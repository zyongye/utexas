; EE 306: Introduction to Computing
; Fall 2018 - Cuevas
; 
;Name: Yongye Zhu
;EID: yz224493
;Recitation: Friday 9-10
;
; Title: Rotate Register
; Author: Jerry Yang
; Created on: 9/6/2018
;
; This program implements R0 as a rotate register.
; Inputs: 
; 	R0 - Data to rotate
; 	R1 - How many times to rotate
;	 If R1<0, rotate right |R1| times
;	 If R1>0, rotate left R1 times.
;
; Outputs:
; 	R0 - Rotated data
;  

.ORIG x3000
	 						; This is where your code is loaded into LC3.
							; x3000 is the "standard" place.
	
	AND R4,R4,#0					; use R4 to store the leftside bit
	ADD R0, R0, #0
	BRZ #33
	ADD R1, R1, #0
	BRN #9
LOOP	BRZ #30						;go to the end of program if rotate 0 times
	ADD R0, R0, #0
	BRZP #1						;check the leftmost bit and store it in R4
	ADD R4, R4, #1 
	ADD R0, R0, R0
	ADD R0, R0, R4
	AND R4, R4, #0					;clear leftmost bit
	ADD R1, R1, #-1 
	BRNZP LOOP					;shift leftside complete
	AND R2, R2, #0					;right shift begin, method: spilt the bits into two parts and change positions
	AND R3, R3, #0					;R2 store left side of original bits and r3 store the right bits
	AND R5, R5, #0					;use r5 as bitmask to spilt the last x bits
	ADD R6, R1, #15					;r6 is used to count the number that each part shift
	ADD R1, R1, #0					
	BRZ #4						;generating bitmask
	ADD R5, R5, R5
	ADD R5, R5, #1
	ADD R1, R1, #1
	BRNZP #-5 
	AND R3, R0, R5					;generating the right side 
	ADD R6, R6, #0
	BRN #8
	ADD R2, R2, R2
	ADD R0, R0, #0
	BRZP #1
	ADD R2, R2, #1					;left shift to store the next bit from r0
	ADD R3, R3, R3					;left shift right side to the left side
	ADD R0, R0, R0
	ADD R6, R6, #-1
	BRNZP #-9
	ADD R0, R3, R2					;connect two part to create the output
HALT 			; Halts the machine
			; LC3 will jump to an odd location and fill
			; your registers with weird values. To prevent
			; this, place a breakpoint before the HALT
			; instruction and observe R0.


.END			; This pseudo-op tells the assembler that this
			; is the end of the file.
