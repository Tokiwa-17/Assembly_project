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
;include     Irvine32.inc

include     audio.inc
include 	game.inc
include     audio.inc
include     config.inc
include     level.inc

extern hInstance:dword
extern hMainWin:dword
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; data
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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
globalCurLevelMusicID dword   0
globalLevelResetTime  dword   0
globalLevelBeginTime  dword   0
globalLevelRecord     LevelRecord       <>  
globalKeyPressing     db      GAME_KEY_COUNT      DUP(0)
globalKeyPressTime    dword   GAME_KEY_COUNT      DUP(0)

_bg1            dword       0
_bg2            dword       0
_bg3            dword       0

music_play      dword       1
wDeviceID       dword       0
settings        dword       0
hEvent          dd          0
musicNameList   dd          QUEUE_LENGTH        DUP(0)

.const
Cyaegha         db  "levels\Cyaegha.level", 0
Sheriruth       db  "levels\Sheriruth.level", 0
musicName1      db  "Cyaegha", 0
musicName2      db  "Sheriruth", 0
musicName3      db  "TODO", 0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.code
memset proto C :ptr byte, :dword, :dword

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; NoteTapJudgement
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
NoteTapJudgement proc  uses  esi ecx,  index
    local @curIndex
    local @judgeTime
    local @note
    local @record
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
    mov esi, globalPCurLevel
    add esi, sizeof Level
;   (globalPCurLevel)->notes[index][curIndex]
    mov eax, GAME_KEY_COUNT
    sub eax, index
    mov ecx, MAX_NOTE_LENGTH
    mul ecx
    add eax, @curIndex
    mov ecx, sizeof LevelNote
    mul ecx
    sub esi, eax
    mov @note, esi
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   LevelNoteRecord *record = &((sGame.levelRecord).records[index][curIndex])
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, offset globalLevelRecord
    add esi, sizeof LevelRecord
    sub esi, eax
    mov @record, esi
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;  (note->type == NOTE_CATCH)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @note
    mov eax, (LevelNote PTR  [esi]).NoteType
    mov esi, NOTE_CATCH
    cmp eax, esi
    je  NoteTapJudgement_endWhile
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   Time diff = judgeTime - note->time;
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @note
    mov eax, @judgeTime
    sub eax, (LevelNote ptr [esi]).Time
    ; if (diff <= 0)
    .IF eax > 80000000h
        neg eax; -diff >= 0
        .IF eax <= NOTE_JUDGE_CRITICAL_PERFECT_LIMIT
            mov esi, @record
            mov eax, NOTE_JUDGE_CRITICAL_PERFECT
            mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSEIF eax <= NOTE_JUDGE_PERFECT_LIMIT
            mov esi, @record
            mov eax, NOTE_JUDGE_PERFECT_EARLY
            mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSEIF eax <= NOTE_JUDGE_GREAT_LIMIT
            mov esi, @record
            mov eax, NOTE_JUDGE_GREAT_EARLY
            mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSE
            jmp NoteTapJudgement_endWhile
        .ENDIF
    .ELSE
        .IF eax <= NOTE_JUDGE_CRITICAL_PERFECT_LIMIT
            mov esi, @record
            mov eax, NOTE_JUDGE_CRITICAL_PERFECT
            mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSEIF eax <= NOTE_JUDGE_PERFECT_LIMIT
            mov esi, @record
            mov eax, NOTE_JUDGE_PERFECT_LATE
            mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSEIF eax <= NOTE_JUDGE_GREAT_LIMIT
            mov esi, @record
            mov eax, NOTE_JUDGE_GREAT_LATE
            mov (LevelNoteRecord PTR [esi]).judgement, eax
        .ELSE
            mov esi, @record
            mov eax, NOTE_JUDGE_MISS
            mov (LevelNoteRecord PTR [esi]).judgement, eax
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
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   record->judgement != NOTE_JUDGE_MISS
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @record
    mov eax, (LevelNoteRecord PTR [esi]).judgement
    cmp eax, NOTE_JUDGE_MISS
    je NoteTapJudgement_beginWhile
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
    mov esi, globalPCurLevel
    add esi, sizeof Level
