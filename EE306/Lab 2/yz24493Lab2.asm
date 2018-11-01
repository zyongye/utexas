; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
; Name: Yongye ZHu
; EID: yz24493
; Recitation Section: Friday 9-10
;
; This program computes the solutions to
; the quadratic equation y=ax^2+bx+c (a is non-zero).
;
; Inputs: 
; 	A - Stored in x4000
; 	B - Stored in x4001
;	C - Stored in x4002
;
; Outputs:
; 	Number of solutions - Stored in x4000
;	Solution 1 - Stored in x4001
; 	Solution 2 - Stored in x4002
;
;  Note: If there are two solutions, Solution 1 < Solution 2.
; 
;  Three main routines to solve: how to multiply, how to sqrt, how to divide.


.ORIG x3000

;  First step: do the multiplication b^2
;  Register usage: 
;		   R0: store the value of the product
;		   R1: store the value of b
;		   R2: track the time of multiplication

	AND 	R0, R0, #0
	LDI 	R1, B
	LDI	R2, B
	BRZ	STEP2
	BRP	C_R2		;test if b is negative
	NOT	R1, R1
	NOT	R2, R2
	ADD	R1, R1, #1
	ADD	R2, R2, #1
C_R2	BRNZ 	STEP2
	ADD 	R0, R0, R1
	ADD 	R2, R2, #-1
	BRNZP 	C_R2		;check the number of time of multiplication

;  Step 2: calculate the product of 4*a*c
;  Register usage:
;		   R1: store the result
;		   R2: store the value of a 
;		   R3: store the value of c;
;		   R4: store the value of the constant #4 
;		   R5: store the change of sign

STEP2	AND 	R1, R1, #0
	AND	R5, R5, #0

	LDI 	R2, A
	BRZ	STEP3
	BRP	CHECK_C
	NOT	R2, R2
	ADD	R2, R2, #1
	ADD	R5, R5, #1

CHECK_C	LDI 	R3, C
	BRZ	STEP3
	BRP	#3
	NOT	R3, R3
	ADD	R3, R3, #1
	ADD	R5, R5, #1

	AND 	R4, R4, #0
	ADD 	R4, R4, #2		;to multiply by 4, we can multiply by 2 twice
MULT1	ADD 	R1, R1, R2
	ADD 	R3, R3, #-1
	BRP 	#-3
	
MULT2	ADD 	R1, R1, R1
	ADD 	R4, R4, #-1
	BRP 	#-3

	ADD	R5, R5, #-1
	BRNP	STEP3
	NOT	R1, R1
	ADD	R1, R1,#1

;  Step 3: do the substraction and check the determint
;  Register Usage:
;		   R0: the value of b*b
;		   R1: the value of 4*a*c
;		   R2: store the value of determint
;		   R3: temp for the substraction operation

STEP3	NOT	R3, R1
	ADD	R3, R3, #1		; 2's complement
	ADD	R2, R0, R3
	BRN	NO_S			;jump to statement that deal with 0 solution
	BRZ	ADD_S			;if the determint is 0, directly generate the root
	BRP	S_ROOT			;jump to the statement that calculate the square root

;  Step 4: check determint and branch to each condition
;  Register Usage: 
;			R0: the value of the fitst solution (always the smaller one)
;			R1: the value of the larger solution (always the bigger one)
;			R4: the numer of solutions
;
	AND	R0, R0, #0
	AND	R1, R1, #0
	AND 	R4, R4, #0
	
NO_S	AND	R4, R4, #0
	STI	R4, A
	BRNZP	END

;  Substep: make a square root of a perfect square number (1, 4, 9... etc.)
;  Method: series	(1 = 1)
;			(4 = 1 + 3)
;			(9 = 1 + 3 + 5)
;
;  Register Usage:
;			R5: store the square root  
;			R3: temp register that store the square that will be tested
;			R6: generate the (2n - 1) to be added to R3
;			

S_ROOT	AND	R5, R5, #0
	AND	R3, R3, #0
	NOT	R2, R2
	ADD	R2, R2, #1	;generate -R2 to check if identical
