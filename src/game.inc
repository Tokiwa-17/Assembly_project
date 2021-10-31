ifndef __game_inc_
__game_inc_ equ <1>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include 	level.inc
include     windows.inc
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; EQU 等值段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

GAME_LEVEL_RESET        equ     0
GAME_LEVEL_PLAYING      equ     1
GAME_LEVEL_PAUSE        equ     2

NOTE_JUDGE_CRITICAL_PERFECT_LIMIT       equ         25
NOTE_JUDGE_PERFECT_LIMIT                equ         50
NOTE_JUDGE_GREAT_LIMIT                  equ         100
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
LevelNoteRecord        struct
judgeTime       dword   0
judgement       dword   0
LevelNoteRecord        ends

LevelRecord            struct
;record indices within level
currentIndices  dword   GAME_KEY_COUNT      DUP(0)
tapJudgesCount  dword   NOTE_JUDGE_COUNT    DUP(0)
catchJudgeCount dword   2                   DUP(0)
records         LevelNoteRecord   GAME_KEY_COUNT * MAX_NOTE_LENGTH      DUP(<>)
LevelRecord            ends

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;函数声明
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameInit						PROTO
GameShutdown                    PROTO
GameDraw                        PROTO,      hDC:dword
GameUpdate                      PROTO
GameKeyCallback                 PROTO       keyCode:byte, down:byte, previousDown:byte
GameLevelCalcScore              PROTO
NoteCatchJudgement              PROTO,      index:dword, currentTime:dword
NoteTapJudgement                PROTO,      index:dword, judgeTime: dword
GameLevelReset                  PROTO
GameUpdateJudgements            PROTO,      keyi: dword, currentTime: dword
GameDrawNotes                   PROTO,      hDC:dword, keyi: dword, currentTime: dword
_ProcDlgMain	                PROTO	    hWnd:dword, wMsg:dword, wParam:dword, lParam:dword
changeQueue                     PROTO,      degree:sword
endif