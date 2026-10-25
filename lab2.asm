; Даны 4 целых числа, одно из которых отлично от трёх других, равных между собой.
; Определить порядковый номер числа, отличного от остальных.

section .data
    msg_in_1 db "Введите число 1: "
    msg_in_len_1  equ $ - msg_in_1

    msg_in_2 db "Введите число 2: "
    msg_in_len_2  equ $ - msg_in_2
    
    msg_in_3 db "Введите число 3: "
    msg_in_len_3  equ $ - msg_in_3
    
    msg_in_4 db "Введите число 4: "
    msg_in_len_4  equ $ - msg_in_4

    msg_err db "Неверные данные!!!"
    msg_err_len equ $ - msg_err

    msg_out db "Порядковый номер числа, отличного от остальных: "
    msg_out_len  equ $ - msg_out
    newline db 10
section .bss
    input_buf resb 32
    num1 resd 1
    num2 resd 1
    num3 resd 1
    num4 resd 1
    res_buf resb 1
section .text
    global _start
_start:
;1
    mov eax, 4                  
    mov ebx, 1                  
    mov ecx, msg_in_1
    mov edx, msg_in_len_1
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80

    dec eax
    cmp eax, 0
    je error
    mov edx, eax
    mov esi, input_buf
    mov ecx, edx
check1:
    mov bl, [esi]

    cmp bl, '0'
    jb error
    cmp bl, '9'
    ja error

    inc esi
    loop check1

    mov esi, input_buf
    mov ecx, edx
    xor eax, eax

convert1:
    imul eax, 10
    movzx ebx, byte [esi]
    sub ebx, '0'
    add eax, ebx
    inc esi
    loop convert1
    mov [num1], eax
;2
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_in_2
    mov edx, msg_in_len_2
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80

    dec eax
    cmp eax, 0
    je error
    mov edx, eax
    mov esi, input_buf
    mov ecx, edx
check2:
    mov bl, [esi]

    cmp bl, '0'
    jb error
    cmp bl, '9'
    ja error

    inc esi
    loop check2

    mov esi, input_buf
    mov ecx, edx
    xor eax, eax
convert2:
    imul eax, 10
    movzx ebx, byte [esi]
    sub ebx, '0'
    add eax, ebx
    inc esi
    loop convert2
    mov [num2], eax
;3   
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_in_3
    mov edx, msg_in_len_3
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80
    dec eax

    cmp eax, 0
    je error
    mov edx, eax
    mov esi, input_buf
    mov ecx, edx
check3:
    mov bl, [esi]

    cmp bl, '0'
    jb error
    cmp bl, '9'
    ja error

    inc esi
    loop check3

    mov esi, input_buf
    mov ecx, edx
    xor eax, eax

convert3:
    imul eax, 10
    movzx ebx, byte [esi]
    sub ebx, '0'
    add eax, ebx
    inc esi
    loop convert3
    mov [num3], eax
;4
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_in_4
    mov edx, msg_in_len_4
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 80h
    
    dec eax
    cmp eax, 0
    je error
    mov edx, eax
    mov esi, input_buf
    mov ecx, edx
check4:
    mov bl, [esi]

    cmp bl, '0'
    jb error
    cmp bl, '9'
    ja error

    inc esi
    loop check4

    mov esi, input_buf
    mov ecx, edx
    xor eax, eax
convert4:
    imul eax, 10
    movzx ebx, byte [esi]
    sub ebx, '0'
    add eax, ebx
    inc esi
    loop convert4

    mov [num4], eax
    
    mov eax, [num1]
    cmp eax, [num2]
    je check_num2
    cmp eax, [num3]
    je check_num2
    cmp eax, [num4]
    je check_num2
    mov byte [res_buf], '1'
    jmp print_answer

check_num2:
    mov eax, [num2]
    cmp eax, [num1]
    je check_num3
    cmp eax, [num3]
    je check_num3
    cmp eax, [num4]
    je check_num3
    mov byte [res_buf], '2'
    jmp print_answer

check_num3:
    mov eax, [num3]
    cmp eax, [num1]
    je check_num4
    cmp eax, [num2]
    je check_num4
    cmp eax, [num4]
    je check_num4
    mov byte [res_buf], '3'
    jmp print_answer

check_num4:
    mov eax, [num4]
    cmp eax, [num1]
    je error
    cmp eax, [num2]
    je error
    cmp eax, [num3]
    je error
    mov byte [res_buf], '4'
    jmp print_answer

print_answer:
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_out
    mov edx, msg_out_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, res_buf
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp exit

error:
    mov eax, 4                  
    mov ebx, 1                  
    mov ecx, msg_err
    mov edx, msg_err_len
    int 0x80

    jmp exit

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80