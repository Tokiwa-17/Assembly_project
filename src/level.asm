.386
.model flat,stdcall
option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
include     windows.inc 
include     user32.inc 
includelib  user32.lib 
include     kernel32.inc 
includelib  kernel32.lib 
includelib  msvcrt.lib

include level.inc

printf proto C, :ptr sbyte, :vararg

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; .const
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.const
levelLoadErr db "Failed to load level %s; error code is %lu", 0ah, 0dh, 0

.code
LevelLoad proc opernNamePtr: ptr sbyte, opernInstancePtr: ptr Level
    local @hFile
    invoke CreateFile, opernNamePtr, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    .if eax == INVALID_HANDLE_VALUE
        invoke GetLastError
        invoke printf, offset levelLoadErr, opernNamePtr, eax
        ret
    .endif
    mov @hFile, eax
    invoke ReadFile, @hFile, opernInstancePtr, type Level, NULL, NULL
    ret
LevelLoad endp

end
