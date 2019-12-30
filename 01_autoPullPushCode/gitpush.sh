#!/bin/bash

# 获取执行脚本的绝对路径 保证日志输出在正确的位置
# SHELLDIR="/home/tianlw/shell/gitshell"
SHELLDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# dir=`pwd`
cd ${SHELLDIR}
# echo $SHELLDIR
# echo $dir

# 定义配置文件 与 日志文件名
configfilename="./gitconfig.ini"
logfilename="./git.log"

# 输入空行 作为开始标识
echo "" >> ${logfilename}
echo "" >> ${logfilename}

# git add
# 输出时间 
datetime=`date "+%Y-%m-%d %H:%M:%S"`
echo "${datetime}" >> ${logfilename}
echo "git add start" >> ${logfilename}
    
# 读取配置文件 -不读取第一行
awk 'NR>1' ${configfilename} | while read line 
do
    # 取出 代码库位置 同 push判断条件
    REPOSITORIES=`echo ${line} | awk '{print $1}'`        
    GITPATH=`echo ${line} | awk '{print $2}'`
    PUSH=`echo ${line} | awk '{print $4}'`
    ORIGIN=`echo ${line} | awk '{print $5}'`
    MASTER=`echo ${line} | awk '{print $6}'`

    # git add
    if [ "${PUSH}" = "TRUE" ]; then
        echo "${REPOSITORIES} ${GITPATH} ${PULL} ${ORIGIN} ${MASTER}" >> ${logfilename}
        
        # 进入目录 git status
        cd ${GITPATH} &&
        message=`git status 2>&1` &&
        # sleep 5 
        cd ${SHELLDIR} && echo "${message}" >> ${logfilename}

        # 判断 输出信息中是否有 git add
        if [[ ${message} =~ "git add" ]]
        then
            cd ${GITPATH} &&
            message=`git add . 2>&1` &&
            # sleep 5 
            cd ${SHELLDIR} && echo "${message}" >> ${logfilename}
        fi 
    fi
done
echo "git add done" >> ${logfilename}

# git commit
# 输出时间 
echo "" >> ${logfilename}
datetime=`date "+%Y-%m-%d %H:%M:%S"`
echo ${datetime} >> ${logfilename}
echo "git commit start" >> ${logfilename}

# 读取配置文件 -不读取第一行
awk 'NR>1' ${configfilename} | while read line 
do
    # 取出 代码库位置 同push判断条件
    REPOSITORIES=`echo ${line} | awk '{print $1}'`        
    GITPATH=`echo ${line} | awk '{print $2}'`
    PUSH=`echo ${line} | awk '{print $4}'`
    ORIGIN=`echo ${line} | awk '{print $5}'`
    MASTER=`echo ${line} | awk '{print $6}'`

    # git commit
    if [ "${PUSH}" = "TRUE" ]; then
        echo "${REPOSITORIES} ${GITPATH} ${PULL} ${ORIGIN} ${MASTER}" >> ${logfilename}
        
        # 进入目录 git Pull
        cd ${GITPATH} &&
        message=`git status 2>&1` &&
        # sleep 5
        cd ${SHELLDIR} && echo "${message}" >> ${logfilename}

        # 判断 输出信息存在 git reset HEAD 则需要提交
        if [[ ${message} =~ "git reset HEAD" ]]
        then
            # 输出信息中存在 git push 则已经存在了 commitid 
            if [[ ${message} =~ "git push" ]]
            then
                date=`date '+%Y-%m-%d'`
                desc="${date} update add"
                echo ${desc}  >> ${logfilename}
                cd ${GITPATH} &&
                # message=`git commit --amend --no-edit 2>&1` &&
                message=`git commit -m "${desc}" 2>&1` &&
                # sleep 5
                cd ${SHELLDIR} && echo "${message}" >> ${logfilename}
            else  # 还没有提交过
                date=`date '+%Y-%m-%d'`
                desc="${date} update"
                echo ${desc}  >> ${logfilename}
                cd ${GITPATH} &&
                message=`git commit -m "${desc}" 2>&1` &&
                # sleep 5
                cd ${SHELLDIR} && echo "${message}" >> ${logfilename}
            fi 
        fi 
    fi
done
echo "git commit done" >> ${logfilename}

