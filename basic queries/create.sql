SQL> rem:CREATE
SQL> 
SQL> rem:=======================================================
SQL> 
SQL> rem:to drop tables,if they exists
SQL> 
SQL> drop table sung_by;

Table dropped.

SQL> 
SQL> drop table artist;

Table dropped.

SQL> 
SQL> drop table song;

Table dropped.

SQL> 
SQL> drop table album;

Table dropped.

SQL> 
SQL> drop table studio;

Table dropped.

SQL> 
SQL> drop table musician;

Table dropped.

SQL> 
SQL> rem:=======================================================
SQL> 
SQL> rem:creation of musician table
SQL> 
SQL> create table musician(id varchar(5) constraint m_pk primary key,
  2  			    name char(20),
  3  			    bir_pl char(20));

Table created.

SQL> 
SQL> desc musician
 Name     Null?    Type
 ------ --------- -----------
 ID      NOT NULL VARCHAR2(5)
 NAME             CHAR(20)
 BIR_PL           CHAR(20)

SQL> 
SQL> 
SQL> insert into musician values('m001','sss','dsfg');

1 row created.

SQL> 
SQL> select * from musician;

ID    NAME                 BIR_PL                                                                                                                     
----- -------------------- --------------------                                                                                                       
m001  sss                  dsfg                                                                                                                       

SQL> 
SQL> rem:=======================================================
SQL> 
SQL> rem:violation of musician constraints
SQL> 
SQL> 
SQL> rem:violation of musician_id
SQL> 
SQL> insert into musician values(null,'sss','dsfg');
insert into musician values(null,'sss','dsfg')
                            *
ERROR at line 1:
ORA-01400: cannot insert NULL into ("SYSTEM"."MUSICIAN"."ID") 


SQL> 
SQL> rem:=======================================================
SQL> 
SQL> rem:creation of studio table
SQL> 
SQL> create table studio(name char(20) constraint s_pk primary key,
  2 addr varchar(20),
  3 ph number(10));

Table created.

SQL> 
SQL> desc studio
 Name      Null?    Type
 ------ --------- ---------
 NAME    NOT NULL CHAR(20)
 ADDR             VARCHAR2(20)
 PH               NUMBER(10)

SQL> 
SQL> 
SQL> insert into studio values('mmm','4a',325436);

1 row created.

SQL> 
SQL> select * from studio;

NAME                 ADDR                         PH                                                                                                  
-------------------- -------------------- ----------                                                                                                  
mmm                  4a                       325436                                                                                                  

SQL> 
SQL> rem:==================================================
SQL> 
SQL> rem:violation of studio constraints
SQL> 
SQL> 
SQL> rem:violation of name,ph as primary key
SQL> 
SQL> insert into studio values('mmm','4a',325436);
insert into studio values('mmm','4a',325436)
*
ERROR at line 1:
ORA-00001: unique constraint (SYSTEM.S_PK) violated 


SQL> 
SQL> rem:violation of name
SQL> 
SQL> insert into studio values('mmm','4a',325437);
insert into studio values('mmm','4a',325437)
*
ERROR at line 1:
ORA-00001: unique constraint (SYSTEM.S_PK) violated 


SQL> 
SQL> 
SQL> rem:========================================================
SQL> 
SQL> rem:creation of album table
SQL> 
SQL> create table album(id varchar(5) constraint a_pk primary key,
  2  			name char(20),
  3  			year number(4) constraint a_chk check (year>1944),
  4  			no_tracks number(1) constraint a_nn1 not null,
  5  			stu_name char(20) constraint a_fk references studio(name),
  6  			genre char(20) constraint a_chk1 check(genre in ('CAR','DIV','MOV','POP')),
  7  			mu_id varchar(5) constraint a_fk1 references musician(id));

Table created.

SQL> 
SQL> desc album
 Name          Null?    Type
 -----        -------- -----------
 ID          NOT NULL VARCHAR2(5)
 NAME                 CHAR(20)
 YEAR                 NUMBER(4)
 NO_TRACKS   NOT NULL NUMBER(1)
 STU_NAME             CHAR(20)
 GENRE                CHAR(20)
 MU_ID                VARCHAR2(5)

SQL> 
SQL> insert into album values('a001','aaaa',1949,5,'mmm','POP','m001');

1 row created.

SQL> 
SQL> 
SQL> insert into album values('aba','aaaa',1949,5,'mmm','POP','m001');

1 row created.

SQL> 
SQL> insert into album values('a003','aaaa',1949,5,'mmm','POP','m001')
  2  
SQL> select * from album;

ID    NAME  YEAR  NO_TRACKS STU_NAME  GENRE                MU_ID                                                      
----- -------------------- ---------- ---------- ----------------                                                      
a001  aaaa 1949    5         mmm       POP                  m001                                                       
aba   aaaa 1949          5   mmm       POP                  m001                                                       

SQL> 
SQL> 
SQL> rem:=====================================================
SQL> 
SQL> rem:violation of album constraints
SQL> 
SQL> 
SQL> rem:violation of id
SQL> 
SQL> insert into album values('a001','aaaa',1949,5,'mmm','POP','m001');
insert into album values('a001','aaaa',1949,5,'mmm','POP','m001')
*
ERROR at line 1:
ORA-00001: unique constraint (SYSTEM.A_PK) violated 


