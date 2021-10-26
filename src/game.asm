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

include		resource.inc
include 	game.inc
include     config.inc
include     level.inc

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
globalCurrentPage     dword   100
globalCurrentLevelID  dword   0
globalPCurLevel       dword   0
globalLevelState      dword   0
globalLevelBeginTime  dword   0
globalLevelRecord     LevelRecord       <>  
globalKeyPressing     db      GAME_KEY_COUNT      DUP(0)
globalKeyPressTime    dword   GAME_KEY_COUNT      DUP(0)

_bg1            dword       0
_bg2            dword       0
_bg3            dword       0

.const
Cyaegha         db  "levels\Cyaegha.level", 0

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; NoteTapJudgement
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
NoteTapJudgement proc  uses  esi ecx,  index
    local @curIndex
    local @judgeTime
    local @note
    local @record
    local @diff
    mov esi, offset globalLevelRecord.currentIndices
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
    mov @curIndex, eax

    mov esi, offset globalKeyPressTime
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
    mov @judgeTime, eax

NoteTapJudgement_beginWhile:
    mov esi, offset globalPCurLevel
    add esi, sizeof Level
    sub esi, 32
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
;   sGame.pCurLevel->noteCounts[index] > curIndex
;   如果不大于
    cmp eax, @curIndex
    jna NoteTapJudgement_endWhile
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   LevelNote *note = &(sGame.pCurLevel)->notes[index][curIndex]
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   globalPCurLevel -> notes[index]
    mov esi, globalPCurLevel
    add esi, sizeof Level
    sub esi, 16
;   (sGame.pCurLevel)->notes[index]
    mov ecx, index
    shl ecx, 2
    add esi, ecx
;   notes[index][curIndex]
    mov eax, [esi]
    mov esi, eax
    mov ecx, @curIndex
    shl ecx, 3; sizeof LevelNote = 8
    add esi, ecx
    mov @note, esi
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   LevelNoteRecord *record = &((sGame.levelRecord).records[index][curIndex])
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, offset globalLevelRecord.records
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
    mov esi, eax
    mov ecx, @curIndex
    shl ecx, 3; sizeof LevelNoteRecord = 8
    add esi, ecx
    mov @record, esi
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;  (note->type == NOTE_CATCH)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @note
    mov eax, (LevelNote PTR  [esi]).NoteType
    mov esi, NOTE_CATCH
    cmp eax, esi
    jz  NoteTapJudgement_endWhile
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   judgeTime > note->time
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @note
    mov eax, (LevelNote PTR [esi]).Time
    mov esi, @judgeTime
    .IF esi > eax
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   Time diff = record->judgeTime - note->time;
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov eax, @judgeTime
    mov esi, @note
    sub eax, (LevelNote PTR [esi]).Time
    mov @diff, eax
        .IF @diff <= NOTE_JUDGE_CRITICAL_PERFECT_LIMIT
        mov esi, @record
        mov eax, NOTE_JUDGE_CRITICAL_PERFECT
        mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSEIF @diff <= NOTE_JUDGE_PERFECT_LIMIT
        mov esi, @record
        mov eax, NOTE_JUDGE_PERFECT_LATE
        mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSEIF @diff <= NOTE_JUDGE_GREAT_LIMIT
        mov esi, @record
        mov eax, NOTE_JUDGE_GREAT_LATE
        mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSE
        mov esi, @record
        mov eax, NOTE_JUDGE_MISS
        mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ENDIF
    .ELSE
    mov esi, @note
    mov eax, (LevelNote PTR [esi]).Time
    sub eax, @judgeTime
    mov @diff, eax
        .IF @diff <= NOTE_JUDGE_CRITICAL_PERFECT_LIMIT
        mov esi, @record
        mov eax, NOTE_JUDGE_CRITICAL_PERFECT
        mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSEIF @diff <= NOTE_JUDGE_PERFECT_LIMIT
        mov esi, @record
        mov eax, NOTE_JUDGE_PERFECT_EARLY
        mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSEIF @diff <= NOTE_JUDGE_GREAT_LIMIT
        mov esi, @record
        mov eax, NOTE_JUDGE_GREAT_EARLY
        mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSE
        jmp NoteTapJudgement_endWhile
        .ENDIF
    .ENDIF
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   record->judgeTime = judgeTime;
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov eax, @judgeTime
    mov esi, @record
    mov (LevelNoteRecord PTR [esi]).judgeTime, eax 
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   ++sGame.levelRecord.tapJudgesCount[record->judgement];
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @record
    mov ecx, (LevelNoteRecord PTR [esi]).judgement
    shl ecx, 2
    mov esi, offset globalLevelRecord.tapJudgesCount
    add esi, ecx
    inc dword PTR [esi]
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   ++curIndex;
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  
    mov eax, @curIndex
    inc eax
    mov @curIndex, eax
    jmp NoteTapJudgement_beginWhile
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   record->judgement != NOTE_JUDGE_MISS
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @record
    mov eax, (LevelNoteRecord PTR [esi]).judgement
    .IF eax != NOTE_JUDGE_MISS
    jmp NoteTapJudgement_endWhile
    .ENDIF
NoteTapJudgement_endWhile:
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   sGame.levelRecord.currentIndices[index] = curIndex
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, offset globalLevelRecord.currentIndices
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, @curIndex
    mov dword PTR [esi], eax
    ret
NoteTapJudgement endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; NoteCatchJudgement
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
NoteCatchJudgement	proc    uses  eax esi ecx,  index, currentTime
    local @curIndex
    local @note
    local @record
    mov esi, offset globalLevelRecord.currentIndices
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
    mov @curIndex, eax
