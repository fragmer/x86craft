;; warning!
;; all of the functions below follows the stdcall calling convention.
;; this means that eax, ecx and edx may or may not change.
;; ebx, edi and esi will contain their original value upon return.
;; return values are mainly stored in eax.
;; secondary return values, if any, are stored accordingly.
;; if the usage of eax, ecx or edx is not documented...
;; ...save them if they're of any importance!

;;  struct file --- [
;;    [dword handle] - 4 bytes (range 00-03)
;;    [dword status] - 4 bytes (range 04-07)
;;  --- ]            - 8 bytes (range 00-07)

;; struct file offsets
file.handle equ 00
file.status equ 04
file.size   equ 08

;; file status codes
;; these will be found in file.status and in some cases in ecx
F_NO_DETAILS         equ 0
F_OPEN_CREATED       equ 1
F_OPEN_INVALID       equ 2
F_OPEN_FLAGS_INVALID equ 3
F_OPEN_UNKNOWN_ERROR equ 4
F_READ_EOF           equ 1
F_READ_BUFFER_FULL   equ 2

;; return values
F_OPEN_ERROR    equ  0
F_CLOSE_ERROR   equ  1
F_READ_ERROR    equ -1
F_WRITE_ERROR   equ -1

;; file_open access flags
FILE_READ      equ               0x80000000
FILE_WRITE     equ               0x40000000
FILE_READWRITE equ (FILE_READ | FILE_WRITE)

%ifndef _FILE_ASM
  extern file_open
%endif
;; file *file_open(byte *fn, dword a_flags);
;; returns a pointer to an open file.

;; FILE_READ
;; opens a file for reading. if the file does not exist, the function fails.
;; FILE_WRITE
;; opens a file for writing. if the file does not exist, it is created. otherwise it is overwritten.
;; FILE_READWRITE
;; opens a file for both reading and writing. if the file does not exist, it is created.

;; eax will contain a pointer to the newly created or opened file.
;; if file_open fails with opening or creating a file, eax will hold F_OPEN_ERROR (0).
;; ecx may or may not contain one of the values from the file status table.

%ifndef _FILE_ASM
  extern file_close
%endif
;; dword file_close(file *file);
;; closes an open file.

;; if file_close fails to close the stream, it will return F_CLOSE_ERROR (1).
;; otherwise zero is returned.

%ifndef _FILE_ASM
  extern file_getchar
%endif
;; dword file_getchar(file *file);
;; will read a character (byte) from 'file'.

;; returns the read character on success or F_READ_ERROR (-1) on error.
;; further information on the error may or may not be found in file.status.
;; if file* is NULL, ecx may act as a replacement for file.status.

%ifndef _FILE_ASM
  extern file_getline
%endif
;; dword file_getline(byte *dst, dword n, file *file);
;; will read from file to dst until newline is found or n is reached.
;; dst will be null-terminated unless n was reached.

;; on success, file_getline returns the number of bytes read.
;; on error, file_getlin returns F_READ_ERROR (-1) and the number of bytes read is found in ecx.
;; further information on the error may or may not be found in file.status.
;; if file* is NULL, ecx may act as a replacement for file.status.

%ifndef _FILE_ASM
;;  extern file_putchar
%endif

%ifndef _FILE_ASM
;;  extern file_putline
%endif

%ifndef _FILE_ASM
;;  extern file_read
%endif
;; dword file_read(byte *dst, dword n, file *file);
;; will read n characters into dst.

;; on success, file_read returns the number of bytes read.
;; on error, file_read returns F_READ_ERROR (-1), and the number of bytes read is found in ecx.
;; further information on the error may or may not be found in file.status.
;; if file* is NULL, ecx may act as a replacement for file.status.

%ifndef _FILE_ASM
  extern file_write
%endif
;; dword file_write(byte *buf, dword n, file *file);
;; will write n characters to file

;; on success, file_writes returns the number of bytes written.
;; on error, file_write returns F_WRITE_ERROR (-1), and the number of bytes written is found in ecx.
;; further information on the error may or may not be found in file.status.
;; if file* is NULL, ecx may act as a replacement for file.status.

%ifndef
;;  extern file_seek
%endif
;; dword file_write(dword offset, dword n, file *file);
;; more information to come...

%ifdef _FILE_ASM
  global    file_open
  global   file_close
  global file_getchar
  global file_getline
  global file_putchar
  global file_putline
  global    file_read
  global   file_write
  global    file_seek

  extern    __imp__CreateFileA@28
  extern       __imp__ReadFile@20
  extern      __imp__WriteFile@20
  extern __imp__SetFilePointer@16
  extern      __imp__HeapAlloc@12
  extern       __imp__HeapFree@12
  extern     __imp__CloseHandle@4
  extern  __imp__GetProcessHeap@0
  extern    __imp__GetLastError@0

  %define    CreateFileA    [__imp__CreateFileA@28]
  %define       ReadFile       [__imp__ReadFile@20]
  %define      WriteFile      [__imp__WriteFile@20]
  %define SetFilePointer [__imp__SetFilePointer@16]
  %define      HeapAlloc      [__imp__HeapAlloc@12]
  %define       HeapFree       [__imp__HeapFree@12]
  %define    CloseHandle     [__imp__CloseHandle@4]
  %define GetProcessHeap  [__imp__GetProcessHeap@0]
  %define   GetLastError    [__imp__GetLastError@0]

  NULL                  equ                              0
  FILE_ATTRIBUTE_NORMAL equ                     0x00000080
  OPEN_EXISTING         equ                              3
  CREATE_ALWAYS         equ                              2
  OPEN_ALWAYS           equ                              4
  ERROR_FILE_NOT_FOUND  equ                              2
  ERROR_ALREADY_EXISTS  equ                            183
  GENERIC_READ          equ                     0x80000000
  GENERIC_WRITE         equ                     0x40000000
  GENERIC_READWRITE     equ (GENERIC_READ | GENERIC_WRITE)
  INVALID_HANDLE_VALUE  equ                             -1
  ERROR_HANDLE_EOF      equ                             38
  FILE_BEGIN            equ                              0
  FILE_CURRENT          equ                              1
  FILE_END              equ                              2
%endif
