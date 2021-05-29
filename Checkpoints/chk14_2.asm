assume cs:code
code segment
start:	; Checkpoint 14.2
		; Evaluate: (ax)=(ax)*10
		mov ax,42
		call t10
		
		mov ax,4c00h
		int 21h
		
	t10:push bx
		push cx
		
		mov bx,ax	; (bx)=(ax)
		shl ax,1	; (ax)*2
		
		mov cl,3
		shl bx,cl	; (ax)*8
		
		add ax,bx	; (ax)=(ax)+(bx)
		
		pop cx
		pop bx
		ret
		
code ends
end start