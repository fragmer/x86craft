%ifdef _MISC_
  global MemZero
  global MemCopy
%else
  extern MemZero
  extern MemCopy
%endif

NULL equ 0 ;; will be used instead of '0' on functions that asks for pointers
