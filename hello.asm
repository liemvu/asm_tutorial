; ----------------------------------------------------------------------------------------
; Writes "Hello, World" to the console using only system calls. Runs on 64-bit MacOS only.
; To assemble and run:
;
;     nasm -f macho64 hello.asm && ld -arch x86_64 -macosx_version_min 10.7.0 -lSystem -no_pie -o hello hello.o  && ./hello
; ----------------------------------------------------------------------------------------

        global  start
        
        section .text
start:
        ; write(1, message, 13)
        mov     eax, 0x2000004                  ; system call 1 is write
        mov     rdi, 1                  ; file handle 1 is stdout
        mov     rsi, message            ; address of string to output
        mov     edx, 13                 ; number of bytes
        syscall                         ; invoke operating system to do the write

        ; exit(0)
        mov     eax, 0x2000001                 ; system call 60 is exit
        xor     rdi, rdi                ; exit code 0
        syscall                         ; invoke operating system to exit
message:
        db      "Hello, World", 10      ; note the newline at the end