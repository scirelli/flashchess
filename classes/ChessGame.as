//---------------------------------------------------------
// File: ChessGame.as
//
// Desc: The chess game class
//
// Notes: 
// @author: Steve Cirelli
//---------------------------------------------------------

////IMPORTS///////
import ChessBoard;
import ChessPiece;
import ChessMove;
import util.RegExp;
import players.Human;
import util.EnumeratedType;
import flash.geom.Point;
import mx.controls.Alert;

//---------------------------------------------------------
// Main Class Declarations
//---------------------------------------------------------
//---------------------------------------------------------
// Name : ChessGame (Class)
// Desc : 
//---------------------------------------------------------
class ChessGame extends gameapp.CGameApp
{
	//---------------------------
	// Constants
	//---------------------------
	public static var NUM_ROWS:Number = 8;
	public static var NUM_COLS:Number = 8;
	public static var GRID_X:Number = 24.5;//32
	public static var GRID_Y:Number = 38.5;//46
	public static var GRID_WIDTH:Number  = 288;
	public static var GRID_HEIGHT:Number = 288;
	public static var BLOCK_WIDTH:Number  = GRID_WIDTH/NUM_COLS;
	public static var BLOCK_HEIGHT:Number = GRID_HEIGHT/NUM_ROWS;
	public static var PIECE_TRAY_X:Number = 359.5;
	public static var PIECE_TRAY_Y:Number = 153.0;
	private static var W_CHIP_X = 316;
	private static var W_CHIP_Y = 342;
	private static var B_CHIP_X = W_CHIP_X;
	private static var B_CHIP_Y = 14;
	
	//---------------------------
	// Constructor
	//---------------------------
	public function ChessGame( mcMain:MovieClip )
	{
		super( );
		m_mcMain = mcMain;
		Mouse.addListener( this );
		m_aCaptureLblPos = new Array( {p:new Point(388.9, 159.0), n:"Wking_dtxt", t:ChessPiece.KING, c:ChessPiece.WHITE},    {p:new Point(388.9, 174.3), n:"WQueen_dtxt", t:ChessPiece.QUEEN, c:ChessPiece.WHITE},   {p:new Point(388.9, 188),n:"WBishop_dtxt", t:ChessPiece.BISHOP, c:ChessPiece.WHITE},
									  {p:new Point(388.9, 205.2), n:"Wknight_dtxt", t:ChessPiece.KNIGHT, c:ChessPiece.WHITE}, {p:new Point(388.9, 220.4), n:"WRook_dtxt", t:ChessPiece.ROOK, c:ChessPiece.WHITE},	 {p:new Point(388.9, 237), n:"WPawn_dtxt", t:ChessPiece.PAWN, c:ChessPiece.WHITE}, 
									  {p:new Point(403.6, 159.0), n:"Bking_dtxt", t:ChessPiece.KING, c:ChessPiece.BLACK},     {p:new Point(403.6, 174.3), n:"BQueen_dtxt", t:ChessPiece.QUEEN, c:ChessPiece.BLACK},  {p:new Point(403.6, 188), n:"BBishop_dtxt", t:ChessPiece.BISHOP, c:ChessPiece.BLACK}, 
									  {p:new Point(403.6, 205.2), n:"BKnight_dtxt", t:ChessPiece.KNIGHT, c:ChessPiece.BLACK}, {p:new Point(403.6, 220.4), n:"BRook_dtxt", t:ChessPiece.ROOK, c:ChessPiece.BLACK},	 {p:new Point(403.6, 237), n:"BPawn_dtxt", t:ChessPiece.PAWN, c:ChessPiece.BLACK}
									);
		m_eCaptureLblIndex = new EnumeratedType( "WKing", "WQueen", "WBishop", "WKnight", "wPawn", "BKing", "BQueen", "BBishop", "BKnight", "BPawn");
		initGame( );
	}
	
