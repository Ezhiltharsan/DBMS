rem:Display the flight number,departure date and time of a flight,
rem:its  route details and aircraft  name of type
rem:either Schweizer or Piper that departs during 8.00 PM and 9.00 PM.


select f.flno,f.departs,f.dtime,r.routeid,r.orig_airport,r.dest_airport,r.distance 
from Fl_schedule f,Routes r 
where (f.dtime between 2000 and 2100)  
and f.flno in
(select flightno from flights where (r.routeid = rid) AND aid in 
(select aid from Aircraft where type in('Schweizer','Piper'))
);

rem:--------------------------------------------------------------------------------------

rem:For all the routes, display the flight number, origin and destination airport,
rem:if a flight is  assigned for that route.


select r.routeid,f.flightno,r.orig_airport,r.dest_airport 
from Routes r full outer join Flights f on(f.rid=r.routeid);


rem:--------------------------------------------------------------------------------------

rem:For all aircraft with cruisingrange over 5,000 miles,
rem:find the name of the aircraft and the average salary of all pilots
rem:certified for this aircraft.


select distinct aname,avg(e.salary) from Aircraft a,Certified c,employee e 
where (c.eid= e.eid)
 and (a.cruisingrange>5000) 
and (a.aid=c.aid)
group by a.aname;


rem:--------------------------------------------------------------------------------------

rem:Show the employee details such as id, name and 
rem:salary who are not pilots and whose salary  is more than 
rem:the average salary of pilots.


select distinct eid,ename,salary from Employee 
where (salary>(select avg(salary) from employee 
where eid in(select eid from Certified)) and (eid not in(select eid from Certified)));



rem:--------------------------------------------------------------------------------------

rem:Find the id and name of pilots who were certified to operate some aircrafts
rem:but at least one  of that aircraft is not scheduled from any routes.


select distinct e.eid,e.ename from Employee e,Certified c 
where e.eid=c.eid and c.aid  not in(select aid from Flights);



rem:--------------------------------------------------------------------------------------

rem:Display the origin and destination of the flights having at least 
rem:three departures with  maximum distance covered


select orig_airport,dest_airport from Routes 
where (distance=(select max(distance) from Routes)) and 
(3 in(select count(departs) from Fl_schedule group by(flno)));



rem:--------------------------------------------------------------------------------------

rem:Display name and salary of pilot whose salary is more than the average salary of any pilots 
rem:for each route other than flights originating from Madison airport.


select distinct e.ename,e.salary 
from employee e,certified c,flights f,routes r where (c.eid=e.eid) and  (c.aid=f.aid) and ( r.routeid = f.rid)  
and (r.orig_airport != 'Madison') and e.salary > 
(select avg(e.salary) from employee e,certified c,flights f,routes r where(e.eid = c.eid) and 
(c.aid=f.aid) and (r.orig_airport != 'Madison'));



rem:--------------------------------------------------------------------------------------

rem:Display the flight number, aircraft type, source and destination airport
rem:of the aircraft having  maximum number of flights to Honolulu.


select f.flightNo,a.type,r.orig_airport,dest_airport from 
routes r,flights f,aircraft a where (a.aid=f.aid) and (r.routeid = f.rid)
and (r.dest_airport = 'Honolulu') and 
a.type in(select a.type from routes r,flights f,aircraft a 
where(r.routeid = f.rid) and (f.aid=a.aid)  and (r.dest_airport = 'Honolulu') 
having count(a.type) in(select max(count(a.type)) from 
routes r,flights f,aircraft a where(r.routeid = f.rid) and (f.aid=a.aid)
and (dest_airport = 'Honolulu') group by (a.type)) 
group by (a.type));



rem:--------------------------------------------------------------------------------------

rem:Display the pilot(s) who are certified exclusively to pilot all aircraft in a type.


