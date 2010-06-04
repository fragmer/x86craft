%ifdef _NET_
  global net_startup
  global net_step
  global net_cleanup

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
  %define freeaddrinf [__imp__freeaddrinfo@4]

%endif
