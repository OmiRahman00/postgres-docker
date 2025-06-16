# PostgreSQL Partitioning Example

```sql
-- Create the original table and populate it
create table grades_org (id serial not null, g int not null);
insert into grades_org(g) select floor(random()*100) from generate_series(0, 1000000);
select * from grades_org;

-- Create an index on the g column
create index grades_org_index on grades_org(g);

-- Simple query and explain analyze
select count(*) from grades_org where g = 30;
explain analyze select count(*) from grades_org where g = 30;

-- Create a partitioned table
create table grades_parts (
    id serial not null,
    g int not null
) partition by range (g);

-- Create partitions
create table g0035 (
    like grades_parts including indexes
);
create table g3560 (
    like grades_parts including indexes
);
create table g6080 (
    like grades_parts including indexes
);
create table g80100 (
    like grades_parts including indexes
);

-- Attach partitions to the main table
alter table grades_parts attach partition g0035 for values from (0) to (35);
alter table grades_parts attach partition g3560 for values from (35) to (60);
alter table grades_parts attach partition g6080 for values from (60) to (80);
alter table grades_parts attach partition g80100 for values from (80) to (100);

-- Insert data into the partitioned table
insert into grades_parts select * from grades_org;

-- Count and max queries
select count(*) from grades_parts;
select max(g) from grades_parts;
select max(g) from g0035;
select count (*) from g0035;
select count (*) from g3560;
select count (*) from g6080;
select count (*) from g80100;

-- Create an index on the partitioned table
create index grades_parts_index on grades_parts(g);
```