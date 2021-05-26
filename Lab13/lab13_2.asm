; Lab 13.2 - Interrupt Handler
; func: Loop
; args: (cx) = cycles;  (bx) = offset

; ## NOTES 
; 
; * `int 7ch` context
; 
; AX=B800  BX=FFF7  CX=0050  DX=0000  SP=0000  BP=0000  SI=0052  DI=0782
; DS=0B28  ES=B800  SS=0B28  CS=0B28  IP=003D   NV UP EI PL NZ NA PE NC
; 0B28:003D CD7C          INT     7C
; -t
; 
; AX=B800  BX=FFF7  CX=0050  DX=0000  SP=FFFA  BP=0000  SI=0052  DI=0782
; DS=0B28  ES=B800  SS=0B28  CS=0000  IP=0200   NV UP DI PL NZ NA PE NC
; 0000:0200 83E901        SUB     CX,+01
; 
; 
; 
; * `iret` context in the loop
; AX=B800  BX=FFF7  CX=004F  DX=0000  SP=FFFA  BP=0000  SI=0052  DI=0782
; DS=0B28  ES=B800  SS=0B28  CS=0000  IP=020C   NV UP DI PL NZ AC PE CY
; 0000:020C CF            IRET
; -t
; 
; AX=B800  BX=FFF7  CX=004F  DX=0000  SP=0000  BP=0000  SI=0052  DI=0782
; DS=0B28  ES=B800  SS=0B28  CS=0B28  IP=0036   NV UP EI PL NZ NA PE NC
; 0B28:0036 26            ES:
; 0B28:0037 C60521        MOV     BYTE PTR [DI],21                   ES:0782=30
; 
; 
; 
; * `iret` context at the end of the loop
; AX=B800  BX=FFF7  CX=0000  DX=0000  SP=FFFA  BP=0000  SI=0052  DI=0782
; DS=0B28  ES=B800  SS=0B28  CS=0000  IP=020C   NV UP DI PL ZR NA PE NC
; 0000:020C CF            IRET
; -t
; 
; AX=B800  BX=FFF7  CX=0000  DX=0000  SP=0000  BP=0000  SI=0052  DI=0782
; DS=0B28  ES=B800  SS=0B28  CS=0B28  IP=003F   NV UP EI PL NZ NA PE NC
; 0B28:003F 90            NOP
;

assume cs:code
code segment
start:	; Set Up the Interrupt Handler
		mov ax,cs
		mov ds,ax
		mov si,offset do0
		mov ax,0
		mov es,ax
		mov di,200h
		
		mov cx,offset do0end-offset do0
		cld
		rep movsb
		
		; Set Interrupt Vector Table
		mov ax,0
		mov es,ax
		mov word ptr es:[7ch*4],200h	; offset
		mov word ptr es:[7ch*4+2],0		; segment
		
		; Test the Handler
		mov ax,0b800h
		mov es,ax
		mov di,160*12
		mov bx,offset s-offset se
		mov cx,80
	s:	mov byte ptr es:[di],'!'
		add di,2
		int 7ch
	se:	nop
		
		mov ax,4c00h
		int 21h
		
		
; Interrupt Handler Start
	do0:	sub cx,1
			jcxz el
			push bp
			mov bp,sp
			add [bp+2],bx
			pop bp
	el:		iret

do0end:		nop

code ends
end start