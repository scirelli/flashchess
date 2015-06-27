//---------------------------------------------------------
// File: ChessBoard.as
//
// Desc: Keeps track of what's on the chess board.
//
// Notes: 
// @author: Steve Cirelli
//---------------------------------------------------------

////IMPORT////
import ChessPiece;
import flash.geom.Point;

//---------------------------------------------------------
// Main Class Declarations
//---------------------------------------------------------
//---------------------------------------------------------
// Name : ChessBoard (Class)
// Desc : Creates a chess board in memory.
// Constructor: No arguments.
//		If you do not want to create the standard 8x8 board
//		send in the number of columns and rows.
//---------------------------------------------------------
class ChessBoard extends util.Board
{ 
	//----------------------
	// Constants
	//----------------------
	public static var NUM_PIECES = 16; //number of diffrent chess peices per person
	public static var TOT_PIECES = 32; //total chess peices on the board
	public static var NUM_M_COLS = 8;
	public static var NUM_N_ROWS = 8;
	private static var WHITE_PAWN_ROW = 1;
	private static var BLACK_PAWN_ROW = 6;
	
	//----------------------
	// Constructer
	//----------------------
	public function ChessBoard( )
	{
		//A chess board is 8x8 but if the user wants a diffrent size board let them send in
		//the number of col and row
		if( arguments.length == 2  && (!isNaN(arguments[0]) || !isNaN(arguments[1])  ) )
			super( arguments[0], arguments[1] );
		else
			super( 8,8 );
		output( "Board size: " + m_nColumns + "x" + m_nRows );
		m_aMoveList = new Array();
		m_cbPromotion = promo;
		initBoard();
	}
	
	//-------------------------------
	// Public Methods
	//-------------------------------
	
	//---------------------------------------------------------
	// Name: initBoard()
	// Desc: initciate the chess board here
	//---------------------------------------------------------
	public function initBoard(  ):Void
	{
		//clear the board just in case need to reinit that board
		this.clearBoard( null );
		//init the white peices
		var p_array:Array = createPieces( ChessPiece.BLACK );
		//place the black peices
		for( var i:Number = 0; i<NUM_PIECES; i++ )
		{
			ChessPiece(p_array[i]).m = this.posToM(i);
			ChessPiece(p_array[i]).n = this.posToN(i);
			this.addItemToBMN( p_array[i], ChessPiece(p_array[i]).m, ChessPiece(p_array[i]).n );
			output( "Placing: " + ChessPiece(p_array[i]).color + ChessPiece(p_array[i]).type +
				   " " + ChessPiece(p_array[i]).m + "," + ChessPiece(p_array[i]).n );
		}

		//init the black peices
		p_array = createPieces( ChessPiece.WHITE );
		var n:Number = NUM_PIECES - 1;
		//place the black peices
		for( var i:Number = 0; i<NUM_PIECES; i++ )
		{
			ChessPiece(p_array[n-i]).m = this.posToM(i);
			ChessPiece(p_array[n-i]).n = this.posToN(i)+6;
			this.addItemToBMN( p_array[n-i], ChessPiece(p_array[n-i]).m, ChessPiece(p_array[n-i]).n );
			output( "Placing: " + ChessPiece(p_array[n-i]).color + ChessPiece(p_array[n-i]).type +
				   " " + ChessPiece(p_array[n-i]).m + "," + ChessPiece(p_array[n-i]).n );
		}
		printBoard( );
	}
	
	//---------------------------------------------------------
	// Name: printBoard()
	// Desc: prints the chess board as text
	//---------------------------------------------------------
	public function printBoard( ):Void
	{
		var b:String = "";
		var tmp:String  = "";
		
		//Max width 15
		for( var i=0; i<this.getBSize();i++ )
		{
			if( this.getItem( i ) != null )
				tmp = ChessPiece.lookUp(this.getItem( i ).color) + " " + i + " " + ChessPiece.lookUp(this.getItem( i ).type);
			else
				tmp = "      " + i + "       ";
			var l:Number = tmp.length;
			if ( tmp.length < 15 )
			{
				for ( var j:Number = 0; j <= (15 - tmp.length); j++ )
					tmp += " ";
			}
			b += "[" +  tmp + "]\t";

			if ( (i+1) % 8 == 0 )
					b += "\n"
		}
		output( b );
	}
	
	//---------------------------------------------------------
	// Name: movePieceMN()
	// Desc: move a piece
	// Param:
	//	m: from column
	//	n: from row
	//	toM: the to locations column
	//	toN: the to locations row
	// return: true if the piece was moved. false if not
	//---------------------------------------------------------
	public function movePieceMN( m:Number, n:Number, toM:Number, toN:Number ):Boolean
	{
		return movePiece( mnToPos(m,n), mnToPos(toM, toN) );
	}
	
