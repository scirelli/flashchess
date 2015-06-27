/*>>> sandef.h: definitions for the Standard Algebraic Notation project */

/* Revised: 1994.02.22 */

/* Note: the above revision date is the SAN Kit version identification */

/* true NULL */

#ifdef NULL
#undef NULL
#endif
#define NULL ((void *) 0)

/* subprogram nonstatic storage class indication */

#define nonstatic

/* a bit */

#define bit 0x01

/* 16 bit short integer and 32 bit long integer types */

typedef short int siT, *siptrT;
typedef long int liT, *liptrT;

/* 16 bit short integer and 32 bit long integer types (unsigned) */

typedef unsigned short int usiT, *usiptrT;
typedef unsigned long int uliT, *uliptrT;

/* some handy types */

typedef void *voidptrT;
typedef char *charptrT;
typedef unsigned char byteT, *byteptrT;
typedef FILE *FILEptrT;
typedef unsigned long int allocT;

/* bit widths */

#define nybbW 4
#define byteW (2 * nybbW)
#define wordW (2 * byteW)
#define dwrdW (2 * wordW)
#define qwrdW (2 * dwrdW)

/* byte legnths */

#define byteL 1
#define wordL (2 * byteL)
#define dwrdL (2 * wordL)
#define qwrdL (2 * dwrdL)

/* masks */

#define nybbM (0x0f)
#define byteM (0x00ff)
#define wordM (0x0000ffffL)

/* time */

#define secondL 1L
#define minuteL (secondL * 60L)
#define hourL   (minuteL * 60L)
#define dayL    (hourL   * 24L)

/* time record */

typedef struct timerecS
    {
    liT timerec_day;    /* 0 - 999 */
    liT timerec_hour;   /* 0 -  23 */
    liT timerec_minute; /* 0 -  59 */
    liT timerec_second; /* 0 -  59 */
    } timerecT, *timerecptrT;

/* timestamp string */

#define stampL 20

typedef char stampT[stampL];

/* some handy macros */

#define map_lower(ch) (isupper((ch)) ? tolower((ch)) : (ch))
#define map_upper(ch) (islower((ch)) ? toupper((ch)) : (ch))

#ifdef max
#undef max
#endif
#define max(x, y) (((x) > (y)) ? (x) : (y))

#ifdef min
#undef min
#endif
#define min(x, y) (((x) > (y)) ? (x) : (y))

/* string list element */

typedef struct sleS
	{
	charptrT     sle_s;     /* allocated string */
	struct sleS *sle_prev;  /* previous list element */
	struct sleS *sle_next;  /* next list element */
	} sleT, *sleptrT;

/* string list anchor */

typedef struct slaS
	{
	sleptrT sla_head;  /* head list element */
	sleptrT sla_tail;  /* tail list element */
	} slaT, *slaptrT;

/* designated file names */

#define dfn_init "init.ci"  /* commands for initialization */

/* text line length limit */

#define tL 256

/* second (time) type */

typedef liT secT;

/* rank type */

typedef siT rankT;
#define rankQ 3
#define rankL (bit << rankQ)
#define rank_nil (-1)

#define rank_1 0
#define rank_2 1
#define rank_3 2
#define rank_4 3
#define rank_5 4
#define rank_6 5
#define rank_7 6
#define rank_8 7

/* file type */

typedef siT fileT;
#define fileQ 3
#define fileM 0x07
#define fileL (bit << fileQ)
#define file_nil (-1)

#define file_a 0
#define file_b 1
#define file_c 2
#define file_d 3
#define file_e 4
#define file_f 5
#define file_g 6
#define file_h 7

/* board mapping macros */

#define map_rank_sq(sq) ((sq) >> fileQ) 
#define map_file_sq(sq) ((sq) & fileM)
#define map_sq_rank_file(rank, file) (((rank) << fileQ) | (file))

/* squares */

typedef siT sqT, *sqptrT;
#define sqQ (rankQ + fileQ)
#define sqsqQ (2 * sqQ)
#define sqL (bit << sqQ)
#define sqM 0x3f
#define sq_nil (-1)

#define sq_a1 map_sq_rank_file(rank_1, file_a)
#define sq_a2 map_sq_rank_file(rank_2, file_a)
#define sq_a3 map_sq_rank_file(rank_3, file_a)
#define sq_a4 map_sq_rank_file(rank_4, file_a)
#define sq_a5 map_sq_rank_file(rank_5, file_a)
#define sq_a6 map_sq_rank_file(rank_6, file_a)
#define sq_a7 map_sq_rank_file(rank_7, file_a)
#define sq_a8 map_sq_rank_file(rank_8, file_a)