select distinct c.eid,a.type,count(*) 
from certified c,aircraft a where(c.aid=a.aid) and
c.eid in(select c.eid from Certified c,aircraft a 
where (c.aid = a.aid) having count(distinct a.type) = 1 
group by (c.eid)) 
group by (c.eid,a.type)
having (count(*) = (select count(a1.aid) from aircraft a1 where(a1.type = a.type)));



rem:--------------------------------------------------------------------------------------

rem:Name the employee(s) who is earning the maximum salary among the airport
rem:having  maximum number of departures.


select distinct e.ename,e.salary from 
employee e,certified c,flights f,fl_schedule fl where(e.eid=c.eid) and (f.aid=c.aid) and (f.flightNo = fl.flno) 
and e.salary in(select distinct max(e.salary) from employee e,certified c,flights f,fl_schedule fl
where(c.eid=e.eid) and (f.aid=c.aid) and (f.flightNo = fl.flno)
having(count(flno)) in(select max(count(flno)) from fl_schedule 
group by (flno))
group by (flno));



rem:--------------------------------------------------------------------------------------

rem:Display the departure chart as follows:
rem:flight number, departure(date,airport,time), destination airport, arrival time, aircraft name
rem:for the flights from New York airport during 15 to 19th April 2005.
rem:Make sure that the route contains at least two flights in the above specified condition.


select f.flightNo,fl.departs,r.orig_airport,fl.dtime,r.dest_airport,fl.atime,a.aname 
from aircraft a,flights f,routes r,fl_schedule fl where(a.aid=f.aid) 
and (f.rid = r.routeid) and (f.flightNo = fl.flno) and
(r.orig_airport = 'New York') and (fl.departs between '15-APR-05' and '19-APR-05')
and (select count(f.flightNo) from aircraft a,flights f,routes r,fl_schedule fl
where (a.aid=f.aid) and (f.rid = r.routeid) and (f.flightNo = fl.flno) and
(r.orig_airport = 'New York') and (fl.departs between '15-APR-05' and '19-APR-05'))>= 2;



rem:--------------------------------------------------------------------------------------

rem:A customer wants to travel from Madison to New York with no more than two changes of  flight.
rem:List the flight numbers from Madison if the customer wants to arrive in New York by  6.50 p.m.


select distinct f.flightNo from flights f,routes r,fl_schedule fs where f.rid=r.routeID and fs.flno=f.flightNo
and r.orig_airport='Madison' and r.dest_airport='New York' and fs.atime<=1850
union
select distinct f1.flightNo from flights f1,routes r1,fl_schedule fs1,flights f11,routes r11
where f1.rid=r1.routeID and fs1.flno=f11.flightNo and f11.rid=r11.routeID
and r1.orig_airport='Madison' and r11.dest_airport='New York' and r1.dest_airport=r11.orig_airport and fs1.atime<=1850
union
select distinct f2.flightNo from flights f2,routes r2,fl_schedule fs2,flights f21,routes r21,flights f22,routes r22
where f2.rid=r2.routeID and fs2.flno=f22.flightNo and f21.rid=r21.routeID  and f22.rid=r22.routeID
and r2.orig_airport='Madison' and r22.dest_airport='New York' and r2.dest_airport=r21.orig_airport
and r21.dest_airport=r22.orig_airport and fs2.atime<=1850;



rem:--------------------------------------------------------------------------------------

rem:Display the id and name  of employee(s) who are not pilots.


select eid,ename from Employee where eid in(select eid from Employee minus select eid from Certified);



rem:--------------------------------------------------------------------------------------

rem:Display the id and name of employee(s) who pilots the aircraft from Los Angels and Detroit airport.


select e.eid,e.ename from employee e,certified c,flights f,routes r,aircraft a
where e.eid=c.eid  and r.routeID=f.rID and  f.aid=a.aid and c.aid=a.aid 
and r.orig_airport='Los Angeles'
intersect
select e.eid,e.ename from employee e,certified c,flights f,routes r,aircraft a
where e.eid=c.eid and r.routeID=f.rID and f.aid=a.aid and c.aid=a.aid and  
r.orig_airport='Detroit';


rem:--------------------------------------------------------------------------------------