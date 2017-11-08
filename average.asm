; -----------------------------------------------------------------------------
; 64-bit program that treats all its command line arguments as integers and
; displays their average as a floating point number.  This program uses a data
; section to store intermediate results, not that it has to, but only to
; illustrate how data sections are used.
; nasm -f macho64 --prefix _ average.asm && gcc -g -std=c99  average.o -o average  && ./average 19 8 21 -33
; -----------------------------------------------------------------------------

        global   main
        extern   atoi
        extern   printf

        section  .text
main:
        dec      rdi                    ; argc-1, since we don't count program name
        jz       nothingToAverage
        mov      [rel count], rdi           ; save number of real arguments
accumulate:
        push     rdi                    ; save register across call to atoi
        push     rsi
        mov      rdi, [rsi+rdi*8]       ; argv[rdi]
        call     atoi                   ; now rax has the int value of arg
        pop      rsi                    ; restore registers after atoi call
        pop      rdi
        add      [rel sum], rax             ; accumulate sum as we go
        dec      rdi                    ; count down
        jnz      accumulate             ; more arguments?
average:
        cvtsi2sd xmm0, [rel sum]
        cvtsi2sd xmm1, [rel count]
        divsd    xmm0, xmm1             ; xmm0 is sum/count
        lea      rdi, [rel format]      ; 1st arg to printf
        mov      rax, 1                 ; printf is varargs, there is 1 non-int argument

        sub      rsp, 8                 ; align stack pointer
        call     printf                 ; printf(format, sum/count)
        add      rsp, 8                 ; restore stack pointer

        ret

nothingToAverage:
        lea      rdi, [rel error]
        xor      rax, rax
        call     printf
        ret

        section  .data
count:  dq       0
sum:    dq       0
format: db       "%g", 10, 0
error:  db       "There are no command line arguments to average", 10, 0