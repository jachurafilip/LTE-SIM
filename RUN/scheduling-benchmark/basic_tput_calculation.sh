FILE=$1
TIME=$2
rm -f tmp
grep "RX " $FILE | awk '{print $8}'  > tmp
/mnt/c/LTE-Sim/lte-sim-dev/TOOLS/./make_goodput tmp $TIME > tput_result.txt
cat tput_result.txt
