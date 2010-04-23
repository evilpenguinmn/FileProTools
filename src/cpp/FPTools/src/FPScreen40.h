#ifndef FPSCREEN40_H_
#define FPSCREEN40_H_

#include <sys/types.h>

typedef struct __fpScreen40 {
	u_int16_t	signature;
	u_int32_t	pwCheck;
	u_int32_t	scrCheck;
	u_int16_t	scrWidth;
	u_int16_t	scrLength;
	u_int16_t	frmX;
	u_int16_t	frmY;
	u_int16_t	pgWidth;
	u_int16_t	pgLines;
	u_int16_t	pgPrintLines;
	u_int16_t	extHdrSize;
	u_int16_t	extHdrType;
	unsigned char		encPasswd[16];
	unsigned char		formName[5];
	unsigned char		reserved[15];
} SCREEN_HDR;

/**
 * This structure is valid for values of 128, 129, 131, and 178
 * in the SCREEN_HDR.extHdrType field. In the filepro documentation
 * the 
 */
typedef struct __fpExt40 {
	union {
		u_int32_t	hdrDesc;
		struct _vhdrdesc {
			u_int16_t	vhdrOffset;
			u_int16_t	vhdrTypeCode;
		} hdr;
	};
	u_int16_t	numTitleLines;
	u_int16_t	numDataLines;
	u_int16_t	numBreakLevels;
	u_int16_t	linesPerSection[9];
	u_int16_t	flags;
	u_int16_t	formfeedBreakLevel;
	unsigned char	sortInfo[64];
	unsigned char	printerName[16];
	u_int16_t	printInitCode;
	u_int16_t	printTermCode;
	
} SCREEN_EXTHDR1;

typedef struct __fpExtScr40 {
	// Yes, this is a duplicate. I think we may eliminate the union
	// and just use the two fields. Not sure why filepro documents it
	// this way.
	union {
		u_int32_t	hdrDesc;
		struct _vhdrdesc2 {
			u_int16_t	vhdrOffset;
			u_int16_t	vhdrTypeCode;
		} hdr;
	};
	u_int16_t		flags;
	u_int16_t		reserved;
	
} SCREEN_EXTHDR2;


#endif /*FPSCREEN40_H_*/
