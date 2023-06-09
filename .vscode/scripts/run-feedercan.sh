#!/bin/bash
# Copyright (c) 2022-2023 Robert Bosch GmbH and Microsoft Corporation
#
# This program and the accompanying materials are made available under the
# terms of the Apache License, Version 2.0 which is available at
# https://www.apache.org/licenses/LICENSE-2.0.
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# SPDX-License-Identifier: Apache-2.0

echo "#######################################################"
echo "### Running FeederCan                               ###"
echo "#######################################################"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

### Override default files for feedercan
CONFIG_DIR="$SCRIPT_DIR/data"

export VEHICLEDATABROKER_DAPR_APP_ID=vehicledatabroker
export LOG_LEVEL=info,databroker=info,dbcfeeder.broker_client=info,dbcfeeder=info
export USECASE=databroker

export CANDUMP_FILE="/data/candumpDefault.log"
export DBC_FILE="/data/dbcfileDefault.dbc"
export MAPPING_FILE="/data/mappingDefault.json"

RUNNING_CONTAINER=$(docker ps | grep "$FEEDERCAN_IMAGE" | awk '{ print $1 }')

if [ -n "$RUNNING_CONTAINER" ];
then
    docker container stop $RUNNING_CONTAINER
fi

dapr run \
    --app-id feedercan \
    --app-protocol grpc \
    --components-path $VELOCITAS_WORKSPACE_DIR/.dapr/components \
    --config $VELOCITAS_WORKSPACE_DIR/.dapr/config.yaml \
-- docker run \
    -v ${CONFIG_DIR}:/data \
    -e VEHICLEDATABROKER_DAPR_APP_ID \
    -e DAPR_GRPC_PORT \
    -e DAPR_HTTP_PORT \
    -e LOG_LEVEL \
    -e USECASE \
    -e CANDUMP_FILE \
    -e DBC_FILE \
    -e MAPPING_FILE \
    --network host \
    $FEEDERCAN_IMAGE:$FEEDERCAN_TAG --use-socketcan --canport vcan0

