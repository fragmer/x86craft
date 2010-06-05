%define _NET_
%include "./include/misc.inc"
%include "./include/net.inc"

section .text

  net_startup:
  call  ws

  mov   ebx, str_port                            ;; will later be parsed from configuration
  call  lstn
  call  init_fd

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
  ;; errorchecking?

  add   esp, WSADATA.size

  ret

  lstn:                                          ;; sets up a listener on eax:edx
  mov   ecx, ai.size
  sub   esp, ecx
  mov   eax, esp
  call  ZeroMemory

  mov   [esp + ai.ai_family], dword PF_INET
  mov   [esp + ai.ai_socktype], dword SOCK_STREAM
  mov   [esp + ai.ai_protocol], dword IPPROTO_TCP

  push  ai_heartbeat                             ;; did i mention we initialize heartbeat here too?
  push  eax                                      ;; eax (stores esp) is preserved in ZeroMemory
  push  http_port
  push  hb_url
  call  getaddrinfo
  ;; errorchecking!

  mov   [esp + ai.ai_flags], dword AI_PASSIVE

  mov   eax, esp
  push  eax
  push  eax
  push  ebx                                      ;; port to listen on
  push  NULL                                     ;; let getaddrinfo resolve our hostname
  call  getaddrinfo
  ;; errorchecking!

  mov   ebx, [esp]
  add   esp, ai.size

  push  dword [ebx + ai.ai_protocol]
  push  dword [ebx + ai.ai_socktype]
  push  dword [ebx + ai.ai_family]
  call  socket
  ;; errorchecking!
  mov   [sock], eax

  push  dword [ebx + ai.ai_addrlen]
  push  dword [ebx + ai.ai_addr]
  push  dword [sock]
  call  bind
  ;; errorchecking!

  push  ebx
  call  freeaddrinfo
  ;; errorchecking?

  push  0                                        ;; not sure how important this is, might change
  push  dword [sock]
  call  listen

  xor   eax, eax
  ret

  init_fd:                                       ;; initializes anything that has to do with select
  xor   eax, eax
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
