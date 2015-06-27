/*>>> sanrdr.c: SAN project game reading with PGN */

/* Revised: 1994.02.19 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>

#include "sandef.h"
#include "sanvar.h"

#include "sandsp.h"
#include "sanepd.h"
#include "sangtc.h"
#include "sanint.h"
#include "sanmnd.h"
#include "sanmne.h"
#include "sanmpu.h"
#include "sanmsc.h"
#include "sanpgc.h"
#include "sanpgn.h"
#include "sanrdr.h"
#include "santag.h"
#include "sanutl.h"

#if (defined(THINK_C))
pascal void SystemTask(void) = 0xA9B4;
#endif

/**** Locals */

/* the game score token type */

#define gstL 12

typedef siT gstT;

#define gst_nil	(-1)

#define gst_eof     0 /* EOF */
#define gst_error   1 /* error */
#define gst_gtim    2 /* game termination indicator marker */
#define gst_lbrack  3 /* left bracket */
#define gst_lparen  4 /* left parenthesis */
#define gst_nag     5 /* numeric annotation glyph */
#define gst_period  6 /* period */
#define gst_pline   7 /* percent sign directive line */
#define gst_rbrack  8 /* right bracket */
#define gst_rparen  9 /* right parenthesis */
#define gst_string 10 /* string */
#define gst_symbol 11 /* symbol */

/* the game reader translation mode */

static grtmT gs_grtm;

/* the file pointer for reading the game score */

static FILEptrT gpar_fptr;

/* the file pointer for writing games and game variations */

static FILEptrT gvar_fptr;

/* token information returned by the lexer */

static gstT gst;
static gtimT gsf_gtim;
static charptrT gsf_sptr;
static siT gsf_nag;

/* the game score current character */

static siT gsf_char;

/* the "game finished" indicator */

static siT gst_done;

/* the number of games processed */

static siT gsf_gn;

/* the number of moves in scanned game */

static siT gsf_mvc;

/* the number of forms in scanned game */

static siT gsf_fmc;

/* the count of newline characters */

static siT gsf_cnl;

/* the line number of the current token start */

static siT gsf_tln;

/* the character column count */

static siT gsf_ccc;

/* forward declarations */

static siT SANRGParseForm(void);

/*--> SANRGSetGRTM: set the game reader translation mode */
nonstatic
void
SANRGSetGRTM(grtmT grtm)
{
gs_grtm = grtm;

return;
}

/*--> SANRGInteger: test string for integer status */
static
siT
SANRGInteger(void)
{
siT flag, length, i;

if ((length = strlen(gsf_sptr)) == 0)
	flag = 0;
else
	{
	flag = 1;
	i = 0;
	while (flag && (i < length))
		if (isdigit(*(gsf_sptr + i)))
			i++;
		else
			flag = 0;
	};

return (flag);
}

/*--> SANRGClass0: test character for class zero (digits) */
static
siT
SANRGClass0(void)
{
siT flag;

if ((gsf_char != EOF) && isdigit(gsf_char))
	flag = 1;
else
	flag = 0;

return (flag);
}

/*--> SANRGClass1: test character for class one (symbol characters) */
static
siT
SANRGClass1(void)
{
  siT flag;

  if (gsf_char == EOF)
    flag = 0;
  else
    if (isalnum(gsf_char))
      flag = 1;
    else
      switch (gsf_char)
	{
	case '+':
	case '-':
	case '*':
	case '/':
	case '=':
	case '#':
	case ':':
	  flag = 1;
	  break;

	default:
	  flag = 0;
	  break;
	};

  return (flag);
}

/*--> SANRGClass2: test character for class two (string characters) */
static
siT
SANRGClass2(void)
{
siT flag;

if (gsf_char == EOF)
	flag = 0;
else
	if (SANRGClass1())
		flag = 1;
	else
		if ((gsf_char >= 0x20) && (gsf_char <= 0x7e) && (gsf_char != '"'))
			flag = 1;
		else
			flag = 0;

return (flag);
}

