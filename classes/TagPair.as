//---------------------------------------------------------
// File: TagPair.as
//
// Desc: A class that represents a PGN tag pair
//
// Notes: 
//
// @author Steve Cirelli
//---------------------------------------------------------

////IMPORTS///////
import util.EnumeratedType;

class  TagPair
{
	
	//--------------------
	// Constant Static Members
	//--------------------
	public static var MODE_OVER_THE_BOARD 		 = "OTB", /* Game mode */
					  MODE_PAPER_MAIL 			 = "PM",
					  MODE_EMAIL 				 = "EM",
					  MODE_INTERNET_CHESS_SERVER = "ICS",
					  MODE_GENERAL_TELCOM 		 = "TC",
					  GTM_WHITE_WINS 			 = "1-0", /*Game termination marker*/
					  GTM_BLACK_WINS 			 = "0-1",
					  GTM_DRAW 					 = "1/2-1/2",
					  GTM_IN_PROGRESS 			 = "*",
					  TERM_ABANDONED 			 = "abandoned", /* Termination */
					  TERM_ADJUDICATION 		 = "adjudication",
					  TERM_DEATH 				 = "death",
					  TERM_EMERGENCY			 = "emergency",
					  TERM_NORMAL				 = "normal",
					  TERM_RULES_INFRACTION		 = "rules infraction",
					  TERM_TIME_FORFEIT			 = "time forfeit",
					  TERM_UNTERMINATED			 = "unterminated";
	
	//--------------------
	// Contructor
	//--------------------	
	//---------------------------------------------------------
	// Func: TagPair() Constructor
	// Desc: 
	// Params:
	//	arguments[0]: the tag name
	//	arguments[1]: the data
	//---------------------------------------------------------
	public function TagPair( )
	{
		if ( arguments.length == 2 )
		{
			m_strTagName = String(arguments[0]); 
			m_strTagData = String( arguments[1] );
		}
	}
	
	//--------------------
	// Public Methods
	//--------------------
	
	//--------------------
	// Public Members
	//--------------------
	public function get name():String
	{ return m_strTagName; }
	
	public function get data():String
	{ return m_strTagData; }
	
	public function set name( n:String ):Void
	{ m_strTagName = n; }
	
	public function set data( d:String ):Void
	{ m_strTagData = d; }
	
