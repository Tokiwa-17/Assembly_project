ifndef __animation_inc__
__animation_inc__ equ <1>

include windows.inc

include level.inc

AnimationClip struct
    image       HBITMAP ?
    rows        dword ?
    columns     dword ?
    frameWidth  dword ?
    frameHeight dword ?
    interval    dword 16
    alphaMask   dword 00685b35h
AnimationClip ends

AnimationInit proto, image: dword, rows: dword, columns: dword, pClip: ptr AnimationClip

GameLoadNoteAssets proto

; return 1 if drawn (time < total effect time)
GameDrawEffect proto, hDC: dword, keyIndex: dword, noteType: dword, animTime: dword

; return 1 if drawn (y >= top)
GameDrawOneNote proto, hDC: dword, keyIndex: dword, note: ptr LevelNote, currentTime: dword

endif