#define sq_b1 map_sq_rank_file(rank_1, file_b)
#define sq_b2 map_sq_rank_file(rank_2, file_b)
#define sq_b3 map_sq_rank_file(rank_3, file_b)
#define sq_b4 map_sq_rank_file(rank_4, file_b)
#define sq_b5 map_sq_rank_file(rank_5, file_b)
#define sq_b6 map_sq_rank_file(rank_6, file_b)
#define sq_b7 map_sq_rank_file(rank_7, file_b)
#define sq_b8 map_sq_rank_file(rank_8, file_b)

#define sq_c1 map_sq_rank_file(rank_1, file_c)
#define sq_c2 map_sq_rank_file(rank_2, file_c)
#define sq_c3 map_sq_rank_file(rank_3, file_c)
#define sq_c4 map_sq_rank_file(rank_4, file_c)
#define sq_c5 map_sq_rank_file(rank_5, file_c)
#define sq_c6 map_sq_rank_file(rank_6, file_c)
#define sq_c7 map_sq_rank_file(rank_7, file_c)
#define sq_c8 map_sq_rank_file(rank_8, file_c)

#define sq_d1 map_sq_rank_file(rank_1, file_d)
#define sq_d2 map_sq_rank_file(rank_2, file_d)
#define sq_d3 map_sq_rank_file(rank_3, file_d)
#define sq_d4 map_sq_rank_file(rank_4, file_d)
#define sq_d5 map_sq_rank_file(rank_5, file_d)
#define sq_d6 map_sq_rank_file(rank_6, file_d)
#define sq_d7 map_sq_rank_file(rank_7, file_d)
#define sq_d8 map_sq_rank_file(rank_8, file_d)

#define sq_e1 map_sq_rank_file(rank_1, file_e)
#define sq_e2 map_sq_rank_file(rank_2, file_e)
#define sq_e3 map_sq_rank_file(rank_3, file_e)
#define sq_e4 map_sq_rank_file(rank_4, file_e)
#define sq_e5 map_sq_rank_file(rank_5, file_e)
#define sq_e6 map_sq_rank_file(rank_6, file_e)
#define sq_e7 map_sq_rank_file(rank_7, file_e)
#define sq_e8 map_sq_rank_file(rank_8, file_e)

#define sq_f1 map_sq_rank_file(rank_1, file_f)
#define sq_f2 map_sq_rank_file(rank_2, file_f)
#define sq_f3 map_sq_rank_file(rank_3, file_f)
#define sq_f4 map_sq_rank_file(rank_4, file_f)
#define sq_f5 map_sq_rank_file(rank_5, file_f)
#define sq_f6 map_sq_rank_file(rank_6, file_f)
#define sq_f7 map_sq_rank_file(rank_7, file_f)
#define sq_f8 map_sq_rank_file(rank_8, file_f)

#define sq_g1 map_sq_rank_file(rank_1, file_g)
#define sq_g2 map_sq_rank_file(rank_2, file_g)
#define sq_g3 map_sq_rank_file(rank_3, file_g)
#define sq_g4 map_sq_rank_file(rank_4, file_g)
#define sq_g5 map_sq_rank_file(rank_5, file_g)
#define sq_g6 map_sq_rank_file(rank_6, file_g)
#define sq_g7 map_sq_rank_file(rank_7, file_g)
#define sq_g8 map_sq_rank_file(rank_8, file_g)

#define sq_h1 map_sq_rank_file(rank_1, file_h)
#define sq_h2 map_sq_rank_file(rank_2, file_h)
#define sq_h3 map_sq_rank_file(rank_3, file_h)
#define sq_h4 map_sq_rank_file(rank_4, file_h)
#define sq_h5 map_sq_rank_file(rank_5, file_h)
#define sq_h6 map_sq_rank_file(rank_6, file_h)
#define sq_h7 map_sq_rank_file(rank_7, file_h)
#define sq_h8 map_sq_rank_file(rank_8, file_h)

/* color and restricted color types */

typedef siT cT, *cptrT;
#define cQ 2
#define cL (bit << cQ)
#define c_nil (-1)

