# This file is the entry point for drcsim users.  It should establish
# all environment necessary to use drcsim.

source ~/.bashrc

# Skip ROS setup if the DRCSIM_SKIP_ROS_GAZEBO_SETUP environment variable
# is set (to anything).
if [ -z "$DRCSIM_SKIP_ROS_GAZEBO_SETUP" ]; then
  # Step 1: load ROS configuration.  Special case for different shells,
  # to pull in command-line completion.
  if [ "$SHELL" = /bin/bash ]; then
    . ${ROS_ROOT}/../../setup.bash
  elif [ "$SHELL" = /bin/zsh ]; then
    . ${ROS_ROOT}/../../setup.zsh
  else
    . ${ROS_ROOT}/../../setup.sh 
  fi

  # Step 2: if present, load catkin-generated setup.sh from the root of our
  # install location.  This file won't be there in a binary deb, but it will be
  # there in a from-source build.  We need to source this file to get the catkin
  # magic that enables proper ROS-package-relative location of resources
  # (launch files, etc.).
  if [ -f /home/$USER/drcsim_ws/install/setup.sh ]; then
    . /home/$USER/drcsim_ws/install/setup.sh 
  fi
fi

# Step 3: Modify LD_LIBRARY_PATH to include some unusual locations.
# Make AtlasSimInterface plugins visible to the runtime loader
export LD_LIBRARY_PATH=/home/$USER/drcsim_ws/install/lib/AtlasSimInterface_1.1.1:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/home/$USER/drcsim_ws/install/lib/AtlasSimInterface_2.10.2:$LD_LIBRARY_PATH
# Make Gazebo-ROS plugins visible to the runtime loader; they'll be
# pulled in by ROS via pluginlib
export LD_LIBRARY_PATH=/home/$USER/drcsim_ws/install/lib/drcsim_gazebo_ros_plugins/plugins:$LD_LIBRARY_PATH

# Skip Gazebo setup if the DRCSIM_SKIP_ROS_GAZEBO_SETUP environment variable
# is set (to anything).
if [ -z "$DRCSIM_SKIP_ROS_GAZEBO_SETUP" ]; then
  # Step 4: get Gazebo configuration.
  if [ -f /usr/local/share/gazebo/setup.sh ]; then
    . /usr/local/share/gazebo/setup.sh 
  elif [ -f /usr/share/gazebo/setup.sh ]; then
    . /usr/share/gazebo/setup.sh  
  else
    echo "Warning: failed to find Gazebo's setup.sh.  You will need to source it manually."
  fi
fi

# Step 5: modify Gazebo configuration.
# Add our top-level directory to GAZEBO_RESOURCE_PATH so that its
# media/materials/* stuff can be found.
export GAZEBO_RESOURCE_PATH=/home/$USER/drcsim_ws/install/share/drcsim_model_resources:$GAZEBO_RESOURCE_PATH
# Add our worlds directory to GAZEBO_RESOURCE_PATH so that *.world files can be
# found without giving a full path.
export GAZEBO_RESOURCE_PATH=/home/$USER/drcsim_ws/install/share/drcsim_model_resources/worlds:$GAZEBO_RESOURCE_PATH
# export GAZEBO_RESOURCE_PATH=/home/alec/drcsim_ws/install/share/drcsim_model_resources-/worlds:$GAZEBO_RESOURCE_PATH

# add path to gazebo standalone models generated by atlas_description
export GAZEBO_MODEL_PATH=/home/$USER/drcsim_ws/install/share/drcsim_gazebo_standalone_models:$GAZEBO_MODEL_PATH

# add path to gazebo models from drcsim_model_resources
export GAZEBO_MODEL_PATH=/home/$USER/drcsim_ws/install/share/drcsim_model_resources/gazebo_models/environments:/home/$USER/drcsim_ws/install/share:$GAZEBO_MODEL_PATH

# Add the directories containing our Gazebo plugins to GAZEBO_PLUGIN_PATH.
export GAZEBO_PLUGIN_PATH=/home/$USER/drcsim_ws/install/lib/drcsim_gazebo_ros_plugins/plugins:$GAZEBO_PLUGIN_PATH