/*--> SANRGChar: read a character from the game score file */
static
void
SANRGChar(void)
{
if (gsf_char == '\n')
	gsf_ccc = 0;

if (gsf_char != EOF)
	{
	gsf_char = fgetc(gpar_fptr);
	if (gsf_char != EOF)
		gsf_ccc++;
	};

if (gsf_char == '\n')
	gsf_cnl++;

return;
}

/*--> SANRGToken: read a game score token from a file */
static
void
SANRGToken(void)
{
  siT i;
  liT bracecount;

  gst = gst_nil;
  while (gst == gst_nil)
    {
      gsf_tln = gsf_cnl;
      if (gsf_char == EOF)
	gst = gst_eof;
      else
	switch (gsf_char)
	  {
	  case ' ':
	  case '\t':
	  case '\n':
	    SANRGChar();
	    break;

	  case ';':
	    SANRGChar();
	    while ((gsf_char != EOF) && (gsf_char != '\n'))
	      SANRGChar();
	    if (gsf_char == '\n')
	      SANRGChar();
	    break;

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

	  case '[':
	    gst = gst_lbrack;
	    SANRGChar();
	    break;

	  case '(':
	    gst = gst_lparen;
	    SANRGChar();
	    break;

	  case '.':
	    gst = gst_period;
	    SANRGChar();
	    break;

	  case ']':
	    gst = gst_rbrack;
	    SANRGChar();
	    break;

	  case ')':
	    gst = gst_rparen;
	    SANRGChar();
	    break;

	  case '%':
	    if (gsf_ccc != 1)
	      gst = gst_error;
	    else
	      {
		gst = gst_pline;
		i = 0;
		*(gsf_sptr + i++) = gsf_char;
		SANRGChar();
		while ((gsf_char != EOF) && (gsf_char != '\n'))
		  {
		    if (i < (tL - 1))
		      *(gsf_sptr + i++) = gsf_char;
		    SANRGChar();
		  };
		*(gsf_sptr + i) = '\0';
	      };
	    break;

	  case '\x24': /* dollar sign */
	    SANRGChar();
	    if (!SANRGClass0())
	      gst = gst_error;
	    else
	      {
		gst = gst_nag;
		gsf_nag = gsf_char - '0';
		SANRGChar();
		while (SANRGClass0())
		  {
		    gsf_nag = (gsf_nag * 10) + (gsf_char - '0');
		    SANRGChar();
		  };
	      };

	    break;

	  case '"':
	    SANRGChar();
	    i = 0;
	    while (SANRGClass2())
	      {
		if (i < (tL - 1))
		  *(gsf_sptr + i++) = gsf_char;
		SANRGChar();
	      };
	    *(gsf_sptr + i) = '\0';
	    if (gsf_char == '"')
	      {
		gst = gst_string;
		SANRGChar();
	      }
	    else
	      gst = gst_error;
	    break;

	  default:
	    if (!SANRGClass1())
	      {
		(void) sprintf(stv,
			       "Spurious character (0x%02x) at line %hd ignored",
			       gsf_char, (gsf_tln + 1));
		SANDspSTVNL();
		SANRGChar();
	      }
	    else
	      {
		i = 0;
		while (SANRGClass1())
		  {
		    if (i < (tL - 1))
		      *(gsf_sptr + i++) = gsf_char;
		    SANRGChar();
		  };
		*(gsf_sptr + i) = '\0';
		gsf_gtim = SANMatchGTIM(gsf_sptr);
		if (gsf_gtim != gtim_nil)
		  gst = gst_gtim;
		else
		  gst = gst_symbol;
	      };
	    break;
	  };
    };

  return;
}