NoteCatchJudgement_beginWhile:
    mov esi, offset globalPCurLevel
    add esi, sizeof Level
    sub esi, 32
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
;   sGame.pCurLevel->noteCounts[index] > curIndex
;   如果不大于
    cmp eax, @curIndex
    jna NoteCatchJudgement_endWhile
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   LevelNote *note = &(sGame.pCurLevel)->notes[index][curIndex]
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   globalPCurLevel -> notes[index]
    mov esi, globalPCurLevel
    add esi, sizeof Level
    sub esi, 16
; (sGame.pCurLevel)->notes[index]
    mov ecx, index
    shl ecx, 2
    add esi, ecx
;   notes[index][curIndex]
    mov eax, [esi]
    mov esi, eax
    mov ecx, @curIndex
    shl ecx, 3; sizeof LevelNote = 8
    add esi, ecx
    mov @note, esi
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   LevelNoteRecord *record = &sGame.levelRecord.records[index][curIndex]
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, offset globalLevelRecord.records
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    loop L5
    mov eax, [esi]
    mov esi, eax
    mov ecx, @curIndex
    shl ecx, 3; sizeof LevelNoteRecord = 8
    add esi, ecx
    mov @record, esi
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;  (note->type == NOTE_TAP)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @note
    mov eax, (LevelNote PTR  [esi]).NoteType
    mov esi, NOTE_TAP
    cmp eax, esi
    jz  NoteCatchJudgement_endWhile
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   note->time > currentTime + NOTE_JUDGE_PERFECT_LIMIT
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @note
    mov eax, (LevelNote PTR [esi]).Time
    mov esi, currentTime
    add esi, NOTE_JUDGE_PERFECT_LIMIT
    cmp eax, esi
    jna NoteCatchJudgement_L7
    mov esi, @note
    mov eax, (LevelNote PTR [esi]).Time
    mov esi, @record
    mov (LevelNoteRecord PTR [esi]).judgeTime, eax
    mov eax, NOTE_JUDGE_CRITICAL_PERFECT
    mov (LevelNoteRecord PTR [esi]).judgement, eax
    mov esi, offset globalLevelRecord.catchJudgeCount
    inc dword PTR [esi]
    jmp NoteCatchJudgement_L8
NoteCatchJudgement_L7:
    mov eax, currentTime
    mov esi, @record
    mov (LevelNoteRecord PTR [esi]).judgeTime, eax
    mov eax, NOTE_JUDGE_MISS
    mov (LevelNoteRecord PTR [esi]).judgement, eax
    mov esi, offset globalLevelRecord.catchJudgeCount
    add esi, 4
    inc dword PTR [esi]
NoteCatchJudgement_L8:
    mov eax, @curIndex
    add eax, 1
    mov @curIndex, eax
    jmp NoteCatchJudgement_beginWhile
NoteCatchJudgement_endWhile:
    mov esi, offset globalLevelRecord.currentIndices
    mov ecx, index
    shl ecx, 2
    add esi, ecx
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
    jbe     GameCalcNoteCenterY_L2
GameCalcNoteCenterY_L1:
    mov eax, currentTime
    sub eax, noteTime
    mul globalSpeedLevel
    shr eax, 4
    add eax, globalJudgeLineY
    jmp     GameCalcNoteCenterY_L3
GameCalcNoteCenterY_L2:
    mov eax, noteTime
    sub eax, currentTime
    mul globalSpeedLevel
    shr eax, 4
    mov ebx, globalJudgeLineY
    sub ebx, eax
    mov eax, ebx
GameCalcNoteCenterY_L3:
    ret
GameCalcNoteCenterY      endp

GameInit proc
;		Load Bitmap
		invoke	LoadBitmap, hInstance, INIT_PAGE
		mov		_bg1, 	eax
		invoke	LoadBitmap, hInstance, SELECT_PAGE
		mov		_bg2, 	eax
		invoke	LoadBitmap, hInstance, PLAY_PAGE
		mov		_bg3, 	eax
		ret
GameInit endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameLevelReset
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameLevelReset      proc    uses esi eax ebx    levelIndex
    ret
GameLevelReset      endp

GameUpdate proc
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
GameUpdate endp

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
		invoke StretchBlt, _hDC, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT,\
			@hDcBack, 0, 0, HOME_PAGE_WIDTH, HOME_PAGE_HEIGHT, SRCCOPY
		invoke SelectObject, @hDcBack, @hOldObject
		invoke DeleteDC, @hDcBack
		ret
GameDraw	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameKeyCallback
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameKeyCallback     proc       uses eax ecx esi,        keyCode:byte, down:byte, previousDown:byte
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
GameKeyCallback_L1:
        mov eax, ecx
        sub eax, 1
        mov @index, eax
        mov esi, offset globalKeyMaps
        add esi, eax
        mov al, byte ptr [esi]
        ; if (sGame.keyMaps[index] == keyCode)
        .if al == keyCode
            .if down
                ; sGame.keyPressing[index] = True
                mov esi, offset globalKeyPressing
                mov eax, @index
                add esi, eax
                mov byte ptr [esi], 1
                ; if (!previousDown)
                mov al, previousDown
                cmp al, 0
                jne GameKeyCallback_L3
                mov esi, offset globalKeyPressTime
                mov eax, @index
                shl eax, 2; sizeof dword = 4
                add esi, eax
                invoke timeGetTime
                sub eax, globalLevelBeginTime
                mov [esi], eax
                invoke NoteTapJudgement, @index
            .else
                mov esi, offset globalKeyPressing
                mov eax, @index
                add esi, eax
                mov byte ptr[esi], 0
                invoke timeGetTime
                sub eax, globalLevelBeginTime
                invoke NoteCatchJudgement, @index, eax
            .endif
            ret
        .endif
        loop GameKeyCallback_L1
    .endif
    ret
GameKeyCallback     endp
end
