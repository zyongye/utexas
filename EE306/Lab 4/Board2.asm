; This file has the linked list for the
; Jungle's layout #(3,1)->H(1,2)->#(3,3)->S(2,1)->#(1,1)->#(0,2)->#(0,0)
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
	.FILL   3
	.FILL   3
	.FILL   blk5

blk5	.FILL   2
	.FILL   1
	.FILL   blk2

blk4
	.FILL   0
	.FILL   2
	.FILL   blk6
blk6
	.FILL   0
	.FILL   0
	.FILL   0
	.END	