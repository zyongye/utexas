; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Title: Minesweeper, Pt. 2
; Author: Yongye Zhu
; Recitation Section: Friday, 9-10
;
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
	LEA   R0, START_GAME
	PUTS
        JSR   DISPLAY_BOARD
        LEA   R0, BOARD_INITIAL
        PUTS
ENGINE	JSR   GET_MOVE
	JSR   IS_VALID_MOVE
	ADD   R0,R0,#0
	BRn   ENGINE
	JSR   APPLY_MOVE
        JSR   DISPLAY_BOARD
	JSR   IS_GAME_OVER
	ADD   R0,R0,#0
	BRz   ENGINE
	JSR   GAME_OVER	
        HALT                        ; halt
BOARD_LOADED       .STRINGZ "\nBoard Loaded\n"
BOARD_INITIAL      .STRINGZ "\nBoard Initial\n"
START_GAME	.STRINGZ "Minesweeper\n"
BLOCKS		    .FILL x6000

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
; Lab 3 subroutines - copy here
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
COL_N	.STRINGZ	"\n   0 1 2 3 \n"
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
	LD	R0, BLOCKS
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
; GET_MOVE

; Input: None
; Output: R0 - Input 1; R1 - Input 2
;***********************************************************

;	Register Usage:
;			R0: OUTPUT ROW
;			R1: OUTOUT COL


GET_MOVE
	ST	R7, RET5

	LEA R0, ETR_MOV
	PUTS
	GETC
	OUT
	ST	R0, N_ROW
	LEA	R0, CMA
	PUTS
	GETC
	OUT
	ADD	R1, R0, #0
	LEA	R0, R_PAR
	PUTS

	LD	R0, N_ROW
	LD	R7, RET5
	RET


RET5	.BLKW	1
ETR_MOV	.STRINGZ	"Enter a move: ("
R_PAR	.STRINGZ	")\n"
CMA	.STRINGZ	","
N_ROW	.BLKW	1


;***********************************************************
; IS_VALID_MOVE

; Input: R0 - Input 1 (row); R1 - Input 2 (col)
; Output: If valid, set (R0,R1)=(row,col) to move; else R0 = -1
;***********************************************************



;  Test if the input is greater than x30(ascii 0) and less than x33(ascii 3)
;
;  Register Usage: 
;			R0, R1: input and output
;			R2: contain nagativev value of the valid ascii of the row/col checked
;			R3: store the result of the comparison



IS_VALID_MOVE

	ST	R7, RET6
	ST	R2, SAVE6R2
	ST	R3, SAVE6R3

	LD	R2, NH_ZERO		;check row first, if ascii is less than zero, then branch to N_VALID
	ADD	R3, R0, R2
	BRN	N_VALID

	ADD	R3, R1, R2
	BRN	N_VALID

	LD	R2, NH_THRE
	ADD	R3, R0, R2
	BRP	N_VALID

	ADD	R3, R1, R2
	BRP	N_VALID

	LD	R2, NH_ZERO
	
	ADD	R0, R0, R2
	ADD	R1, R1, R2
	BR	RST6

N_VALID	LEA	R0, MSG6
	PUTS				;print message
	AND	R0, R0, #0
	ADD	R0, R0, #-1
	
RST6	LD	R2, SAVE6R2
	LD	R3, SAVE6R3
	LD	R7, RET6
	RET

RET6	.BLKW	1
SAVE6R2	.BLKW	1
SAVE6R3	.BLKW	1
NH_ZERO	.FILL	xFFD0		;contain -x30
NH_THRE	.FILL	xFFCD		;contain -x33
MSG6	.STRINGZ	"Invalid move - try again!\n"

;***********************************************************
; APPLY_MOVE

; Input: (R0,R1) = (Row,Col) of desired move
; Output: (R0,R1) = (Row,Col) of completed move
;***********************************************************

;  Register Usage: 
;			R0: input/output, used to print massage, get output from count bomb
;			R1: input/output, 
;			R2: input of count bomb; load the number in the linked ist
;			R3: used to compare
;			R4: store the header of the user's linked list, or starting address of each node

APPLY_MOVE

	ST	R7, RET7
	ST	R0, SAVE7R0
	ST	R1, SAVE7R1
	ST	R2, SAVE7R2
	ST	R3, SAVE7R3
	ST	R4, SAVE7R4

