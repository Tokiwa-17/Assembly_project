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
includelib  msvcrt.lib
include     msimg32.inc
includelib  msimg32.lib
;include     Irvine32.inc

include     audio.inc
include 	game.inc
include     draw.inc
include     config.inc
include     level.inc

extern hInstance:dword
extern hMainWin:dword

public globalSpeedLevel
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; data
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

.data
;        ///// information /////
ansMsg	BYTE    "str is %s", 0ah, 0dh, 0  
globalJudgeLineY      dword   0
;        ///// settings /////
globalSpeedLevel      dword   0
globalJudgeDelay      sdword  0
globalKeyMaps         db      GAME_KEY_COUNT      DUP(0)
;        ///// data /////
globalLevelCount      dword   0
globalLevels          dword   0
globalLevelResources  dword   0
;        ///// state /////                ends
globalCurrentPage     dword   100
globalCurrentLevelID  dword   0
globalPCurLevel       dword   0
globalPCurLevelResources dword 0
globalLevelState      dword   0
globalLevelResetTime  dword   0
globalLevelBeginTime  dword   0
globalLevelRecord     LevelRecord       <>  
globalKeyPressing     db      GAME_KEY_COUNT      DUP(0)
globalKeyPressTime    dword   GAME_KEY_COUNT      DUP(0)

tapSoundDeviceID dword ?

_bg1            dword       0
_bg2            dword       0
_bg3            dword       0
_bg4            dword       0

_item1          dword       0

settings        dword       0
hEvent          dword       0
musicNameList   dword       QUEUE_LENGTH        DUP(0)
tmp_str         db          256 dup(0)

.const
Cyaegha     db  "Cyaegha", 0
Sheriruth   db  "Sheriruth", 0

scoreFmt        db  "%08d",0
num2str         db  "%d",0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.code
memset proto C :ptr byte, :dword, :dword
strcmp proto C :dword, :dword
strlen proto C :ptr sbyte
printf proto C :ptr sbyte, :VARARG
sprintf proto C :ptr byte, :ptr byte, :VARARG
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; NoteTapJudgement
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
NoteTapJudgement proc  uses ecx edx esi edi, index: dword, judgeTime: dword
    local @noteCount: dword
    local @curIndex: dword
    local @note: ptr LevelNote
    local @record: ptr LevelNoteRecord

    mov esi, globalPCurLevel
    add esi, type Level
    ; globalPCurLevel->noteCounts
    sub esi, GAME_KEY_COUNT * type dword + GAME_KEY_COUNT * MAX_NOTE_LENGTH * type LevelNote
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
    mov @noteCount, eax
    
    mov esi, offset globalLevelRecord.currentIndices
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
    mov @curIndex, eax

    ; (globalPCurLevel)->notes[index][curIndex]
    mov eax, GAME_KEY_COUNT
    sub eax, index
    mov ecx, MAX_NOTE_LENGTH
    mul ecx
    sub eax, @curIndex
    mov ecx, type LevelNote
    mul ecx
    mov esi, globalPCurLevel
    add esi, type Level
    sub esi, eax
    mov @note, esi
    ; LevelNoteRecord *record = &globalLevelRecord.records[index][curIndex]
    mov edi, offset globalLevelRecord
    add edi, type LevelRecord
    sub edi, eax
    mov @record, edi

NoteTapJudgement_beginWhile:
    mov eax, @noteCount
    cmp eax, @curIndex
    jna NoteTapJudgement_endWhile

    ; (note->type == NOTE_CATCH) => break
    mov eax, (LevelNote PTR [esi]).NoteType
    mov edx, NOTE_CATCH
    cmp eax, edx
    je  NoteTapJudgement_endWhile
    ; Time diff = judgeTime - note->time;
    mov eax, judgeTime
    sub eax, (LevelNote ptr [esi]).Time
    ; if (diff <= 0)
    .IF eax >= 80000000h
        neg eax; -diff >= 0
        .IF eax <= NOTE_JUDGE_CRITICAL_PERFECT_LIMIT
            mov (LevelNoteRecord PTR [edi]).judgement, NOTE_JUDGE_CRITICAL_PERFECT
        .ELSEIF eax <= NOTE_JUDGE_PERFECT_LIMIT
            mov (LevelNoteRecord PTR [edi]).judgement, NOTE_JUDGE_PERFECT_EARLY
        .ELSEIF eax <= NOTE_JUDGE_GREAT_LIMIT
            mov (LevelNoteRecord PTR [edi]).judgement, NOTE_JUDGE_GREAT_EARLY
        .ELSE
            jmp NoteTapJudgement_endWhile
        .ENDIF
    .ELSE
        .IF eax <= NOTE_JUDGE_CRITICAL_PERFECT_LIMIT
            mov (LevelNoteRecord PTR [edi]).judgement, NOTE_JUDGE_CRITICAL_PERFECT
        .ELSEIF eax <= NOTE_JUDGE_PERFECT_LIMIT
            mov (LevelNoteRecord PTR [edi]).judgement, NOTE_JUDGE_PERFECT_LATE
        .ELSEIF eax <= NOTE_JUDGE_GREAT_LIMIT
            mov (LevelNoteRecord PTR [edi]).judgement, NOTE_JUDGE_GREAT_LATE
        .ELSE
            mov (LevelNoteRecord PTR [edi]).judgement, NOTE_JUDGE_MISS
        .ENDIF
    .ENDIF
    mov eax, judgeTime
    mov (LevelNoteRecord PTR [edi]).judgeTime, eax 
    mov edx, (LevelNoteRecord PTR [edi]).judgement
    shl edx, 2
    mov esi, offset globalLevelRecord.tapJudgesCount
    add esi, edx
    inc dword PTR [esi]
    inc @curIndex

    mov eax, (LevelNoteRecord PTR [edi]).judgement
    mov esi, @note
    add esi, type LevelNote
    add edi, type LevelNoteRecord
    mov @note, esi
    mov @record, edi
    cmp eax, NOTE_JUDGE_MISS
    je NoteTapJudgement_beginWhile
    invoke timeGetTime
    sub eax, globalLevelBeginTime
    sub eax, judgeTime
    invoke AudioPlay, tapSoundDeviceID, eax
