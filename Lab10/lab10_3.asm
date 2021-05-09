; Lab 10
; name: wdtoc
; func: convert HEX word(8bit) data into a string of DEC which ends with 0
; args: (ax) = data (word)
;		ds:si = where the string begins

assume cs:code

data segment
	db 10 dup (0)
data ends

stack segment
	dd 0,0
	dd 0,0
stack ends

code segment
start:		mov ax,data
			mov ds,ax
			mov ax,stack
			mov ss,ax
			mov sp,20H
			mov si,0
			
			mov ax,3
			call wdtoc
			
			mov dh,8
			mov dl,3
			mov cl,2
			call show_str
			
			mov ax,4c00H
			int 21h
			
wdtoc:		push ax
			push bx
			push cx
			push dx
			push si
			push di
			
			mov bx,0
			mov si,0
			
	wdtoc_s:mov dx,0
			mov cx,10
			call divdw
			add cl,30H			; DEC to ASCII
			mov ds:[bx+si],cl	; remainder (ASCII)
			mov cx,ax			; quotient
			inc si
			jcxz wdtoc_done
			jmp short wdtoc_s

 ; reverse the output
 wdtoc_done:push si
			sub si,1
			mov cx,si
			jcxz wdtoc_ret
			inc si
			mov ax,si
			mov cl,2
			div cl
			mov ch,0
			mov cl,al			; quotient = number of step for swapping
			mov di,si
			sub di,1			; position of the last char
			mov si,0			; position of the first char
   wdtoc_s1:mov al,ds:[bx+si]
			mov ah,ds:[bx+di]
			mov ds:[bx+si],ah
			mov ds:[bx+di],al
			sub di,1
			inc si
			loop wdtoc_s1
			
 wdtoc_ret:	pop si
			mov al,0
			mov ds:[bx+si],al
			
			pop di
			pop si
			pop dx
			pop cx
			pop bx
			pop ax
			ret
			
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
			
	str_s:	mov cl,ds:[si]
			jcxz done
			mov es:[bp+di],cl
			mov es:[bp+di+1],dl
			add di,2
			inc si
			jmp short str_s
			
	done:	pop cx
			pop dx
			pop ax
			pop bp
			pop bx
			pop di
			pop si
			ret

divdw:	push bx

		mov bx,0
		push [bx+0]
		push [bx+2]
		push [bx+4]
		push [bx+6]
		push [bx+8]
		push [bx+10]
		
		mov [bx+0],ax	; dividend (lower)
		mov [bx+2],dx	; dividend (higher)
		mov [bx+4],cx	; divisor
		
		mov dx,0
		mov ax,[bx+2]
		div cx
		mov [bx+6],dx	; remainder of lhs H/N
		
		add ax,ax
		mov cx,8000H
		mul cx
		mov [bx+8],ax	; lower  part of the lhs result
		mov [bx+10],dx	; higher part of the lhs result
		
		mov ax,[bx+6]
		add ax,ax
		mov cx,8000H
		mul cx
		add ax,[bx+0]
		div word ptr [bx+4]
		
		mov [bx+6],dx	; remainder
		add [bx+8],ax
		mov ax,[bx+8]
		mov dx,[bx+10]
		mov cx,[bx+6]
		
		mov bx,0
		pop [bx+10]
		pop [bx+8]
		pop [bx+6]
		pop [bx+4]
		pop [bx+2]
		pop [bx+0]
		pop bx
		ret
				
code ends

end start