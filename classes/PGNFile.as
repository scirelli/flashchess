//---------------------------------------------------------
// File: PGNFile.as
//
// Desc: A class that represents a PGN file
//
// Notes: 
//
// @author Steve Cirelli
//---------------------------------------------------------

import TagPairSection;

class PGNFile 
{
	//--------------------
	// Public Members
	//--------------------
	
	//--------------------
	// Private Methods
	//--------------------
	
	//--------------------
	// Private Members
	//--------------------
	private var m_strFileName:String = "";
	private var m_tagPairSection:TagPairSection;
	private var m_MoveList:PGNMoveText;
}

/* ---- Tokens ----
String Token:
	A string token is a sequence of zero or more printing characters delimited by a pair of quote characters 
	(ASCII decimal value 34, hexadecimal value 0x22). An empty string is represented by two adjacent quotes. 
	(Note: an apostrophe is not a quote.) A quote inside a string is represented by the backslash immediately followed by a quote. 
	A backslash inside a string is represented by two adjacent backslashes. Strings are commonly used as tag pair values (see below). 
	Non-printing characters like newline and tab are not permitted inside of strings. A string token is terminated by its closing quote. 
	Currently, a string is limited to a maximum of 255 characters of data.

Integer Token:
	An integer token is a sequence of one or more decimal digit characters. It is a special case of the more general "symbol" token 
	class described below. Integer tokens are used to help represent move number indications (see below). An integer token is terminated 
	just prior to the first non-symbol character following the integer digit sequence.

Period Token:
	A period character (".") is a token by itself. It is used for move number indications (see below). It is self terminating.

Asterisk Token:
	An asterisk character ("*") is a token by itself. It is used as one of the possible game termination markers (see below); 
	it indicates an incomplete game or a game with an unknown or otherwise unavailable result. It is self terminating.

Left [ and Right ] Tokens:
	The left and right bracket characters ("[" and "]") are tokens. They are used to delimit tag pairs (see below). Both are 
	self terminating.

Left ( and Right ) Token
	The left and right parenthesis characters ("(" and ")") are tokens. They are used to delimit Recursive Annotation Variations 
	(see below). Both are self terminating.

Left < and Rigt > Token
	The left and right angle bracket characters ("<" and ">") are tokens. They are reserved for future expansion. Both are self 
	terminating.

NAG Tokens:
	A Numeric Annotation Glyph ("NAG", see below) is a token; it is composed of a dollar sign character ("$") immediately followed 
	by one or more digit characters. It is terminated just prior to the first non-digit character following the digit sequence.

Symbol Token:
	A symbol token starts with a letter or digit character and is immediately followed by a sequence of zero or more symbol 
	continuation characters. These continuation characters are letter characters ("A-Za-z"), digit characters ("0-9"), the 
	underscore ("_"), the plus sign ("+"), the octothorpe sign ("#"), the equal sign ("="), the colon (":"), and the hyphen 
	("-"). Symbols are used for a variety of purposes. All characters in a symbol are significant. A symbol token is terminated 
	just prior to the first non-symbol character following the symbol character sequence. Currently, a symbol is limited to a maximum 
	of 255 characters in length.

*/
//---------------------------------------------------------
// Func: 
// Desc: 
//---------------------------------------------------------