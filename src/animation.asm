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

include animation.inc

extern hInstance: dword

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

AnimationLoopTime proc uses edx edi, pClip: ptr AnimationClip, time: dword
    mov edi, pClip
    mov eax, (AnimationClip ptr [edi]).interval
    mul (AnimationClip ptr [edi]).rows
    mul (AnimationClip ptr [edi]).columns
    mov edx, eax
    mov eax, time
    div edx
    mov eax, edx
    ret
AnimationLoopTime endp

AnimationDraw proc uses edx edi, hDC: dword, pClip: ptr AnimationClip, time: dword, dstX: dword, dstY: dword, dstW: dword, dstH:dword
    local @srcX: dword
    local @srcY: dword
    local @srcW: dword
    local @srcH: dword
    local @hBmpDC: dword
    local @hOldObject: dword
    local @blendFn: BLENDFUNCTION
    mov edi, pClip
    mov eax, time
    div (AnimationClip ptr [edi]).interval
    div (AnimationClip ptr [edi]).columns
    mov @srcX, edx; column
    div (AnimationClip ptr [edi]).rows
    mov eax, edx; row
    mov edx, (AnimationClip ptr [edi]).frameHeight
    mov @srcH, edx
    mul edx
    mov @srcY, eax
    mov eax, @srcX
    mov edx, (AnimationClip ptr [edi]).frameWidth
    mov @srcW, edx
    mul edx
    mov @srcX, eax

    invoke CreateCompatibleDC, hDC
    mov @hBmpDC, eax
    mov edi, pClip
    mov edx, (AnimationClip ptr [edi]).image
    invoke SelectObject, @hBmpDC, edx
    mov @hOldObject, eax
    mov @blendFn.BlendOp, AC_SRC_OVER
    mov @blendFn.BlendFlags, 0
    mov @blendFn.SourceConstantAlpha, 255
    mov @blendFn.AlphaFormat, AC_SRC_ALPHA
    invoke AlphaBlend, hDC, dstX, dstY, dstW, dstH, @hBmpDC, @srcX, @srcY, @srcW, @srcH, addr @blendFn
    invoke SelectObject, @hBmpDC, @hOldObject
    invoke DeleteDC, @hBmpDC
    ret
AnimationDraw endp

end
