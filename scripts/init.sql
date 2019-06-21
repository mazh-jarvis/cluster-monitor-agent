drop table public.host_info
create table public.host_info
(
	id					serial not null,
	hostname			varchar not null,
	cpu_number			int2 not null,
	cpu_architecture	varchar not null,
	cpu_model			varchar not null,
	cpu_mhz				float8 not null,
	"timestamp"			timestamp null,
	total_mem			int4 null,
	CONSTRAINT host_info_pk	primary key (id),
	CONSTRAINT host_info_un unique (hostname)
);

-- WAR: copied from above
drop table public.host_usage
create table public.host_usage
(
	"timestamp"			timestamp null,
	host_id				serial not null,
	memory_free			int4 not null,
	cpu_idle			int2 not null,
	cpu_kernel			int2 not null,
	disk_io				int4 not null,
	disk_available		int4 not null,
	CONSTRAINT host_usage_host_info_fk	foreign key (host_id) references
		host_info(id)
);

