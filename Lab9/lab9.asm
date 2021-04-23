assume cs:codesg

data segment
	db 'welcome to masm!'
	db 00000010b,00100100b,01110001b
data ends

stack segment
	dd 0,0
stack ends

codesg segment
start:	mov ax,data
		mov ds,ax
		
		mov ax,0B800H
		mov es,ax
		mov di,0780H
		add di,20H			; center the output
		
		mov ax,stack
		mov ss,ax
		mov sp,10H
		
		mov si,0			; color offset
		mov bp,0
		
		mov cx,3
	s:	push cx
		mov bx,0			; text offset
		mov cx,16
	s1:	mov al,ds:[bx]
		mov es:[bp+di],al
		mov al,ds:[10H+si]	; color
		mov es:[bp+di+1],al
		add bp,2
		inc bx
		loop s1
		
		inc si
		pop cx
		loop s
		
		mov ax,4c00H
		int 21h
codesg ends

end start