	//---------------------------
	// Public Methods
	//---------------------------
	
	//-----------------------------------------------------
	// Name: beginGame()
	// Desc: 
	//-----------------------------------------------------
	public function beginGame( ):Void
	{
		//do intro etc
	}
	
	//-----------------------------------------------------
	// Name: frameAdvance()
	// Desc: exe each frame.
	//-----------------------------------------------------
	public function frameAdvance( ):Boolean 
	{ 
		processLoadTxtInput( );
		processInput( );
		
		if ( m_chessBoard.getWhosTurn() )
			placeChip( ChessPiece.WHITE );
		else
			placeChip( ChessPiece.BLACK );
		
		//output( "col= " + getCellCol(m_mcMain._xmouse )  );
		//output( "row= " + getCellRow( m_mcMain._ymouse ) );
		return false; 
	}
	
	public function rot( deg:Number ):Void
	{
		m_piecesContainer_mc._rotation += deg;
	}
	
	//-----------------------------------------------------
	// Name: flipBoard()
	// Desc: 
	//-----------------------------------------------------
	public function onFlip():Void
	{
		//invert the mouse coordinates
		output("Flipping board.");
	}

	//-----------------------------------------------------
	// Name: onMouseDown()
	// Desc: what to do when the mouse button is pressed
	//-----------------------------------------------------
	public function onMouseDown( ):Void
	{
		var m:Number = getCellCol( m_mcMain._xmouse );
		var n:Number = getCellRow( m_mcMain._ymouse );
		
		m_movingPiece_mc = clickOnPiece( new Point(m_mcMain._xmouse,m_mcMain._ymouse) ) ;//m_chessPieces_array[ ChessBoard.st_mnToPos(m, n,NUM_COLS) ];
		if ( m_movingPiece_mc )//if there is a peice there.
		{
			m_movingPiece_mc.startDrag();
			m_movingPiece_mc.moving =  true;
			m_movingPiece_mc.prevM = m;
			m_movingPiece_mc.prevN = n;
			m_movingPiece_mc.swapDepths( m_mcPlaceHolder );
		}
	}
	
	//-----------------------------------------------------
	// Name: onMouseMove()
	// Desc: what to do when the mouse is moved
	//-----------------------------------------------------
	public function onMouseMove( ):Void
	{
		/*
		if( m_movingPiece_mc.moving == true )
		{
			m_movingPiece_mc._x = m_mcMain._xmouse-(m_movingPiece_mc._width*0.5);//colToX(getCellCol(m_mcMain._xmouse));
			m_movingPiece_mc._y = m_mcMain._ymouse - (m_movingPiece_mc._height * 0.5);//rowToY(getCellRow(m_mcMain._ymouse));
			updateAfterEvent();
		}
		*/
	}
	
	//-----------------------------------------------------
	// Name: onMouseUp()
	// Desc: What to do when the mouse button is released
	//-----------------------------------------------------
	public function onMouseUp( ):Void
	{
		//if we're dragging a piece around when we let go
		if ( m_movingPiece_mc )
		{
			m_mcPlaceHolder.swapDepths( m_movingPiece_mc );
			var toCol:Number = getCellCol(m_mcMain._xmouse),
				toRow:Number = getCellRow(m_mcMain._ymouse),
				fromCol:Number = m_movingPiece_mc.prevM,
				fromRow:Number = m_movingPiece_mc.prevN;
			
			//stop dragging the peice
			m_movingPiece_mc.stopDrag();
			//snap to grid
			m_movingPiece_mc._x = colToX(toCol);
			m_movingPiece_mc._y = rowToY(toRow);
			//stop movement
			m_movingPiece_mc.moving = false;
			//validate the move
			if ( m_chessBoard.movePieceMN(fromCol,fromRow,toCol,toRow) )
			{
				var killed:MovieClip = pieceHitTest( m_movingPiece_mc );
				if ( killed )
					killed.removeMovieClip();
				m_chessBoard.printBoard();
				redrawBoard();
				updatePieceCount();
				updateMoveList();
			}
			else
			{//wasn't a valid move put it back
				m_movingPiece_mc._x = colToX(m_movingPiece_mc.prevM);
				m_movingPiece_mc._y = rowToY(m_movingPiece_mc.prevN);
			}
		}
	}
	
