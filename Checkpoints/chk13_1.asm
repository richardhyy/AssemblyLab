assume cs:code
data segment
	db 'Light and Wings',0
data ends

code segment
start:	call setjpn
		
		mov ax,data
		mov ds,ax
		mov si,0
		mov ax,0b800h
		mov es,ax
		mov di,12*160
	s:  cmp byte ptr [si],0
		je ok
		mov al,[si]
		mov es:[di],al
		inc si
		add di,2
		mov bx,offset s-offset ok
		int 7ch
	ok: mov ax,4c00h
		int 21h
	
; Set up jpn
 setjpn:mov ax,cs
		mov ds,ax
		mov si,offset jpn
		mov ax,0
		mov es,ax
		mov di,200h
		mov cx,offset jpnend-offset jpn
		cld
		rep movsb
		
		mov ax,0
		mov es,ax
		mov word ptr es:[7ch*4],200h
		mov word ptr es:[7ch*4+2],0
		ret
		
	jpn:push bp
		mov bp,sp
		add [bp+2],bx
		pop bp
		iret
 jpnend:nop
		
code ends
end start
