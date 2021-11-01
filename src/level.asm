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
include     gdi32.inc
includelib  gdi32.lib
include     winmm.inc
includelib  winmm.lib
includelib  msvcrt.lib

include level.inc
include audio.inc

printf proto C, :ptr sbyte, :vararg
memcpy proto C, :ptr sbyte, :ptr sbyte, :dword
strlen proto C, :ptr sbyte

.data
levelPathBuf db 256 dup(0)

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; .const
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.const
levelFolder db ".\levels\"
levelSuffix db ".level", 0
imageLoadError db "Failed to load image %s; error code is %lu", 0ah, 0dh, 0
levelLoadErr db "Failed to load level %s; error code is %lu", 0ah, 0dh, 0

.code
ImageFromFile proc filePath: ptr sbyte
    invoke LoadImage, NULL, filePath, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
    .if eax == NULL
        invoke GetLastError
        invoke printf, offset imageLoadError, filePath, eax
        mov eax, NULL
    .endif
    ret
ImageFromFile endp

LevelLoad proc levelName: ptr sbyte, pLevel: ptr Level, pResources: ptr LevelResources
    local @hFile
    invoke memcpy, offset levelPathBuf, offset levelFolder, lengthof levelFolder
    invoke strlen, levelName
    mov edi, offset levelPathBuf + lengthof levelFolder
    add edi, eax
    push edi
    invoke memcpy, offset levelPathBuf + lengthof levelFolder, levelName, eax
    pop edi
    invoke memcpy, edi, offset levelSuffix, lengthof levelSuffix
    invoke CreateFile, offset levelPathBuf, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL
    .if eax == INVALID_HANDLE_VALUE
        invoke GetLastError
        invoke printf, offset levelLoadErr, offset levelPathBuf, eax
        ret
    .endif
    mov @hFile, eax
    invoke ReadFile, @hFile, pLevel, type Level, NULL, NULL
    invoke CloseHandle, @hFile

    mov esi, pLevel
    invoke AudioOpen, addr (Level ptr [esi]).musicPath
    mov edi, pResources
    mov (LevelResources ptr [edi]).musicDeviceID, eax
    mov esi, pLevel
    invoke ImageFromFile, addr (Level ptr [esi]).imagePath
    mov edi, pResources
    mov (LevelResources ptr [edi]).image, eax
    mov esi, pLevel
    invoke ImageFromFile, addr (Level ptr [esi]).playImagePath
    mov edi, pResources
    mov (LevelResources ptr [edi]).playImage, eax
    ret
LevelLoad endp

LevelDestroy proc pResources: ptr LevelResources
    mov esi, pResources
    invoke DeleteObject, (LevelResources ptr [esi]).playImage
    mov esi, pResources
    invoke DeleteObject, (LevelResources ptr [esi]).image
    mov esi, pResources
    invoke AudioClose, (LevelResources ptr [esi]).musicDeviceID
LevelDestroy endp

end
