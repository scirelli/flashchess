/*>>> sanmne.c: SAN project move notation encode routines */

/* Revised: 1993.05.16 */

#include <stdio.h>
#include <stddef.h>
#include <ctype.h>
#include <time.h>

#include "sandef.h"
#include "sanvar.h"

#include "sanmne.h"
#include "sanutl.h"

/**** Locals */

/* local copy of san vector and index */

static sanT lsan;
static siT lsani;

/*--> SANEncodeChar: encode SAN character */
static
void
SANEncodeChar(char ch)
{
if ((lsani < (sanL - 1)) || ((ch == '\0') && (lsani < sanL)))
	lsan[lsani++] = ch;
else
	SANFatal("SANEncodeChar: overflow");

return;
}

/*--> SANEncodeStr: encode a SAN string */
static
void
SANEncodeStr(charptrT s)
{
charptrT p;

p = s;
while (*p)
	SANEncodeChar(*p++);

return;
}

/*--> SANEncodeFile: encode SAN file from square */
static
void
SANEncodeFile(sqT sq)
{
SANEncodeChar(acfv[map_file_sq(sq)]);

return;
}

/*--> SANEncodeRank: encode SAN rank from square */
static
void
SANEncodeRank(sqT sq)
{
SANEncodeChar(acrv[map_rank_sq(sq)]);

return;
}

/*--> SANEncodeSq: encode SAN square */
static
void
SANEncodeSq(sqT sq)
{
SANEncodeFile(sq);
SANEncodeRank(sq);

return;
}

/*--> SANEncodeCI: encode an appropriate capture indicator */
static
void
SANEncodeCI(siT index)
{
switch (index)
	{
	case 0:
		SANEncodeChar('x');
		break;

	case 1:
		break;

	case 2:
		SANEncodeChar(':');
		break;

	case 3:
		SANEncodeChar('*');
		break;

	case 4:
		SANEncodeChar('-');
		break;
	};

return;
}
	
