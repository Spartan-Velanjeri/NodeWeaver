#! /bin/bash

ROS_PATH=/opt/ros/galactic/setup.bash
WS=/bautiro_environment/bautiro_setup_378.bash # modify this when working in local workspace
SWSM=/bautiro_environment/bautiro_it_infrastructure/scripts/install_ws_manager.sh
source ${ROS_PATH}
source ${WS}

# LOCAL_PKG="bautiro"
# LOCAL_PKG_INSTALL_PATH=$(ros2 pkg prefix ${LOCAL_PKG})
# LOCAL_PKG_WORKSPC_PATH=$(ros2 pkg prefix ${LOCAL_PKG} | sed --expression='s/install/src/g')

SESSION=robot_bringup

tmux kill-session -t ${SESSION}
tmux new-session -s ${SESSION} -d -n build


WINDOW0=${SESSION}:0
WINDOW1=${SESSION}:1
WINDOW2=${SESSION}:2
WINDOW3=${SESSION}:3
WINDOW4=${SESSION}:4
# pane=${WINDOW}.4

#Create window
tmux new-window -t ${WINDOW1} -n ur_drivers 
tmux select-window -t ${WINDOW1}
#tmux split-window -h  #0.1
#tmux split-window -v  #0.2
tmux new-window -t ${WINDOW2} -n moveit
tmux select-window -t ${WINDOW2}
#tmux split-window -h  #0.1
#tmux split-window -v  #0.2
tmux new-window -t ${WINDOW3} -n hu_motion
tmux select-window -t ${WINDOW3}
tmux split-window -h  #0.1
#tmux split-window -v  #0.2

tmux new-window -t ${WINDOW4} -n action_cmd
tmux select-window -t ${WINDOW4}
tmux split-window -h  #0.1
tmux split-window -v  #0.2
#tmux split-window -h  #0.1
#tmux split-window -v  #0.2
# Create panes

tmux select-layout tiled


# Send commands
# CMD_PATH="bash ${LOCAL_PKG_WORKSPC_PATH}/launch/fus1/"
tmux send-keys -t ${WINDOW0}.0 C-z "source ${SWSM} && cd /bautiro_environment" Enter


tmux send-keys -t ${WINDOW1}.0 C-z "source ${WS} && ros2 launch ur_bringup ur_control.launch.py ur_type:=ur16e robot_ip:=192.168.2.3 launch_rviz:=false prefix:=hu_ initial_joint_controller:=joint_trajectory_controller" Enter

tmux send-keys -t ${WINDOW2}.0 C-z "source ${WS} && ros2 launch fpm_moveit ur_moveit.launch.py launch_rviz:=false" Enter

tmux send-keys -t ${WINDOW3}.0 C-z "source ${WS} && ros2 launch handling_unit_motion_manager main.launch.py" Enter

tmux send-keys -t ${WINDOW3}.1 C-z "source ${WS} && ros2 launch hu_behavior_tree hu_tree_bringup.launch.py" Enter

tmux send-keys -t ${WINDOW4}.0 C-z "source ${WS} && echo window 3 pane 0"
tmux send-keys -t ${WINDOW4}.1 C-z "source ${WS} && echo window 3 pane 1"


#Example with delays
#tmux send-keys -t ${WINDOW0}.2 C-z "source ${ROS_PATH} && source ${WS} && sleep 15 && ros2 launch ur_bringup ur_control.launch.py ur_type:=ur16e robot_ip:=10.30.36.200 launch_rviz:=false headless_mode:=true" Enter
#tmux send-keys -t ${WINDOW0}.3 C-z "source ${ROS_PATH} && source ${WS} && sleep 25 && ros2 launch bautiro_bringup bautiro_bringup.launch.py" Enter

#tmux send-keys -t ${WINDOW1}.4 C-z "source ${ROS_PATH} && source ${WS} && ros2 run groot Groot --mode monitor --publisher_port 2200 --server_port 2201" Enter
#tmux send-keys -t ${WINDOW1}.5 C-z "source ${ROS_PATH} && source ${WS} && ros2 action send_goal /hu_start bautiro_ros_interfaces/action/StartHuMainTask "{start: true, bt_xml: "moveit_program_control.xml"}""

#tmux set-option -g mouse on

#Select initial window
tmux select-window -t ${WINDOW1}

# Attach to the session
tmux attach-session -t "${SESSION}"