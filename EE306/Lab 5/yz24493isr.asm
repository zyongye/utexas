; Title: ID Card Data Parser - ISR
; Name: Yongye Zhu
; EID: yz24493
; Date: 12/06/2018
; Recitation Section: Friday 9-10
; Description of program: Reads a character from console
;	and increments character count
; Keyboard ISR runs when a key is struck


.ORIG xA000
	ST	R0, SAVER0

	LDI	R0, KBDR
	STI	R0, ST_C	;store what is in KBDR into x8000

	LDI	R0, COUNT
	ADD	R0, R0, #1
	STI	R0, COUNT	;increment the counter

	LD	R0, SAVER0	;restore the value
	
	RTI
SAVER0	.BLKW	1
ST_C	.FILL	x8000
COUNT	.FILL	x8001
KBDR	.FILL	xFE02
.END
