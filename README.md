# Assembly_project
An implementation of MUG with assembly.

## Build
#### Visual Studio
在CMakeLists.txt目录，输入命令：
```
cmake -DMASM_HOME=D:/masm32 -Bbuild -T host=x86 -A win32
```
其中`-DMASM_HOME`后面换成自己的masm安装目录。
然后在build目录下可以看到生成的VS项目(.sln)文件。

#### 其它方式
VSCode CMake-Tools

## GDI utility functions
#### 绘制图片
+ [`BitBlt`](https://docs.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-bitblt)
+ [`StretchBlt`](https://docs.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-stretchblt)
+ [`TransparentBlt`](https://docs.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-transparentblt)

#### 半透明
+ [`AlphaBlend`](https://docs.microsoft.com/en-us/windows/win32/api/wingdi/nf-wingdi-alphablend)

#### 文件

* [`CreateFile`](https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilea)
* [`SetFilePointer`](https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-setfilepointer)
* [`ReadFile`](https://docs.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-readfile)

## 写谱
参照level-build/cyaegha.cpp
含`main`函数的单文件，在同级CMakeLists中加上`add_level(level_name)`，指定以level_name.cpp生成可执行文件，这个程序将会生成二进制格式的谱面。

## 游戏设定界面
#### 下落速度调整
#### 延迟调整





## TODO 

---

- [x]  谱面一
- [ ]  谱面二
- [x]  读取文件
- [ ]  判定逻辑
- [x] 音频读取  没交PR 测试？
- [ ] 选歌页面
- [ ] 绘制事件



10/25 TODO

- [ ] 谱面二
- [ ] GameKeyCallback（除游玩页面）
- [ ] NoteTapJudgement
- [ ] GameCalcNoteCenterY
- [ ] 开始游戏后的处理，得分，音效