	//---------------------------------------------------------
	// Name: movePiece()
	// Desc: moves a piece
	// Param:
	//	nFrom: from position in the board array
	//	nTo: to position in the board array
	// return: true if the piece was  moved false if not
	//---------------------------------------------------------
	public function movePiece( nFrom:Number, nTo:Number ):Boolean
	{
		var t:ChessPiece = ChessPiece(getItem( nTo ));
		var f:ChessPiece = ChessPiece(getItem( nFrom ));
		var rtn:Boolean = false;
		
		if( f != null && f.color == whosTurn() )//if there is a peice in the from location
		{
			//Check to see if this is a valid regular move
			if ( !validMove( nFrom, nTo ) )
			{
				//it's not so check for a castle or en passant before failing.
				rtn = checkForCastle( nFrom, nTo );
				rtn = Boolean(rtn ^ checkForEnPasant( nFrom, nTo ));//xor the values to make sure that only one can be true
				//return true and skip the normal move proc
				return rtn;
			}
			//it's a valid move.
			//record the move
			m_aMoveList.push( new ChessMove(nFrom, nTo, f.copy(), t.copy()) );
			output(printMoveList());
			//update the board with the new move.
			
			//If this is a pawn and it reaches the oposite side of the board it turns into a queen
			if ( f.type == ChessPiece.PAWN && posToN(nTo) == 7 && f.color == ChessPiece.BLACK )
				f.type = validPromotion(m_cbPromotion());//ChessPiece.QUEEN;
			if ( f.type == ChessPiece.PAWN && posToN(nTo) == 0 && f.color == ChessPiece.WHITE )
				f.type = validPromotion(m_cbPromotion());//ChessPiece.QUEEN;
			
			//Add the item to the 'nTo' posisiton
			addItemToBoard( f, nTo );
			//now clear the spot where it came from
			addItemToBoard( null, nFrom );
			rtn = true;//the add was made
				
			//Check for check validity here if bad move call undo()
			if ( putIntoCheck( f.color ) )//if the move puts you into check undo it
			{
				//call undo and return false.
				output("That move put you into check");
				printBoard();
				undo();
				printBoard();
				rtn = false;
			}
		}
		
		return rtn;
	}
	
	//---------------------------------------------------------
	// Func: undo()
	// Desc: allows the user to undo the last move as far back
	//	as they wish to go.
	// Todo: make it handle en passent and castle
	//---------------------------------------------------------
	public function undo():Void
	{
		var mv:ChessMove = ChessMove(m_aMoveList.pop());
		if( mv )
		{//if I get a move process it
			switch( mv.m_nMoveType )
			{
				case ChessMove.REG_MOVE:
				{
					addItemToBoard(mv.m_cpPiece, mv.m_nPos);//add the piece back to it's starting position
					addItemToBoard(mv.m_cpKill, mv.m_nDest);//Clear or add the piece that was killed
					break;
				}
			
				case ChessMove.EN_PASSANT:
				{
					addItemToBoard(mv.m_cpPiece, mv.m_nPos);//add the piece back to it's starting position
					addItemToBoard(mv.m_cpKill, mv.m_nDest);//Clear or add the piece that was killed
					var p:Point = new Point(this.posToM(mv.m_nDest), this.posToN(mv.m_nDest) );
					var dir = mv.m_cpPiece.color == ChessPiece.WHITE?-1:1;
					addItemToBoard(null, this.mnToPos(p.x, p.y + dir) );//Clear the attackers ghost
					output('Enpasant x: ' + p.x + ', y: ' + p.y + ' dir: ' + dir);
					break;
				}
				
				case ChessMove.CASTLE:
				{
					addItemToBoard(mv.m_cpPiece, mv.m_nPos);//add the piece back to it's starting position
					addItemToBoard(mv.m_cpKill, mv.m_nDest);//Clear or add the piece that was killed
					mv = ChessMove(m_aMoveList.pop());
					addItemToBoard(mv.m_cpPiece, mv.m_nPos);//add the piece back to it's starting position
					addItemToBoard(mv.m_cpKill, mv.m_nDest);//Clear or add the piece that was killed
					break;
				}
				default:
				{
					m_aMoveList.push(mv);
					throw new Error("Not a move that can be undone." + mv.toString());
				}
			}
		}
	}
	
	//---------------------------------------------------------
	// Func: parseMoveList()
	// Desc:
	// Param:
	//	moveList: string, a list of moves in algebraic chess 
	//		notation.
	// return: number, -1 if list ran successfully. The 
	//		position of failure if not.
	// Notes: Chess algebraic notation is- 
	//	piece moved - file where it moved - rank where it moved
	//	example: Qg5, means queen moves to square g5.
	//---------------------------------------------------------
	public function parseMoveList( moveList:String ):Number
	{
		//parseInt()//returns NaN if not a number
		for ( var i:Number = 0, c:String=moveList.charAt(i); i < moveList.length; i++ )
		{
			switch( c.toUpperCase() )
			{
				case "K" :
				case "N" :
				case "Q" :
				case "B" :
				case "R" :
				{
					//Piece found
					c = moveList.charAt( ++i );//get the next char
					if ( isNaN(parseInt(c)) == false )
					{//rank
						
					}
					break;
				}
				
			}
			
		}
		return -1;
	}
	
	//---------------------------------------------------------
	// Func: getWhosTurn()
	// Desc: returns true if whites turn false if its blacks
	//---------------------------------------------------------
	public function getWhosTurn():Boolean
	{
		if ( whosTurn() == ChessPiece.WHITE )
			return true;
		else
			return false;
	}
	
