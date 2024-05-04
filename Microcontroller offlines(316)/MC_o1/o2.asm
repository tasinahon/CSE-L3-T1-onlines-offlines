.model small
.stack 100h
.data  
m1 db 'Enter three characters: $' 
m2 db 'All letters are equal $'
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
   
   mov ah,1
   int 21h
   mov bh,al
   
   mov ah,1
   int 21h
   mov cl,al
   
 
  
   
      
   cmp bl,bh 
   jg second_test_for_first_one:
   
   cmp bl,cl
   jg second_test_for_first_one:  
   
   
   
   jmp second_input
   
   second_test_for_first_one:
   cmp bl,bh
   jl print_n1
   
   cmp bl,cl
   jl print_n1
   
   jmp second_input
   
   
   
   second_input: 
   cmp bh,cl 
   jg second_test_for_second_one:
   
   cmp bh,bl
   jg second_test_for_second_one: 
   
   jmp third_input
   
   second_test_for_second_one:
   cmp bh,bl
   jl print_n2
   
   cmp bh,cl
   jl print_n2
   
   jmp third_input
   
   
   
   print_n1:
   mov dl,0Ah
   mov ah,2
   int 21h
   
   mov dl,0Dh
   mov ah,2
   int 21h
   
   mov dl,bl
   mov ah,2
   int 21h 
   jmp end_if  
   
   print_n2:
   mov dl,0Ah
   mov ah,2
   int 21h
   
   mov dl,0Dh
   mov ah,2
   int 21h
   
   mov dl,bh
   mov ah,2
   int 21h
   jmp end_if
   
   
   third_input:
   
   cmp bl,bh
   jne a 
   cmp bl,cl
   jg print_the_third
   
   cmp bl,cl
   jl print_n2 
   
   cmp bl,cl
   je all_letters
   
    a:
    cmp bh,cl
    jne b
    
    cmp bh,bl 
    jg print_n1
    
    jmp print_the_third
    
    b:
    cmp cl,bl
    jne print_the_third
    
    cmp cl,bh
    jg  print_n2
    jmp print_the_third
   
   print_the_third: 
   mov dl,0Ah
   mov ah,2
   int 21h
   
   mov dl,0Dh
   mov ah,2
   int 21h
   
   mov dl,cl
   mov ah,2
   int 21h  
   jmp end_if
   
   all_letters:
   mov dl,0Ah
   mov ah,2
   int 21h
   
   mov dl,0Dh
   mov ah,2
   int 21h
   
   lea dx,m2
   mov ah,9
   int 21h
   
   
   end_if:
   exit:
   mov ah,4ch
   int 21h
   main endp
end main
           
   