#define c_w 0
#define c_b 1
#define c_v 2
#define c_x 3

typedef siT rcT, *rcptrT;
#define rcQ 1
#define rcL (bit << rcQ)

/* piece type */

typedef siT pT, *pptrT;
#define pQ 3
#define pL (bit << pQ)
#define p_nil (-1)

#define p_p 0 /* pawn */
#define p_n 1 /* knight */
#define p_b 2 /* bishop */
#define p_r 3 /* rook */
#define p_q 4 /* queen */
#define p_k 5 /* king */
#define p_v 6 /* vacant */
#define p_x 7 /* extra */

/* maximum pieces per side */

#define pmaxL (2 * fileL)

/* king's location in piece vector */

#define kingslot 0

/* color piece combination */

typedef siT cpT, *cpptrT;
#define cpQ 4
#define cpL (bit << cpQ)
#define rcpL 12
#define cp_nil (-1)

#define cp_wp  0
#define cp_wn  1
#define cp_wb  2
#define cp_wr  3
#define cp_wq  4
#define cp_wk  5
#define cp_bp  6
#define cp_bn  7
#define cp_bb  8
#define cp_br  9
#define cp_bq 10
#define cp_bk 11
#define cp_v0 12
#define cp_x0 13
#define cp_x1 14
#define cp_x2 15

/* the board type */

typedef union bU
	{
	cpT bm[rankL][fileL];
	cpT bv[sqL];
	} bT, *bptrT;

/* extended rank, file, and square types */

typedef siT xrankT;
#define xrankQ (rankQ + 1)
#define xrankL (bit << xrankQ)

typedef siT xfileT;
#define xfileQ (fileQ + 1)
#define xfileM 0x0f
#define xfileL (bit << xfileQ)

typedef siT xsqT, *xsqptrT;
#define xsqQ (xrankQ + xfileQ)
#define xsqL (bit << xsqQ)

#define xbdrL 4

/* the extended board type */

typedef union xbU
	{
	cpT xbm[xrankL][xfileL];
	cpT xbv[xsqL];
	} xbT, *xbptrT;

/* extended board mapping macros */

#define map_xrank_xsq(xsq) ((xsq) >> xfileQ)
#define map_xfile_xsq(xsq) ((xsq) & xfileM)
#define map_xsq_xrank_xfile(xrank, xfile) (((xrank) << xfileQ) | (xfile))

/* extended conversion macros */

#define map_xfile_file(file) ((file) + xbdrL)
#define map_xrank_rank(rank) ((rank) + xbdrL)

#define map_file_xfile(xfile) ((xfile) - xbdrL)
#define map_rank_xrank(xrank) ((xrank) - xbdrL)

#define map_sq_xsq(xsq) \
	(((((xsq) >> xfileQ) - xbdrL) << fileQ) | (((xsq) & xfileM) - xbdrL))

#define map_xsq_sq(sq) \
	((((((sq) >> fileQ) & fileM) + xbdrL) << xfileQ) | \
	(((sq) & fileM) + xbdrL))

/* compressed board type */

#define zL (sqL / 2)
typedef byteT zT[zL];

/* search tree leg length */

#define legL 2048

/* census reporting */

typedef siT cenT;
#define cenL 16
#define cen_nil (-1)

#define cen_lgl  0 /* legal position */
#define cen_ept  1 /* en passant target fault */
#define cen_wck  2 /* white castling kingside fault */
#define cen_wcq  3 /* white castling queenside fault */
#define cen_wkc  4 /* white king passive check */
#define cen_wkn  5 /* white king non-unique */
#define cen_wms  6 /* white men surplus */
#define cen_wpm  7 /* white pawn misplacement */
#define cen_wps  8 /* white pawn surplus */
#define cen_bck  9 /* black castling kingside fault */
#define cen_bcq 10 /* black castling queenside fault */
#define cen_bkc 11 /* black king passive check */
#define cen_bkn 12 /* black king non-unique */
#define cen_bms 13 /* black men surplus */
#define cen_bpm 14 /* black pawn misplacement */
#define cen_bps 15 /* black pawn surplus */

/* game status type */

typedef siT gsT;
#define gsL 13
#define gs_nil (-1)

