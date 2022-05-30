FILE=$1
TIME=$2
MAXUEINDEX=$3
APPSPERUE=$4
NUMOFBEARERS=$(($MAXUEINDEX*$APPSPERUE))
rm -f tmp_2
for bearer in $(seq 0 $APPSPERUE ${NUMOFBEARERS})
do 
	grep "RX INF_BUF" $FILE | grep "B ${bearer} " |  awk '{print $8}'  > tmp
	/mnt/c/LTE-Sim/lte-sim-dev/TOOLS/./make_goodput tmp $TIME >> tmp_2
	rm tmp
done
	/mnt/c/LTE-Sim/lte-sim-dev/TOOLS/./make_fairness_index  tmp_2
