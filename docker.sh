
function is_image_exists() {
  local image=${1:?"Empty image_name parameter!"}
  imageExists=`docker images --format "{{.Repository}}:{{.Tag}}" | grep $image -c`
  echo "$imageExists"
}

function is_container_exists(){
  local container_name=${1:?"Empty container_name parameter!"}
  containerExists=`docker ps -a --format "{{.Names}}" | grep $name -c`
  echo "$containerExists"
}

function get_container_name() {
	local id=$1
	name=$(docker ps -f "id=$id" --format "{{.Names}}")
	echo $name
}

function process_existed_container() {
	local name=${1:?"Empty container_name parameter!"}
	local autoremove=${2:-0}
  local yes_no="no"
  echo "Container $name already exists! Remove it ?(yes/no)"
  if [[ $autoremove -ne 1 ]];
  then
    read yes_no
  else
    yes_no="yes"
    echo "yes"
  fi
  if [ "$yes_no" = "Yes" ] || [ "$yes_no" = "yes" ]; then 
    docker stop $name
    docker rm $name
  else
    echo "Exit..."
    exit 0
  fi
}