/*--> SANEncodeAux: encode SAN format move with variants */
nonstatic
void
SANEncodeAux(mptrT mptr, sanT san, ssavT ssav)
{
siT i;

/* reset local index */

lsani = 0;

/* busted? */

if (mptr->m_flag & mf_bust)
	SANEncodeChar('*');

/* process according to moving piece */

switch (cv_p_cpv[mptr->m_frcp])
	{
	case p_p:
		switch (mptr->m_scmv)
			{
			case scmv_reg:
				if (mptr->m_tocp != cp_v0)
					{
					SANEncodeFile(mptr->m_frsq);
					if (ssav[ssa_edcr] == 1)
						SANEncodeRank(mptr->m_frsq);
					SANEncodeCI(ssav[ssa_capt]);
					if (ssav[ssa_ptar] == 0)
						SANEncodeSq(mptr->m_tosq);
					else
						SANEncodeFile(mptr->m_tosq);
					}
				else
					{
					SANEncodeFile(mptr->m_frsq);
					if (ssav[ssa_edcr] == 1)
						SANEncodeRank(mptr->m_frsq);
					if (ssav[ssa_move] == 1)
						SANEncodeChar('-');
					if (ssav[ssa_edcf] == 1)
						SANEncodeFile(mptr->m_tosq);
					SANEncodeRank(mptr->m_tosq);
					};
				break;

			case scmv_epc:
				SANEncodeFile(mptr->m_frsq);
				if (ssav[ssa_edcr] == 1)
					SANEncodeRank(mptr->m_frsq);
				SANEncodeCI(ssav[ssa_capt]);
				if (ssav[ssa_ptar] == 0)
					SANEncodeSq(mptr->m_tosq);
				else
					SANEncodeFile(mptr->m_tosq);
				if (ssav[ssa_epct] == 1)
					SANEncodeStr("ep");
				break;

			case scmv_ppn:
			case scmv_ppb:
			case scmv_ppr:
			case scmv_ppq:
				if (mptr->m_tocp != cp_v0)
					{
					SANEncodeFile(mptr->m_frsq);
					if (ssav[ssa_edcr] == 1)
						SANEncodeRank(mptr->m_frsq);
					SANEncodeCI(ssav[ssa_capt]);
					if (ssav[ssa_ptar] == 0)
						SANEncodeSq(mptr->m_tosq);
					else
						SANEncodeFile(mptr->m_tosq);
					}
				else
					{
					SANEncodeFile(mptr->m_frsq);
					if (ssav[ssa_edcr] == 1)
						SANEncodeRank(mptr->m_frsq);
					if (ssav[ssa_move] == 1)
						SANEncodeChar('-');
					if (ssav[ssa_edcf] == 1)
						SANEncodeFile(mptr->m_tosq);
					SANEncodeRank(mptr->m_tosq);
					};
				switch (ssav[ssa_prom])
					{
					case 0:
						SANEncodeChar('=');
						SANEncodeChar(acpv[cv_p_scmvv[mptr->m_scmv]]);
						break;
					case 1:
						SANEncodeChar(acpv[cv_p_scmvv[mptr->m_scmv]]);
						break;
					case 2:
						SANEncodeChar('/');
						SANEncodeChar(acpv[cv_p_scmvv[mptr->m_scmv]]);
						break;
					case 3:
						SANEncodeChar('(');
						SANEncodeChar(acpv[cv_p_scmvv[mptr->m_scmv]]);
						SANEncodeChar(')');
						break;
					};
				break;
			};
		break;

	case p_n:
	case p_b:
	case p_r:
	case p_q:
		SANEncodeChar(acpv[cv_p_cpv[mptr->m_frcp]]);
		if ((mptr->m_flag & mf_sanf) || (ssav[ssa_edcf] == 1))
			SANEncodeFile(mptr->m_frsq);
		if ((mptr->m_flag & mf_sanr) || (ssav[ssa_edcr] == 1))
			SANEncodeRank(mptr->m_frsq);
		if (mptr->m_tocp != cp_v0)
			SANEncodeCI(ssav[ssa_capt]);
		else
			if (ssav[ssa_move] == 1)
				SANEncodeChar('-');
		SANEncodeSq(mptr->m_tosq);
		break;

	case p_k:
		switch (mptr->m_scmv)
			{
			case scmv_reg:
				SANEncodeChar(acpv[p_k]);
				if (ssav[ssa_edcf] == 1)
					SANEncodeFile(mptr->m_frsq);
				if (ssav[ssa_edcr] == 1)
					SANEncodeRank(mptr->m_frsq);
				if (mptr->m_tocp != cp_v0)
					SANEncodeCI(ssav[ssa_capt]);
				else
					if (ssav[ssa_move] == 1)
						SANEncodeChar('-');
				SANEncodeSq(mptr->m_tosq);
				break;

			case scmv_cks:
				switch (ssav[ssa_cast])
					{
					case 0:
						SANEncodeStr("O-O");
						break;
					case 1:
						SANEncodeStr("0-0");
						break;
					case 2:
						SANEncodeStr("OO");
						break;
					case 3:
						SANEncodeStr("00");
						break;
					case 4:
						SANEncodeChar(acpv[p_k]);
						if (ssav[ssa_edcf] == 1)
							SANEncodeFile(mptr->m_frsq);
						if (ssav[ssa_edcr] == 1)
							SANEncodeRank(mptr->m_frsq);
						if (ssav[ssa_move] == 1)
							SANEncodeChar('-');
						SANEncodeSq(mptr->m_tosq);
						break;
					};
				break;

			case scmv_cqs:
				switch (ssav[ssa_cast])
					{
					case 0:
						SANEncodeStr("O-O-O");
						break;
					case 1:
						SANEncodeStr("0-0-0");
						break;
					case 2:
						SANEncodeStr("OOO");
						break;
					case 3:
						SANEncodeStr("000");
						break;
					case 4:
						SANEncodeChar(acpv[p_k]);
						if (ssav[ssa_edcf] == 1)
							SANEncodeFile(mptr->m_frsq);
						if (ssav[ssa_edcr] == 1)
							SANEncodeRank(mptr->m_frsq);
						if (ssav[ssa_move] == 1)
							SANEncodeChar('-');
						SANEncodeSq(mptr->m_tosq);
						break;
					};
				break;
			};
		break;
	};

/* insert markers */

if ((mptr->m_flag & mf_chec) && !(mptr->m_flag & mf_chmt))
	switch (ssav[ssa_chec])
		{
		case 0:
			SANEncodeChar('+');
			break;
		case 1:
			break;
		case 2:
			SANEncodeStr("ch");
			break;
		};

if (mptr->m_flag & mf_chmt)
	switch (ssav[ssa_chmt])
		{
		case 0:
			SANEncodeChar('#');
			break;
		case 1:
			break;
		case 2:
			SANEncodeChar('+');
			break;
		case 3:
			SANEncodeStr("++");
			break;
		};

if (mptr->m_flag & mf_draw)
	if (ssav[ssa_draw] == 1)
		SANEncodeChar('=');

/* map to lower case if indicated */

if (ssav[ssa_case] == 1)
	for (i = 0; i < lsani; i++)
		lsan[i] = map_lower(lsan[i]);

/* pad and copy */

while (lsani < sanL)
	SANEncodeChar('\0');

for (i = 0; i < sanL; i++)
	san[i] = lsan[i];

return;
}

/*--> SANEncode: encode a move into a SAN string */
nonstatic
void
SANEncode(mptrT mptr, sanT san)
{
ssaT ssa;
ssavT ssav;

/* select canonical encoding (zero point in variant space) */

for (ssa = 0; ssa < ssaL; ssa++)
	ssav[ssa] = 0;
SANEncodeAux(mptr, san, ssav);

return;
}

/*<<< sanmne.c: EOF */
