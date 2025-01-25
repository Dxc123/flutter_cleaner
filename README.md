##
目的：清理当前目录下所有Flutter项目以便释放更多磁盘空间

原理：该工具会递归扫描当前目录及其子目录，找到所有 Flutter 项目，并执行以下操作：

执行 flutter clean。

删除 .dart_tool 文件夹。

删除 build 文件夹。


使用：
安装到本地：(需要Flutter环境)

dart pub global activate -sgit https://github.com/Dxc123/flutter_cleaner.git

本地移除：dart pub global deactivate flutter_cleaner

执行命令：flutter_cleaner clean