	//---------------------------------------------------------
	// Func: NAGLookup()
	// Desc: Numeric Annotation Glyphs lookup.
	// Params: 
	//	n: Number, the NAG number to lookup
	// return: Returns a descriptive string of a NAG
	//---------------------------------------------------------
	public static function NAGLookup( n:Number ):String
	{
		var rtn:String = "";
		switch( n )
		{
			case 0: 
			{
				rtn = "null annotation";
				break;
			}
			case 1:	
			{
				rtn = "good move (traditional '!')";
				break;
			}
			case 2:
			{
				rtn = "poor move (traditional '?')";
				break;
			}
			case 3:
			{
				rtn = "very good move (traditional '!!')";
				break;
			}
			case 4:
			{
				rtn = "very poor move (traditional '??')";
				break;
			}
			case 5:
			{
				rtn = "speculative move (traditional '!?')";
				break;
			}
			case 6:
			{
				rtn = "questionable move (traditional '?!')";
				break;
			}
			case 7:
			{
				rtn = "forced move (all others lose quickly)";
				break;
			}
			case 8:
			{
				rtn = "singular move (no reasonable alternatives)";
				break;
			}
			case 9:
			{
				rtn = "worst move";
				break;
			}
			case 10:
			{
				rtn = "drawish position";
				break;
			}
			case 11:
			{
				rtn = "equal chances, quiet position";
				break;
			}
			case 12:
			{
				rtn = "equal chances, active position";
				break;
			}
			case 13:
			{
				rtn = "unclear position";
				break;
			}
			case 14:
			{
				rtn = "White has a slight advantage";
				break;
			}
			case 15:
			{
				rtn = "Black has a slight advantage";
				break;
			}
			case 16:
			{
				rtn = "White has a moderate advantage";
				break;
			}
			case 17:
			{
				rtn = "Black has a moderate advantage";
				break;
			}
			case 18:
			{
				rtn = "White has a decisive advantage";
				break;
			}
			case 19:
			{
				rtn = "Black has a decisive advantage";
				break;
			}
			case 20:
			{
				rtn = "White has a crushing advantage (Black should resign)";
				break;
			}
			case 21:
			{
				rtn = "Black has a crushing advantage (White should resign)";
				break;
			}
			case 22:
			{
				rtn = "White is in zugzwang";
				break;
			}
			case 23:
			{
				rtn = "Black is in zugzwang";
				break;
			}
			case 24:
			{
				rtn = "White has a slight space advantage";
				break;
			}
			case 25:
			{
				rtn = "Black has a slight space advantage";
				break;
			}
			case 26:
			{
				rtn = "White has a moderate space advantage";
				break;
			}
			case 27:
			{
				rtn = "Black has a moderate space advantage";
				break;
			}
			case 28:
			{
				rtn = "White has a decisive space advantage";
				break;
			}
			case 29:
			{
				rtn = "Black has a decisive space advantage";
				break;
			}
			case 30:
			{
				rtn = "White has a slight time (development) advantage";
				break;
			}
			case 31:
			{
				rtn = "Black has a slight time (development) advantage";
				break;
			}
			case 32:
			{
				rtn = "White has a moderate time (development) advantage";
				break;
			}
			case 33:
			{
				rtn = "Black has a moderate time (development) advantage";
				break;
			}
			case 34:
			{
				rtn = "White has a decisive time (development) advantage";
				break;
			}
			case 35:
			{
				rtn = "Black has a decisive time (development) advantage";
				break;
			}
			case 36:
			{
				rtn = "White has the initiative";
				break;
			}
			case 37:
			{
				rtn = "Black has the initiative";
				break;
			}
			case 38:
			{
				rtn = "White has a lasting initiative";
				break;
			}
			case 39:
			{
				rtn = "Black has a lasting initiative";
				break;
			}
			case 40:
			{
				rtn = "White has the attack";
				break;
			}
			case 41:
			{
				rtn = "Black has the attack";
				break;
			}
			case 42:
			{
				rtn = "White has insufficient compensation for material deficit";
				break;
			}
			case 43:
			{
				rtn = "Black has insufficient compensation for material deficit";
				break;
			}
			case 44:
			{
				rtn = "White has sufficient compensation for material deficit";
				break;
			}
			case 45:
			{
				rtn = "Black has sufficient compensation for material deficit";
				break;
			}
			case 46:
			{
				rtn = "White has more than adequate compensation for material deficit";
				break;
			}
			case 47:
			{
				rtn = "Black has more than adequate compensation for material deficit";
				break;
			}
			case 48:
			{
				rtn = "White has a slight center control advantage";
				break;
			}
			case 49:
			{
				rtn = "Black has a slight center control advantage";
				break;
			}
			case 50:
			{
				rtn = "White has a moderate center control advantage";
				break;
			}
			case 51:
			{
				rtn = "Black has a moderate center control advantage";
				break;
			}
			case 52:
			{
				rtn = "White has a decisive center control advantage";
				break;
			}
			case 53:
			{
				rtn = "Black has a decisive center control advantage";
				break;
			}
			case 54:
			{
				rtn = "White has a slight kingside control advantage";
				break;
			}
			case 55:
			{
				rtn = "Black has a slight kingside control advantage";
				break;
			}
			case 56:
			{
				rtn = "White has a moderate kingside control advantage";
				break;
			}
			case 57:
			{
				rtn = "Black has a moderate kingside control advantage";
				break;
			}
			case 58:
			{
				rtn = "White has a decisive kingside control advantage";
				break;
			}
			case 59:
			{
				rtn = "Black has a decisive kingside control advantage";
				break;
			}
			case 60:
			{
				rtn = "White has a slight queenside control advantage";
				break;
			}
			case 61:
			{
				rtn = "Black has a slight queenside control advantage";
				break;
			}
			case 62:
			{
				rtn = "White has a moderate queenside control advantage";
				break;
			}
			case 63:
			{
				rtn = "Black has a moderate queenside control advantage";
				break;
			}
			case 64:
			{
				rtn = "White has a decisive queenside control advantage";
				break;
			}
			case 65:
			{
				rtn = "Black has a decisive queenside control advantage";
				break;
			}
			case 66:
			{
				rtn = "White has a vulnerable first rank";
				break;
			}
			case 67:
			{
				rtn = "Black has a vulnerable first rank";
				break;
			}
			case 68:
			{
				rtn = "White has a well protected first rank";
				break;
			}
			case 69:
			{
				rtn = "Black has a well protected first rank";
				break;
			}
			case 70:
			{
				rtn = "White has a poorly protected king";
				break;
			}
			case 71:
			{
				rtn = "Black has a poorly protected king";
				break;
			}
			case 72:
			{
				rtn = "White has a well protected king";
				break;
			}
			case 73:
			{
				rtn = "Black has a well protected king";
				break;
			}
			case 74:
			{
				rtn = "White has a poorly placed king";
				break;
			}
			case 75:
			{
				rtn = "Black has a poorly placed king";
				break;
			}
			case 76:
			{
				rtn = "White has a well placed king";
				break;
			}
			case 77:
			{
				rtn = "Black has a well placed king";
				break;
			}
			case 78:
			{
				rtn = "White has a very weak pawn structure";
				break;
			}
			case 79:
			{
				rtn = "Black has a very weak pawn structure";
				break;
			}
			case 80:
			{
				rtn = "White has a moderately weak pawn structure";
				break;
			}
			case 81:
			{
				rtn = "Black has a moderately weak pawn structure";
				break;
			}
			case 82:
			{
				rtn = "White has a moderately strong pawn structure";
				break;
			}
			case 83:
			{
				rtn = "Black has a moderately strong pawn structure";
				break;
			}
			case 84:
			{
				rtn = "White has a very strong pawn structure";
				break;
			}
			case 85:
			{
				rtn = "Black has a very strong pawn structure";
				break;
			}
			case 86:
			{
				rtn = "White has poor knight placement";
				break;
			}
			case 87:
			{
				rtn = "Black has poor knight placement";
				break;
			}
			case 88:
			{
				rtn = "White has good knight placement";
				break;
			}
			case 89:
			{
				rtn = "Bcase lack has good knight placement";
				break;
			}
			case 90:
			{
				rtn = "White has poor bishop placement";
				break;
			}
			case 91:
			{
				rtn = "Black has poor bishop placement";
				break;
			}
			case 92:
			{
				rtn = "White has good bishop placement";
				break;
			}
			case 93:
			{
				rtn = "Black has good bishop placement";
				break;
			}
			case 84:
			{
				rtn = "White has poor rook placement";
				break;
			}
			case 85:
			{
				rtn = "Black has poor rook placement";
				break;
			}
			case 86:
			{
				rtn = "White has good rook placement";
				break;
			}
			case 87:
			{
				rtn = "Black has good rook placement";
				break;
			}
			case 98:
			{
				rtn = "White has poor queen placement";
				break;
			}
			case 99:
			{
				rtn = "Black has poor queen placement";
				break;
			}
			case 100:
			{
				rtn = "White has good queen placement";
				break;
			}
			case 101:
			{
				rtn = "Black has good queen placement";
				break;
			}
			case 102:
			{
				rtn = "White has poor piece coordination";
				break;
			}
			case 103:
			{
				rtn = "Black has poor piece coordination";
				break;
			}
			case 104:
			{
				rtn = "White has good piece coordination";
				break;
			}
			case 105:
			{
				rtn = "Black has good piece coordination";
				break;
			}
			case 106:
			{
				rtn = "White has played the opening very poorly";
				break;
			}
			case 107:
			{
				rtn = "Black has played the opening very poorly";
				break;
			}
			case 108:
			{
				rtn = "White has played the opening poorly";
				break;
			}
			case 109:
			{
				rtn = "Black has played the opening poorly";
				break;
			}
			case 110:
			{
				rtn = "White has played the opening well";
				break;
			}
			case 111:
			{
				rtn = "Black has played the opening well";
				break;
			}
			case 112:
			{
				rtn = "White has played the opening very well";
				break;
			}
			case 113:
			{
				rtn = "Black has played the opening very well";
				break;
			}
			case 114:
			{
				rtn = "White has played the middlegame very poorly";
				break;
			}
			case 115:
			{
				rtn = "Black has played the middlegame very poorly";
				break;
			}
			case 116:
			{
				rtn = "White has played the middlegame poorly";
				break;
			}
			case 117:
			{
				rtn = "Black has played the middlegame poorly";
				break;
			}
			case 118:
			{
				rtn = "White has played the middlegame well";
				break;
			}
			case 119:
			{
				rtn = "Black has played the middlegame well";
				break;
			}
			case 120:
			{
				rtn = "White has played the middlegame very well";
				break;
			}
			case 121:
			{
				rtn = "Black has played the middlegame very well";
				break;
			}
			case 122:
			{
				rtn = "	White has played the ending very poorly";
				break;
			}
			case 123:
			{
				rtn = "Black has played the ending very poorly";
				break;
			}
			case 124:
			{
				rtn = "White has played the ending poorly";
				break;
			}
			case 125:
			{
				rtn = "Black has played the ending poorly";
				break;
			}
			case 126:
			{
				rtn = "White has played the ending well";
				break;
			}
			case 127:
			{
				rtn = "Black has played the ending well";
				break;
			}
			case 128:
			{
				rtn = "White has played the ending very well";
				break;
			}
			case 129:
			{
				rtn = "Black has played the ending very well";
				break;
			}
			case 130:
			{
				rtn = "White has slight counterplay";
				break;
			}
			case 131:
			{
				rtn = "Black has slight counterplay";
				break;
			}
			case 132:
			{
				rtn = "White has moderate counterplay";
				break;
			}
			case 133:
			{
				rtn = "Black has moderate counterplay";
				break;
			}
			case 134:
			{
				rtn = "White has decisive counterplay";
				break;
			}
			case 135:
			{
				rtn = "Black has decisive counterplay";
				break;
			}
			case 136:
			{
				rtn = "White has moderate time control pressure";
				break;
			}
			case 137:
			{
				rtn = "Black has moderate time control pressure";
				break;
			}
			case 138:
			{
				rtn = "White has severe time control pressure";
				break;
			}
			case 139:
			{
				rtn = "Black has severe time control pressure";
				break;
			}
			default :
				rtn = "";
		}
		return "";
	}
	
