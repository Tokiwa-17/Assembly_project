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
include     comdlg32.inc 
includelib  comdlg32.lib 

extern hInstance: dd, hMainWin: dd
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; .const
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.const
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; .data
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.data
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

.code
LevelLoad proc    uses esi ebx ecx, opernNamePtr: ptr sbyte, opernInstancePtr: ptr Level
    local       @fileHandle
    local       @levelSize
    local       @levelNoteSize
    local       @lpNumberOfBytesRead
    local       @levelNoteLength1
    local       @levelNoteLength2
    local       @levelNoteLength3
    local       @levelNoteLength4
    local       @levelNoteArrayLength
    mov @levelSize,             sizeof Level
    mov @levelNoteSize,         sizeof LevelNote
    mov eax,                    sizeof LevelNote
    mov ebx, MAX_NOTE_LENGTH
    mul ebx
    mov @levelNoteArrayLength,  eax 
    invoke CreateFile, opernNamePtr, GENERIC_READ, FILE_SHARE_READ, 0, \ 
            OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0 
    .if eax == INVALID_HANDLE_VALUE 
        invoke MessageBox, hMainWin, addr szErrOpenFile,\ 
        NULL,MB_OK or MB_ICONEXCLAMATION 
        ret 
    .endif
    mov @fileHandle, eax
    ;@@@@@@@@@@@@@@@@@@@@@ 读入Level结构体 @@@@@@@@@@@@@@@@@@@@@
    invoke ReadFile, @fileHandle, opernInstancePtr,  @levelSize, addr @lpNumberOfBytesRead, 0
    ;@@@@@@@@@@@@@@@@@@@@@ 读入音轨长度    @@@@@@@@@@@@@@@@@@@@@
    mov esi, opernInstancePtr
    add esi, @levelSize
    sub esi, 32
    mov eax, [esi]

    mov @levelNoteLength1, eax
    add esi, 4

    mov eax, [esi]
    mov @levelNoteLength2, eax
    add esi, 4

    mov eax, [esi]
    mov @levelNoteLength3, eax
    add esi, 4

    mov eax, [esi]
    mov @levelNoteLength4, eax

    ;@@@@@@@@@@@@@@@@@@@@@ 读入音轨LevelNote数组    @@@@@@@@@@@@@@@@@@@@@
    mov esi, @levelSize
    mov eax, @levelNoteLength1
    mul @levelNoteSize
    mov ebx, eax
    add esi, opernInstancePtr
    invoke ReadFile, @fileHandle, esi,  ebx, addr @lpNumberOfBytesRead, 0  
    add esi, @levelNoteArrayLength
    mov eax, @levelNoteLength2
    mul @levelNoteSize
    mov ebx, eax
    invoke ReadFile, @fileHandle, esi, ebx, addr @lpNumberOfBytesRead, 0
    add esi, @levelNoteArrayLength
    mov eax, @levelNoteLength3
    mul @levelNoteSize
    mov ebx, eax
    invoke ReadFile, @fileHandle, esi, ebx, addr @lpNumberOfBytesRead, 0
    add esi, @levelNoteArrayLength
    mov eax, @levelNoteLength4
    mul @levelNoteSize
    mov ebx, eax
    invoke ReadFile, @fileHandle, esi, ebx, addr @lpNumberOfBytesRead, 0
    ret
LevelLoad endp

end
