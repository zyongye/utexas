; Title: ID Card Data Parser - Main Program
; Name: Yongye Zhu
; EID: yz24493
; Date: 12/06/2018
; Recitation Section: Friday 9-10
; Description of program: ID Card Parser


.ORIG x3000
; set up ISR
	LD	R6, SP			;load the supervisor stack pointer
	LD	R1, KBISR
	STI	R1, KBISRV		;initialize ISR to ISRV	
	LD	R1, ENINT
	STI	R1, KBSR		;enable KBI
	AND	R2, R2, #0		;used to clear x8000

; start of actual program
; Implementation of finite state machine
;	STATE 0: continously check x8000 see if the data is "1"
;	Register Usage: 
;			R0: read character from x8000, and echo to the console
;			R1: load the negative value used to compare, and store the comparsion
;			R2: used to clear x8000 after usage
;			R3: load the value from counter to see if exceed the limit

	LEA	R0, NAME
	PUTS
	LEA	R0, EID
	PUTS
	LEA	R0, DATE
	PUTS
	LD	R0, ADD_TITLE
	PUTS
	LEA	R0, ETR
	PUTS

STATE0	LDI	R0, ST_C
	BRZ	STATE0
	OUT
	STI	R2, ST_C
	LD	R1, NH_ONE
	ADD	R1, R1, R0
	BRZ	STATE1
	LDI	R3, COUNTER
	LD	R1, NH16
	ADD	R1, R1, R3
	BRZ	DENIED
	LD	R1, FINISHED
	NOT	R1, R1
	ADD	R1, R1, #1
	ADD	R1, R1, R0
	BRZ	FINISH
	BR	STATE0	

ADD_TITLE	.FILL	x3111

STATE1	LDI	R0, ST_C
	BRZ	STATE1
	OUT
	STI	R2, ST_C
	LD	R1, NH_SIX
	ADD	R1, R1, R0
	BRZ	STATE2
	LD	R1, NH_ONE
	ADD	R1, R1, R0
	BRZ	STATE1
	LDI	R3, COUNTER
	LD	R1, NH16
	ADD	R1, R1, R3
	BRP	DENIED
	BR	STATE0

STATE2	LDI	R0, ST_C
	BRZ	STATE2
	OUT
	STI	R2, ST_C
	LD	R1, NH_ONE
	ADD	R1, R1, R0
	BRZ	STATE3
	LDI	R3, COUNTER
	LD	R1, NH16
	ADD	R1, R1, R3
	BRP	DENIED
	BR	STATE0

STATE3	LDI	R0, ST_C
	BRZ	STATE3
	OUT
	STI	R2, ST_C
	LD	R1, NH_ONE
	ADD	R1, R1, R0
	BRZ	STATE4A
	LD	R1, NH_ZERO
	ADD	R1, R1, R0
	BRZ	STATE4B
	LD	R1, NH_SIX
	ADD	R1, R1, R0
	BRZ	STATE2
	LDI	R3, COUNTER
	LD	R1, NH16
	ADD	R1, R1, R3
	BRP	DENIED
	BR	STATE0

STATE4A	LDI	R0, ST_C
	BRZ	STATE4A
	OUT
	STI	R2, ST_C
	LD	R1, NH_ONE
	ADD	R1, R1, R0
	BRZ	STATE1
	LD	R1, NH_ZERO
	ADD	R1, R1, R0
	BRZ	STATE5
	LD	R1, NH_FIVE
	ADD	R1, R1, R0
	BRZ	STATE5
	LD	R1, NH_SIX
	ADD	R1, R1, R0
	BRZ	STATE2
	LDI	R3, COUNTER
	LD	R1, NH16
	ADD	R1, R1, R3
	BRP	DENIED
	BR	STATE0

STATE4B	LDI	R0, ST_C
	BRZ	STATE4B
	OUT
	STI	R2, ST_C
	LD	R1, NH_ONE
	ADD	R1, R1, R0
	BRZ	STATE1
	LD	R1, NH_ZERO
	ADD	R1, R1, R0
	BRZ	STATE5
	LD	R1, NH_FIVE
	ADD	R1, R1, R0
	BRZ	STATE5
	LDI	R3, COUNTER
	LD	R1, NH16
	ADD	R1, R1, R3
	BRP	DENIED
	BR	STATE0

STATE5	LEA	R0, IN_MSG
	PUTS
	STI	R2, COUNTER
	LEA	R0, ETR
	PUTS
	BR	STATE0

DENIED	LEA	R0, OUT_MSG
	PUTS
	STI	R2, COUNTER
	LEA	R0, ETR
	PUTS
	BR	STATE0

;  Additional Step: check if the string is "finishedtesting "
;  Register Usage:
;			R0: store the character
;			R1: store the compared character
;			R2: store blank to clear x8000
;			R3: the counter
;			R4: store the address of the header of the string

FINISH	LDI	R0, ST_C
	BRZ	FINISH
	OUT
	STI	R2, ST_C
	LEA	R4, FINISHED
	ADD	R4, R4, #-1
	LDI	R3, COUNTER
	ADD	R4, R4, R3
	LDR	R1, R4, #0
	NOT	R1, R1
	ADD	R1, R1, #1
	ADD	R1, R1, R0
	BRNP	STATE0
	LD	R1, NH16
	ADD	R1, R1, R3
	BRNP	FINISH
	LEA	R0, OUT_MSG
	PUTS
	LEA	R0, ETR
	PUTS
	LEA	R0, STICKER
	PUTS
	LEA	R0, ETR
	PUTS
	STI	R2, COUNTER
	BR	STATE0

HALT
FINISHED	.STRINGZ	"finishedtesting "
NH_ZERO	.FILL	xFFD0
NH_ONE	.FILL	xFFCF
NH_FIVE	.FILL	xFFCB
NH_SIX	.FILL	xFFCA
NH16	.FILL	xFFF0
ETR	.STRINGZ	"\n"
IN_MSG	.STRINGZ	"\nAccess Granted!\n"
OUT_MSG	.STRINGZ	"\nAccess Denied!\n"
ST_C	.FILL	x8000
COUNTER	.FILL	x8001
SP	.FILL	x3000
KBISR	.FILL	xA000
KBISRV	.FILL	x180
KBSR	.FILL	xFE00
ENINT	.FILL	x4000
NAME	.STRINGZ	"Name: Yongye Zhu\n"
EID	.STRINGZ	"EID: yz24493\n"
DATE	.STRINGZ	"Date: 12/06/2018\n"
TITLE	.STRINGZ	"Title: ID Card Data Parser\n"
STICKER	.STRINGZ	":)~~~~~~~~~~~\n"

.END
