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
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.data
LevelNoteRecord        struct
key_d           dword   0
key_f           dword   0
key_j           dword   0
key_k           dword   0
key_return      dword   0
LevelNoteRecord        ends

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

Game                   struct
;        ///// information /////
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
keyPressing     db      GAME_KEY_COUNT      DUP(0)
keyPressTime    dword   GAME_KEY_COUNT      DUP(0)
Game                   ends
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;函数声明
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameInit						PROTO
GameShutdown                    PROTO
GameKeyCallback                 PROTO,      keyCode:db, down:db, previousDown:db  
GameUpdate                      PROTO
GameDraw                        PROTO,      hDC:dword
GameCalcNoteCenterY             PROTO,      noteTime:dword, currentTime:dword
GameLevelCalcScore              PROTO
