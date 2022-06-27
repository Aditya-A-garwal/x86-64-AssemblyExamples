%include "io.asm"

section .bss

section .data
    newl:   DB  10

section .text
    global _start

fibo_recur:
    ; give the fibo_recur function 16 bytes to work with
    push        rbp
    mov         rbp, rsp
    sub         rsp, 16

    ; check for base case
    cmp         rdi, 1
    jg          fibo_recur_regular

    ; base case (when the caller wants the first or second fibonoacci fibonacci numbers)
    ; just return n
    fibo_recur_base:
    mov         rax, rdi
    jmp         fibo_recur_return

    ; regular case
    fibo_recur_regular:

    ; copy n to the stack twice
    mov         [rbp-8], rdi
    mov         [rbp-16], rdi

    ; get n-1 and n-2
    sub         QWORD [rbp-8], 1
    sub         QWORD [rbp-16], 2

    ; call the function recursively to get the n-1th fibonacci number
    ; and move the result to the stack
    mov         rdi, [rbp-8]
    call        fibo_recur
    mov         [rbp-8], rax

    ; call the function recursively to get the n-2th fibonacci number
    ; and move the result to the stack
    mov         rdi, [rbp-16]
    call        fibo_recur
    mov         [rbp-16], rax

    ; keep the sum of the two numbers ready in the rax register for returning
    mov         rax, [rbp-8]
    add         rax, [rbp-16]

    fibo_recur_return:

    leave
    ret

fibo_linear:

    push        rbx

    ; the eax register holds the current value while the ebx register holds the next value
    mov         rax, 0
    mov         rbx, 1

    ; handle special case where the user wants the first fibonacci number
    cmp         rdi, 0
    je          fibo_linear_loopend

    fibo_linear_loopstart:

    ; swap the values of eax and ebx
    xchg        rax, rbx

    ; add the value of eax to ebx
    add         rbx, rax

    ; keep the loop going n times
    dec         rdi
    cmp         rdi, 0
    jne         fibo_linear_loopstart

    fibo_linear_loopend:

    pop         rbx

    ; the eax register already has the answer, no need to move anything
    ret

_main:
    ; give the main function 8 bytes on the stack
    push        rbp
    mov         rbp, rsp
    sub         rsp, 16

    %define     i   [rbp-8]
    %define     j   [rbp-16]
    %define     n   10

    ; initialize i with 0
    mov         QWORD i, 0

    _main_loopstart:

    ; call a fibonacci function and move the result to rdi
    mov         rdi, i
    call        fibo_linear
    ; call        fibo_recur
    mov         rdi, rax

    ; show the value
    call        showInt

    mov         rax, SYS_WRITE
    mov         rdi, STDOUT
    mov         rsi, newl
    mov         rdx, 1
    syscall

    ; increment i and keep looping while its value is not equal to n
    inc         QWORD i
    cmp         QWORD i, n
    jne         _main_loopstart

    _main_loopend:

    %undef      i
    %undef      j
    %undef      n

    xor         rax, rax
    leave
    ret

_start:

    call        _main

    mov         rdi, rax
    mov         rax, SYS_EXIT
    syscall
