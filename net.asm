%define _NET_
%include "./include/net.inc"

WSADATA.size equ 400

section .text

  net_init:
  call  ws
  xor   eax, eax
  ret

  net_step:
  xor   eax, eax
  ret

  net_cleanup:
  xor   eax, eax
  ret

  ws:
  sub esp, WSADATA.size

  push esp
  push 0202h
  call WSAStartup

  add   esp, WSADATA.size

  ret

  beat:
  xor   eax, eax
  ret
