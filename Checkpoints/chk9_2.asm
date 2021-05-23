assume cs:code
data segment
	dd 1,2,3,4
data ends

code segment
start:	mov ax,2000H
		mov ds,ax
		mov bx,0
s:		mov cl,0
		mov ch,[bx]
		jcxz ok
		inc bx
		jmp short s
ok:		mov dx,bx
		mov ax,4c00h
		int 21h
code ends
end start