NoteTapJudgement_endWhile:

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
NoteCatchJudgement  proc uses ecx edx esi edi, index, currentTime
    local @pressTime: dword
    local @noteCount: dword
    local @curIndex: dword
    local @note: ptr LevelNote
    local @record: ptr LevelNoteRecord

    mov esi, offset globalKeyPressTime
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
    mov @pressTime, eax

    mov esi, globalPCurLevel
    add esi, type Level
    ; globalPCurLevel->noteCounts
    sub esi, GAME_KEY_COUNT * type dword + GAME_KEY_COUNT * MAX_NOTE_LENGTH * type LevelNote
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
    mov @noteCount, eax

    mov esi, offset globalLevelRecord.currentIndices
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
    mov @curIndex, eax

    ; (globalPCurLevel)->notes[index][curIndex]
    mov eax, GAME_KEY_COUNT
    sub eax, index
    mov ecx, MAX_NOTE_LENGTH
    mul ecx
    sub eax, @curIndex
    mov ecx, type LevelNote
    mul ecx
    mov esi, globalPCurLevel
    add esi, type Level
    sub esi, eax
    mov @note, esi
    ; LevelNoteRecord *record = &globalLevelRecord.records[index][curIndex]
    mov edi, offset globalLevelRecord
    add edi, type LevelRecord
    sub edi, eax
    mov @record, edi

NoteCatchJudgement_beginWhile:
    mov eax, @noteCount
    cmp eax, @curIndex
    jna NoteCatchJudgement_endWhile

    ; (note->type == NOTE_TAP) => break
    mov eax, (LevelNote PTR  [esi]).NoteType
    mov edx, NOTE_TAP
    cmp eax, edx
    je  NoteCatchJudgement_endWhile
    ; currentTime + NOTE_JUDGE_PERFECT_LIMIT - note->time < 0 => break
    mov eax, (LevelNote PTR [esi]).Time
    mov edx, currentTime
    add edx, NOTE_JUDGE_PERFECT_LIMIT
    sub edx, eax
    shl edx, 1
    jc  NoteCatchJudgement_endWhile

    mov eax, (LevelNote PTR [esi]).Time
    add eax, NOTE_JUDGE_PERFECT_LIMIT
    sub eax, @pressTime
    ; note->time + NOTE_JUDGE_PERFECT_LIMIT - globalKeyPressTime[index] >= 0
    .if eax < 80000000h
        mov eax, (LevelNote PTR [esi]).Time
        mov (LevelNoteRecord PTR [edi]).judgeTime, eax
        mov (LevelNoteRecord PTR [edi]).judgement, NOTE_JUDGE_CRITICAL_PERFECT
        mov esi, offset globalLevelRecord.catchJudgeCount
        inc dword ptr [esi]
        invoke timeGetTime
        mov edi, @record
        sub eax, globalLevelBeginTime
        sub eax, (LevelNoteRecord PTR [edi]).judgeTime
        invoke AudioPlay, tapSoundDeviceID, eax
    .else
        mov eax, currentTime
        mov (LevelNoteRecord PTR [edi]).judgeTime, eax
        mov (LevelNoteRecord PTR [edi]).judgement, NOTE_JUDGE_MISS
        mov esi, offset globalLevelRecord.catchJudgeCount
        inc dword ptr [esi + 4]
    .endif
    inc @curIndex
    mov esi, @note
    add esi, type LevelNote
    mov @note, esi
    mov edi, @record
    add edi, type LevelNoteRecord
    mov @record, edi
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

GameLevelCalcScore proc uses ebx edx esi
    mov esi, offset globalLevelRecord.tapJudgesCount
    mov edx, [esi]
    add edx, [esi + 4]
    add edx, [esi + 8]
    shl edx, 1
    mov eax, edx
    mov edx, [esi + 12]
    add edx, [esi + 16]
    mov esi, offset globalLevelRecord.catchJudgeCount
    add edx, [esi]
    add eax, edx
    mov edx, 10000000
    mul edx

    mov esi, globalPCurLevel
    mov ebx, (Level ptr [esi]).totalTapCount
    shl ebx, 1
    add ebx, (Level ptr [esi]).totalCatchCount
    div ebx
    mov esi, offset globalLevelRecord.tapJudgesCount
    add eax, [esi]
    ret
GameLevelCalcScore endp

