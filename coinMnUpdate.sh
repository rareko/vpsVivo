##!/usr/bin/env bash
#set -x
#trap read debug
if [ $# -le 1 ]; then
    echo $0: usage: you have to give coin name in lower case as param and how many masternodes - coinMnInstall.sh pivx 1
    exit 1
fi
rm -rf /root/vivoMnIp4
COIN_NAME=$1
cd
mkdir /var/log/sentinel
rm -rf /root/vpsVIVO/
git clone https://github.com/coolblock/vpsVivo.git 
cd vpsVivo/
#git checkout v1.0 
chmod +x installNG.sh
./installNG.sh -p ${COIN_NAME} -n 4 -s -c "$2" -u
echo "Will try to restart vivod if it exists"
killall vivod
echo "otherwise, will start on its own"
echo "to get status run the following line"
echo "/root/vpsVivo/overAllMnStat.sh"