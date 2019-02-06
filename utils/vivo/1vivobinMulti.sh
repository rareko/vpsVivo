#!/bin/bash

# Variable for config file path
vpsVIVODefinitionFile=vpsVIVoDefs.txt

# Each masternode needs:
# - Index
# - Port
# - IP Address (Singular to begin)

initialise() {
    echo "Cleaning up existing vpsVIVO deployment"
    rm -rf vpsVIVO/
    # This should be changed to ensure we are in a specific directory first.
}

deployPrereqs() {
    apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils screen git
}

getMasternodeCount() {
    echo "How many Vivo masternodes are you deploying? :"
    while :
        do
        echo -n "Masternode Count: "
        read mncount
        if [ $mncount -eq $mncount 2>/dev/null ] && [ "$mncount" -ge "1" ]
        then
            echo "$mncount Vivo Masternodes will be deployed."
             break
        else
            echo "$mncount is not valid"
        fi
    done
}

getMasternodePrivKey() {
    echo "Please enter masternode private key and copy it here:"
    while :
        do
        echo -n "Private Key: "
        read mnprivkey < /proc/self/fd/2
        if [ ! "$(echo -n $mnprivkey | wc -c)" = "51" ]
        then
            echo "Invalid masternode private key given, try again"
        else
            break
        fi
    done
}
getMasternodePort() {
    echo "Please enter masternode port:"
    while :
        do
        echo -n "\port: "
        read mnport < /proc/self/fd/2
        if [ ## Check validty of port ## ]
        then
            echo "Invalid masternode port, try again"
        else
            break
        fi
    done
}

deployMasternodes() {
    # Some additional directory structure and management will be needed here
    # The RPC port will also need to be unique for each daemon

    git clone https://github.com/coolblock/vpsVivo.git
    cd vpsVivo
    ./installNG.sh -p vivo -n 4 -c 1 -s -d -b
    echo "To look at status of the masternode run:"
    echo "/root/vpsVIVO/overAllMnStat.sh"
    echo "The masternode will start and stop on its own, it is a service."
}

main() {
    initialise
    deployPrereqs
    getMasternodeCount
    # For number of masternodes do: # AND store in array with Index
    getMasternodePrivKey
    getMasternodeIP
    getMasternodePort
    # Done
}

main
