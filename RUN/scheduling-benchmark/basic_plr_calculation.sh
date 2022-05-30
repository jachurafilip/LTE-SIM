FILE=$1
FLOW=$2

grep "RX "$FLOW   $FILE  | awk '{print $1}'  > tmp
grep "TX "$FLOW   $FILE  | awk '{print $1}'  >> tmp
/mnt/c/LTE-SIM/lte-sim-dev/RUN/do_simulations/compute_plr.sh tmp > plt_ratio.txt
cat plt_ratio.txt
