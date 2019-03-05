#!/bin/bash

# Variable for config file path
vpsVIVODefinitionFile=vpsVIVoDefs.txt

# Each masternode needs:
# - Index
# - Port
# - IP Address (Singular to begin)

mncount=0
index=0
initialise() {
    echo "Cleaning up existing vpsVIVO deployment"
    rm -rf vpsVIVO/
	rm allowport.sh
    # This should be changed to ensure we are in a specific directory first.
	cd
}

deployPrereqs() {
    apt-get install -y build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils screen git
}

getMasternodeCount() {
	echo "++++++++++++++++"
    echo "This will add the next masternode you have. Example: If you have 1 masternode already, to add another one, enter 2 for the following question. How many (total) Vivo masternodes are you deploying? :"
    while :
        do
        echo -n "Masternode Count: "
        read mncount
        if [ $mncount -eq $mncount 2>/dev/null ] && [ "$mncount" -ge "1" ]
        then
            echo "$mncount Vivo Masternodes will be deployed."
		((mncount++))
             break
        else
            echo "$mncount is not valid"
		index=0
        fi
    done
}

getMasternodePrivKey() {

	if [ -f /root/pk_vivo_$index.txt ]; then
		echo -n "Private key for Mn $index being used is: "
		cat /root/pk_vivo_$index.txt
		echo " "
		echo "Not changing pivate key"
		return 0
	fi

    echo "=================================="
    while :
        do
        echo -n "Private Key for masternode $index: "
        read mnprivkey < /proc/self/fd/2
        if [ ! "$(echo -n $mnprivkey | wc -c)" = "51" ]
        then
            echo "Invalid masternode private key given, try again"
        else
	echo "masternodeprivkey=$mnprivkey" > /root/pk_vivo_$index.txt
            break
        fi
    done
}


getMasternodePort() {

	if [ -f mnport_vivo_$index.txt ]; then
		echo -n "Port being used: "
		cat mnport_vivo_$index.txt
		echo " "
		return 0;
	else
		echo "default port is 12845, each masternode should have a different one"
	fi

    declare -i port_num
    echo "Please enter masternode port for masternode $index:"
    while :
        do
        echo -n "port: "
        read mnport < /proc/self/fd/2

	if [ $mnport -eq $mnport 2>/dev/null ]

	then
		port_num=$((10#$mnport + 0))

                echo "portnum is:${port_num}"

		if (( $port_num < 1 || $port_num > 65535 )) ; then
			echo "*** ${mnport} is not a valid port try again"
		else
			echo "$mnport" > mnport_vivo_$index.txt
			echo "ufw allow $mnport" >> allowport.sh
		    cp /root/ip4_1.txt /root/ip4_$index.txt
            break
		fi

	else
		echo " not an integer"
	fi
    done
}

deployMasternodes() {
    # Some additional directory structure and management will be needed here
    # The RPC port will also need to be unique for each daemon
	rm -rf vpsVivo
    git clone https://github.com/rareko/vpsVivo.git
    cd vpsVivo
    ((mncount--))
    echo "masternodecount to deploy $mncount" > ~/masternodecount.txt
    ./installNG.sh -p vivo -n 4 -c $mncount -s -d -b
    echo "To look at status of the masternode run:"
    echo "/root/vpsVivo/overAllMnStat.sh"
    echo "The masternode will start and stop on its own, it is a service."
}

main() {
    deployPrereqs
	echo "-------------------------------"
    initialise
    getMasternodeCount
    # For number of masternodes do: # AND store in array with Index


for (( index=1; $index < $mncount; ++index)); do
    getMasternodePrivKey
    #getMasternodeIP
    getMasternodePort
done
	chmod +x allowport.sh
	./allowport.sh
	rm allowport.sh
    deployMasternodes
    # Done
}

main
