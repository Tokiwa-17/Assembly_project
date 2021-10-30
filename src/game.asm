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
printf          PROTO C :ptr sbyte, :VARARG

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
;        ///// state /////                ends
globalCurrentPage     dword   100
globalCurrentLevelID  dword   0
globalPCurLevel       dword   0
globalLevelState      dword   0
globalCurLevelMusicID dword   0
globalSelectDeviceID  dword   0
globalLevelResetTime  dword   0
globalLevelBeginTime  dword   0
globalLevelRecord     LevelRecord       <>  
globalKeyPressing     db      GAME_KEY_COUNT      DUP(0)
globalKeyPressTime    dword   GAME_KEY_COUNT      DUP(0)

_bg1            dword       0
_bg2            dword       0
_bg3            dword       0
_bg4            dword       0
_sel_cover0    dword       0
_sel_cover1     dword       0

_item1          dword       0

settings        dword       0
hEvent          dd          0
musicNameList   dd          QUEUE_LENGTH        DUP(0)
mci_1           dd          0
mci_2           dd          0
blendFunction   BLENDFUNCTION   <AC_SRC_OVER, 0, 0, AC_SRC_ALPHA>
tmp_str            db  0

.const
Cyaegha         db  "levels\Cyaegha.level", 0
Sheriruth       db  "levels\Sheriruth.level", 0
musicName1      db  "Cyaegha", 0
musicName2      db  "Sheriruth", 0
musicName3      db  "TODO", 0

num2str             db  "%d",0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.code
memset proto C :ptr byte, :dword, :dword

strcmp proto C :dword, :dword
sprintf proto C :ptr byte, :ptr byte, :VARARG
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
NoteCatchJudgement  proc uses esi ecx, index, currentTime
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

    mov ebx, (Level ptr [esi]).totalTapCount
    shl ebx, 1
    add ebx, (Level ptr [esi]).totalCatchCount
    div ebx
    mov esi, offset globalLevelRecord.tapJudgesCount
    add eax, [esi]
    ret
GameLevelCalcScore endp

GameInit proc uses edi esi edx
    local @hHeap

    mov globalSpeedLevel, 10
    mov globalJudgeDelay, 0

	invoke	LoadBitmap, hInstance, INIT_PAGE
	mov		_bg1, 	eax
	invoke	LoadBitmap, hInstance, SELECT_PAGE
	mov		_bg2, 	eax
	invoke	LoadBitmap, hInstance, PLAY_PAGE
	mov		_bg3, 	eax
    invoke  LoadBitmap, hInstance, RESULT_PAGE
    mov     _bg4,   eax
    invoke  LoadBitmap, hInstance, MUSIC_SELECT_0
    mov     _sel_cover0, eax
    invoke  LoadBitmap, hInstance, MUSIC_SELECT_1
    mov     _sel_cover1, eax

    invoke GameLoadNoteAssets

    invoke GetProcessHeap
    mov @hHeap, eax
    invoke HeapAlloc, @hHeap, 0, 4 * type Level
    mov globalLevels, eax

    mov globalLevelCount, 3
    mov globalCurrentLevelID, 1
    invoke LevelLoad, offset Cyaegha, globalLevels
    mov edi, globalLevels
    add edi, type Level
    invoke LevelLoad, offset Sheriruth, edi
    
    mov     esi,    offset  musicNameList
    mov     [esi],  offset  musicName1
    mov     [esi+4],offset  musicName2
    mov     [esi+8],offset  musicName3

    mov     esi,    offset  globalKeyMaps
    mov     al,     'F'
    mov     byte ptr [esi], al
    mov     al,     'G'
    mov     byte ptr [esi + 1], al
    mov     al,     'H'
    mov     byte ptr [esi + 2], al
    mov     al,     'J'
    mov     byte ptr [esi + 3], al

    mov esi, globalLevels
    invoke AudioOpen, addr (Level ptr [esi]).musicSelectPath
    mov mci_1, eax
    mov edx, type Level
    add esi, edx
    invoke AudioOpen, addr (Level ptr [esi]).musicSelectPath
    mov mci_2, eax
    mov globalSelectDeviceID, eax
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
GameLevelReset proc uses ecx edx esi edi
    mov eax, globalCurrentLevelID
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
GameLevelReset endp

