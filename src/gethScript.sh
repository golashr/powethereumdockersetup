#!/bin/bash

sudo apt install xterm -y
# sudo apt-get install parallel -y
mkdir PoA && cd PoA
mkdir nodeA

geth --datadir nodeA/ account new
#geth --datadir nodeB/ account new

cd nodeA/keystore
echo "---------------Address of account 1------------------"
account1=0x$(cat UTC--* | awk -F: "{ print $2 }" | tr "," "\n" | head -n1 | cut -d ':' -f 2 | cut -d '"' -f 2) 
echo "$account1";

#cd ../../nodeB/keystore
#echo "---------------Address of account 2------------------"
#account2=0x$(cat UTC--* | awk -F: "{ print $2 }" | tr "," "\n" | head -n1 | cut -d ':' -f 2 | cut -d '"' -f 2) 
#echo "$account2";

cd ../../
echo "---------------Create Genesis File-------------------"
echo "#### Attention ####"
echo "_____Press Ctrl+d to stop the Puppeth, Ctrl+c will stop the Shell Script"
puppeth

echo "Genesis File Created"
echo "_______________________________________"
cd PoA
# cat *.json

echo "##### Initializing the Nodes #####";
echo "----NodeA----"
geth --datadir nodeA/ init *.json
#echo "----NodeB----"
#geth --datadir nodeB/ init *.json
echo "##### Nodes Initialized #####";

networkid=$(cat *.json | grep "chainId" | awk '{print $2}' | cut -d "," -f 1);
echo "NetworkId: $networkid";
echo "password" > nodeA/password
#echo "password" > nodeB/password

echo "Folder Structure"
tree -L 20
sleep 7s

echo "##### Running NodeA #####"
geth --datadir nodeA/ --syncmode 'full' --port 30301 --rpc --rpcaddr 'localhost' --rpcport 8545 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --networkid $networkid --gasprice '1' -unlock $account1 --password nodeA/password --mine --rpccorsdomain '*' console "*"

#geth --datadir nodeA/ --syncmode 'full' --port 30302 --rpc --rpcaddr 'localhost' --rpcport 8546 --rpcapi 'personal,db,eth,net,web3,txpool,miner' --networkid 7789 --gasprice '1' -unlock '0x9e5c5ca7b81011921a81ef3477555cbe82cac981' --password nodeA/password --mine --rpccorsdomain '*' console "*"
