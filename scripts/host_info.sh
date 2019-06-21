#!/bin/bash
# Script usage
# ./host_info.sh localhost 5432 host_agent postgres password
db=$3
db_user=$4
password=$5

# Get specs
hostname=`hostname -f`
cpu_number=`lscpu | egrep "^CPU\S"`
cpu_architecture=`lscpu | grep "Arch" | awk '{print $3}'`
cpu_model=`lscpu | grep -i "model name" | awk '{print $3}'`
cpu_mhz=`lscpu | egrep -i "cpu mhz" | egrep -o "[0-9]+\.[0-9]+"`
l2_cache=`lscpu | egrep -i "l2" | awk '{print $3}'`
timestamp=`date +"+x +X"`
total_mem=`cat /proc/meminfo | grep -i memtotal`


# connect to db
db_command="""insert into host_info (hostname, cpu_number, cpu_architecture,
	cpu_model, cpu_mhz, l2_cache, "timestamp", total_mem) 
	VALUES($hostname, $cpu_number, $cpu_architecture,
	$cpu_model, $cpu_mhz, $l2_cache, $timestamp, $total_mem)"""

psql -h "$hostname" -p "$password" -U "$db_user" -d "$db" -c "$db_command"
#sleep 1


