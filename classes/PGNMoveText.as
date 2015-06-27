//---------------------------------------------------------
// File: PGNMoveText.as
//
// Desc: A class that represents a PGN Move text section
//
// Notes: 
//
// @author Steve Cirelli
//---------------------------------------------------------

import util.EnumeratedType;
import ChessMove;
import RegExp;

class PGNMoveText
{
	//--------------------
	// Static Const Private Members
	//--------------------
	public static var PIECE_LIST:String = "KQNBRP";
	public static var PIECES:EnumeratedType = new EnumeratedType( "king", "queen", "knight", "bishop", "rook", "pawn" );
	public static var FILE_LIST:String = "abcdefgh";
	public static var RANK_RANGE:Array = [ 1, 8 ];
	public static var Q_CASTLE:String = "O-O-O";
	public static var K_CASTLE:String = "O-O";
	
	//--------------------
	// Contructor
	//--------------------
	
	//--------------------
	// Public Methods
	//--------------------
	
	//--------------------
	// Public Members
	//--------------------
	
	//--------------------
	// Private Methods
	//--------------------
	private function parseMove( mv:String ):ChessMove
	{
		var c:String = "";
		
		for ( var i:Number = 0; i < mv.length; i++ )
		{
			c = mv.charAt(i);
			if ( PIECE_LIST.indexOf(c, 0) != -1 )
			{//found a piece
				
			}
			else
				if ( FILE_LIST )
				{//found a file
					
				}
		}
		return new ChessMove;
	}
	
	//--------------------
	// Private Members
	//--------------------
}

	//---------------------------------------------------------
	// Func: 
	// Desc: 
	//---------------------------------------------------------
	
	
	
/*
	case '{':
	    SANRGChar();
	    bracecount = 1;
	    while ((gsf_char != EOF) && (bracecount > 0))
	      {
			if (gsf_char == '{')
			  bracecount++;
			else
			  if (gsf_char == '}')
				bracecount--;
			SANRGChar();
	      };
	    if (bracecount != 0)
	      gst = gst_error;
	    break;

<move token>

move token ::= <move number> <move>

move number ::= <Integer token> <.>

move ::= <SAN move white> <SAN move Black>

SAN move white ::= <..> OR <SAN move>

SAN move Blank ::= <SAN move>

	
	
*/	
