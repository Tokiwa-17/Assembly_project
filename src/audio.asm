.386
.model flat,stdcall
option casemap:none

include windows.inc
include mciapi.inc
include msvcrt32.inc

includelib kernel32.lib
includelib user32.lib
includelib winmm.lib

printf proto C, :ptr sbyte, :vararg

.data
waveaudio db "waveaudio", 0
unknownMCIError db, "Unknown MCI error", 0
mciOpenErrorPrompt db, "MCI Open Error: file [%s], %s", 0ah, 0dh
mciPlayErrorPrompt db, "MCI Play Error: wDeviceID %lu, %s", 0ah, 0dh

.code
AudioOpen proc filePath: ptr sbyte
    local @openParams:MCI_OPEN_PARMS
    local @errBuffer[256]:sbyte
    mov @openParams.lpstrDeviceType, offset waveaudio
    mov @openParams.lpsreElementName, filePath
    invoke mciSendCommand, 0, MCI_OPEN, MCI_OPEN_TYPE | MCI_OPEN_ELEMENT, addr @openParams
    .if eax != 0
        invoke mciGetErrorString, eax, addr @errBuffer
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
    mov @playParams.dwFrom, 0
    invoke mciSendCommand, wDeviceID, MCI_PLAY, MCI_FROM, addr @playParams
    .if eax != 0
        invoke mciGetErrorString, eax, addr @errBuffer
        .if eax == 0
            invoke printf, offset mciPlayErrorPrompt, wDeviceID, offset unknownMCIError
        .else
            invoke printf, offset mciPlayErrorPrompt, wDeviceID, addr @errBuffer
        .endif
    .endif
AudioPlay endp

AudioStop proc wDeviceID: dword
    invoke mciSendCommand, wDeviceID, MCI_STOP, 0, 0
AudioStop endp

end
