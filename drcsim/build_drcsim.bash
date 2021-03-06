#!/bin/bash

GIT_DIRECTORY=$(pwd)
echo $GIT_DIRECTORY

source ~/.bashrc

if [ -d ~/drcsim_ws ] ; then
  cd ~/drcsim_ws
  exit 0
fi

# install dependencies
sudo apt-get install -y cmake debhelper avr-libc gcc-avr libqt4-dev libtinyxml-dev mercurial

# create folder and clone repository
mkdir -p ~/drcsim_ws/src
cd ~/drcsim_ws/src

hg clone https://bitbucket.org/osrf/osrf-common
hg clone https://bitbucket.org/osrf/sandia-hand
hg clone https://bitbucket.org/osrf/drcsim
git clone https://github.com/ros-simulation/gazebo_ros_pkgs.git -b hydro-devel
git clone -b hydro-devel https://github.com/ros-controls/ros_control.git
git clone -b hydro-devel https://github.com/ros-controls/ros_controllers.git
git clone -b hydro-devel https://github.com/ros-controls/control_toolbox.git
git clone -b hydro-devel https://github.com/ros-controls/realtime_tools.git
git clone -b hydro-devel https://github.com/ros/common_msgs.git

# Remove link to ros source CMakeLists.txt and insert a line into our own one.
#cp /home/$USER/drcsim_ws/src/CMakeLists.txt ~/drcsim_ws/src/CMakeLists.txt.bak
rm -f /home/$USER/drcsim_ws/src/CMakeLists.txt
#cp /home/$USER/drcsim_ws/src/CMakeLists.txt.bak ~/drcsim_ws/src/CMakeLists.txt
cp ${ROS_INSTALL_DIR}/share/catkin/cmake/toplevel.cmake /home/$USER/drcsim_ws/src/CMakeLists.txt
sed -i '/set(CATKIN_TOPLEVEL TRUE)/aset(CMAKE_CXX_FLAGS \"${CMAKE_CXX_FLAGS} -std=c++11\")' /home/$USER/drcsim_ws/src/CMakeLists.txt

source ~/.bashrc

# build drcsim
cd ~/drcsim_ws
catkin_make install

# copy over new setup script that hasn't hardcoded the location as /opt/ros/hydro
#cp -f ${GIT_DIRECTORY}/drcsim/setup.sh /home/$USER/drcsim_ws/install/setup.sh

# source the stuff
COUNT=$(grep -a "source /home/$USER/drcsim_ws/install/setup.bash" ~/.bashrc | wc -l)
if [ $COUNT -eq 0 ] ; then
  echo "source /home/$USER/drcsim_ws/install/setup.bash" >> ~/.bashrc
fi

COUNT=$(grep -a "source /home/$USER/drcsim_ws/install/share/drcsim/setup.sh" ~/.bashrc | wc -l)
if [ $COUNT -eq 0 ] ; then
  echo "source /home/$USER/drcsim_ws/install/share/drcsim/setup.sh" >> ~/.bashrc
fi

exit 0
