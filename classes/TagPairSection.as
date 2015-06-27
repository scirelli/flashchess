//---------------------------------------------------------
// File: TagPairSection.as
//
// Desc: A class that represents a PGN tag pair
//
// Notes: 
//
// @author Steve Cirelli
//---------------------------------------------------------

////IMPORTS///////
import TagPair;

class  TagPairSection
{
	//--------------------
	// Public Static Constants
	//--------------------
	public static var PGN_STR:Array = ["Event","Site","Date","Round","White","Black","Result"];//Seven tag roaster
	
	//--------------------
	// Contructor
	//--------------------
	public function TagPairSection( ):Void
	{
		m_aTagPairList = new Array();
	}
	
	//--------------------
	// Public Methods
	//--------------------
	//---------------------------------------------------------
	// Func: addTag()
	// Desc: Adds a tag to the tag list
	// Return: number, length of the tag list
	//---------------------------------------------------------
	public function addTag( tagPair:TagPair ):Number
	{
		return m_aTagPairList.push( tagPair );
	}
	
	//---------------------------------------------------------
	// Func: isPGNExportTPSec()
	// Desc: returns true if the tag list represents a valid
	//	PGN tag pair section of a PGN export file
	//---------------------------------------------------------
	public function isPGNExportTPSec():Boolean
	{
		var rtn:Boolean = true;
		for ( var i = 0; i < PGN_STR.length; i++ )
			rtn = rtn && ( String(PGN_STR[i]).toUpperCase == TagPair(m_aTagPairList[i]).name.toUpperCase );
		return rtn;
	}
	
	//---------------------------------------------------------
	// Func: length()
	// Desc: returns the length of the list
	//---------------------------------------------------------
	public function length():Number
	{
		return m_aTagPairList.length;
	}
	
	//---------------------------------------------------------
	// Func: getList()
	// Desc: returns the list
	//---------------------------------------------------------
	public function getList():Array
	{
		return m_aTagPairList;
	}
	
	//--------------------
	// Public Members
	//--------------------
	
	//--------------------
	// Private Methods
	//--------------------
	
	//--------------------
	// Private Members
	//--------------------
	private var m_aTagPairList:Array;
}

	//---------------------------------------------------------
	// Func: 
	// Desc: 
	//---------------------------------------------------------