/*--> SANRGFileStart: start processing for an input file */
static
siT
SANRGFileStart(charptrT fn)
{
siT flag;

/* clear the counters */

gsf_gn = 0;
gsf_cnl = 0;
gsf_tln = 0;
gsf_ccc = 0;

/* get a text buffer */

gsf_sptr = (charptrT) SANMemGrab(tL);

/* open the input file */

if ((gpar_fptr = SANTextFileOpen(fn, "r")) == NULL)
	flag = 0;
else
	flag = 1;

/* initialize the lexer */

if (flag)
	{
	gsf_char = '\0';
	SANRGChar();
	SANRGToken();
	};

return (flag);
}

/*--> SANRGFileFinish: finish processing for an input file */
static
void
SANRGFileFinish(void)
{
if (gpar_fptr != NULL)
	{
	SANTextFileClose(gpar_fptr);
	gpar_fptr = NULL;
	};

if (gsf_sptr != NULL)
	{
	SANMemFree(gsf_sptr);
	gsf_sptr = NULL;
	};

return;
}

/*--> SANRGError: report a scanning error */
static
void
SANRGError(charptrT s)
{
(void) sprintf(stv, "%s at line %hd\n", s, (gsf_tln + 1));
SANDspErrorSTV();

return;
}

/*--> SANRGParseSymbol: parse a symbol */
static
siT
SANRGParseSymbol(void)
{
siT flag, mn;
mptrT mptr;

/* try a move number first */

if (SANRGInteger())
	{
	mn = 0;
	(void) sscanf(gsf_sptr, "%hd", &mn);
	if (mn == curr_e.e_fmvn)
		{
		flag = 1;
		SANRGToken();
		}
	else
		{
		SANRGError("Unexpected integer");
		flag = 0;
		};
	}
else
	{
	/* not a move number, try a move */

	mptr = SANDecodeAux(gsf_sptr);
	if (mptr != NULL)
		{
		flag = 1;
		SANRGToken();
		SANPlayMove(mptr);
		gsf_mvc++;
		}
	else
		{
		SANRGError("undecipherable symbol");
		flag = 0;
		};
	};

return (flag);
}

/*--> SANRGParseTag: parse a tag directive */
static
siT
SANRGParseTag(void)
{
  siT flag;
  charptrT tnptr, tvptr;
  tagptrT tagptr;

  /* set default return value */

  flag = 1;

  /* skip to label */

  SANRGToken();
  if (gst != gst_symbol)
    {
      SANRGError("Expected symbol");
      flag = 0;
    }
  else
    {
      tnptr = SANStrGrab(gsf_sptr);
      tvptr = NULL;
      SANRGToken();
      if (gst == gst_rbrack)
	{
	  SANRGToken();
	  tagptr = SANTagLocate(tnptr);
	  if ((tagptr != NULL) &&
	      !(tagptr->tag_flag & tagf_perm))
	    SANTagDelete(tagptr);
	}
      else
	{
	  if ((gst == gst_string) || (gst == gst_symbol))
	    {
	      /* copy the input string and advance to next token */

	      tvptr = SANStrGrab(gsf_sptr);
	      SANRGToken();

	      /* process concluding bracket */

	      if (gst == gst_rbrack)
		{
		  SANRGToken();
		  tagptr = SANTagLocate(tnptr);
		  if (tagptr == NULL)
		    {
		      tagptr = SANTagCreate(tnptr, "", 0);
		      SANTagInsert(tagptr);
		    }
		  SANTagUpdate(tagptr, tvptr);
		}
	      else
		{
		  SANRGError("Expected ']'");
		  flag = 0;
		};

	      /* release string */

	      SANMemFree(tvptr);
	    }
	  else
	    {
	      SANRGError("Expected string, symbol, or ']'");
	      flag = 0;
	    };
	};
      SANMemFree(tnptr);
    };

  return (flag);
}

