set -x
set -e

RANDOM_SEED=1
REPEAT=5
SIMULATION_TIME=10
mkdir -p /mnt/d/TRACE
until [ $RANDOM_SEED -gt $REPEAT ]; do
for scenario in AllTraffic RtTraffic
do
  mkdir -p /mnt/d/TRACE/$scenario
for sched in  1 2 3 		#scheduling algorithm
do
for ue in 10 30 50		#number of UEs
do
for del in 0.02 0.05 0.1 	#target delay
do	
for v in 0 3 120			#users speed
do
	../../LTE-Sim $scenario $sched $ue $v $del $SIMULATION_TIME $RANDOM_SEED 2 > /mnt/d/TRACE/$scenario/SCHED_${sched}_UE_${ue}_V_${v}_D_${del}_$RANDOM_SEED
	cd /mnt/d/TRACE/$scenario
	gzip SCHED_${sched}_UE_${ue}_V_${v}_D_${del}_$RANDOM_SEED
	cd /mnt/c/LTE-SIM/lte-sim-dev/RUN/scheduling-benchmark
done
done
done
done
done

for scenario in NonRtTraffic
do
  mkdir -p /mnt/d/TRACE/$scenario
for sched in  1 2 3 		#scheduling algorithm
do
for ue in 10 30 50		#number of UEs
do
for v in 0 3 120			#users speed
do
	../../LTE-Sim $scenario $sched $ue $v $SIMULATION_TIME $RANDOM_SEED 2 > /mnt/d/TRACE/$scenario/SCHED_${sched}_UE_${ue}_V_${v}_D_${del}_$RANDOM_SEED
	cd /mnt/d/TRACE/$scenario
  gzip SCHED_${sched}_UE_${ue}_V_${v}_D_${del}_$RANDOM_SEED
  cd /mnt/c/LTE-SIM/lte-sim-dev/RUN/scheduling-benchmark
done
done
done
done
RANDOM_SEED=$((RANDOM_SEED + 1))
done