	//---------------------------------------------------------
	// Func: IOCCntryCodeLookup()
	// Desc: International Olympic Country Codes. 
	// Param: 
	// c: String, a IOC code to lookup, or country name
	// code: Boolean, true if you want to look up a code or 
	//	false if you want the country name.
	// return: The full country name or code for the IOC
	//	represents
	//---------------------------------------------------------
	public static function IOCCntryCodeLookup( c:String, code:Boolean ):String
	{
		var rtn:String = "Could not find " + c + " check your spelling.";
		var index1:Number = 0,
			index2:Number = 0;
		
		var cntryList:Array = [ "AFG:Afghanistan", "AIR:Aboard aircraft",	"ALB:Albania", "ALG:Algeria", "AND:Andorra", "ANG:Angola",
						  "ANT:Antigua","ARG:Argentina", "ARM:Armenia", "ATA:Antarctica", "AUS:Australia", "AZB:Azerbaijan",
						  "BAN:Bangladesh", "BAR:Bahrain", "BHM:Bahamas", "BEL:Belgium", "BER:Bermuda", "BIH:Bosnia and Herzegovina",
						  "BLA:Belarus", "BLG:Bulgaria", "BLZ:Belize", "BOL:Bolivia", "BRB:Barbados", "BRS:Brazil", "BRU:Brunei",
						  "BSW:Botswana", "CAN:Canada", "CHI:Chile", "COL:Columbia", "CRA:Costa Rica", "CRO:Croatia", "CSR:Czechoslovakia",
						  "CUB:Cuba", "CYP:Cyprus", "DEN:Denmark", "DOM:Dominican Republic", "ECU:Ecuador", "EGY:Egypt", "ENG:England",
						  "ESP:Spain", "EST:Estonia", "FAI:Faroe Islands", "FIJ:Fiji", "FIN:Finland", "FRA:France", "GAM:Gambia",
						  "GCI:Guernsey-Jersey", "GEO:Georgia", "GER:Germany", "GHA:Ghana", "GRC:Greece", "GUA:Guatemala", "GUY:Guyana",
						  "HAI:Haiti", "HKG:Hong Kong", "HON:Honduras", "HUN:Hungary", "IND:India", "IRL:Ireland", "IRN:Iran",
						  "IRQ:Iraq", "ISD:Iceland", "ISR:Israel", "ITA:Italy", "IVO:Ivory Coast", "JAM:Jamaica", "JAP:Japan", "JRD:Jordan",
						  "JUG:Yugoslavia", "KAZ:Kazakhstan", "KEN:Kenya", "KIR:Kyrgyzstan", "KUW:Kuwait", "LAT:Latvia", "LEB:Lebanon",
						  "LIB:Libya", "LIC:Liechtenstein", "LTU:Lithuania", "LUX:Luxembourg", "MAL:Malaysia", "MAU:Mauritania",
						  "MEX:Mexico", "MLI:Mali", "MLT:Malta", "MNC:Monaco", "MOL:Moldova", "MON:Mongolia", "MOZ:Mozambique", "MRC:Morocco",
						  "MRT:Mauritius", "MYN:Myanmar", "NCG:Nicaragua", "NET:The Internet", "NIG:Nigeria", "NLA:Netherlands Antilles",
						  "NLD:Netherlands", "NOR:Norway", "NZD:New Zealand", "OST:Austria", "PAK:Pakistan", "PAL:Palestine",
						  "PAN:Panama", "PAR:Paraguay", "PER:Peru", "PHI:Philippines", "PNG:Papua New Guinea", 	"POL:Poland",
						  "POR:Portugal", "PRC:People's Republic of China", "PRO:Puerto Rico", "QTR:Qatar", "RIN:Indonesia", "ROM:Romania",
						  "RUS:Russia", "SAF:South Africa", "SAL:El Salvador", "SCO:Scotland", "SEA:At Sea", "SEN:Senegal",
						  "SEY:Seychelles", "SIP:Singapore", "SLV:Slovenia", "SMA:San Marino", "SPC:Aboard spacecraft", "SRI:Sri Lanka",
						  "SUD:Sudan", "SUR:Surinam", "SVE:Sweden", "SWZ:Switzerland", "SYR:Syria", "TAI:Thailand", "TMT:Turkmenistan",
						  "TRK:Turkey", "TTO:Trinidad and Tobago", "TUN:Tunisia", "UAE:United Arab Emirates", "UGA:Uganda", "UKR:Ukraine",
						  "UNK:Unknown", "URU:Uruguay", "USA:United States of America", "UZB:Uzbekistan", "VEN:Venezuela",
						  "VGB:British Virgin Islands", "VIE:Vietnam", "VUS:U.S. Virgin Islands", "WLS:Wales", "YEM:Yemen", "YUG:Yugoslavia",
						 "ZAM:Zambia", "ZIM:Zimbabwe", "ZRE:Zaire"
						];
		
		if ( !code ) { index1 = 1; index2 = 0; }
		
		for ( var i:Number = 0, tmp = String(cntryList[i]).split(":"); i < cntryList.length; i++ )
		{
			tmp = String(cntryList[i]).split(":");
			 if ( tmp[index1] == c )
				return tmp[index2];
		}

		return rtn;
	}
	
