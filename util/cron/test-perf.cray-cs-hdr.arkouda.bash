#!/usr/bin/env bash
#
# Run arkouda testing on a cray-cs with HDR IB

UTIL_CRON_DIR=$(cd $(dirname ${BASH_SOURCE[0]}) ; pwd)

export CHPL_TEST_PERF_CONFIG_NAME='16-node-cs-hdr'
export CHPL_NIGHTLY_TEST_CONFIG_NAME="perf.cray-cs-hdr.arkouda"

# setup arkouda
source $UTIL_CRON_DIR/common-arkouda.bash
export ARKOUDA_NUMLOCALES=16

module list

# setup for CS perf (gasnet-large, gnu, 128-core Rome)
source $UTIL_CRON_DIR/common-cray-cs.bash
export CHPL_LAUNCHER_PARTITION=rome64Share
export CHPL_TARGET_CPU=none

module list

export GASNET_PHYSMEM_MAX="9/10"
nightly_args="${nightly_args} -no-buildcheck"

test_nightly_performance
sync_graphs
