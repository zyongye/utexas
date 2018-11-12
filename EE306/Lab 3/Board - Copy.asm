; This file has the linked list for the
; board's layout
	.ORIG	x6000
	.FILL	Head

blk2
        .FILL	0
	.FILL   0
	.FILL   blk4

blk6
	.FILL   3
	.FILL   2
	.FILL   0

Head
        .FILL   0
	.FILL   3
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
	.FILL   2
	.FILL   3
	.FILL   blk5

blk5
	.FILL   3
	.FILL   0
	.FILL   blk6
	.END	