	//--------------------
	// Private Methods
	//--------------------
	
	//--------------------
	// Private Members
	//--------------------
	private var m_strTagName:String = null;
	private var m_strTagData:String = null;
}

/*
International Olympic Committee country codes
Table 1. Country codes and names
Code	Name
AFG	Afghanistan
AIR	Aboard aircraft
ALB	Albania
ALG	Algeria
AND	Andorra
ANG	Angola
ANT	Antigua
ARG	Argentina
ARM	Armenia
ATA	Antarctica
AUS	Australia
AZB	Azerbaijan
BAN	Bangladesh
BAR	Bahrain
BHM	Bahamas
BEL	Belgium
BER	Bermuda
BIH	Bosnia and Herzegovina
BLA	Belarus
BLG	Bulgaria
BLZ	Belize
BOL	Bolivia
BRB	Barbados
BRS	Brazil
BRU	Brunei
BSW	Botswana
CAN	Canada
CHI	Chile
COL	Columbia
CRA	Costa Rica
CRO	Croatia
CSR	Czechoslovakia
CUB	Cuba
CYP	Cyprus
DEN	Denmark
DOM	Dominican Republic
ECU	Ecuador
EGY	Egypt
ENG	England
ESP	Spain
EST	Estonia
FAI	Faroe Islands
FIJ	Fiji
FIN	Finland
FRA	France
GAM	Gambia
GCI	Guernsey-Jersey
GEO	Georgia
GER	Germany
GHA	Ghana
GRC	Greece
GUA	Guatemala
GUY	Guyana
HAI	Haiti
HKG	Hong Kong
HON	Honduras
HUN	Hungary
IND	India
IRL	Ireland
IRN	Iran
IRQ	Iraq
ISD	Iceland
ISR	Israel
ITA	Italy
IVO	Ivory Coast
JAM	Jamaica
JAP	Japan
JRD	Jordan
JUG	Yugoslavia
KAZ	Kazakhstan
KEN	Kenya
KIR	Kyrgyzstan
KUW	Kuwait
LAT	Latvia
LEB	Lebanon
LIB	Libya
LIC	Liechtenstein
LTU	Lithuania
LUX	Luxembourg
MAL	Malaysia
MAU	Mauritania
MEX	Mexico
MLI	Mali
MLT	Malta
MNC	Monaco
MOL	Moldova
MON	Mongolia
MOZ	Mozambique
MRC	Morocco
MRT	Mauritius
MYN	Myanmar
NCG	Nicaragua
NET	The Internet
NIG	Nigeria
NLA	Netherlands Antilles
NLD	Netherlands
NOR	Norway
NZD	New Zealand
OST	Austria
PAK	Pakistan
PAL	Palestine
PAN	Panama
PAR	Paraguay
PER	Peru
PHI	Philippines
PNG	Papua New Guinea
POL	Poland
POR	Portugal
PRC	People's Republic of China
PRO	Puerto Rico
QTR	Qatar
RIN	Indonesia
ROM	Romania
RUS	Russia
SAF	South Africa
SAL	El Salvador
SCO	Scotland
SEA	At Sea
SEN	Senegal
SEY	Seychelles
SIP	Singapore
SLV	Slovenia
SMA	San Marino
SPC	Aboard spacecraft
SRI	Sri Lanka
SUD	Sudan
SUR	Surinam
SVE	Sweden
SWZ	Switzerland
SYR	Syria
TAI	Thailand
TMT	Turkmenistan
TRK	Turkey
TTO	Trinidad and Tobago
TUN	Tunisia
UAE	United Arab Emirates
UGA	Uganda
UKR	Ukraine
UNK	Unknown
URU	Uruguay
USA	United States of America
UZB	Uzbekistan
VEN	Venezuela
VGB	British Virgin Islands
VIE	Vietnam
VUS	U.S. Virgin Islands
WLS	Wales
YEM	Yemen
YUG	Yugoslavia
ZAM	Zambia
ZIM	Zimbabwe
ZRE	Zaire 
*/