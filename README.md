# ROS Intro

Please ask all questions about setup at the issues section with 'question' or 'help wanted' label.

### Ubuntu 16.04
[Image](http://releases.ubuntu.com/16.04/)

### ROS Kinetic Kame 
[Installation guide](http://wiki.ros.org/kinetic/Installation/Ubuntu)

### Docker CE
[Installation guide](https://docs.docker.com/install/linux/docker-ce/ubuntu/)

[Manage Docker as a non-root user](https://docs.docker.com/install/linux/linux-postinstall/)

### Special docker image for workshop
Docker Hub:   [link](https://hub.docker.com/r/chepsi/mipt_ros_example)

For pulling image from docker hub (if you have a docker account):
```bash
docker pull chepsi/mipt_ros_example
```

Google Drive: [link](https://drive.google.com/open?id=1ySC5t2DncXSdgLvcYsx8lc74KmJah3x2)

For loading image from .tar archive:
```bash
docker load < mipt_ros_example.tar
```

### Scripts for running docker container
Clone this repo:

```bash
git clone https://github.com/ShepelIlya/docker_utils.git
```

### V-REP PRO EDU 3.5.0 with custom messages and scenes
Download and unzip .tar.gz archive.

Google Drive: [link](https://drive.google.com/open?id=1gUgCpGeNuDRZrkZyER7ZpE-dgn-gJqGE)

Install additional libs:

```bash
sudo apt install git cmake python-tempita python-catkin-tools python-lxml default-jre xsltproc libbullet-dev
```

Create VREP_ROOT env:
```bash
# if you use bash (for zshell use .zshrc)
echo 'export VREP_ROOT="path_to_vrep_folder/V-REP_PRO_EDU*"' >> ~/.bashrc
source ~/.bashrc
```

### Practical part of workshop 
To convert messages the easiest way we need one package from ros community. Clone it with this command:
```bash
git clone https://github.com/eric-wieser/ros_numpy.git
```

### Useful links
[ROS Tutorials](http://wiki.ros.org/ROS/Tutorials)

[Creating package](http://wiki.ros.org/ROS/Tutorials/CreatingPackage)

[Writing publisher/subscriber](http://wiki.ros.org/ROS/Tutorials/WritingPublisherSubscriber%28python%29)

# How to check that all is ok?
Terminal 1:
```bash
docker_utils/start.sh
docker_utils/into.sh
. ./ros1_entrypoint.sh
roscore
```

Terminal 2:
```bash
cd $VREP_ROOT
./vrep.sh
```
In V-REP:

File &#8594; Open scene &#8594; flat_polygon.ttt 
After play scene

Terminal 3:
```bash
docker_utils/into.sh
. ./ros1_entrypoint.sh
roslaunch ~/catkin_ws/test.launch
```

Terminal 4:
```bash
rviz
```
In Rviz:

File &#8594; Open config &#8594; rviz_cfg.rviz

If you can see map and point cloud from V-REP in Rviz then you are ready for workshop!
