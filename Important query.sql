--  //it's for  query analysis it returnes query execution time
 explain analyze select id from employees where id =1000;
--  // it's for  query analysis it returnes query execution time and it's slow because it's doesn't have any index
 explain analyze select name from employees where name = 'Zs';

 //
 explain analyze select id,name from employees where name like '%Zs%';
--  //create index on name column
 create index employees_name on employees(name);
 
 explain analyze select id, g from students where g > 80 and g < 95 order by g desc;
 // create index on g column
 create index g_idx on students(g);
// drop index g_idx;
drop index g_idx
//
create index g_idx on students(g) include (id);