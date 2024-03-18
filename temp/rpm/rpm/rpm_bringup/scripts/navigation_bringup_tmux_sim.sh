#! /bin/bash
ROS_PATH=/opt/ros/galactic/setup.bash
WS=install/setup.bash # modify this when working in local workspace

source ${ROS_PATH}
source ${WS}

# get pat

SESSION=rpm_bringup_navigation

tmux kill-session -t ${SESSION}
tmux new-session -s ${SESSION} -d

WINDOW=${SESSION}:0

WINDOW_CCU=${SESSION}:1
WINDOW_RPM=${SESSION}:2
WINDOW_RPM2=${SESSION}:3
WINDOW_FPM=${SESSION}:4
WINDOW_HCU=${SESSION}:5
WINDOW_MISC=${SESSION}:6

#Create window
tmux new-window -t ${WINDOW_CCU} -n CCU 
tmux new-window -t ${WINDOW_RPM} -n RPM
tmux new-window -t ${WINDOW_RPM2} -n RPM2
tmux new-window -t ${WINDOW_FPM} -n FPM
tmux new-window -t ${WINDOW_HCU} -n HCU 
tmux new-window -t ${WINDOW_MISC} -n MISC


##### Start HCU  ####### 
tmux select-window -t ${WINDOW_HCU}
tmux split-window -h
## ToDo Command To start HCU on Ubuntu machine

##### Start CCU   #####
tmux select-window -t ${WINDOW_CCU}

# # launch decription + simulation
tmux send-keys -t ${WINDOW_CCU}.0 C-z "source ${ROS_PATH} && source ${WS} && ros2 launch bautiro_gazebo_simulation bautiro_spawn_gazebo_control.launch.py headless:=true" Enter

# launch only description for hardware
#tmux send-keys -t6 ${WINDOW_CCU}.0 C-z "source ${ROS_PATH} && source ${WS} && ros2 launch bautiro_bringup bautiro_description.launch.py robot_name:=FUS2 rpm_name:=RPM2" Enter

tmux split-window -h #0.1
### others command to start CCU
tmux split-window -v


##### Start RPM (part1) #####
tmux select-window -t ${WINDOW_RPM}
tmux split-window -h
tmux select-pane -t ${WINDOW_RPM}.0
tmux split-window -v
tmux split-window -v
tmux split-window -v
tmux select-pane -t ${WINDOW_RPM}.4
tmux split-window -v
tmux split-window -v
tmux split-window -v

# put command to panes

tmux send-keys -t ${WINDOW_RPM}.1 C-z "source ${ROS_PATH} && source ${WS} && ros2 launch rpm_localization rpm_localization_launch.py mode:=gazebo_sim hw_sample:=RPM1 map:=$(ros2 pkg prefix lu_rough_localization)/share/lu_rough_localization/maps/rosbag_le131_AUTOMATED_GEN" Enter
tmux send-keys -t ${WINDOW_RPM}.2 C-z "source ${ROS_PATH} && source ${WS} && ros2 run lu_rough_localization filter_temporal_spatial_outliers --ros-args -p tpc_in:=/rpm/sensors/front/lidar3d/points -p max_distance:=5.0" Enter
tmux send-keys -t ${WINDOW_RPM}.3 C-z "source ${ROS_PATH} && source ${WS} && ros2 run lu_rough_localization filter_temporal_spatial_outliers --ros-args -p tpc_in:=/rpm/sensors/rear/lidar3d/points -p max_distance:=5.0" Enter
tmux send-keys -t ${WINDOW_RPM}.4 C-z "source ${ROS_PATH} && source ${WS}" Enter


tmux send-keys -t ${WINDOW_RPM}.6 C-z "source ${ROS_PATH} && source ${WS} && ros2 run p2p_offset_controller controller" Enter


##### Start RPM (part2) #####
tmux select-window -t ${WINDOW_RPM2}
tmux split-window -h
tmux select-pane -t ${WINDOW_RPM2}.0
tmux split-window -v
tmux select-pane -t ${WINDOW_RPM2}.2
tmux split-window -v

# put command to panes
tmux send-keys -t ${WINDOW_RPM2}.0 C-z "source ${ROS_PATH} && source ${WS} && ros2 launch rpm_nav2 navigation_launch.py velocity_command_topic:=/rpm_velocity_controller/cmd_vel_unstamped params_file:=$(ros2 pkg prefix rpm_nav2)/share/rpm_nav2/config/nav2_params_sim.yaml" #Enter
tmux send-keys -t ${WINDOW_RPM2}.2 C-z "source ${ROS_PATH} && source ${WS} && ros2 launch rpm_behavior_tree rpm_tree_bringup.launch.py" Enter
tmux send-keys -t ${WINDOW_RPM2}.1 C-z "source ${ROS_PATH} && source ${WS} && ros2 launch rpm_nav2 map_launch.py" #Enter


#### Start FPM ##### 
tmux select-window -t ${WINDOW_FPM}
tmux split-window -h #0.1
tmux select-pane -t ${WINDOW_FPM}.0
tmux split-window -v #0.2
tmux select-pane -t ${WINDOW_FPM}.1
tmux split-window -v #1.3

tmux send-keys -t ${WINDOW_FPM}.0 C-z "source ${WS} && ros2 launch fpm_moveit ur_moveit.launch.py launch_rviz:=false" #Enter
tmux send-keys -t ${WINDOW_FPM}.1 C-z "source ${WS} && ros2 launch handling_unit_motion_manager main.launch.py" #Enter
tmux send-keys -t ${WINDOW_FPM}.2 C-z "source ${WS} && ros2 launch hu_behavior_tree hu_tree_bringup.launch.py" #Enter


### Start some other functions ####
tmux select-window -t ${WINDOW_MISC}
tmux select-pane -t ${WINDOW_MISC}.0
tmux split-window -v #0.1
tmux split-window -v #1.2
tmux select-pane -t ${WINDOW_MISC}.0
tmux split-window -v #0.3
tmux select-pane -t ${WINDOW_MISC}.1
tmux split-window -v #1.4
tmux select-pane -t ${WINDOW_MISC}.2
tmux split-window -v #2.5

tmux send-keys -t ${WINDOW_MISC}.0 C-z "source ${WS} && ros2 run tf2_ros static_transform_publisher -4.742 3.396 0.0 0.0 0.0 0.0 map cluster1" Enter
tmux send-keys -t ${WINDOW_MISC}.1 C-z "source ${WS} && ros2 run tf2_ros static_transform_publisher -0.742 3.396 0.0 0.0 0.0 0.0 map cluster2" Enter


########## Attach to the session
tmux attach-session -t "${SESSION}"