#!/bin/bash
# Script usage
# ./host_info.sh localhost 5432 host_agent postgres password
db_host=$1
port=$2
db=$3
db_user=$4
password=$5
db_table='host_info'

# Get specs
hostname=`hostname -f`
cpu_number=`lscpu | egrep "^CPU\S" | awk '{print $2}'`
cpu_architecture=`lscpu | grep "Arch" | awk '{print $2}'`
cpu_model=`lscpu | grep -Po "Model name:\s+\K.+"`
cpu_mhz=`lscpu | egrep -i "cpu mhz" | egrep -o "[0-9]+\.[0-9]+"`
l2_cache=`lscpu | egrep -i "l2" | awk '{print $3}' | egrep -o '[0-9]+'`
timestamp=`date +"%x %X"`
total_mem=`cat /proc/meminfo | grep -i memtotal | awk '{print $2}'`

# connect to db
export PGPASSWORD=$password
db_insert="""insert into $db_table (hostname, cpu_number, cpu_architecture,
	cpu_model, cpu_mhz, l2_cache, "timestamp", total_mem) 
	VALUES('$hostname', $cpu_number, '$cpu_architecture',
	'$cpu_model', $cpu_mhz, $l2_cache, '$timestamp', $total_mem)"""

psql -h "$db_host" -p "$port" -U "$db_user" -d "$db" -c "$db_insert"
sleep 1


