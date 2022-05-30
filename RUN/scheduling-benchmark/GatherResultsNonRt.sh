set -x
set -e

TOOLS="../../TOOLS"
RUN="../../RUN"
SIMULATION_TIME=10
mkdir -p OUT/NonRtTraffic
rm -rf OUT/NonRtTraffic/*
REPEAT=5
_COUNT=1
until [ $_COUNT -gt $REPEAT ]; do
for sched in  1 2 3           #scheduling algorithm
do
for ue in 10 30 50           #number of users
do
for v in 0 3 120                  #users speed
do

	FILEIN="SCHED_${sched}_UE_${ue}_V_${v}_D_0.1_$_COUNT"
	TPUTTOTAL="OUT/NonRtTraffic/TPUTTOTAL_SCHED_${sched}_UE_${ue}_V_${v}"
	FAIRNESSTOTAL="OUT/NonRtTraffic/FAIRNESSTOTAL_SCHED_${sched}_UE_${ue}_V_${v}"
	CQI="OUT/NonRtTraffic/CQITOTAL_SCHED_${sched}_UE_${ue}_V${v}"
	BLER="OUT/NonRtTraffic/BLERTOTAL_SCHED_${sched}_UE_${ue}_V${v}"
	cd  /mnt/d/TRACE/NonRtTraffic
	unp ${FILEIN}.gz;
	cd /mnt/c/LTE-SIM/lte-sim-dev/RUN/scheduling-benchmark

    grep "CQI" /mnt/d/TRACE/NonRtTraffic/${FILEIN} > tmp_CQI
    awk '{s+=$1}END{print "",s/NR}' RS=" " tmp_CQI >> ${CQI}

    grep "BLER:" /mnt/d/TRACE/NonRtTraffic/${FILEIN} | awk {'print $11'} > tmp_BLER
    /mnt/c/LTE-Sim/lte-sim-dev/TOOLS/make_avg tmp_BLER >> ${BLER}


		grep "RX INF_BUF" /mnt/d/TRACE/NonRtTraffic/${FILEIN} | awk '{print $8}' > tmp_tput
		${TOOLS}/make_goodput tmp_tput $SIMULATION_TIME >> ${TPUTTOTAL}

		for bearer in $(seq 0 1 $((${ue}-1)))
    do
    	grep "RX INF_BUF" /mnt/d/TRACE/NonRtTraffic/${FILEIN} | grep "B ${bearer} " |  awk '{print $8}'  > tmp
    	/mnt/c/LTE-Sim/lte-sim-dev/TOOLS/./make_goodput tmp $SIMULATION_TIME >> tmp_2
    	rm tmp
    done
    	/mnt/c/LTE-Sim/lte-sim-dev/TOOLS/./make_fairness_index tmp_2 >> ${FAIRNESSTOTAL}

    rm /mnt/d/TRACE/NonRtTraffic/${FILEIN}
  	rm tmp*
done
done
done
_COUNT=$(($_COUNT + 1))

done
