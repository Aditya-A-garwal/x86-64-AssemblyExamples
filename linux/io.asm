SYS_READ        equ     0
SYS_WRITE       equ     1
SYS_EXIT        equ     60

STDIN           equ     0
STDOUT          equ     1
STDERR          equ     2

; routine to read and parse an integer from a stdin
; uses the r8, r9, r10 registers
readInt:

    ; give 16 bytes to the readInt function
    push        rbp
    mov         rbp, rsp
    sub         rsp, 16

    ; result (to return)
    %define     res     r10
    ; loop variable
    %define     i       r8
    ; whether to negate the result or not
    %define     mult    r9
    ; stores characters as they are read from stdin
    %define     c       [rbp-16]

    ; initialize mul with 1, everything else with 0
    mov         QWORD c, 0
    mov         QWORD res, 0
    mov         QWORD mult, 1
    mov         QWORD i, 0

    readInt_whileStart:

    ; call system read to read from stdin
    mov         rax, SYS_READ
    mov         rdi, STDIN
    lea         rsi, c
    mov         rdx, 1
    syscall

    ; if nothing could be read from stdin, break out of the loop
    cmp         rax, 0
    je          readInt_whileEnd

    mov         al, BYTE c

    ; if a newline (10) was read, break out of the loop
    cmp         al, 10
    je          readInt_whileEnd

    ; if a minus sign was read, the value of mul should be negative
    readInt_minusCase:
    cmp         al, 45
    jne         readInt_digitCase
    mov         QWORD mult, -1
    jmp         readInt_loopCheck

    ; otherwise, assume it is a digit and move forward
    readInt_digitCase:

    ; multiply res by 10 and add the digit stored at c to it
    imul        res, 10
    add         res, c
    sub         res, 48

    readInt_loopCheck:

    ; increment i and keep looping if it is not yet 32
    inc         QWORD i
    cmp         QWORD i, 32
    jne         readInt_whileStart

    readInt_whileEnd:

    ; multiple res with mul and return it
    mov         rax, QWORD res
    imul        rax, QWORD mult

    leave
    ret

    %undef      c
    %undef      res
    %undef      mult
    %undef      i

; routine to print an integer to stdout
; uses the r8, r9 and r10 registers
showInt:
    ; give 24 bytes to the showInt function
    push        rbp
    mov         rbp, rsp
    sub         rsp, 24

    ; a buffer to store the final resutl
    %define     buff(x)     [rbp-24+(x)]
    ; the supplied value
    %define     val         r8
    ; r15 holds the address of where to print from
    %define     startAddr   r9
    ; r14 holds the length of the resultant string
    %define     len         r10

    ; move the supplied integer to the r8 register for faster access
    mov         val, rdi

    ; set the first and second positions to '-' and '0'
    mov         WORD buff(0), 0x302D

    ; load the address of the second character of buff into startAddr and rdi
    lea         startAddr, buff(1)
    mov         rdi, startAddr

    ; make the length 0
    xor         len, len

    ; check if the supplied number is negative, zero or positive
    cmp         val, 0
    jge         showInt_positive

    showInt_negative:
    ; negate the supplied number
    neg         val
    ; start printing from the first character
    dec         startAddr
    inc         len

    showInt_positive:

    ; keep the divisor (10) and dividend in the rbx and rax registers ready
    mov         rax, val
    mov         rbx, 10
    showInt_loopstart1:

    ; divide the value by 10 and add '0' to the remainder
    cqo
    idiv        rbx
    add         rdx, 48

    ; move this value to buff[ptr] and increment len
    inc         rdi
    inc         len
    mov         BYTE [rdi], dl

    ; keep looping while the value does not become zero
    cmp         rax, 0
    jne         showInt_loopstart1

    showInt_loopend1:

    ; load the address of the two endpoints of buff to reverse
    lea         rsi, buff(1)
    showInt_loopstart2:

    ; swap the values pointed to by rsi and rdi
    mov         al, BYTE [rsi]
    xchg        al, BYTE [rdi]
    mov         BYTE [rsi], al

    ; move the two pointers forward and backward
    inc         rsi
    dec         rdi

    cmp         rsi, rdi
    jl          showInt_loopstart2

    showInt_loopend2:

    ; write the buffer to stdout and return the number of bytes which could successfully be written
    mov         rax, SYS_WRITE
    mov         rdi, STDOUT
    mov         rsi, startAddr
    mov         rdx, len
    syscall

    leave
    ret

    %undef      buff
    %undef      startAddr
    %undef      len
