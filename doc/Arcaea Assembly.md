# Arcaea Assembly

## 简介

用masm32和win32编程实现一款音游。

## 开发环境

* IDE: VS Code
* Assembler: MASM32
* OS: Win10

## 运行方法

* vscode工作区配置

  ```json
  {
      "cmake.configureArgs": ["-DMASM_HOME=C:/masm32"],
      "C_Cpp.default.configurationProvider": "ms-vscode.cmake.tools",
      "files.associations": {
          "charconv": "cpp"
      },
      "debug.allowBreakpointsEverywhere": true
  }
  ```

  其中`cmake.configureArgs`换成自己的masm32目录。

* 运行`.\level-build`目录中的`cyaegha.cpp`和`sheriruth.cpp`文件，在`.\bin\Debug`目录中生成`cyaegha.exe`和`sheriruth.exe`（分别选择build target为`cyaegha`和`sheriruth`)

* 在`.\bin\Debug`运行`cyaegha.exe`和`sheriruth.exe`，在`.\bin\Debug\levels`目录下生成两个二进制谱面文件`Cyaegha.level`和`Sheriruth.level`

* 选择build target为`asm_mug`，编译链接项目文件和资源文件，在`.\bin\Debug`目录下生成`asm_mug.exe`可执行文件。

## 实现思路

gameInit: 分配堆大小分别载入之前生成的二进制谱面

```assembly
LevelLoad proc opernNamePtr: ptr sbyte, opernInstancePtr: ptr Level
```

* opernNamePtr: 指向谱面二进制文件地址的指针
* opernInstancePtr: 指向谱面buffer的地址



```assembly
LevelRecord            struct
;record indices within level
currentIndices  dword   GAME_KEY_COUNT      DUP(0)
tapJudgesCount  dword   NOTE_JUDGE_COUNT    DUP(0)
catchJudgeCount dword   2                   DUP(0)
records         LevelNoteRecord   GAME_KEY_COUNT * MAX_NOTE_LENGTH      DUP(<>)
LevelRecord            ends
```

```assembly
LevelNote        struct
Time            dword   0
NoteType        dword   0
LevelNote       ends
```

`globalLevelRecord   LevelRecord    <> `

`globalKeyPressing   db    GAME_KEY_COUNT `



```c++
DWORD timeGetTime();
```

The **timeGetTime** function retrieves the system time, in milliseconds. The system time is the time elapsed since Windows was started.



globalLevelState: GAME_LEVEL_PLAYING



`GameDrawNotes`: 

* @currentTime:  

  计算当前游戏时间（ms）

  ```assembly
  invoke timeGetTime
  sub eax, globalLevelBeginTime
  mov @currentTime, eax
  ```

* @keyi

* @pCurrentID

  指向当前的Note id

  ```assembly
  mov esi, offset globalLevelRecord
  mov @pCurrentID, esi
  ```

  ```assembly
  LevelRecord            struct
  ;record indices within level
  currentIndices  dword   GAME_KEY_COUNT      DUP(0)
  tapJudgesCount  dword   NOTE_JUDGE_COUNT    DUP(0)
  catchJudgeCount dword   2                   DUP(0)
  records         LevelNoteRecord   GAME_KEY_COUNT * MAX_NOTE_LENGTH      DUP(<>)
  LevelRecord            ends
  ```

* @pRecords

  指向levelRecord的records部分

  ```assembly
  LevelRecord            struct
  ;record indices within level
  currentIndices  dword   GAME_KEY_COUNT      DUP(0)
  tapJudgesCount  dword   NOTE_JUDGE_COUNT    DUP(0)
  catchJudgeCount dword   2                   DUP(0)
  records         LevelNoteRecord   GAME_KEY_COUNT * MAX_NOTE_LENGTH      DUP(<>)
  LevelRecord            ends
  ```

  ```assembly
  LevelNoteRecord        struct
  judgeTime       dword   0
  judgement       dword   0
  LevelNoteRecord        ends
  ```

* @pNotes

  指向Level里的notes字段

  ```assembly
  mov esi, globalPCurLevel
  add esi, type Level
  sub esi, GAME_KEY_COUNT * MAX_NOTE_LENGTH * type LevelNote
  ```

  ```assembly
  Level        struct
  musicName       db      MAX_NAME_LENGTH     DUP(0)
  author          db      MAX_NAME_LENGTH     DUP(0)
  musicPath       db      MAX_NAME_LENGTH     DUP(0)
  imagePath       db      MAX_NAME_LENGTH     DUP(0)
  musicSelectPath db      MAX_NAME_LENGTH     DUP(0)
  LevelDifficulty dword   0
  totalTime       dword   0
  totalTapCount   dword   0
  totalCatchCount dword   0
  totalNoteCount  dword   0
  noteCounts      dword   GAME_KEY_COUNT      DUP(0)
  notes           LevelNote   GAME_KEY_COUNT * MAX_NOTE_LENGTH DUP(<>)
  Level       ends
  ```

* @pNoteCount

  指向Level里面的noteCounts字段

* @pTheRecord

  指向当前轨道的records

  ```assembly
  LevelRecord            struct
  ;record indices within level
  currentIndices  dword   GAME_KEY_COUNT      DUP(0)
  tapJudgesCount  dword   NOTE_JUDGE_COUNT    DUP(0)
  catchJudgeCount dword   2                   DUP(0)
  records         LevelNoteRecord   GAME_KEY_COUNT * MAX_NOTE_LENGTH      DUP(<>)
  LevelRecord            ends
  ```

* @pTheNote

  指向当前轨道的Notes