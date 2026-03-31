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
		MEMTOP=true	
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
	#Get memory totals and filter to divide memory and swap amounts
	totals=$(free | awk '{ print $2 }')
	mem_total=$(echo "$totals" | tail -n 2 | head -n 1)
	swap_total=$(echo "$totals" | tail -n 1)
	#Get memory usages and filter them to get memory and swap used
	totals_used=$(free | awk '{ print $3 }')
	mem_used=$(echo "$totals_used" | tail -n 2 | head -n 1)
	swap_used=$(echo "$totals_used" | tail -n 1)
	#Get the percents of each type of memory used
	mem_used_percent="$((100*mem_used/mem_total))"
	swap_used_percent="$((100*swap_used/swap_total))"
	#Get the free memories amounts and percents
	mem_free="$((mem_total-mem_used))"
	swap_free="$((swap_total-swap_used))"
	mem_free_percent="$((100-mem_used_percent))"
	swap_free_percent="$((100-swap_used_percent))"
	printf "%-15s %-10s %-16s %-16s\n" "TYPE" "TOTAL" "USED" "FREE"
	printf "%-15s %-10d %-16s %-16s\n" "Memory" "$mem_total" "$mem_used ($mem_used_percent%)" "$mem_free ($mem_free_percent%)" 
	printf "%-15s %-10d %-16s %-16s\n" "Swap" "$swap_total" "$swap_used ($swap_used_percent%)" "$swap_free ($swap_free_percent%)"
	exit 0
fi

if [[ "$DISK" == true ]]; then
	#Get the information of usage of the main disk. Particulary of the root partition"
	disk_info=$(df -h / | tail -n 1)
	#Filter the information to get the total, used and free space amounts and percents
	disk_total=$(echo $disk_info | awk '{ print $2 }')
	disk_used=$(echo $disk_info | awk '{ print $3 }')
	disk_free=$(echo $disk_info | awk '{ print $4 }')
	disk_used_percent=$(echo $disk_info | awk '{ print $5 }' | tr -d '%')
	disk_free_percent="$((100-disk_used_percent))"
	#Show them on the console and exit
	printf "%-8s %-12s %-12s\n" "TOTAL" "USED" "AVAILABLE"
	printf "%-8s %-12s %-12s\n" "$disk_total" "$disk_used ($disk_used_percent%)" "$disk_free ($disk_free_percent%)"
	exit 0
fi
if [[ "$CPUTOP" == true ]]; then
	#Get all processes using CPU, Sort them by CPU usage and delete the script usage and the ps usage to prevent false readings. Then take the first 5 elements
	top_processes=$(ps -eo comm,%cpu --sort=-%cpu | grep -vw -e "ps" -e "$(basename $0)" | tail -n +2 | head -n 5)
	#Separate name and usage
	top_processes_name=$(echo "$top_processes" | awk '{ print $1 }')
	top_processes_usage=$(echo "$top_processes" | awk '{ print $2 }')
	printf "%-15s %5s\n" "PROCESS" "USAGE"
	for ((i=1; i<6; i++)); do
		process_name=$(echo "$top_processes_name" | awk -v i="$i" 'NR==i')
		process_usage=$(echo "$top_processes_usage" | awk -v i="$i" 'NR==i')
		printf "%-15s %5s\n" "$process_name" "$process_usage%"
	done
	exit 0
fi

if [[ "$MEMTOP" == true ]]; then
	top_processes=$(ps -eo comm,%mem --sort=-%mem | grep -vw -e "ps" -e "$(basename $0)" | tail -n +2 | head -n 5)
	#Separate name and usage
	top_processes_name=$(echo "$top_processes" | awk '{ print $1 }')
	top_processes_usage=$(echo "$top_processes" | awk '{ print $2 }')
	printf "%-15s %5s\n" "PROCESS" "USAGE"
	for ((i=1; i<6; i++)); do
		process_name=$(echo "$top_processes_name" | awk -v i="$i" 'NR==i')
		process_usage=$(echo "$top_processes_usage" | awk -v i="$i" 'NR==i')
		printf "%-15s %5s\n" "$process_name" "$process_usage%"
	done
	exit 0

fi
exit 0
