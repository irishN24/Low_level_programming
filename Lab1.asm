; Дано целое число, большее 999. Используя одну операцию деления нацело и 
; одну операцию взятия остатка от деления, найти цифру, 
; соответствующую разряду сотен в записи этого числа.

section .data
    msg_in db "Введите число (>999): "
    msg_in_len  equ $ - msg_in

    msg_err db "Неверные данные!!!"
    msg_err_len equ $ - msg_err

    msg_out db "Цифра сотен: "
    msg_out_len  equ $ - msg_out

section .bss
    input_buf resb 32 
    digit_out resb 2

section .text
global _start
_start:

    mov eax, 4                  
    mov ebx, 1                  
    mov ecx, msg_in
    mov edx, msg_in_len
    int 0x80

    mov eax, 3                  
    mov ebx, 0                  
    mov ecx, input_buf
    mov edx, 32
    int 0x80

    mov esi, input_buf
    xor eax, eax
.parse:
    movzx ecx, byte [esi]
    cmp ecx, '0'
    jb .error
    cmp ecx, '9'
    ja .error
    sub ecx, '0'
    imul eax, eax, 10
    add eax, ecx
    inc esi
    jmp .parse

.error:

    mov eax, 4                  
    mov ebx, 1                  
    mov ecx, msg_err
    mov edx, msg_err_len
    int 0x80

    jmp .exit

.parse_done:

    xor edx, edx
    mov ecx, 100
    div ecx 

    xor edx, edx
    mov ecx, 10
    div ecx
    
    add dl, '0'
    mov [digit_out], dl
    mov byte [digit_out + 1], 10 

    mov eax, 4
    mov ebx, 1
    mov ecx, msg_out
    mov edx, msg_out_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, digit_out
    mov edx, 2
    int 0x80

.exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80