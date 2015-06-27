/*>>> santag.h: subprogram prototypes for santag.c */

/* Revised: 1993.11.25 */

charptrT SANTagFormat(tagptrT tagptr);
charptrT SANTagFormatReserved(rsvtagT rsvtag);
tagptrT SANTagCreate(charptrT name, charptrT value, tagfT tagf);
tagptrT SANTagLocate(charptrT name);
void SANTagDelete(tagptrT tagptr);
void SANTagInsert(tagptrT tagptr);
void SANTagUpdate(tagptrT tagptr, charptrT value);
void SANTagClear(tagptrT tagptr);
void SANTagClearAll(void);
void SANTagInit(void);
void SANTagTerm(void);

/*<<< santag.h: EOF */
