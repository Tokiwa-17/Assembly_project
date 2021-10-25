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
include     config.inc
include     level.inc
include 	winmm.inc
includelib	winmm.lib

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
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameInit
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameInit        proc        uses eax


    ret
GameInit        endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameUpdate
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameUpdate      proc       

    ret
GameUpdate      endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; NoteTapJudgement
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_NoteTapJudgement proc index:dword
        
_NoteTapJudgement endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; NoteCatchJudgement
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
NoteCatchJudgement	proc    uses  eax esi ecx,  index, currentTime
    local @curIndex
    local @note
    local @record
    mov esi, offset globalLevelRecord.currentIndices
    mov ecx, index
L1:
    add esi, 4
    loop L1
    mov eax, [esi]
    mov @curIndex, eax
beginWhile:
    mov esi, offset globalPCurLevel
    add esi, sizeof Level
    sub esi, 32
    mov ecx, index
L2:
    add esi, 4
    loop L2
    mov eax, [esi]
;   sGame.pCurLevel->noteCounts[index] > curIndex
;   如果不大于
    cmp eax, @curIndex
    jna endWhile
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   LevelNote *note = &(sGame.pCurLevel)->notes[index][curIndex]
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   globalPCurLevel -> notes[index]
    mov esi, globalPCurLevel
    add esi, sizeof Level
    sub esi, 16
    mov ecx, index
L3:
    add esi, 4
    loop L3     ; (sGame.pCurLevel)->notes[index]
;   notes[index][curIndex]
    mov eax, [esi]
    mov esi, eax
    mov ecx, @curIndex
L4:
    add esi, sizeof LevelNote
    loop L4
    mov @note, esi
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   LevelNoteRecord *record = &sGame.levelRecord.records[index][curIndex]
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, offset globalLevelRecord.records
    mov ecx, index
L5: 
    add esi, 4
    loop L5
    mov eax, [esi]
    mov esi, eax
    mov ecx, @curIndex
L6: 
    add esi, sizeof LevelNoteRecord
    loop L6
    mov @record, esi
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;  (note->type == NOTE_TAP)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @note
    mov eax, (LevelNote PTR  [esi]).NoteType
    mov esi, NOTE_TAP
    cmp eax, esi
    jz  endWhile
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   note->time > currentTime + NOTE_JUDGE_PERFECT_LIMIT
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @note
    mov eax, (LevelNote PTR [esi]).Time
    mov esi, currentTime
    add esi, NOTE_JUDGE_PERFECT_LIMIT
    cmp eax, esi
    jna L7
    mov esi, @note
    mov eax, (LevelNote PTR [esi]).Time
    mov esi, @record
    mov (LevelNoteRecord PTR [esi]).judgeTime, eax
    mov eax, NOTE_JUDGE_CRITICAL_PERFECT
    mov (LevelNoteRecord PTR [esi]).judgement, eax
    mov esi, offset globalLevelRecord.catchJudgeCount
    inc dword PTR [esi]
    jmp L8
L7:
    mov eax, currentTime
    mov esi, @record
    mov (LevelNoteRecord PTR [esi]).judgeTime, eax
    mov eax, NOTE_JUDGE_MISS
    mov (LevelNoteRecord PTR [esi]).judgement, eax
    mov esi, offset globalLevelRecord.catchJudgeCount
    add esi, 4
    inc dword PTR [esi]
L8:
    mov eax, @curIndex
    add eax, 1
    mov @curIndex, eax
    jmp beginWhile
endWhile:
    mov esi, offset globalLevelRecord.currentIndices
    mov ecx, index
L9:
    add esi, 4
    loop L9
    mov eax, @curIndex
    mov dword PTR [esi], eax
    ret
NoteCatchJudgement  endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameCalcNoteCenterY
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameCalcNoteCenterY     proc    uses eax ebx,    noteTime, currentTime
    
    mov eax, currentTime
    cmp eax, noteTime
    jbe     L2
L1:
    mov eax, currentTime
    sub eax, noteTime
    mul globalSpeedLevel
    shr eax, 4
    add eax, globalJudgeLineY
    jmp     L3
L2:
    mov eax, noteTime
    sub eax, currentTime
    mul globalSpeedLevel
    shr eax, 4
    mov ebx, globalJudgeLineY
    sub ebx, eax
    mov eax, ebx
L3:
    ret
GameCalcNoteCenterY      endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameLevelReset
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameLevelReset      proc    uses esi eax ebx    levelIndex
    ret
GameLevelReset      endp
end