GRT_E	ADD	R5, R5, #1
	ADD	R6, R5, R5
	ADD	R6, R6, #-1
	ADD	R3, R3, R6
	ADD	R6, R3, R2
	BRN	GRT_E



;  Additional Step: genertate and initilize all the elements that are needed to calculate the square root
;  Register Usage:
;			R0: the smaller solution
;			R1: the larger solution
;			R2: -b
;			R3: -2a (used for divide)
;			R4: store the number of root and the negative sign counter
;			R5: store the square root
;			R6: large dividend
;			R7: smaller dividend
;

ADD_S	AND	R0, R0, #0
	AND	R1, R1, #0
	AND	R3, R3, #0
	LDI	R2, B
	NOT	R2, R2
	ADD	R2, R2, #1	;generate -b
	LDI	R3, A
	ADD	R3, R3, R3	;generate 2a
	NOT	R3, R3
	ADD	R3, R3, #1	;generate -2a
	STI	R3, N2A
	ADD	R5, R5, #0
	BRZ	ONE_S
	BRP	TWO_S
	

ONE_S	AND	R5, R5, #0
	ADD 	R4, R4, #1
	STI	R4, A
	AND	R4, R4, #0
	ADD	R7, R2, R5	;-b + S_root

	BRZ	OUTPUT0
	BRP	C_2A1
	NOT	R7, R7
	ADD	R7, R7, #1
	ADD	R4, R4, #1
C_2A1	ADD	R3, R3, #0
	BRN	DIVIDE1
	NOT	R3, R3
	ADD	R3, R3, #1

DIVIDE1	ADD	R7, R7, R3
	ADD	R0, R0, #1
	ADD	R7, R7, #0
	BRZ	C_SIGN
	BRP	DIVIDE1

C_SIGN	ADD	R4, R4, #-1		;apply sign
	BRNP	OUTPUT0
	NOT	R0, R0
	ADD	R0, R0, #1
	BRNZP	OUTPUT0
	

TWO_S	ADD	R4, R4, #2
	STI	R4, A
	AND	R4, R4, #0
	ADD	R6, R2, R5	;generate -b + s_root
	NOT	R5, R5
	ADD	R5, R5, #1
	ADD	R7, R2, R5	;generate -b - s_root
	BRZ	C_LGR
	BRP	C_2AS
	NOT	R7, R7
	ADD	R7, R7, #1
	ADD	R4, R4, #1
C_2AS	ADD	R3, R3, #0
	BRN	DIVIDES
	NOT	R3, R3
	ADD	R3, R3, #1
	ADD	R4, R4, #1

DIVIDES	ADD	R7, R7, R3
	ADD	R0, R0, #1
	ADD	R7, R7, #0
	BRZ	C_SIGNS
	BRP	DIVIDES

C_SIGNS	ADD	R4, R4, #-1		;apply sign
	BRNP	C_LGR
	NOT	R0, R0
	ADD	R0, R0, #1
	BRNZP	C_LGR

C_LGR	LDI	R3, N2A
	AND	R4, R4, #0
	ADD	R6, R6, #0
	BRZ	OUTPUT1
	BRP	C_2AL
	NOT	R6, R6
	ADD	R6, R6, #1
	ADD	R4, R4, #1
C_2AL	ADD	R3, R3, #0
	BRN	DIVIDEL
	NOT	R3, R3
	ADD	R3, R3, #1
	ADD	R4, R4, #1

DIVIDEL	ADD	R6, R6, R3
	ADD	R1, R1, #1
	ADD	R6, R6, #0
	BRZ	C_SIGNL
	BRP	DIVIDEL

C_SIGNL	ADD	R4, R4, #-1		;apply sign
	BRNP	OUTPUT1
	NOT	R1, R1
	ADD	R1, R1, #1
	BRNZP	OUTPUT1
	
	

OUTPUT0	STI	R0, B
	STI	R1, C
	BRNZP	END

OUTPUT1	NOT	R2, R0
	ADD	R2, R2, #1
	ADD	R2, R1, R2
	BRP	OUTPUT0
	STI	R0, C
	STI	R1, B

	 
END	HALT
A	.FILL 	x4000
B 	.FILL 	x4001
C	.FILL 	x4002
N2A	.BLKW	1	

.END
