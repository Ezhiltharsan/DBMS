


SQL> rem:ALTER
SQL> SQL>===========================================================
SQL> 
SQL> rem:adding gender column to artist table
SQL> 
SQL> alter table artist add(gender char(6));

Table altered.

SQL> desc artist
 Name     Null?    Type
 ----  --------   ------
 ID     NOT NULL VARCHAR2(5)
 NAME             CHAR(20)
 GENDER           CHAR(6)

SQL> 
SQL>rem:======================================================== 
SQL> 
SQL> rem:first few words of lyrics to be song name
SQL> 
SQL> alter table song modify name char(30);

Table altered.

SQL> desc song
 Name    Null?    Type
 ------ --------  ------------
 AL_ID   NOT NULL VARCHAR2(5)
 NAME             CHAR(30)
 TRACK_NO NOT NULL NUMBER(1)
 LENGTH            NUMBER(1)
 GENRE             CHAR(20)

SQL> 
SQL> rem:=======================================================
SQL> 
SQL> rem:make phone number as unique in studio
SQL> 
SQL> alter table studio add constraint s_un1 unique(ph);

Table altered.

SQL> insert into studio values('mmn','4a',325436);
insert into studio values('mmn','4a',325436)
*
ERROR at line 1:
ORA-00001: unique constraint (SYSTEM.S_UN1) violated 


SQL> 
SQL> rem:======================================================
SQL> 
SQL> rem:make rec as not null in sung_by
SQL> 
SQL> alter table sung_by modify rec Date constraint su_nn1 not null;

Table altered.

SQL> desc sung_by
 Name    Null?    Type
 ----- --------- ----------
 AL_ID  NOT NULL VARCHAR2(5)
 AR_ID  NOT NULL VARCHAR2(5)
 TRACK_NO NOT NULL NUMBER(1)
 REC     NOT NULL DATE

SQL> 
SQL> rem:======================================================
SQL> 
SQL> rem:modify genre constraint to include NAT
SQL> 
SQL> alter table song drop constraint so_chk1;

Table altered.

SQL> alter table song add constraint so_chk1 check(genre in('PHI','REL','LOV','DEV','PAT','NAT'));

Table altered.

SQL> insert into song values('a001','aaa',3,4,'NAT');

1 row created.

SQL> select * from song;

AL_ID NAME                             TRACK_NO     LENGTH GENRE                                              
----- ------------------------------ ---------- ---------- ------                               
a001  aaa                                     1          4 LOV                                                
aba   aaa                                     2          4 LOV                                                
aba   aaa                                     1          4 LOV                                                
a001  aaa                                     2          4 LOV                                                
a001  aaa                                     3          4 NAT                                                

SQL> 
SQL> rem:========================================================
SQL> 
SQL> rem:to delete false information in song
SQL> 
SQL> alter table sung_by drop constraint su_fk;

Table altered.

SQL> 
SQL> alter table sung_by add constraint su_fk foreign key(al_id,track_no) references song(al_id,track_no)
  2  on delete cascade;

Table altered.

SQL> 
SQL> select * from song;

AL_ID NAME                             TRACK_NO     LENGTH GENRE                                              
----- ------------------------------ ---------- ---------- ------                              
a001  aaa                                     1          4 LOV                                                
aba   aaa                                     2          4 LOV                                                
aba   aaa                                     1          4 LOV                                                
a001  aaa                                     2          4 LOV                                                
a001  aaa                                     3          4 NAT                                                

SQL> 
SQL> select * from sung_by;

AL_ID AR_ID   TRACK_NO REC                                                                                    
----- ----- ---------- ---------                                                                              
a001  ar001          1 05-JAN-19                                                                              
aba   ar001          1 05-JAN-19                                                                              
a001  ar001          2 05-JAN-19                                                                              
a001  ar002          1 05-JAN-19                                                                              
a001  ar002          2 05-JAN-19                                                                              

SQL> 
SQL> delete from song;

5 rows deleted.

SQL> 
SQL> select * from song;

no rows selected

SQL> 
SQL> select * from sung_by;

no rows selected

SQL> rem:========================================================
