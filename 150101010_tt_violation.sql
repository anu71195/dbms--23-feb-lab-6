drop procedure if exists tt_violation; #if the tt_violation procedure already exists then drop it
delimiter $ #changing the delimiter to $
create procedure tt_violation() #creating the tt_violation procedure
begin #beginning the procedure
	DECLARE v_outer, v_inner BOOLEAN DEFAULT FALSE;   ##declaring variables to keep track whether the cursor has reached the end of the table or not
	DECLARE v_name varchar (50); #declaring variable v_name for entry from cursor 1
	DECLARE v_roll int ; #declaring variable for roll number from cursor 1
	DECLARE v_course_id varchar(6); #declaring variable for course from cursor 1
	DECLARE v_exam_date date; #declaring variable for exam date from cursor 1
	DECLARE v_start_time time; #declaring varible for start time from cursor 1
	DECLARE v_name_2 varchar (50); #declaring variable for name from cursor 2
	DECLARE v_roll_2 int ; #declaring variable for roll number from cursor 2
	DECLARE v_course_id_2 varchar(6); #declaring varible for course from cursor 2
	DECLARE v_exam_date_2 date; #declaring variable fro exam date from cursor 2
	DECLARE v_start_time_2	 time; #declaring variable for start time from cursor 2
	DECLARE CURSOR_1 CURSOR FOR SELECT name, roll_number,course_id,exam_date,start_time FROM (select a.roll_number , a.name, a.course_id, a.email, b.exam_date, b.start_time , b.end_time
from cwsl as a , ett as b
where a.course_id=b.course_id
order by a.roll_number	
) as table_1;  #declaring cursor for the table as created from the query
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_outer = TRUE;  #stating if the table has reached to its end then make v_outer set so that we can come out of the loop
drop table if exists VIOLATION; #if the violation table already exists then delete it
CREATE TABLE VIOLATION( #creating the table violation
	roll_number int, #declaring roll number with int
	name varchar(50), #declaring name with varchar(50) as names can be very long
	course_1 varchar(6), #course can be max 6
	course_2 varchar(6) #course can be max 6

);
OPEN CURSOR_1; #starting the cursor 1
    LOOP_1: LOOP #starting a loop for it
    FETCH FROM CURSOR_1 INTO v_name,v_roll,v_course_id,v_exam_date,v_start_time; #fetch from the entries for cursor 1

    IF v_outer THEN #if reached to the end of the table then exit it
        CLOSE CURSOR_1; #exiting the cursor 1
        LEAVE LOOP_1; #leaving the loop corresponding to the cursor 1
    END IF; #end the if statement corresponding to the v_outer set condition

    BLOCK2:begin #beginnnig another block for cursor 2
    	DECLARE cursor_2 CURSOR FOR SELECT name,roll_number,course_id,exam_date,start_time FROM (select a.roll_number , a.name, a.course_id, a.email, b.exam_date, b.start_time , b.end_time
from cwsl as a , ett as b
where a.course_id=b.course_id and a.roll_number=v_roll
order by a.roll_number	
) as table_1; #declaring cursor for the table as created from the query
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_inner = TRUE; #stating if the table has reached to its end then make v_inner set so that we can come out of the loop
        OPEN cursor_2; #opening cursor 2
        LOOP_2: LOOP #starting the loop for cursor 2
        FETCH FROM cursor_2 INTO v_name_2,v_roll_2,v_course_id_2,v_exam_date_2,v_start_time_2;   #fetching entries from cursor 2
            IF v_inner THEN #checking if table has reached its end
            set v_inner=false; # if yes then for another loop in cursor 1 seting v_inner false
            CLOSE cursor_2; #closing the cursor 2 
            LEAVE LOOP_2; #closing the loop 2
            END IF; #end statement for if v_inner 
            if v_course_id!=v_course_id_2 and v_exam_date=v_exam_date_2 and v_start_time=v_start_time_2 then
                insert into VIOLATION select v_roll,v_name,v_course_id,v_course_id_2; #if above condition are satisfied that is for different courses if exam date and time are same then that is a violation so add it to the violation table

            end if; # end if statement

        END LOOP LOOP_2; #ending the inner loop i.e. loop corresponding to cursor 2

    END BLOCK2; #ending the inner block


    END LOOP LOOP_1; #ending the outer loop i.e. for cursor 1
    select distinct roll_number, name,  #now selecting the distinct entries from violation for which courses are clashing and then printing it
case #case statement to sort entries so that (a,b)  will be equal to (b,a)
when course_1<course_2 then course_1
else course_2
end,
case
when course_1>course_2 then course_1
else course_2
end 
from VIOLATION;
end $ #ending the procedure
delimiter ; #changing the delimiter back to its original value