GameInit proc uses esi edi
    local @hHeap

    mov globalSpeedLevel, 13
    mov globalJudgeDelay, 0

    mov     esi,    offset  globalKeyMaps
    mov     al,     'F'
    mov     byte ptr [esi], al
    mov     al,     'G'
    mov     byte ptr [esi + 1], al
    mov     al,     'H'
    mov     byte ptr [esi + 2], al
    mov     al,     'J'
    mov     byte ptr [esi + 3], al

	invoke	LoadBitmap, hInstance, INIT_PAGE
	mov		_bg1, 	eax
	invoke	LoadBitmap, hInstance, SELECT_PAGE
	mov		_bg2, 	eax
	invoke	LoadBitmap, hInstance, PLAY_PAGE
	mov		_bg3, 	eax
    invoke  LoadBitmap, hInstance, RESULT_PAGE
    mov     _bg4,   eax

    invoke GameLoadNoteAssets

    invoke AudioOpenResource, TAP_SOUND_EFFECT
    mov tapSoundDeviceID, eax

    invoke GetProcessHeap
    mov @hHeap, eax
    invoke HeapAlloc, @hHeap, 0, 4 * type Level
    mov globalLevels, eax
    invoke HeapAlloc, @hHeap, 0, 4 * type LevelResources
    mov globalLevelResources, eax

    invoke LevelLoad, offset Cyaegha, globalLevels, globalLevelResources
    mov esi, globalLevels
    mov edi, globalLevelResources
    add esi, type Level
    add edi, type LevelResources
    invoke LevelLoad, offset Sheriruth, esi, edi

    mov globalLevelCount, 2
    mov globalCurrentLevelID, 0
    mov esi, globalLevels
    mov globalPCurLevel, esi
    mov esi, globalLevelResources
    mov globalPCurLevelResources, esi

	ret
GameInit endp

GameShutdown proc uses edi
    local @hHeap

    invoke LevelDestroy, globalLevelResources
    mov edi, globalLevelResources
    add edi, type LevelResources
    invoke LevelDestroy, edi

    invoke GetProcessHeap
    mov @hHeap, eax
    invoke HeapFree, @hHeap, 0, globalLevelResources
    invoke HeapFree, @hHeap, 0, globalLevels

    invoke AudioClose, tapSoundDeviceID
    ret
GameShutdown endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameLevelReset
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameLevelReset proc uses ecx edx esi edi
    invoke memset, offset globalLevelRecord, 0, type LevelRecord
    mov ecx, GAME_KEY_COUNT
    mov edi, offset globalKeyPressing
GameLevelReset_L1:
    mov byte ptr [edi], FALSE
    inc edi
    loop GameLevelReset_L1

    mov globalLevelState, GAME_LEVEL_RESET
    invoke timeGetTime
    mov globalLevelResetTime, eax
    add eax, GAME_LEVEL_WAIT_TIME
    add eax, globalJudgeDelay
    mov globalLevelBeginTime, eax
    ret
GameLevelReset endp

GameUpdate proc uses edx esi
    local @currentTime: dword
    invoke timeGetTime
    sub eax, globalLevelBeginTime
    mov @currentTime, eax
    .if globalCurrentPage == PLAY_PAGE
        .if globalLevelState == GAME_LEVEL_RESET
            .if eax < 80000000h
                mov esi, globalPCurLevelResources
                invoke AudioPlay, (LevelResources ptr [esi]).musicDeviceID, eax
                mov globalLevelState, GAME_LEVEL_PLAYING
            .endif
        .elseif globalLevelState == GAME_LEVEL_PLAYING
            mov esi, globalPCurLevel
            mov edx, (Level ptr [esi]).totalTime
            .if eax >= edx
                mov globalCurrentPage, RESULT_PAGE
                ret
            .endif
        .endif
        mov ecx, GAME_KEY_COUNT
GameUpdate_L1:
        mov edx, GAME_KEY_COUNT
        sub edx, ecx
        push ecx
        invoke GameUpdateJudgements, edx, @currentTime
        pop ecx
        loop GameUpdate_L1
	.endif
	ret
GameUpdate endp

GameUpdateJudgements proc uses ecx edx esi edi, keyi: dword, currentTime: dword
    local @pressTime
    local @noteCount: ptr dword
    local @currentID: ptr dword
    local @pTheRecord: ptr LevelNoteRecord
    local @pTheNote: ptr LevelNote

    mov esi, offset globalKeyPressTime
    mov eax, keyi
    shl eax, 2
    add esi, eax
    mov eax, [esi]
    mov @pressTime, eax

    mov esi, globalPCurLevel
    add esi, type Level
    ; globalPCurLevel->noteCounts
    sub esi, GAME_KEY_COUNT * type dword + GAME_KEY_COUNT * MAX_NOTE_LENGTH * type LevelNote
    mov ecx, keyi
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
    mov @noteCount, eax

    mov esi, offset globalLevelRecord
    mov ecx, keyi
    shl ecx, 2
    add esi, ecx
    mov edx, [esi]
    mov @currentID, edx

    mov eax, GAME_KEY_COUNT
    sub eax, keyi
    mov ecx, MAX_NOTE_LENGTH
    mul ecx
    sub eax, @currentID
    mov ecx, 8
    mul ecx
    mov esi, globalPCurLevel
    add esi, type Level
    sub esi, eax
    mov @pTheNote, esi
    mov edi, offset globalLevelRecord
    add edi, type LevelRecord
    sub edi, eax
    mov @pTheRecord, edi

