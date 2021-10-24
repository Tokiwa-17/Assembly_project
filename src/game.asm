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
include 	game.inc

.data
judgeLineY      dword   0
;        ///// settings /////
speedLevel      dword   0
judgeDelay      sdword  0
keyMaps         db      GAME_KEY_COUNT      DUP(0)
;        ///// data /////
levelCount      dword   0
levels          dword   0
;        ///// state /////
currentPage     dword   0
currentLevelID  dword   0
pCurLevel       dword   0
levelState      dword   0
levelBeginTime  dword   0
levelRecord     LevelRecord <>;
keyPressing     db      GAME_KEY_COUNT      DUP(0)
keyPressTime    dword   GAME_KEY_COUNT      DUP(0)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.code
_NoteTapJudgement proc 
        local @curIndex:DWORD
        local @judgeTime:DWORD

        mov ebx, sGame.LevelRecord
        mov @curIndex, ebx
        mov esi, OFFSET sGame.keyPressTime
        add esi, 4[eax]
        mov ebx, [esi]
        mov @judgeTime, ebx

        jl  L1

        ret
    L1: 

        



_NoteTapJudgement endp