	public function onUndo():Void
	{
		try{ m_chessBoard.undo(); }catch( e:Error ) { Alert.show( e.message ); }
		redrawBoard();
		updatePieceCount();
		updateMoveList();
	}
	
	//-------------------------------------------------------------------
	// Func: onReset()
	// Desc: resets the board
	//-------------------------------------------------------------------
	public function onReset():Void
	{
		this.m_chessBoard.resetBoard();
		updatePieceCount();
		updateMoveList();
		redrawBoard();
	}
	
	//-------------------------------------------------------------------
	// Func: onLoad()
	// Desc: deermines what to do when the load button is clicked
	//-------------------------------------------------------------------
	public function onLoad():Void
	{
		var str:String = m_mcMain.loadmove_ti.text;
		var rgex:RegExp = new RegExp("^http://|^file:///", "i");//need to complete the regex
		
		if ( rgex.test( str ) )
			loadBkgrnd( str );
		else
			loadBoard( str );
	}
	
	//-----------------------------------------------------
	// Name: toString()
	// Desc: over load the toString method to return the
	//	name of this class
	//-----------------------------------------------------
	public function toString( ):String
	{
		return "ChessGame";
	}
		
	public function setDebugMode( db:Boolean ):Void { m_bDebugMode = db; m_chessBoard.debugMode = db; }
	public function getDebugMode( ):Boolean { return m_bDebugMode; }
	public function get outputString():String { return m_chessBoard.outputString + m_strOutput; }
	
	//---------------------------
	// Private Methods
	//---------------------------
	
	//-------------------------------------------------------------------
	// Func: onLoad()
	// Desc: Takes a string of moves in the format FRFR,...,FRFR
	//	where F stands for file and R stands for rank, and processes
	//	those moves.
	//-------------------------------------------------------------------
	private function loadBoard( b:String ):Void
	{
		var mvList:Array = String(b).split(",");
		
		if ( mvList[0] == "" || mvList == null) { Alert.show( "You must enter moves to load.", "Null String", Alert.OK, m_mcPlaceHolder, null, "Exclamation_Icon"); return; }
		
		for ( var cm:ChessMove; mvList.length >0; )
		{
			cm = parseMoveFromStr( String(mvList.shift()) );
			if ( cm != null )
			{
				if ( m_chessBoard.movePiece( cm.m_nPos, cm.m_nDest ) )
				{
					m_chessBoard.printBoard();
					redrawBoard();
					updatePieceCount();
					updateMoveList();
				}
				else
				{
					Alert.show( "Not a valid move!", "Invalid Move", Alert.OK, m_mcPlaceHolder, null, "Exclamation_Icon");
					break;
				}
			}
			else
			{
				Alert.show( "Failed to parse a move! Click OK to continue.", "Parse Move", Alert.OK, m_mcPlaceHolder, null, "Exclamation_Icon");
				break;
			}
		}
	}
	
	//-----------------------------------------------------
	// Func: loadBk()
	// Desc: 
	//-----------------------------------------------------
	private function loadBkgrnd( str:String ):Void
	{
		//SWF, JPEG, GIF, or PNG 
		//file:///E:\MyDocuments\My Pictures\tasha allb.jpg
		//http://picasaweb.google.com/scirelli2/MaxiRandomPics/photo#5217005918394006098
		loadMovie( str, m_mcMain.boardAndTxt_mc.bkimg_mc ); //302,302
		//m_mcMain.boardAndTxt_mc.bkimg_mc._alpha = 50;
		trace( "Loaded img: W:" + m_mcMain.boardAndTxt_mc.bkimg_mc._width + " H: " + m_mcMain.boardAndTxt_mc.bkimg_mc._height )
		//m_mcMain.boardAndTxt_mc.bkimg_mc._xscale = 50;
		//m_mcMain.boardAndTxt_mc.bkimg_mc._yscale = 50;
		m_mcMain.boardAndTxt_mc.outlinegrid_mc.grid_mc._alpha = 70;
		m_mcMain.logo_mc._visible = false;
	}
	
