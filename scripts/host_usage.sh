#!/bin/bash
# Script usage
# ./host_usage.sh localhost 5432 host_agent postgres password
db_host=$1
port=$2
db=$3
db_user=$4
password=$5
db_table='host_usage'
#[ ! -f "host_id" ] && echo "ERROR: File host_id not found!" && exit 1;
host_id=`cat ~/dev/jrvs/bootcamp/host_agent/scripts/host_id`

# Get status
timestamp=`date +"%x %X"`
#host_id=
memory_free=` free -m | grep "^Mem" | awk '{print $2}' `
cpu_idle=` vmstat | awk 'NR == 3' | awk '{print $15}' `
cpu_k=` vmstat | awk 'NR == 3' | awk '{print $14}' `
disk_io=` vmstat | awk 'NR == 3' | awk '{print $10}' `
disk_av=` df -lm | head -n5 | grep "/$" | awk '{print $4}' `

# connect to db
export PGPASSWORD=$password
db_insert="""insert into host_usage (host_id, timestamp, memory_free, cpu_idle,
	cpu_kernel, disk_io, disk_available) 
	VALUES($host_id, '$timestamp', $memory_free, $cpu_idle, $cpu_k, $disk_io, $disk_av)"""

psql -h "$db_host" -p "$port" -U "$db_user" -d "$db" -c "$db_insert"
