assume cs:code
code segment
start:	; Set Up the Interruption Handler
		mov ax,cs
		mov ds,ax
		mov si,offset do0
		mov ax,0
		mov es,ax
		mov di,200h
		
		mov cx,offset do0end-offset do0
		; w/o offset:	0B28:000F B92D00        MOV     CX,002D
		;  w/ offset:	0B28:000F B92D00        MOV     CX,002D
		
		cld
		rep movsb
		
		; Set Interruption Vector Table
		mov ax,0
		mov es,ax
		mov word ptr es:[0*4],200h	; offset
		mov word ptr es:[0*4+2],0	; segment
		
		; Test the Handler
		mov ax,1000h
		mov bh,1
		div bh
		
		mov ax,4c00h
		int 21h
		
		; Interruption Handler
   do0: jmp short do0start
		db "overflow!"
do0start:mov ax,cs
		mov ds,ax
		mov si,202h		; points to the text
		
		mov ax,0b800h
		mov es,ax
		mov di,12*160 + 36*2
		
		mov cx,9		; length of the string
	s:	mov al,[si]
		mov es:[di],al
		inc si
		add di,2
		loop s
		
		mov ax,4c00h
		int 21h
do0end: nop

code ends
end start