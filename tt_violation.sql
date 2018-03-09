use 150101010_23feb2018;
drop procedure if exists tt_violation;
delimiter $
create procedure tt_violation()
begin
	DECLARE v_outer, v_inner BOOLEAN DEFAULT FALSE;   
	DECLARE COUNT INT DEFAULT 0; 
	DECLARE v_name varchar (50);
	DECLARE v_roll int ;
	DECLARE v_course_id varchar(6);
	DECLARE v_exam_date date;
	DECLARE v_start_time time;
	DECLARE v_name_2 varchar (50);
	DECLARE v_roll_2 int ;
	DECLARE v_course_id_2 varchar(6);
	DECLARE v_exam_date_2 date;
	DECLARE v_start_time_2	 time;
	DECLARE CURSOR_1 CURSOR FOR SELECT name, roll_number,course_id,exam_date,start_time FROM (select a.roll_number , a.name, a.course_id, a.email, b.exam_date, b.start_time , b.end_time
from cwsl as a , ett as b
where a.course_id=b.course_id
order by a.roll_number	
) as table_1;  
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_outer = TRUE;
drop table if exists VIOLATION;
CREATE TABLE VIOLATION(
	roll_number int,
	name varchar(50),
	course_1 varchar(6),
	course_2 varchar(6)
	-- primary key (roll_number,course_id,v_course_id_2)

);
OPEN CURSOR_1;
    LOOP_1: LOOP
    FETCH FROM CURSOR_1 INTO v_name,v_roll,v_course_id,v_exam_date,v_start_time;

    IF v_outer THEN
        CLOSE CURSOR_1;
        LEAVE LOOP_1;
    END IF;

    BLOCK2:begin
    	DECLARE cursor_2 CURSOR FOR SELECT name,roll_number,course_id,exam_date,start_time FROM (select a.roll_number , a.name, a.course_id, a.email, b.exam_date, b.start_time , b.end_time
from cwsl as a , ett as b
where a.course_id=b.course_id and a.roll_number=v_roll
order by a.roll_number	
) as table_1;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_inner = TRUE;
        OPEN cursor_2; 
        LOOP_2: LOOP
        FETCH FROM cursor_2 INTO v_name_2,v_roll_2,v_course_id_2,v_exam_date_2,v_start_time_2;   
            IF v_inner THEN
            set v_inner=false;
            CLOSE cursor_2;
            LEAVE LOOP_2;
            END IF;
            if v_course_id!=v_course_id_2 and v_exam_date=v_exam_date_2 and v_start_time=v_start_time_2 then
                insert into VIOLATION select v_roll,v_name,v_course_id,v_course_id_2;
            	SET COUNT=COUNT+1;

            end if;

        END LOOP LOOP_2;

    END BLOCK2;


    END LOOP LOOP_1;
    SELECT COUNT;
    select distinct roll_number, name, 
case
when course_1<course_2 then course_1
else course_2
end,
case
when course_1>course_2 then course_1
else course_2
end 
from VIOLATION;
end $
delimiter ;


