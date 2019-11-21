# !/bin/bash

# 获取执行脚本的绝对路径 保证日志输出在正确的位置
SHELLDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SHELLDIR}

# 定义配置文件 与 日志文件名
configfilename="gitconfig.ini"
logfilename="git.log"

# 输入空行 与 时间 作为开始标识
echo "" >> ./${logfilename}
echo "" >> ./${logfilename}
echo `date "+%Y-%m-%d %H:%M:%S"` >> ./${logfilename}

# git pull
echo "git pull start" >> ./${logfilename}
# 读取配置文件 -不读取第一行
awk 'NR>1' ./${configfilename} | while read line 
do
    # 取出 代码库位置 同 pull判断条件
    REPOSITORIES=`echo $line | awk '{print $1}'`        
    GITPATH=`echo $line | awk '{print $2}'`
    PULL=`echo $line | awk '{print $3}'`
    ORIGIN=`echo $line | awk '{print $5}'`
    MASTER=`echo $line | awk '{print $6}'`

    # 需要 pull 的时候在 pull
    if [ "$PULL" = "TRUE" ]; then
        echo "${REPOSITORIES} ${GITPATH} ${PULL} ${ORIGIN} ${MASTER}" >> ./${logfilename}
        
        # 进入目录 && git Pull
        cd ${GITPATH} && 
        message=`git pull ${ORIGIN} ${MASTER} 2>&1` &&
        sleep 5
        cd ${SHELLDIR} && echo "${message}" >> ./${logfilename}

        # 如果存在冲突或者错误终止，将信息发送邮件 同时将 ${configfilename} 文件中的相应仓库设置为faluse,暂停该仓库的操作
        if [[ ${message} =~ "ERROR" ]] || [[ ${message} =~ "FATAL" ]] || [[ ${message} =~ "CONFLICT" ]] 
        then
            # 发送邮件 mail ＋参数可以直接发送邮箱
            echo "${message}" | mail -s "git pull conflit `date -d "-10 days" "+%Y-%m-%d %H:%M:%S"`" 1308145492@qq.com &&
            # 设置该仓库为FALUSE
            sed -i "/^${REPOSITORIES}\>/s/TRUE/FAULSE/g" ./${configfilename}
        fi 
        sleep 5;
    fi
done
echo "git pull done" >> ./${logfilename}

# 日志处理，只保存10天日志
# 进入日志所在目录 获取10天前的日期 删除开始到该日期的所有日志
cd ${SHELLDIR}
date=`date -d "-10 days" +%Y-%m-%d`
delline=`sed -n  "/${date}/=" ./${logfilename}| head -1`
delline=`expr ${delline} - 1 > /dev/null 2>&1`
sed -i "1,${delline}d" ./${logfilename} > /dev/null 2>&1  # 不处理错误信息

