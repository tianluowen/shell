提示该 shell 脚本的用法

功能：将 md 文件中的图片文件 链接 替换为 github 上的图床链接
      将本地文件复制得到 图床 git 并上传

实现 
- 不需要输入文件位置的功能
- 只对 mk 文件生效
- 支持文件位置移动，文件位置发生移动，相应的移动图片的位置

用法：
- 需要在配置文件中填写 github 远程地址 用来做地址替换
    配置文件方式   parametername=***
    不需要手动添加 调用函数添加 gitmk para str
- 需要本地图床存放文件的文件
- 需要 ln 创建文件的软连接
- typora 需要设置将所有图片复制到本地