#define gs_norm  0 /* normal game in progress */
#define gs_bust  1 /* illegal position */
#define gs_wcmt  2 /* white checkmated */
#define gs_bcmt  3 /* black checkmated */
#define gs_wsmt  4 /* white stalemated */
#define gs_bsmt  5 /* black stalemated */
#define gs_dhmc  6 /* draw: halfmove clock */
#define gs_dmat  7 /* draw: insufficient material */
#define gs_drep  8 /* draw: position repetition */
#define gs_dagr  9 /* draw: agreed */
#define gs_wres 10 /* white resigns */
#define gs_bres 11 /* black resigns */
#define gs_over 12 /* overflow */

/* game termination code type */

typedef siT gtcT;
#define gtcL 4
#define gtc_nil (-1)

#define gtc_wwin 0 /* White win */
#define gtc_bwin 1 /* Black win */
#define gtc_draw 2 /* drawn */
#define gtc_norm 3 /* ongoing */

/* game termination input markers */

typedef siT gtimT;
#define gtimL 13
#define gtim_nil (-1)

#define gtim_norm  0 /* game still in progress: "*" */
#define gtim_drw0  1 /* draw: "1/2-1/2" */
#define gtim_drw1  2 /* draw: "1/2" */
#define gtim_drw2  3 /* draw: "draw" */
#define gtim_drw3  4 /* draw: "drawn" */
#define gtim_wwn0  5 /* White wins: "1-0" */
#define gtim_wwn1  6 /* White wins: "1/0" */
#define gtim_wwn2  7 /* White wins: "1:0" */
#define gtim_bwn0  8 /* Black wins: "0-1" */
#define gtim_bwn1  9 /* Black wins: "0/1" */
#define gtim_bwn2 10 /* Black wins: "0:1" */
#define gtim_res0 11 /* Active player resignation: "resign" */
#define gtim_res1 12 /* Active player resignation: "resigns" */

/* flanks */

typedef siT flankT;
#define flankQ 1
#define flankL (bit << flankQ)
#define flank_nil (-1)

#define flank_k 0 /* kingside */
#define flank_q 1 /* queenside */

/* castling availability indicators */

typedef siT caiT;
#define caiQ (rcQ + flankQ)
#define caiL (bit << caiQ)
#define cai_nil (-1)

#define cai_wk ((c_w * flankL) + flank_k)
#define cai_wq ((c_w * flankL) + flank_q)
#define cai_bk ((c_b * flankL) + flank_k)
#define cai_bq ((c_b * flankL) + flank_q)

/* castling availability indicator bits */

typedef siT castT;
typedef castT *castptrT;

#define cast_wk (bit << cai_wk)
#define cast_wq (bit << cai_wq)
#define cast_bk (bit << cai_bk)
#define cast_bq (bit << cai_bq)

/* analysis ply limit; must be at least 3 */

#define aL 32

/* direction indices */

typedef siT dxT;
#define dxQ 4
#define dxL (bit << dxQ)
#define dx_nil (-1)

#define dx_0  0
#define dx_1  1
#define dx_2  2
#define dx_3  3
#define dx_4  4
#define dx_5  5
#define dx_6  6
#define dx_7  7
#define dx_8  8
#define dx_9  9
#define dx_a 10
#define dx_b 11
#define dx_c 12
#define dx_d 13
#define dx_e 14
#define dx_f 15

/* direction vector displacements */

typedef siT dvT;

#define dv_0 (( 0 * fileL) + 1)
#define dv_1 (( 1 * fileL) + 0)
#define dv_2 (( 0 * fileL) - 1)
#define dv_3 ((-1 * fileL) - 0)
#define dv_4 (( 1 * fileL) + 1)
#define dv_5 (( 1 * fileL) - 1)
#define dv_6 ((-1 * fileL) - 1)
#define dv_7 ((-1 * fileL) + 1)
#define dv_8 (( 1 * fileL) + 2)
#define dv_9 (( 2 * fileL) + 1)
#define dv_a (( 2 * fileL) - 1)
#define dv_b (( 1 * fileL) - 2)
#define dv_c ((-1 * fileL) - 2)
#define dv_d ((-2 * fileL) - 1)
#define dv_e ((-2 * fileL) + 1)
#define dv_f ((-1 * fileL) + 2)

/* extended direction vector offsets */

typedef siT xdvT;

