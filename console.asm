%define _CONSOLE_
%include "./include/file.inc"
%include "./include/console.inc"

section .text

  print:
  cmp   [hStdOut], dword 0
  jne   .print

  push  eax
  push  edx

  push  STD_OUTPUT_HANDLE
  call  GetStdHandle

  test  eax, eax
  je    .err_handle

  cmp   eax, INVALID_HANDLE_VALUE
  je    .err_handle

  mov   [hStdOut], eax

  pop   edx
  pop   eax

  .print:
  xor   eax, eax
  jmp   .return

  .err_handle:
  mov   eax, CONSOLE_NO_HANDLE

  .return:
  ret

section .bss

  hStdIn: resd 1
  hStdOut: resd 1