GameUpdateJudgements_L1:
    mov eax, @currentID
    cmp eax, @noteCount
    jge GameUpdateJudgements_L1_Exit

    mov eax, (LevelNote ptr [esi]).NoteType
    .if eax == NOTE_TAP
        mov eax, currentTime
        sub eax, NOTE_JUDGE_GREAT_LIMIT
        sub eax, (LevelNote ptr [esi]).Time
        shl eax, 1
        jc GameUpdateJudgements_L1_Exit
        mov eax, currentTime
        mov (LevelNoteRecord ptr [edi]).judgeTime, eax
        mov (LevelNoteRecord ptr [edi]).judgement, NOTE_JUDGE_MISS
        mov edi, offset globalLevelRecord.tapJudgesCount
        inc dword ptr [edi + NOTE_JUDGE_MISS * type dword]
    .elseif eax == NOTE_CATCH
        mov ebx, offset globalKeyPressing
        add ebx, keyi
        mov cl, [ebx]
        .if cl > 0
            mov eax, @pressTime
            sub eax, (LevelNote ptr [esi]).Time
            sub eax, NOTE_JUDGE_PERFECT_LIMIT
            .if eax < 80000000h
                mov eax, (LevelNote ptr [esi]).Time
                mov (LevelNoteRecord ptr [edi]).judgeTime, eax
                mov (LevelNoteRecord ptr [edi]).judgement, NOTE_JUDGE_MISS
                mov edi, offset globalLevelRecord.catchJudgeCount
                inc dword ptr [edi + 4]
            .else
                mov eax, (LevelNote ptr [esi]).Time
                sub eax, currentTime
                shl eax, 1
                jnc GameUpdateJudgements_L1_Exit
                mov eax, (LevelNote ptr [esi]).Time
                mov (LevelNoteRecord ptr [edi]).judgeTime, eax
                mov (LevelNoteRecord ptr [edi]).judgement, NOTE_JUDGE_CRITICAL_PERFECT
                mov edi, offset globalLevelRecord.catchJudgeCount
                inc dword ptr [edi]
                invoke timeGetTime
                mov esi, @pTheRecord
                sub eax, globalLevelBeginTime
                sub eax, (LevelNoteRecord ptr [esi]).judgeTime
                invoke AudioPlay, tapSoundDeviceID, eax
            .endif
        .else
            mov eax, currentTime
            sub eax, NOTE_JUDGE_PERFECT_LIMIT
            sub eax, (LevelNote ptr [esi]).Time
            shl eax, 1
            jc GameUpdateJudgements_L1_Exit
            mov eax, (LevelNote ptr [esi]).Time
            mov (LevelNoteRecord ptr [edi]).judgeTime, eax
            mov (LevelNoteRecord ptr [edi]).judgement, NOTE_JUDGE_MISS
            mov edi, offset globalLevelRecord.catchJudgeCount
            inc dword ptr [edi + 4]
        .endif
    .endif

    inc @currentID
    mov esi, @pTheNote
    add esi, type LevelNote
    mov @pTheNote, esi
    mov edi, @pTheRecord
    add edi, type LevelNoteRecord
    mov @pTheRecord, edi
    jmp GameUpdateJudgements_L1
GameUpdateJudgements_L1_Exit:
    mov edi, offset globalLevelRecord
    mov ecx, keyi
    shl ecx, 2
    add edi, ecx
    mov eax, @currentID
    mov [edi], eax
    ret
GameUpdateJudgements endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; obtain RGB
  ;mov eax,红色＋绿色*100h＋蓝色*10000h
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
obtainRGB   proc uses esi ebx, R:dword, G:dword, B:dword
  mov esi, B
  mov eax, 10000h
  mul esi
  mov esi, eax
  mov ebx, G
  mov eax, 100h
  mul ebx
  mov ebx, eax
  mov eax, R
  add eax, ebx
  add eax, esi
  ret
obtainRGB  endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameDraw
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameDraw	proc uses esi ebx, _hDC
		local @hDcBack
		local @hOldObject
        local @hDcPen
        local @R_
        local @G_
        local @B_
        local @currentTime
		; DC for background 
		invoke	CreateCompatibleDC, _hDC; 
		mov		@hDcBack, eax
		.if	globalCurrentPage == INIT_PAGE
			invoke	SelectObject, @hDcBack, _bg1
            mov @hOldObject, eax
		.elseif globalCurrentPage == SELECT_PAGE
			invoke	SelectObject, @hDcBack, _bg2
            mov @hOldObject, eax
		.elseif globalCurrentPage == PLAY_PAGE
			invoke	SelectObject, @hDcBack, _bg3
            mov @hOldObject, eax
        .elseif globalCurrentPage == RESULT_PAGE
            invoke  SelectObject, @hDcBack, _bg4
            mov @hOldObject, eax
		.endif
		invoke	BitBlt, _hDC, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, @hDcBack, 0, 0, SRCCOPY
		invoke SelectObject, @hDcBack, @hOldObject
		invoke DeleteDC, @hDcBack
