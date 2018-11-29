#!/usr/bin/env bash

# usage
# sh test/python/read-test.sh 3 http://invisible-hound-kairosdb-app greg4 144000 1000 50
# sh test/python/read-test.sh 3 http://romping-wolf-kairosdb-app greg3 144000 1000 50

JOBS=$1
KAIROS=$2
NAME=$3
HOURS=$4
DEVICES=$5
VOLUMES=$6
WRITERS=$7

QUERIES=50000

# IMAGE=gcmcnutt/ktest:lyu19
IMAGE=quay.io/yugabyte/kairosdb-loader:latest
CONTEXT=aws

for i in $(seq 1 $JOBS)
do
 kubectl \
    --image $IMAGE \
    --image-pull-policy=Always \
    --restart=Never \
    --labels=group=$NAME-r,agent=$i \
    --requests=cpu=100m,memory=50Mi \
    run $NAME-$i-r -- sh -c "KAIROS=$KAIROS WRITERS=$WRITERS QUERIES=$QUERIES METRIC_BASE=$NAME HOURS=$HOURS DEVICES=$DEVICES VOLUMES=$VOLUMES python random_read.py"
done
