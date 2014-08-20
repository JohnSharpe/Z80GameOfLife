ORG 40000

MAIN	CALL	CLS
	CALL	ATT
	CALL	SET1
	CALL	KLOOP
	RET

KLOOP	
	LD	A,0
	LD 	A,0FBh ; check keyboard for ‘Break Key’
	IN 	A,(0FEh) ; and read the port
	RRA ; check the appropriate bit
	JP NC, EXIT ; and exit if it was pressed

	LD	A,0FDh; check keyboard for movement or select keys
	IN	A,(0FEh)
	RRA
	RRA
	RRA
	JP	NC,RIGHT

	LD	A,0FDh ; check keyboard for movement or select keys
	IN	A,(0FEh)
	RRA
	JP	NC,LEFT

	LD	A,0FBh
	IN	A,(0FEh)
	RRA
	RRA
	JP	NC,UP

	LD	A,0FDh
	IN	A,(0FEh)
	RRA
	RRA
	JP	NC,DOWN

	LD	A,0FBh
	IN	A,(0FEh)
	RRA
	RRA
	RRA
	JP	NC,SELECT

	LD	A,07Fh
	IN	A,(0FEh)
	RRA
	JP	NC,STEP

	LD	A,0
	LD 	A,0FBh 
	IN 	A,(0FEh) 
	RRA
	RRA
	RRA
	RRA 
	JP NC, RESET 
	JP	KLOOP

CLS	
	LD	HL,4000h
	LD	(HL),0
	LD	D,H
	LD	E,1
	LD	BC,17FFh
	LDIR	
	RET

ATT	
	LD	HL,5800h
	LD	(HL),01111000b
	LD	D,H
	LD	E,1
	LD	BC,02FFh
	LDIR
	RET

SET1	
	LD	HL,5800h
	LD	(HL),11111000b
	RET

DELAYL	LD BC,3500h ;Load large number into BC
TIMEL	DEC BC
	LD A,B
	OR C
	JP NZ,TIMEL ;Dec BC and check B and C for 0, loop till zero.
	RET

DELAYS	LD BC,2000h ;Load large number into BC
TIMES	DEC BC
	LD A,B
	OR C
	JP NZ,TIMES ;Dec BC and check B and C for 0, loop till zero.
	RET

RIGHT	LD	A,L
		CP	1Fh
		JP	Z,RCHKL
		CP	3Fh
		JP	Z,RCHKL
		CP	5Fh
		JP	Z,RCHKL
		CP	7Fh
		JP	Z,RCHKL
		CP	9Fh
		JP	Z,RCHKL
		CP	0BFh
		JP	Z,RCHKL
		CP	0DFh
		JP	Z,RCHKL
		CP	0FFh
		JP	Z,RCHKL
	LD	A,(HL)	
	SUB	10000000b
	LD	(HL),A
	INC	HL
	LD	A,(HL)
	ADD	A,10000000b
	LD	(HL),A
RCHKL	LD	A,0FDh; check keyboard for movement or select keys
	IN	A,(0FEh)
	RRA		
	RRA
	RRA
	JP	NC,RCHKL
	JP	KLOOP

LEFT	LD	A,L
		CP	00h
		JP	Z,LCHKL
		CP	20h
		JP	Z,LCHKL
		CP	40h
		JP	Z,LCHKL
		CP	60h
		JP	Z,LCHKL
		CP	80h
		JP	Z,LCHKL
		CP	0A0h
		JP	Z,LCHKL
		CP	0C0h
		JP	Z,LCHKL
		CP	0E0h
		JP	Z,LCHKL
	LD	A,(HL)	
	SUB	10000000b
	LD	(HL),A
	DEC	HL
	LD	A,(HL)
	ADD	A,10000000b
	LD	(HL),A
LCHKL	LD	A,0FDh ; check keyboard for movement or select keys
	IN	A,(0FEh)
	RRA
	JP	NC,LCHKL
	JP	KLOOP

UP	LD	DE,-20h
	PUSH	HL
	ADD	HL,DE
	LD	A,H
	SUB	57h
	POP	HL
	JP	Z,UCHKL
	LD	A,(HL)	
	SUB	10000000b
	LD	(HL),A
	LD	DE,-20h
	ADD	HL,DE
	LD	A,(HL)
	ADD	A,10000000b
	LD	(HL),A
UCHKL	LD	A,0FBh
	IN	A,(0FEh)
	RRA
	RRA
	JP	NC,UCHKL
	JP	KLOOP

