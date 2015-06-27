/*>>> sanvar.h: external declarations for SAN variables */

/* Revised: 1993.04.24 */

/* program identification and control */

extern charptrT progname;
extern siT progdone;

/* the nil string */

extern charptrT nilstr;

/* ASCII character vectors */

extern char accv[cL];
extern char acpv[pL];
extern char acrv[rankL];
extern char acfv[fileL];

/* conversion vectors */

extern cT cv_c_cpv[cpL];
extern pT cv_p_cpv[cpL];
extern cpT cv_cp_cpv[rcL][pL];

/* special case promotion piece conversion */

extern pT cv_p_scmvv[scmvL];

/* color inversion */

extern cT inv_cv[rcL];

/* game termination strings */

extern charptrT gtcstrv[gtcL];

/* game termination input marker strings */

extern charptrT gtimstrv[gtimL];

/* game status conversions */

extern gtcT cv_gtc_gsv[gsL];

/* game termination input marker converstion */

extern gtcT cv_gtc_gtimv[gtimL];

/* dribble output file */

extern FILEptrT do_fptr;

/* direction vectors */

extern dvT dvv[dxL];
extern xdvT xdvv[dxL];

/* global boards */

extern bT gb;
extern xbT gxb;

/* search strategy names */

extern charptrT ssstrv[ssL];

/* piece values */

extern cpevT valpv[pL];
extern cpevT valcpv[cpL];

/* position setup flag */

extern siT setup;

/* game termination code */

extern gtcT gtc;

/* piece locations and counts */

extern sqT plv[rcL][pmaxL];
extern siT plnv[rcL];

/* attackers: bitfield merge and count */

extern siT atkcsqv[rcL][sqL];

/* board indices for piece location vector */

extern siT biv[sqL];

/* history record count */

extern siT hn;

/* history stack base and current pointers */

extern hptrT hbase, hcurr;

/* current environment record */

extern eT curr_e;

/* current generation record */

extern gT curr_g;

/* count of records in analysis stack (also, the current ply) */

extern siT an;

/* analysis stack */

extern aT av[aL];

/* base of tree leg storage */

extern mptrT Tree;

/* head and tail of tag list */

extern tagptrT head_tagptr, tail_tagptr;

/* default reserved tag names */

extern charptrT rsvtagv[rsvtagL];

/* program option vectors: values, names, and helps */

extern siT optnv[optnL];
extern charptrT optnnamev[optnL];
extern charptrT optnhelpv[optnL];

/* command token vector */

extern siT tkn;
extern charptrT tkv[tkL];

/* scratch text vector */

extern char stv[tL];

/* command information vector */

extern ciT civ[cmdL];

/* search strategies */

extern ssT ssv[rcL];

/* material */

extern cpevT cpmv[rcL];

/* playing level */

extern siT level;

/* average response time */

extern secT artsec;

/* previous state information for play/unplay strategy transition */

extern eT prev_e;
extern mT prev_m;
extern bT prev_b;

/* the null move */

extern mT null_m;

/* strategy move selection result */

extern mT select_m;

/*<<< sanvar.h: EOF */
