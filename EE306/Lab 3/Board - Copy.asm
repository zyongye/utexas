; This file has the linked list for the
; board's layout
	.ORIG	x6000
	.FILL	Head

blk2
        .FILL	0
	.FILL   1
	.FILL   blk4

blk6
	.FILL   0
	.FILL   2	
	.FILL   blk7

Head
        .FILL   0
	.FILL   0
	.FILL	blk1

blk1
	.FILL   1
	.FILL   0
	.FILL   blk3

blk3
	.FILL   1
	.FILL   2
	.FILL   blk2

blk4
	.FILL   2
	.FILL   0
	.FILL   blk5

blk5
	.FILL   2
	.FILL   1
	.FILL   blk6

blk7	.FILL	2
	.FILL	2
	.FILL	0
	.END	