%define _MISC_
%include "./include/misc.inc"

section .text

  ZeroMemory:                                    ;; memory in eax, length in ecx
  dec   ecx
  mov   [eax + ecx], byte 0
  jnz   ZeroMemory
  ret
