%ifdef _CONSOLE_
  global print

  extern __imp__GetStdHandle@4

  %define GetStdHandle [__imp__GetStdHandle@4]

  STD_INPUT_HANDLE    equ -10
  STD_OUTPUT_HANDLE   equ -11
  STD_ERROR_HANDLE    equ -12
  INVALID_HANDLE_VALUE equ -1
%else
  extern print
%endif

CONSOLE_NO_ERR    equ 0
CONSOLE_NO_HANDLE equ 1