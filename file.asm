%define _FILE_
%include "./include/file.inc"

section .text

  f_open:                                        ;; tries to open filename: eax with flags edx

  f_close:                                       ;; closes file in eax

  f_putc:                                        ;; writes a char: eax to file eax

  f_getc:                                        ;; reads a char from file eax

  f_write:                                       ;; writes to file: eax from esi until ecx is reached.

  f_read:                                        ;; reads from file: eax into edi until ecx is reached.

  f_getline:                                     ;; reads from file: eax into edi until newline is found.

  f_putline:                                     ;; writes to file: eax from esi until null is found.
