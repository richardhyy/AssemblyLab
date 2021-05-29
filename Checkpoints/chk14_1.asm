assume cs:code
code segment
start:	; Checkpoint 14.1 (1)
		; Read from the #2 unit of CMOS RAM
		mov dx,70h
		mov al,2
		out dx,al
		mov dx,71h
		in al,dx
		
		; Checkpoint 14.1 (2)
		; Write 0 to the #2 unit of CMOS RAM
		mov dx,70h
		mov al,2
		out dx,al
		mov dx,71h
		mov al,0
		out dx,al
		
		mov ax,4c00h
		int 21h
code ends
end start