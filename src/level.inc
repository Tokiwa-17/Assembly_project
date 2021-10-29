ifndef __level_inc_
__level_inc_ equ <1>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; EQU 等值段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GAME_KEY_COUNT          equ     4
MAX_NOTE_LENGTH         equ     512
MAX_NAME_LENGTH         equ     128

DIFFICULTY_EASY         equ     0
DIFFICULTY_NORMAL       equ     1
DIFFICULTY_HARD         equ     2
DIFFICULTY_EXPERT       equ     3

NOTE_TAP                equ     111
NOTE_CATCH              equ     45

NOTE_JUDGE_CRITICAL_PERFECT     equ     0
NOTE_JUDGE_PERFECT_EARLY        equ     1
NOTE_JUDGE_PERFECT_LATE         equ     2
NOTE_JUDGE_GREAT_EARLY          equ     3
NOTE_JUDGE_GREAT_LATE           equ     4
NOTE_JUDGE_MISS                 equ     5
NOTE_JUDGE_COUNT                equ     6
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; LevelNote 结构体
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
LevelNote        struct
Time            dword   0
NoteType        dword   0
LevelNote       ends
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Level 结构体
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Level        struct
musicName       db      MAX_NAME_LENGTH     DUP(0)
author          db      MAX_NAME_LENGTH     DUP(0)
musicPath       db      MAX_NAME_LENGTH     DUP(0)
imagePath       db      MAX_NAME_LENGTH     DUP(0)
musicSelectPath db      MAX_NAME_LENGTH     DUP(0)
LevelDifficulty dword   0
totalTime       dword   0
totalTapCount   dword   0
totalCatchCount dword   0
totalNoteCount  dword   0
noteCounts      dword   GAME_KEY_COUNT      DUP(0)
; 指向LevelNote结构体的指针
notes           dword   GAME_KEY_COUNT * MAX_NOTE_LENGTH DUP(0)
Level       ends
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;函数声明
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
LevelLoad PROTO, opernNamePtr: ptr sbyte, opernInstancePtr: ptr Level
;    int LevelLoad(const TCHAR *filePath, Level* pLevel); 

LevelDestroy PROTO,      pLevel: ptr Level
;    void LevelDestroy(Level *pLevel);

endif