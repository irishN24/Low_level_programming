section .data
    msg_in_1 db "Введите n: "
    msg_len_1 equ $ - msg_in_1
    msg_out_1 db "n - куб :)"
    len_yes equ $ - msg_out_1
    msg_out_2 db "n - не куб :("
    len_no equ $ - msg_out_2
    msg_err db "НЕВЕРНЫЕ ДАННЫЕ!!!"
    len_err equ $ - msg_err
    newline db 10
    
segment .bss
    input_buf resb 32
    n resd 1
section .text
    global _start
_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_in_1
    mov edx, msg_len_1
    int 0x80
    
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80
    mov edi, eax
    
    xor eax, eax
    xor esi, esi
    xor ebp, ebp
    
convert:
    cmp esi, edi
    jge convert_done
    
    movzx ecx, byte [input_buf + esi]
    cmp ecx, 10
    je convert_done
    cmp ecx, '0'
    jb error
    cmp ecx, '9'
    ja error
    sub ecx, '0'
    imul eax, eax, 10
    add eax, ecx
    inc esi
    mov ebp, 1
    jmp convert
    
convert_done:
    cmp ebp, 0
    je error
    
    mov [n], eax

    mov eax, 1
    mov ebx, 1

cube_:
    mov eax, ebx 
    xor edx, edx    
    mul ebx
    test edx, edx
    jnz error
    xor edx, edx    
    mul ebx
    test edx, edx
    jnz error
    cmp eax, [n]
    je is_cube
    ja not_cube
    inc ebx
    jmp cube_

is_cube:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_out_1
    mov edx, len_yes
    int 0x80
    jmp exit
    
not_cube:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_out_2
    mov edx, len_no
    int 0x80
    jmp exit
    
error:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_err
    mov edx, len_err
    int 0x80
    jmp exit
    
exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80