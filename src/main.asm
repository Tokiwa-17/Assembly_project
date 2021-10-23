;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 使用 ./nmake 或下列命令进行编译和链接:
; ml /c /coff main.asm
; Link /subsystem:windows main.obj
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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

include		utils.inc
include		resource.inc
include 	level.inc
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; EQU 等值段
WINDOW_HEIGHT 			equ 	960
WINDOW_WIDTH  			equ		1280
ID_TIMER				equ		1
TIMER_MAIN_INTERVAL		equ		100
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ico
ICO_GAME		equ		1000

; Bitmap
INIT_PAGE		equ		100
SELECT_PAGE 	equ		101
PLAY_PAGE		equ		102
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.data?
hInstance	dd		?
hWinMain	dd		?

.data
_page 		dword		100
keys		KeyState	<>

.const
szClassName		db	'MUG GAME', 0
szCaptionMain	db	'MUG', 0
Cyaegha         db  "levels\Cyaegha.level", 0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 函数声明
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_InitGame						PROTO,		_hWnd:dword
_DrawCustomizedBackground		PROTO,		_hDC:dword
_OnPaint						PROTO,		_hWnd:dword, _hDC:dword
_ProcessTimer					PROTO, 		hWnd:dword, wParam:dword
_ComputeGameLogic				PROTO,		_hWnd:dword
_UpdateKeyState					PROTO,		_wParam:dword, _keyDown:dword
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 窗口过程
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcWinMain	proc	uses ebx edi esi, hWnd, uMsg, wParam, lParam
		local	@stPs:PAINTSTRUCT
		local	@stRect:RECT
		local	@hDc

		mov	eax,uMsg
;********************************************************************
		.if	eax ==	WM_PAINT
			invoke	BeginPaint, hWnd, addr @stPs
			mov	@hDc, eax
			invoke _OnPaint, hWnd, @hDc 
			invoke	EndPaint, hWnd, addr @stPs
;********************************************************************
;		sent when a window be created by calling the CreateWindowEx 
;		or CreateWindow function.
		.elseif eax == WM_CREATE
			invoke _InitGame, hWnd
;********************************************************************
		.elseif eax == WM_KEYDOWN
			invoke	_UpdateKeyState, wParam, 1
;********************************************************************
		.elseif eax == WM_KEYUP
			invoke	_UpdateKeyState, wParam, 0
;********************************************************************
		.elseif eax == WM_TIMER
			invoke _ProcessTimer, hWnd, wParam
;********************************************************************
		.elseif	eax ==	WM_CLOSE
			invoke	KillTimer, hWnd, ID_TIMER
			invoke	DestroyWindow, hWinMain
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
		mov	hWinMain, eax
		invoke	ShowWindow, hWinMain, SW_SHOWNORMAL
		invoke	UpdateWindow, hWinMain
;********************************************************************
; 消息循环
;********************************************************************
		.while	TRUE
			invoke	GetMessage, addr @stMsg, NULL, 0, 0
			.break	.if eax	== 0
			invoke	TranslateMessage, addr @stMsg
			invoke	DispatchMessage, addr @stMsg
		.endw
		ret

_WinMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_InitGame	proc	_hWnd
;		Set Timer
		invoke	SetTimer, _hWnd, ID_TIMER, TIMER_MAIN_INTERVAL, NULL

;		Load Bitmap
		invoke	LoadBitmap, hInstance, INIT_PAGE
		mov		_bg1, 	eax
		invoke	LoadBitmap, hInstance, SELECT_PAGE
		mov		_bg2, 	eax
		invoke	LoadBitmap, hInstance, PLAY_PAGE
		mov		_bg3, 	eax
		ret

_InitGame	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 画自定义背景
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_DrawCustomizedBackground	proc _hDC
		local @hDcBack
		local @hOldObject
		; DC for background 
		invoke	CreateCompatibleDC, _hDC; 
		mov		@hDcBack, eax
		.if	_page == INIT_PAGE
			invoke	SelectObject, @hDcBack, _bg1
		
		.elseif _page == SELECT_PAGE
			invoke	LoadBitmap, hInstance, SELECT_PAGE
			invoke	SelectObject, @hDcBack, _bg2

		.elseif _page == PLAY_PAGE
			invoke	LoadBitmap, hInstance, PLAY_PAGE
			invoke	SelectObject, @hDcBack, _bg3

		.endif
		invoke	BitBlt, _hDC, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, @hDcBack, 0, 0, SRCCOPY
;		invoke StretchBlt, _hDC, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT,\
;			@hDcBack, 0, 0, HOME_PAGE_WIDTH, HOME_PAGE_HEIGHT, SRCCOPY
		invoke SelectObject, @hDcBack, @hOldObject
		invoke DeleteDC, @hDcBack
		ret
_DrawCustomizedBackground	endp
;********************************************************************
_OnPaint	proc	_hWnd, _hDC
		local	@stTime:SYSTEMTIME, @bufferDC; bufferDC is cache for pictures.
		local	@bufferBmp
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
;********************************************************************
; 画自定义背景
;********************************************************************
		invoke _DrawCustomizedBackground, @bufferDC
;		画游戏相关内容


		invoke	BitBlt, _hDC, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, @bufferDC, 0, 0, SRCCOPY
		invoke	GetStockObject,NULL_PEN
		invoke	SelectObject,@bufferDC,eax
		invoke	DeleteObject,eax
		invoke	DeleteObject,@bufferBmp
		invoke	DeleteObject,@bufferDC
;		invoke StretchBlt, _hDC, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT,\
;			@bufferDC, 0, 0, HOME_PAGE_WIDTH, HOME_PAGE_HEIGHT, SRCCOPY
		popad
		ret
_OnPaint endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcessTimer	proc	_hWnd, timerId
		.if timerId == ID_TIMER
			invoke	_ComputeGameLogic, _hWnd
			invoke	InvalidateRect, _hWnd, NULL, FALSE
		.else
			ret
		.endif
		ret
_ProcessTimer	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ComputeGameLogic	proc  _hWnd
	local	@i
	pushad
	;@@@@@@@@@@@@@@@@@@@@@ 主页 @@@@@@@@@@@@@@@@@@@@@
	.if _page == INIT_PAGE
		.if keys.key_return
			mov _page, SELECT_PAGE
			mov keys.key_return, 0
		.endif
	;@@@@@@@@@@@@@@@@@@@@@ 选歌 @@@@@@@@@@@@@@@@@@@@@
	.elseif _page == SELECT_PAGE
		.if keys.key_return
			mov _page, PLAY_PAGE
			mov keys.key_return, 0
		.elseif keys.key_d
			mov eax, offset cyaephaOpern
			invoke _readFile,  offset Cyaegha, offset cyaephaOpern
			mov keys.key_d, 0
		.endif

	.endif

	popad
	ret
_ComputeGameLogic	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_UpdateKeyState proc _wParam, _keyDown
		local @timenow
		;判断按键按下的状态
		.if _keyDown != 0
			invoke GetTickCount
			mov	@timenow, eax
		.else
			mov @timenow, 0
		.endif
		mov eax, @timenow
		.if		_wParam == VK_D
			mov keys.key_d, eax
		.elseif _wParam == VK_F
			mov keys.key_f, eax
		.elseif _wParam == VK_J
			mov keys.key_j, eax
		.elseif _wParam == VK_K
			mov keys.key_k, eax
		.elseif _wParam == VK_RETURN
			mov keys.key_return, eax
		.endif
		ret
_UpdateKeyState endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
		call	_WinMain
		invoke	ExitProcess, NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end	start
