# gedit 的使用

gedit 是 GNOME 下默认的编辑器。在 GNOME 3 以后，GNOME 小组认为平板才是未来。
为了适应平板的操作，gedit 的功能遭到了大幅缩减。
而且，因为架构变动，想自行编译 gedit 也将越来越困难。

和 gedit 说再见的时候到了！

如果，你继续使用 GNOME 2，那么以下内容对你依然有用。

## gedit 的插件包

gedit-plugins是一个插件包，提供很多有用的插件。

### 安装

Ubuntu：

```
$ sudo apt-get install gedit-plugins
```

Centos：

```
$ sudo yum install gedit-plugins
```

### 使用

gedit-plugins提供如下功能：

1. Smart Spaces: Forget you're not using tabulations.

    - 按Tab键，输出的是多个空格。
    - 在首选项的插件选项卡内选中智能空格，然后在编辑器选项卡内设置。

2. Embedded Terminal: Embed a terminal in the bottompane.

    - 内嵌的terminal，只能有一个terminal。
    - 在首选项的插件选项卡内选中嵌入终端，然后在菜单栏里的查看下拉菜单里选中底部面板。

3. Show/Hide Tabbar: Add a menu entry to show/hide the tabbar.

4. Join/Split Lines: Join several lines or splitlongones

    - 合并/分割行。
    - 按Ctrl+J可以合并行。分割行是Shift+Ctrl+J，但是似乎无效。

5. Color Picker: Pick a color from a dialog and insert itshexadecimal representation.

    - 拾色器。
    - 在工具菜单内。

6. DrawSpaces: Draw Spaces and Tabs

    - 特别显示空格与制表符。
    - 空格会显示为一个小点，制表符是一个箭头。在首选项的插件选项卡内选中绘制空白。

7. Session Saver: Save and restore your workingsessions

    - 会话保存 不过貌似不怎么管用。

8. Code comment:Comment out or uncomment a selected block ofcode.

    - 注释代码。
    - 在首选项的插件选项卡内选中代码注释。使用时，选中想注释的区域，点编辑菜单内的注释代码。取消注释类似。

9. Bracket Completion: Automatically adds closingbrackets.

    - 自动的括号补全。
    - 在首选项的插件选项卡内选中括号补全。似乎不管用，但是可以高亮匹配的括号。

10. Character Map: Insert special characters justby clicking on them.

    - 对特殊字符集映射。
    - 不知道是什么。

11. 还有很多插件

## 语法高亮功能

gedit 的语法高亮功能是借助软件 gtksourceview-3.0 来实现的。
在 `/usr/share/gtksourceview-3.0` 下有两个文件夹：`language-specs` 和 `styles`。
文件夹 `language-specs` 下有很多 lang 文件，一种语言对应一个文件。
文件夹 `styles` 下有一些 xml 文件。一个 xml 文件就对应一种主题。

gedit 首先依据 lang 文件确定是哪种语言，以及按这种语言的语法，什么情况着重显示，什么情况属于注释等等。
然后，依据 xml 文件或者说主题最终确定如何显示。你可以修改 lan g文件来修改对某语言的识别方式。

### 增加 rST 的语法高亮

gtksourceview-3.0 并不支持 reStructuredText。
我们只能自己写一个 lang 文件。
这个lang文件放到 `/usr/share/gtksourceview-3.0/language-specs` 下是无效的。
这点，还不理解。
lang 文件需要放到这个文件夹下，如果没有这个文件夹，自己创建一个：`~/.local/share/gtksourceview-3.0/language-specs/` 。
我已经准备好 restructuredtext.lang 了，你可以直接下载：
https://github.com/wangliang1989/scripts/blob/master/gtksourceview-3.0/restructuredtext.lang
。
注意，第5行到第7行确定了如果文件名结尾是 rst，就会识别为 rST 了。也许你想用其他文件名结尾，你可以自己改。

## 参考

我提供的restructuredtext.lang文件内容修改自：
https://mail.gnome.org/archives/gedit-list/2011-May/msg00012.html
并参考了
http://codex.wiki/post/135189-866
和
http://ubuntuforums.org/showthread.php?t=1868181
。