GameUpdate proc uses ecx edx esi
	local	@currentTime
    .if globalCurrentPage == PLAY_PAGE
        .if globalLevelState == GAME_LEVEL_RESET
            invoke timeGetTime
            sub eax, globalLevelResetTime
            mov edx, GAME_LEVEL_WAIT_TIME
            .if eax >= edx
                invoke AudioPlay, globalCurLevelMusicID
                invoke timeGetTime
                add eax, globalJudgeDelay
                mov globalLevelBeginTime, eax
                mov globalLevelState, GAME_LEVEL_PLAYING
            .endif
        .elseif globalLevelState == GAME_LEVEL_PLAYING
            invoke timeGetTime
            sub eax, globalLevelBeginTime
            mov @currentTime, eax
            mov esi, globalPCurLevel
            mov edx, (Level ptr [esi]).totalTime
            .if eax < edx
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
                    push ecx
                    invoke NoteCatchJudgement, edx, @currentTime
                    pop ecx
                .endif
                loop GameUpdate_L1
            .else
                mov globalCurrentPage, RESULT_PAGE
            .endif
            ; TODO: other play logic
        .endif
	.endif
	ret
GameUpdate endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Str_length
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
        
        .elseif globalCurrentPage == RESULT_PAGE
            invoke  SelectObject, @hDcBack, _bg4

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
            .if     globalCurrentLevelID == 0
                invoke SelectObject, @hDcBack, _sel_cover0
                invoke BitBlt, _hDC, SELECT_COVER_X, SELECT_COVER_Y, \
                    SELECT_COVER_WIDTH, SELECT_COVER_HEIGHT, @hDcBack, 0, 0, SRCCOPY
            .elseif globalCurrentLevelID == 1
                invoke SelectObject, @hDcBack, _sel_cover1
                invoke BitBlt, _hDC, SELECT_COVER_X, SELECT_COVER_Y, \
                    SELECT_COVER_WIDTH, SELECT_COVER_HEIGHT, @hDcBack, 0, 0, SRCCOPY
            .endif
            invoke SelectObject, @hDcBack, @hOldObject
		    invoke DeleteDC, @hDcBack
            mov esi, offset musicNameList
            invoke SetBkMode, _hDC, TRANSPARENT
            mov    ebx, 255
            invoke obtainRGB, ebx, ebx, ebx
            invoke SetTextColor, _hDC, eax
            invoke Str_length, [esi]
            invoke TextOut,   _hDC, TEXTOUT1_X, TEXTOUT1_Y, [esi], eax
            invoke Str_length, [esi + 4]
            invoke TextOut,   _hDC, TEXTOUT2_X, TEXTOUT2_Y, [esi + 4], eax
            invoke Str_length, [esi + 8]
            invoke TextOut,   _hDC, TEXTOUT3_X, TEXTOUT3_Y, [esi + 8], eax
            mov    eax, @hDcPen
        .elseif globalCurrentPage == PLAY_PAGE 
            ;SONGTEXT
            mov esi, globalPCurLevel
            invoke Str_length, addr (Level ptr [esi]).musicName
            invoke TextOut, _hDC, SONGTEXT_X, SONGTEXT_Y, addr (Level ptr [esi]).musicName, eax
            ;MUSICIANTEXT
            invoke Str_length, addr (Level ptr [esi]).author
            invoke TextOut, _hDC, MUSICIANTEXT_X, MUSICIANTEXT_Y, addr (Level ptr [esi]).author, eax
            ;mov esi, offset musicName1
            ;invoke Str_length, esi
            ;invoke TextOut, _hDC, SONGTEXT_X, SONGTEXT_Y, esi, eax
            ;SCORETEXT
            call GameLevelCalcScore 
            mov ebx, eax
            mov esi, offset score ;这一行原因未知，似乎esi只是需要类似的初始化
            invoke sprintf, esi, addr spr, ebx
            invoke Str_length, esi
            invoke TextOut, _hDC, SCORETEXT_X, SCORETEXT_Y, esi, eax
            ;PERFECTTEXT
            mov esi, offset globalLevelRecord.tapJudgesCount
            mov ebx, [esi]
            add ebx, [esi+4]
            add ebx, [esi+8]
            mov esi, offset globalLevelRecord.catchJudgeCount
            add ebx, [esi]
            mov esi, offset score
            invoke sprintf, esi, addr spr, ebx
            invoke Str_length, esi
            invoke TextOut, _hDC, PERFECTTEXT_X, PERFECTTEXT_Y, esi, eax
            ;GREATTEXT
            mov esi, offset globalLevelRecord.tapJudgesCount
            mov ebx, [esi+12]
            add ebx, [esi+16]
            mov esi, offset score
            invoke sprintf, esi, addr spr, ebx
            invoke Str_length, esi
            invoke TextOut, _hDC, GREATTEXT_X, GREATTEXT_Y, esi, eax
            ;MISSTEXT
            mov esi, offset globalLevelRecord.tapJudgesCount
            mov ebx, [esi+20]
            mov esi, offset globalLevelRecord.catchJudgeCount
            add ebx, [esi+4]
            mov esi, offset score
            invoke sprintf, esi, addr spr, ebx
            invoke Str_length, esi
            invoke TextOut, _hDC, MISSTEXT_X, MISSTEXT_Y, esi, eax
            .if globalLevelState == GAME_LEVEL_PLAYING
                invoke GameDrawNotes, _hDC
            .endif
        .elseif globalCurrentPage == RESULT_PAGE
            invoke	CreateCompatibleDC, _hDC; 创建与_hDC兼容的另一个DC(设备上下文)，以备后续操作
		    mov		@hDcBack, eax
            .if     globalCurrentLevelID == 0
                invoke SelectObject, @hDcBack, _sel_cover0
                invoke BitBlt, _hDC, RESULT_COVER_X, RESULT_COVER_Y, \
                    RESULT_COVER_WIDTH, RESULT_COVER_HEIGHT, @hDcBack, 0, 0, SRCCOPY
            .elseif globalCurrentLevelID == 1
                invoke SelectObject, @hDcBack, _sel_cover1
                invoke BitBlt, _hDC, RESULT_COVER_X, RESULT_COVER_Y, \
                    RESULT_COVER_WIDTH, RESULT_COVER_HEIGHT, @hDcBack, 0, 0, SRCCOPY
            .endif
            invoke SelectObject, @hDcBack, @hOldObject
		    invoke DeleteDC, @hDcBack
            invoke SelectObject, @hDcBack, @hOldObject
		    invoke DeleteDC, @hDcBack
            invoke SetBkMode, _hDC, TRANSPARENT
            mov    ebx, 255
            invoke obtainRGB, ebx, ebx, ebx
            invoke SetTextColor, _hDC, eax
            ;TAP_CRITICAL_PERFECT
            mov edx, globalLevelRecord.tapJudgesCount[0]
            mov esi, offset tmp_str
            invoke sprintf, esi , offset num2str, edx
            invoke Str_length, esi
            invoke TextOut,   _hDC, RECORD_X, TAP_CRITICAL_PERFECT_Y, esi, eax
            ;TAP_PERFECT
            mov edx, globalLevelRecord.tapJudgesCount[4]
            add edi, globalLevelRecord.tapJudgesCount[8]
            mov esi, offset tmp_str
            invoke sprintf, esi , offset num2str, edx
            invoke Str_length, esi
            invoke TextOut,   _hDC, RECORD_X, TAP_PERFECT_Y, esi, eax
            ;TAP_PERFECT_EARLY
            mov edx, globalLevelRecord.tapJudgesCount[4]
            mov esi, offset tmp_str
            invoke sprintf, esi , offset num2str, edx
            invoke Str_length, esi
            invoke TextOut,   _hDC, RECORD_X, TAP_PERFECT_EARLY_Y, esi, eax
            ;TAP_PERFECT_LATE_Y
            mov edx, globalLevelRecord.tapJudgesCount[8]
            mov esi, offset tmp_str
            invoke sprintf, esi , offset num2str, edx
            invoke Str_length, esi
            invoke TextOut,   _hDC, RECORD_X, TAP_PERFECT_LATE_Y, esi, eax
            ;TAP_GREAT
            mov edx, globalLevelRecord.tapJudgesCount[12]
            add edi, globalLevelRecord.tapJudgesCount[16]
            mov esi, offset tmp_str
            invoke sprintf, esi , offset num2str, edx
            invoke Str_length, esi
            invoke TextOut,   _hDC, RECORD_X, TAP_GREAT_Y, esi, eax
            ;TAP_GREAT_EARLY
            mov edx, globalLevelRecord.tapJudgesCount[12]
            mov esi, offset tmp_str
            invoke sprintf, esi , offset num2str, edx
            invoke Str_length, esi
            invoke TextOut,   _hDC, RECORD_X, TAP_GREAT_EARLY_Y, esi, eax
            ;TAP_GREAT_LATE
            mov edx, globalLevelRecord.tapJudgesCount[16]
            mov esi, offset tmp_str
            invoke sprintf, esi , offset num2str, edx
            invoke Str_length, esi
            invoke TextOut,   _hDC, RECORD_X, TAP_GREAT_LATE_Y, esi, eax
            ;TAP_MISS
            mov edx, globalLevelRecord.tapJudgesCount[20]
            mov esi, offset tmp_str
            invoke sprintf, esi , offset num2str, edx
            invoke Str_length, esi
            invoke TextOut,   _hDC, RECORD_X, TAP_MISS_Y, esi, eax
            ;CATCH_CRITICAL_PERFECT
            mov edx, globalLevelRecord.catchJudgeCount[0]
            mov esi, offset tmp_str
            invoke sprintf, esi , offset num2str, edx
            invoke Str_length, esi
            invoke TextOut,   _hDC, RECORD_X, CATCH_CRITICAL_PERFECT_Y, esi, eax
            ;CATCH_MISS
            mov edx, globalLevelRecord.catchJudgeCount[4]
            mov esi, offset tmp_str
            invoke sprintf, esi , offset num2str, edx
            invoke Str_length, esi
            invoke TextOut,   _hDC, RECORD_X, CATCH_MISS_Y, esi, eax
            
            ;TODO: 调用分数计算函数会闪退，暂未解决
            ; call GameLevelCalcScore
            mov edx, eax
            mov esi, offset tmp_str
            invoke sprintf, esi , offset num2str, edx
            invoke Str_length, esi

            invoke TextOut,   _hDC, SCORE_X, SCORE_Y, esi, eax

            mov    eax, @hDcPen
        .endif
		ret