DOWN	
	PUSH	HL
	LD	DE,20h
	ADD	HL,DE
	LD	A,H
	SUB	5Bh
	POP	HL
	JP	Z,DCHKL

	LD	A,(HL)	
	SUB	10000000b
	LD	(HL),A
	LD	DE,20h
	ADD	HL,DE
	LD	A,(HL)
	ADD	A,10000000b
	LD	(HL),A
DCHKL	LD	A,0FDh
	IN	A,(0FEh)
	RRA
	RRA
	JP	NC,DCHKL
	JP	KLOOP

SELECT	LD	A,(HL)
	SUB	11011000b
	JP	Z,DSELECT
	LD	(HL),11011000b
SCHKL	LD	A,0FBh
	IN	A,(0FEh)
	RRA
	RRA
	RRA
	JP	NC,SCHKL
	JP	KLOOP	

DSELECT	LD	(HL),11111000b
	JP	SCHKL

RESET
RSCHKL	LD	A,0
	LD 	A,0FBh 
	IN 	A,(0FEh) 
	RRA
	RRA
	RRA
	RRA 
	JP 	NC,RSCHKL
	JP	MAIN

STEP	
	PUSH	HL
	LD	A,(HL)
	SUB	10000000b
	LD	(HL),A
	JP	PHASE1

STEND	POP	HL
	LD	A,(HL)
	ADD	A,10000000b
	LD	(HL),A
;STCHKL	LD	A,07Fh
	;IN	A,(0FEh)
	;RRA
	;JP	NC,STCHKL
	JP	KLOOP

PHASE1
	LD	HL,5800h
	LD	DE,0A800h
	LD	BC,300h
P1LOOP		LD	A,(HL)
		SUB	01011000b
		JP	Z,SVON
		JP	SVOFF
SVDONE		INC	HL
		INC	DE
		DEC	BC
		LD	A,B
		OR	C
		JP	NZ,P1LOOP
	JP	PHASE2

SVON
	PUSH	HL
	LD	H,D
	LD	L,E
	LD	(HL),0001h
	POP	HL
	JP	SVDONE

SVOFF	
	PUSH	HL
	LD	H,D
	LD	L,E
	LD	(HL),00ffh
	POP	HL
	JP	SVDONE

PHASE2	LD	HL,0A800h
	LD	BC,300h
P2LOOP		PUSH	BC
		LD	C,0
		CALL	DCHECK
		CALL 	NORTH 
		CALL	NE
		CALL	EAST
		CALL	SE
		CALL 	SOUTH
		CALL	SW
		CALL	WEST
		CALL	NW
		LD	DE,1000h
		PUSH	HL
		ADD	HL,DE
		LD	(HL),C
		POP	HL
		INC	HL
		POP	BC
		DEC	BC
		LD	A,B
		OR	C
		JP	NZ,P2LOOP
	JP	PHASE3

PHASE3	LD	HL,0A800h
	LD	BC,300h
P3LOOP		LD	A,(HL)
		SUB	01h
		JP	Z,LCELL
		JP	DCELL
P3END		DEC	BC
		LD	A,B
		OR	C
		POP	HL
		JP	Z,STEND
		INC	HL
		JP	P3LOOP

LCELL	PUSH	HL
	LD	DE,1000h
	ADD	HL,DE
	LD	A,(HL)
	SUB	2
	JP	Z,P3END
	SUB	1
	JP	Z,P3END
	JP	DEATH

DCELL	PUSH	HL
	LD	DE,1000h
	ADD	HL,DE
	LD	A,(HL)
	SUB	3
	JP	Z,LIVE
	JP	P3END

LIVE	LD	DE,6000h
	LD	A,H
	SUB	D
	LD	H,A
	LD	A,L
	SUB	E
	LD	L,A
	LD	(HL),01011000b
	JP	P3END

DEATH	LD	DE,6000h
	LD	A,H
	SUB	D
	LD	H,A
	LD	A,L
	SUB	E
	LD	L,A
	LD	(HL),01111000b
	JP	P3END		

DCHECK	;Direction check for phase 2 	
	;North check
	PUSH	HL
	LD	DE,-20h
	ADD	HL,DE
	LD	A,H
	CP	0A7h
	JP	NZ,NSET
	JP	NRESET
DCNE	POP	HL
	;South check
	PUSH	HL
	LD	DE,20h
	ADD	HL,DE
	LD	A,H
	SUB	0ABh
	JP	NZ,SSET
	JP	SRESET
