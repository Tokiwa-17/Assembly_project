.386
.model flat,stdcall
option casemap:none

include windows.inc
include winmm.inc

includelib msvcrt.lib
includelib kernel32.lib
includelib user32.lib
includelib winmm.lib

printf proto C, :ptr sbyte, :vararg

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
    mov eax, @openParams.wDeviceID
    ret
AudioOpen endp

AudioPlay proc wDeviceID: dword
    local @playParams:MCI_PLAY_PARMS
    local @errBuffer[256]:sbyte
    local @errCode:dword
    mov @playParams.dwFrom, 0
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

end
