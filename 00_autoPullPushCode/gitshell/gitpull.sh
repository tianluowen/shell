# !/bin/bash

# 读取配置文件 -不读取第一行
awk 'NR>1' ./config.ini | while read line 
do
    # 取出 代码库位置 同 pull判断条件
    GITPATH=`echo $line | awk '{print $2}'`
    PULL=`echo $line | awk '{print $3}'`
    ORIGIN=`echo $line | awk '{print $5}'`
    MASTER=`echo $line | awk '{print $6}'`

    # 需要 pull 的时候在 pull
    if [ "$PULL" = "TRUE" ]; then
        echo "$GITPATH $PULL $ORIGIN $MASTER";
        # 进入目录 git Pull
        cd $GITPATH && git pull $ORIGIN $MASTER;  
        # messge=`git pull $ORIGIN $MASTER` | >>& ./log && echo "$messge" >> ./log
        echo '\n';
        sleep 5;
    fi
done

#判断日志文件，如果大于500line 删除第一行到第一个空行
fileline=`cat ./log | wc -l`
while test $[fileline]  -gt 500
do
    spaceline=`sed -n '/[a-zA-Z0-9@#$%^&*]/!=' ./log`;

    dellinestart=`echo $spaceline | awk '{print $1}'` &&
    dellineend=`echo $spaceline | awk '{print $2}'` &&
    dellinestart=`expr $dellinestart + 1`;

    sed -i "${dellinestart},${dellineend}d" ./log > /dev/null

    if [ $? -ne 0 ]; then
        sed -i "${dellinestart},+100d" ./log  > /dev/null
    fi

    fileline=`cat ./log | wc -l`
done
