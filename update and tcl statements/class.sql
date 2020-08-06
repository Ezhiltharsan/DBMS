SQL> rem:CLASS
SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:dropping the table,if it exists
SQL> 
SQL> 
SQL> drop table classes;

Table dropped.

SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:creation of table
SQL> 
SQL> 
SQL> create table classes(class char(30) constraint c_pk primary key,
  2  			  type char(2) constraint s_chk check (type in('bb','bc')),
  3  			  country char(20) constraint c_nn not null,
  4  			  numGuns number(2),
  5  			  bore number(2),
  6  			  displacement number(5));

Table created.

SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:random insertion of values
SQL> 
SQL> 
SQL> insert into classes (class,country,numGuns,type,bore,displacement)
  2  values('Bismark','Germany',8,'bb',14,32000);

1 row created.

SQL> 
SQL> insert into classes (class,country,numGuns,type,bore,displacement)
  2  values('lowa','USA',9,'bb',16,46000);

1 row created.

SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:ordered insertion of values
SQL> 
SQL> 
SQL> insert into classes values('Kongo','bc','Japan',8,15,42000);

1 row created.

SQL> 
SQL> insert into classes values('North Carolina','bb','USA',9,16,37000);

1 row created.

SQL> 
SQL> insert into classes values('Revenge','bb','Gt.Britian',8,15,29000);

1 row created.

SQL> 
SQL> insert into classes values('Renown','bc','Gt.Britian',6,15,32000);

1 row created.

SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:displaying the table
SQL> 
SQL> 
SQL> select * from classes;

CLASS                          TY COUNTRY                 NUMGUNS       BORE DISPLACEMENT                     
------------------------------ -- -------------------- ---------- ---------- ------------                     
Bismark                        bb Germany                       8         14        32000                     
lowa                           bb USA                           9         16        46000                     
Kongo                          bc Japan                         8         15        42000                     
North Carolina                 bb USA                           9         16        37000                     
Revenge                        bb Gt.Britian                    8         15        29000                     
Renown                         bc Gt.Britian                    6         15        32000                     

6 rows selected.

SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:creating intermediate point
SQL> 
SQL> 
SQL> savepoint A;

Savepoint created.

SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:changing displacement of bismark from 32000 to 34000
SQL> 
SQL> 
SQL> update classes set displacement=34000 where class='Bismark';

1 row updated.

SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:changing the displacement values
SQL> 
SQL> 
SQL> update classes set displacement=displacement+(0.1*displacement) where numGuns>=9 or bore>=15;

5 rows updated.

SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:delete Kongo class from the table
SQL> 
SQL> 
SQL> delete from classes where class='Kongo';

1 row deleted.

SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:displaying the table;
SQL> 
SQL> 
SQL> select * from classes;

CLASS                          TY COUNTRY                 NUMGUNS       BORE DISPLACEMENT                     
------------------------------ -- -------------------- ---------- ---------- ------------                     
Bismark                        bb Germany                       8         14        34000                     
lowa                           bb USA                           9         16        50600                     
North Carolina                 bb USA                           9         16        40700                     
Revenge                        bb Gt.Britian                    8         15        31900                     
Renown                         bc Gt.Britian                    6         15        35200                     

SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:rollback to the savepoint
SQL> 
SQL> 
SQL> rollback to savepoint A;

Rollback complete.

SQL> 
SQL> rem:====================================================================================================
SQL> 
SQL> rem:commit the changes
SQL> 
SQL> 
SQL> commit;

Commit complete.

SQL> rem:====================================================================================================
