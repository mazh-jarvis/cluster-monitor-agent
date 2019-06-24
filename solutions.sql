-- Group hosts by CPU number and sort by their memory size in descending order:
select 
	cpu_number,
	host_id ,
	total_mem
from host_info
order by 
	cpu_number asc,
	total_mem desc;


-- Average used memory in percentage over 5 minute interval for each host
select
	host_id,
	host_name,
	total_mem,
	total_mem - free_memory as used_memory
		over( partition by M.minute ),
	avg(used_memory) as used_memory_percentage
from (
	select *, row_number() over(order by host_id) as row
	from ( 
		select date_trunc('minute', "timestamp") as minute from host_info 
	) M
) I
where I.row % 5 = 0

