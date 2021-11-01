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
      "debug.allowBreakpointsEverywhere": true // for debug
  }
  ```

  其中`cmake.configureArgs`换成自己的masm32目录。

* 运行`.\level-build`目录中的`cyaegha.cpp`和`sheriruth.cpp`文件，在`.\bin\Debug`目录中生成`cyaegha.exe`和`sheriruth.exe`（分别选择build target为`cyaegha`和`sheriruth`)

* 在`.\bin\Debug`运行`cyaegha.exe`和`sheriruth.exe`，在`.\bin\Debug\levels`目录下生成两个二进制谱面文件`Cyaegha.level`和`Sheriruth.level`

* 选择build target为`asm_mug`，编译链接项目文件和资源文件，在`.\bin\Debug`目录下生成`asm_mug.exe`可执行文件。

## 游戏说明

- **开始页面：**

  

  如图所示，按J键开始游戏，进入选歌页面；按H键打开设置窗口。

  

  设置窗口可设置速度、延迟和按键映射，如图为默认设置。

* **选歌页面：**

  选歌页面功能画面左侧为当前选中曲目封面图片，滚动鼠标滚轮可切换选中的歌曲。曲目名称在画面右侧显示，其中被最大文本框圈中的歌曲为被选中歌曲。在此页面按H键可开始游玩选中曲目。

- **游戏页面：**

  

  

  左上角为曲目封面，下方有曲目名称和作者；右上角为当前得分；右下角为当前记录的perfect、great和miss数。

  下方深色矩形的上边缘为判定线。

  游戏中下落方块分为两种：tap方块（紫色）和catch方块（黄色）。tap方块要求玩家在方块落到判定线附近时敲击对应轨道按键，游戏会根据玩家敲击按键的时机判断本次动作评价，具体可分为：critical perfect、perfect、great、miss，判定依据为敲击按键时方块重心距判定线的绝对距离，距离越短评价越高，评价越高得分越高。catch方块要求玩家在块落到判定线附近时对应轨道按键为按下状态，这类方块的评价只有critcal perfect和miss两种，判定依据为方块在判定线附近时是否检测到按键被按下，评价越高得分越高。

* **结算页面：**

  结算页面显示本次游玩的成绩。画面左侧为游玩曲目封面，右侧显示游玩分数信息以及获得各种评价的方块数量。需要说明的是：PERFECT标签后两行有较小字体的EARLY标签和LATE标签，分别指示了因过早敲击按键而得到PERFECT评价的方块数量以及因过晚敲击按键而得到PERFECT评价的方块数量，二者的和应等于PERFECT标签后的数据。GREAT标签同理。

## 实现思路



