//---------------------------------------------------------
// File: ChessPiece.as
//
// Desc: 
//
// Notes: 
// @author: Steve Cirelli
//---------------------------------------------------------

////IMPORTS///////


//---------------------------------------------------------
// Main Class Declarations
//---------------------------------------------------------
//---------------------------------------------------------
// Name : ChessPiece (Class)
// Desc : 
//---------------------------------------------------------
class ChessPiece
{
	//--------------------
	// Constants
	//--------------------
	public static var NONE:Number  = 0;
	public static var BLACK:Number = 1;
	public static var WHITE:Number = 2;
	public static var KING:Number  = 3;
	public static var QUEEN:Number = 4;
	public static var ROOK:Number  = 5;
	public static var KNIGHT:Number= 6;
	public static var BISHOP:Number= 7;
	public static var PAWN:Number  = 8;
	
	public static var NUM_INDIVIDUAL_PIECES:Number = 6;
	
	public static function lookUp( type:Number ):String
	{
		switch ( type )
		{
			case NONE:
			{
				return "";
				break;
			}
			case BLACK:
			{
				return "Black";
				break;
			}
			case WHITE:
			{
				return "White";
				break;
			}
			case KING:
			{
				return "King";
				break;
			}
			case QUEEN:
			{
				return "Queen";
				break;
			}
			case ROOK:
			{
				return "Rook";
				break;
			}
			case KNIGHT:
			{
				return "Knight";
				break;
			}
			case BISHOP:
			{
				return "Bishop";
				break;
			}
			case PAWN:
			{
				return "Pawn";
				break;
			}
			default :
				return "Unknown"
		}
	}
	
	public static function lookUpColor( c:Number ):String
	{
		switch( c )
		{
			case BLACK:
			{
				return "black";
			}
			case WHITE:
			{
				return "white";
			}
		}
		return "Not a valid color index.";
	}
	public function ChessPiece( t:Number, c:Number, col:Number, row:Number, d:Boolean )
	{ 
		type = t;
		color = c;
		m = col;
		n = row;
		dead = d;
	}
	
	//----------------------------------------------------
	// Func: copy()
	// Desc: performs a deep copy of the peice sent it
	// Param:
	//	p: ChessPiece, a chess peice
	// return: a chesspiece
	//----------------------------------------------------
	public function copy( ):ChessPiece
	{
		return new ChessPiece( this.type, this.color, this.m, this.n, this.dead);
	}

	public var type:Number  = NONE;
	public var color:Number = NONE;
	public var m:Number     = 0;
	public var n:Number     = 0;
	public var moves:Number = 0;
	public var dead:Boolean = false;
};