SQL> 
SQL> rem:violation of year
SQL> 
SQL> insert into album values('a002','aaa',1940,5,'mmm','POP','m001');
insert into album values('a002','aaa',1940,5,'mmm','POP','m001')
*
ERROR at line 1:
ORA-02290: check constraint (SYSTEM.A_CHK) violated 


SQL> 
SQL> rem:violation of no_tracks
SQL> 
SQL> insert into album values('a002','aaa',1940,'','mmm','POP','m001');
insert into album values('a002','aaa',1940,'','mmm','POP','m001')
                                           *
ERROR at line 1:
ORA-01400: cannot insert NULL into ("SYSTEM"."ALBUM"."NO_TRACKS") 


SQL> 
SQL> rem:violation of stu_name
SQL> 
SQL> insert into album values('a002','aaa',1949,5,'nnn','POP','m001');
insert into album values('a002','aaa',1949,5,'nnn','POP','m001')
*
ERROR at line 1:
ORA-02291: integrity constraint (SYSTEM.A_FK) violated - parent key not found 


SQL> 
SQL> rem:violation of genre
SQL> 
SQL> insert into album values('a002','aaa',1949,5,'mmm','DAN','m001');
insert into album values('a002','aaa',1949,5,'mmm','DAN','m001')
*
ERROR at line 1:
ORA-02290: check constraint (SYSTEM.A_CHK1) violated 


SQL> 
SQL> rem:violation of mu_id
SQL> 
SQL> insert into album values('a002','aaa',1949,5,'mmm','POP','m002');
insert into album values('a002','aaa',1949,5,'mmm','POP','m002')
*
ERROR at line 1:
ORA-02291: integrity constraint (SYSTEM.A_FK1) violated - parent key not found 


SQL> 
SQL> 
SQL> rem:========================================================
SQL> 
SQL> rem:creation of song table
SQL> 
SQL> create table song(al_id varchar(5) constraint so_fk references album(id),
  2  			name char(20),
  3  			track_no number(1) constraint so_nn1 not null,
  4  			length number(1),
  5  			genre char(20) constraint so_chk1 check(genre in ('PHI','REL','LOV','DEV','PAT')),
  6  			constraint so_pk primary key(al_id,track_no),
  7  			constraint so_chk check((genre='PAT' and length>7)or(genre!='PAT' and length>=0)));

Table created.

SQL> 
SQL> desc song
 Name      Null?          Type
 ----     --------       -------
 AL_ID     NOT NULL     VARCHAR2(5)
 NAME                   CHAR(20)
 TRACK_NO  NOT NULL     NUMBER(1)
 LENGTH                 NUMBER(1)
 GENRE                  CHAR(20)

SQL> 
SQL> insert into song values('a001','aaa',1,4,'LOV');

1 row created.

SQL> insert into song values('aba','aaa',2,4,'LOV');

1 row created.

SQL> insert into song values('aba','aaa',1,4,'LOV');

1 row created.

SQL> insert into song values('a001','aaa',2,4,'LOV');

1 row created.

SQL> insert into song values('a003','aaa',1,8,'PAT');
insert into song values('a003','aaa',1,8,'PAT')
*
ERROR at line 1:
ORA-02291: integrity constraint (SYSTEM.SO_FK) violated - parent key not found 


SQL> insert into song values('a003','aaa',2,10,'LOV');
insert into song values('a003','aaa',2,10,'LOV')
                                       *
ERROR at line 1:
ORA-01438: value larger than specified precision allowed for this column 


SQL> 
SQL> select * from song;

AL_ID NAME                   TRACK_NO     LENGTH GENRE                                                                                                
----- -------------------- ---------- ---------- ----------                                                                                 
a001  aaa                           1          4 LOV                                                                                                  
aba   aaa                           2          4 LOV                                                                                                  
aba   aaa                           1          4 LOV                                                                                                  
a001  aaa                           2          4 LOV                                                                                                  

SQL> 
SQL> 
SQL> rem:========================================================
SQL> 
SQL> rem:violation of song constraints
SQL> 
SQL> 
SQL> rem:violation of al_id,track_no as primarykey
SQL> 
SQL> insert into song values('a001','aaa',1,4,'LOV');
insert into song values('a001','aaa',1,4,'LOV')
*
ERROR at line 1:
ORA-00001: unique constraint (SYSTEM.SO_PK) violated 


SQL> 
SQL> rem:violation of al_id
SQL> 
SQL> insert into song values('a002','aaa',1,4,'LOV');
insert into song values('a002','aaa',1,4,'LOV')
*
ERROR at line 1:
ORA-02291: integrity constraint (SYSTEM.SO_FK) violated - parent key not found 


SQL> 
SQL> rem:violation of track_no
SQL> 
SQL> insert into song values('a001','aaa','',4,'LOV');
insert into song values('a001','aaa','',4,'LOV')
                                     *
