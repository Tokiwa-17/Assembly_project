ifndef __animation_inc__
__animation_inc__ equ <1>

AnimationClip struct
    image       dword ?; HBITMAP
    rows        dword ?
    columns     dword ?
    frameWidth  dword ?
    frameHeight dword ?
    interval    dword 16
AnimationClip ends

AnimationInit proto, image: dword, rows: dword, columns: dword, pClip: ptr AnimationClip

AnimationLoopTime proto, pClip: ptr AnimationClip, time: dword

AnimationDraw proto, hDC: dword, pClip: ptr AnimationClip, time: dword, dstX: dword, dstY: dword, dstW: dword, dstH:dword

endif
