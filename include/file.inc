%ifdef _FILE_
  global f_open
  global f_close
  global f_putc
  global f_getc
  global f_write
  global f_read
  global f_getline
  global f_putline

  extern __imp__CreateFileA@28
  extern __imp__CloseHandle@4
  extern __imp__WriteFile@20
  extern __imp__ReadFile@20

  %define CreateFileA [__imp__CreateFileA@28]
  %define CloseHandle [__imp__CloseHandle@4]
  %define WriteFile [__imp__WriteFile@20]
  %define ReadFile[__imp__ReadFile@20]

  GENERIC_READ      equ 0x80000000
  GENERIC_WRITE     equ 0x40000000
  GENERIC_READWRITE equ (GENERIC_READ | GENERIC_WRITE)
%else
  extern f_open
  extern f_close
  extern f_putc
  extern f_getc
  extern f_write
  extern f_read
  extern f_getline
  extern f_putline

  READ      equ 0x80000000
  WRITE     equ 0x40000000
  READWRITE equ (READ | WRITE)
%endif

;; file error codes
FILE_NO_ERR   equ 0
FILE_NO_FILE  equ 1