;       draw other stuff
        .if globalCurrentPage == INIT_PAGE

        .elseif globalCurrentPage == SELECT_PAGE
            ;mov hPen, eax 
            invoke	CreateCompatibleDC, _hDC; 创建与_hDC兼容的另一个DC(设备上下文)，以备后续操作
		    mov		@hDcBack, eax
            mov esi, globalPCurLevelResources
            invoke SelectObject, @hDcBack, (LevelResources ptr [esi]).image
            mov @hOldObject, eax
            invoke BitBlt, _hDC, SELECT_COVER_X, SELECT_COVER_Y, \
                SELECT_COVER_WIDTH, SELECT_COVER_HEIGHT, @hDcBack, 0, 0, SRCCOPY
            invoke SelectObject, @hDcBack, @hOldObject
		    invoke DeleteDC, @hDcBack
            invoke SetBkMode, _hDC, TRANSPARENT
            invoke obtainRGB, 255, 255, 255
            invoke SetTextColor, _hDC, eax
            invoke strlen, musicNameList[0]
            invoke TextOut,   _hDC, TEXTOUT1_X, TEXTOUT1_Y, musicNameList[0], eax
            invoke strlen, musicNameList[4]
            invoke TextOut,   _hDC, TEXTOUT2_X, TEXTOUT2_Y, musicNameList[4], eax
            invoke strlen, musicNameList[8]
            invoke TextOut,   _hDC, TEXTOUT3_X, TEXTOUT3_Y, musicNameList[8], eax
            mov    eax, @hDcPen
        .elseif globalCurrentPage == PLAY_PAGE 
            invoke SetBkMode, _hDC, TRANSPARENT
            mov    ebx, 255
            invoke obtainRGB, ebx, ebx, ebx
            invoke SetTextColor, _hDC, eax
            ;SONGTEXT
            mov esi, globalPCurLevel
            invoke strlen, addr (Level ptr [esi]).musicName
            invoke TextOut, _hDC, SONGTEXT_X, SONGTEXT_Y, addr (Level ptr [esi]).musicName, eax
            ;MUSICIANTEXT
            mov esi, globalPCurLevel
            invoke strlen, addr (Level ptr [esi]).author
            invoke TextOut, _hDC, MUSICIANTEXT_X, MUSICIANTEXT_Y, addr (Level ptr [esi]).author, eax
            ;SCORETEXT
            invoke GameLevelCalcScore
            invoke sprintf, offset tmp_str, offset scoreFmt, eax
            invoke strlen, offset tmp_str
            invoke TextOut, _hDC, SCORETEXT_X, SCORETEXT_Y, offset tmp_str, eax
            ;PERFECTTEXT
            mov esi, offset globalLevelRecord.tapJudgesCount
            mov ebx, [esi]
            add ebx, [esi+4]
            add ebx, [esi+8]
            mov esi, offset globalLevelRecord.catchJudgeCount
            add ebx, [esi]
            invoke sprintf, offset tmp_str, offset num2str, ebx
            invoke strlen, offset tmp_str
            invoke TextOut, _hDC, PERFECTTEXT_X, PERFECTTEXT_Y, offset tmp_str, eax
            ;GREATTEXT
            mov esi, offset globalLevelRecord.tapJudgesCount
            mov ebx, [esi+12]
            add ebx, [esi+16]
            invoke sprintf, offset tmp_str, offset num2str, ebx
            invoke strlen, offset tmp_str
            invoke TextOut, _hDC, GREATTEXT_X, GREATTEXT_Y, offset tmp_str, eax
            ;MISSTEXT
            mov esi, offset globalLevelRecord.tapJudgesCount
            mov ebx, [esi+20]
            mov esi, offset globalLevelRecord.catchJudgeCount
            add ebx, [esi+4]
            invoke sprintf, offset tmp_str, offset num2str, ebx
            invoke strlen, offset tmp_str
            invoke TextOut, _hDC, MISSTEXT_X, MISSTEXT_Y, offset tmp_str, eax
            ;COVER
            invoke	CreateCompatibleDC, _hDC; 创建与_hDC兼容的另一个DC(设备上下文)，以备后续操作
		    mov		@hDcBack, eax
            mov esi, globalPCurLevelResources
            invoke SelectObject, @hDcBack, (LevelResources ptr [esi]).playImage
            mov @hOldObject, eax
            invoke BitBlt, _hDC, PLAY_COVER_X, PLAY_COVER_Y, \
                 PLAY_COVER_WIDTH, PLAY_COVER_HEIGHT, @hDcBack, 0, 0, SRCCOPY
            invoke SelectObject, @hDcBack, @hOldObject
		    invoke DeleteDC, @hDcBack

            invoke timeGetTime
            sub eax, globalLevelBeginTime
            mov @currentTime, eax
            mov ecx, GAME_KEY_COUNT
