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
VSCode