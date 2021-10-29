.386
.model flat,stdcall
option casemap:none

include		windows.inc
include		gdi32.inc
includelib	gdi32.lib
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib
include 	winmm.inc
includelib	winmm.lib
include     msimg32.inc
includelib  msimg32.lib

include draw.inc
include config.inc
include game.inc

extern hInstance: dword
extern globalSpeedLevel: dword

.data
bmpTapEffect    dword       ?
bmpCatchEffect  dword       ?
animTapEffect   AnimationClip <>
animCatchEffect AnimationClip <>

.code
AnimationInit proc uses edx edi, image: dword, rows: dword, columns: dword, pClip: ptr AnimationClip
    local @bmpInfo: BITMAP
    mov eax, image
    mov edi, pClip
    mov (AnimationClip ptr [edi]).image, eax
    mov eax, rows
    mov (AnimationClip ptr [edi]).rows, eax
    mov eax, columns
    mov (AnimationClip ptr [edi]).columns, eax
    invoke GetObject, image, type BITMAP, addr @bmpInfo
    mov eax, @bmpInfo.bmWidth
    div columns
    mov edi, pClip
    mov (AnimationClip ptr [edi]).frameWidth, eax
    mov eax, @bmpInfo.bmHeight
    div rows
    mov (AnimationClip ptr [edi]).frameHeight, eax
    ret
AnimationInit endp

GameLoadNoteAssets proc
    invoke LoadBitmap, hInstance, TAP_EFFECT
    mov bmpTapEffect, eax
    invoke AnimationInit, bmpTapEffect, 4, 4, offset animTapEffect
    invoke LoadBitmap, hInstance, CATCH_EFFECT
    mov bmpCatchEffect, eax
    invoke AnimationInit, bmpCatchEffect, 4, 4, offset animCatchEffect
    ret
GameLoadNoteAssets endp

GameDrawEffect proc uses edx esi, hDC: dword, keyIndex: dword, noteType: dword, animTime: dword
    local @anim
    local @xarr[5]: dword
    local @dstX: dword
    local @dstY: dword
    local @dstW: dword
    local @dstH: dword
    local @srcX: dword
    local @srcY: dword
    local @hBmpDC: dword
    local @hOldObject: dword
    local @blendFn: BLENDFUNCTION

    mov eax, noteType
    .if eax == NOTE_TAP
        mov esi, offset animTapEffect
    .elseif eax == NOTE_CATCH
        mov esi, offset animCatchEffect
    .endif
    mov @anim, esi
    mov eax, (AnimationClip ptr [esi]).interval
    mul (AnimationClip ptr [esi]).rows
    mul (AnimationClip ptr [esi]).columns
    .if eax >= animTime
        mov eax, 0
        ret
    .endif

    mov eax, animTime
    div (AnimationClip ptr [esi]).interval
    div (AnimationClip ptr [edi]).columns
    mov @srcX, edx; column
    div (AnimationClip ptr [esi]).rows
    mov eax, edx; row
    mul (AnimationClip ptr [esi]).frameHeight
    mov @srcY, eax
    mov eax, @srcX
    mul (AnimationClip ptr [esi]).frameWidth
    mov @srcX, eax

    mov @xarr[0], TRACT0_X
    mov @xarr[1], TRACT1_X
    mov @xarr[2], TRACT2_X
    mov @xarr[3], TRACT3_X
    mov @xarr[4], TRACT4_X
    lea esi, @xarr
    mov eax, keyIndex
    shl eax, 2
    add esi, eax
    mov eax, [esi]
    mov @dstX, eax
    mov edx, [esi + 4]
    sub edx, eax
    mov @dstW, edx
    mov esi, @anim
    mov eax, (AnimationClip ptr [esi]).frameHeight
    mul edx
    mov edx, (AnimationClip ptr [esi]).frameWidth
    div edx
    mov @dstH, eax
    mov edx, JUDGELINE_Y
    shr eax, 1
    sub edx, eax
    mov @dstY, edx

    invoke CreateCompatibleDC, hDC
    mov @hBmpDC, eax
    mov esi, @anim
    mov edx, (AnimationClip ptr [esi]).image
    invoke SelectObject, @hBmpDC, edx
    mov @hOldObject, eax
    mov @blendFn.BlendOp, AC_SRC_OVER
    mov @blendFn.BlendFlags, 0
    mov @blendFn.SourceConstantAlpha, 255
    mov @blendFn.AlphaFormat, AC_SRC_ALPHA
    invoke AlphaBlend, hDC, @dstX, @dstY, @dstW, @dstH, @hBmpDC, @srcX, @srcY, \
        (AnimationClip ptr [esi]).frameWidth, (AnimationClip ptr [esi]).frameHeight, addr @blendFn
    invoke SelectObject, @hBmpDC, @hOldObject
    invoke DeleteDC, @hBmpDC
    mov eax, 1
    ret
GameDrawEffect endp

GameDrawOneNote proc uses ebx edx esi, hDC: dword, keyIndex: dword, note: ptr LevelNote, currentTime: dword
    local @xarr[5]: dword
    local @noteCY: dword
    local @rect: RECT
    local @brush: HBRUSH

    mov esi, note
    mov eax, currentTime
    sub eax, (LevelNote ptr [esi]).Time
    imul globalSpeedLevel
    cdq
    mov ebx, 16
    idiv ebx
    add eax, JUDGELINE_Y
    mov edx, eax
    mov eax, 0
    mov @noteCY, edx
    cmp edx, TRACT_BOTTOM_Y
    jg GameDrawOneNote_Exit
    sub edx, TRACT_TOP_Y
    shl edx, 1
    jc GameDrawOneNote_Exit
    mov edx, (LevelNote ptr [esi]).NoteType

    mov @xarr[0], TRACT0_X
    mov @xarr[1], TRACT1_X
    mov @xarr[2], TRACT2_X
    mov @xarr[3], TRACT3_X
    mov @xarr[4], TRACT4_X
    lea esi, @xarr
    mov eax, keyIndex
    shl eax, 2
    add esi, eax
    mov eax, [esi]
    mov @rect.left, eax
    mov eax, [esi + 4]
    mov @rect.right, eax
    mov eax, @noteCY
    .if edx == NOTE_TAP
        sub eax, TAP_NOTE_HEIGHT / 2
        mov @rect.top, eax
        add eax, TAP_NOTE_HEIGHT
        mov @rect.bottom, eax
        invoke CreateSolidBrush, 00f000e0h
    .elseif edx == NOTE_CATCH
        sub eax, CATCH_NOTE_HEIGHT / 2
        mov @rect.top, eax
        add eax, CATCH_NOTE_HEIGHT
        mov @rect.bottom, eax
        invoke CreateSolidBrush, 00f0c000h
    .endif
    push eax
    invoke FillRect, hDC, addr @rect, eax
    pop eax
    invoke DeleteObject, eax
    mov eax, 1
GameDrawOneNote_Exit:
    ret
GameDrawOneNote endp

end
