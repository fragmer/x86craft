%ifdef _NET_
  global net_startup
  global net_step
  global net_cleanup

  ;; net error codes
  NET_NOERR equ 00
  FD_FULL   equ 01

  ;; ws2_32.lib
  extern __imp__WSAStartup@8
  extern __imp__WSACleanup@0
  extern __imp__socket@12
  extern __imp__bind@12
  extern __imp__listen@8
  extern __imp__select@20
  extern __imp__closesocket@4
  extern __imp__getaddrinfo@16
  extern __imp__freeaddrinfo@4

  %define WSAStartup [__imp__WSAStartup@8]
  %define WSACleanup [__imp__WSACleanup@0]
  %define socket [__imp__socket@12]
  %define bind [__imp__bind@12]
  %define listen [__imp__listen@8]
  %define closesocket [__imp__closesocket@4]
  %define getaddrinfo [__imp__getaddrinfo@16]
  %define freeaddrinfo [__imp__freeaddrinfo@4]

  AI_PASSIVE  equ 0x00000001
  AF_INET     equ          2
  PF_INET     equ    AF_INET
  SOCK_STREAM equ          1
  IPPROTO_TCP equ          6

  WSADATA.size equ 400

  ;; struct addrinfo offsets
  ai.ai_flags equ 00
  ai.ai_family equ 04
  ai.ai_socktype equ 08
  ai.ai_protocol equ 12
  ai.ai_addrlen equ 16
  ai.ai_canonname equ 20
  ai.ai_addr equ 24
  ai.ai_next equ 28
  ai.size equ 32

  fd.fd_count equ 00
  fd.fd_array equ 04
  fd.size equ 68
%else
  extern net_startup
  extern net_step
  extern net_cleanup
%endif
