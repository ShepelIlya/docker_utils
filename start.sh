#!/bin/bash

BASE_PATH="`dirname \"$0\" `"
source $BASE_PATH/docker.sh

function usage() {
	local me=`basename "$0"`
	echo "
Usage: $me -i=IMAGE [OPTIONS]

Run a container from IMAGE in detach mode.
Also, adds volume ~/volumes/data -> /volumes/data.

Options:
  -i=IMAGE
                IMAGE = [IMAGE_ID|REPOSITORY:TAG]
  --name=CONTAINER_NAME
                Length of string should be more than 1 symbol.
  --net=NETWORK
                Name of docker network driver.
                Default network driver is 'host'.

$me --help  - this message.

Example:
$me -i=sdbcs/ros1:melodic-dev --name=melodic --catkin_ws=/home/user/volumes/catkin_ws"

}

IMAGE="chepsi/mipt_ros_example:latest"
NAME="mfti"
NETWORK=""

function local_volumes() {
	if [ ! -d "/home/user/temp" ]; then
		mkdir -p /home/user/temp
	fi

	volumes="-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
						-v /home/$USER/.Xauthority:/home/user/.Xauthority \
						-v /dev:/dev \
						-v /etc/localtime:/etc/localtime:ro \
						-v /home/$USER/temp:/home/user/temp"
	echo "${volumes}"
}

function parse_params() {
	for i in "$@"
	do
	case $i in
			-i=*|--image=*)
			IMAGE="${i#*=}"
			shift # past argument=value
			;;
			--name=*)
			NAME="${i#*=}"
			shift # past argument=value
			;;
			--net=*)
			NETWORK="${i#*=}"
			shift # past argument=value
			;;
			--help)
				usage
				exit 0
			shift # past argument with no value
			;;
			*)
				local me=`basename "$0"`
				echo "Wrong usage!
To get help type: $me --help

Example of usage:
$me -i=sdbcs/ros1:melodic-dev --name=melodic --catkin_ws=/home/user/volumes/catkin_ws"
				exit 0
			;;
	esac
	done
}

function prerun() {
	local name=$1
	if [ "${USER}" != "root" ]; then
		docker exec $name /bin/bash -c '/root/scripts/docker_adduser.sh'
	fi
	docker exec $name /bin/bash -c 'cp /root/scripts/ros1_entrypoint.sh /home/user/ros1_entrypoint.sh; \
	chown user /home/user/ros1_entrypoint.sh;'
}

USER_ID=$(id -u)
GRP=$(id -g -n)
GRP_ID=$(id -g)

if [ $# -eq 0 ]
then
  echo "Starting with default parameters:
  image: $IMAGE
  name:  $NAME"
fi

parse_params $@
image=$IMAGE
name=$NAME
network=$NETWORK
name_string=""
if [ "$name" = "" ]; then
	name_string=""
else
	name_string="--name $name"
fi
if [ "$network" = "" ]; then
	network="host"
fi
id=$(docker run -it -d --rm \
	--env="DISPLAY" \
	--env="QT_X11_NO_MITSHM=1" \
	--privileged \
	$name_string \
	-e http_proxy=$http_proxy \
	-e https_proxy=$https_proxy \
	-e DOCKER_USER=$USER \
	-e USER=$USER \
	-e DOCKER_USER_ID=$USER_ID \
	-e DOCKER_GRP="$GRP" \
	-e DOCKER_GRP_ID=$GRP_ID \
	--net $network \
	$(local_volumes) \
	--cap-add=NET_ADMIN \
	$image)
if [ ! -z "$id" ]
then
	name="$(get_container_name $id)"
	prerun $name
	docker ps --format "{{.ID}} {{.Names}} {{.Networks}}" --filter id=$id
fi
