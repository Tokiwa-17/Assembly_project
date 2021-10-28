ifndef __config_inc_
__config_inc_ equ <1>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; EQU 等值段
WINDOW_HEIGHT 			equ 	960
WINDOW_WIDTH  			equ		1280
ID_TIMER				equ		1
TIMER_MAIN_INTERVAL		equ		16
GAME_LEVEL_WAIT_TIME     equ     1000
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ico
ICO_GAME		equ		1000

; Bitmap
INIT_PAGE		equ		100
SELECT_PAGE 	equ		101
PLAY_PAGE		equ		102

TAP_EFFECT      equ     200
CATCH_EFFECT    equ     201
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; settings.rc
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
ICO_MAIN	equ	10000
DLG_MAIN	equ	10000
DLG_SPEED	equ	10001
IDC_CANCEL	equ	10002
DLG_DELAY   equ 10003
DLG_KEY1    equ 10004
DLG_KEY2    equ 10005
DLG_KEY3    equ 10006
DLG_KEY4    equ 10007
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; SELECT_PAGE
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
MUSIC1_X1    equ     560
MUSIC1_Y1    equ     340
MUSIC1_X2    equ     720
MUSIC1_Y2    equ     380
MUSIC2_X1    equ     560
MUSIC2_Y1    equ     460
MUSIC2_X2    equ     720
MUSIC2_Y2    equ     500
MUSIC3_X1    equ     560
MUSIC3_Y1    equ     580
MUSIC3_X2    equ     720
MUSIC3_Y2    equ     620
TEXTOUT1_X   equ     610
TEXTOUT1_Y   equ     350
TEXTOUT2_X   equ     610
TEXTOUT2_Y   equ     470
TEXTOUT3_X   equ     610
TEXTOUT3_Y   equ     590
QUEUE_LENGTH equ     3
endif