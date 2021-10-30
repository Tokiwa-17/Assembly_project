ifndef __config_inc_
__config_inc_ equ <1>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; EQU 等值段
WINDOW_HEIGHT 			equ 	960
WINDOW_WIDTH  			equ		1280
ID_TIMER				equ		1
TIMER_MAIN_INTERVAL		equ		16
GAME_LEVEL_WAIT_TIME     equ     1000

TAP_NOTE_HEIGHT   equ 50
CATCH_NOTE_HEIGHT equ 50
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ico
ICO_GAME		equ		1000

; Bitmap
INIT_PAGE		equ		100
SELECT_PAGE 	equ		101
PLAY_PAGE		equ		102
RESULT_PAGE     equ     103

TAP_EFFECT      equ     200
CATCH_EFFECT    equ     201
MUSIC_SELECT_0   equ    105
MUSIC_SELECT_1   equ    106

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
TEXTOUT1_X   equ     1122
TEXTOUT1_Y   equ     339
TEXTOUT2_X   equ     1051
TEXTOUT2_Y   equ     474
TEXTOUT3_X   equ     1122
TEXTOUT3_Y   equ     609
QUEUE_LENGTH equ     3
SELECT_COVER_X  equ  187
SELECT_COVER_Y  equ  193
SELECT_COVER_WIDTH   equ    512
SELECT_COVER_HEIGHT  equ    512
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; PLAY_PAGE
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SONGTEXT_X equ 14
SONGTEXT_Y equ 317
MUSICIANTEXT_X equ 14
MUSICIANTEXT_Y equ 398
SCORETEXT_X equ 1010
SCORETEXT_Y equ 68
PERFECTTEXT_X equ 1160
PERFECTTEXT_Y equ 730
GREATTEXT_X equ 1160
GREATTEXT_Y equ 810
MISSTEXT_X equ 1160
MISSTEXT_Y equ 890
TRACT0_X equ 257
TRACT1_X equ 437
TRACT2_X equ 617
TRACT3_X equ 797
TRACT4_X equ 979
TRACT_TOP_Y equ 0
TRACT_BOTTOM_Y equ WINDOW_HEIGHT
JUDGELINE_Y equ 800
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; RESULT_PAGE
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
RESULT_COVER_X equ  52
RESULT_COVER_Y equ  204
RESULT_COVER_WIDTH   equ    512
RESULT_COVER_HEIGHT  equ    512
RECORD_X equ 916
TAP_CRITICAL_PERFECT_Y equ 500
TAP_PERFECT_Y equ 533
TAP_PERFECT_EARLY_Y equ 566
TAP_PERFECT_LATE_Y equ 599
TAP_GREAT_Y equ 633
TAP_GREAT_EARLY_Y equ 666
TAP_GREAT_LATE_Y equ 699
TAP_MISS_Y equ 733
CATCH_CRITICAL_PERFECT_Y equ 808
CATCH_MISS_Y equ 842
SCORE_X equ 653
SCORE_Y equ 331
endif
