/*>>> sandsp.h: subprogram prototypes for sandsp.c */

/* Revised: 1993.05.15 */

void SANDspChar(char ch);
void SANDspStr(charptrT s);
void SANDspNL(void);
void SANDspLine(charptrT s);
void SANDspSTV(void);
void SANDspSTVNL(void);
void SANDspNote(charptrT s);
void SANDspError(charptrT s);
void SANDspErrorSTV(void);
void SANDspSI(siT si);
void SANDspLI(liT li);
void SANDspStrSI(charptrT s, siT si);
void SANDspStrLI(charptrT s, liT li);
void SANDspStrSINL(charptrT s, siT si);
void SANDspStrLINL(charptrT s, liT li);
void SANDspTimestamp(void);
void SANDspSq(sqT sq);
void SANDspColor(cT c);
void SANDspPiece(pT p);
void SANDspColorPiece(cpT cp);
void SANDspSAN(mptrT mptr);
void SANDspSANTB(mptrT mptr);
void SANDspSANNL(mptrT mptr);
void SANDspFullMove(siT n, mptrT mptr);
void SANDspPath(void);
void SANDspBoard(void);
void SANDspOptions(void);
void SANDspStatus(void);
void SANGateChar(FILEptrT fptr, char ch);
void SANGateStr(FILEptrT fptr, charptrT s);
void SANBadParmForm(siT n);
void SANBadParmValue(siT n);

/*<<< sandsp.h: EOF */