	//---------------------------------------------------------
	// Func: moveList()
	// Desc: returns the move list array.
	//---------------------------------------------------------
	public function get moveList():Array
	{
		return m_aMoveList;
	}
	
	//---------------------------------------------------------
	// Func: setPawnPromoFunc()
	// Desc: attaches the pawn promtion func to the func var
	//---------------------------------------------------------
	public function setPawnPromoFunc( f:Function ):Boolean
	{
		m_cbPromotion = f;
		return true;
	}
	
	//---------------------------------------------------------
	// Func: countPiece()
	// Desc: returns the number of peices of some type that are
	//		on the board.
	// Params:
	//	t: Number, peice type
	//	c: Number: color
	// Return: number of peice of type t and color c
	//---------------------------------------------------------
	public function countPiece( t:Number, c:Number ):Number
	{
		var count:Number = 0;
		for ( var i:Number = 0, p:ChessPiece=null; i < this.m_Board_array.length; i++ )
		{
			p = ChessPiece( m_Board_array[i] );
			if ( t == p.type && c == p.color )
				count++;
		}
		return count;
	}
	
	//---------------------------------------------------------
	// Func: resetBoard()
	// Desc: Resets the board
	//---------------------------------------------------------
	public function resetBoard():Void
	{
		initBoard();
		clearMoveList();
	}
	
	//---------------------------------------------------------
	// Func: clearMoveList()
	// Desc: clears the move list
	//---------------------------------------------------------
	public function clearMoveList():Void
	{
		for ( var i:Number = 0; i < m_aMoveList.length; i++ )
			m_aMoveList.pop();//remove everything from the list, encase anything else is pointing to it
		m_aMoveList = new Array(); //set the pointer to null
	}
	
	//-------------------------------
	// Private Methods
	//-------------------------------
	
	//---------------------------------------------------------
	// Func: validPawnPromotion()
	// Desc: 
	//---------------------------------------------------------
	private function validPromotion( p:Number  ):Number
	{ 
		switch (p)
		{
			case ChessPiece.QUEEN:
			case ChessPiece.KNIGHT:
			case ChessPiece.BISHOP:
			case ChessPiece.ROOK:
			{
				return p;
			}
			default:
				return ChessPiece.QUEEN;
		}
		return ChessPiece.NONE;
	}
	
	//---------------------------------------------------------
	// Name: craatePieces()
	// Desc: create all the Chess Pieces of a color
	// Params:
	//	color: the color of the pieces
	// Returns: an array of peices of color color
	//---------------------------------------------------------
	private function createPieces( color:Number ):Array
	{
		var p_array:Array = new Array();
		var t_array:Array = null;
		if ( color == ChessPiece.WHITE )
		{
			t_array = new Array( ChessPiece.ROOK,   ChessPiece.KNIGHT, ChessPiece.BISHOP,
										   ChessPiece.KING,   ChessPiece.QUEEN, 
										   ChessPiece.BISHOP, ChessPiece.KNIGHT, ChessPiece.ROOK );
		}
		else
		{
			t_array = new Array( ChessPiece.ROOK,   ChessPiece.KNIGHT, ChessPiece.BISHOP,
										   ChessPiece.QUEEN,  ChessPiece.KING,
										   ChessPiece.BISHOP, ChessPiece.KNIGHT, ChessPiece.ROOK );
		}
		//Create power peices
		for( var i:Number = 0; i<t_array.length; i++ )
		{
			p_array[i] = new ChessPiece( t_array[i], color, 0, 0, false );
			output( "Creating " + i + ": " +  ChessPiece.lookUp(p_array[i].color) + " " + ChessPiece.lookUp(p_array[i].type) );
		}
		//Create pawns
		for( var i:Number = t_array.length; i<NUM_PIECES; i++ )
		{
			p_array[i] = new ChessPiece( ChessPiece.PAWN, color, 0, 0, false );
			output( "Creating " + i + ": " +  ChessPiece.lookUp(p_array[i].color) + " " + ChessPiece.lookUp(p_array[i].type) );
		}
		return p_array;
	}
	
	//---------------------------------------------------------
	// Func: validSpecialMove()
	// Desc: Checks for castle and en pasunt move.
	// Params: 
	//	from: the from position
	//	to: move to position
	//---------------------------------------------------------
	private function validSpecialMove( from:Number, to:Number ):Boolean
	{
		var fromPiece:ChessPiece = ChessPiece( this.getItem(from) ),
			toPiece:ChessPiece = ChessPiece( this.getItem(to) );
		var p:Point = new Point(this.posToM( from ), this.posToN( from )),
			tmpp:Point = new Point(p.x, p.y);
			
		//check for castle
		return false;
	}
	
	//---------------------------------------------------------
	// Func: validMoveMN()
	// Desc: Checks to make sure that the move is a valid move
	// Params: 
	//	m: colomn from
	//	n: row from
	//	m2: column to
	//	n2: row to
	//---------------------------------------------------------
	private function validMoveMN( m:Number, n:Number, m2:Number, n2:Number ):Boolean
	{
		return validMove( mnToPos(m, n), mnToPos(m2, n2) );
	}
	
