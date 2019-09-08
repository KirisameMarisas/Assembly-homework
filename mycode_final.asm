; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
     
	
	con_exe db 'EXE:$'
	con_mod db 'the remainder of the file length divides 512 is :$'
	con_quo db 'the quotient of the file length divides 512 is :$'
    con_h_quo db 'the quotient of the file hander divid 16 is :$'
    con_min_segment db 'the minimum segments when this exe file running is :$'
    con_max_segment db 'the maximum segments when this exe file running is :$'
    con_checksum db 'the checksum of this file is :$'
    
    error_o db "*******open file error*******$"
    error_r db '*******read file error*******$'
    
    transfer db '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
    hex dw 010h
    
    handle_file dw ?
    path db 'D:\test.exe',00 
    Info db 0100h dup(0)
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
    
    xor ax,ax
    
    mov ah,3dh    ;open file
    mov al,00
    lea dx,path
    int 21h
    jc  error_open
    mov handle_file,ax
    
    mov ah,3fh    ;read file 
    mov al,00h
    mov bx,handle_file
    lea dx,Info
    mov cx,020h
    int 21h
    jc  error_read
    
    jmp exe
error_open:

    mov ah,09h
    lea dx,error_o
    int 21h
    jmp exit_p

error_read:

    mov ah,09h
    lea dx,error_r
    int 21h
    jmp exit_p

exe:
     call show_exe
     call show_mod_512
     call show_quo_512
     call show_head_16
     call show_min_seg
     call show_max_seg
     call show_checksum
     jmp exit_p
     
print:

    push ax
    push bx
    push cx
    push dx
    
    xor  ax,ax
    
    mov  al,Info[bx]
    mov  cl,4
    push ax
    ror  al,cl
    and  al,0fh
    cbw
    mov  bx,ax
    mov  dl,transfer[bx]
    mov  ah,02h
    int  21h
    pop  ax
    and  al,0fh
    cbw
    mov  bx,ax
    mov  dl,transfer[bx]
    mov  ah,02h
    int  21h
    
    pop  dx
    pop  cx
    pop  bx
    pop  ax
    ret

print_s:

    push ax
    push bx
    push cx
    push dx
           
    mov  dl,' '
    mov  ah,02h
    int  21h
               
    pop  dx
    pop  cx
    pop  bx
    pop  ax    
    ret

print_enter:

    push ax
    push bx
    push cx
    push dx
           
    mov  dl,0dh
    mov  ah,02h
    int  21h
    
    mov  dl,0ah
    mov  ah,02h
    int  21h
               
    pop  dx
    pop  cx
    pop  bx
    pop  ax    
    ret
    
show:
    
    push ax
    push bx
    push cx
    push dx
    
    mov  ah,09h
    int 21h
    call print_s
    
loop1:
    call print
    call print_s
    inc bx
    loop loop1
    
    call print_enter
    
    pop  dx    
    pop  cx
    pop  bx
    pop  ax
    ret
    
show_exe:
    
    push ax
    push bx
    push cx
    push dx
    
    mov  bx,00h
    mov  cx,2
    lea  dx,con_exe
    
    call show
    
    pop  dx    
    pop  cx
    pop  bx
    pop  ax
    ret
    
show_mod_512:

    push ax
    push bx
    push cx
    push dx
    
    mov  bx,02h
    mov  cx,2
    lea  dx,con_mod
    
    call show
    
    pop  dx    
    pop  cx
    pop  bx
    pop  ax
    ret

show_quo_512:

    push ax
    push bx
    push cx
    push dx
    
    mov  bx,04h
    mov  cx,2
    lea  dx,con_quo
    
    call show
    
    pop  dx    
    pop  cx
    pop  bx
    pop  ax
    ret

show_head_16:
    
    push ax
    push bx
    push cx
    push dx
    
    mov  bx,08h
    mov  cx,2
    lea  dx,con_h_quo
    
    call show
    
    pop  dx    
    pop  cx
    pop  bx
    pop  ax
    ret
    
show_min_seg:
    
    push ax
    push bx
    push cx
    push dx
    
    mov  bx,0ah
    mov  cx,2
    lea  dx,con_min_segment
    
    call show
    
    pop  dx    
    pop  cx
    pop  bx
    pop  ax
    ret

show_max_seg:

    push ax
    push bx
    push cx
    push dx
    
    mov  bx,0ch
    mov  cx,2
    lea  dx,con_max_segment
    
    call show
    
    pop  dx    
    pop  cx
    pop  bx
    pop  ax
    ret

show_checksum:

    push ax
    push bx
    push cx
    push dx
    
    mov  bx,012h
    mov  cx,2
    lea  dx,con_checksum
    
    call show
    
    pop  dx    
    pop  cx
    pop  bx
    pop  ax
    ret
          
exit_p: 
 
    mov ax, 4c00h ; exit to operating system.
    int 21h  
ends

end start ; set entry point and stop the assembler.
