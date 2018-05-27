#!/bin/bash

##original run_miner.sh
#NODE_NAME=$1
#NODE_NAME=${NODE_NAME:-"miner1"}
#ETHERBASE=${ETHERBASE:-"0x0000000000000000000000000000000000000001"}
#./runnode.sh $NODE_NAME $RPC_PORT --mine --minerthreads=1 --etherbase="$ETHERBASE"
##############

IMGVERSION=$(head -n 1 .IMGVERSION)
IMGVERSION=${IMGVERSION:-"latest"}
IMGNAME=$(head -n 1 .IMGNAME)
NODE_NAME=$1
RPC_PORT=$2
#NODEAPP_PORT1=$3
#NODEAPP_PORT2=$4
NODE_NAME=${NODE_NAME:-"node1"}
CONTAINER_NAME="ethereum-$NODE_NAME"
DATA_ROOT=${DATA_ROOT:-$(pwd)}
echo "Destroying old container $CONTAINER_NAME..."
sudo docker stop $CONTAINER_NAME
sudo docker rm $CONTAINER_NAME
NET_ARG=
GEN_ARG=
RPC_ARG=
RPC_PORTMAP=
UDP_PORTMAP=
#[[ ! -z $NET_ID ]] && NET_ARG="-e NET_ID=$NET_ID"
if [ ! -z $GEN_ALLOC ];then
GEN_ARG="-e GEN_ALLOC=$GEN_ALLOC"
fi
if [ ! -z $RPC_PORT ];then
RPC_ARG="--unlock 0 --password pwd.txt --mine --minerthreads 1 --rpc --rpcport $RPC_PORT --rpcaddr=0.0.0.0 --rpcapi=admin,eth,miner,debug,db,net,shh,txpool,personal,web3 --rpccorsdomain "*""
RPC_PORTMAP="-p $RPC_PORT:$RPC_PORT"
#NODEAPP_PORTMAP1="-p $NODEAPP_PORT1:$NODEAPP_PORT1"
#NODEAPP_PORTMAP2="-p $NODEAPP_PORT2:$NODEAPP_PORT2"
fi
if [ ! -z $UDP_PORT ];then
UDP_PORTMAP="-p $UDP_PORT:30303 -p $UDP_PORT:30303/udp"
fi

echo "GEN_ALLOC - $GEN_ALLOC"
echo "NET_ARG - $NET_ARG"
echo "GEN_ARG - $GEN_ARG"
echo "RPC_ARG - $RPC_ARG"
echo "RPC_PORTMAP - $RPC_PORTMAP"
echo "UDP_PORTMAP - $UDP_PORTMAP"
echo "RPC_PORT - $RPC_PORT"
echo "UDP_PORT - $UDP_PORT"
#echo "NODEAPP_PORTMAP1 = $NODEAPP_PORTMAP1"
#echo "NODEAPP_PORTMAP2 = $NODEAPP_PORTMAP2"

BOOTNODE_URL=${BOOTNODE_URL:-$(./getbootnodeurl.sh)}
echo "Running new container $CONTAINER_NAME..."

echo "BOOTNODE_URL: $BOOTNODE_URL"



sudo docker run -d --name $CONTAINER_NAME \
    -v $DATA_ROOT/.ether-$NODE_NAME:/root \
    --network CASHe \
    -e "BOOTNODE_URL=$BOOTNODE_URL" \
    $NET_ARG $GEN_ARG $RPC_PORTMAP $UDP_PORTMAP \
    $IMGNAME:$IMGVERSION $RPC_ARG --identity $NODE_NAME --syncmode full --cache=1024 --verbosity=4 --maxpeers=10 ${@:2}

#$NET_ARG $GEN_ARG $RPC_PORTMAP $NODEAPP_PORTMAP1 $UDP_PORTMAP 
