ifndef __config_inc_
__config_inc_ equ <1>
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
keys		KeyState	<>

.const
szClassName		db	'MUG GAME', 0
szCaptionMain	db	'MUG', 0
Cyaegha         db  "levels\Cyaegha.level", 0



endif