#!/bin/bash

########################################################################
# Copyright (c) 2020 Robert Bosch GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
########################################################################

#
# Set up virtual can device "elmcan" as sink
# for the elm2canbridge
#
echo "createvcan: Preparing to bring up vcan interface vcan0"

virtualCanConfigure() {
	echo "createvcan: Setting up VIRTUAL CAN"


	ifconfig vcan0 &> /dev/null
	
	echo "createvcan: Virtual CAN interface not yet existing. Creating..."
	sudo ip link add dev vcan0 type vcan
	sudo ip link set vcan0 up
}



#If up?
up=$(ifconfig cvcan0 2> /dev/null | grep NOARP | grep -c RUNNING)

if [ $up -eq 1 ]
then
   echo "createvcan: Interface already up. Exiting"
   exit
fi

virtualCanConfigure

echo "#######################################################"
echo "### Install python requirements                     ###"
echo "#######################################################"
# Update pip before installing requirements
pip3 install --upgrade pip

# Dependencies for the app
REQUIREMENTS="app/dbc2val/requirements.txt"
if [ -f $REQUIREMENTS ]; then
    pip3 install -r $REQUIREMENTS
fi


echo "createvcan: Done."
