section .data
    mode    db  "r", 0
    fmt_int db  "%d", 0
    sum_msg db  "Sum: %d", 10, 0
    extern fopen, fscanf, printf, fclose

section .bss
    array   resd 1000
    count   resd 1
    sum     resd 1
    fp      resd 1

section .text
global main

main:
    push    ebp
    mov     ebp, esp

    cmp     dword [ebp + 8], 2
    jne     exit

    mov     eax, [ebp + 12]
    mov     ebx, [eax + 4]


    push    mode
    push    ebx
    call    open_file
    add     esp, 8
    cmp     eax, 0
    je      exit

    call    read_data
    call    summing
    call    print_final

    push    dword [fp]
    call    fclose
    add     esp, 4

exit:
    mov     esp, ebp
    pop     ebp
    xor     eax, eax
    ret


open_file:
    push    ebp
    mov     ebp, esp

    push    dword [ebp + 12]
    push    dword [ebp + 8]
    call    fopen
    add     esp, 8

    mov     [fp], eax
    mov     esp, ebp
    pop     ebp
    ret

read_data:
    push    ebp
    mov     ebp, esp

    push    count
    push    fmt_int
    push    dword [fp]
    call    fscanf
    add     esp, 12

    xor     ecx, ecx
    mov     ebx, array

read_loop:
    cmp     ecx, [count]
    jge     done

    push    ebx
    push    fmt_int
    push    dword [fp]
    call    fscanf
    add     esp, 12

    cmp     eax, 1
    jne     done

    add     ebx, 4
    inc     ecx
    jmp     read_loop

done:
    mov     esp, ebp
    pop     ebp
    ret

summing:
    push    ebp
    mov     ebp, esp

    xor     eax, eax
    xor     ecx, ecx
    mov     ebx, array

sum_loop:
    cmp     ecx, [count]
    jge     .done
    add     eax, [ebx]
    add     ebx, 4
    inc     ecx
    jmp     sum_loop

.done:

    add     eax, [count]
    mov     [sum], eax
    mov     esp, ebp
    pop     ebp
    ret


print_final:
    push    ebp
    mov     ebp, esp

    push    dword [sum]
    push    sum_msg
    call    printf
    add     esp, 8

    mov     esp, ebp
    pop     ebp
    ret