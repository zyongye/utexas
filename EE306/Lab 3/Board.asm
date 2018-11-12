; This file has the linked list for the
; board's layout
	.ORIG	x6000
	.FILL	Head

blk2
        .FILL	1
	.FILL   1
	.FILL   blk4

Head
        .FILL   3
	.FILL   1
	.FILL	blk1

blk1
	.FILL   1
	.FILL   2
	.FILL   blk3

blk3
	.FILL   2
	.FILL   1
	.FILL   blk2

blk4
	.FILL   0
	.FILL   2
	.FILL   0
	.END	