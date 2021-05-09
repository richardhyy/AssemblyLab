assume cs:codesg

data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983'
	db '1984','1985','1986','1987','1988','1989','1990','1991','1992'
	db '1993','1994','1995'
	; 21 strings that represent 21 years
	
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	; 21 dword data that represents total income of Power Idea for 21 years
	
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
	; numbers of employees for 21 years
data ends

table segment
	db 21 dup ('year summ ne ?? ')
table ends

stack segment
	db 16 dup (0)
stack ends

codesg segment
start:	mov ax,data
		mov ds,ax
		mov ax,stack	; stack start
		mov ss,ax
		mov bp,00E0H	; table start
		
		mov bx,0
		mov si,0
		mov cx,21
		
		; year
s:		push cx
		mov cx,2
		mov di,0
s_year:	mov ax,[bx+si]
		mov ds:[bp+di],ax
		add si,2
		add di,2
		loop s_year
		add bp,16
		pop cx
		loop s
		
		; profit
		mov si,0
		mov bx,0054H
		mov bp,00E5H
		mov cx,21
s1:		push cx
		mov di,0
		mov cx,2
s_sum:	mov ax,[bx+si]
		mov ds:[bp+di],ax
		add si,2
		add di,2
		loop s_sum
		add bp,16
		pop cx
		loop s1
		
		; number of employees
		mov si,0
		mov bx,00A8H
		mov bp,00EAH
		mov cx,21
s2:		mov ax,[bx+si]
		mov ds:[bp],ax
		add si,2
		add bp,16
		loop s2
		
		; average profit per employee
		mov bx,00E5H ; summ
		mov bp,00EAH ; ne
		mov si,0
		mov cx,21
s3:		mov ax,[bx+si]
		mov dx,[bx+si+2]
		div word ptr ds:[bp+si]
		mov [bx+si+8],ax
		add si,16
		loop s3
		
		
		; print data
		
		mov ax,data
		mov ds,ax
		mov bx,0
		mov di,0
		mov bp,00E0H	; table start
		
		mov dh,2
		
		mov cx,21
; print table rows
print_tr:	push cx
			mov cl,01110000B
			
			; year
			mov ax,ds:[bp]
			mov [bx],ax
			mov ax,ds:[bp+2]
			mov [bx+2],ax
			mov ax,0
			mov [bx+4],ax
			mov si,0
			mov dl,0
			call show_str
			
			; income
			push dx
			mov ax,ds:[bp+5]
			mov dx,ds:[bp+7]
			mov si,0
			call dtoc
			
			pop dx
			mov dl,10
			call show_str
			
			; employees
			push dx
			mov ax,ds:[bp+10]
			mov dx,0
			mov si,0
			call dtoc
			
			pop dx
			mov dl,20
			call show_str
			
			; avg profit per employee
			push dx
			mov ax,ds:[bp+0dH]
			mov dx,0
			mov si,0
			call dtoc
			
			pop dx
			mov dl,30
			call show_str
			
			inc dh
			add bp,10H
			pop cx
			loop print_tr
			
			mov ax,4c00H
			int 21H
			
			
; Utils
dtoc:		push ax
			push bx
			push cx
			push dx
			push si
			push di
			
			mov bx,0
			mov si,0
			
	dtoc_s:	mov cx,10
			call divdw
			add cl,30H			; DEC to ASCII
			mov ds:[bx+si],cl	; remainder (ASCII)
			mov cx,ax			; quotient
			inc si
			jcxz dtoc_done
			jmp short dtoc_s
			
 dtoc_done:	push si
			sub si,1
			mov cx,si
			jcxz dtoc_ret
			inc si
			mov ax,si
			mov cl,2
			div cl
			mov ch,0
			mov cl,al			; quotient = number of step for swapping
			mov di,si
			sub di,1			; position of the last char
			mov si,0			; position of the first char
   dtoc_s1:	mov al,ds:[bx+si]
			mov ah,ds:[bx+di]
			mov ds:[bx+si],ah
			mov ds:[bx+di],al
			sub di,1
			inc si
			loop dtoc_s1
			
 dtoc_ret:	pop si
			mov ax,0
			mov ds:[bx+si],ax
			
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

codesg ends

end start