# git pull
# 输出时间 也用作发邮件的主题时间 方便定位日志位置
echo "" >> ${logfilename}
datetime=`date "+%Y-%m-%d %H:%M:%S"`
echo "${datetime}" >> ${logfilename}
echo "git pull start" >> ${logfilename}

# 读取配置文件 -不读取第一行
awk 'NR>1' ${configfilename} | while read line 
do
    # 取出 代码库位置 同 pull判断条件
    REPOSITORIES=`echo ${line} | awk '{print $1}'`        
    GITPATH=`echo ${line} | awk '{print $2}'`
    PULL=`echo ${line} | awk '{print $3}'`
    ORIGIN=`echo ${line} | awk '{print $5}'`
    MASTER=`echo ${line} | awk '{print $6}'`

    # 需要 pull 的时候在 pull
    if [ "${PULL}" = "TRUE" ]; then
        echo "${REPOSITORIES} ${GITPATH} ${PULL} ${ORIGIN} ${MASTER}" >> ${logfilename}
        
        # 进入目录 && git Pull
        cd ${GITPATH} && 
        message=`git pull ${ORIGIN} ${MASTER} 2>&1` &&
        # sleep 5
        cd ${SHELLDIR} && echo "${message}" >> ${logfilename}

        # 如果存在冲突或者错误终止，将信息发送邮件 同时将 ${configfilename} 文件中的相应仓库设置为faluse,暂停该仓库的操作
        if [[ ${message} =~ "error" ]] || [[ ${message} =~ "fatal" ]] || [[ ${message} =~ "conflict" ]]
        then
            # 发送邮件 mail ＋参数可以直接发送邮箱
            echo "${message}" | mail -s "git pull conflit ${datetime}" 1308145492@qq.com &&
            # 设置该仓库为FALUSE
            sed -i "/^${REPOSITORIES}\>/s/TRUE/FAULSE/g" ${configfilename}
        fi 
        # sleep 5;
    fi
done
echo "git pull done" >> ${logfilename}

# git push
# 输出时间 也用作发邮件的主题时间 方便定位日志位置
echo "" >> ${logfilename}
datetime=`date "+%Y-%m-%d %H:%M:%S"`
echo ${datetime} >> ${logfilename}
echo "git push start" >> ${logfilename}

# 读取配置文件 -不读取第一行
awk 'NR>1' ${configfilename} | while read line 
do
    # 取出 代码库位置 同push判断条件
    REPOSITORIES=`echo $line | awk '{print $1}'`        
    GITPATH=`echo $line | awk '{print $2}'`
    PUSH=`echo $line | awk '{print $4}'`
    ORIGIN=`echo $line | awk '{print $5}'`
    MASTER=`echo $line | awk '{print $6}'`

    # git push
    if [ "$PUSH" = "TRUE" ]; then
        echo "${REPOSITORIES} ${GITPATH} ${PULL} ${ORIGIN} ${MASTER}" >> ${logfilename}
        
        # 进入 git 目录
        cd ${GITPATH} &&
        message=`git status 2>&1` &&
        # sleep 5
        cd ${SHELLDIR} && echo "${message}" >> ${logfilename}

        # 判断 输出信息中是否有 git push
        if [[ ${message} =~ "git push" ]]
        then
            # git rebase
            cd ${GITPATH} &&
            message=`git rebase 2>&1` &&
            # sleep 5 
            cd ${SHELLDIR} && echo "${message}" >> ${logfilename}

            # git push
            cd ${GITPATH} &&
            message=`git push ${ORIGIN} ${MASTER} 2>&1` &&
            # sleep 20
            cd ${SHELLDIR} && echo "${message}" >> ${logfilename}
        fi 

        # 如果存在冲突或者错误终止，将信息发送邮件 同时将 ${configfilename} 文件中的相应仓库设置为faluse,暂停该仓库的操作
        if [[ ${message} =~ "error" ]] || [[ ${message} =~ "fatal" ]] || [[ ${message} =~ "conflict" ]] 
        then
            # 发送邮件 mail ＋参数可以直接发送邮箱
            echo "${message}" | mail -s "git pull conflit ${datetime}" 1308145492@qq.com &&
            # 设置该仓库为FALUSE
            sed -i "/^${REPOSITORIES}\>/s/TRUE/FAULSE/g" ${configfilename}
        fi 
        # sleep 5;
    fi
done
echo "git push done" >> ${logfilename}
echo "auto push done, all is well" >> ${logfilename}


exit 0
