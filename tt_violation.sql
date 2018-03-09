use 150101010_23feb2018
drop procedure tt_violation;
drop table temp;
create table temp(roll_number int,
name varchar(50),
course_id varchar(6),
email varchar(50),
exam_date date,
start_time time,
end_time time);
insert temp select * from (select a.roll_number , a.name, a.course_id, a.email, b.exam_date, b.start_time , b.end_time
from cwsl as a , ett as b
where a.course_id=b.course_id
order by a.roll_number)as table_1;
DELIMITER $
CREATE PROCEDURE tt_violation()
BEGIN   
	 DECLARE v_outer, v_inner BOOLEAN DEFAULT FALSE;    
	 declare v_roll int;
	 declare v_roll_2 int;
	 declare credit_sum int;
	 declare sum int ;
	 declare v_credits int ;
	 declare v_name varchar(50);
	 declare v_name_2 varchar(50);
     declare v_exam_date date;
     declare v_exam_date_2 date;

     declare v_start_time_2 time;
     
     declare v_start_time time;
    declare v_course_id varchar(6);
    declare  v_course_id_2 varchar(6) ;
    declare temp , temp2 int default 0; 



    DECLARE curProjects CURSOR FOR SELECT name, roll_number,course_id,exam_date,start_time FROM temp; 
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_outer = TRUE;
    drop table output_table_2;
    create table output_table_2(
        name varchar(50),
		roll_number int, 
		course_id varchar(6),
        course_id_2 varchar(6),
        exam_date date,
        start_time time
		);
   
    -- set temp =0;
    -- select temp;
    OPEN curProjects;
    cur_project_loop: LOOP
    FETCH FROM curProjects INTO v_name,v_roll,v_course_id,v_exam_date,v_start_time;
    	-- set temp=temp+1;
        IF v_outer THEN
        CLOSE curProjects;
        LEAVE cur_project_loop;
        END IF;
     -- select temp;




        BLOCK2: BEGIN
        DECLARE curAttribute CURSOR FOR SELECT name,roll_number,course_id,exam_date,start_time FROM temp;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_inner = TRUE;
        OPEN curAttribute; 
        cur_attribute_loop: LOOP
        FETCH FROM curAttribute INTO v_name_2,v_roll_2,v_course_id_2,v_exam_date_2,v_start_time_2;   
            IF v_inner THEN
            -- set v_outer = false;
            set v_inner=false;
            CLOSE curAttribute;
            LEAVE cur_attribute_loop;
            END IF;
            if v_roll_2=v_roll and v_course_id!=v_course_id_2 and v_exam_date=v_exam_date_2 and v_start_time=v_start_time_2 then
                insert into output_table_2 values(v_name, v_roll,v_course_id,v_course_id_2,v_exam_date,v_start_time);
            end if;

        END LOOP cur_attribute_loop;
        END BLOCK2;



    END LOOP cur_project_loop;
END $
DELIMITER ;