;  STEP 1: check if users tried the location
;		scarch in linked list, if found, return tried; 
;		if not, put on the linked list; count bomb in that location and put in the grid
;
;  For linked list: first space store the current row, second space store the current col; third space store the address of next node(zero means end)


	LEA	R4, L_LIST
C_EMPT	LDR	R2, R4, #0
	BRZ	NO_TRY
	LDR	R4, R4, #0
	LDR	R2, R4, #0
	NOT	R2, R2
	ADD	R2, R2, #1
	ADD	R3, R0, R2
	BRNP	NXT_N
	LDR	R2, R4, #1
	NOT	R2, R2
	ADD	R2, R2, #1
	ADD	R3, R1, R2
	BRNP	NXT_N
	BR	TRIED

NXT_N	ADD	R4, R4, #2
	BR	C_EMPT

TRIED	LEA	R0, MSG7
	PUTS
	BR	RST7
	
NO_TRY	LEA	R4, L_LIST
	LDR	R2, R4, #0
	BRZ	ADD_NODE
	LDR	R4, R4, #0
	ADD	R4, R4, #2
	BR	#-5

ADD_NODE
	ADD	R2, R4, #1
	STR	R2, R4, #0
	STR	R0, R2, #0
	STR	R1, R2, #1

;count bomb and put into grid
	
	ADD	R2, R1, #0
	ADD	R1, R0, #0
	LD	R0, HEADER1
	JSR	COUNT_BOMBS
	ADD	R3, R0, #0
	BRZ	RST7
	BRP	#2
	LD	R3, A_BOMB1
	BR	#2
	LD	R4, H_ZERO
	ADD	R3, R3, R4
	JSR	GRID_ADDRESS
	STR	R3, R0, #0
	
RST7	LD	R0, SAVE7R0
	LD	R1, SAVE7R1
	LD	R2, SAVE7R2
	LD	R3, SAVE7R3
	LD	R4, SAVE7R4
	LD	R7, RET7
	RET



RET7	.BLKW	1
SAVE7R0	.BLKW	1
SAVE7R1	.BLKW	1
SAVE7R2	.BLKW	1
SAVE7R3	.BLKW	1
SAVE7R4	.BLKW	1
MSG7	.STRINGZ	"You already tried this location!"
HEADER1	.FILL	x6000
A_BOMB1	.STRINGZ	"*"
H_ZERO	.FILL	x30
L_LIST	.BLKW	49


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
;			R0, R1, R2: input and output, R0 is also a bomb counter
;			R3: head of the lined list
;			R4: 
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

	ADD	R3, R0, #0
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

	ADD	R1, R1, #0
	ADD	R2, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1			;bomb detected
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS


	ADD	R1, R1, #0
	ADD	R2, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS


	
	ADD	R1, R1, #0
	BRZ	UP_MID
	ADD	R7, R1, R6
	BRZ	DOWN_MID



	ADD	R1, R1, #-1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS



	ADD	R1, R1, #1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS


	ADD	R2, R2, #-1
	ADD	R1, R1, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS



	ADD	R2, R2, #1
	ADD	R1, R1, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS


	ADD	R2, R2, #-1
	ADD	R1, R1, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS


	ADD	R2, R2, #1
	ADD	R1, R1, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3

UP_MID	ADD	R1, R1, #1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #1
	ADD	R2, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #1
	ADD	R2, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3

ISBOMB	AND	R0, R0, #0
	ADD	R0, R0, #-1
	BR	RST3

SAVE3R1	.BLKW	1
SAVE3R2	.BLKW	1
SAVE3R3	.BLKW	1
SAVE3R4	.BLKW	1
SAVE3R5	.BLKW	1
SAVE3R6	.BLKW	1
RET3	.BLKW	1
HEADERS	.FILL	x6000


DOWN_MID
	ADD	R1, R1, #-1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #-1
	ADD	R2, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #-1
	ADD	R2, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3


LEFT	ADD	R1, R1, #0
	ADD	R2, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS
	
	ADD	R1, R1, #0
	BRZ	UP_LEFT
	ADD	R7, R1, R6
	BRZ	DOWN_LEFT

	ADD	R1, R1, #-1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #-1
	ADD	R2, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #1
	ADD	R2, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3

UP_LEFT	ADD	R1, R1, #1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #1
	ADD	R2, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3

DOWN_LEFT
	ADD	R1, R1, #-1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #-1
	ADD	R2, R2, #1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3
		