;   (globalPCurLevel)->notes[index][curIndex]
    mov eax, GAME_KEY_COUNT
    sub eax, index
    mov ecx, MAX_NOTE_LENGTH
    mul ecx
    add eax, @curIndex
    mov ecx, sizeof LevelNote
    mul ecx
    sub esi, eax
    mov @note, esi
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   LevelNoteRecord *record = &sGame.levelRecord.records[index][curIndex]
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, offset globalLevelRecord
    add esi, sizeof LevelRecord
    sub esi, eax
    mov @record, esi
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;  (note->type == NOTE_TAP)
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @note
    mov eax, (LevelNote PTR  [esi]).NoteType
    mov esi, NOTE_TAP
    cmp eax, esi
    je  NoteCatchJudgement_endWhile
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   currentTime + NOTE_JUDGE_PERFECT_LIMIT - note->time < 0 => break
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @note
    mov eax, (LevelNote PTR [esi]).Time
    mov esi, currentTime
    add esi, NOTE_JUDGE_PERFECT_LIMIT
    sub esi, eax
    cmp esi, 80000000h
    jge  NoteCatchJudgement_endWhile

    mov esi, @note
    mov eax, (LevelNote PTR [esi]).Time
    add eax, NOTE_JUDGE_PERFECT_LIMIT
    mov esi, offset globalKeyPressTime
    mov ecx, index
    shl ecx, 2
    add esi, ecx
    sub eax, [esi]
    ; note->time + NOTE_JUDGE_PERFECT_LIMIT - sGame.keyPressTime[index] >= 0
    .if eax < 80000000h
        mov esi, @note
        mov eax, (LevelNote PTR [esi]).Time
        mov esi, @record
        mov (LevelNoteRecord PTR [esi]).judgeTime, eax
        mov (LevelNoteRecord PTR [esi]).judgement, NOTE_JUDGE_CRITICAL_PERFECT
        mov esi, offset globalLevelRecord.catchJudgeCount
        inc dword ptr [esi]
    .else
        mov eax, currentTime
        mov esi, @record
        mov (LevelNoteRecord PTR [esi]).judgeTime, eax
        mov (LevelNoteRecord PTR [esi]).judgement, NOTE_JUDGE_MISS
        mov esi, offset globalLevelRecord.catchJudgeCount
        add esi, 4
        inc dword ptr [esi]
    .endif
    mov eax, @curIndex
    inc eax
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
    mov edx, 1000000
    mul edx

    mov esi, globalPCurLevel
    mov edx, (Level ptr [esi]).totalTapCount
    shl edx, 1
    mov ebx, edx
    mov edx, (Level ptr [esi]).totalCatchCount
    add ebx, edx

    div ebx
    mov esi, offset globalLevelRecord.tapJudgesCount
    add eax, [esi]
    ret
GameLevelCalcScore endp

GameInit proc
    local @hHeap

	invoke	LoadBitmap, hInstance, INIT_PAGE
	mov		_bg1, 	eax
	invoke	LoadBitmap, hInstance, SELECT_PAGE
	mov		_bg2, 	eax
	invoke	LoadBitmap, hInstance, PLAY_PAGE
	mov		_bg3, 	eax

    invoke GetProcessHeap
    mov @hHeap, eax
    invoke HeapAlloc, @hHeap, 0, 4 * type Level
    mov globalLevels, eax

    mov globalLevelCount, 2
    invoke LevelLoad, offset Cyaegha, globalLevels
    mov edi, globalLevels
    add edi, type Level
    invoke LevelLoad, offset Sheriruth, edi
    
    mov     esi,    offset  musicNameList
    mov     [esi],  offset  musicName1
    mov     [esi+4],offset  musicName2
    mov     [esi+8],offset  musicName3
	ret
GameInit endp

GameShutdown proc
    local @hHeap

    invoke GetProcessHeap
    mov @hHeap, eax
    invoke HeapFree, @hHeap, 0, globalLevels
    ret
GameShutdown endp

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameLevelReset
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameLevelReset proc uses eax ecx edx esi edi, levelIndex
    mov eax, levelIndex
    mov globalCurrentLevelID, eax
    mov esi, globalLevels
    mov edx, type Level
    mul edx
    add esi, eax
    mov globalPCurLevel, esi

    invoke memset, offset globalLevelRecord, 0, type LevelRecord
    mov ecx, GAME_KEY_COUNT
    mov edi, offset globalKeyPressing
GameLevelReset_L1:
    mov dword ptr [edi], FALSE
    add edi, 4
    loop GameLevelReset_L1

    mov globalLevelState, GAME_LEVEL_RESET
    invoke timeGetTime
    mov globalLevelResetTime, eax

    mov esi, globalPCurLevel
    invoke AudioOpen, addr (Level ptr [esi]).musicPath
    mov globalCurLevelMusicID, eax
    ret
GameLevelReset      endp

GameUpdate proc uses eax ecx edx esi
	local	@currentTime
    .if globalCurrentPage == PLAY_PAGE
        .if globalLevelState == GAME_LEVEL_RESET
            invoke timeGetTime
            mov edx, globalLevelResetTime
            sub eax, edx
            mov edx, GAME_LEVEL_WAIT_TIME
            .if eax >= edx
                invoke AudioOpen, globalCurLevelMusicID
                invoke timeGetTime
                mov globalLevelBeginTime, eax
                mov eax, globalJudgeDelay
                add globalLevelBeginTime, eax
                mov globalLevelState, GAME_LEVEL_PLAYING
            .endif
        .elseif globalLevelState == GAME_LEVEL_PLAYING
            invoke timeGetTime
            mov edx, globalLevelBeginTime
            sub eax, edx
            mov @currentTime, eax
            mov ecx, GAME_KEY_COUNT
GameUpdate_L1:
            mov eax, GAME_KEY_COUNT
            sub eax, ecx
            mov edx, eax
            shl eax, 2
            mov esi, offset globalKeyPressing
            add esi, eax
            mov eax, [esi]
            .if al > 0
                invoke NoteCatchJudgement, edx, @currentTime
            .endif
            loop GameUpdate_L1

            ; TODO: other play logic
        .endif
	.endif
	ret
