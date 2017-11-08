; ----------------------------------------------------------------------------------------
; Writes "Hello, World" to the console using only system calls. Runs on 64-bit MacOS only.
; To assemble and run:
;
;     nasm -f macho64 --prefix _ hola.asm && gcc -g -std=c99  hola.o -o hola  && ./hola
; ----------------------------------------------------------------------------------------

        global  main
        extern  puts

        section .text
main:
 		push    rbp
    	mov     rbp, rsp       

        lea     rdi, [rel message]            ; address of string to output
        call    puts

        mov     rsp, rbp
    	pop     rbp
        ret                         

message:
        db      "Hola, mundo", 0      ; Note strings must be terminated with 0 in C