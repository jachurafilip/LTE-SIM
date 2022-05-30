set -x
set -e

TOOLS="../../TOOLS"
SIMULATION_TIME=10
mkdir -p OUT/AllTraffic
rm -rf OUT/AllTraffic/*
REPEAT=5
_COUNT=1
until [ $_COUNT -gt $REPEAT ]; do
for sched in  1 2 3           #scheduling algorithm
do
for ue in 10 30 50           #number of users
do
for del in 0.02 0.05 0.1   #target delay
do
for v in 0 3 120                  #users speed
do

	FILEIN="SCHED_${sched}_UE_${ue}_V_${v}_D_${del}_$_COUNT"
	PLRVIDEO="OUT/AllTraffic/PLRVIDEO_SCHED_${sched}_UE_${ue}_V_${v}_D_${del}"
	PLRVOIP="OUT/AllTraffic/PLRVOIP_SCHED_${sched}_UE_${ue}_V_${v}_D_${del}"
	DELVIDEO="OUT/AllTraffic/DELVIDEO_SCHED_${sched}_UE_${ue}_V_${v}_D_${del}"
	DELVOIP="OUT/AllTraffic/DELVOIP_SCHED_${sched}_UE_${ue}_V_${v}_D_${del}"
	TPUTVIDEO="OUT/AllTraffic/TPUTVIDEO_SCHED_${sched}_UE_${ue}_V_${v}_D_${del}"
	TPUTVOIP="OUT/AllTraffic/TPUTVOIP_SCHED_${sched}_UE_${ue}_V_${v}_D_${del}"
	TPUTBE="OUT/AllTraffic/TPUTBE_SCHED_${sched}_UE_${ue}_V_${v}_D_${del}"
	TPUTTOTAL="OUT/AllTraffic/TPUTTOTAL_SCHED_${sched}_UE_${ue}_V_${v}_D_${del}"
	CQI="OUT/AllTraffic/CQITOTAL_SCHED_${sched}_UE_${ue}_V_${v}_D_${del}"
  BLER="OUT/AllTraffic/BLERTOTAL_SCHED_${sched}_UE_${ue}_V_${v}_D_${del}"
	
	cd  /mnt/d/TRACE/AllTraffic
	unp ${FILEIN}.gz; 
	cd /mnt/c/LTE-SIM/lte-sim-dev/RUN/scheduling-benchmark

	    grep "CQI" /mnt/d/TRACE/AllTraffic/${FILEIN} > tmp_CQI
      awk '{s+=$1}END{print "",s/NR}' RS=" " tmp_CQI >> ${CQI}

      grep "BLER:" /mnt/d/TRACE/AllTraffic/${FILEIN} | awk {'print $11'} > tmp_BLER
      /mnt/c/LTE-Sim/lte-sim-dev/TOOLS/make_avg tmp_BLER >> ${BLER}

		grep -c "TX VIDEO" /mnt/d/TRACE//AllTraffic/${FILEIN} > tmp_plr_video
		grep -c "RX VIDEO" /mnt/d/TRACE//AllTraffic/${FILEIN} >> tmp_plr_video
		${TOOLS}/make_plr tmp_plr_video | awk '{print $2}' | tail -1 >> ${PLRVIDEO}
                                                        
		grep "RX VIDEO" /mnt/d/TRACE//AllTraffic/${FILEIN} | awk '{print $14}' > tmp_delay_video
		${TOOLS}/make_avg tmp_delay_video >> ${DELVIDEO}

		grep "RX VIDEO" /mnt/d/TRACE//AllTraffic/${FILEIN} |awk '{print $8}' >> tmp_gput_video
		${TOOLS}/make_goodput tmp_gput_video $SIMULATION_TIME >> ${TPUTVIDEO}
                                                       
		grep -c "TX VOIP" /mnt/d/TRACE//AllTraffic/${FILEIN} > tmp_plr_voip
		grep -c "RX VOIP" /mnt/d/TRACE//AllTraffic/${FILEIN} >> tmp_plr_voip
		${TOOLS}/make_plr tmp_plr_voip | awk '{print $2}' | tail -1 >> ${PLRVOIP}

		grep "RX VOIP" /mnt/d/TRACE//AllTraffic/${FILEIN} | awk '{print $14}' > tmp_delay_voip
		${TOOLS}/make_avg tmp_delay_voip >> ${DELVOIP}

		grep "RX VOIP" /mnt/d/TRACE//AllTraffic/${FILEIN} |awk '{print $8}' >> tmp_gput_voip
		${TOOLS}/make_goodput tmp_gput_voip $SIMULATION_TIME >> ${TPUTVOIP}

		grep "RX INF_BUF" /mnt/d/TRACE//AllTraffic/${FILEIN} |awk '{print $8}' >> tmp_gput_be
                ${TOOLS}/make_goodput tmp_gput_be $SIMULATION_TIME >> ${TPUTBE}

    grep "RX" /mnt/d/TRACE//AllTraffic/${FILEIN} |awk '{print $8}' >> tmp_gput_total
                ${TOOLS}/make_goodput tmp_gput_total $SIMULATION_TIME >> ${TPUTTOTAL}

		rm /mnt/d/TRACE/AllTraffic/${FILEIN}
		rm tmp*
done
done
done
done
_COUNT=$(($_COUNT + 1))
done
