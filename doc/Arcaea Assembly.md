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

