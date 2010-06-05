%ifdef _MISC_
  global ZeroMemory
%else
  extern ZeroMemory
%endif

NULL equ 0 ;; will be used instead of '0' on functions that asks for pointers
