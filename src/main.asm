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
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; EQU 等值段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ico
ICO_GAME	equ	1000

; Bitmap
HOME_PAGE	equ 100
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.data?
hInstance	dd		?
hWinMain	dd		?

.data
_page 		dword	100

.const
szClassName		db	'MUG GAME', 0
szCaptionMain	db	'MUG', 0
szText			db	'TODO', 0
WINDOW_HEIGHT 	dword 750
WINDOW_WIDTH  	dword 1334
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 函数声明
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 画自定义背景
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_DrawCustomizedBackground	proc _hDC
		local @hDcBack
		; DC for background 
		invoke	CreateCompatibleDC, _hDC; 
		mov		@hDcBack, eax
		.if	_page == HOME_PAGE
			invoke LoadBitmap, hInstance, HOME_PAGE
			invoke	SelectObject, @hDcBack, eax
;		.elseif _page == PLAY_PAGE
;			invoke	SelectObject, @hDcBack, _bg2
		.endif
		invoke	BitBlt, _hDC, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, @hDcBack, 0, 0, SRCCOPY
		ret
_DrawCustomizedBackground	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _Onpaint
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_OnPaint	proc	_hWnd,_hDC
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
		popad
		ret
_OnPaint endp
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
		.elseif	eax ==	WM_CLOSE
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
		invoke LoadCursor, 0, ICO_GAME
		mov @stWndClass.hIcon, eax
		mov @stWndClass.hIconSm, eax
		invoke	RegisterClassEx, addr @stWndClass
;********************************************************************
; 建立并显示窗口
;********************************************************************
		invoke	CreateWindowEx, WS_EX_CLIENTEDGE, offset szClassName, offset szCaptionMain,\
			WS_OVERLAPPEDWINDOW,\
			100, 100, 640, 480,\
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
start:
		call	_WinMain
		invoke	ExitProcess, NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end	start
