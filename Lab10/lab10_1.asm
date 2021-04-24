; Lab 10
; name: show_str
; func: display a string of text which ends with 0 at specified position with certain color
; args: (dh) = line(0~24),	(dl) = column(0~79)
;       (cl) = color,		ds:si = where the string begins

assume cs:code

data segment
	db 'welcome to masm!',0
data ends

stack segment
	dd 0,0
	dd 0,0
stack ends

code segment
start:		mov dh,8		; line
			mov dl,3		; column
			mov cl,2		; color (00000010b)
			mov ax,data
			mov ds,ax
			mov ax,stack
			mov ss,ax
			mov sp,20H
			
			mov si,0
			call show_str
			
			mov ax,4c00H
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