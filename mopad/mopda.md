## Mopad 的安装

Mopad 的官方地址：https://github.com/geophysics/MoPaD

语言为 python2，不支持 python3。依赖的模块有 numpy 和 matplotlib，这两个用 pip 安装。
在安装好模块后，mopad.py 即可使用了。不要用官方的安装方式。mopad.py 的 shebang 固定为python的可执行文件：
```
#! /home/peterpan/.pyenv/versions/2.7.12/bin/python
```
这样在 global 依然是 3 的情况，也可以使用 mopad

## Mopad 在地图上绘制沙滩球

先绘制 ps 格式的图片，用 gmt 转为 eps 图片插入。
代码例子：

https://gist.github.com/wangliang1989/0255a17b9b6884346d251cb165b69aa0