GameDraw	endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameDrawNotes
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameDrawNotes proc hDC: dword
    local @currentTime: dword
    local @keyi: dword
    local @pRecords: ptr LevelNoteRecord
    local @pCurrentID: ptr dword
    local @pTheRecord: ptr LevelNoteRecord
    local @pNotes: ptr LevelNote
    local @pNoteCount: ptr dword
    local @pTheNote: ptr LevelNote
    local @i: dword
    invoke timeGetTime
    sub eax, globalLevelBeginTime
    mov @currentTime, eax
    mov @keyi, 0
    mov esi, offset globalLevelRecord
    mov @pCurrentID, esi
    add esi, type LevelRecord
    sub esi, GAME_KEY_COUNT * MAX_NOTE_LENGTH * type LevelNoteRecord
    mov @pRecords, esi
    mov esi, globalPCurLevel
    add esi, type Level
    sub esi, GAME_KEY_COUNT * MAX_NOTE_LENGTH * type LevelNote
    mov @pNotes, esi
    sub esi, GAME_KEY_COUNT * type dword
    mov @pNoteCount, esi
GameDrawNotes_L1:
    mov esi, @pCurrentID
    mov eax, [esi]
    mov @i, eax
    mov edx, 8; type LevelNote, type LevelNoteRecord
    mul edx
    mov edx, @pRecords
    add edx, eax
    mov @pTheRecord, edx 
    mov edx, @pNotes
    add edx, eax
    mov @pTheNote, edx
