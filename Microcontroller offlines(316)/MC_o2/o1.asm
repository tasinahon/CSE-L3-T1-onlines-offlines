.model small  
.stack 100h
.data
num dw ?
num2 dw ?
.code
main proc
    mov ax,@data
    mov ds,ax
    
    mov num,0
    mov bx,10
    
    input:
    mov ah,1
    int 21h
    cmp al,32 
    je next_inp
    sub al,30h
    mov ah,0
    mov cx,ax
    mov ax,num
    mul bx
    add ax,cx
    mov num,ax
    jmp input
    
    
    next_inp:
    mov num2,0
    mov bx,10
    
    input2:
    mov ah,1
    int 21h
    cmp al,13 
    je  main_work
    sub al,30h
    mov ah,0
    mov cx,ax
    mov ax,num2
    mul bx
    add ax,cx
    mov num2,ax
    jmp input2
    
    main_work:
    mov cx,num
    mov ax,num
    mov bx,num2 
    do_it:
    xor dx,dx
    div bx  
    add cx,ax
    add ax,dx
    cmp ax,bx
    jge do_it  
    
     
     
    mov ah,2
    mov dl,0Ah
    int 21h
    
    mov ah,2
    mov dl,0Dh
    int 21h
    
    mov ax,cx
    mov dx,0
    mov bx,10
    mov cx,0
    l1:
    div bx
    push dx
    mov dx,0
    inc cx
    cmp ax,0
    jne l1
    mov ah,2
    
    l2:
    pop dx
    add dx,48
    int 21h
    loop l2
    mov ah,4ch
    int 21h
    
    
    
