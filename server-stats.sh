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
	DeltaTotal="$((SecondTotal-$FirstTotal))"
	DeltaIdle="$((SecondIdle-$FirstIdle))"
	CpuUsage="$((100*($DeltaTotal - $DeltaIdle)/$DeltaTotal))"
	echo $CpuUsage
	exit 0
fi
exit 0
