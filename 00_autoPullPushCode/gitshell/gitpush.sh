# !/bin/bash

# 输入空行 与 时间
echo "" #>> ./log
# echo `date`>> ./log
echo `date`

# git add
# 读取配置文件 -不读取第一行
awk 'NR>1' ./config.ini | while read line 
do
    # 取出 代码库位置 同 push判断条件
    GITPATH=`echo $line | awk '{print $2}'`
    PUSH=`echo $line | awk '{print $4}'`
    ORIGIN=`echo $line | awk '{print $5}'`
    MASTER=`echo $line | awk '{print $6}'`

    # git add
    if [ "$PUSH" = "TRUE" ]; then
        echo "$GITPATH $PULL $ORIGIN $MASTER"
        
        # 进入目录 git Pull
        cd ${GITPATH}; 
        if [ $? -ne 1 ]; then
            message=`git status` &&
            # 不输入到 log 是因为当前所在目录已经发生了变化 不想使用绝对路径
            echo ${message}
            sleep 5
        fi

        # 判断 输出信息中是否有 git add
        if [[ ${message} =~ "git add" ]]
        then
            message=`git add .` &&
            echo ${message}
            sleep 5 
        fi 
    fi
done
# echo "add done" >> ./log
echo "add done"

# git commit
# 读取配置文件 -不读取第一行
awk 'NR>1' ./config.ini | while read line 
do
    # 取出 代码库位置 同push判断条件
    GITPATH=`echo $line | awk '{print $2}'`
    PUSH=`echo $line | awk '{print $4}'`
    ORIGIN=`echo $line | awk '{print $5}'`
    MASTER=`echo $line | awk '{print $6}'`

    # git commit
    if [ "$PUSH" = "TRUE" ]; then
        echo "$GITPATH $PULL $ORIGIN $MASTER";
        
        # 进入目录 git Pull
        cd ${GITPATH}; 
        if [ $? -ne 1 ]; then
            message=`git status` &&
            echo ${message}
            sleep 5
        fi

        # 判断 输出信息中是否有 git reset HEAD
        if [[ ${message} =~ "git reset HEAD" ]]
        then
            # 已经存在了 commitid 
            if [[ ${message} =~ "git push" ]]
            then
                message=`git commit --amend`&&
                echo ${message}
            else
                date=`date '+%Y-%m-%d'`
                desc="${date} update"
                echo $desc
                message=`git commit -m "${desc}"` &&
                echo ${message}
                sleep 5
            fi 
        fi 
    fi
done
echo "commit done" 
# echo "commit done" >> ./log

# git pull
sh ./gitpull.sh &&

# git push
# 读取配置文件 -不读取第一行
awk 'NR>1' ./config.ini | while read line 
do
    # 取出 代码库位置 同push判断条件
    GITPATH=`echo $line | awk '{print $2}'`
    PUSH=`echo $line | awk '{print $4}'`
    ORIGIN=`echo $line | awk '{print $5}'`
    MASTER=`echo $line | awk '{print $6}'`

    # git add
    if [ "$PUSH" = "TRUE" ]; then
        echo "$GITPATH $PULL $ORIGIN $MASTER";
        
        # 进入目录 git Pull
        cd ${GITPATH}; 
        if [ $? -ne 1 ]; then
            message=`git status` &&
            echo ${message}
            sleep 5
        fi

        # 判断 输出信息中是否有 git add
        if [[ ${message} =~ "git push" ]]
        then
            message=`git push ${ORIGIN} ${MASTER}` &&
            echo ${message};
            sleep 20
        fi 
    fi
done
# echo "push done" >> ./log
echo "push done" 

# 删除 gitpull 时候日志添加的空行，显得日志整齐，每一次操作日志被空行分隔开，也方便查看
delteline=sed -n '/[a-zA-Z0-9@#$%^&*]/!=' ./log | tail -1 &&
sed "${delteline},+1d"
