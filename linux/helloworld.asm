SYS_READ:       equ             0
SYS_WRITE:      equ             1
SYS_EXIT:       equ             60

STDIN:          equ             0
STDOUT:         equ             1
STDERR:         equ             2

section .bss


section .data
    msg:        DB              "Hello World", 10
    msglen:     equ             $ - msg


section .text
    global _start

_start:

                mov             rax, SYS_WRITE      ; call the write API
                mov             rdi, STDOUT         ; first parameter is the file handle to the output stream
                mov             rsi, msg            ; second parameter is the address of the buffer
                mov             rdx, msglen         ; third parameter is the length of the buffer
                syscall

                mov             rax, SYS_EXIT       ; call the exit API
                mov             rdi, 0              ; return code is 0
                syscall
