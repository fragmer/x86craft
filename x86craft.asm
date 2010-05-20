global x86craft

global x86craft

%include "./includes/file.inc"

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
    push filename
    call file_open
    push eax
    call file_close
    xor eax, eax
    ret

section .data

  filename: db "x86c.cfg", 0

section .bss

  x86c: resb x86c.size
