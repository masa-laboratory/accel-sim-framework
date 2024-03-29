#!/bin/bash

# vectorSparse
# cxx: 7.5.0
# apps: util/job_launching/apps/define-all-apps.yml
# traces: hw_run/traces/device-0/11.0/spmm_benchmark/
# cfg: gpu-simulator/gpgpu-sim/configs/tested-cfgs/SM75_RTX2080_Ti/gpgpusim.config
make vectorSparse -C ./gpu-app-collection/src
# every time execute run_hw_trace, you must bash && conda activate accel-sim && source ./gpu-app-collection/src/setup_environment
export LD_LIBRARY_PATH=/home/yangjianchao/Github/sputnik/build/sputnik/:$LD_LIBRARY_PATH
./util/tracer_nvbit/run_hw_trace.py -B vectorSparse -D 0
# every time execute run_simulations, you must source ./gpu-simulator/setup_environment.sh
./util/job_launching/run_simulations.py -B vectorSparse -C RTX2080Ti-SASS -T ./hw_run/traces/device-0/11.0/ -N myTest-202307102012
./util/job_launching/monitor_func_test.py -v -N myTest-202307102012
./util/job_launching/run_simulations.py -B vectorSparse -C RTX2080Ti-PTX -T ./hw_run/traces/device-0/11.0/ -N myTest-202307102018
./util/job_launching/monitor_func_test.py -v -N myTest-202307102018

# cutlass-bench
# cxx: 7.5.0
# apps: util/job_launching/apps/define-all-apps.yml
# traces: hw_run/traces/device-0/11.0/spmm_benchmark/
# cfg: gpu-simulator/gpgpu-sim/configs/tested-cfgs/SM75_RTX2080_Ti/gpgpusim.config
make cutlass -C ./gpu-app-collection/src
# every time execute run_hw_trace, you must bash && conda activate accel-sim && source ./gpu-app-collection/src/setup_environment
./util/tracer_nvbit/run_hw_trace.py -B cutlass_5_trace -D 0
# every time execute run_simulations, you must source ./gpu-simulator/setup_environment.sh
./util/job_launching/run_simulations.py -B cutlass_5_trace -C RTX2080Ti-SASS -T ./hw_run/traces/device-0/11.0/ -N myTest-202307102012
./util/job_launching/monitor_func_test.py -v -N myTest-202307102012
./util/job_launching/run_simulations.py -B cutlass_5_trace -C RTX2080Ti-PTX -T ./hw_run/traces/device-0/11.0/ -N myTest-202307102018
./util/job_launching/monitor_func_test.py -v -N myTest-202307102018

# debug
gdb -args ./gpu-simulator/bin/debug/accel-sim.out -trace ./hw_run/traces/device-0/11.0/cutlass_perf_test_k1/__seed_2020___dist_0____m_256___n_256___k_256___kernels_wmma_gemm_nn____iterations_1___providers_cutlass/traces/kernelslist.g -config ./gpu-simulator/gpgpu-sim/configs/tested-cfgs/SM75_RTX2080_Ti/gpgpusim.config -config ./gpu-simulator/configs/tested-cfgs/SM75_RTX2080_Ti/trace.config

# sass_states && aerialvision
# every time execute run_hw_trace, you must bash && conda activate accel-sim && source ./gpu-app-collection/src/setup_environment
source ./gpu-app-collection/src/setup_environment
export TRACE_LINEINFO=1
conda activate Accel-Sim
./util/tracer_nvbit/run_hw_trace.py -B cutlass_5_trace -D 0
# every time execute run_simulations, you must source ./gpu-simulator/setup_environment.sh
rm -rf ./sim_run_11.0/gpgpu-sim-builds/
source ./gpu-simulator/setup_environment.sh release && make -j -C ./gpu-simulator/
./util/job_launching/run_simulations.py -B cutlass_5_trace -C RTX2080Ti-VISUAL -T ./hw_run/traces/device-0/11.0/ -N myTest-202307102012
./util/job_launching/monitor_func_test.py -v -N myTest-202307102012

