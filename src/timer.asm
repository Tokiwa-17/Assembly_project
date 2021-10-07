.386
.model flat, stdcall
option casemap: none

include windows.inc
include kernel32.inc

include timer.inc

includelib kernel32.lib

.data
tFrequency dword ?
tFPS dword 60
tFrameDelta dword ?
tLastFrame qword ?

.code

TimeInitialize proc
	sub esp, 8
	push esp
	call QueryPerformanceFrequency
	mov eax, [esp]
	mov edx, 0
	mov tFrequency, eax
	div tFPS
	mov tFrameDelta, eax
	push offset tLastFrame
	call QueryPerformanceCounter
	add esp, 8
	ret
TimeInitialize endp

TimeNextFrame proc; return BOOL
	sub esp, 8
	push esp
	call QueryPerformanceCounter
	mov eax, [esp]
	mov ebx, [esp + 4]
	add esp, 8
	mov ecx, dword ptr [tLastFrame]
	mov edx, dword ptr [tLastFrame + 4]
	sub eax, ecx
	sbb ebx, edx
	cmp ebx, 0
	jg TimeNextFrame_Impl
	cmp eax, tFrameDelta
	jge TimeNextFrame_Impl
	mov eax, 0
	ret
TimeNextFrame_Impl:
	add ecx, tFrameDelta
	adc edx, 0
	mov dword ptr [tLastFrame], ecx
	mov dword ptr [tLastFrame + 4], edx
	mov eax, 1
	ret
TimeNextFrame endp

end
