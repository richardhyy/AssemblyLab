; Requirements:
; Analyse the following program. Consider before running it: Will it returning normally?
; Think after running the program: why?

; before execution:
; 0B28:0000 B8004C        MOV     AX,4C00
; 0B28:0003 CD21          INT     21
; 0B28:0005 B80000        MOV     AX,0000	<== start:
; 0B28:0008 90            NOP		<== s:	<-- `EBF6` will be placed here
; >> AFTER EXECUTION: 0B28:0008 EBF6          JMP     0000  hence the program will return normally
; 0B28:0009 90            NOP
; 0B28:000A BF0800        MOV     DI,0008
; 0B28:000D BE2000        MOV     SI,0020
; 0B28:0010 2E            CS:
; 0B28:0011 8B04          MOV     AX,[SI]
; 0B28:0013 2E            CS:
; 0B28:0014 8905          MOV     [DI],AX
; 0B28:0016 EBF0          JMP     0008		<== s0:
; 0B28:0018 B80000        MOV     AX,0000	<== s1:
; 0B28:001B CD21          INT     21
; 0B28:001D B80000        MOV     AX,0000
; 0B28:0020 EBF6          JMP     0018  <== s2:	<-- HERE'S WHAT'S COPIED
; 0B28:0022 90            NOP
; 0B28:0023 2DFE06        SUB     AX,06FE


assume cs:codesg
codesg segment
		
		mov ax,4c00h
		int 21h

start:	mov ax,0
	s:	nop
		nop
		
		mov di,offset s
		mov si,offset s2
		mov ax,cs:[si]
		mov cs:[di],ax
		
	s0:	jmp short s
	
	s1:	mov ax,0
		int 21h
		mov ax,0
		
	s2:	jmp short s1
		nop
		
codesg ends
end start
