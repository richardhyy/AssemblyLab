assume cs:code

data segment
	db 'YY/MM/DD HH:MI:SS',0	; 18
	db 9,8,7,4,2,0
data ends

stack segment
	dd 0,0
stack ends

code segment
start:	mov ax,data
		mov ds,ax
		mov ax,stack
		mov ss,ax
		mov sp,0
		mov si,0
		mov di,18
		mov cx,6
	s0:	mov al,ds:[di]
		out 70h,al
		in al,71h
		
		mov ah,al
		mov cl,4
		shr ah,cl
		and al,00001111b
		
		mov bx,ax
		mov al,bh
		mov ah,bl
		
		add ax,3030h
		mov ds:[si],ax
		
		add si,3
		add di,1
		loop s0
		
		mov dh,12		; line
		mov dl,30		; column
		mov cl,0fh		; color
		mov si,0
		call show_str
		
		mov ax,4c00h
		int 21h
		
show_str:	push si
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
			ret
code ends
end start