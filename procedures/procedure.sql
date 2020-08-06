rem:dropping tables

drop table order_list;
drop table orders;
drop table pizza;
drop table customer;

rem:--------------------------------------------------------------------------------------------------------

rem:creating tables

create table customer(cust_id varchar(10) constraint cu_pk primary key,
		      cust_name char(50),
		      address varchar(50),
		      phone number(20));


create table pizza(pizza_id varchar(10) constraint p_pk primary key,
		   pizza_type char(50),
		   unit_price number(10));


create table orders(order_no varchar(10) constraint o_pk primary key,
		    cust_id varchar(50) constraint o_fk references customer(cust_id),
		    order_date date,
		    delv_date date);


create table order_list(order_no varchar(10) constraint ol_fk references orders(order_no),
			pizza_id varchar(10) constraint ol_fk1 references pizza(pizza_id),
			qty number(10),
			constraint ol_pk primary key(order_no,pizza_id));


rem:------------------------------------------------------------------------------------------------------------

rem:populating the tables

@ D:\dbms\Pizza_DB.sql

rem:------------------------------------------------------------------------------------------------------------

rem:Check whether the given pizza type is available. If not display appropriate message.

DECLARE
num number(1):=0;
type1 pizza.pizza_type%type;
cursor my_c is select pizza_type from pizza;
BEGIN
	type1:='&pizza_type';
	for c in my_c LOOP
		if(type1=c.pizza_type) then
			dbms_output.put_line('given pizza type found');
			num:=1;
			EXIT;
		END IF;
	END LOOP;
	if(num=0) then
		dbms_output.put_line('given pizza type not found');
	END IF;
END;
/

rem:--------------------------------------------------------------------------------------------------------------

rem:For the given customer name and a range of order date,
rem:find whether a customer had placed any order,
rem:if so display the number of orders placed by the customer along  with the order number(s).

DECLARE
co number(2):=0;
from_date date;
to_date date;
name char(50);
num number(1):=0;
cursor my_c is select o.order_no,c.cust_name,o.order_date from orders o,customer c
where (c.cust_id=o.cust_id);
BEGIN
	name:='&customer_name';
	from_date:='&start_date';
	to_date:='&end_date';
	for c in my_c LOOP
		if(c.cust_name=name) and (c.order_date>=from_date) and (c.order_date<=to_date) then
			dbms_output.put_line(c.order_no);
			co:=co+1;
		END IF;
	END LOOP;
	if(co>0) then
		dbms_output.put_line('total:' ||co);
	else
		dbms_output.put_line('no order placed');
	END IF;
END;
/

rem:----------------------------------------------------------------------------------------------------------------

rem:Display the customer name along with the details of pizza type and its quantity
rem:ordered for the given order number. Also find the total quantity ordered for the given order number.

DECLARE
co number(2):=0;
o_id orders.order_no%type;
cursor my_c is select c.cust_name,c.cust_id,o.order_no,ol.pizza_id,p.pizza_type,ol.qty
from order_list ol,orders o,customer c,pizza p
where (o.order_no=ol.order_no) and (p.pizza_id=ol.pizza_id) and (o.cust_id=c.cust_id);
BEGIN
	o_id:='&order_id';
	for c in my_c LOOP
		if(c.order_no=o_id) then
			dbms_output.put_line('customer name:' || c.cust_name);
			EXIT;
		END IF;
	END LOOP;
	dbms_output.put_line('PIZZA_TYPE     QTY');
	for c in my_c LOOP
		if(c.order_no=o_id) then
			dbms_output.put_line(c.pizza_type || '     ' || c.qty);
			co:=co+c.qty;
		END IF;
	END LOOP;
	dbms_output.put_line('total qty:' || co);
END;
/

rem:-----------------------------------------------------------------------------------------------------------------

rem:Display the total number of orders that contains one pizza type, two pizza type and so on.

DECLARE
co number(2);
co1 number(2):=0;
co2 number(2):=0;
co3 number(2):=0;
co4 number(2):=0;
cursor my_c is select order_no from orders;
BEGIN
	for c in my_c LOOP
		select count(order_no) into co from order_list where(order_no=c.order_no);
		if(co=4) then
			co1:=co1+1;
		elsif(co=3) then
			co2:=co2+1;
		elsif(co=2) then
			co3:=co3+1;
		else
			co4:=co4+1;
		END IF;
	END LOOP;
	dbms_output.put_line('ONE TYPE:' || co4);
	dbms_output.put_line('TWO TYPES:' || co3);
	dbms_output.put_line('THREE TYPES:' || co2);
	dbms_output.put_line('ALL TYPES:' || co1);
END;
/

rem:---------------------------------------------------------------------------------------------------------------