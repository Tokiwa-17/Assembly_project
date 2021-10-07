.386
.model flat, stdcall
option casemap: none

include windows.inc
include kernel32.inc
include user32.inc
include gdi32.inc

include window.inc
include timer.inc
include game.inc

includelib kernel32.lib
includelib user32.lib
includelib gdi32.lib

.data
; window
hInstance dword ?
wClassName db "MUGWindow", 0
wName db "MUG", 0
hWnd dword ?
wWidth dword 960
wHeight dword 540

.code

WindowProc proc _hWnd:dword, uMsg: dword, wParam: dword, lParam: dword
	mov eax, uMsg
	.if eax == WM_CLOSE
		push 0
		call PostQuitMessage
	.elseif eax == WM_SIZE
		mov eax, lParam
		movzx edx, ax
		shr eax, 16
		mov wWidth, edx
		mov wHeight, eax
	.else
		invoke GameWindowProc, _hWnd, uMsg, wParam, lParam
		invoke DefWindowProc, _hWnd, uMsg, wParam, lParam
		ret
	.endif
	mov eax, 0
	ret
WindowProc endp

WindowInitialize proc
	push NULL
	call GetModuleHandle
	mov hInstance, eax
	push IDI_GAME
	push eax
	call LoadIcon
	; WNDCLASSEX wc
	sub esp, type WNDCLASSEX
	mov ecx, hInstance
	mov dword ptr [esp], type WNDCLASSEX; wc.cbSize
	mov dword ptr [esp + 4], 0
	mov dword ptr [esp + 8], offset WindowProc
	mov	dword ptr [esp + 12], 0
	mov	dword ptr [esp + 16], 0
	mov	dword ptr [esp + 20], ecx; hInstance
	mov	dword ptr [esp + 24], eax; hIcon
	mov	dword ptr [esp + 28], NULL
	mov	dword ptr [esp + 32], NULL
	mov	dword ptr [esp + 36], NULL
	mov	dword ptr [esp + 40], offset wClassName
	mov	dword ptr [esp + 44], NULL
	push esp
	call RegisterClassEx
	add esp, type WNDCLASSEX
	invoke CreateWindowEx,
		0, offset wClassName, offset wName, WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT, CW_USEDEFAULT, wWidth, wHeight,
		NULL, NULL, hInstance, NULL
	.if eax == NULL
		call GetLastError
		push eax
		call ExitProcess
	.endif
	mov hWnd, eax
	invoke ShowWindow, hWnd, SW_SHOW
	ret
WindowInitialize endp

WindowFinalize proc
	mov eax, hWnd
	push eax
	call DestroyWindow
	ret
WindowFinalize endp

WinMain proc
	call WindowInitialize
	call GameInitialize
	call TimeInitialize
	; MSG msg
	sub esp, type MSG
WinMain_Loop:
	; Rendering with fixed frame rate
	call TimeNextFrame
	test eax, eax
	jz WinMain_Loop_MSGLoop
	mov eax, hWnd
	push eax
	call GetDC
	mov edx, hWnd
	push eax; ReleaseDC
	push edx; ReleaseDC
	push eax
	push edx
	call GameRender
	call ReleaseDC
WinMain_Loop_MSGLoop:
	mov eax, esp
	invoke PeekMessage, eax, NULL, 0, 0, PM_REMOVE
	test eax, eax; while (PeekMessage(...))
	jz WinMain_Loop_Update
	cmp dword ptr [esp + 4], WM_QUIT; if (msg.message == WM_QUIT)
	jne WinMain_Loop_MSGLoopMain
	mov eax, dword ptr [esp + 8]; exit code
	jmp WinMain_Exit
WinMain_Loop_MSGLoopMain:
	push esp
	call TranslateMessage
	push esp
	call DispatchMessage
	jmp WinMain_Loop_MSGLoop
WinMain_Loop_Update:
	call GameUpdate
	jmp WinMain_Loop
WinMain_Exit:
	add esp, type MSG
	push eax; exit code
	call GameFinalize
	call WindowFinalize
	call ExitProcess
WinMain endp

end WinMain
