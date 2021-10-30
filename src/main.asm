.386
.model flat,stdcall
option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		windows.inc
include		gdi32.inc
includelib	gdi32.lib
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib
include 	winmm.inc
includelib	winmm.lib

include 	level.inc
include		game.inc
include		config.inc
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
public hInstance, hMainWin
.data?
hInstance	dword		?
hMainWin	dword		?
.data
rotateDistance  sword		 0
mousewheelwParam  sdword       0
.const
szClassName		db	'MUG GAME', 0
szCaptionMain	db	'MUG', 0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 函数声明
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_OnPaint						PROTO,		_hWnd:dword, _hDC:dword
_ProcessTimer					PROTO, 		hWnd:dword, wParam:dword
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 窗口过程
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcWinMain	proc	uses ebx edi esi, hWnd, uMsg, wParam, lParam
		local	@stPs:PAINTSTRUCT
		local	@stRect:RECT
		local	@hDc
		local	@key:byte, @down:byte, @previousDown:byte

		mov	eax,uMsg
;********************************************************************
		.if	eax ==	WM_PAINT
			invoke	BeginPaint, hWnd, addr @stPs
			mov		@hDc, eax
			invoke 	_OnPaint, hWnd, @hDc
			invoke	EndPaint, hWnd, addr @stPs
;********************************************************************
;		sent when a window be created by calling the CreateWindowEx 
;		or CreateWindow function.
		.elseif eax == WM_CREATE
			invoke GameInit
			;Set Timer
			invoke	SetTimer, hWnd, ID_TIMER, TIMER_MAIN_INTERVAL, NULL
;********************************************************************

		.elseif eax == WM_KEYDOWN
			mov eax, wParam
			mov @key, al
			mov @down, 1
			mov eax, lParam
			shr eax, 16; HIWORD(lParam)
			mov @previousDown, 0
			test ax, KF_REPEAT
			jz PreviousDownFlag
			mov @previousDown, 1
PreviousDownFlag:
			invoke GameKeyCallback, @key, @down, @previousDown
;********************************************************************
		.elseif eax == WM_KEYUP
			mov eax, wParam
			mov @key, al
			mov @down, 0
			mov @previousDown, 1
			invoke GameKeyCallback, @key, @down, @previousDown
;********************************************************************
		.elseif eax == WM_TIMER
			invoke _ProcessTimer, hWnd, wParam
;********************************************************************
		.elseif eax == WM_MOUSEWHEEL
			;.if globalCurrentPage == SELECT_PAGE
			mov eax, wParam
			mov mousewheelwParam, eax
			mov esi, offset mousewheelwParam
			add esi, 2
			mov ax,  word ptr [esi]
			mov rotateDistance, ax
			invoke changeQueue, rotateDistance  
;********************************************************************
		.elseif	eax ==	WM_CLOSE
			invoke	KillTimer, hWnd, ID_TIMER
			invoke	PostQuitMessage, NULL
;********************************************************************
		.else
			invoke	DefWindowProc, hWnd, uMsg, wParam, lParam
			ret
		.endif
;********************************************************************
		xor	eax, eax
		ret

_ProcWinMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WinMain	proc
		local	@stWndClass:WNDCLASSEX
		local	@stMsg:MSG

		invoke	GetModuleHandle, NULL
		mov	hInstance, eax
		invoke	RtlZeroMemory, addr @stWndClass, sizeof @stWndClass
;********************************************************************
; 注册窗口类
;********************************************************************
		invoke	LoadCursor, 0, IDC_ARROW
		mov	@stWndClass.hCursor, eax
		push	hInstance
		pop	@stWndClass.hInstance
		mov	@stWndClass.cbSize, sizeof WNDCLASSEX
		mov	@stWndClass.style, CS_HREDRAW or CS_VREDRAW
		mov	@stWndClass.lpfnWndProc, offset _ProcWinMain
		mov	@stWndClass.hbrBackground, COLOR_WINDOW + 1
		mov	@stWndClass.lpszClassName, offset szClassName
;		加载图标句柄
		invoke LoadIcon, hInstance, ICO_GAME
		mov @stWndClass.hIcon, eax
		mov @stWndClass.hIconSm, eax
		invoke	RegisterClassEx, addr @stWndClass
;********************************************************************
; 建立并显示窗口
;********************************************************************
		invoke	CreateWindowEx, WS_EX_CLIENTEDGE, offset szClassName, offset szCaptionMain,\
			WS_OVERLAPPEDWINDOW,\
			0, 0, WINDOW_WIDTH, WINDOW_HEIGHT,\
			NULL, NULL, hInstance, NULL
		mov	hMainWin, eax
		invoke	ShowWindow, hMainWin, SW_SHOWNORMAL
		invoke	UpdateWindow, hMainWin
;********************************************************************
; 消息循环
;********************************************************************
		.while	TRUE
			invoke	GetMessage, addr @stMsg, NULL, 0, 0
			.break	.if eax	== 0
			invoke	TranslateMessage, addr @stMsg
			invoke	DispatchMessage, addr @stMsg
		.endw
		invoke  GameShutdown
		invoke	DestroyWindow, hMainWin
		ret

_WinMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

;********************************************************************
_OnPaint	proc	_hWnd, _hDC
		local	@stTime:SYSTEMTIME, @bufferDC; bufferDC is cache for pictures.
		local	@bufferBmp
		local   @hOldObject
		local	@i, @j
		pushad
;		invoke	GetLocalTime,addr @stTime
;		invoke	_CalcClockParam
;********************************************************************
; 启用双缓冲绘图方式，避免界面闪烁
;********************************************************************
		invoke	CreateCompatibleDC, _hDC
		mov		@bufferDC,	eax
		invoke	CreateCompatibleBitmap, _hDC, WINDOW_WIDTH, WINDOW_HEIGHT
		mov		@bufferBmp,	eax
		invoke	SelectObject, @bufferDC, @bufferBmp
		mov		@hOldObject, eax
;********************************************************************
; 画自定义背景
;********************************************************************
		invoke GameDraw, @bufferDC
;		画游戏相关内容
		invoke	BitBlt, _hDC, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, @bufferDC, 0, 0, SRCCOPY
		invoke	SelectObject, @bufferDC, @hOldObject
		invoke	DeleteObject,@bufferBmp
		invoke	DeleteDC,@bufferDC
		;invoke StretchBlt, _hDC, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT,\
			;@bufferDC, 0, 0, HOME_PAGE_WIDTH, HOME_PAGE_HEIGHT, SRCCOPY
		popad
		ret
_OnPaint endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcessTimer	proc	_hWnd, timerId
		.if timerId == ID_TIMER
			invoke	GameUpdate
			invoke	InvalidateRect, _hWnd, NULL, FALSE
		.else
			ret
		.endif
		ret
_ProcessTimer	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
		call	_WinMain
		invoke	ExitProcess, NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end	start