GameDraw_L1:
            mov edx, GAME_KEY_COUNT
            sub edx, ecx
            push ecx
            invoke GameDrawNotes, _hDC, edx, @currentTime
            pop ecx
            loop GameDraw_L1
        .elseif globalCurrentPage == RESULT_PAGE
            invoke	CreateCompatibleDC, _hDC; 创建与_hDC兼容的另一个DC(设备上下文)，以备后续操作
		    mov		@hDcBack, eax
            mov esi, globalPCurLevelResources
            invoke SelectObject, @hDcBack, (LevelResources ptr [esi]).image
            mov @hOldObject, eax
            invoke BitBlt, _hDC, RESULT_COVER_X, RESULT_COVER_Y, \
                RESULT_COVER_WIDTH, RESULT_COVER_HEIGHT, @hDcBack, 0, 0, SRCCOPY
            invoke SelectObject, @hDcBack, @hOldObject
		    invoke DeleteDC, @hDcBack
            invoke SetBkMode, _hDC, TRANSPARENT
            mov    ebx, 255
            invoke obtainRGB, ebx, ebx, ebx
            invoke SetTextColor, _hDC, eax
            ;TAP_CRITICAL_PERFECT
            mov edx, globalLevelRecord.tapJudgesCount[0]
            invoke sprintf, offset tmp_str, offset num2str, edx
            invoke strlen, offset tmp_str
            invoke TextOut,   _hDC, RECORD_X, TAP_CRITICAL_PERFECT_Y, offset tmp_str, eax
            ;TAP_PERFECT
            mov edx, globalLevelRecord.tapJudgesCount[4]
            add edx, globalLevelRecord.tapJudgesCount[8]
            invoke sprintf, offset tmp_str, offset num2str, edx
            invoke strlen, offset tmp_str
            invoke TextOut,   _hDC, RECORD_X, TAP_PERFECT_Y, offset tmp_str, eax
            ;TAP_PERFECT_EARLY
            mov edx, globalLevelRecord.tapJudgesCount[4]
            invoke sprintf, offset tmp_str, offset num2str, edx
            invoke strlen, offset tmp_str
            invoke TextOut,   _hDC, RECORD_X, TAP_PERFECT_EARLY_Y, offset tmp_str, eax
            ;TAP_PERFECT_LATE_Y
            mov edx, globalLevelRecord.tapJudgesCount[8]
            invoke sprintf, offset tmp_str, offset num2str, edx
            invoke strlen, offset tmp_str
            invoke TextOut,   _hDC, RECORD_X, TAP_PERFECT_LATE_Y, offset tmp_str, eax
            ;TAP_GREAT
            mov edx, globalLevelRecord.tapJudgesCount[12]
            add edx, globalLevelRecord.tapJudgesCount[16]
            invoke sprintf, offset tmp_str, offset num2str, edx
            invoke strlen, offset tmp_str
            invoke TextOut,   _hDC, RECORD_X, TAP_GREAT_Y, offset tmp_str, eax
            ;TAP_GREAT_EARLY
            mov edx, globalLevelRecord.tapJudgesCount[12]
            invoke sprintf, offset tmp_str, offset num2str, edx
            invoke strlen, offset tmp_str
            invoke TextOut,   _hDC, RECORD_X, TAP_GREAT_EARLY_Y, offset tmp_str, eax
            ;TAP_GREAT_LATE
            mov edx, globalLevelRecord.tapJudgesCount[16]
            invoke sprintf, offset tmp_str, offset num2str, edx
            invoke strlen, offset tmp_str
            invoke TextOut,   _hDC, RECORD_X, TAP_GREAT_LATE_Y, offset tmp_str, eax
            ;TAP_MISS
            mov edx, globalLevelRecord.tapJudgesCount[20]
            invoke sprintf, offset tmp_str, offset num2str, edx
            invoke strlen, offset tmp_str
            invoke TextOut,   _hDC, RECORD_X, TAP_MISS_Y, offset tmp_str, eax
            ;CATCH_CRITICAL_PERFECT
            mov edx, globalLevelRecord.catchJudgeCount[0]
            invoke sprintf, offset tmp_str, offset num2str, edx
            invoke strlen, offset tmp_str
            invoke TextOut,   _hDC, RECORD_X, CATCH_CRITICAL_PERFECT_Y, offset tmp_str, eax
            ;CATCH_MISS
            mov edx, globalLevelRecord.catchJudgeCount[4]
            invoke sprintf, offset tmp_str, offset num2str, edx
            invoke strlen, offset tmp_str
            invoke TextOut,   _hDC, RECORD_X, CATCH_MISS_Y, offset tmp_str, eax
            ;SCORE
            mov    ebx, 0
            invoke obtainRGB, ebx, ebx, ebx
            invoke SetTextColor, _hDC, eax
            invoke GameLevelCalcScore
            mov edx, eax
            invoke sprintf, offset tmp_str, offset scoreFmt, edx
            invoke strlen, offset tmp_str
            invoke TextOut,   _hDC, SCORE_X, SCORE_Y, offset tmp_str, eax

            mov    eax, @hDcPen
        .endif
		ret
GameDraw	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameDrawNotes
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameDrawNotes proc uses ecx edx esi edi, hDC: dword, keyi: dword, currentTime: dword
    local @noteCount: dword
    local @i: dword
    local @pTheNote: ptr LevelNote
    local @pTheRecord: ptr LevelNoteRecord

    mov esi, globalPCurLevel
    add esi, type Level
    ; globalPCurLevel->noteCounts
    sub esi, GAME_KEY_COUNT * type dword + GAME_KEY_COUNT * MAX_NOTE_LENGTH * type LevelNote
    mov ecx, keyi
    shl ecx, 2
    add esi, ecx
    mov eax, [esi]
    mov @noteCount, eax

    mov esi, offset globalLevelRecord
    mov ecx, keyi
    shl ecx, 2
    add esi, ecx
    mov edx, [esi]
    mov @i, edx

    mov eax, GAME_KEY_COUNT
    sub eax, keyi
    mov ecx, MAX_NOTE_LENGTH
    mul ecx
    sub eax, @i
    mov ecx, 8
    mul ecx
    mov esi, globalPCurLevel
    add esi, type Level
    sub esi, eax
    mov @pTheNote, esi
    mov edi, offset globalLevelRecord
    add edi, type LevelRecord
    sub edi, eax
    mov @pTheRecord, edi

