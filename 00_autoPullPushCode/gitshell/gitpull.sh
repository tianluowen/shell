# !/bin/bash

# 读取配置文件 -不读取第一行
awk 'NR>1' /home/tianlw/shell/gitshell/config.ini | while read line 
do
    # 取出 代码库位置 同 pull判断条件
    GITPATH=`echo $line | awk '{print $2}'`
    PULL=`echo $line | awk '{print $3}'`
    ORIGIN=`echo $line | awk '{print $5}'`
    MASTER=`echo $line | awk '{print $6}'`

    # 需要 pull 的时候在 pull
    if [ "$PULL" = "TRUE" ] 
    then
        echo "$GITPATH $PULL $ORIGIN $MASTER"

        # 进入目录 git Pull
        cd $GITPATH && 
        messge=`git pull $ORIGIN $MASTER` && echo "$messge"
        echo '\n'
        sleep 5
    fi
done
