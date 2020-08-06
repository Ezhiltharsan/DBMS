REM : Dropping views

drop view schedule_15;
drop view airtype;
drop view losangeles_route;
drop view losangeles_flight;

REM:-----------------------------------------------------------------------------------------------------

REM : Create a view Schedule_15 that display the flight number, route, airport(origin, destination)
REM : departure (date, time), arrival (date, time) of a flight on 15 apr 2005. Label the view column
REM : as flight, route, from_airport, to_airport, ddate, dtime, adate, atime respectively.


create or replace view Schedule_15
(flight,route,from_airport,to_airport,ddate,dtime,adate,atime)
as
select f.flightno,r.routeid,r.orig_airport,r.dest_airport,
fl.departs,fl.dtime,fl.arrives,fl.atime
from flights f,routes r,fl_schedule fl where (f.flightno=fl.flno) and
(f.rid=r.routeid) and (fl.arrives='15-apr-2005');


REM:display of view

select * from schedule_15;


savepoint p1;

REM:UPDATE


REM:Error

update schedule_15 set from_airport='Las Vegas' where flight='RP-5018';
update schedule_15 set to_airport='Las Vegas' where flight='RP-5018'
update schedule_15 set route='MM203' where flight='RP-5018';
update schedule_15 set flight='9E-3749' where route='MD200';

REM:allowed

update schedule_15 set dtime = 1130 where flight = 'HA-1';

select * from schedule_15 where flight = 'HA-1';
select flno,dtime from fl_schedule where flno = 'HA-1';


update schedule_15 set atime = 1130 where flight = 'HA-1';

select * from schedule_15 where flight = 'HA-1';
select flno,atime from fl_schedule where flno = 'HA-1';


update schedule_15 set ddate = '16-APR-05' where flight = 'SQ-11';

select * from schedule_15 where flight = 'SQ-11';
select flno,departs from fl_schedule where flno = 'SQ-11';


update schedule_15 set adate = '16-APR-05' where flight = 'HA-1';

select * from schedule_15 where flight = 'HA-1';
select flno,arrives from fl_schedule where flno = 'HA-1';


REM:DELETE


REM:allowed

delete from schedule_15 where flight = 'HA-1';

select * from schedule_15 where flight = 'HA-1';
select * from fl_schedule where flno = 'HA-1';


REM:INSERT


REM:error

insert into schedule_15 values('HA-1','LH106','Los Angeles','Honolulu','15-apr-05','1230','16-apr-05','2055');

rollback to p1;


REM:-------------------------------------------------------------------------------------------------------------

REM : Define a view Airtype that display the number of aircrafts for each of its type.
REM : Label the column as craft_type, total.

create view Airtype
(craft_type,total)
as
select type,count(type) from aircraft group by(type);


REM:display of view

select * from airtype;

savepoint p2;


REM:updates


REM:errors

update airtype set total = 5 where craft_type='Saab';
update airtype set craft_type='Saab' where total = 1;


REM:DELETE


REM:errors

delete from airtype where craft_type='Saab';


REM :INSERT


REM:errors

insert into airtype values('streamer','4');

rollback to p2;



REM:--------------------------------------------------------------------------------------------------------

REM : Create a view Losangeles_Route that display the information about Los Angeles route.
REM : Ensure that the view always contain/allows only information about the Los Angeles route.

create view losangeles_route
as
select * from routes where
orig_airport = 'Los Angeles' or dest_airport  = 'Los Angeles';


REM:display of view

select * from losangeles_route;

savepoint p3;


REM:UPDATE


REM:errors

update losangeles_route set routeid = 'AM101' where dest_airport = 'New York';

REM:allowed

update losangeles_route set distance = 1130 where routeid = 'LW100';

select * from losangeles_route where routeid = 'LW100';
select * from routes where routeid = 'LW100';


update losangeles_route set orig_airport = 'Tokyo' where routeid = 'LC101';

select * from losangeles_route where routeid = 'LC101';
select * from routes where routeid = 'LC101';


update losangeles_route set dest_airport = 'Tokyo' where routeid = 'LW100';

select * from losangeles_route where routeid = 'LW100';
select * from routes where routeid = 'LW100';


REM:DELETE


REM:errors

delete from losangeles_route where routeid = 'LW100';


REM:INSERT


REM:allowed

insert into losangeles_route values('LH107','Los Angeles','Los vegas','4500');

select * from losangeles_route where routeid = 'LH107';
select * from routes where routeid = 'LH107';

rollback to p3;



REM:---------------------------------------------------------------------------------------------------------

REM : Create a view named Losangeles_Flight on Schedule_15 (as defined in 1) that display flight,
REM : departure (date, time), arrival (date, time) of flight(s) from Los Angeles.

create view Losangeles_Flight
(flight,ddate,dtime,adate,atime)
as
select flight,ddate,dtime,adate,atime from schedule_15 where (from_airport='Los Angeles');


REM:display of view

select * from losangeles_flight;

savepoint p4;


REM:UPDATE


REM:errors

update losangeles_flight set flight='h001' where dtime=2100;

REM:allowed

update losangeles_flight set dtime = 1130 where flight = 'SQ-11';

select * from losangeles_flight where flight = 'SQ-11';
select * from fl_schedule where flno = 'SQ-11';


update losangeles_flight set atime = 1130 where flight = 'HA-1';

select * from losangeles_flight where flight = 'HA-1';
select flight ,atime from schedule_15 where flight = 'HA-1';


update losangeles_flight set ddate = '16-APR-05' where flight = 'HA-1';

select * from losangeles_flight where flight = 'HA-1';
select flight ,ddate from schedule_15 where flight = 'HA-1';


update losangeles_flight set adate = '16-APR-05' where flight = 'SQ-11';

select * from losangeles_flight where flight = 'SQ-11';
select flight ,adate from schedule_15 where flight = 'SQ-11';


REM:DELETE


REM:allowed


delete from losangeles_flight where flight = 'SQ-11';

select * from losangeles_flight where flight = 'SQ-11';
select * from fl_schedule where flno = 'SQ-11';


REM:INSERT


REM:errors

insert into losangeles_flight values('SQ-11','15-APR-05','1130','16-APR-05','2055');

rollback to p4;

REM:----------------------------------------------------------------------------------------------------------