RIGHT	ADD	R1, R1, #0
	ADD	R2, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS
	
	ADD	R1, R1, #0
	BRZ	UP_RIGHT
	ADD	R7, R1, #0
	BRZ	DOWN_RIGHT

	ADD	R1, R1, #-1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #1
	ADD	R2, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS
	

	ADD	R1, R1, #-1
	ADD	R2, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3

UP_RIGHT
	ADD	R1, R1, #1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #1
	ADD	R2, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3
	
DOWN_RIGHT
	ADD	R1, R1, #-1
	ADD	R2, R2, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	LD	R1, SAVE3R1
	LD	R2, SAVE3R2
	LD	R3, HEADERS

	ADD	R1, R1, #-1
	ADD	R2, R2, #-1
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRZ	#1
	ADD	R0, R0, #1
	BR	RST3
	

RST3	LD	R1, SAVE3R1		;restore value and return
	LD	R2, SAVE3R2
	LD	R3, SAVE3R3
	LD	R4, SAVE3R4
	LD	R5, SAVE3R5
	LD	R6, SAVE3R6
	LD	R7, RET3
	RET


;***********************************************************
; CHECK_BOMB
; Input: R1: the row number
;	 R2: the col number
;	 R3 contains the header of the linked list
;
; Output: if the location contains bombs, return R5 = 1;
;	  if there is no bomb in that location, return R5 = 0;
;***********************************************************


; Compare the content in the address and the ASCII of bomb "*"
; Register Usage:
;			R1: row num 
;			R2: col num			
;			R3: header of the linked list or the address of the node
;			R4: row number in the linked list
;			R5: col number in the linked list
;			R6: Temp register that stores the compared value


CHECK_BOMB
	ST	R7, SS_RET
	ST	R0, SS_R0
	ST	R1, SS_R1
	ST	R3, SS_R3
	ST	R2, SS_R2
	ST	R4, SS_R4
	ST	R6, SS_R6
	
	NOT	R1, R1
	ADD	R1, R1, #1
	NOT	R2, R2
	ADD	R2, R2, #1

	LDR	R3, R3, #0
CK_ROW	ADD	R3, R3, #0
	BRZ	NOT_BOMB
	LDR	R4, R3, #0
	ADD	R6, R1, R4
	BRNP	NEXT_NODE
	LDR	R5, R3, #1
	ADD	R6, R2, R5
	BRNP	NEXT_NODE
	BRNZP	D_BOMB

NEXT_NODE
	LDR	R3, R3, #2
	BR	CK_ROW
	
D_BOMB	AND	R5, R5, #0
	ADD	R5, R5, #1
	BR	RST_V
	
NOT_BOMB
	AND	R5, R5, #0

RST_V	LD	R0, SS_R0
	LD	R1, SS_R1
	LD	R2, SS_R2
	LD	R3, SS_R3
	LD	R4, SS_R4
	LD	R6, SS_R6
	LD	R7, SS_RET
	RET

SS_RET	.BLKW	1
SS_R0	.BLKW	1
SS_R1	.BLKW	1
SS_R2	.BLKW	1
SS_R3	.BLKW	1
SS_R6	.BLKW	1
SS_R4	.BLKW	1
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
R_ROW0	.FILL	x3047

;***********************************************************
; IS_GAME_OVER
; Assume APPLY_MOVE called before. 
; Input: (R0,R1) - (Row,Col) of last move
; Output: 0 - Game not over; 1 - Player won; -1 - Player lost
;***********************************************************

;  	Register Usage: 
;			R0: input/ output status
;			R1: input for cols/ input rows for subroutine check_bomb/number of node for user's linked list
;			R2: used for input cols for subroutine -- check_bomb/number of node for global linked list
;			R3: used for subroutine check_bomb -- header of the global linked_list and header of user's linked list
;			R5: used for output for count_bomb subroutine/the content of the linked list(check if has nect node)

IS_GAME_OVER

	ST	R7, RET8
	ST	R0, SAVE8R0
	ST	R1, SAVE8R1
	ST	R2, SAVE8R2
	ST	R3, SAVE8R3
	ST	R5, SAVE8R5

;  Step 1: check if the last move ravel a bomb

	LD	R3, HDR2
	ADD	R2, R1, #0
	ADD	R1, R0, #0
	JSR	CHECK_BOMB
	ADD	R5, R5, #0
	BRP	LOST

;  STEP 2: traverse both global linked_list (location for bombs) and user's linked list (contain tried location)
;	   check if the sum is 16; if is 16, means Game_over and user win; if not, game continues

