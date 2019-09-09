; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
    PATH1 DB 'D:\ABC.txt',00
    PATH2 DB 'D:\CBA.txt',00   
    LEN DW ?
    CURSOR DW ?
    HANDLE1 DW ?
    HANDLE2 DW ?  
    BUFFER DB 2 DUP(0)
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
            
    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    MOV AH,3DH
    LEA DX,PATH1
    MOV AL,0
    INT 21H
    JC  ERROR1
    MOV HANDLE1,AX
    
    MOV AH,42H
    MOV AL,2
    MOV BX,HANDLE1
    MOV CX,0
    MOV DX,0
    INT 21H
    JC  ERROR2
    MOV LEN,AX
    
    MOV AH,3CH
    MOV CX,0
    LEA DX,PATH2
    INT 21H
    JC  ERROR1
    MOV HANDLE2,AX
    
    MOV CX,LEN
    MOV CURSOR,-1
    
LOOP1:
    
    PUSH CX
    
    MOV BUFFER,0
    XOR AX,AX
    MOV BX,HANDLE1
    MOV CX,-1
    MOV DX,CURSOR
    MOV AL,1
    MOV AH,42H
    INT 21H
    JC  ERROR1
    
    MOV AH,3FH
    MOV BX,HANDLE1
    MOV CX,1
    LEA DX,BUFFER
    INT 21H
    JC  ERROR1
    
    LEA DX,BUFFER
    MOV AH,40H
    MOV CX,1
    MOV BX,HANDLE2
    INT 21H
           
    POP CX
    MOV CURSOR,-2
    LOOP LOOP1
    
    JMP EXIT0
ERROR1:

	MOV DL,'1'
	MOV AH,02H
	INT 21H
	JMP EXIT0
	
ERROR2:

	MOV DL,'2'
	MOV AH,02H
	INT 21H

EXIT0:
    
    MOV AH,3EH
    MOV BX,HANDLE1
    INT 21H
    
    MOV AH,3EH
    MOV BX,HANDLE2
    INT 21H
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
