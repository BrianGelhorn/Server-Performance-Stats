#!/bin/bash

while [[ "$#" -gt 0 ]]; do
	case "$1" in
	--help|-h)
		#TODO add help
		exit 0
		;;
	--cpu|-c)
		#TODO add total CPU usage
		shift
		;;
	--memory|-m)
		#TODO add total Memory usage
		shift
		;;
	--disk|-d)
		#TODO add total Disk usage
		shift
		;;
	--cpu-top|-C)
		#TODO add top 5 processes by CPU usage
		shift
		;;
	--memory-top|-M)
		#TODO add top 5 processes by memory usage
		shift
		;;
	-*)
		echo "Uknown Option: $1" >&2
		exit 1
		;;
	*)
		#TODO Implement operand
		shift
		;;
	esac
done
