%define _NET_
%include "./include/misc.inc"
%include "./include/net.inc"

section .text

  net_startup:
  call  ws

  mov   ebx, str_port                            ;; will later be parsed from configuration
  call  lstn

  mov   eax, fd_read
  mov   [eax + fd.fd_count], dword 0
  mov   edx, [sock]
  call  fd_add

  xor   eax, eax
  ret

  net_step:
  xor   eax, eax
  ret

  net_cleanup:
  xor   eax, eax
  ret

  ws:                                            ;; initializes winsock
  sub   esp, WSADATA.size

  push  esp
  push  0202h
  call  WSAStartup
  test  eax, eax

  add   esp, WSADATA.size

  ret

  lstn:                                          ;; sets up a listener on eax:edx
  mov   ecx, ai.size
  sub   esp, ecx
  mov   edi, esp
  call  MemZero

  mov   [esp + ai.ai_family], dword PF_INET
  mov   [esp + ai.ai_socktype], dword SOCK_STREAM
  mov   [esp + ai.ai_protocol], dword IPPROTO_TCP

  push  ai_heartbeat                             ;; did i mention we initialize heartbeat here too?
  push  eax                                      ;; eax (stores esp) is preserved in ZeroMemory
  push  http_port
  push  hb_url
  call  getaddrinfo
  test  eax, eax
  jnz   .err_getai

  mov   [esp + ai.ai_flags], dword AI_PASSIVE

  mov   eax, esp
  push  eax
  push  eax
  push  ebx                                      ;; port to listen on
  push  NULL                                     ;; let getaddrinfo resolve our hostname
  call  getaddrinfo
  test  eax, eax
  jnz   .err_getai

  mov   ebx, [esp]
  add   esp, ai.size

  push  dword [ebx + ai.ai_protocol]
  push  dword [ebx + ai.ai_socktype]
  push  dword [ebx + ai.ai_family]
  call  socket
  test  eax, eax
  jz    .err_socket
  mov   [sock], eax

  push  dword [ebx + ai.ai_addrlen]
  push  dword [ebx + ai.ai_addr]
  push  dword [sock]
  call  bind
  test  eax, eax
  jnz   .err_bind

  push  ebx
  call  freeaddrinfo

  push  0                                        ;; not sure how important this is, might change
  push  dword [sock]
  call  listen
  test  eax, eax
  jnz   .err_listen

  ;;    if we're here, eax is already zero.
  jmp   .return
  
  .err_socket:
  inc   eax
  jmp   .return

  .err_getai:
  .err_bind:
  .err_freeai:
  .err_listen:

  .return:
  ret

  fd_add:                                        ;; adds fd edx to the fd_set* in eax
  mov   ecx, dword [eax + fd.fd_count]           ;; returns 0 on success
  cmp   ecx, 63                                  ;; a maximum of 64 (0-63) fd's per set
  jae   .err_full

  inc   ecx
  mov   [eax + fd.fd_array + ecx], edx
  xor   eax, eax
  jmp   .return
  
  .err_full:
  mov   eax, NET_FD_FULL

  .return:
  ret

  heartbeat:
  xor   eax, eax
  ret

section .data

  str_port: db "25566", 0                        ;; will later be parsed from configuration
  hb_url: db "www.minecraft.net", 0
  http_port: db "80", 0

section .bss

  fd_read: resb fd.size
  fd_tmp: resb fd.size

  sock: resd 1
  nfds: resd 1
  ai_heartbeat: resd 1
