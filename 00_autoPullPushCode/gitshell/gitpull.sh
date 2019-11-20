# !/bin/bash

# 获取执行脚本的绝对路径
SHELLDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd ${SHELLDIR}
# echo ${SHELLDIR}
# 输入空行 与 时间
echo "" >> ./gitlog
echo "`date -d "-10 days" "+%Y-%m-%d %H:%M:%S"`" >> ./gitlog

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
        echo "${GITPATH} ${PULL} ${ORIGIN} ${MASTER}" >> ./gitlog
        # 进入目录 && git Pull
        cd $GITPATH && 
        message=`git pull ${ORIGIN} ${MASTER} 2>&1` &&
        cd ${SHELLDIR} && echo "${message}" >> ./gitlog

        # 如果存在冲突或者错误终止，将 config.ini 文件中的相应仓库设置为faluse,暂停该仓库的操作
        if [[ ${message} =~ "ERROR" ]] || [[ ${message} =~ "FATAL" ]] || [[ ${message} =~ "CONFLICT" ]]
        then
            # 发送邮件 mail ＋参数可以直接发送邮箱
            echo "${message}" | mail -s "git pull conflit `date -d "-10 days" "+%Y-%m-%d %H:%M:%S"`" 1308145492@qq.com &&
            # 设置该仓库为FALUSE
            echo `pwd` >> ./gitlog 
        fi 

        sleep 5;
    fi
done

# 日志处理，只保存7天日志
# 进入日志所在目录 获取10天前的日期 删除开始到该日期的所有日志
cd ${SHELLDIR}
date=`date -d "-10 days" +%Y-%m-%d`
delline=`sed -n  "/${date}/=" ./gitlog | head -1`
delline=`expr ${delline} - 1`
# 不处理错误信息
sed -i "1,${delline}d" ./gitlog > /dev/null 2>&1

#判断日志文件，如果大于1000line 删除第一个空行行到第二个空行之间的内容
# delline=`sed -n  "/`date -d "-10 days" +%Y-%m-%d`/=" ./log | tail -1`
# sed -i "1,${delline}d" ./gitlog 

# fileline=`cat ./gitlog | wc -l`
# while test $[fileline]  -gt 1000
# do
#     spaceline=`sed -n '/[a-zA-Z0-9@#$%^&*]/!=' ./gitlog`;

#     dellinestart=`echo ${spaceline} | awk '{print $1}'` &&
#     dellineend=`echo ${spaceline} | awk '{print $2}'` &&
#     dellinestart=`expr ${dellinestart} + 1`

#     # sed -i "${dellinestart},${dellineend}d" ./gitlog > /dev/null
#     sed -i "${dellinestart},${dellineend}d" ./gitlog 

#     if [ $? -ne 0 ]; then
#         sed -i "${dellinestart},+100d" ./gitlog  > /dev/null
#     fi

#     fileline=`cat ./log | wc -l`
# done
