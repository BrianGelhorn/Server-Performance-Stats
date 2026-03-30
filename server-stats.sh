#!/bin/bash

CPU=false
MEMORY=false
DISK=false
CPUTOP=false
MEMORYTOP=false
PROC=""


while [[ "$#" -gt 0 ]]; do
	case "$1" in
	--help|-h)
		#TODO add help
		exit 0
		;;
	--cpu|-c)
		CPU=true
		shift
		;;
	--memory|-m)
		MEMORY=true
		shift
		;;
	--disk|-d)
		DISK=true
		shift
		;;
	--cpu-top|-C)
		CPUTOP=true
		shift
		;;
	--memory-top|-M)
		
		shift
		;;
	-*)
		echo "Uknown Option: $1" >&2
		exit 1
		;;
	*)
		PROC="$1"
		shift
		;;
	esac
done

if [[ "$CPU" == true  ]]; then
	FirstTotal=$(head -n 1 /proc/stat | awk '{ for (i=2;i<=11;i++) total+=$i } END { print total}')
	FirstIdle=$(head -n 1 /proc/stat | awk '{ print $5 }')
	sleep 0.5
	SecondTotal=$(head -n 1 /proc/stat | awk '{ for (i=2;i<=11;i++) total+=$i } END { print total}')
	SecondIdle=$(head -n 1 /proc/stat | awk '{ print $5 }')
	DeltaTotal="$((SecondTotal-FirstTotal))"
	DeltaIdle="$((SecondIdle-FirstIdle))"
	CpuUsage="$((100*($DeltaTotal - $DeltaIdle)/$DeltaTotal))"
	echo $CpuUsage
	exit 0
fi

if [[ "$MEMORY" == true ]]; then
	#Get memory totals and filter them
	totals=$(free | awk '{ print $2 }')
	mem_total=$(echo "$totals" | tail -n 2 | head -n 1)
	swap_total=$(echo "$totals" | tail -n 1)
	#Get memory usages and filter them
	totals_used=$(free | awk '{ print $3 }')
	mem_used=$(echo "$totals_used" | tail -n 2 | head -n 1)
	swap_used=$(echo "$totals_used" | tail -n 1)
	#Get the percents of each type of memory used
	mem_used_percent="$((100*mem_used/mem_total))"
	swap_used_percent="$((100*swap_used/swap_total))"
	#Get the free memories doing the difference between the total memories and the memories used amount
	mem_free="$((mem_total-mem_used))"
	swap_free="$((swap_total-swap_used))"
	mem_free_percent="$((100-mem_used_percent))"
	swap_free_percent="$((100-swap_used_percent))"
	printf "%-15s %-10s %-16s %-16s\n" "TYPE" "TOTAL" "USED" "FREE"
	printf "%-15s %-10d %-16s %-16s\n" "Memory" "$mem_total" "$mem_used ($mem_used_percent%)" "$mem_free ($mem_free_percent%)" 
	printf "%-15s %-10d %-16s %-16s\n" "Swap" "$swap_total" "$swap_used ($swap_used_percent%)" "$swap_free ($swap_free_percent%)"
	exit 0
fi
exit 0
