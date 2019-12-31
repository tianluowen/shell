> **本文档是关于如何使用该 shell 脚本以方便实现自动更新代码的说明**

<br/>

### 01 初次使用
> 初始使用，需要做三方面的配置

1. 配置文件
 - 在本目录下创建 gitconfig.ini 配置文件
 - 按照如下格式将所有 git 仓库全部写入

 ```vim
    Repositories      path                      pull           push     origin          master
    c               /home/tianlw/gitee/c      TRUE           TRUE     origin          master      
    仓库名称描述      仓库地址                  自动pull       自动push 远程仓库名称    本地分支名称
 ```
    

2. crontab 定时 pull push
 - `crontab -e` 打开定时任务
 
 <br />
 ```
 # 每天早上定时更新 自己的代码仓库
 01 6 * * * /home/tianlw/gitee/shell/01_autoPullPushCode/gitpull.sh &>> /dev/null
 # 每天晚上 10 点更新自己的代码
 15 22 * * * /home/tianlw/gitee/shell/01_autoPullPushCode/gitpush.sh &>> /dev/null
 # 每周五晚上自动关机
 30 22 * * 5 sudo /sbin/shutdown now
 ```

3. systemctl 开关机自动运行服务
 - `cd /etc/systemctl/user/`
 - `vim my.service`
 - 输入以下内容

 ```shell
 [Unit]                                                                                         
 Description=auto-git                                                                           
 #Before=network.target sshd-keygen.service                                                     
 #After=network.target                                                                          

 [Service]                                                                                      
 ExecStart=-/usr/bin/sudo su - tianlw -s /home/tianlw/gitee/shell/01_autoPullPushCode/gitpull.sh
 #ExecStart=-/usr/bin/sudo su - tianlw -s /home/tianlw/shell/gitshell/bootuserin.sh             
 ExecStop=-/usr/bin/sudo su - tianlw -s /home/tianlw/gitee/shell/01_autoPullPushCode/gitpush.sh 
 #ExecStart=/home/tianlw/shell/gitshell/gitpull.sh                                              
 #ExecStop=/home/tianlw/shell/gitshell/gitpush.sh                                               
 #Type=forking                                                                                  
 #Type=oneshot                                                                                  
 Type=simple                                                                                    
 RemainAfterExit=yes                                                                            
 #User=tianlw                                                                                   
 #Group=dialout                                                                                 
 #TimeoutStopSec=300                                                                            
 #ExecStart=/usr/bin/sudo /bin/su - tianlw -s /home/tianlw/gitpull.sh                           
 #ExecStop=/usr/bin/sudo /bin/su - tianlw -s /home/tianlw/gitpush.sh                            

 [Install]                                                                                      
 WantedBy=default.target                                                                        
 ```


### 02 code 地址修改变更情况
当某个代码仓库添加或者删除一个远程仓库 或者 添加删除一个代码仓库时，需要在本目录下的 `gitconfig.ini ` 文件中删除或者添加对应的远程说明嗯，格式如文件例子所示

### 03 shell 脚本位置发生变化
> shell 脚本发生变化，修改的地方比较多，总的来说类似于 **初次使用** 主要修改二方面的内容

- crontab 中的内容
 - `crontab -e`
 - 修改定时 `pull.sh` 的脚本存放位置
 - 修改定时 `push.sh` 的脚本存放位置
- `systemctl` 服务中的内容
 - `cd /etc/systemctl/user/`
 - `vim my.service`
 - 修改 start 和 stop 脚本的位置 保存退出
 - `systemctl --user daemon-reload` 更新修改的服务
 - `systemctl --user status my.service` 查看服务状态，一切正常就可以了

