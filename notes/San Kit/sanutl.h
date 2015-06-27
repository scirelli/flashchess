/*>>> sanutl.h: subprogram prototypes for sanutl.c */

/* Revised: 1994.02.06 */

void Noop(void);
siT SANConvToCSI(siT value);
siT SANConvFrCSI(siT value);
liT SANConvToCLI(liT value);
liT SANConvFrCLI(liT value);
void SANFatal(charptrT s);
void SANSwitchFault(charptrT s);
charptrT SANToken(charptrT s, siptrT siptr);
FILEptrT SANTextFileOpen(charptrT fn, charptrT mode);
void SANTextFileClose(FILEptrT fptr);
charptrT SANStrGrab(charptrT s);
voidptrT SANMemGrab(allocT n);
void SANMemFree(voidptrT p);
voidptrT SANMemResize(voidptrT p, allocT n);
siT SANCIEqChar(char c0, char c1);
siT SANCIEqStr(charptrT s0, charptrT s1);
void SANTimestampAt(time_t tval, stampT stamp);
void SANTimestamp(stampT stamp);

/*<<< sanutl.h: EOF */