ERROR at line 1:
ORA-01400: cannot insert NULL into ("SYSTEM"."SONG"."TRACK_NO") 


SQL> 
SQL> rem:violation of length
SQL> 
SQL> insert into song values('a001','bbb',2,4,'PAT');
insert into song values('a001','bbb',2,4,'PAT')
*
ERROR at line 1:
ORA-02290: check constraint (SYSTEM.SO_CHK) violated 


SQL> 
SQL> rem:violation of genre
SQL> 
SQL> insert into song values('a001','bbb',2,4,'DAN');
insert into song values('a001','bbb',2,4,'DAN')
*
ERROR at line 1:
ORA-02290: check constraint (SYSTEM.SO_CHK1) violated 


SQL> 
SQL> 
SQL> rem:======================================================
SQL> 
SQL> rem:creation of artist table
SQL> 
SQL> create table artist(id varchar(5) constraint ar_pk primary key,
  2  			 name char(20) constraint ar_un unique);

Table created.

SQL> 
SQL> desc artist
 Name   Null?    Type
 ----- ------- --------
 ID    NOT NULL VARCHAR2(5)
 NAME           CHAR(20)

SQL> 
SQL> insert into artist values('ar001','aab');

1 row created.

SQL> 
SQL> insert into artist values('ar002','aad');

1 row created.

SQL> 
SQL> select * from artist;

ID    NAME                                                                                                                                            
----- -------                                                                                                                            
ar001 aab                                                                                                                                             
ar002 aad                                                                                                                                             

SQL> 
SQL> rem:=====================================================
SQL> 
SQL> rem:violation of artist constraints
SQL> 
SQL> 
SQL> rem:violation of id
SQL> 
SQL> insert into artist values('ar001','aac');
insert into artist values('ar001','aac')
*
ERROR at line 1:
ORA-00001: unique constraint (SYSTEM.AR_PK) violated 


SQL> 
SQL> rem:violation of name
SQL> 
SQL> insert into artist values('ar002','aab');
insert into artist values('ar002','aab')
*
ERROR at line 1:
ORA-00001: unique constraint (SYSTEM.AR_PK) violated 


SQL> 
SQL> 
SQL> rem:================================================
SQL> 
SQL> rem:creation of sung_by table
SQL> 
SQL> create table sung_by(al_id varchar(5),
  2  			  ar_id varchar(5) constraint su_fk1 references artist(id),
  3  			  track_no number(1),
  4  			  rec Date,
  5  			  constraint su_pk primary key(al_id,ar_id,track_no),
  6  			  constraint su_fk foreign key(al_id,track_no) references song(al_id,track_no));

Table created.

SQL> 
SQL> desc sung_by
 Name     Null?     Type
 -----  ----------  ----------
 AL_ID   NOT NULL VARCHAR2(5)
 AR_ID   NOT NULL VARCHAR2(5)
 TRACK_NO NOT NULL NUMBER(1)
 REC               DATE

SQL> 
SQL> insert into sung_by values('a001','ar001',1,'05-JAN-2019');

1 row created.

SQL> 
SQL> insert into sung_by values('aba','ar001',1,'05-JAN-2019');

1 row created.

SQL> 
SQL> insert into sung_by values('a001','ar001',2,'05-JAN-2019');

1 row created.

SQL> 
SQL> insert into sung_by values('a001','ar002',1,'05-JAN-2019');

1 row created.

SQL> 
SQL> select * from sung_by;

AL_ID AR_ID   TRACK_NO REC                                                                                                                            
----- ----- ---------- ---------                                                                                                                      
a001  ar001          1 05-JAN-19                                                                                                                      
aba   ar001          1 05-JAN-19                                                                                                                      
a001  ar001          2 05-JAN-19                                                                                                                      
a001  ar002          1 05-JAN-19                                                                                                                      

SQL> 
SQL> 
SQL> rem:===================================================
SQL> 
SQL> rem:violation of sung_by constraints
SQL> 
SQL> 
SQL> rem:violation of al_id,tack_no as primary key
SQL> 
SQL> insert into sung_by values('a001','ar001',1,'05-JAN-2019');
insert into sung_by values('a001','ar001',1,'05-JAN-2019')
*
ERROR at line 1:
ORA-00001: unique constraint (SYSTEM.SU_PK) violated 


SQL> 
SQL> rem:violation of al_id,tack_no as foreign key
SQL> 
SQL> insert into sung_by values('a002','ar001',2,'05-JAN-2019');
insert into sung_by values('a002','ar001',2,'05-JAN-2019')
*
ERROR at line 1:
ORA-02291: integrity constraint (SYSTEM.SU_FK) violated - parent key not found 


SQL> 
SQL> rem:violation of ar_id
SQL> 
SQL> insert into song values('a001','aaa',2,4,'LOV');
insert into song values('a001','aaa',2,4,'LOV')
*
ERROR at line 1:
ORA-00001: unique constraint (SYSTEM.SO_PK) violated 


SQL> insert into sung_by values('a001','ar002',2,'05-JAN-2019');

1 row created.
 
SQL> rem:=====================================================