GameDrawNotes_L1:
    mov eax, @i
    test eax, eax
    jz GameDrawNotes_L1_Exit
    dec eax
    mov @i, eax
    sub esi, type LevelNote
    sub edi, type LevelNoteRecord
    mov @pTheNote, esi
    mov @pTheRecord, edi

    mov eax, (LevelNoteRecord ptr [edi]).judgement
    .if eax == NOTE_JUDGE_MISS
        invoke GameDrawOneNote, hDC, keyi, @pTheNote, currentTime
        jmp GameDrawNotes_L1
    .else
        mov edx, currentTime
        sub edx, (LevelNoteRecord ptr [edi]).judgeTime
        invoke GameDrawEffect, hDC, keyi, (LevelNote ptr [esi]).NoteType, edx
        test eax, eax
        jnz GameDrawNotes_L1
    .endif
    mov esi, @pTheNote
    mov edi, @pTheRecord
GameDrawNotes_L1_Exit:

    mov esi, offset globalLevelRecord
    mov ecx, keyi
    shl ecx, 2
    add esi, ecx
    mov edx, [esi]
    mov @i, edx

    mov eax, GAME_KEY_COUNT
    sub eax, keyi
    mov ecx, MAX_NOTE_LENGTH
    mul ecx
    sub eax, @i
    mov ecx, type LevelNote
    mul ecx
    mov esi, globalPCurLevel
    add esi, type Level
    sub esi, eax
    mov @pTheNote, esi

    mov eax, @i
GameDrawNotes_L2:
    cmp eax, @noteCount
    jge GameDrawNotes_L2_Exit
    invoke GameDrawOneNote, hDC, keyi, esi, currentTime
    test eax, eax
    jz GameDrawNotes_L2_Exit

    mov eax, @i
    inc eax
    mov @i, eax
    mov esi, @pTheNote
    add esi, type LevelNote
    mov @pTheNote, esi
    jmp GameDrawNotes_L2
GameDrawNotes_L2_Exit:
    ret
GameDrawNotes endp

GameUpdateSelect proc uses ecx edx esi edi
    local @i: dword

    mov esi, globalLevels
    mov ecx, globalCurrentLevelID
    mov eax, ecx
    mov edx, type Level
    mul edx
    add esi, eax
    mov edi, offset musicNameList
    mov [edi + 4], esi
    inc ecx
    .if ecx == globalLevelCount
        mov esi, globalLevels
    .else
        add esi, type Level
    .endif
    mov [edi + 8], esi

    mov eax, globalCurrentLevelID
    mov esi, globalLevels
    .if eax == 0
        mov eax, globalLevelCount
    .endif
    dec eax
    mov edx, type Level
    mul edx
    add esi, eax
    mov [edi], esi

    mov eax, globalCurrentLevelID
    mov esi, globalLevels
    mov edx, type Level
    mul edx
    add esi, eax
    mov globalPCurLevel, esi

    mov eax, globalCurrentLevelID
    mov esi, globalLevelResources
    mov edx, type LevelResources
    mul edx
    add esi, eax
    mov globalPCurLevelResources, esi
    invoke AudioPlay, (LevelResources ptr [esi]).musicDeviceID, 0
    ret
GameUpdateSelect endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameKeyCallback
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameKeyCallback     proc       uses eax ecx esi,        keyCode:byte, down:byte, previousDown:byte
    local @index
    ;@@@@@@@@@@@@@@@@@@@@@ 主页 @@@@@@@@@@@@@@@@@@@@@
    .if globalCurrentPage == INIT_PAGE
        .if (keyCode == 'H') && down
            mov eax, settings
            .if eax == 0
                mov settings, 1
                invoke  GetModuleHandle, NULL
                invoke	DialogBoxParam, eax, DLG_MAIN, NULL, offset _ProcDlgMain,NULL
            .endif
        .elseif (keyCode == 'J') && down
            mov globalCurrentPage, SELECT_PAGE
            invoke GameUpdateSelect
        .endif
    ;@@@@@@@@@@@@@@@@@@@@@ 选歌 @@@@@@@@@@@@@@@@@@@@@
    .elseif globalCurrentPage == SELECT_PAGE
        .if (keyCode == VK_RETURN) && down
            mov globalCurrentPage, PLAY_PAGE
            mov esi, globalPCurLevelResources
            invoke AudioStop, (LevelResources ptr [esi]).musicDeviceID
            invoke GameLevelReset
        .elseif (keyCode == VK_ESCAPE) && down
            mov globalCurrentPage, INIT_PAGE
            mov esi, globalPCurLevelResources
            invoke AudioStop, (LevelResources ptr [esi]).musicDeviceID
        .endif
    ;@@@@@@@@@@@@@@@@@@@@@ Play @@@@@@@@@@@@@@@@@@@@@
    .elseif globalCurrentPage == PLAY_PAGE
        mov eax, 0
