%include "./includes/file.inc"

global config_getitem

extern console_putstr
extern WriteConsoleA
extern GetStdHandle
NULL equ 0

section .text

  config_getitem:
    push ebp
    mov ebp, esp
    sub esp, (256 + 4) ;; char[256] + dword

    push FILE_READWRITE
    push file_name
    call file_open

    test eax, eax
    jz .getitem_failure

    mov [ebp - 4], eax          ;; store file handle at stack

    cmp ecx, FILE_CREATED
    je .getitem_writetemplate

    .getitem:
      push dword [ebp - 4]
      push 256
      lea eax, [ebp - (256 + 4)]
      push eax
      call file_getline
      cmp ecx, READ_EOF
      je .eof

    .debugprint:
      lea eax, [ebp - (256 + 4)]
      push eax
      call console_putstr
      jmp .getitem

    .eof:
      cmp eax, 0
      jne .debugprint
      jmp .getitem_return

    .getitem_writetemplate:
      mov edx, eax
      push eax
      push dword [file_template_len]
      push file_template
      call file_write
      push edx
      call file_close

    .getitem_failure:
    .getitem_return:
      mov esp, ebp
      pop ebp
      ret 4

section .data

  file_name: db "x86c.cfg", 0

  file_template: db \
  "#x86craft configuration", 13, 10, \
  "name=x86craft",           13, 10, \
  "motd=x86craft",           13, 10, \
  "max_players=16",          13, 10, 0

  file_template_len: dd $-file_template-1