DCSE	POP	HL
	;East check
	LD	A,L
	CP	1Fh
	JP	Z,ELOOPND
	CP	3Fh
	JP	Z,ELOOPND
	CP	5Fh
	JP	Z,ELOOPND
	CP	7Fh
	JP	Z,ELOOPND
	CP	9Fh
	JP	Z,ELOOPND
	CP	0BFh
	JP	Z,ELOOPND
	CP	0DFh
	JP	Z,ELOOPND
	CP	0FFh
	JP	Z,ELOOPND
	JP	NZ,ESET
ELOOPND	JP	ERESET
DCEE	
	;West check
	LD	A,L
	CP	00h
	JP	Z,WLOOPND
	CP	20h
	JP	Z,WLOOPND
	CP	40h
	JP	Z,WLOOPND
	CP	60h
	JP	Z,WLOOPND
	CP	80h
	JP	Z,WLOOPND
	CP	0A0h
	JP	Z,WLOOPND
	CP	0C0h
	JP	Z,WLOOPND
	CP	0E0h
	JP	Z,WLOOPND
	JP	NZ,WSET
WLOOPND	JP	WRESET
DCWE	RET	

NSET	SET	7,B	;set North 'flag'
	SET	6,B	;set North East 'flag'
	SET	0,B	;set North West 'flag'
	JP	DCNE	;return to DCHECK

NRESET	RES	7,B	;reset North 'flag'
	JP	DCNE	;return to DCHECK
	
SSET	SET	3,B	;set South 'flag'
	SET	4,B	;set South East 'flag'
	SET	2,B	;set South West 'flag'
	JP	DCSE	;return to DCHECK

SRESET	RES	3,B	;reset South 'flag'
	JP	DCSE	;return to DCHECK


ESET	SET	5,B	;set East 'flag'
	JP	DCEE

ERESET	RES	5,B	;reset East 'flag'
	RES	6,B	;reset North East 'flag'
	RES	4,B	;reset South East 'flag'
	JP	DCEE

WSET	SET	1,B	;set West 'flag'
	JP	DCWE

WRESET	RES	1,B	;reset West 'flag'
	RES	0,B	;reset North West 'flag'
	RES	2,B	;reset South West 'flag'
	JP	DCWE

NORTH	PUSH 	HL
	LD	A,B
	RLA
	LD	B,A
	JP	NC,NEND
	LD	DE,-20h
	ADD	HL,DE
	LD	A,(HL)
	SUB	01h
	JP	NZ,NEND
	INC 	C
NEND	POP	HL
	RET

NE	PUSH 	HL
	LD	A,B
	RLA
	LD	B,A
	JP	NC,NEEND
	INC	HL
	LD	DE,-20h	
	ADD	HL,DE
	LD	A,(HL)
	SUB	01h
	JP	NZ,NEEND
	INC 	C
NEEND	POP	HL
	RET

EAST	PUSH 	HL
	LD	A,B
	RLA
	LD	B,A
	JP	NC,EEND
	INC	HL
	LD	A,(HL)
	SUB	01h
	JP	NZ,EEND
	INC 	C
EEND	POP	HL
	RET


SE	PUSH 	HL
	LD	A,B
	RLA
	LD	B,A
	JP	NC,SEEND
	INC	HL
	LD	DE,20h	
	ADD	HL,DE
	LD	A,(HL)
	SUB	01h
	JP	NZ,SEEND
	INC 	C
SEEND	POP	HL
	RET


SOUTH	PUSH 	HL
	LD	A,B
	RLA
	LD	B,A
	JP	NC,SEND
	LD	DE,20h
	ADD	HL,DE
	LD	A,(HL)
	SUB	01h
	JP	NZ,SEND	
	INC 	C
SEND	POP	HL
	RET

SW	PUSH 	HL
	LD	A,B
	RLA
	LD	B,A
	JP	NC,SWEND	
	LD	DE,20h	
	ADD	HL,DE
	DEC	HL
	LD	A,(HL)
	SUB	01h
	JP	NZ,SWEND
	INC 	C
SWEND	POP	HL
	RET


WEST	PUSH 	HL
	LD	A,B
	RLA
	LD	B,A
	JP	NC,WEND
	DEC	HL
	LD	A,(HL)
	SUB	01h
	JP	NZ,WEND
	INC 	C
WEND	POP	HL
	RET



NW	PUSH 	HL
	LD	A,B
	RLA
	LD	B,A
	JP	NC,NWEND	
	DEC	HL
	LD	DE,-20h
	ADD	HL,DE
	LD	A,(HL)
	SUB	01h
	JP	NZ,NWEND
	INC 	C
NWEND	POP	HL
	RET
	
EXIT	RET