#define xdv_0 (( 0 * xfileL) + 1)
#define xdv_1 (( 1 * xfileL) + 0)
#define xdv_2 (( 0 * xfileL) - 1)
#define xdv_3 ((-1 * xfileL) - 0)
#define xdv_4 (( 1 * xfileL) + 1)
#define xdv_5 (( 1 * xfileL) - 1)
#define xdv_6 ((-1 * xfileL) - 1)
#define xdv_7 ((-1 * xfileL) + 1)
#define xdv_8 (( 1 * xfileL) + 2)
#define xdv_9 (( 2 * xfileL) + 1)
#define xdv_a (( 2 * xfileL) - 1)
#define xdv_b (( 1 * xfileL) - 2)
#define xdv_c ((-1 * xfileL) - 2)
#define xdv_d ((-2 * xfileL) - 1)
#define xdv_e ((-2 * xfileL) + 1)
#define xdv_f ((-1 * xfileL) + 2)

/* the standard algebraic notation character vector type */

#define sanL 16 /* must be at least 8; extra room for alternatives */

typedef char sanT[sanL];
typedef sanT *sanptrT;

/* SAN style attributes, priority ordered (used for encoding) */

typedef siT ssaT; 
#define ssaL 12
#define ssa_nil (-1)

#define ssa_capt  0 /* 5 way: capture indicator */
#define ssa_case  1 /* 2 way: letter case */
#define ssa_chec  2 /* 3 way: checking */
#define ssa_cast  3 /* 5 way: castling */
#define ssa_prom  4 /* 4 way: promoting */
#define ssa_ptar  5 /* 2 way: pawn target rank skip */
#define ssa_chmt  6 /* 4 way: checkmating */
#define ssa_epct  7 /* 2 way: en passant capture */
#define ssa_draw  8 /* 2 way: drawing */
#define ssa_move  9 /* 2 way: movement indicator */
#define ssa_edcf 10 /* 2 way: extra disambiguating character (file) */
#define ssa_edcr 11 /* 2 way: extra disambiguating character (rank) */

/* SAN style vector */

typedef siT ssavT[ssaL];

/* centipawn value type */

typedef siT cpevT;

/* millipawn value type */

typedef siT mpevT;

/* scoring evaluations (centipawn units) */

#define ev_bust (-32767)
#define ev_draw 0
#define ev_mate 32767

/* piece values (centipawn units) */

#define val_p 100
#define val_n 325
#define val_b 333
#define val_r 500
#define val_q 900
#define val_k   0
#define val_v   0
#define val_x   0

/* move flag bits */

typedef siT mfT;

#define mf_bust (bit << 0) /* illegal move */
#define mf_chec (bit << 1) /* checking */
#define mf_chmt (bit << 2) /* checkmating */
#define mf_draw (bit << 3) /* drawing (includes stalemating) */
#define mf_exec (bit << 4) /* executed at least once */
#define mf_null (bit << 5) /* special null move */
#define mf_sanf (bit << 6) /* needs file disambiguation */
#define mf_sanr (bit << 7) /* needs rank disambiguation */
#define mf_stmt (bit << 8) /* stalemating */

/* special case move type */

typedef siT scmvT;
#define scmvQ 3
#define scmvL (bit << scmvQ)
#define scmv_nil (-1)

#define scmv_reg 0 /* regular */
#define scmv_epc 1 /* en passant capture */
#define scmv_cks 2 /* castles kingside */
#define scmv_cqs 3 /* castles queenside */
#define scmv_ppn 4 /* pawn promotes to knight */
#define scmv_ppb 5 /* pawn promotes to bishop */
#define scmv_ppr 6 /* pawn promotes to rook */
#define scmv_ppq 7 /* pawn promotes to queen */

/* move type */

typedef struct mS
	{
	mfT   m_flag; /* move flags */
	sqT   m_frsq; /* from square */
	sqT   m_tosq; /* to square */
	cpT   m_frcp; /* from color-piece */
	cpT   m_tocp; /* to color-piece */
	scmvT m_scmv; /* special case move indication */
	cpevT m_eval; /* evaluation */
	} mT, *mptrT;

/* fifty fullmove halfmove clock draw limit */

#define hmvcL (50 * rcL)

/* maximum generated move limit (exact upper bound unknown) */

#define gmL 256

/* generation flags */

typedef siT gfT;

#define gf_capt (bit << 0) /* capture move generation present */
#define gf_dsam (bit << 1) /* disambiguation scan performed */
#define gf_exec (bit << 2) /* execute scan */
#define gf_full (bit << 3) /* full move generation present */
#define gf_mate (bit << 4) /* stalemate/checkmate scan */
#define gf_plcd (bit << 5) /* police scan */
#define gf_sort (bit << 6) /* ASCII sort */

