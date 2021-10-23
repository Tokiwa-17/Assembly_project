.386
.model flat,stdcall
option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
include		utils.inc
include     level.inc
include     windows.inc 
include     user32.inc 
includelib  user32.lib 
include     kernel32.inc 
includelib  kernel32.lib 
include     comdlg32.inc 
includelib  comdlg32.lib 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
; data
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
.data?
hWinMain        dd      ?
.data
Cyaegha         db      "levels\Cyaegha.level", 0
szErrOpenFile   db      "无法打开源文件!",0 
level_Cyaegha   Level   <> 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
; code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> 
.code
_readFile           proc
    local       @File
    invoke CreateFile, offset Cyaegha, GENERIC_READ, FILE_SHARE_READ, 0, \ 
            OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0 
    .if eax == INVALID_HANDLE_VALUE 
        invoke MessageBox, hWinMain, addr szErrOpenFile,\ 
        NULL,MB_OK or MB_ICONEXCLAMATION 
        ret 
    .endif
    mov @File, eax
    ret
_readFile           endp
end