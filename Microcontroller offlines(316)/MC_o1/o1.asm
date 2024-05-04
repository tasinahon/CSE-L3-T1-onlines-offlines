.model small
.stack 100h
.data
m1 db 'Enter a single character : $'
m2 db 'Uppercase letter $'
m3 db 'Lowercase letter $'
m4 db 'Number $'
m5 db 'Not an alphanumeric character $'
.code
main proc
    
    mov ax,@data
    mov ds,ax
    
    lea dx,m1
    mov ah,9
    int 21h
    
    mov ah,1
    int 21h
    mov bl,al 
    
    
    cmp bl,'A'
    jge check_uppercase
    
    com_low:
    cmp bl,'a'
    jge check_lowercase  
    
    com_number:
    cmp bl,'0'
    jge check_number
    
    
    others: 
    
    mov dl,0Ah
    mov ah,2
    int 21h 
    
    mov dl,0Dh
    mov ah,2
    int 21h
    
    
    lea dx,m5
    mov ah,9
    int 21h  
    jmp end_if    
    
    
    check_uppercase:
    cmp bl,'Z'
    jg com_low 
    
    
    
    upper:  
    mov dl,0Ah
    mov ah,2
    int 21h 
    
    mov dl,0Dh
    mov ah,2
    int 21h
    
    
    lea dx,m2
    mov ah,9
    int 21h 
    
    jmp end_if 
    
    
    check_lowercase:
    cmp bl,'z'
    jg others
    
    lower:  
    mov dl,0Ah
    mov ah,2
    int 21h 
    
    mov dl,0Dh
    mov ah,2
    int 21h
    
    
    lea dx,m3
    mov ah,9
    int 21h 
    
    jmp end_if
    
    check_number:
    cmp bl,'9'
    jg others
    
    mov dl,0Ah
    mov ah,2
    int 21h 
    
    mov dl,0Dh
    mov ah,2
    int 21h
    
    
    lea dx,m4
    mov ah,9
    int 21h 
    
    
    end_if:
    exit:
    mov ah,4ch
    int 21h
    main endp