/* the generation record type */

typedef struct gS
	{
	gfT   g_flag; /* generation flags */
	siT   g_strt; /* start index in tree leg storage */
	siT   g_gmvc; /* generated move count */
	mptrT g_base; /* start of move storage in tree leg */
	mptrT g_curr; /* current move of interest in tree leg storage */
	} gT, *gptrT;

/* hash code position address and signature types */

typedef liT hcpaT, *hcpaptrT;
typedef liT hcpsT, *hcpsptrT;

/* hash code position exclusive-or record type (constant values) */

typedef struct hxS
    {
    hcpaT hx_hcpa; /* address exclusive-or data */
    hcpsT hx_hcps; /* signature exclusive-or data */
    } hxT, *hxptrT;

/* the environment record type */

typedef struct eS
	{
	cT    e_actc; /* active color */
	cT    e_pasc; /* passive color */
	castT e_cast; /* castling availability flags */
	sqT   e_epsq; /* en passant target square */
	siT   e_hmvc; /* halfmove clock */
	siT   e_fmvn; /* fullmove number */
	hcpaT e_mhca; /* hash address */
	hcpsT e_mhcs; /* hash signature */
	} eT, *eptrT;

/* the analysis record type; one entry per lookahead ply */

typedef struct aS
	{
	eT a_e; /* environment */
	gT a_g; /* move generation */
	} aT, *aptrT;

/* the fullmove and halfmove play limits */

#define fmpL 200
#define hmpL (fmpL * rcL)

/* the history record type */

#define hL (hmpL + aL)

typedef struct hS
	{
	siT h_o; /* move ordinal (SAN string sort index; -1 if invalid) */
	eT  h_e; /* environment */
	mT  h_m; /* move */
	zT  h_z; /* compressed board */
	} hT, *hptrT;

/* tag flags */

typedef siT tagfT;

#define tagf_crep (bit << 0) /* corredspondence report item */
#define tagf_estm (bit << 1) /* can be estimated */
#define tagf_perm (bit << 2) /* permanent, can't be cleared */
#define tagf_read (bit << 3) /* read only, can't be written */

/* tags (program environment pairs) */

typedef struct tagS
    {
    charptrT tag_name;     /* tag identifier */
    charptrT tag_value;    /* associated value */
    struct tagS *tag_prev; /* the previous tag */
    struct tagS *tag_next; /* the next tag */
    tagfT tag_flag;        /* tag flag word */
    } tagT, *tagptrT;

/* reserved tags (note display order dependence) */

typedef siT rsvtagT;
#define rsvtagL 7
#define rsvtag_nil (-1)

#define rsvtag_event  0 /* competition event */
#define rsvtag_site   1 /* location */
#define rsvtag_date   2 /* competition date */
#define rsvtag_round  3 /* playing round ordinal */
#define rsvtag_white  4 /* white player */
#define rsvtag_black  5 /* black player */
#define rsvtag_result 6 /* game result */

/* EPD record length */

#define epdL 1024

/* the game reader translation mode type */

typedef siT grtmT;
#define grtmL 5

#define grtm_none 0 /* no output */
#define grtm_epd  1 /* EPD output */
#define grtm_pgc  2 /* PGC output */
#define grtm_pgn  3 /* PGN output */
#define grtm_var  4 /* variation output */

/* search strategies */

typedef siT ssT;
#define ssL 5
#define ss_nil (-1)

#define ss_eat 0 /* best simple capture */
#define ss_gtp 1 /* neo-adaptation of Gillogly TECH program */
#define ss_ran 2 /* random move selection */
#define ss_sc0 3 /* Stanback Chess Program (internal) */
#define ss_sc1 4 /* Stanback Chess Program (external) */

/* strategy entry points */

typedef siT sepT;
#define sepL 8
#define sep_nil (-1)

#define sep_init    0 /* one time initialization */
#define sep_term    1 /* one time termination */
#define sep_newgame 2 /* reset for a new game */
#define sep_select  3 /* select a move */
#define sep_play    4 /* play a move */
#define sep_unplay  5 /* unplay a move */
#define sep_setpos  6 /* register set-up position */
#define sep_config  7 /* register configuration parameters */

