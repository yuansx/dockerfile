#!/bin/bash
OLDIP_FILE=/usr/local/resin/oldip
OLDIP=“172.17.0.2”

if [ -f $OLDIP_FILE ]; then
    read OLD_IP < $OLDIP_FILE
fi

hostip=`ifconfig eth0 | grep inet | awk '{print $2}'`
echo $hostip > $OLDIP_FILE

sed -i "s/$OLD_IP/$hostip/g" `grep $OLD_IP -Irl /data/ | grep -v log`
sed -i "s/$OLD_IP/$hostip/g" `grep $OLD_IP -Irl /usr/local/resin/webapps/seer-1.0.0-SNAPSHOT/`

/data/tseer_test/etcd//bin/etcd --name tseer_etcd0 -data-dir /data/tseer_test/etcd//datadir/tseer_etcd0/ -initial-advertise-peer-urls http://${hostip}:2380 -listen-peer-urls http://${hostip}:2380 -listen-client-urls http://${hostip}:2379 -advertise-client-urls http://${hostip}:2379 --initial-cluster tseer_etcd0=http://${hostip}:2380,tseer_etcd1=http://${hostip}:3380,tseer_etcd2=http://${hostip}:4380 -initial-cluster-state new & >> /data/tseer_test/etcd/log/tseer_etcd0.log
/data/tseer_test/etcd//bin/etcd --name tseer_etcd1 -data-dir /data/tseer_test/etcd//datadir/tseer_etcd1/ -initial-advertise-peer-urls http://${hostip}:3380 -listen-peer-urls http://${hostip}:3380 -listen-client-urls http://${hostip}:3379 -advertise-client-urls http://${hostip}:3379 --initial-cluster tseer_etcd0=http://${hostip}:2380,tseer_etcd1=http://${hostip}:3380,tseer_etcd2=http://${hostip}:4380 -initial-cluster-state new & >> /data/tseer_test/etcd/log/tseer_etcd1.log
/data/tseer_test/etcd//bin/etcd --name tseer_etcd2 -data-dir /data/tseer_test/etcd//datadir/tseer_etcd2/ -initial-advertise-peer-urls http://${hostip}:4380 -listen-peer-urls http://${hostip}:4380 -listen-client-urls http://${hostip}:4379 -advertise-client-urls http://${hostip}:4379 --initial-cluster tseer_etcd0=http://${hostip}:2380,tseer_etcd1=http://${hostip}:3380,tseer_etcd2=http://${hostip}:4380 -initial-cluster-state new & >> /data/tseer_test/etcd/log/tseer_etcd2.log

/data/tseer_test/Tseer/TseerAgent/util/start.sh
/data/tseer_test/Tseer/TseerServer/util/start.sh

/usr/local/resin/bin/resin.sh start

