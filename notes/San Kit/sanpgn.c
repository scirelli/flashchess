/*>>> sanpgn.c: SAN project PGN (Portable Game Notation) output routines */

/* Revised: 1993.05.16 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#include "sandef.h"
#include "sanvar.h"

#include "sandsp.h"
#include "sanmne.h"
#include "sanpgn.h"
#include "sanrst.h"
#include "santag.h"
#include "sanutl.h"

/*** Locals */

/* the output file of interest */

static FILEptrT gms_fptr;

/* the current character column */

static siT col;

/*--> SANPGNSetUp: set up game move score processing */
static
void
SANPGNSetUp(FILEptrT fptr)
{
gms_fptr = fptr;
col = 0;

return;
}

/*--> SANPGNNL: produce newline */
static
void
SANPGNNL(void)
{
SANGateChar(gms_fptr, '\n');
col = 0;

return;
}

/*--> SANPGNResTag: produce reserved tag output line */
static
void
SANPGNResTag(rsvtagT rsvtag)
{
charptrT s;

s = SANTagFormat(SANTagLocate(rsvtagv[rsvtag]));
SANGateStr(gms_fptr, s);
SANGateChar(gms_fptr, '\n');
SANMemFree(s);

return;
}

/*--> SANPGNWrapStr: produce wrapped string w/possibly prepended space */
static
void
SANPGNWrapStr(charptrT s)
{
siT length;

length = strlen(s);
if (col == 0)
	col = length;
else
	if ((col + 1 + length) < 80)
		{
		SANGateChar(gms_fptr, ' ');
		col += (1 + length);
		}
	else
		{
		SANPGNNL();
		col = length;
		};
SANGateStr(gms_fptr, s);

return;
}

/*--> SANPGNScore: produce game score */
static
void
SANPGNScore(void)
{
siT first, hcn;
hptrT hptr;
sanT san;

first = 1;
hcn = 0;
hptr = hbase;

while (hcn < hn)
	{
	if (first || (hptr->h_e.e_actc == c_w))
		{
		(void) sprintf(stv, "%hd.", hptr->h_e.e_fmvn);
		SANPGNWrapStr(stv);
		};

	if (first && (hptr->h_e.e_actc == c_b))
		SANPGNWrapStr("...");

	first = 0;

	SANEncode(&hptr->h_m, san);
	SANPGNWrapStr(san);

	hcn++;
	hptr++;
	};

if (gtc == gtc_norm)
	SANPGNWrapStr(gtcstrv[cv_gtc_gsv[SANStatus()]]);
else
	SANPGNWrapStr(gtcstrv[gtc]);

if (col != 0)
	SANPGNNL();

return;
}

/*--> SANPGNCorrespondenceReport: produce correspondence report to file */
nonstatic
void
SANPGNCorrespondenceReport(FILEptrT fptr)
{
rankT rank;
fileT file;
cpT cp;

SANPGNSetUp(fptr);

/* output color tags */

SANPGNResTag(rsvtag_white);
SANPGNResTag(rsvtag_black);
SANPGNNL();

/* output game score */

SANPGNScore();
SANPGNNL();

/* output board */

for (rank = rank_8; rank >= rank_1; rank--)
	{
	for (file = file_a; file <= file_h; file++)
		if ((cp = gb.bm[rank][file]) == cp_v0)
			if ((rank & bit) == (file & bit))
				SANGateStr(gms_fptr, "::");
			else
				SANGateStr(gms_fptr, "  ");
		else
			{
			SANGateChar(gms_fptr, accv[cv_c_cpv[cp]]);
			SANGateChar(gms_fptr, acpv[cv_p_cpv[cp]]);
			};
	SANPGNNL();
	};
SANPGNNL();

return;
}

/*--> SANPGNEventReport: produce event report to file */
nonstatic
void
SANPGNEventReport(FILEptrT fptr)
{
rsvtagT rsvtag;

SANPGNSetUp(fptr);

/* output event tags */

for (rsvtag = 0; rsvtag < rsvtagL; rsvtag++)
	SANPGNResTag(rsvtag);
SANPGNNL();

/* output game score */

SANPGNScore();
SANPGNNL();

return;
}

/*<<< sanpgn.c: EOF */
