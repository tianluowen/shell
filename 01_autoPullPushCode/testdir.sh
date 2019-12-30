# !/bin/bash

SHEL="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $SHEL

. ./gitshell/git.sh
SHEL="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $SHEL

getshellpath

SHEL="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $SHEL

cd ..

SHEL="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $SHEL

cd ..

SHEL="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $SHEL