GameDrawNotes_L2:
    mov eax, @i
    test eax, eax
    jz GameDrawNotes_L2_Exit
    dec eax
    mov @i, eax
    mov eax, @pTheRecord
    sub eax, type LevelNoteRecord
    mov @pTheRecord, eax
    mov eax, @pTheNote
    sub eax, type LevelNote
    mov @pTheNote, eax

    mov esi, @pTheRecord
    mov eax, (LevelNoteRecord ptr [esi]).judgement
    cmp eax, NOTE_JUDGE_MISS
    je GameDrawNotes_L2
    mov edx, @currentTime
    sub edx, (LevelNoteRecord ptr [esi]).judgeTime
    mov esi, @pTheNote
    invoke GameDrawEffect, hDC, @keyi, (LevelNote ptr [esi]).NoteType, edx
    test eax, eax
    jnz GameDrawNotes_L2
GameDrawNotes_L2_Exit:
    mov esi, @pCurrentID
    mov eax, [esi]
    mov @i, eax
    mov edx, type LevelNote
    mul edx
    mov edx, @pNotes
    add edx, eax
    mov @pTheNote, edx
    mov eax, @i
    mov esi, @pNoteCount
    mov edx, @pTheNote
GameDrawNotes_L3:
    cmp eax, [esi]
    jge GameDrawNotes_L3_Exit
    invoke GameDrawOneNote, hDC, @keyi, edx, @currentTime
    test eax, eax
    jz GameDrawNotes_L3_Exit

    mov eax, @i
    inc eax
    mov @i, eax
    mov esi, @pNoteCount
    add esi, type dword
    mov @pNoteCount, esi
    mov edx, @pTheNote
    add edx, type LevelNote
    mov @pTheNote, edx
    jmp GameDrawNotes_L3
