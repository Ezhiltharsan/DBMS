rem:The date of arrival should be always later than or on the same date of departure.

create or replace trigger arrival
before insert or update on fl_schedule
for each row when (new.atime<new.dtime)
BEGIN
	RAISE_APPLICATION_ERROR(-20107,'atime is incorrect');
END;
/

rem:--------------------------------------------------------------------------------------

rem:Flight number CX­7520 is scheduled only on Tuesday, Friday and Sunday.

create or replace trigger schedule
before insert or update on fl_schedule
for each row when (new.flno='CX7520')
DECLARE
	x char(10);
	y date;
BEGIN
	y:=:new.departs;
	select to_char(y,'DAY') into x from dual;
	if(x not in('TUESDAY','FRIDAY','SUNDAY') ) then
		RAISE_APPLICATION_ERROR(-20107,'scheduling day is incorrect');
	END IF;
END;
/

rem:--------------------------------------------------------------------------------------

rem:An aircraft is assigned to a flight only if its cruising range is more than the distance of the  flights’ route.

create or replace trigger cru_range
before insert or update on flights
for each row
DECLARE
	x number;
	y number;
	w routes.routeid%type;
	z aircraft.aid%type;
BEGIN
	w:=:new.routeid;
	z:=:new.aid;
	select cruisingrange into x from aircraft where (aid=z);
	select distance into y from routes where (routeid=w);
	if(x<=y) then
		RAISE_APPLICATION_ERROR(-20107,'cruising_range is not sufficient');
	END IF;
END;
/

rem:--------------------------------------------------------------------------------------
