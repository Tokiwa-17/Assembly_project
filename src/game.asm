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
includelib msvcrt.lib

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

.const
Cyaegha         db  "levels\Cyaegha.level", 0
CyaeghaAudio    db  "Cyaegha.wav", 0
SheriruthAudio  db  "Sheriruth.wav", 0
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
    jz  NoteTapJudgement_endWhile
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   judgeTime > note->time
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mov esi, @note
    mov eax, (LevelNote PTR [esi]).Time
    mov esi, @judgeTime
    .IF esi > eax
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   Time diff = judgeTime - note->time;
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
GameLevelReset proc uses eax ecx edi, levelIndex
    mov eax, levelIndex
    mov globalCurrentLevelID, eax
    ; TODO: sGame.pCurLevel = &sGame.levels[levelIndex];

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
        .if keyCode == 'H'
                mov eax, settings
                cmp eax, 0
                jnz GameUpdate_L1
            mov settings, 1
            invoke  GetModuleHandle, NULL
            invoke	DialogBoxParam,eax,DLG_MAIN,NULL,offset _ProcDlgMain,NULL
GameUpdate_L1:
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
        loop GameKeyCallback_L1
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
end
