create table grades_org (id serial not null, g int not null);
insert into grades_org(g) select floor(random()*100) from generate_series(0, 1000000);
select * from grades_org;

-- creating index on g column
create index grades_org_index on grades_org(g);

-- just a simple query
select count(*) from grades_org where g = 30;
-- explain analyze select count(*) from grades_org where g = 30;
explain analyze select count(*) from grades_org where g = 30;

-- create a partitioned table
create table grades_parts (
    id serial not null,
    g int not null
) partition by range (g);

-- already done ann this is a partitioned table it's for 0 to 35
create table g0035 (
    like grades_parts including indexes
);

-- create a partition for 36 to 60
create table g3560 (
    like grades_parts including indexes
);
-- create a partition for 61 to 80
create table g6080 (
    like grades_parts including indexes
);
-- create a partition for 81 to 100
create table g80100 (
    like grades_parts including indexes
);

-- attach partitions to the main table
alter table grades_parts attach partition g0035 for values from (0) to (35);
alter table grades_parts attach partition g3660 for values from (35) to (60);
alter table grades_parts attach partition g6180 for values from (60) to (80);
alter table grades_parts attach partition g81100 for values from (80) to (100);
-- insert data into main table from the original table
insert into grades_parts select * from grades_org;
-- count the number of main table
select count(*) from grades_parts;
-- max grades of the main table
select max(g) from grades_parts;
-- max grades from first partition
select max(g) from g0035;
-- count the number of first partition
select count (*) from g0035;
-- count the number of second partition
select count (*) from g3560;
-- count the number of third partition
select count (*) from g6080;
-- count the number of fourth partition
select count (*) from g80100;\
-- create an index on the main table
create index grades_parts_index on grades_parts(g);