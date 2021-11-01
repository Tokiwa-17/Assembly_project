.386
.model flat,stdcall
option casemap:none

include windows.inc
include kernel32.inc 
include user32.inc 
include winmm.inc

includelib msvcrt.lib
includelib kernel32.lib
includelib user32.lib
includelib winmm.lib

include audio.inc

printf proto C, :ptr sbyte, :vararg

extern hInstance: dword

.const
waveaudio db "waveaudio", 0
unknownMCIError db "Unknown MCI error", 0
mciOpenErrorPrompt db "MCI Open Error: file [%s], %s", 0ah, 0dh, 0
mciPlayErrorPrompt db "MCI Play Error: wDeviceID %lu, %s", 0ah, 0dh, 0

.code
AudioOpen proc filePath: ptr sbyte
    local @openParams:MCI_OPEN_PARMS
    local @errBuffer[256]:sbyte
    local @errCode:dword
    local @setParams: MCI_SET_PARMS
    mov @openParams.lpstrDeviceType, offset waveaudio
    mov eax, filePath
    mov @openParams.lpstrElementName, eax
    invoke mciSendCommand, 0, MCI_OPEN, MCI_OPEN_TYPE + MCI_OPEN_ELEMENT, addr @openParams
    .if eax != 0
        mov @errCode, eax
        invoke mciGetErrorString, @errCode, addr @errBuffer, 256
        .if eax == 0
            invoke printf, offset mciOpenErrorPrompt, filePath, offset unknownMCIError
        .else
            invoke printf, offset mciOpenErrorPrompt, filePath, addr @errBuffer
        .endif
    .endif
    mov @setParams.dwTimeFormat, MCI_FORMAT_MILLISECONDS
    invoke mciSendCommand, @openParams.wDeviceID, MCI_SET, MCI_SET_TIME_FORMAT, addr @setParams
    mov eax, @openParams.wDeviceID
    ret
AudioOpen endp

AudioPlay proc wDeviceID: dword, dwFrom: dword
    local @playParams:MCI_PLAY_PARMS
    local @errBuffer[256]:sbyte
    local @errCode:dword
    mov eax, dwFrom
    .if eax >= 80000000h
        mov eax, 0
    .endif
    mov @playParams.dwFrom, eax
    invoke mciSendCommand, wDeviceID, MCI_PLAY, MCI_FROM, addr @playParams
    .if eax != 0
        mov @errCode, eax
        invoke mciGetErrorString, @errCode, addr @errBuffer, 256
        .if eax == 0
            invoke printf, offset mciPlayErrorPrompt, wDeviceID, offset unknownMCIError
        .else
            invoke printf, offset mciPlayErrorPrompt, wDeviceID, addr @errBuffer
        .endif
    .endif
    ret
AudioPlay endp

AudioStop proc wDeviceID: dword
    invoke mciSendCommand, wDeviceID, MCI_STOP, 0, 0
    ret
AudioStop endp

AudioClose proc wDeviceID: dword
    invoke mciSendCommand, wDeviceID, MCI_CLOSE, 0, 0
    ret
AudioClose endp

AudioOpenResource proc uses esi, resID :dword
    local @hResSrc: HRSRC
    local @hRes: HGLOBAL
    local @hFile: dword
    local @filePath[MAX_PATH]: sbyte
    local @filePathName[MAX_PATH]: sbyte
    local @sz: dword

    invoke FindResource, hInstance, resID, RT_RCDATA
    mov @hResSrc, eax
    invoke LoadResource, hInstance, eax
    mov @hRes, eax
    invoke GetTempPath, MAX_PATH, addr @filePath
    invoke GetTempFileName, addr @filePath, offset waveaudio, 0, addr @filePathName
    invoke CreateFile, addr @filePathName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL
    mov @hFile, eax
    invoke SizeofResource, hInstance, @hResSrc
    mov @sz, eax
    invoke LockResource, @hRes
    mov esi, eax
    invoke WriteFile, @hFile, esi, @sz, NULL, NULL
    invoke CloseHandle, @hFile
    invoke AudioOpen, addr @filePathName
    ret
AudioOpenResource endp

end
