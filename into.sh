#!/bin/bash


name="mfti"

path="~/"
if [ $# -eq 2 ]; then
	path=$2
fi

xhost +local:root 1>/dev/null 2>&1
docker exec --user "user" -it $name /bin/bash -c ". ~/ros1_entrypoint.sh; export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib; cd $path && /bin/bash"
xhost -local:root 1>/dev/null 2>&1
