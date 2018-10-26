.ORIG x2500
;  write your code
;  for sorting
;  in the following lines until
;  the following instructions should
;  come after the last line of your
;  sorting program



;  Code Purpose: sorting a linked list (bubble sort)
;  Register Usage: 
;			R0: the addr of the header (addr of the previousNode.addr)
;			R1: currentNode.data
;			R2: currentNode.addr (pointer to the nextNode)
;			R3: nextNode.data
;			R4: nextNode.addr (pointer to the node after the nextNode)
;			R7: outer_counter, the number of node
;			R6: inner_counter



	AND	R7, R7, #0
	AND	R6, R6, #0		

;	First Step: tranverse the data to see how many node 

	LDI	R0, HEADER
COUNT	BRZ	SORT
	;ADD 	R7, R7, #0
	;BRZ	MOV1			;test if R0 is the header; if yes, load the content; if no, load R0->addr
	ADD	R7, R7, #1
	LDR	R0, R0, #2
	BRNZP	COUNT
	
;	Second Step: start sorting
;
;		Substep1: load the initial value and set the inner_counter R6	


SORT	LD	R0, HEADER
	LDR	R5, R0, #0
	ADD	R7, R7, #-1		;test if there is only one node; if yes, no sort
	BRZ	END			;test of the header is null

S_ICTR	ADD	R6, R7, #0

LOAD_V	LDR	R1, R5, #1
	LDR	R2, R5, #2
	LDR	R3, R2, #1
	LDR	R4, R2, #2	

	
;		Substep2: compare value between the value in the node
;			if need swap, go to swap, then change the counter; if not swap, change the counter, then go to the LOAD_V
;			Register usage: 
;					R5: temp register, store the negative value, then store the value after substruction


	NOT 	R5, R3
	ADD 	R5, R5, #1
	ADD	R5, R1, R5
	BRP	SWAP
	BRN	N_SWAP

;		Substep3: subroutine1: swap, then substuct the counter
;			Additional Register Usage: 
;							R5: the pointer to the currentNode (R5 = M[R0])

SWAP	LDR	R5, R0, #0		;store the address of the currentNode
	STR	R2, R0, #0		;link the nextNode to the previousNode
	STR	R4, R5, #2		;link the Node after the nextNode to the current Node
	STR	R5, R2, #2		;link the currentNode to the nextNode
	BRNZP	C_ICTR			;go to the statement that reload R0 and changes the inner_counter

N_SWAP	BRNZP	C_ICTR			;go to the statement that reload R0 and changes the inner_counter


;		Substep4: change the inner_counter, and re-load the value; if the inner_counter is 0, change the outer_counter R7

C_ICTR	LDR	R0, R0, #0
	ADD	R0, R0, #2
	LDR	R5, R0, #0
	ADD 	R6, R6, #-1
	BRP	LOAD_V
	BRZ	C_OCTR

C_OCTR	ADD	R7, R7, #-1
	LD	R0, HEADER
	LDR	R5, R0, #0
	ADD	R7, R7, #0
	BRNZ	END
	BRP	S_ICTR

END	HALT

LD R0, DELP
JMP R0
DELP	.FILL	x2700
HEADER	.FILL	x3200
.END
