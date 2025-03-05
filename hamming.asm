	SECTION .text
	global _start
_start:

section .data
    str1 db "foo", 0
    str2 db "bar", 0
    len equ 3
    msg db "Hamming Distance: ", 0
    msg_len equ 19
    newline db 10
section .bss
    hamming resb 1

section .text
    global _start

_start:

    mov esi, str1
    mov edi, str2
    mov ecx, len
    mov edx, 0 ;used to add up Hamming distance

for_loop:
    mov al, [esi]
    mov bl, [edi]
    xor al, bl

    mov ebx, 0 ;used for counting differing bits


if_bit_count:
    test al, 1
    jz else_if_bit_count
    inc ebx

else_if_bit_count:
    shr al, 1
    jnz if_bit_count

    add edx, ebx

    inc esi
    inc edi
    dec ecx
    jnz for_loop

    mov eax, edx
    add eax , '0'
    mov [hamming], al

    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, msg_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, hamming
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

