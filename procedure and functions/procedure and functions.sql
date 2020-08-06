rem:Add necessary attributes to ORDERS.


alter table orders add(total_amt number(4),discount number(2),bill_amt number(4));

rem:----------------------------------------------------------------------------------------------------

rem:Write a stored function to display the total number of pizza's ordered by the given  order number.


create or replace function t_order(ord orders.order_no%type) return real
is
	co number(3);
BEGIN
	select sum(qty) into co from order_list where order_no=ord;
	if(sql%notfound) then
		dbms_output.put_line('order_no not available');
		return 0;
	else
		return co;
	END IF;
END;
/

rem:----------------------------------------------------------------------------------------------------

rem:Write a PL/SQL block to calculate the total amount, discount and billable amount.
rem:Calculate the billable amount (after the discount) and update the same in orders  table.


create or replace procedure up_order
is
	co number(1);
	cursor my_c is select o.order_no,sum(o.qty*p.unit_price) amt from order_list o,pizza p
	where o.qty is not null and (p.pizza_id=o.pizza_id) group by(o.order_no);
	cursor my_c1 is select distinct order_no from order_list
	having count(order_no)=count(qty) group by(order_no);
BEGIN
	co:=0;
	for c in my_c LOOP
		for c1 in my_c1 LOOP
			if(c.order_no=c1.order_no) then
				co:=1;
				exit;
			END IF;
		END LOOP;
		if(co=1) then
			update orders set total_amt=c.amt where order_no=c.order_no;
			if(c.amt>10000) then	
				update orders set discount=20 where order_no=c.order_no;
			elsif(c.amt>5000) then
				update orders set discount=10 where order_no=c.order_no;
			elsif(c.amt>2000) then
				update orders set discount=5 where order_no=c.order_no;
			else
				update orders set discount=0 where order_no=c.order_no;
			END IF;
			update orders set bill_amt=total_amt-(total_amt*discount/100)
			where order_no=c.order_no;
		else
			dbms_output.put_line(c.order_no || 'information not available');
		END IF;
	END LOOP;
END;
/

rem:----------------------------------------------------------------------------------------------------

rem:For the given order number, write a PL/SQL block to print the order


create or replace procedure receipt(ord IN orders.order_no%type)
is
	co number(1):=1;
	co1 orders.order_no%type;
	co2 orders.order_no%type;
	co3 orders.order_no%type;
	co4 orders.order_no%type;
	co5 number(1):=0;
	cursor my_c is select c.cust_name,c.cust_id,c.phone,o.order_no,o.order_date,ol.pizza_id,
	o.bill_amt,o.total_amt,o.discount,p.pizza_type,p.unit_price,ol.qty
	from order_list ol,orders o,customer c,pizza p
	where (o.order_no=ol.order_no) and (o.order_no=ord) and (p.pizza_id=ol.pizza_id) and (o.cust_id=c.cust_id);
	cursor my_c1 is select distinct order_no from order_list
	having count(order_no)=count(qty) group by(order_no);
BEGIN
	up_order();
	for c in my_c1 LOOP
		if(c.order_no=ord) then
			co5:=1;
			exit;
		END IF;
	END LOOP;
	if(co5=1) then
		for c in my_c LOOP
			if(co=1) then
				dbms_output.put_line('*******************************************************************************************');
				dbms_output.put_line('ORDER NUMBER:' || ord || '				CUSTOMER NAME:' || c.cust_name);
				dbms_output.put_line('ORDER DATE:' || c.order_date || '				PHONE:' || c.phone);
				dbms_output.put_line('*******************************************************************************************');
				dbms_output.put_line('SNO		PIZZA_TYPE		QTY		PRICE		AMOUNT');
			END IF;
			dbms_output.put_line(co || '.		' || c.pizza_type || '		' || c.qty || '		' || c.unit_price || '		' || c.qty*c.unit_price);
			co:=co+1;
			co1:=c.total_amt;
			co2:=c.discount;
			co3:=c.bill_amt;
		END LOOP;
		co4:=t_order(ord);
		dbms_output.put_line('--------------------------------------------------------------------------');
		dbms_output.put_line('			TOTAL' || co4 || '		' || co1);
		dbms_output.put_line('--------------------------------------------------------------------------');
		dbms_output.put_line('TOTAL AMOUNT		:' || co1);
		dbms_output.put_line('DISCOUNT (' || co2 || ')		:' || co2/100*co1);
		dbms_output.put_line('--------------------------------------------------------------------------');
		dbms_output.put_line('AMOUNT TO BE PAID		:' || co3);
		dbms_output.put_line('--------------------------------------------------------------------------');
		dbms_output.put_line('Great Offers! Discount up to 25% on DIWALI Festival Day...');
		dbms_output.put_line('*******************************************************************************************');
	else
		dbms_output.put_line(ord || ' information not available');
	END IF;
END;
/

rem:----------------------------------------------------------------------------------------------------
