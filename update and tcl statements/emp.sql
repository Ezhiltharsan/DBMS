SQL> rem:EMPLOYEE
SQL> 
SQL> rem:=======================================================
SQL> 
SQL> rem:display fist_name,job_id,salary of all employees
SQL> 
SQL> 
SQL> select first_name,job_id,salary from employees;

FIRST_NAME           JOB_ID         SALARY                                                                    
-------------------- ---------- ----------                                                                    
Steven               AD_PRES         24000                                                                    
Neena                AD_VP           17000                                                                    
Lex                  AD_VP           17000                                                                    
Alexander            IT_PROG          9000                                                                    
Bruce                IT_PROG          6000                                                                    
David                IT_PROG          4800                                                                    
Valli                IT_PROG          4800                                                                    
Diana                IT_PROG          4200                                                                    
Kevin                ST_MAN           5800                                                                    
Trenna               ST_CLERK         3500                                                                    
Curtis               ST_CLERK         3100                                                                    
Randall              ST_CLERK         2600                                                                    
Peter                ST_CLERK         2500                                                                    
Eleni                SA_MAN          10500                                                                    
Ellen                SA_REP          11000                                                                    
Jonathon             SA_REP           8600                                                                    
Kimberely            SA_REP           7000                                                                    
Jennifer             AD_ASST          4400                                                                    
Michael              MK_MAN          13000                                                                    
Pat                  MK_REP           6000                                                                    
Shelley              AC_MGR          12000                                                                    
William              AC_ACCOUNT       8300                                                                    

22 rows selected.

SQL> 
SQL> rem:========================================================
SQL> 
SQL> rem:display the id,name(first & last), salary and annual salary
SQL> rem:of all the employees and sort the them by first name
SQL> 
SQL> 
SQL> select employee_id as EMPLOYEE_ID,concat(concat(first_name,' '),last_name) as FULL_NAME,
  2  salary as MONTHLY_SAL,salary*12 as ANNUAL_SALARY from employees order by first_name;

EMPLOYEE_ID FULL_NAME        MONTHLY_SAL  ANNUAL_SALARY                          
----------- ----------       ------------ ----------------------                          103         Alexander Hunold 9000         108000                 104         Bruce Ernst      6000         72000                         142         Curtis Davies    3100         37200                          
105         David Austin     4800         57600                          
107         Diana Lorentz    4200         50400                          
149         Eleni Zlotkey    10500        126000                    174         Ellen Abel       11000        132000 
200         Jennifer whalen  4400         52800      
176         Johnathan Taylor 8600         103200    
124         Kevin Mourgos    5800         69600                      178         Kimberely Grant  7000         84000                   102         Lex De Haan      17000        204000                          
201         Michael Hartstein13000        156000                         101         Neena Kochhar    17000        204000                          202         Pat Fay          6000         72000                          144         Peter Vargas     2500         30000                          143         Randall Matos    2600         31200                        205         Shelley Higgins  12000        144000                   100         Steven King      24000        288000                          141         Trenna Rajs      3500         42000                          106         Valli Pataballa  4800         57600                          
206         William Gietz    8300         99600                          

22 rows selected.

SQL> 
SQL> rem:=====================================================
SQL> 
SQL> rem:display jobs of employees
SQL> 
SQL> 
SQL> select distinct job_id from employees;

JOB_ID                                                                                                        
----------                                                                                                    
IT_PROG                                                                                                       
AC_MGR                                                                                                        
AC_ACCOUNT                                                                                                    
ST_MAN                                                                                                        
AD_ASST                                                                                                       
AD_VP                                                                                                         
SA_MAN                                                                                                        
MK_MAN                                                                                                        
AD_PRES                                                                                                       
SA_REP                                                                                                        
MK_REP                                                                                                        
ST_CLERK                                                                                                      

12 rows selected.

SQL> 
SQL> rem:========================================================
SQL> 
SQL> rem:display the id, first name, job id, salary and commission of employees who are earning commissions
SQL> 
SQL> 
SQL> select employee_id,first_name,job_id,salary,commission_pct from employees
  2  where commission_pct is not null;

EMPLOYEE_ID FIRST_NAME   JOB_ID       SALARY COMMISSION_PCT                                         
----------- ---------- ---------- ---------- -------------------                                        
149          Eleni       SA_MAN       10500             .2                                         
174          Ellen        SA_REP    11000             .3                                         176          Jonathon      SA_REP    8600             .2                                         
178          Kimberely    SA_REP           7000        .15                                         

SQL> 
SQL> rem:========================================================
SQL> 
SQL> rem:details of employees who are managers
SQL> 
SQL> 
SQL> select distinct worker.employee_id,worker.first_name,worker.job_id,worker.salary,worker.department_id
  2  from employees worker,employees manager where worker.employee_id=manager.manager_id;

EMPLOYEE_ID FIRST_NAME           JOB_ID         SALARY DEPARTMENT_ID                                          
----------- -------------------- ---------- ---------- -------------                                          
        102 Lex                  AD_VP           17000            90                                          
        103 Alexander            IT_PROG          9000            60                                          
        100 Steven               AD_PRES         24000            90                                          
        124 Kevin                ST_MAN           5800            50                                          
        149 Eleni                SA_MAN          10500            80                                          
        201 Michael              MK_MAN          13000            20                                          
        101 Neena                AD_VP           17000            90                                          
        205 Shelley              AC_MGR          12000           110                                          

