global net_init
global net_step
global net_cleanup

align 4

;;;; WinAPI
extern GetStdHandle
extern WriteConsoleA
extern ExitProcess
extern HeapAlloc
extern HeapFree

;;;; Winsock
extern WSAStartup
extern WSACleanup
extern socket
extern listen
extern connect
extern bind
extern select
extern closesocket
extern getaddrinfo
extern freeaddrinfo

;;  struct net --- [
;;    int sock;              -  4 bytes (range 00-03)
;;    int playernum;         -  4 bytes (range 04-07)
;;    struct world *world;   -  4 bytes (range 08-11)
;;    struct config *config; -  4 bytes (range 12-15)
;;    struct players *plist; -  4 bytes (range 16-19)
;;  --- ]                    - 20 bytes (range 00-19)

net.sock equ 0
net.playernum equ 4
srv.world equ 8
srv.config equ 12
srv.plist equ 16
srv.size equ 20

WSADATA.size equ 400

section .text

  net_init:
    push ebp
    mov ebp, esp
    call net_ws_init
    mov esp, ebp
    pop ebp
    ret

  net_step:
    xor eax, eax
    ret

  net_cleanup:
    xor eax, eax
    ret

  net_ws_init:
    push ebp
    mov ebp, esp
    sub esp, WSADATA.size

    lea eax, [ebp-WSADATA.size]
    push eax
    push 0202h
    call WSAStartup

    mov esp, ebp
    pop ebp
    ret

  net_beat:
    xor eax, eax
    ret