GameKeyCallback_L2:
        mov edx, GAME_KEY_COUNT
        cmp eax, edx
        jge GameKeyCallback_L2_Exit
        mov @index, eax
        mov esi, offset globalKeyMaps
        add esi, eax
        mov al, byte ptr [esi]
        .if al == keyCode
            .if down
                mov esi, offset globalKeyPressing
                add esi, @index
                mov byte ptr [esi], 1
                mov al, previousDown
                .if al == 0; if (!previousDown)
                    mov esi, offset globalKeyPressTime
                    mov eax, @index
                    shl eax, 2; sizeof dword = 4
                    add esi, eax
                    push esi
                    invoke timeGetTime
                    sub eax, globalLevelBeginTime
                    pop esi
                    mov [esi], eax
                    invoke NoteTapJudgement, @index, eax
                .endif
            .else
                mov esi, offset globalKeyPressing
                add esi, @index
                mov al, [esi]
                .if al > 0
                    mov byte ptr [esi], 0
                    invoke timeGetTime
                    sub eax, globalLevelBeginTime
                    invoke NoteCatchJudgement, @index, eax
                .endif
            .endif
            ret
        .endif
        mov eax, @index
        inc eax
        jmp GameKeyCallback_L2
GameKeyCallback_L2_Exit:
        mov al, VK_ESCAPE
        .if (al == keyCode) && down
            mov globalCurrentPage, RESULT_PAGE
            mov esi, globalPCurLevelResources
            invoke AudioStop, (LevelResources ptr [esi]).musicDeviceID
        .endif
    ;@@@@@@@@@@@@@@@@@@@@@ 结算 @@@@@@@@@@@@@@@@@@@@@
    .elseif globalCurrentPage == RESULT_PAGE
        mov al, VK_ESCAPE
        .if (al == keyCode) && down
            mov globalCurrentPage, SELECT_PAGE
            invoke GameUpdateSelect
        .endif
    .endif
    ret
GameKeyCallback     endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; _ProcDlgMain
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcDlgMain	proc	uses ebx edi esi hWnd, wMsg, wParam, lParam
		local	@lpTranslated:byte, @bSigned:byte
        local   @lpString[2]:byte 
        mov	eax,wMsg
        mov @bSigned, 0
;********************************************************************
		.if	eax ==	WM_COMMAND
            mov	eax,wParam
			.if	ax ==	IDOK
                invoke GetDlgItemInt, hWnd, DLG_SPEED, addr @lpTranslated, @bSigned
                mov globalSpeedLevel, eax
                invoke GetDlgItemInt, hWnd, DLG_DELAY, addr @lpTranslated, @bSigned
                mov globalJudgeDelay, eax
                invoke GetDlgItemText, hWnd, DLG_KEY1, addr @lpString, 2
                mov esi, offset globalKeyMaps
                mov al, @lpString[0]
                mov byte ptr [esi], al
                inc esi
                invoke GetDlgItemText, hWnd, DLG_KEY2, addr @lpString, 2
                mov al, @lpString[0]
                mov byte ptr [esi], al
                inc esi
                invoke GetDlgItemText, hWnd, DLG_KEY3, addr @lpString, 2
                mov al, @lpString[0]
                mov byte ptr [esi], al
                inc esi
                invoke GetDlgItemText, hWnd, DLG_KEY4, addr @lpString, 2
                mov al, @lpString[0]
                mov byte ptr [esi], al
                invoke CloseHandle, hEvent
                invoke EndDialog, hWnd, NULL
                mov eax, 0
                mov settings, eax
            .elseif	ax ==	IDC_CANCEL
                invoke CloseHandle, hEvent
                invoke EndDialog, hWnd, NULL
                mov eax, 0
                mov settings, eax
            .endif
;********************************************************************
		.elseif	eax ==	WM_CLOSE
			invoke	CloseHandle, hEvent
			invoke	EndDialog, hWnd, NULL
            mov eax, 0
            mov settings, eax
;********************************************************************
		.elseif	eax ==	WM_INITDIALOG
            invoke SetDlgItemInt, hWnd, DLG_SPEED, globalSpeedLevel, @bSigned
            invoke SetDlgItemInt, hWnd, DLG_DELAY, globalJudgeDelay, @bSigned
            mov eax, 0
            mov @lpString[1], al
            mov esi, offset globalKeyMaps
            mov al, [esi]
            mov @lpString[0], al
            invoke SetDlgItemText, hWnd, DLG_KEY1, addr @lpString
            mov al, [esi + 1]
            mov @lpString[0], al
            invoke SetDlgItemText, hWnd, DLG_KEY2, addr @lpString
            mov al, [esi + 2]
            mov @lpString[0], al
            invoke SetDlgItemText, hWnd, DLG_KEY3, addr @lpString
            mov al, [esi + 3]
            mov @lpString[0], al
            invoke SetDlgItemText, hWnd, DLG_KEY4, addr @lpString
;********************************************************************
		.else
            mov	eax,FALSE
			ret
        .endif
        mov eax, TRUE
		ret
_ProcDlgMain	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; changeQueue
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameMouseWheelCallback proc	uses edx esi, degree:sword
        .if globalCurrentPage != SELECT_PAGE
            ret
        .endif
        mov edx, 0
        mov eax, globalCurrentLevelID
        .if degree == -120
            inc eax
            .if eax == globalLevelCount
                mov eax, 0
            .endif
        .elseif degree == 120
            .if eax == 0
                mov eax, globalLevelCount
            .endif
            dec eax
        .endif
        mov globalCurrentLevelID, eax
        mov esi, globalPCurLevelResources
        invoke AudioStop, (LevelResources ptr [esi]).musicDeviceID
        invoke GameUpdateSelect
        ret
GameMouseWheelCallback endp
end
