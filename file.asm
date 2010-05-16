;; module taking care of file i/o

%define _FILE_ASM
%include "./includes/file.inc"

section .text

  file_open:
    push ebp
    mov ebp, esp
    sub esp, 8
    
    push ebx
    
    call GetProcessHeap
    test eax, eax
    jz .open_alloc_error                   ;; Very unlikely.
    mov [ebp - 4], eax
    
    push dword file.size
    push dword 0
    push eax
    call HeapAlloc
    test eax, eax
    jz .open_alloc_error                   ;; Very unlikely.
    mov [ebp - 8], eax

    mov ecx, [ebp + 12]

    cmp ecx, FILE_READ
    je .open_read
    cmp ecx, FILE_WRITE
    je .open_write
    cmp ecx, FILE_READWRITE
    je .open_readwrite

    mov ebx, dword F_OPEN_FLAGS_INVALID
    jmp .open_error

    .open_read:
      mov edx, OPEN_EXISTING
      jmp .open

    .open_write:
      mov edx, CREATE_ALWAYS
      jmp .open

    .open_readwrite:
      mov edx, OPEN_ALWAYS

    .open:
      push dword NULL
      push dword FILE_ATTRIBUTE_NORMAL
      push edx
      push dword NULL
      push dword 0
      push ecx
      push dword [ebp + 8]
      call CreateFileA

      cmp eax, INVALID_HANDLE_VALUE
      jne .open_success

      mov ebx, F_OPEN_PATH_INVALID
      jmp .open_error
      
    .open_success:
      mov edx, [ebp - 8]
      mov [edx + file.handle], eax

      call GetLastError
      cmp eax, ERROR_ALREADY_EXISTS
      jne .file_created
      
      mov [edx + file.status], dword F_NO_DETAILS
      xor ebx, ebx
      jmp .open_return

    .file_created:
      mov [edx + file.status], dword F_OPEN_FILE_CREATED
      xor ebx, ebx
      jmp .open_return
      
    .open_error:
      push dword [ebp - 8]
      push dword 0
      push dword [ebp - 4]
      call HeapFree

      xor edx, edx
      jmp .open_return
      
    .open_alloc_error:
      xor edx, edx
      mov ebx, F_OPEN_UNKNOWN_ERROR

    .open_return:
      mov eax, edx
      mov ecx, ebx
      pop ebx

      mov esp, ebp
      pop ebp
      ret 8

  file_close:
    push ebp
    mov ebp, esp
    
    push ebx

    mov ebx, [ebp + 8]
    test ebx, ebx
    jz .close_error

    push dword [ds:ebx + file.handle]
    call CloseHandle
    ;; check for valid close

    call GetProcessHeap
    ;; check for valid heap

    push ebx
    push dword 0
    push eax
    call HeapFree

    xor eax, eax
    jmp .close_return

    .close_error:
      mov eax, F_CLOSE_ERROR

    .close_return:
      pop ebx
      mov esp, ebp
      pop ebp
      ret 4

  file_getchar:
    push ebp
    mov ebp, esp
    sub esp, 8
    
    push ebx
    mov ebx, [ebp + 8]

    test ebx, ebx
    jz .getchar_return

    mov [ebx + file.status], dword F_NO_DETAILS

    push dword NULL
    lea eax, [ebp - 4]
    push eax
    push dword 1
    lea eax, [ebp - 5]
    push eax
    push dword [ebx + file.handle]
    call ReadFile

    test eax, eax
    jz .getchar_error

    movsx ebx, byte [ebp - 5]
    jmp .getchar_return

    .getchar_error:
      mov ebx, dword F_READ_ERROR

      call GetLastError
      cmp eax, ERROR_HANDLE_EOF
      je .getchar_eof
      jmp .getchar_return

    .getchar_eof:
      mov ebx, dword [ebp + 8]
      mov [ebx + file.status], dword F_READ_EOF

    .getchar_return:
      mov eax, ebx
      pop ebx
      mov esp, ebp
      pop ebp
      ret 4

  file_getline:
    push ebp
    mov ebp, esp
    sub esp, 8
    
    push ebx
    push esi
    push edi
    
    xor ebx, ebx
    mov esi, [ebp + 12]
    mov edi, [ebp + 8]

    .getline_loop:
      cmp ebx, esi
      je .getline_error_buffer_full
      push dword [ebp + 16]
      call file_getchar

      cmp eax, F_READ_ERROR
      je .getline_return

      cmp eax, 13
      je .getline_newline

      mov byte [edi + ebx], al
      inc ebx
      jmp .getline_loop

    .getline_newline:
      mov byte [edi + ebx + 1], 0
      xor ecx, ecx
      
      push dword FILE_CURRENT
      push dword NULL
      push dword 1
      push dword [ebp + 16]
      call SetFilePointer
      
      jmp .getline_return

    .getline_error_buffer_full:
      mov ecx, F_READ_BUFFER_FULL

    .getline_return:
      mov eax, ebx
      pop edi
      pop esi
      pop ebx
      mov esp, ebp
      pop ebp
      ret 12

  file_write:
    push ebp
    mov ebp, esp
    push eax              ;; same as sub esp, 4 but faster.
    
    push ebx
    mov ebx, [ebp + 16]
    mov [ebx + file.status], dword F_NO_DETAILS

    push dword NULL
    lea eax, [ebp - 4]
    push eax
    push dword [ebp + 12]
    push dword [ebp + 8]
    push dword [ebx + file.handle]
    call WriteFile

    test eax, eax
    jz .write_error

    pop eax
    jmp .write_return

    .write_error:
      mov eax, dword F_WRITE_ERROR
      pop ecx

    .write_return:
      mov esp, ebp
      pop ebp
      ret 12
