; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Title: Minesweeper, Pt. 1
; Name: Yongye Zhu
; EID: yz24493
; Recitation Section: Friday 9-10
;
; You are given the main program
; and some declarations. The subroutines you are responsible for
; are given as empty stubs at the bottom. Follow the contract. 
; You are free to rearrange your subroutines if the need were to 
; arise.

; Testcase 1 - Check if program has been modified

;***********************************************************
.ORIG x3000

;***********************************************************
; Main Program
;***********************************************************
        JSR   DISPLAY_BOARD
        LEA   R0, BOARD_INITIAL
        PUTS
	LDI   R0, BLOCKS
	JSR   LOAD_BOARD
        JSR   DISPLAY_BOARD
        LEA   R0, BOARD_LOADED
        PUTS                        ; output end message
        HALT                        ; halt
BOARD_LOADED       .STRINGZ "\nBoard Loaded\n"
BOARD_INITIAL      .STRINGZ "\nBoard Initial\n"
BLOCKS		   .FILL x6000

;***********************************************************
; Global constants used in program (don't worry about this)
;***********************************************************
SCORE .BLKW 1
;***********************************************************
; This is the data structure for the BOARD grid
;***********************************************************
GRID               .STRINGZ "+-+-+-+-+"
ROW0               .STRINGZ "| | | | |"
                   .STRINGZ "+-+-+-+-+"
ROW1               .STRINGZ "| | | | |"
                   .STRINGZ "+-+-+-+-+"
ROW2               .STRINGZ "| | | | |"
                   .STRINGZ "+-+-+-+-+"
ROW3               .STRINGZ "| | | | |"
                   .STRINGZ "+-+-+-+-+"

;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
; The code above is provided for you. 
; DO NOT MODIFY THE CODE ABOVE THIS LINE.
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************
;***********************************************************



;***********************************************************
; DISPLAY_BOARD
;   Displays the current state of the BOARD Grid.
; Input: None
; Output: None
; Notes: The displayed grid must have the row and column numbers.
;***********************************************************

DISPLAY_BOARD 
;	Register Usage: 
;			R0: used to diaplay board to the console
;			R1: keep track of the row
;			R7: store the return value
;		
	
	ST	R0, SAVE1R0	;store the existing value to a set of buffer
	ST	R1, SAVE1R1
	ST	R7, RET1	;store return value
	
;	starting displaying

	LEA	R0, COL_N
	PUTS
	LEA	R0, DBL_S
	PUTS
	LEA	R0, GRID
	PUTS	
	LEA	R0, ETR
	PUTS

	LD	R1, ZERO
	
	ADD	R0, R1, #0
	OUT
	ADD	R1, R1, #1
	LEA	R0, SIG_S
	PUTS
	LEA	R0, ROW0
	PUTS
	LEA	R0, ETR
	PUTS
	LEA	R0, DBL_S
	PUTS
	LEA	R0, ROW0
	ADD	R0, R0, #10
	PUTS
	LEA	R0, ETR
	PUTS

	ADD	R0, R1, #0
	OUT
	ADD	R1, R1, #1	;increment the row no.
	LEA	R0, SIG_S
	PUTS
	LEA	R0, ROW1
	PUTS
	LEA	R0, ETR
	PUTS
	LEA	R0, DBL_S
	PUTS
	LEA	R0, ROW1
	ADD	R0, R0, #10
	PUTS
	LEA	R0, ETR
	PUTS

	ADD	R0, R1, #0
	OUT
	ADD	R1, R1, #1
	LEA	R0, SIG_S
	PUTS
	LEA	R0, ROW2
	PUTS
	LEA	R0, ETR
	PUTS
	LEA	R0, DBL_S
	PUTS
	LEA	R0, ROW2
	ADD	R0, R0, #10
	PUTS
	LEA	R0, ETR
	PUTS

	ADD	R0, R1, #0
	OUT
	ADD	R1, R1, #1
	LEA	R0, SIG_S
	PUTS
	LEA	R0, ROW3
	PUTS
	LEA	R0, ETR
	PUTS
	LEA	R0, DBL_S
	PUTS
	LEA	R0, ROW3
	ADD	R0, R0, #10
	PUTS
	LEA	R0, ETR
	PUTS

	LD	R0, SAVE1R0		;restore value
	LD	R1, SAVE1R1
	LD	R7, RET1

	RET

SAVE1R0	.BLKW	1
SAVE1R1	.BLKW	1
RET1	.BLKW	1
ZERO	.STRINGZ	"0"
COL_N	.STRINGZ	"   0 1 2 3 \n"
ETR	.STRINGZ	"\n"
SIG_S	.STRINGZ	" "
DBL_S	.STRINGZ	"  "

;***********************************************************
; LOAD_BOARD
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has 3 fields:
;		1. row # (0-3)
;		2. col # (0-3)
;               3. Address of the next gridblock in the list
;         The list is guaranteed to be terminated by a gridblock
;	  whose next address field is a zero.
;
; Output: None
;   This function loads the board from a linked list by inserting 
;   bombs (*) or numbers corresponding to the # of bombs near
;   the position into the grid.
;       
;***********************************************************

;  Register Usage:
;			R0: the header of the list or the current bomb address
;			R1: x coordinate of the bomb
;			R2: y coordinate of the bomb
;			R3: temp to load the sign of bomb (the number in the grid), and the address of the coordinate
;			R4: value -4 to check if we go to the end of row/col
;			R5: store the compare value to check
;			R6: store the ascii offset

LOAD_BOARD
	ST	R7, RET2		;store the value
	ST	R1, SAVE2R1
	ST	R2, SAVE2R2
	ST	R3, SAVE2R3
	ST	R4, SAVE2R4
	ST	R5, SAVE2R5
	ST	R6, SAVE2R6	
	LD	R3, BOMB

;  Step 1: load the bomb, 
;  find the coordinate in the linked and change the corresponding address into a "*"

	ADD	R0, R0, #0		;load the data of the node to register
LD_B	BRZ	LD_NUMS
	LDR	R1, R0, #0
	LDR	R2, R0, #1
	ST	R0, SAVE_H
	JSR	GRID_ADDRESS
	STR	R3, R0, #0
	LD	R0, SAVE_H
	LDR	R0, R0, #2
	BRNZP	LD_B

;  Step 2: load numbers, 
;  use subroutine 3 to generate the number of bombs surrding and store in the corresponding address

LD_NUMS	AND	R1, R1, #0	;initialize all the value needed
	AND	R2, R2, #0
	AND	R3, R3, #0
	AND	R4, R4, #0
	ADD	R4, R4, #-4
	AND	R5, R5, #0
	LD	R6, ASCII
	
BY_ROWS	JSR	GRID_ADDRESS
	ADD	R3, R0, #0	;load the grid address into R3
	JSR	COUNT_BOMBS
	ADD	R0, R0, #0
	BRNZ	#2
	ADD	R0, R0, R6
	STR	R0, R3, #0
	
	ADD	R2, R2, #1
	ADD	R5, R2, R4
	BRN	BY_ROWS
	
	AND	R2, R2, #0
	ADD	R1, R1, #1
	ADD	R5, R1, R4
	BRN	BY_ROWS

RE_S	LD	R1, SAVE2R1		;restore the value
	LD	R2, SAVE2R2
	LD	R3, SAVE2R3
	LD	R4, SAVE2R4
	LD	R5, SAVE2R5
	LD	R6, SAVE2R6
	LD	R7, RET2
	RET

RET2	.BLKW	1
SAVE2R1	.BLKW	1
SAVE2R2	.BLKW	1
SAVE2R3	.BLKW	1
SAVE2R4	.BLKW	1
SAVE2R5	.BLKW	1
SAVE2R6	.BLKW	1
SAVE_H	.BLKW	1
BOMB	.FILL	x2A	;the ASCII code of the bomb ("*")
ASCII	.FILL	x30	;use to convert the numbers into ASCII numbers


;***********************************************************
; COUNT_BOMBS
; Input:  R0  has the address of the head of a linked list of
;         gridblock records. Each record has 3 fields:
;		1. row # (0-3)
;		2. col # (0-3)
;               3. Address of the next gridblock in the list
;         The list is guaranteed to be terminated by a gridblock
;	  whose next address field is a zero.
;
;	  R1 - Row # of location to count bombs around
;	  R2 - Col # of location to count bombs around
;		*Assume that location is valid.
;
; Output: R0 contains the number of bombs
; 		R0 = -1 if the location contains a bomb 
; 
;   This function calculates the number of bombs within one location
;	of the given location.
;       
;***********************************************************


;  Register Usage: 
;			R0, R1, R2: input and output
;			R3, R4: used for input for sub_subroutine
;			R5: used output of the sub_subroutine 
;			R6: temp value

COUNT_BOMBS
	ST	R7, RET3
	ST	R1, SAVE3R1
	ST	R2, SAVE3R2
	ST	R3, SAVE3R3
	ST	R4, SAVE3R4
	ST	R5, SAVE3R5
	ST	R6, SAVE3R6
	
;  check if the location contains a bomb

	ADD	R3, R1, #0
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRP	ISBOMB
	BRNZ	NOTABOMB

NOTABOMB
	AND	R0, R0, #0		;initialize the counter
	AND	R6, R6, #0
	ADD	R6, R6, #-3		;used to check if the row or col is 3


;  CATEGORY: 	1. upper left
;		2. upper middle
;		3. upper left
;		4. middle left
;		5. middle middle
;		6. middle right
;		7. down left
;		8. down middle
;		9. down right

	
	ADD	R2, R2, #0
	BRZ	LEFT
	ADD	R7, R2, R6
	BRZ	RIGHT

	ADD	R3, R1, #0
	ADD	R4, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1			;bomb detected
	ADD	R0, R0, #1


	ADD	R3, R1, #0
	ADD	R4, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1


	
	ADD	R1, R1, #0
	BRZ	UP_MID
	ADD	R7, R1, R6
	BRZ	DOWN_MID



	ADD	R3, R1, #-1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1



	ADD	R3, R1, #1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1


	ADD	R4, R2, #-1
	ADD	R3, R1, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1



	ADD	R4, R2, #1
	ADD	R3, R1, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1


	ADD	R4, R2, #-1
	ADD	R3, R1, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1


	ADD	R4, R2, #1
	ADD	R3, R1, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3

UP_MID	ADD	R3, R1, #1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #1
	ADD	R4, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #1
	ADD	R4, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3

DOWN_MID
	ADD	R3, R1, #-1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #-1
	ADD	R4, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #-1
	ADD	R4, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BRZ	RST3


LEFT	ADD	R3, R1, #0
	ADD	R4, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	
	ADD	R1, R1, #0
	BRZ	UP_LEFT
	ADD	R7, R1, R6
	BRZ	DOWN_LEFT

	ADD	R3, R1, #-1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #-1
	ADD	R4, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #1
	ADD	R4, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3

UP_LEFT	ADD	R3, R1, #1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #1
	ADD	R4, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3

DOWN_LEFT
	ADD	R3, R1, #-1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #-1
	ADD	R4, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3
		
RIGHT	ADD	R3, R1, #0
	ADD	R4, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	
	ADD	R1, R1, #0
	BRZ	UP_RIGHT
	ADD	R7, R1, #0
	BRZ	DOWN_RIGHT

	ADD	R3, R1, #-1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #1
	ADD	R4, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	

	ADD	R3, R1, #-1
	ADD	R4, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3

UP_RIGHT
	ADD	R3, R1, #1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #1
	ADD	R4, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3
	
DOWN_RIGHT
	ADD	R3, R1, #-1
	ADD	R4, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1

	ADD	R3, R1, #-1
	ADD	R4, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3
	
ISBOMB	AND	R0, R0, #0
	ADD	R0, R0, #-1
	BR	RST3

RST3	LD	R1, SAVE3R1		;restore value and return
	LD	R2, SAVE3R2
	LD	R3, SAVE3R3
	LD	R4, SAVE3R4
	LD	R5, SAVE3R5
	LD	R6, SAVE3R6
	LD	R7, RET3
	RET

SAVE3R1	.BLKW	1
SAVE3R2	.BLKW	1
SAVE3R3	.BLKW	1
SAVE3R4	.BLKW	1
SAVE3R5	.BLKW	1
SAVE3R6	.BLKW	1
RET3	.BLKW	1



;***********************************************************
; CHECK_BOMB
; Input: R3 has the row number (0-3)
;        R4 has the column number (0-3)
; Output: if the location contains bombs, return R5 = 1;
;	  if there is no bomb in that location, return R5 = 0;
;***********************************************************


; Compare the content in the address and the ASCII of bomb "*"
; Register Usage:
;			R3, R4, R5: Input and Output
;			R1, R2: temp store for calling subroutine4
;			R6: Temp register that stores the compared value


CHECK_BOMB
	ST	R7, SS_RET
	ST	R0, SS_R0
	ST	R1, SS_R1
	ST	R2, SS_R2
	ST	R6, SS_R6
	
	ADD	R1, R3, #0
	ADD	R2, R4, #0
	

JSR	GRID_ADDRESS
	LD	R1, ASC_BOMB
	LDR	R2, R0, #0
	NOT	R1, R1
	ADD	R1, R1, #1		;2'S COMPLEMENT
	ADD	R6, R1, R2
	BRNP	NO_BOMB

D_BOMB	AND	R5, R5, #0		;bomb detected, R0 = -1 and return
	ADD	R5, R5, #1
	BR	RST_V

NO_BOMB	AND	R5, R5, #0


RST_V	LD	R0, SS_R0
	LD	R1, SS_R1
	LD	R2, SS_R2
	LD	R6, SS_R6
	LD	R7, SS_RET
	RET

SS_RET	.BLKW	1
SS_R0	.BLKW	1
SS_R1	.BLKW	1
SS_R2	.BLKW	1
SS_R6	.BLKW	1
ASC_BOMB	.STRINGZ	"*"

;***********************************************************
; GRID_ADDRESS
; Input:  R1 has the row number (0-3)
;         R2 has the column number (0-3)
; Output: R0 has the corresponding address of the space in the GRID
; Notes: This is a key routine.  It translates the (row, col) logical 
;        GRID coordinates of a gridblock to the physical address in 
;        the GRID memory.
;***********************************************************

;	Register Usage: 
;			R3: calculate the offset (number of the rows)
;			R4: calculate the offset (number of the cols)

GRID_ADDRESS
	ST	R7, RET4		;store the return value
	ST	R1, SAVE4R1
	ST	R2, SAVE4R2
	ST	R3, SAVE4R3
	ST	R4, SAVE4R4

	LD	R0, R_ROW0		;load the address of [0][0]

;  Calculate the offset
;  ROW, represented by the address of row0 + 20 * row_number

	AND	R3, R3, #0
	LD	R4, ROW
	ADD	R1, R1, #0
ROWS	BRZ	COLS
	ADD	R3, R3, R4
	ADD	R1, R1, #-1
	BR	ROWS
;  COLS, represented by the address of row[] + (2 * n_cols - 1)

COLS	ADD	R0, R0, R3
	ADD	R2, R2, R2
	ADD	R2, R2, #1
	ADD	R0, R0, R2

	LD	R1, SAVE4R1		;restore value
	LD	R2, SAVE4R2
	LD	R3, SAVE4R3
	LD	R4, SAVE4R4
	LD	R7, RET4	
	RET

RET4	.BLKW	1
SAVE4R1	.BLKW	1
SAVE4R2	.BLKW	1
SAVE4R3	.BLKW	1
SAVE4R4	.BLKW	1
ROW	.FILL	#20
R_ROW0	.FILL	x3034

.END