	//-----------------------------------------------------
	// Func: parseMoveFromStr()
	// Desc: Accepts an array of moves in the format FRFR
	//	where F stands for file and R stands for rank and
	//	returns a ChessMove
	// Param:
	//	mvList: String, string representing a chess moves 
	//		FRFR.
	//-----------------------------------------------------
	private function parseMoveFromStr( mvList:String ):ChessMove
	{
		var rgex:RegExp = new RegExp(".\\d.\\d", "i");//matches any character then any digit twice
		
		if ( rgex.test( mvList ) )
		{
			var a:String = mvList.charAt(0), b:String = mvList.charAt(1), c:String = mvList.charAt(2), d:String = mvList.charAt(3);
			var pos:Number = m_chessBoard.mnToPos ( fileToColNum( mvList.charAt(0) ), rankToRow( parseInt(mvList.charAt(1))) ),
				dest:Number = m_chessBoard.mnToPos( fileToColNum( mvList.charAt(2) ), rankToRow( parseInt(mvList.charAt(3))) );
			return new ChessMove( pos, dest, null, null );
		}
		
		return null;
	}
	
	
	//-----------------------------------------------------
	// Func: clickOnPiece
	// Desc:
	// Param:
	//	Point: the point to hit test all chesspieces against
	// return: the piece that was clicked on. Or null if
	//	not found.
	//-----------------------------------------------------
	private function clickOnPiece( p:Point ):MovieClip
	{
		for ( var strPiece:String in m_piecesContainer_mc )
		{
			var piece:MovieClip = m_piecesContainer_mc[ strPiece ];
			if ( piece.hitTest( p.x, p.y ) )
				return piece;
		}
		return null;
	}
	
	//-----------------------------------------------------
	// Func: pieceHitTest()
	// Desc: Check to see if two pieces collide
	// Param:
	//	p: MovieClip, the movieclip to hit test
	// return: the movieclip that was hit
	//-----------------------------------------------------
	private function pieceHitTest( p:MovieClip ):MovieClip
	{
		for ( var strPiece:String in m_piecesContainer_mc )
		{
			var piece:MovieClip = m_piecesContainer_mc[ strPiece ];
			if ( p.hitTest( piece ) && p != piece )
				return piece;
		}
		return null;
	}
	
	//-----------------------------------------------------
	// Name: drawBoard()
	// Desc: draws the visual board.
	//	Param:
	//	container: container clip for the pieces.
	//	return: the container clip sent in
	//-----------------------------------------------------
	private function drawBoard( container:MovieClip ):MovieClip
	{
		//loop through the board and create the chess peices
		//output("Starting loop 0 to " + m_chessBoard.getBSize() );
		
		for( var i:Number =0; i<m_chessBoard.getBSize(); i++ )
		{
			//get a chess peice
			var p_cp:ChessPiece = ChessPiece(m_chessBoard.getItem(i));
			
			//make sure it's a piece
			if( p_cp != undefined && p_cp != null )
			{
				//output("Found vaild piece...");
				var p_obj:Object = new Object(); //create an obj for setting the x,y pos
				var p_str:String = ChessPiece.lookUp(p_cp.color) + ChessPiece.lookUp(p_cp.type); //create the piece string for attaching the movie
				//output( p_str );
				p_obj._x = colToX(m_chessBoard.posToM(i));
				p_obj._y = rowToY(m_chessBoard.posToN(i));
				//output("It's coords: " + p_obj._x + "," + p_obj._y );
				p_obj.moving = false;
				p_obj.piece_cp = p_cp;
				p_obj.onRollOver = function( ){} //attach an onRollOver function so change mouse pointer to hand
				//Now create the piece attach the p_obj for initialization
				m_chessPieces_array[i] =  container.attachMovie( p_str+"_mc",p_str+i+"_mc", 
																 container.getNextHighestDepth(),
																 p_obj
																);
				//output( "Popped: " + m_chessPieces_array.pop()._name);
			}//end if
		}//end for
		m_mcPlaceHolder = container.createEmptyMovieClip( "m_mcPlaceHolder", container.getNextHighestDepth() );
		return container;
	}
	
