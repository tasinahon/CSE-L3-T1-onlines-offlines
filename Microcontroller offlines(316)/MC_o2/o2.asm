 .model small
.stack 100h
.data
arr dw 5 DUP(?)
.code
main proc
    mov ax,@data
    mov ds,ax
    
    lea si,arr 
    mov cx,0
    mov bx,0 
    
    
    input:
     mov ah,1
     int 21h 
     cmp al,0x0d
     je function
     mov [si],al
     add si,2
     inc cx 
     
     jmp input
     
   
   function:
    lea si,arr  
    mov ax,[si]
    sub ax,48
    push ax
    call sum_digit  
   
    mov ah,2
    mov dl,0Ah
    int 21h
    
    mov ah,2
    mov dl,0Dh
    int 21h
    
    mov ax,bx
    mov dx,0
    mov bx,10
    mov cx,0
    l1:
    div bx
    push dx
    mov dx,0
    mov ah,0
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
 
sum_digit proc near
    push bp
    mov bp,sp 
    cmp cx,1
    jg end_if  

    mov bx,[si]  
    sub bx,48
    jmp return
    
    
    end_if: 
    add si,2 
    mov ax,[si] 
    sub ax,48
    push ax 
    dec cx
    call sum_digit 
    
    mov dx,word ptr[bp+4]
    add bx,dx
    
    
    return:
    pop bp
    ret 2