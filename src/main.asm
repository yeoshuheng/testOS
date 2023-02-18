org 0x7C00
bits 16

;Macro to end line.
%define ENDL 0x00, 0x0A

start:
    jpm main ;Need to jump to main since functions written above main.

;
; Prints characters of string to stdout until it comes across NULL.
; @param ds:si pointer to string.

puts:
    ; Saves registers to modify.
    push si
    push ax
    
.loop:
    lodsb               ;Loads next character in al.
    or al, al           ;Indicator to exit loop: sets zero flag.
    jz .done            ;Jumps to done when zero flag is set.
    
    ;Printing the string.

    mov bh 0            ;Set page number to 0.
    mov ah 0x0e         ;Call BIOS interrupt.
    int 0x10

    jmp.loop

.done:
    pop ax 
    pop si
    ret



main:

    ;set up data segments.
    
    mov ax, 0 ;we cannot write to ds/es directly.
    mov ds, ax
    mov es, ax

    ;setup stack.
    ;stack pushes pointers downwards to write to memory.
    ;hence, stack needs to be at the start of the OS,
    ;to prevent overwritting the program.

    mov ss, ax
    mov sp, 0x7C00


    ;Print message.
    mov si, msg_hello
    call puts

    hlt

.halt:
    jmp.halt

times 510-($-$$) db 0
dw 0AA55h