	//-----------------------------------------------------
	// Func: redrawBoard()
	// Desc: redraws board based on m_chessBoard
	//-----------------------------------------------------
	private function redrawBoard( ):Void
	{
		releaseSymbols();
		output("Deleted board " + m_piecesContainer_mc);
		this.m_piecesContainer_mc = m_mcMain.createEmptyMovieClip( "piecesContainer_mc", m_mcMain.getNextHighestDepth() ); 
		drawBoard( this.m_piecesContainer_mc );
	}
	
	//-----------------------------------------------------
	// Name: initGame()
	// Desc: 
	//-----------------------------------------------------
	private function initGame( ):Void
	{
		m_chessBoard = new ChessBoard( );
		m_chessPieces_array = new Array( m_chessBoard.getBSize() );
		m_plyrHuman = new Human("Steve Cirelli");
		m_capturePieceLbls = new Array();
		buildSymbols( );
		m_mcMain.undo_btn.onRollOver = function(){ this.useHandCursor = true; };
		m_mcMain.undo_btn.onRollOut = function() { this.useHandCursor = false; };
		setupGameState( );
		updatePieceCount();
		beginGame();
	}
	
	//-----------------------------------------------------
	// Name: buildSymbols()
	// Desc: create all the movies clips needed for this
	//		 game. and attach them to m_mcMain
	//-----------------------------------------------------
	private function buildSymbols ( ):Boolean 
	{
		//--create all clips--
		//create a container for all the clips
		this.m_piecesContainer_mc = m_mcMain.createEmptyMovieClip( "piecesContainer_mc", m_mcMain.getNextHighestDepth() ); 
		//output("Created: piecesContainer: " + m_mcMain + " " + this.m_piecesContainer_mc.toString() + " " + (m_mcMain.getNextHighestDepth() - 1) );
		drawBoard( this.m_piecesContainer_mc );
		this.m_chipContainer_mc = m_mcMain.createEmptyMovieClip( "chipContainer_mc", m_mcMain.getNextHighestDepth() ); 
		this.m_chipContainer_mc.attachMovie( "chip", "chip_mc", m_chipContainer_mc.getNextHighestDepth() ); 
		placeChip( ChessPiece.WHITE );
		placePieceCaptureLbl();
		return true; 
	}
	
	//-------------------------------------------------------------------
	// Func: placePieceCaptureLbl()
	// Desc: 
	//-------------------------------------------------------------------
	private function placePieceCaptureLbl():Void
	{
		m_capturePieceCont = m_mcMain.createEmptyMovieClip( "m_capturePieceCont", m_mcMain.getNextHighestDepth() ); 
		//Now create the piece attach the p_obj for initialization
		for ( var i:Number = 0; i < m_aCaptureLblPos.length; i++)
			m_capturePieceLbls.push( placePieceCaptureLblHlpr( m_aCaptureLblPos[i].p, m_aCaptureLblPos[i].n ));
		
	}
	private function placePieceCaptureLblHlpr( p:Point, name:String ):MovieClip
	{
		var p_obj:Object = new Object(); //create an obj for setting the x,y pos
		
		p_obj._x = p.x;
		p_obj._y = p.y;
		p_obj.text = 0;
		//this.createObject("Button", "cbtSubmit", this.getNextHighestDepth());
		return m_capturePieceCont.createClassObject(mx.controls.Label, name, m_capturePieceCont.getNextHighestDepth(),p_obj);
	}
	