/*--> SANRGParseGTIM: parse a game termination indicator marker */
static
siT
SANRGParseGTIM(void)
{
  siT flag;
  gtcT local_gtc;

  /* set default return value */

  flag = 1;

  /* handle gtim token */

  local_gtc = SANGTCDetermine(gsf_gtim);
  if (SANGTCConsistent(local_gtc))
    {
      SANGTCSet(local_gtc);
      SANTagUpdate(SANTagLocate(rsvtagv[rsvtag_result]), gtcstrv[local_gtc]);
      SANRGToken();
      gst_done = 1;
    }
  else
    {
      (void) sprintf(stv, "%s (%s) at line %hd",
		     "Improper game termination marker", gsf_sptr, (gsf_tln + 1));
      SANDspNote(stv);
      if ((hn > 0) &&
	  (((curr_e.e_actc == c_w) && (local_gtc == gtc_wwin)) ||
	   ((curr_e.e_actc == c_b) && (local_gtc == gtc_bwin))))
	{
	  SANDspNote("Deleting last move made");
	  SANUnplayMove();
	  gsf_mvc--;
	  SANGTCSet(local_gtc);
	  SANTagUpdate(SANTagLocate(rsvtagv[rsvtag_result]),
		       gtcstrv[local_gtc]);
	  SANRGToken();
	  gst_done = 1;
	}
      else
	{
	  SANDspError("Unable to correct game termination");
	  flag = 0;
	};
    };

  return (flag);
}

/*--> SANRGParseList: parse a parenthesized move list */
static
siT
SANRGParseList(void)
{
siT flag;

/* set default return value */

flag = 1;

/* scan */

SANRGToken();
while (flag && (gst != gst_eof) && (gst != gst_rparen))
	flag = SANRGParseForm();

/* conclude */

if (flag && (gst == gst_rparen))
	SANRGToken();
else
	{
	SANRGError("Unmatched parenthesis");
	flag = 0;
	};

return (flag);
}

/*--> SANRGParseNAG: parse a Numeric Annotation Glyph */
static
siT
SANRGParseNAG(void)
{
siT flag;

flag = 1;
SANRGToken();

return (flag);
}

/*--> SANRGParsePLine: parse a percent line */
static
siT
SANRGParsePLine(void)
{
siT flag;

flag = 1;
SANRGToken();

return (flag);
}

/*--> SANRGParseForm: parse a game form */
static
siT
SANRGParseForm(void)
{
  siT flag;

  /* set default return value */

  flag = 1;

  /* switch according to string match */

  switch (gst)
    {
    case gst_eof:
      gst_done = 1;
      break;

    case gst_error:
      SANRGError("Lexical error");
      flag = 0;
      break;

    case gst_gtim:
      flag = SANRGParseGTIM();
      break;

    case gst_lbrack:
      flag = SANRGParseTag();
      break;

    case gst_lparen:
      flag = SANRGParseList();
      break;

    case gst_nag:
      flag = SANRGParseNAG();
      break;

    case gst_period:
      SANRGToken();
      break;

    case gst_pline:
      flag = SANRGParsePLine();
      break;

    case gst_rbrack:
      SANRGError("Unexpected ']'");
      flag = 0;
      break;

    case gst_rparen:
      SANRGError("Unexpected ')'");
      flag = 0;
      break;

    case gst_string:
      SANRGError("Unexpected string");
      flag = 0;
      break;

    case gst_symbol:
      flag = SANRGParseSymbol();
      break;

    default:
      SANSwitchFault("SANRGParseForm");
      break;
    };

  if (flag && (gst != gst_eof))
    gsf_fmc++;

  return (flag);
}

/*--> SANRGParseGame: parse a single game sequence from the current file */
static
siT
SANRGParseGame(void)
{
siT flag;

#if (defined(THINK_C))
SystemTask();
#endif

/* set default return value */

flag = 1;

/* prepare for scan */

SANInitGround();
SANTagClearAll();
gst_done = 0;
gsf_mvc = 0;
gsf_fmc = 0;

/* scan */

while (flag && !gst_done)
	flag = SANRGParseForm();

/* check for game termination to make a game */

if (gtc != gtc_norm)
	{
	gsf_gn++;
	if (optnv[optn_verb])
		SANDspStrSINL("Finished translation for game number: ", gsf_gn);
	};

return (flag);
}

