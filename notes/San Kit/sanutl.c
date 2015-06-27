/*>>> sanutl.c: SAN project general utilities */

/* Revised: 1994.02.06 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <time.h>

#include "sandef.h"
#include "sanvar.h"

#include "sanutl.h"

/**** Locals */

/* type for short conversion */

typedef union cvsiU
	{
	siT   cvsi_si;
	byteT cvsi_bv[2];
	} cvsiT;

/* type for long conversion */

typedef union cvliU
	{
	liT   cvli_li;
	byteT cvli_bv[4];
	} cvliT;

/*--> Noop: do nothing */
nonstatic
void
Noop(void)
{

return;
}

/*--> SANConvFrCSI: convert from canonical two byte integer format */
nonstatic
siT
SANConvFrCSI(siT value)
{
siT result;
cvsiT cvsi;

cvsi.cvsi_si = value;

result =
	(cvsi.cvsi_bv[0] << (0 * byteW)) |
	(cvsi.cvsi_bv[1] << (1 * byteW));

return (result);
}

/*--> SANConvToCSI: convert to canonical two byte integer format */
nonstatic
siT
SANConvToCSI(siT value)
{
cvsiT cvsi;

cvsi.cvsi_bv[0] = (value >> (0 * byteW)) & byteM;
cvsi.cvsi_bv[1] = (value >> (1 * byteW)) & byteM;

return (cvsi.cvsi_si);
}

/*--> SANConvToCLI: convert to canonical four byte integer format */
nonstatic
liT
SANConvToCLI(liT value)
{
cvliT cvli;

cvli.cvli_bv[0] = (value >> (0 * byteW)) & byteM;
cvli.cvli_bv[1] = (value >> (1 * byteW)) & byteM;
cvli.cvli_bv[2] = (value >> (2 * byteW)) & byteM;
cvli.cvli_bv[3] = (value >> (3 * byteW)) & byteM;

return (cvli.cvli_li);
}

/*--> SANConvFrCLI: convert from canonical four byte integer format */
nonstatic
liT
SANConvFrCLI(liT value)
{
liT result;
cvliT cvli;

cvli.cvli_li = value;

result =
	(cvli.cvli_bv[0] << (0 * byteW)) |
	(cvli.cvli_bv[1] << (1 * byteW)) |
	(cvli.cvli_bv[2] << (2 * byteW)) |
	(cvli.cvli_bv[3] << (3 * byteW));

return (result);
}

/*--> SANFatal: report fatal error and exit */
nonstatic
void
SANFatal(charptrT s)
{
(void) fprintf(stderr, "SANFatal: %s\n", s);
exit(1);

return;
}

/*--> SANSwitchFault: report fswitch fault atal error and exit */
nonstatic
void
SANSwitchFault(charptrT s)
{
(void) fprintf(stderr, "SANFatal: switch fault: %s\n", s);
exit(1);

return;
}

/*--> SANToken: extract a token from a position in a string */
nonstatic
charptrT
SANToken(charptrT s, siptrT siptr)
{
charptrT tptr;
charptrT s0ptr, s1ptr;
siT c, i, length;

s0ptr = s + *siptr;
while (((c = *s0ptr) != '\0') && isspace(c))
	s0ptr++;

if (c == '\0')
	tptr = NULL;
else
	if (c != '"')
		{
		s1ptr = s0ptr + 1;
		while (((c = *s1ptr) != '\0') && !isspace(c) && (c != '"'))
			s1ptr++;
		length = s1ptr - s0ptr;
		tptr = SANMemGrab(length + 1);
		for (i = 0; i < length; i++)
			*(tptr + i) = *(s0ptr + i);
		*(tptr + length) = '\0';
		*siptr = s1ptr - s;
		}
	else
		{
		s1ptr = s0ptr + 1;
		while (((c = *s1ptr) != '\0') && (c != '"'))
			s1ptr++;
		length = s1ptr - s0ptr - 1;
		if (c == '"')
			s1ptr++;
		tptr = SANMemGrab(length + 1);
		for (i = 0; i < length; i++)
			*(tptr + i) = *(s0ptr + i + 1);
		*(tptr + length) = '\0';
		*siptr = s1ptr - s;
		};

return (tptr);
}

/*--> SANTextFileOpen: open a text file */
nonstatic
FILEptrT
SANTextFileOpen(charptrT fn, charptrT mode)
{
FILEptrT fptr;

fptr = fopen(fn, mode);

return (fptr);
}

/*--> SANTextFileClose: close a text file */
nonstatic
void
SANTextFileClose(FILEptrT fptr)
{
(void) fclose(fptr);

return;
}

/*--> SANStrGrab: allocate and copy string */
nonstatic
charptrT
SANStrGrab(charptrT s)
{
charptrT p;

p = SANMemGrab(strlen(s) + 1);
(void) strcpy(p, s);

return (p);
}

/*--> SANMemGrab: allocate memory */
nonstatic
voidptrT
SANMemGrab(allocT n)
{
voidptrT ptr;

ptr = malloc((n == 0) ? 1 : n);
if (ptr == NULL)
	SANFatal("SANMemGrab: out of memory");

return (ptr);
}

/*--> SANMemFree: deallocate memory */
nonstatic
void
SANMemFree(voidptrT p)
{
if (p != NULL)
	free(p);

return;
}

/*--> SANMemResize: shrink allocated block */
nonstatic
voidptrT
SANMemResize(voidptrT p, allocT n)
{
voidptrT q;

/* note that the block may be moved, so the new address is returned */

q = realloc(p, ((n == 0) ? 1 : n));

return (q);
}

/*--> SANCIEqChar: test chars for case independent equlaity */
nonstatic
siT
SANCIEqChar(char c0, char c1)
{
siT flag;

flag = (map_lower(c0) == map_lower(c1));

return (flag);
}

/*--> SANCIEqStr: compare two strings for case independent equality */
nonstatic
siT
SANCIEqStr(charptrT s0, charptrT s1)
{
siT flag;
charptrT p0, p1;
liT i, length0, length1;

length0 = strlen(s0);
length1 = strlen(s1);

if (length0 != length1)
	flag = 0;
else
	{
	flag = 1;
	p0 = s0;
	p1 = s1;
	i = 0;
	while (flag && (i < length1))
		if (!SANCIEqChar(*p0, *p1))
			flag = 0;
		else
			{
			p0++;
			p1++;
			i++;
			};
	};

return (flag);
}

/*--> SANTimestampAt: generate a timestamp for the given time */
nonstatic
void
SANTimestampAt(time_t tval, stampT stamp)
{
struct tm tmark;

tmark = *localtime(&tval);
(void) sprintf(stamp, "%04hd.%02hd.%02hd %02hd:%02hd:%02hd",
	((siT) (tmark.tm_year + 1900)), ((siT) (tmark.tm_mon + 1)),
	((siT) tmark.tm_mday), ((siT) tmark.tm_hour),
	((siT) tmark.tm_min), ((siT) tmark.tm_sec));

return;
}

/*--> SANTimestamp: generate a current timestamp */
nonstatic
void
SANTimestamp(stampT stamp)
{
SANTimestampAt(time(NULL), stamp);

return;
}

/*<<< sanutl.c: EOF */
