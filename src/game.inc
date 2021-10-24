ifndef __game_inc_
__game_inc_ equ <1>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include 	level.inc
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; EQU 等值段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GAME_PAGE_HOME          equ     0
GAME_PAGE_CHOOSE        equ     1
GAME_PAGE_SETTING       equ     2
GAME_PAGE_PLAYING       equ     3

GAME_LEVEL_RESET        equ     0
GAME_LEVEL_PLAYING      equ     1
GAME_LEVEL_PAUSE        equ     2
GAME_LEVEL_END          equ     3

NOTE_JUDGE_CRITICAL_PERFECT_LIMIT       equ         25
NOTE_JUDGE_PERFECT_LIMIT                equ         50
NOTE_JUDGE_GREAT_LIMIT                  equ         100
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
LevelNoteRecord        struct
judgeTime       dword   0
judgement       dword   0
LevelNoteRecord        ends

LevelRecord            struct
records         dword   GAME_KEY_COUNT      DUP(0)
;record indices within level
currentIndices  dword   GAME_KEY_COUNT      DUP(0)
tapJudgesCount  dword   NOTE_JUDGE_COUNT    DUP(0)
catchJudgeCount dword   2                   DUP(0)
LevelRecord            ends

.data
;        ///// information /////
globalJudgeLineY      dword   0
;        ///// settings /////
globalSpeedLevel      dword   0
globalJudgeDelay      sdword  0
globalKeyMaps         db      GAME_KEY_COUNT      DUP(0)
;        ///// data /////
globalLevelCount      dword   0
globalLevels          dword   0
;        ///// state /////                ends
globalCurrentPage     dword   0
globalCurrentLevelID  dword   0
globalPCurLevel       dword   0
globalLevelState      dword   0
globalLevelBeginTime  dword   0
globalLevelRecord     LevelRecord       <>  
globalKeyPressing     db      GAME_KEY_COUNT      DUP(0)
globalKeyPressTime    dword   GAME_KEY_COUNT      DUP(0)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;函数声明
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameInit						PROTO
GameShutdown                    PROTO
;GameKeyCallback                 PROTO,      keyCode:db, down:db, previousDown:db  
GameUpdate                      PROTO
GameDraw                        PROTO,      hDC:dword
GameCalcNoteCenterY             PROTO,      noteTime:dword, currentTime:dword
GameLevelCalcScore              PROTO
NoteCatchJudgement              PROTO,      index:dword, currentTime:dword
endif