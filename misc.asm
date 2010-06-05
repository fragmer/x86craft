%define _MISC_
%include "./include/misc.inc"

section .text

  MemZero:                                       ;; dst in edi, len in ecx
  xor   al, al
  rep   stosb
  ret

  MemCopy:                                       ;; src in esi, dst in edi, len in ecx
  rep movsb
  ret
