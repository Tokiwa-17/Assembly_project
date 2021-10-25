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

include		utils.inc
include		resource.inc
include 	level.inc
include		game.inc
include		config.inc
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 函数声明
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_InitGame						PROTO,		_hWnd:dword
GameDraw						PROTO,		_hDC:dword
GameKeyCallBack                 PROTO,      keyCode:byte, down:byte, previousDown:byte 
_OnPaint						PROTO,		_hWnd:dword, _hDC:dword
_ProcessTimer					PROTO, 		hWnd:dword, wParam:dword
_ComputeGameLogic				PROTO,		_hWnd:dword
_UpdateKeyState					PROTO,		_wParam:dword, _lParam:dword, _keyDown:dword
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
			invoke _InitGame, hWnd
;********************************************************************
		.elseif eax == WM_KEYDOWN
			;invoke	_UpdateKeyState, wParam, 1
			.if wParam == VK_F
				mov @key, 'F'
			.elseif wParam == VK_G
				mov @key, 'G'
			.elseif wParam == VK_H
				mov @key, 'H'
			.elseif wParam == VK_J
				mov @key, 'J'
			.endif
			mov @down, 1
			.if lParam == VK_F
				mov @previousDown, 'F'
			.elseif lParam == VK_G
				mov @previousDown, 'G'
			.elseif lParam == VK_H
				mov @previousDown, 'H'
			.elseif lParam == VK_J
				mov @previousDown, 'J'
			.endif
			invoke GameKeyCallBack, @key, @down, @previousDown
;********************************************************************
		.elseif eax == WM_KEYUP
			.if wParam == VK_F
				mov @key, 'F'
			.elseif wParam == VK_G
				mov @key, 'G'
			.elseif wParam == VK_H
				mov @key, 'H'
			.elseif wParam == VK_J
				mov @key, 'J'
			.endif
			mov @down, 0
			.if lParam == VK_F
				mov @previousDown, 'F'
			.elseif lParam == VK_G
				mov @previousDown, 'G'
			.elseif lParam == VK_H
				mov @previousDown, 'H'
			.elseif lParam == VK_J
				mov @previousDown, 'J'
			.endif
			invoke GameKeyCallBack, @key, @down, @previousDown
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
; GameDraw
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameDraw	proc _hDC
		local @hDcBack
		local @hOldObject
		; DC for background 
		invoke	CreateCompatibleDC, _hDC; 
		mov		@hDcBack, eax
		.if	globalCurrentPage == INIT_PAGE
			invoke	SelectObject, @hDcBack, _bg1
		
		.elseif globalCurrentPage == SELECT_PAGE
			;invoke	LoadBitmap, hInstance, SELECT_PAGE
			invoke	SelectObject, @hDcBack, _bg2

		.elseif globalCurrentPage == PLAY_PAGE
			;invoke	LoadBitmap, hInstance, PLAY_PAGE
			invoke	SelectObject, @hDcBack, _bg3

		.endif
		invoke	BitBlt, _hDC, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, @hDcBack, 0, 0, SRCCOPY
;		invoke StretchBlt, _hDC, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT,\
;			@hDcBack, 0, 0, HOME_PAGE_WIDTH, HOME_PAGE_HEIGHT, SRCCOPY
		invoke SelectObject, @hDcBack, @hOldObject
		invoke DeleteDC, @hDcBack
		ret
GameDraw	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameKeyCallback
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameKeyCallBack     proc       uses eax ecx esi,        keyCode:byte, down:byte, previousDown:byte
    local @index
    ;@@@@@@@@@@@@@@@@@@@@@ 主页 @@@@@@@@@@@@@@@@@@@@@
    .if globalCurrentPage == INIT_PAGE
        .if down
            mov globalCurrentPage, SELECT_PAGE
        .endif
    ;@@@@@@@@@@@@@@@@@@@@@ 选歌 @@@@@@@@@@@@@@@@@@@@@
    .elseif globalCurrentPage == SELECT_PAGE
        .if keyCode == 'F'
            mov globalCurrentPage, PLAY_PAGE
			invoke _readFile, offset Cyaegha, offset cyaephaOpern
        .endif
    ;@@@@@@@@@@@@@@@@@@@@@ Play @@@@@@@@@@@@@@@@@@@@@
    .elseif globalCurrentPage == PLAY_PAGE
        mov ecx, GAME_KEY_COUNT
L1:
        mov eax, ecx
        sub eax, 1
        mov @index, eax
        mov esi, offset globalKeyMaps
        mov eax, type byte
        mul @index
        add esi, eax
        mov al, byte ptr [esi]
        ; if (sGame.keyMaps[index] == keyCode)
        .if al == keyCode
            mov al, down
            cmp al, 0
            je  L2
        ; sGame.keyPressing[index] = True
            mov esi, offset globalKeyPressing
            mov eax, type byte
            mul @index
            add esi, eax
            mov al, 1
            mov byte ptr [esi], al
        ; if (!previousDown)
        mov al, previousDown
        cmp al, 0
        jne L3
        mov esi, offset globalKeyPressTime
        mov eax, type dword
        mul @index
        add esi, eax
        invoke timeGetTime
        sub eax, globalLevelBeginTime
        mov [esi], eax
        invoke NoteTapJudgement, @index
L2:
        mov esi, offset globalKeyPressing
        mov eax, type byte
        mul @index
        add esi, eax
        mov eax, 0
        mov byte ptr[esi], al
        invoke timeGetTime
        sub eax, globalLevelBeginTime
        invoke NoteCatchJudgement, @index, eax
L3:
        jmp L4    
        .endif
        dec ecx
        jne L1
;        loop L1
L4:
    .endif
    ret
GameKeyCallBack     endp
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
		invoke GameDraw, @bufferDC
;		invoke GameDraw, @bufferDC
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
	.if globalCurrentPage == INIT_PAGE
		.if keys.key_return
			mov globalCurrentPage, SELECT_PAGE
			mov keys.key_return, 0
		.endif
	;@@@@@@@@@@@@@@@@@@@@@ 选歌 @@@@@@@@@@@@@@@@@@@@@
	.elseif globalCurrentPage == SELECT_PAGE
		.if keys.key_return
			mov globalCurrentPage, PLAY_PAGE
			mov keys.key_return, 0
		.elseif keys.key_d
			invoke _readFile,  offset Cyaegha, offset cyaephaOpern
			mov keys.key_d, 0
		.endif

	.endif

	popad
	ret
_ComputeGameLogic	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_UpdateKeyState proc _wParam, _lParam, _keyDown
		local @timenow, @key:byte, @down:byte, @previousDown:byte
		;判断按键按下的状态
		.if _keyDown != 0
			invoke GetTickCount
			mov	@timenow, eax
		.else
			mov @timenow, 0
		.endif
		mov eax, @timenow
		.if		_wParam == VK_F
			mov @key, 'F'
		.elseif _wParam == VK_G
			mov @key, 'G'
		.elseif _wParam == VK_H
			mov @key, 'H'
		.elseif _wParam == VK_J
			mov @key, 'J'
		.endif
		
		ret
_UpdateKeyState endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
start:
		call	_WinMain
		invoke	ExitProcess, NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end	start