/* options */

typedef siT optnT;
#define optnL 9
#define optn_nil (-1)

#define optn_dbug 0 /* debugging */
#define optn_emde 1 /* extraordinary move disambiguation effort */
#define optn_nabd 2 /* no auto board display */
#define optn_namd 3 /* no auto move display */
#define optn_napr 4 /* no auto program reply */
#define optn_nmde 5 /* no move disambiguation effort */
#define optn_test 6 /* testing */
#define optn_trpt 7 /* trace: processing time */
#define optn_verb 8 /* verbosity */

/* command string token limit */

#define tkL (tL / 2)

/* commands */

typedef siT cmdT;
#define cmdL 56
#define cmd_nil (-1)

#define cmd_afdo  0 /* append file: dribble output */
#define cmd_auto  1 /* perform automatic competetion */
#define cmd_beep  2 /* emit ASCII BEL */
#define cmd_call  3 /* call command subfile */
#define cmd_cfdo  4 /* close file: dribble output */
#define cmd_cvca  5 /* clear value: castling availablity */
#define cmd_cvcb  6 /* clear value: chess board */
#define cmd_cvep  7 /* clear value: en passant target square */
#define cmd_cvgt  8 /* clear value: game termination */
#define cmd_cvop  9 /* clear value: option */
#define cmd_cvsq 10 /* clear value: square */
#define cmd_cvtf 11 /* clear value: tag field */
#define cmd_dvas 12 /* display value: hash address and signature */
#define cmd_dvcb 13 /* display value: chess board */
#define cmd_dvcr 14 /* display value: correspondence report */
#define cmd_dver 15 /* display value: event report */
#define cmd_dvfe 16 /* display value: Forsyth-Edwards notation */
#define cmd_dvhg 17 /* display value: hash generation tables */
#define cmd_dvss 18 /* display value: search strategies */
#define cmd_dvte 19 /* display value: tag environment */
#define cmd_dvtf 20 /* display value: tag field */
#define cmd_dvts 21 /* display value: timestamp */
#define cmd_echo 22 /* echo arguments */
#define cmd_enum 23 /* enumerate descendents */
#define cmd_exit 24 /* exit program */
#define cmd_exsm 25 /* execute supplied move */
#define cmd_game 26 /* autoplay to end of game */
#define cmd_help 27 /* display help */
#define cmd_lfer 28 /* load file: event report */
#define cmd_newg 29 /* new game */
#define cmd_noop 30 /* no operation */
#define cmd_ofdo 31 /* open file: dribble output */
#define cmd_play 32 /* select and play N moves */
#define cmd_rtmv 33 /* retract N played moves */
#define cmd_rtrn 34 /* return from command subfile */
#define cmd_sfcr 35 /* save file: correspondence report */
#define cmd_sfer 36 /* save file: event report */
#define cmd_srch 37 /* search for a target move */
#define cmd_stat 38 /* status report */
#define cmd_svac 39 /* set value: active color */
#define cmd_svca 40 /* set value: castling availability */
#define cmd_svep 41 /* set value: en passant target square */
#define cmd_svfe 42 /* set value: Forsyth-Edwards notation */
#define cmd_svfn 43 /* set value: fullmove number */
#define cmd_svhc 44 /* set value: halfmove clock */
#define cmd_svop 45 /* set value: option */
#define cmd_svpl 46 /* set value: playing level */
#define cmd_svrt 47 /* set value: average response time */
#define cmd_svsq 48 /* set value: square */
#define cmd_svss 49 /* set value: search strategies */
#define cmd_svtf 50 /* set value: tag field */
#define cmd_test 51 /* developer test */
#define cmd_tfgc 52 /* translate file: games to code (PGC) */
#define cmd_tfge 53 /* translate file: games to EPD */
#define cmd_tfgg 54 /* translate file: games to games (PGN) */
#define cmd_tfgv 55 /* translate file: games to variations */

/* pointer to function returning void type */

typedef void (*frvptrT)(void);

/* command information */

typedef struct ciS
	{
	charptrT ci_name; /* command name */
	charptrT ci_help; /* informative help */
	frvptrT  ci_func; /* processing function */
	siT      ci_amin; /* argument count minimum (always >= 1) */
	siT      ci_amax; /* argument count minimum (always <= tkL) */
	} ciT, *ciptrT;

/*<<< sandef.h: EOF */