/*--> SANRGWriteEPD: output the current game EPD */
static
void
SANRGWriteEPD(void)
{
siT i, n;
sqT sq;
hptrT hptr;
charptrT ptr;
bT b;

hptr = hbase;
n = hn;
for (i = 0; i < hn; i++)
	{
	for (sq = sq_a1; sq <= sq_h8; sq++)
		{
		if ((sq % 2) == 0)
			b.bv[sq] = (hptr->h_z[sq / 2] & 0x0f);
		else
			b.bv[sq] = ((hptr->h_z[sq / 2] >> 4) & 0x0f);
		};
	ptr = SANEPDGenBasic(&b,
		hptr->h_e.e_actc, hptr->h_e.e_cast, hptr->h_e.e_epsq);
	fprintf(gvar_fptr, "%s\n", ptr);
	SANMemFree(ptr);
	hptr++;
	};

ptr = SANEPDGenBasic(&gb, curr_e.e_actc, curr_e.e_cast, curr_e.e_epsq);
fprintf(gvar_fptr, "%s\n", ptr);
SANMemFree(ptr);

return;
}

/*--> SANRGWriteVariation: output the current game variation */
static
void
SANRGWriteVariation(void)
{
siT i, n;
hptrT hptr;
mT m;
sanT san;

(void) fputc('(', gvar_fptr);

hptr = hbase;
n = hn;
for (i = 0; i < hn; i++)
	{
	m = hptr->h_m;
	SANEncode(&m, san);
	(void) fprintf(gvar_fptr, "%s", san);
	if (i < (n - 1))
		(void) fputc(' ', gvar_fptr);
	hptr++;
	};

(void) fputc(')', gvar_fptr);
(void) fprintf(gvar_fptr, " ; %s", gtcstrv[gtc]);
(void) fputc('\n', gvar_fptr);

return;
}

/*--> SANRGSingle: read a single game score given a file name */
nonstatic
siT
SANRGSingle(charptrT fn, siptrT gnptr)
{
siT flag;

/* Initialize */

flag = SANRGFileStart(fn);

/* scan */

if (flag)
	flag = SANRGParseGame();

/* finish input file */

SANRGFileFinish();

/* assign game read count */

*gnptr = gsf_gn;

return (flag);
}

/*--> SANRGMultiple: read multiple game scores and produce translation */
nonstatic
siT
SANRGMultiple(charptrT fn0, charptrT fn1, siptrT gnptr)
{
  siT flag, done;

  /* initialize the input file */

  flag = SANRGFileStart(fn0);

  /* initialize the output file */

  if (flag)
    {
      gvar_fptr = SANTextFileOpen(fn1, "w");
      if (gvar_fptr == NULL)
	flag = 0;
    };

  /* scan */

  done = 0;
  while (flag && !done)
    {
      flag = SANRGParseGame();

      if (flag && (gsf_fmc == 0))
	done = 1;

      if (flag && !done)
	switch (gs_grtm)
	  {
	  case grtm_epd:
	    SANRGWriteEPD();
	    break;

	  case grtm_pgc:
	    SANPGCWriteCurrent(gvar_fptr);
	    break;

	  case grtm_pgn:
	    SANPGNEventReport(gvar_fptr);
	    break;

	  case grtm_var:
	    SANRGWriteVariation();
	    break;

	  default:
	    SANSwitchFault("SANRGMultiple");
	    break;
	  };
    };

  /* finish output file */

  if (gvar_fptr != NULL)
    {
      SANTextFileClose(gvar_fptr);
      gvar_fptr = NULL;
    };

  /* finish input file */

  SANRGFileFinish();

  /* reset */

  SANInitGround();

  /* assign game read count */

  *gnptr = gsf_gn;

  return (flag);
}

/*<<< sanrdr.c: EOF */
