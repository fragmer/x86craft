%define _X86CRAFT_
%include "./include/net.inc"

global x86craft

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
    xor eax, eax
    ret
