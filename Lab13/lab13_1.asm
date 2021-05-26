; Lab 13.1 - Interrupt Handler
; func: Display a string of text ends with 0
; args: (dh) = line(0~24),	(dl) = column(0~79)
;       (cl) = color,		ds:si = where the string begins

; ## NOTES 
; 
; * `int 7ch` context
; 
; AX=0B28  BX=0000  CX=0002  DX=0A0A  SP=0000  BP=0000  SI=0000  DI=023F
; DS=0B28  ES=0000  SS=0B28  CS=0B2A  IP=0036   NV UP EI PL NZ NA PO NC
; 0B2A:0036 CD7C          INT     7C
; -t
; 
; AX=0B28  BX=0000  CX=0002  DX=0A0A  SP=FFFA  BP=0000  SI=0000  DI=023F
; DS=0B28  ES=0000  SS=0B28  CS=0000  IP=0200   NV UP DI PL NZ NA PO NC
; 0000:0200 56            PUSH    SI
; 
; 
; 
; * `iret` context
; AX=0B28  BX=0000  CX=0002  DX=0A0A  SP=FFFA  BP=0000  SI=0000  DI=023F
; DS=0B28  ES=B800  SS=0B28  CS=0000  IP=0239   NV UP DI PL NZ NA PE NC
; 0000:0239 CF            IRET
; -t
; 
; AX=0B28  BX=0000  CX=0002  DX=0A0A  SP=0000  BP=0000  SI=0000  DI=023F
; DS=0B28  ES=B800  SS=0B28  CS=0B2A  IP=0038   NV UP EI PL NZ NA PO NC
; 0B2A:0038 B8004C        MOV     AX,4C00
; 

assume cs:code
data segment
	db "welcome to masm! ",0
data ends
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
		mov dh,10
		mov dl,10
		mov cl,2
		mov ax,data
		mov ds,ax
		mov si,0
		int 7ch
		
		mov ax,4c00h
		int 21h
		
		
; Interrupt Handler Start
	do0:	push si
			push di
			push bx
			push bp
			push ax
			push dx
			push cx
			
			mov ax,0B800H
			mov es,ax
			
			mov al,0A0H
			mov bl,dh
			mul bl
			
			mov bp,ax		; first column of the line
			
			mov al,2
			mul dl
			add bp,ax		; exact position
			
			mov di,0
			mov dl,cl
			mov ch,0
			
		s:	mov cl,ds:[si]
			jcxz done
			mov es:[bp+di],cl
			mov es:[bp+di+1],dl
			add di,2
			inc si
			jmp short s
			
	done:	pop cx
			pop dx
			pop ax
			pop bp
			pop bx
			pop di
			pop si
			iret

do0end:		nop

code ends
end start