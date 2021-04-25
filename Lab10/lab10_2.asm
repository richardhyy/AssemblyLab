; Lab 10
; name: divdw
; func: Do division that will not overflow.
; args: (ax) = dword, lower part of dividend
;		(dx) = dword, higher part of dividend
;		(cx) = divisor
; ret:	(ax) = lower part of the quotient
;		(dx) = higher part of the quotient
;		(cx) = remainder

assume cs:code

data segment
	dd 0,0,0,0
	dd 0,0,0,0
data ends

stack segment
	dd 0,0
stack ends

code segment
start:	mov ax,data
		mov ds,ax
		
		mov ax,stack
		mov ss,ax
		mov sp,10H
		
		mov ax,4241H	; sample data begins
		mov dx,000FH	;  >> Different from what is given in the textbook, the lower part of the dividend is 4241H instead of 4240H
		mov cx,0AH		; sample data ends
		
		call divdw
		
		mov ax,4c00H
		int 21h
		
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