8 rows selected.

SQL> 
SQL> rem:=======================================================
SQL> 
SQL> rem:display the details of employees other than sales representatives hired after ‘01May1999’
SQL> rem:or whose salary is at least 10000
SQL> 
SQL> 
SQL> select employee_id,first_name,hire_date,job_id,salary,department_id from employees
  2  where job_id!='SA_REP' and (hire_date > '01-MAY-1999' or salary>=10000);

EMPLOYEE_ID FIRST_NAME  HIRE_DATE JOB_ID SALARY DEPARTMENT_ID                                
----------- ---------- ---------- ------ ------ ----------                                 
100         Steven   17-JUN-87 AD_PRES    24000            90                                
101         Neena    21-SEP-89 AD_VP      17000            90                                
102         Lex      13-JAN-93 AD_VP      17000            90                                
124         Kevin    16-NOV-99 ST_MAN     5800             50                                
149         Eleni    29-JAN-00 SA_MAN     10500            80                                201         Michael  17-FEB-96 MK_MAN     13000            20                                
205         Shelley  07-JUN-94 AC_MGR     12000           110                                

7 rows selected.

SQL> 
SQL> rem:========================================================
SQL> 
SQL> rem:display the employee details whose salary falls in the range of 5000 to 15000 and his/her name
SQL> rem:begins with any of characters (A,J,K,S) and sort the output by first name
SQL> 
SQL> 
SQL> select first_name,hire_date,salary,department_id from employees where (salary between 5000 and 15000)
  2  and (substr(first_name,1,1) in ('A','J','K','S')) order by first_name;

FIRST_NAME           HIRE_DATE     SALARY DEPARTMENT_ID                                                       
-------------------- --------- ---------- -------------                                                       
Alexander            03-JAN-90       9000            60                                                       
Jonathon             24-MAR-98       8600            80                                                       
Kevin                16-NOV-99       5800            50                                                       
Kimberely            24-MAY-99       7000                                                                     
Shelley              07-JUN-94      12000           110                                                       

SQL> 
SQL> rem:=======================================================
SQL> 
SQL> rem:display the experience of employees in no. of years and months who were hired after 1998
SQL> 
SQL> 
SQL> select employee_id,first_name,hire_date,months_between(sysdate,hire_date)/12 exp_years,
  2  months_between(sysdate,hire_date) exp_months from employees where hire_date>'31-Dec-1998';

EMPLOYEE_ID FIRST_NAME           HIRE_DATE  EXP_YEARS EXP_MONTHS                                              
----------- -------------------- --------- ---------- ----------                                              
        107 Diana                07-FEB-99 21.0265991 252.319189                                              
        124 Kevin                16-NOV-99      20.25        243                                              
        149 Eleni                29-JAN-00 20.0507927 240.609512                                              
        178 Kimberely            24-MAY-99 20.7309002 248.770802                                              

SQL> 
SQL> rem:========================================================
SQL> 
SQL> rem:display the total number of departments
SQL> 
SQL> 
SQL> select count(distinct department_id) no from employees;

        NO                                                                                                    
----------                                                                                                    
         7                                                                                                    

SQL> 
SQL> rem:=======================================================
SQL> 
SQL> rem:display the number of employees hired by yearwise and sort the result by yearwise
SQL> 
SQL> 
SQL> select count(employee_id),extract(year from hire_date) from employees group by
  2  extract(year from hire_date) order by extract(year from hire_date);

COUNT(EMPLOYEE_ID) EXTRACT(YEARFROMHIRE_DATE)                                                                 
------------------ --------------------------                                                                 
                 2                       1987                                                                 
                 1                       1989                                                                 
                 1                       1990                                                                 
                 1                       1991                                                                 
                 1                       1993                                                                 
                 2                       1994                                                                 
                 1                       1995                                                                 
                 2                       1996                                                                 
                 3                       1997                                                                 
                 4                       1998                                                                 
                 3                       1999                                                                 
                 1                       2000                                                                 

12 rows selected.

SQL> 
SQL> rem:======================================================
SQL> 
SQL> rem:display the minimum, maximum and average salary, number of employees for each department.
SQL> rem:Exclude the employee(s) who are not in any department.Include the department(s) with at least
SQL> rem:2 employees and the average salary is more than 10000.
SQL> rem:Sort the result by minimum salary in descending order
SQL> 
SQL> 
SQL> select min(salary),max(salary),avg(salary),count(employee_id),department_id from employees
  2  where department_id is not null group by department_id having count(employee_id)>1
  3  and avg(salary)>10000 order by min(salary) desc;

MIN(SALARY)MAX(SALARY)AVG(SALARY)COUNT(EMPLOYEE_ID) DEPARTMENT_ID                                          
----------- ----------- -------- --------------- ----------                                         
17000       24000     19333.3333         3            90                                          
8600        11000      10033.3333        3            80                                         8300        12000       10150            2           110                                          

SQL> rem:=======================================================