GameDrawNotes_L3_Exit:
    mov esi, @pCurrentID
    add esi, type dword
    mov @pCurrentID, esi
    mov esi, @pRecords
    add esi, MAX_NOTE_LENGTH * type LevelNoteRecord
    mov @pRecords, esi
    mov esi, @pNotes
    add esi, MAX_NOTE_LENGTH * type LevelNote
    mov @pNotes, esi
    mov eax, @keyi
    inc eax
    mov @keyi, eax
    cmp eax, GAME_KEY_COUNT
    jl GameDrawNotes_L1
    ret
GameDrawNotes endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; GameKeyCallback
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
GameKeyCallback     proc       uses eax ecx esi,        keyCode:byte, down:byte, previousDown:byte
    local @index
    ;@@@@@@@@@@@@@@@@@@@@@ 主页 @@@@@@@@@@@@@@@@@@@@@
    .if globalCurrentPage == INIT_PAGE
        .if keyCode == 'H'
            mov eax, settings
            .if eax == 0
                mov settings, 1
                invoke  GetModuleHandle, NULL
                invoke	DialogBoxParam, eax, DLG_MAIN, NULL, offset _ProcDlgMain,NULL
            .endif
        .elseif keyCode == 'J'
            mov globalCurrentPage, SELECT_PAGE
            invoke AudioPlay, globalSelectDeviceID
        ;;;;;;;;;;;;;DEBUG;;;;;;;;;;;;;;;
        .elseif keyCode == 'F'
            mov globalCurrentPage, RESULT_PAGE
        ;;;;;;;;;;;;;DEBUG;;;;;;;;;;;;;;;
        .endif
    ;@@@@@@@@@@@@@@@@@@@@@ 选歌 @@@@@@@@@@@@@@@@@@@@@
    .elseif globalCurrentPage == SELECT_PAGE
        .if keyCode == 'H'
            mov globalCurrentPage, PLAY_PAGE
            invoke AudioStop, globalSelectDeviceID
            invoke GameLevelReset
        .endif 
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
                mov byte ptr [esi], 0
                invoke timeGetTime
                sub eax, globalLevelBeginTime
                invoke NoteCatchJudgement, @index, eax
            .endif
            ret
        .endif
        loop GameKeyCallback_L2
    ;@@@@@@@@@@@@@@@@@@@@@ 结算 @@@@@@@@@@@@@@@@@@@@@
    .elseif globalCurrentPage == RESULT_PAGE

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
changeQueue     proc	uses ebx edi esi ecx edx, degree:sword
        local @mci_1, @mci_2
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
                dec eax
            .else
                dec eax
            .endif
        .endif
        mov globalCurrentLevelID, eax
        div globalLevelCount
        mov globalCurrentLevelID, edx 

        .if globalCurrentLevelID == 2
            invoke AudioStop, globalSelectDeviceID
            ;mov globalSelectDeviceID, 0
            jmp changeQueue_L3
        .endif 
        invoke AudioStop, globalSelectDeviceID
        .if globalCurrentLevelID == 0
            invoke AudioPlay, mci_1
            mov eax, mci_1
            mov globalSelectDeviceID, eax
        .elseif globalCurrentLevelID == 1
            invoke AudioPlay, mci_2
            mov eax, mci_2
            mov globalSelectDeviceID, eax
        .endif
changeQueue_L3:
        ret
changeQueue     endp
end