	//---------------------------------------------------------
	// Func: validMove()
	// Desc: Checks to make sure that the move is a valid move
	// Params: 
	//	from: from
	//	to: from
	//---------------------------------------------------------
	private function validMove( from:Number, to:Number ):Boolean
	{
		var fp:ChessPiece = ChessPiece( getItem(from));
		var validPos:Array = allowedPositions( fp, from );
		
		for ( var i:Number = 0; i < validPos.length; i++ )
		{
			if ( to == validPos[i] )
				return true;
		}
		return false;
	}
	
	//---------------------------------------------------------
	// Func: allowedPositions()
	// Desc: returns all allowed positions for a given piece
	// Params:
	//	piece: the peice to move
	//	pos: the peices locatoin
	//---------------------------------------------------------
	private function allowedPositions( piece:ChessPiece, pos:Number ):Array
	{
		var rtn:Array = new Array();
		var p:Point = new Point(this.posToM( pos ), this.posToN( pos ));
		var tmpp:Point = new Point(p.x,p.y);
		
		//Notes: White on top
		switch( piece.type )
		{
			case ChessPiece.PAWN :
			{ 
				//1. Pawns can not move backwards.
				//2. Pawns can only move one space forward, unless it's the first move.
				//3. Pawns can only kill on a forward moving angle.
				if ( piece.color == ChessPiece.BLACK )
				{
					output("Black pawn");
					tmpp.x = p.x; tmpp.y = p.y + 1;
					if ( boundsCheck( tmpp.x,tmpp.y ) && !this.getItemMN(tmpp.x, tmpp.y) ) //in bounds and no piece pos + 1
					{
						rtn.push(this.mnToPos(tmpp.x, tmpp.y)); //rtn = rtn | (1 << valpos);
						
						tmpp.x = p.x; tmpp.y = p.y + 2;
						if ( p.y == WHITE_PAWN_ROW && !this.getItemMN(tmpp.x, tmpp.y) ) //no piece in second spot.1st line 2 space move allowed.
							rtn.push(this.mnToPos(tmpp.x, tmpp.y)); //rtn = rtn | (1 << valpos);
					}
					tmpp.x = p.x + 1; tmpp.y = p.y + 1;//down right
					var tmpPiece:ChessPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
					if( boundsCheck(tmpp.x,tmpp.y) && tmpPiece != null && tmpPiece.color != piece.color )
						rtn.push(this.mnToPos(tmpp.x, tmpp.y)); //rtn = rtn | (1 << valpos);
					tmpp.x = p.x - 1; tmpp.y = p.y + 1;//down left
					tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
					if( boundsCheck(tmpp.x,tmpp.y) && tmpPiece != null && tmpPiece.color != piece.color )
						rtn.push(this.mnToPos(tmpp.x, tmpp.y)); //rtn = rtn | (1 << valpos);
				}
				else
				{
					output( "White pawn" );		
					tmpp.x = p.x; tmpp.y = p.y - 1;
					if ( boundsCheck( tmpp.x,tmpp.y ) && !this.getItemMN(tmpp.x, tmpp.y) ) //no piece in first spot
					{
						rtn.push(this.mnToPos(tmpp.x, tmpp.y)); //rtn = rtn | (1 << valpos);
						
						tmpp.x = p.x; tmpp.y = p.y - 2;
						if ( p.y == BLACK_PAWN_ROW && !this.getItemMN(tmpp.x, tmpp.y) ) //no piece in second spot
							rtn.push(this.mnToPos(tmpp.x, tmpp.y)); //rtn = rtn | (1 << valpos);
					}
					tmpp.x = p.x + 1; tmpp.y = p.y - 1; //up left
					var tmpPiece:ChessPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
					if( boundsCheck(tmpp.x,tmpp.y) && tmpPiece != null && tmpPiece.color != piece.color  )
						rtn.push(this.mnToPos(tmpp.x, tmpp.y)); //rtn = rtn | (1 << valpos);
					tmpp.x = p.x - 1; tmpp.y = p.y - 1;//up right
					tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
					if( boundsCheck(tmpp.x,tmpp.y) && tmpPiece != null && tmpPiece.color != piece.color  )
						rtn.push(this.mnToPos(tmpp.x, tmpp.y)); //rtn = rtn | (1 << valpos);
				}
				break;
			}
			
			case ChessPiece.ROOK :
			{ 
				output("Rook");
				rtn = validHozVertPos( piece, p );
				break;
			}
			
			case ChessPiece.KNIGHT :
			{
				output("Knight");
				
				tmpp.x = p.x - 1; tmpp.y = p.y + 2;
				var tmpPiece:ChessPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
				if( boundsCheck( tmpp.x, tmpp.y ) && (tmpPiece == null || tmpPiece != null && tmpPiece.color != piece.color  ) )
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x + 1; tmpp.y = p.y + 2;
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
				if( boundsCheck( tmpp.x, tmpp.y ) && (tmpPiece == null || tmpPiece != null && tmpPiece.color != piece.color  ) )
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x - 1; tmpp.y = p.y - 2;
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
				if( boundsCheck( tmpp.x, tmpp.y ) && (tmpPiece == null || tmpPiece != null && tmpPiece.color != piece.color  ) )
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x + 1; tmpp.y = p.y - 2;
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
				if( boundsCheck( tmpp.x, tmpp.y ) && (tmpPiece == null || tmpPiece != null && tmpPiece.color != piece.color  ) )
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x + 2; tmpp.y = p.y - 1;
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
				if( boundsCheck( tmpp.x, tmpp.y ) && (tmpPiece == null || tmpPiece != null && tmpPiece.color != piece.color  ) )
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x +2; tmpp.y = p.y + 1;
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
				if( boundsCheck( tmpp.x, tmpp.y ) && (tmpPiece == null || tmpPiece != null && tmpPiece.color != piece.color  ) )
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x - 2; tmpp.y = p.y -1;
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
				if( boundsCheck( tmpp.x, tmpp.y ) && (tmpPiece == null || tmpPiece != null && tmpPiece.color != piece.color  ) )
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x - 2; tmpp.y = p.y + 1;
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));
				if( boundsCheck( tmpp.x, tmpp.y ) && (tmpPiece == null || tmpPiece != null && tmpPiece.color != piece.color  ) )
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));				
				break;
			}
			
			case ChessPiece.BISHOP :
			{
				output("Bishop")
				rtn = validAngledPos( piece, p );
				break;
			}
			
			case ChessPiece.QUEEN :
			{
				output("Queen");
				rtn = validHozVertPos( piece, p ).concat(validAngledPos( piece, p ));
				/*
				for ( var i:Number = p.x+1; i < 8; i++ )//right
					rtn.push( this.mnToPos(i,p.y) );
				for ( var i:Number = p.x-1; i >= 0; i-- ) //left
					rtn.push( this.mnToPos(i, p.y) );
				for ( var i:Number = p.y+1; i < 8; i++ )
					rtn.push( this.mnToPos(p.x, i) );
				for ( var i:Number = p.y-1; i >= 0; i-- )
					rtn.push( this.mnToPos(p.x, i) );
				//Bishop
				for ( var i:Number = 1; this.boundsCheck(p.x+i, p.y+i); i++ )//down right
					rtn.push(this.mnToPos(p.x+i, p.y+i));
				for ( var i:Number = 1; this.boundsCheck(p.x-i,p.y-i); i++ )//up left
					rtn.push(this.mnToPos(p.x-i,p.y-i));
				for ( var i:Number = 1; this.boundsCheck(p.x-i,p.y+i); i++ )//down left
					rtn.push(this.mnToPos(p.x-i,p.y+i));
				for ( var i:Number = 1; this.boundsCheck(p.x+i,p.y-i); i++ )//up right
					rtn.push(this.mnToPos(p.x + i, p.y - i));
				*/
				break;
			}
			
			case ChessPiece.KING :
			{
				output("*King*");
				
				tmpp.x = p.x + 1; tmpp.y = p.y;//right
				var tmpPiece:ChessPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));				
				if ( boundsCheck(tmpp.x, tmpp.y) && (tmpPiece == null || (tmpPiece != null ) && piece.color != tmpPiece.color ))
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x - 1; tmpp.y = p.y;//left
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));				
				if ( boundsCheck(tmpp.x, tmpp.y) && (tmpPiece == null || (tmpPiece != null ) && piece.color != tmpPiece.color ))
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x; tmpp.y = p.y+1;//down
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));				
				if ( boundsCheck(tmpp.x, tmpp.y) && (tmpPiece == null || (tmpPiece != null ) && piece.color != tmpPiece.color ))
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x; tmpp.y = p.y-1;//up
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));				
				if ( boundsCheck(tmpp.x, tmpp.y) && (tmpPiece == null || (tmpPiece != null ) && piece.color != tmpPiece.color ))
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x + 1; tmpp.y = p.y+1;//down right
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));				
				if ( boundsCheck(tmpp.x, tmpp.y) && (tmpPiece == null || (tmpPiece != null ) && piece.color != tmpPiece.color ))
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x - 1; tmpp.y = p.y-1;//up left
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));				
				if ( boundsCheck(tmpp.x, tmpp.y) && (tmpPiece == null || (tmpPiece != null ) && piece.color != tmpPiece.color ))
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x + 1; tmpp.y = p.y-1;//up right
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));				
				if ( boundsCheck(tmpp.x, tmpp.y) && (tmpPiece == null || (tmpPiece != null ) && piece.color != tmpPiece.color ))
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				tmpp.x = p.x - 1; tmpp.y = p.y+1;//down left
				tmpPiece = ChessPiece(this.getItemMN(tmpp.x, tmpp.y));				
				if ( boundsCheck(tmpp.x, tmpp.y) && (tmpPiece == null || (tmpPiece != null ) && piece.color != tmpPiece.color ))
					rtn.push(this.mnToPos(tmpp.x, tmpp.y));
				break;
			}
		}
		
		output( "Allowed positions for " + ChessPiece.lookUp(piece.type) + ": " + String( rtn ) );
		return rtn;
	}
	
	//---------------------------------------------------------
	// Func: validHozVertPos()
	// Desc: returns an array of valid horizontal and vertical
	//	positions for a peice at position p;
	// Params:
	//	piece: ChessPiece, a chess piece.
	//	p: Point, the position of the piece.
	//---------------------------------------------------------
	private function validHozVertPos( piece:ChessPiece, p:Point ):Array
	{
		var rtn:Array = new Array();
		
		for ( var i:Number = p.x + 1; i < 8; i++ )//right
		{
			var tmpPiece:ChessPiece = ChessPiece(this.getItemMN(i, p.y));
			if ( tmpPiece == null)
				rtn.push( this.mnToPos(i, p.y) );
			else
				if (tmpPiece != null  && piece.color != tmpPiece.color ) 
				{
					rtn.push( this.mnToPos(i, p.y) );
					break;
				}
				else
					break;
		}
		for ( var i:Number = p.x - 1; i >= 0; i-- ) //left
		{
			var tmpPiece:ChessPiece = ChessPiece(this.getItemMN( i, p.y));
			if ( tmpPiece == null)
				rtn.push( this.mnToPos(i, p.y) );
			else
				if (tmpPiece != null  && piece.color != tmpPiece.color ) 
				{
					rtn.push( this.mnToPos(i, p.y) );
					break;
				}
				else
					break;
		}
		for ( var i:Number = p.y + 1; i < 8; i++ )//down
		{
			var tmpPiece:ChessPiece = ChessPiece(this.getItemMN(p.x, i));
			if ( tmpPiece == null )
				rtn.push( this.mnToPos(p.x, i) );
			else
				if (piece.color != tmpPiece.color )
				{
					rtn.push( this.mnToPos(p.x, i) );
					break;
				}
				else
					break;
		}
		for ( var i:Number = p.y-1; i >= 0; i-- )//up
		{
			var tmpPiece:ChessPiece = ChessPiece(this.getItemMN(p.x, i));
			if ( tmpPiece == null )
				rtn.push( this.mnToPos(p.x, i) );
			else
				if (piece.color != tmpPiece.color )
				{
					rtn.push( this.mnToPos(p.x, i) );
					break;
				}
				else
					break;
		}
			
		return rtn;
	}
	
	//---------------------------------------------------------
	// Func: validAngledPos()
	// Desc: returns an array of valid angled positions for
	//	pieces like rook and queen for a peice at position p;
	// Params:
	//	piece: ChessPiece, a chess piece.
	//	p: Point, the position of the piece.
	//---------------------------------------------------------
	private function validAngledPos( piece:ChessPiece, p:Point ):Array
	{
		var rtn:Array = new Array();
		
		for ( var i:Number = 1; this.boundsCheck(p.x + i, p.y + i); i++ )//down right
		{
			var tmpPiece:ChessPiece = ChessPiece(this.getItemMN(p.x+i, p.y+i));
			if( tmpPiece == null )
				rtn.push( this.mnToPos(p.x + i, p.y + i) );
			else 
				if ( piece.color != tmpPiece.color )
				{
					rtn.push( this.mnToPos(p.x + i, p.y + i) );
					break;
				}
				else
					break;
		}
		for ( var i:Number = 1; this.boundsCheck(p.x - i, p.y - i); i++ )//up left
		{
			var tmpPiece:ChessPiece = ChessPiece(this.getItemMN(p.x-i, p.y-i));
			if( tmpPiece == null )
				rtn.push( this.mnToPos(p.x - i, p.y - i) );
			else
				if (piece.color != tmpPiece.color )
				{
					rtn.push( this.mnToPos(p.x - i, p.y - i) );
					break;
				}
				else
					break;
		}
		for ( var i:Number = 1; this.boundsCheck(p.x - i, p.y + i); i++ )//down left
		{
			var tmpPiece:ChessPiece = ChessPiece(this.getItemMN(p.x-i, p.y+i));
			if( tmpPiece == null)
				rtn.push( this.mnToPos(p.x - i, p.y + i) );
			else
				if (piece.color != tmpPiece.color )
				{
					rtn.push( this.mnToPos(p.x - i, p.y + i) );
					break;
				}
				else
					break;
		}
		for ( var i:Number = 1; this.boundsCheck(p.x + i, p.y - i); i++ )//up right
		{
			var tmpPiece:ChessPiece = ChessPiece(this.getItemMN(p.x+i, p.y-i));
			if( tmpPiece == null )
				rtn.push( this.mnToPos(p.x + i, p.y - i) );
			else
				if (piece.color != tmpPiece.color )
				{
					rtn.push( this.mnToPos(p.x + i, p.y - i) );
					break;
				}
				else
					break;
		}
		return rtn;
	}
	
	//---------------------------------------------------------
	// Func: checkNotPutIntoCheck()
	// Desc: checks to see if a king is in check.
	// Param:
	//	pieceColor: color of the piece that was moved
	// Note: This func needs to be called after the piece has 
	//	been moved. So the move should be a valid move until 
	//	this point where we check to make sure the move does 
	//	not put it's king into check.
	//---------------------------------------------------------
	private function putIntoCheck( pieceColor:Number ):Boolean
	{
		var kingPos:Number = -1;
		
		for ( var i:Number = 0, k:ChessPiece; i < m_Board_array.length; i++ )
		{ //find players king
			k = ChessPiece( m_Board_array[i] );
			//Find a king that is the same color as the piece being moved.
			if ( k.type == ChessPiece.KING && k.color == pieceColor )
				kingPos = i;
		}
		//loop through all peices on board
		for ( var i:Number = 0; i < this.m_Board_array.length; i++ )
		{
			//if the square isn't enmpty and the piece is of oppostie color then the piece being moved
			if ( this.m_Board_array[i] != null && ChessPiece(this.m_Board_array[i]).color != pieceColor )
			{//so if there is a piece here and the piece is the oposing team try to move it to the kings square.
				if ( validMove( i, kingPos ) ) 
					return true;
			}
		}
		return false;
	}
	
	//---------------------------------------------------------
	// Func: checkForCastle()
	// Desc: checks to see if the move you made is a castle
	// Param:
	//	pos: current pos of the piece
	//	dest: where to move the piece to
	// return: Boolean, true if the move is a castle type move
	//	false otherwise.
	// Notes:
	//	Castle Criteria:
	//	1. King and rook could not have moved *
	//	2. Can not castle through check.
	//	3. Can not castle through other pieces.
	//	4. Move king over two then rook moves to other side of king
	//	5. 
	//---------------------------------------------------------
	private function checkForCastle( pos:Number, dest:Number ):Boolean
	{
		var p:ChessPiece = ChessPiece(getItem( pos ));
		var d:ChessPiece = ChessPiece(getItem( dest ));
		var rtn:Boolean = false;
		
		//first things first, make sure it's a king that is being moved, check to make sure dest is empty, and it's moving two spaces
		if ( p.type == ChessPiece.KING && Math.abs( dest-pos) == 2 && d == null )
		{
			//Now check to see if the king has moved at all.
			for ( var i:Number = 0,t:ChessPiece; i < m_aMoveList.length; i++ )
			{
				t = ChessMove(m_aMoveList[i]).m_cpPiece;
				if ( t.type == ChessPiece.KING && t.color == p.color )
					return false;//if he moved then you can't castle
			}
			//The king hasn't moved.
			//Check to see if the rook has moved.
			var rookPos:Number = -1; 
			//figure out what rook will move/should not have moved
			if ( p.color == ChessPiece.WHITE )
				rookPos = dest > pos ? 63:56;//is the king moving left or right.
			else
				rookPos = dest > pos ? 7:0;
			//search for the rook in the move list
			for ( var i:Number = 0,t:ChessPiece; i < m_aMoveList.length; i++ )
			{
				t = ChessMove(m_aMoveList[i]).m_cpPiece;//get a peice
				//check to make sure its the right color and started in the correct spot.
				if ( t.type == ChessPiece.ROOK && t.color == p.color && ChessMove(m_aMoveList[i]).m_nPos == rookPos)
					return false;//if he moved then you can't castle
			}
			//Rook hasn't moved
			//So both king and rook have not moved
			var dir:Number = dest > pos ? 1: -1;//figure out what direction the king should move
			//try to move the king twice in that direction
			var v:Boolean = validMove( pos, pos + dir );
			if (v)
			{
				addItemToBoard( getItem(pos), pos +dir );//do the move
				addItemToBoard( null, pos );
				if ( putIntoCheck( p.color ) ) 
				{
					addItemToBoard( getItem(pos + dir), pos );//undo the move
					addItemToBoard( null, pos+dir );//undo the move
					return false;
				}
				v = v && validMove( pos + dir, pos + dir + dir );
				//If the king was able to move, move the rook
				if ( v )
				{
					addItemToBoard( getItem(pos+dir), pos +dir+dir );//move the king
					addItemToBoard( null, pos+dir );
					if ( putIntoCheck( p.color ) ) 
					{
						addItemToBoard( getItem(pos+dir+dir), pos +dir );//undo it
						addItemToBoard( null, pos+dir+dir );
						return false;
					}
					//if the king could finally move then add it to the move list
					m_aMoveList.push( new ChessMove(pos, pos+dir+dir, p.copy(), null, ChessMove.CASTLE) );//add the move to the move list
					var rp:ChessPiece = ChessPiece(getItem(rookPos));//get the rook
					addItemToBoard( rp, pos +dir );//do the move
					addItemToBoard( null, rookPos );//
					m_aMoveList.push( new ChessMove(rookPos, pos+dir, rp.copy(), null, ChessMove.CASTLE) );//add the move to the move list
					rtn = true;
				}
			}
		}
		
		return rtn;
	}
	
	//---------------------------------------------------------
	// Func: checkForEnPasant()
	// Desc: checks to see if the move was an en pasant move
	// Param:
	// 	pos: current pos of the piece
	//	dest: where to move the piece to
	// return: Boolean, true if the move is a en pasant type 
	//		move.
	// Notes: En pasant rules
	//		1. When a pawn is on the 4th or 5th rank and 
	//			opposite color pawn makes its first move of 2
	//			ranks and passes the pawn. The passed pawn
	//			may take the passing pawn by moving along a
	//			normal attack rounte.
	//---------------------------------------------------------
	private function checkForEnPasant( pos:Number, dest:Number ):Boolean
	{
		var p:ChessPiece = ChessPiece(getItem( pos ));
		var d:ChessPiece = ChessPiece(getItem( dest ));
		var rtn:Boolean = false;
		
		//first make sure it's a pawn that is moving
		if ( p.type == ChessPiece.PAWN )
		{
			var dirY:Number = p.color==ChessPiece.WHITE?-1:1;//figure out what direction the attacking pawn will take
			//get the only two valid places this pawn can move for an en pasant
			var p1:Number = this.mnToPos(this.posToM( pos ) - 1, this.posToN(pos) + dirY);
			var p2:Number = this.mnToPos(this.posToM( pos ) + 1, this.posToN(pos) + dirY);
			//Is it's destination a valid move for an en pasant
			if ( p1 == dest || p2 == dest )
			{
				//get the peice that it passed
				var passedcpPos:Number = this.mnToPos( this.posToM( dest ), this.posToN( pos ) );
				var passedcp:ChessPiece = ChessPiece(this.getItem( passedcpPos ));
				//make sure this piece is a pawn and of the correct color which is not the color of the peice that is moving
				if ( passedcp != null && passedcp.type == ChessPiece.PAWN && passedcp.color != p.color)
				{
					//check to make sure that the passed pawn only moved once and it moved two ranks
					var correctCP:Boolean = false;
					for ( var i:Number = 0,t:ChessPiece; i < m_aMoveList.length; i++ )
					{//so what you have to do is check it's from/to positions. It should have moved two ranks
						//get a move from the list
						var passedPawnMV:ChessMove = ChessMove(m_aMoveList[i]);
						output( "A chess piece of color '" + ChessPiece.lookUpColor(passedPawnMV.m_cpPiece.color) + "', type '" + ChessPiece.lookUp(passedPawnMV.m_cpPiece.type) + 
								"' with an initial position of '" + passedPawnMV.m_nPos +  "', a destination of '" + passedPawnMV.m_nDest + 
								"' is being compared to the destination of '" + this.mnToPos(passedcp.m, passedcp.n) + "' and initial position of '" +
								this.mnToPos(passedcp.m, passedcp.n-(dirY*2)) + "'");
						if ( 
							 passedPawnMV.m_cpPiece.type == ChessPiece.PAWN && passedPawnMV.m_nDest == this.mnToPos(passedcp.m, passedcp.n-(dirY*2)) &&
						     passedPawnMV.m_nPos == this.mnToPos(passedcp.m, passedcp.n)
						   )
						{
							correctCP = true;
							break;	
						}
					}
					if ( correctCP )
					{//Ok it's an enpasant now move the pieces
						output("This move was an en pasant.");
						addItemToBoard( getItem(pos), dest );//move the pawn
						m_aMoveList.push( new ChessMove(pos, passedcpPos, p.copy(), passedcp.copy(), ChessMove.EN_PASSANT) );//add the move to the move list
						addItemToBoard( null, pos );//Now delete it at its prev pos
						addItemToBoard( null, passedcpPos );//remove the piece that was passed
						rtn = true;
					}
					else { this.output("checkForEnPasant(): Can't take the pawn bc it moved more than once"); }
				}else { output("checkForEnPasant():The passed pawn is not the right color or is not a pawn"); }
			}else { output("checkForEnPasant(): The pawn is not moving correctly for enpasant"); }
		}else { output("checkForEnPasant(): not a pawn can't be en pasant move.");  }
		
		return rtn;
	}
	
	//---------------------------------------------------------
	// Func: promo()
	// Desc: returns the type of peice a pawn should turn into
	//	after promotion
	//---------------------------------------------------------
	private function promo():Number
	{
		return ChessPiece.QUEEN;
	}
	
	//---------------------------------------------------------
	// Func: whosTurn()
	// desc: returns which peices turn it is
	//---------------------------------------------------------
	private function whosTurn():Number
	{
		if ( m_aMoveList.length == 0 ) return ChessPiece.WHITE;
		
		if ( ChessMove(m_aMoveList[m_aMoveList.length-1]).m_cpPiece.color == ChessPiece.WHITE )
			return ChessPiece.BLACK;
		else
			return ChessPiece.WHITE;
	}
	
	//---------------------------------------------------------
	// Func: printMoveList()
	// Desc: prints the move list as a string
	//---------------------------------------------------------
	private function printMoveList():String
	{
		var rtn:String = "";
		
		for ( var i:Number = 0, mv:ChessMove; i < m_aMoveList.length; i++ )
		{
			mv = m_aMoveList[i];
			rtn += "Move[" + i +"]: \n\t" +
				   ChessPiece.lookUp(mv.m_cpPiece.color) + " " + ChessPiece.lookUp(mv.m_cpPiece.type) + " from pos: " + mv.m_nPos + 
				   " moved to dest: " + mv.m_nDest + " and took: " +
				   ChessPiece.lookUp(mv.m_cpKill.color)  + " " + ChessPiece.lookUp(mv.m_cpKill.type)  + "\n\n"
		}
		return rtn;
	}
	
	//------------------------------
	// Public Member Variables
	//------------------------------
		
	//-------------------------------
	// Private Member Variables
	//-------------------------------
	private var m_aMoveList:Array;
	private var m_bTurn:Boolean = true;
	private var m_cbPromotion:Function = null;
};