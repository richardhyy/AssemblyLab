; Lab 11
; name: letterc
; func: Convert a string of characters ends with 0 to upper case.
; args: di:si : points to the beginning of the string

assume cs:codesg

datasg segment
	db "Beginner's All-purpose Symbolic Instruction Code.",0
datasg ends

stacksg segment
	dd 0,0
stacksg ends

codesg segment
begin:	mov ax,datasg
		mov ds,ax
		mov si,0
		call letterc
		
		mov ax,4c00h
		int 21h

letterc:push cx
		push si
		
		mov cx,0
		
l_upper:cmp byte ptr [si],97	; if (si)<'a'
		jb l_next
		cmp byte ptr [si],122	; if (si)>'z'
		ja l_next
		and byte ptr [si],11011111b
		
l_next: inc si
		mov cl,[si]
		jcxz l_done				; stop at \0
		jmp short l_upper
		
l_done: pop si
		pop cx
		ret
codesg ends

end begin