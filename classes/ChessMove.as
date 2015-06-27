//---------------------------------------------------------
// File: ChessMovee.as
//
// Desc: A class that represents a chess move
//
// Notes: 
//
// @author Steve Cirelli
//---------------------------------------------------------

////IMPORTS///////
import ChessPiece;
import mx.data.types.Str;

class ChessMove
{
	//--------------------
	// Static Constants
	//--------------------
	public static var NOT_A_MOVE:Number  		= 0;
	public static var REG_MOVE:Number			= 1;
	public static var QUEEN_SIDE_CASTLE:Number 	= 2;
	public static var KING_SIDE_CASTLE:Number 	= 3;
	public static var CASTLE:Number				= 4;
	public static var EN_PASSANT:Number			= 5;
	public static var SPECIAL:Number			= 6;
	
	//--------------------
	// Constructor
	//--------------------
	//-----------------------------------------------------
	// Func: ChessMove()
	// Desc: Constructor
	// Param:
	//	pos: the position where the piece started
	//	dest: the position of where the piece moved to
	//	piece: the piece being moved
	//	kill: if the moving piece killed another piece, this
	//		will be the dead piece
	// 	type: Type of move. special or reg.
	//	check: if this move puts it's apponent into check
	//-----------------------------------------------------
	public function ChessMove( pos:Number, dest:Number, piece:ChessPiece, kill:ChessPiece, moveType:Number )
	{	
		m_nPos = pos;
		m_nDest = dest;
		m_cpPiece = piece;
		m_cpKill = kill;
		if ( arguments[4] )
			m_nMoveType = arguments[4];
		else
			m_nMoveType = REG_MOVE;
	}
	
	//--------------------
	// Public Static Methods
	//--------------------
	public static function moveType( type:Number ):String
	{
		switch(type)
		{
			case NOT_A_MOVE:
			{
				return "not a move";
			}
			case REG_MOVE:
			{
				return "regular move";
			}
			case QUEEN_SIDE_CASTLE:
			{
				return "queen side castle";
			}
			case KING_SIDE_CASTLE:
			{
				return "king side castle";
			}
			case EN_PASSANT:
			{
				return "en passant";
			}
			case SPECIAL:
			{
				return "special";
			}
			default:
			{
				return "";
			}
		}
		return "";
	}
	
	//--------------------
	// Public Methods
	//--------------------
	
	//-----------------------------------------------------
	// Func: toString()
	// Desc: converts this move to a PGN move string
	//-----------------------------------------------------
	public function toString():String
	{
		return "Pos: '" + this.m_nPos + "' Dest: '" + this.m_nDest + "' Moving piece '" + ChessPiece.lookUp(this.m_cpPiece.type) + "' Color: " +
		        ChessPiece.lookUpColor(this.m_cpPiece.color) + "' Killed piece: '" + ChessPiece.lookUp(this.m_cpKill.type) + "' Color '" + ChessPiece.lookUpColor(this.m_cpKill.color) + 
				"' Move type '" + ChessMove.moveType(m_nMoveType) + "'";
	}
		
	//--------------------
	// Private Methods
	//--------------------
	
	//--------------------
	// Public Members
	//--------------------
	public var m_nPos:Number;
	public var m_nDest:Number;
	public var m_cpPiece:ChessPiece = null;
	public var m_cpKill:ChessPiece = null;
	public var m_bCheck:Boolean = false;
	public var m_strComment:String = "";
	public var m_nMoveType:Number = NOT_A_MOVE;
	
	//--------------------
	// Private Members
	//--------------------
}