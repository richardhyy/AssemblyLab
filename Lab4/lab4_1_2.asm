assume cs:code

code segment

        mov ax,0020h	;1
        mov ds,ax	;2
	
        mov bx,0040h	;3
s:      sub bl,1	;4
        mov [bx],bl	;5
	
        loop s		;6
	
        mov ax,4c00h	;7
        int 21h		;8

code ends

end