	//-------------------------------------------------------------------
	// Func: updatePieceCount()
	// Desc: Updates the boards killed piece counter.
	//-------------------------------------------------------------------
	private function updatePieceCount( ):Void
	{
		for ( var i:Number = 0, t:Number=0; i < m_aCaptureLblPos.length; i++ )
		{
			switch( m_aCaptureLblPos[i].t )
			{
				case ChessPiece.KING :
				case ChessPiece.QUEEN :
				{
					t = 1;
					break;
				}
				case ChessPiece.BISHOP:
				case ChessPiece.KNIGHT:
				case ChessPiece.ROOK:
				{
					t = 2;
					break;
				}
				case ChessPiece.PAWN:
				{
					t = 8;
					break;
				}
				default:
					t = 0;
			}
			m_capturePieceCont[m_aCaptureLblPos[i].n].text = t - m_chessBoard.countPiece( m_aCaptureLblPos[i].t, m_aCaptureLblPos[i].c);
		}
	}
	
	//-------------------------------------------------------------------
	// Func: updateMoveList()
	// Desc: updates the text field that displays the move list
	//-------------------------------------------------------------------
	private function updateMoveList( ):Void
	{
		var list:String = "";
		for ( var i:Number = 0, mvList:Array = this.m_chessBoard.moveList, mv:ChessMove, tmp:ChessMove=null; i < mvList.length; i++ )
		{
			mv  = ChessMove(mvList[i]);
			
			if( tmp == null || mv.m_cpPiece.color != tmp.m_cpPiece.color )//using this for now to get rid of extra castle move.
				list += colNumToFile(posToX(mv.m_nPos))  + rowToRank(posToY(mv.m_nPos)) + 
						colNumToFile(posToX(mv.m_nDest)) + rowToRank(posToY(mv.m_nDest)) + ",";
			tmp = mv;
		}
		m_mcMain.recmove_ti.text = list.substring(0, list.length-1);//remove the comma at the end
	}
	
	//-------------------------------------------------------------------
	// Name: setupGameState()
	// Desc: 
	//-------------------------------------------------------------------
	private function setupGameState    ( ):Boolean 
	{ 
		return false; 
	}
	
	//-------------------------------------------------------------------
	// Name: processInput()
	// Desc: Processes the m_moveQ_array.
	// Standards: Moves are in the format [char][number][char][number]
	//			  where the first two (char number) are the from possition
	//			  and the second pair are the to possition. 
	//			  Example: a2a3 would move a piece from a1 to a2
	//-------------------------------------------------------------------
	private function processInput      ( ):Boolean 
	{ 
		//var move_str:String = String(m_moveQ_array.shift());
		if ( m_plyrHuman.m_bpKeys_array[ String("d").charCodeAt(0) ] )
		{
			releaseSymbols();
			trace("Deleted " + m_piecesContainer_mc);
			this.m_piecesContainer_mc = m_mcMain.createEmptyMovieClip( "piecesContainer_mc", m_mcMain.getNextHighestDepth() ); 
			drawBoard( this.m_piecesContainer_mc );
		}
		return false; 
	}
	private function processLoadTxtInput( ):Void
	{
		if( m_mcMain.loadmove_ti.text != "" )
		{//process input
		
		}
	}
	
	//-------------------------------------------------------------------
	// Func: placeChip()
	// desc: places the chip for which ever color you send in.
	//-------------------------------------------------------------------
	private function placeChip( color:Number ):Void
	{
		if ( color == ChessPiece.WHITE )
		{
			m_chipContainer_mc.chip_mc._x = W_CHIP_X;
			m_chipContainer_mc.chip_mc._y = W_CHIP_Y;
		}
		else
			if ( color == ChessPiece.BLACK )
			{
				m_chipContainer_mc.chip_mc._x = B_CHIP_X;
				m_chipContainer_mc.chip_mc._y = B_CHIP_Y;
			}
	}
	