;	SubStep 1: count the number of node in global linked_list

CNT_B	LD	R3, HDR2
	AND	R2, R2, #0
	LDR	R5, R3, #0
	BRZ	CNT_TRIAL
	ADD	R2, R2, #1
	LDR	R3, R3, #0
	ADD	R3, R3, #2
	BR	#-6

CNT_TRIAL
	LD	R3, ULL
	AND	R1, R1, #0
	LDR	R5, R3, #0
	BRZ	CHECK_OVER
	ADD	R1, R1, #1
	LDR	R3, R3, #0
	ADD	R3, R3, #2
	BR	#-6

CHECK_OVER
	LD	R5, NHEX16
	ADD	R0, R1, R2
	ADD	R5, R5, R0
	BRZ	WIN
	BRN	N_OVER

WIN	AND	R0, R0, #0
	ADD	R0, R0, #1
	BR	RST8

N_OVER	AND	R0, R0, #0
	BR	RST8

LOST	AND	R0, R0, #0
	ADD	R0, R0, #-1


RST8	LD	R2, SAVE8R2
	LD	R3, SAVE8R3
	LD	R5, SAVE8R5
	LD	R7, RET8
	RET

RET8	.BLKW	1
SAVE8R0	.BLKW	1
SAVE8R1	.BLKW	1
SAVE8R2	.BLKW	1
SAVE8R3	.BLKW	1
SAVE8R5	.BLKW	1
HDR2	.FILL	x6000	;header of global linked list
ULL	.FILL	x31FE	;header of user's linked list
NHEX16	.FILL	xFFF0	;store -#16 used to compare



;***********************************************************
; GAME_OVER
; 
; Input: R0 = 1 if player won; R0 = -1 if player lost
; Output: None
;***********************************************************

;  Register Usage: 
;			R1: score in binary
;			R2: header of user's linked list
;			R3: content in the linked list



GAME_OVER
	ST	R7, RET9
	ST	R1, SAVE9R1
	ST	R2, SAVE9R2
	ST	R3, SAVE9R3

	ADD	R0, R0, #0
	BRP	WON
	BRN	LST

WON	LEA	R0, WIN_MSG
	PUTS
	LDI	R0, HDR2
	JSR	LOAD_BOARD
	JSR	DISPLAY_BOARD
	LEA	R0, S_MSG
	PUTS
	LEA	R0, WINS
	PUTS
	LEA	R0, ETR1
	PUTS
	BR	RST9
	
LST	

; First count the score in binary, that is, how many trial user does; interpret as how many node in user's linked list

	AND	R1, R1, #0
	LD	R2, ULL
	LDR	R3, R2, #0
	BRZ	PRT_MSG
	ADD	R1, R1, #1
	LDR	R2, R2, #0
	ADD	R2, R2, #2
	BR	#-6

; Second check if the score is greater than 10

PRT_MSG	LD	R3, ACI
	ADD	R2, R1, #-10
	BRN	N_CONVERT
	ADD	R1, R3, #1
	ADD	R2, R2, R3
	LEA	R0, LST_MSG
	PUTS
	LDI	R0, HDR2
	JSR	LOAD_BOARD
	JSR	DISPLAY_BOARD
	LEA	R0, S_MSG
	PUTS
	ADD	R0, R1, #0
	OUT
	ADD	R0, R2, #0
	OUT
	LEA	R0, ETR1
	PUTS
	BR	RST9
	
N_CONVERT
	ADD	R1, R1, R3
	LEA	R0, LST_MSG
	PUTS
	LDI	R0, HDR2
	JSR	LOAD_BOARD
	JSR	DISPLAY_BOARD
	LEA	R0, S_MSG
	PUTS
	ADD	R0, R1, #0
	OUT
	LEA	R0, ETR1
	PUTS

RST9	LD	R1, SAVE9R1
	LD	R2, SAVE9R2
	LD	R3, SAVE9R3
	LD	R7, RET9
	RET
RET9	.BLKW	1
SAVE9R1	.BLKW	1
SAVE9R2	.BLKW	1
SAVE9R3	.BLKW	1
WIN_MSG	.STRINGZ	"\nCongrats, you won!\n"
LST_MSG	.STRINGZ	"\nYou lost! Better luck next time!\n"
S_MSG	.STRINGZ	"\nYour score is: "
WINS	.STRINGZ	"99"
ETR1	.STRINGZ	"\n"
ACI	.FILL	x30
.END

