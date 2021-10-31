ifndef __audio_inc__
__audio_inc__ equ <1>

AudioOpen proto : ptr sbyte
AudioPlay proto : dword, :dword
AudioStop proto : dword

AudioOpenResource proto : dword

endif