	//-------------------------------------------------------------------
	// Name: releaseSymbols()
	// Desc: 
	//-------------------------------------------------------------------
	private function releaseSymbols    ( ):Boolean 
	{ 
		m_piecesContainer_mc.swapDepths(0);
		m_piecesContainer_mc.removeMovieClip();
		return true; 
	}
	
	//---------------------------
	// Private Static Methods
	//---------------------------
	private static function getCellCol( x:Number ):Number
	{ return Math.floor( (NUM_COLS/GRID_WIDTH) * (x-GRID_X) ); }
	private static function getCellRow( y:Number ):Number // NUM_ROWS/GRID_HEIGHT * MouseY
	{ return Math.floor( (NUM_ROWS/GRID_HEIGHT) * (y-GRID_Y) ); }
	private static function colToX( col:Number ):Number
	{ return ( BLOCK_WIDTH * col)+GRID_X; }
	private static function rowToY( row:Number ):Number
	{ return ( BLOCK_HEIGHT * row ) + GRID_Y; }
	
	//---------------------------------------------------
	// Name: rowToRank()
	// Desc: row to graphical board row
	//---------------------------------------------------
	private static function rowToRank( n:Number ):Number
	{
		//get a number from 0 to 7
		if( n >= 0 && n < NUM_ROWS ) //0 to 7
		{ return NUM_ROWS-(n); } //n+1
	}
	private static function rankToRow( n:Number ):Number
	{
		if( n >= 1 && n <= NUM_ROWS ) //1 to 8
		{ return (NUM_ROWS-1)-(n-1); }
	}
	
	//---------------------------------------------------
	// Name: colNumToChar()
	// Desc: row to graphical board row
	//---------------------------------------------------
	private static function colNumToFile( m:Number ):String
	{
		//get a number from 0 to 7
		// 8 7 6 5 4 3 2 1
		//   7 6 5 4 3 2 1 0
		if( m >= 0 && m < NUM_ROWS ) //0 to 7
		{
			switch( m )
			{
				case 0 : return "a";
				case 1 : return "b";
				case 2 : return "c";
				case 3 : return "d";
				case 4 : return "e";
				case 5 : return "f";
				case 6 : return "g";
				case 7 : return "h";
			}
		}
	}
	private static function fileToColNum( m:String ):Number
	{
		switch( m )
			{
				case "a" : return 0;
				case "b" : return 1;
				case "c" : return 2;
				case "d" : return 3;
				case "e" : return 4;
				case "f" : return 5;
				case "g" : return 6;
				case "h" : return 7;
			}
	}
	
	private static function xyToPos( x:Number, y:Number ):Number
	{ return y*NUM_COLS + x; }
	private static function posToY( pos:Number ):Number
	{ return Math.floor(pos/NUM_ROWS); }
	private static function posToX( pos:Number ):Number
	{ return( pos - posToY(pos)*NUM_COLS ); }
	
	//---------------------------
	// Private Variables
	//---------------------------
	private var m_piecesContainer_mc:MovieClip;
	private var m_chipContainer_mc:MovieClip;
	private var m_chessPieces_array:Array;
	private var m_movingPiece_mc:MovieClip;
	private var m_chessBoard:ChessBoard;
	private var m_mcMain:MovieClip;
	private var m_mcPlaceHolder:MovieClip;
	private var m_plyrHuman:Human;
	private var m_capturePieceLbls:Array;
	private var m_capturePieceCont:MovieClip;
	private var m_aCaptureLblPos:Array = null;
	private var m_eCaptureLblIndex:EnumeratedType;
	private var m_nBoardOrientation:Number = 1;
};