.386
.model flat, stdcall
option casemap: none

include windows.inc
include kernel32.inc
include user32.inc
include gdi32.inc

include game.inc

includelib kernel32.lib
includelib user32.lib
includelib gdi32.lib

.data
clearG dword 0
clearColor dword 200020h

.code

GameInitialize proc
	; TODO
	ret
GameInitialize endp

GameFinalize proc
	; TODO
	ret
GameFinalize endp

GameWindowProc proc hWnd: dword, uMsg: dword, wParam: dword, lParam: dword
    mov eax, uMsg
    ret
GameWindowProc endp

GameRender proc hWnd: dword, hDC: dword
    sub esp, type RECT
    mov eax, hWnd
    push esp
    push eax
	call GetClientRect
    mov eax, clearColor
    push eax
    call CreateSolidBrush
    mov edx, esp; lpRect
    add esp, type RECT
    push eax; DeleteObject
    push eax; brush
    mov eax, hDC
    push edx
    push eax
    call FillRect
    call DeleteObject
    ; TODO
	ret
GameRender endp

GameUpdate proc
    mov edx, clearG
    inc edx
    mov clearG, edx
    mov ecx, 000ff000h
    and ecx, edx
    shr ecx, 12
    .if cl >= 128
        mov dl, 255
        sub dl, cl
        mov cl, dl
    .endif
    mov eax, clearColor
    shl ecx, 8
    and eax, 00ff00ffh
    or eax, ecx
    mov clearColor, eax
	ret
GameUpdate endp

end