GameUpdate endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameDraw
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Str_length  proc uses esi ebx, address:dword
    mov eax, 0
    mov esi, address
    .while  TRUE
        mov bl, byte ptr [esi]
        .break  .if bl == 0
        inc eax
        inc esi
    .endw
    ret
Str_length  endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameDraw
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameDraw	proc uses esi, _hDC
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
		invoke SelectObject, @hDcBack, @hOldObject
		invoke DeleteDC, @hDcBack
;       draw other stuff
        .if globalCurrentPage == INIT_PAGE

        .elseif globalCurrentPage == SELECT_PAGE
            invoke CreatePen, PS_SOLID, 4, WHITE_PEN
            ;mov hPen, eax 
            invoke Rectangle, _hDC, MUSIC1_X1, MUSIC1_Y1, MUSIC1_X2, MUSIC1_Y2
            invoke Rectangle, _hDC, MUSIC2_X1, MUSIC2_Y1, MUSIC2_X2, MUSIC2_Y2
            invoke Rectangle, _hDC, MUSIC3_X1, MUSIC3_Y1, MUSIC3_X2, MUSIC3_Y2
            mov esi, offset musicNameList
            invoke Str_length, [esi]
            invoke TextOut,   _hDC, TEXTOUT1_X, TEXTOUT1_Y, [esi], eax
            invoke Str_length, [esi + 4]
            invoke TextOut,   _hDC, TEXTOUT2_X, TEXTOUT2_Y, [esi + 4], eax
            invoke Str_length, [esi + 8]
            invoke TextOut,   _hDC, TEXTOUT3_X, TEXTOUT3_Y, [esi + 8], eax
        .elseif globalCurrentPage == PLAY_PAGE

        .endif
		ret
GameDraw	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameKeyCallback
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameKeyCallback     proc       uses eax ecx esi,        keyCode:byte, down:byte, previousDown:byte
    local @index
    ;@@@@@@@@@@@@@@@@@@@@@ 主页 @@@@@@@@@@@@@@@@@@@@@
    .if globalCurrentPage == INIT_PAGE
        .if keyCode == 'H'
            mov eax, settings
            cmp eax, 0
            jnz GameKeyCallback_L1
            mov settings, 1
            invoke  GetModuleHandle, NULL
            invoke	DialogBoxParam,eax,DLG_MAIN,NULL,offset _ProcDlgMain,NULL
GameKeyCallback_L1:
        .elseif keyCode == 'J'
            mov globalCurrentPage, SELECT_PAGE
            ;invoke AudioStop, wDeviceID
            ;invoke      AudioOpen, offset CyaeghaAudio
            ;invoke      AudioPlay, eax
        ;    mov globalCurrentPage, SELECT_PAGE
        .endif
    ;@@@@@@@@@@@@@@@@@@@@@ 选歌 @@@@@@@@@@@@@@@@@@@@@
    .elseif globalCurrentPage == SELECT_PAGE
        ; TODO
    ;@@@@@@@@@@@@@@@@@@@@@ Play @@@@@@@@@@@@@@@@@@@@@
    .elseif globalCurrentPage == PLAY_PAGE
        mov ecx, GAME_KEY_COUNT
GameKeyCallback_L2:
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
                    invoke NoteTapJudgement, @index
                .endif
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
        loop GameKeyCallback_L2
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
            .elseif	ax ==	IDC_CANCEL
                invoke CloseHandle, hEvent
                invoke EndDialog, hWnd, NULL
            .endif
;********************************************************************
		.elseif	eax ==	WM_CLOSE
			invoke	CloseHandle, hEvent
			invoke	EndDialog, hWnd, NULL
;********************************************************************
		.elseif	eax ==	WM_INITDIALOG
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
changeQueue     proc	uses ebx edi esi ecx, degree:sword
        .if globalCurrentPage != SELECT_PAGE
            ret
        .endif
        mov esi, offset musicNameList
        mov ecx, QUEUE_LENGTH
        dec ecx
        .if degree == 120
        mov esi, offset musicNameList
        mov eax, type dword
        mul ecx
        add esi, eax
        mov edi, [esi]
changeQueue_L1:
        mov esi, offset musicNameList
        mov ebx, ecx
        dec ebx
        mov eax, type dword
        mul ebx
        add esi, eax
        mov ebx, [esi]
        add esi, type dword
        mov [esi], ebx
        loop changeQueue_L1
        mov esi, offset musicNameList
        mov [esi], edi
        .elseif degree == -120
        mov esi, offset musicNameList
        mov edi, [esi]
changeQueue_L2:
        mov esi, offset musicNameList
        mov ebx, QUEUE_LENGTH
        sub ebx, ecx
        mov eax, type dword
        mul ebx
        add esi, eax
        mov eax, [esi]
        sub esi, type dword
        mov [esi], eax
        loop changeQueue_L2
        mov esi, offset musicNameList
        mov eax, type dword
        mov ebx, QUEUE_LENGTH - 1
        mul ebx
        add esi, eax
        mov [esi], edi        
        .endif
        ret
changeQueue     endp
end
