;Дан массив из 20-ти чисел и число A. Вычислить произведение тех элементов массива, 
; модуль которых больше чем A. Подсчитать количество таких элементов
section .data
    msg_in_1 db "Введите 20 чисел: "
    len_1 equ $ - msg_in_1
    msg_in_2 db "Введите A: "
    len_2 equ $ - msg_in_2

    msg_out_1 db "Произведение = "
    len_out_1 equ $ - msg_out_1
    msg_out_2 db "Количество =  "
    len_out_2 equ $ - msg_out_2

    msg_err db "ОШИБКА: НЕВЕРНЫЕ ДАННЫЕ!!!", 10
    len_err equ $ - msg_err

    msg_ovf db "ОШИБКА: РАЗМЕР ПРОИЗВЕДЕНИЯ БОЛЬШЕ 32 БИТ", 10
    len_ovf equ $ - msg_ovf

section .bss
    input_buf resb 32 
    array resd 20           
    A resd 1
    i resd 1
    prod resd 1
    count resd 1
    number resd 1
    digit resb 16

section .text
    global _start

_start:
    ; "Введите 20 чисел: "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_in_1
    mov edx, len_1
    int 0x80

;ввод массива
    mov dword [i], 0
input_loop:
    cmp dword [i], 20
    jge input_A
    
    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80

    cmp eax, 0
    jle error

    mov esi, input_buf
    mov ecx, eax

skip_sp:
    cmp ecx, 0
    je error
    mov bl, [esi]

    cmp bl, ' '
    je skip_ch
    cmp bl, 9 ;TAB
    je skip_ch
    cmp bl, 10 ;Перевод строки 
    je skip_ch
    cmp bl, 13 ;Возврат каретки
    je skip_ch

    jmp parse_num

skip_ch:
    inc esi
    dec ecx
    jmp skip_sp  

;строка -> число
parse_num:
    xor edi, edi
    cmp byte [esi], '-'
    jne is_plus

    mov edi, 1
    inc esi
    dec ecx
    jmp start_digit

is_plus:
    cmp byte [esi], '+'
    jne start_digit
    inc esi
    dec ecx

start_digit:
    cmp ecx, 0
    je error
    xor eax, eax
    xor ebx, ebx

digit_loop:
    cmp ecx, 0
    je digit_done 

    mov bl, [esi]
    cmp bl, 10
    je digit_done
    cmp bl, 13
    je digit_done 
    cmp bl, '0'
    jb error
    cmp bl, '9'
    ja error

    sub bl, '0'
    imul eax, eax, 10
    jo error 
    movzx ebx, bl
    add eax, ebx
    jo error
    inc esi
    dec ecx
    jmp digit_loop

digit_done:
    cmp edi, 1
    jne save_number
    neg eax

save_number:
    mov ebx, [i]
    mov [array + ebx * 4], eax 
    inc dword [i]
    jmp input_loop        

input_A:
    ;"Введите A: "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_in_2
    mov edx, len_2
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, input_buf
    mov edx, 32
    int 0x80

    cmp eax, 0
    jle error

    mov esi, input_buf
    mov ecx, eax
    xor eax, eax
    xor edi, edi

    cmp byte [esi], '-'
    jne A_plus
    mov edi, 1
    inc esi
    dec ecx
    jmp A_start

A_plus:
    cmp byte [esi], '+'
    jne A_start
    inc esi
    dec ecx   

A_start:
    cmp ecx, 0
    je error
    xor edx, edx

parse_A:
    cmp ecx, 0
    je A_done

    mov bl, [esi]
    cmp bl, 10
    je A_done
    cmp bl, 13
    je A_done
    cmp bl, '0'
    jb error
    cmp bl, '9'
    ja error

    sub bl, '0'
    imul eax, eax, 10
    jo error
    movzx ebx, bl
    add eax, ebx
    jo error
    inc esi 
    dec ecx
    inc edx
    jmp parse_A

A_done:
    cmp edx, 0
    je error
    cmp edi, 1
    jne A_save
    neg eax
    jo error
    
A_save:
    mov [A], eax
    jmp calc

calc:
    mov dword [i], 0
    mov dword [count], 0
    mov dword [prod], 1

process_loop:
    cmp dword [i], 20
    jge result
    mov ebx, [i]
    mov eax, [array + ebx * 4]
    cmp eax, 0
    jge val
    neg eax

val:
    cmp eax, [A]
    jle next_element
    inc dword [count]
    mov ebx, [i]
    mov eax, [array + ebx * 4]
    imul dword [prod]
    jo ovf_error
    mov [prod], eax

next_element:
    inc dword [i]
    jmp process_loop    

result:
    ;"Произведение = "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_out_1
    mov edx, len_out_1
    int 0x80

    mov eax, [prod]
    mov edi, digit + 15
    mov byte [edi], 10
    mov ebx, 10
    xor ecx, ecx

    cmp eax, 0
    jge prod_positive

    neg eax
    mov ecx, 1

prod_positive:
    xor edx, edx
    div ebx

    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz prod_positive
    cmp ecx, 1
    jne prod_print
    dec edi
    mov byte [edi], '-'

prod_print:
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, digit + 16
    sub edx, edi
    int 0x80

    ;"Количество =  "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_out_2
    mov edx, len_out_2
    int 0x80

    mov eax, [count]
    mov edi, digit + 15
    mov byte [edi], 10
    mov ebx, 10
count_convert:
    xor edx, edx
    div ebx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz count_convert

    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, digit + 16
    sub edx, edi
    int 0x80
    jmp exit

ovf_error:
    ;"ОШИБКА: РАЗМЕР ПРОИЗВЕДЕНИЯ БОЛЬШЕ 32 БИТ"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_ovf
    mov edx, len_ovf
    int 0x80
    jmp exit
error:
    ;"ОШИБКА: НЕВЕРНЫЕ ДАННЫЕ!!!"
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_err
    mov edx, len_err
    int 0x80
    jmp exit

exit:
    mov eax, 1
    xor ebx, ebx
    int 80h