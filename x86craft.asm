global x86craft

%include "./includes/file.inc"
extern console_putchar

;;  struct x86c --- [
;;    [struct *net]     -   4 bytes (range 00-03)
;;    [struct *world]   -   4 bytes (range 04-07)
;;    [struct *config]  -   4 bytes (range 08-11)
;;    [struct *players] -   4 bytes (range 12-15)
;;  --- ]               -  16 bytes (range 00-15)

;; struct x86c offsets
x86c.net     equ 00
x86c.world   equ 04
x86c.config  equ 08
x86c.players equ 12
x86c.size    equ 16

section .text

  x86craft:
    push ebp
    mov ebp, esp
    sub esp, 4

    push FILE_READ
    push filename
    call file_open

    test eax, eax
    jz .x86craft_return

    mov ebx, eax

    .x86craft_loop:
      push ebx
      call file_getchar

      cmp eax, F_READ_ERROR
      je .x86craft_unloop

      push eax
      call console_putchar
      jmp .x86craft_loop

    .x86craft_unloop:
      push dword [ebp - 4]
      call file_close

    .x86craft_return:
      xor eax, eax
      mov esp, ebp
      pop ebp
      ret

section .data

  filename: db "x86c.cfg", 0

section .bss

  x86c: resb x86c.size
