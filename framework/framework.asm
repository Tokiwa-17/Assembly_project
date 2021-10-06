.386
.model flat, stdcall
option casemap: none

include windows.inc
include kernel32.inc
include user32.inc
include gdi32.inc

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
; timer
timerFrequency dword ?
timerFPS dword 60
timerFrameDelta dword ?
timerLastFrame qword ?

.code

WindowInitialize proc
	invoke GetModuleHandle, NULL
	mov hInstance, eax
	invoke LoadIcon, NULL, IDI_APPLICATION
	push eax
	invoke LoadCursor, NULL, IDC_ARROW
	pop ebx
	; WNDCLASSEX wc
	sub esp, type WNDCLASSEX
	mov dword ptr [esp], type WNDCLASSEX; wc.cbSize
	mov dword ptr [esp + 4], 0
	mov dword ptr [esp + 8], offset WindowProc
	mov	dword ptr [esp + 12], 0
	mov	dword ptr [esp + 16], 0
	mov ecx, hInstance
	mov	dword ptr [esp + 20], ecx
	mov	dword ptr [esp + 24], ebx; hIcon
	mov	dword ptr [esp + 28], eax; hCursor
	mov	dword ptr [esp + 32], NULL
	mov	dword ptr [esp + 36], NULL
	mov	dword ptr [esp + 40], offset wClassName
	mov	dword ptr [esp + 44], ebx; hIconSm
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
	push SW_SHOW
	push eax
	call ShowWindow
	mov eax, hWnd
	push eax
	call UpdateWindow
	ret
WindowInitialize endp

WindowFinalize proc
	invoke DestroyWindow, hWnd
	ret
WindowFinalize endp

TimerInitialize proc
	sub esp, 8
	push esp
	call QueryPerformanceFrequency
	mov eax, [esp]
	mov edx, 0
	mov timerFrequency, eax
	div timerFPS
	mov timerFrameDelta, eax
	push offset timerLastFrame
	call QueryPerformanceCounter
	add esp, 8
	ret
TimerInitialize endp

TimerNextFrame proc; return BOOL
	sub esp, 8
	push esp
	call QueryPerformanceCounter
	mov eax, [esp]
	mov ebx, [esp + 4]
	add esp, 8
	mov ecx, dword ptr [timerLastFrame]
	mov edx, dword ptr [timerLastFrame + 4]
	sub eax, ecx
	sbb ebx, edx
	.if (ebx > 0) || (eax >= timerFrameDelta)
		add ecx, timerFrameDelta
		adc edx, 0
		mov dword ptr [timerLastFrame], ecx
		mov dword ptr [timerLastFrame + 4], edx
		mov eax, 1; return TRUE
	.else
		xor eax, eax; return FALSE
	.endif
	ret
TimerNextFrame endp

GameInitialize proto
GameFinalize proto
GameRender proto, :dword
GameUpdate proto

WinMain proc
	call WindowInitialize
	call GameInitialize
	call TimerInitialize
	; MSG msg
	sub esp, type MSG
WinMain_Loop:
	; Rendering with fixed frame rate
	call TimerNextFrame
	test eax, eax
	jz WinMain_Loop_MSGLoop
	mov eax, hWnd
	push eax
	call GetDC
	push eax; ReleaseDC
	push eax
	call GameRender
	mov eax, hWnd
	push eax
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

;;;;;;;;; implementation ;;;;;;;;;

.data
; Game data

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
	; TODO: Process messages
	; Default handler
	.else
		invoke DefWindowProc, _hWnd, uMsg, wParam, lParam
		ret
	.endif
	mov eax, 0
	ret
WindowProc endp

GameInitialize proc
	; TODO
	ret
GameInitialize endp

GameFinalize proc
	; TODO
	ret
GameFinalize endp

GameRender proc hDC: dword
	; TODO
	ret
GameRender endp

GameUpdate proc
	; TODO
	ret
GameUpdate endp

end WinMain
