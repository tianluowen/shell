#!/bin/bash

# 配置文件名 与 函数名
logfilename="./log"
configfilename="./gitconfig.ini"


# test 多字符串匹配
function testmangstr() {
    # message="testFATLidjfdiconfliticCONFLITICk"
    if [[ ${message} =~ "ERROR" ]] || [[ ${message} =~ "FATAL" ]] || [[ ${message} =~ "CONFLITIC" ]]; then  
        echo ${message}
        # 发送邮件                                                                                                                                                          
        # 设置该仓库为FALUSE                                                                                                                                                
    fi       
}


# test 文件字符匹配
function teststr() {
    message="test abc
    def kfsfksslgjg"
    if [[ "${message}" =~ "abc" ]];
    then
        echo 111111
    fi
}


# 日志处理，只保存10天日志
# managelog ${logfilename}
function managelog() {
    # 进入日志所在目录 获取10天前的日期 删除开始到该日期的所有日志
    cd ${SHELLDIR}
    date=`date -d "-10 days" +%Y-%m-%d`
    delline=`sed -n  "/${date}/=" $1 | head -1`
    delline=`expr ${delline} - 1 > /dev/null 2>&1`
    sed -i "1,${delline}d" $1 > /dev/null 2>&1  # 不处理错误信息
}


# 删除文件中最后一个空白行
# 删除 gitpull 时候日志添加的空行，显得日志整齐，每一次操作日志被空行分隔开，也方便查看
# deltailspaceline ${logfilename}
function deltailspaceline() {
    delteline=sed -n '/[a-zA-Z0-9@#$%^&*]/!=' $1 | tail -1 &&
    sed "${delteline},+1d"
}


# 把配置文件中的 FAULSE 全部修改为 TRUE
# changfulsetotrue ${configfilename}
function changfulsetotrue() {
    sed -i "s/FAULSE/TRUE/g" ./gitconfig.ini
    # sed -i "s/FAULSE/TRUE/g" $1 
}


# 判断日志文件，如果大于1000line 删除第一个空行行到第二个空行之间的内容
# deltwospacelineinfo ${logfilename}
function deltwospacelineinfo() {
    fileline=`cat ./$1 | wc -l`

    while test $[fileline]  -gt 500
    do
        spaceline=`sed -n '/[a-zA-Z0-9@#$%^&*]/!=' ./$1`;

        dellinestart=`echo ${spaceline} | awk '{print $1}'` &&
        dellineend=`echo ${spaceline} | awk '{print $2}'` &&
        dellinestart=`expr ${dellinestart} + 1`

        # sed -i "${dellinestart},${dellineend}d" ./git.log > /dev/null
        sed -i "${dellinestart},${dellineend}d" ./$1 > /dev/null 2>&1

        if [ $? -ne 0 ]; then
            sed -i "${dellinestart},+100d"  ./$1 > /dev/null 2>&1
        fi

        fileline=`cat ./$1 | wc -l`
    done
}


# 获取执行脚本的绝对路径 保证日志输出在正确的位置
# 该方法有时候会存在问题
# 该命令会获得，脚本当前所在的目录 PATH
# 所以在shell 脚本执行后 运行该命令确实可以获得脚本存放位置 
# 但是一旦切换了目录，就只能获得当前所在目录的 PATH
# getshellpath() 
function getshellpath() {
    SHELLDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    echo $SHELLDIR
    cd ${SHELLDIR}
}

  
# 输入空行 与 时间 作为开始标识
# printstartlog ${logfilename}
function printstartlog() {
    echo "" >> ./$1
    echo `date "+%Y-%m-%d %H:%M:%S"` >> ./$1
}

