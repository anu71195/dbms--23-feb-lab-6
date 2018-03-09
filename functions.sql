use 150101010_23feb2018
drop procedure proj_attr;
drop table temp;
create table temp (
    roll_number int,
    name varchar(50),
    course_id varchar(6),
    number_of_credits int
);
insert temp select * from (select a.roll_number, a.name,  a.course_id, b.number_of_credits 
from cwsl as a, cc as b
where a.course_id=b.course_id
order by a.roll_number) as table_2;
DELIMITER $
CREATE PROCEDURE proj_attr()
BEGIN   
     DECLARE v_outer, v_inner BOOLEAN DEFAULT FALSE;    
     declare v_roll int;
     declare v_roll_2 int;
     declare credit_sum int;
     declare sum int ;
     declare v_credits int ;
     declare v_name varchar(50);
     declare v_name_2 varchar(50);

    declare v_course_id varchar(6);
    declare  v_course_id_2 varchar(6) ;
    declare temp , temp2 int default 0; 
    DECLARE curProjects CURSOR FOR SELECT name, roll_number FROM (select name, roll_number from cwsl group by name, roll_number) as table_1;  
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_outer = TRUE;
    drop table output_table;
    create table output_table(
        roll_number int primary key, 
        name varchar(50),
        credits int
        );
   
    set temp =0;
    OPEN curProjects;
    cur_project_loop: LOOP
    FETCH FROM curProjects INTO v_name,v_roll;
        set temp=temp+1;
        IF v_outer THEN
        CLOSE curProjects;
        LEAVE cur_project_loop;
        END IF;
     select temp;




        BLOCK2: BEGIN
        DECLARE curAttribute CURSOR FOR SELECT name,roll_number,course_id,number_of_credits FROM temp;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_inner = TRUE;
        -- set temp2=0;
        set credit_sum=0;
        OPEN curAttribute; 
        cur_attribute_loop: LOOP
        FETCH FROM curAttribute INTO v_name_2,v_roll_2,v_course_id_2,v_credits;   
            -- set temp2=temp2+1;

            IF v_inner THEN
            set v_outer = false;
            set v_inner=false;
            CLOSE curAttribute;
            LEAVE cur_attribute_loop;
            END IF;
            if v_name=v_name_2 and v_roll=v_roll_2 THEN
            -- select v_name_2,v_roll_2,v_course_id_2,v_credits,v_name,v_roll;
            set credit_sum=credit_sum+v_credits;
            end if;
            -- if v_course_id=v_course_id_2 THEN
               -- insert into output_table values (v_roll,v_name,v_credits); 
            -- end if;
        END LOOP cur_attribute_loop;
        if credit_sum> 40 THEN
            insert into output_table values(v_roll,v_name,credit_sum);
         end if;
        END BLOCK2;



        -- select * from output_table;
    END LOOP cur_project_loop;
END $
DELIMITER ;



























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



use 150101010_23feb2018;
drop procedure count_credits;
delimiter $
create procedure count_credits()
begin
	DECLARE v_outer, v_inner BOOLEAN DEFAULT FALSE;    
	DECLARE v_name varchar(50);
	DECLARE temp_name varchar(50) default NULL;
	DECLARE v_course_id varchar(50);
	DECLARE v_roll int ;
	DECLARE row_number int default 0;
	DECLARE temp_roll int default 0 ;
	DECLARE temp_credits int default 0;
	DECLARE v_credits int;
	DECLARE CURSOR_1 CURSOR FOR SELECT name, roll_number,course_id,number_of_credits FROM (select a.roll_number, a.name,  a.course_id, b.number_of_credits 
from cwsl as a, cc as b
where a.course_id=b.course_id
order by a.roll_number
) as table_1;  
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_outer = TRUE;
OPEN CURSOR_1;
    LOOP_1: LOOP
    FETCH FROM CURSOR_1 INTO v_name,v_roll,v_course_id,v_credits;
    if v_roll <> temp_roll THEN
    	if temp_credits>40 THEN
    		set row_number=row_number+1;
	    	select row_number, temp_roll,temp_name, temp_credits;
    	end if;
    	set temp_name=v_name;
    	set temp_credits=0;
    	set temp_roll=v_roll;
    end if;    
        IF v_outer THEN
        if temp_credits>40 THEN
	        select temp_roll,temp_name,temp_credits;
        end if;
        CLOSE CURSOR_1;
        LEAVE LOOP_1;
        END IF;
    set temp_credits=temp_credits+v_credits;
END LOOP LOOP_1;
end $
delimiter ;


	






delimiter $
CREATE PROCEDURE count_credits( )
BEGIN
select roll_number ,name,  sum(number_of_credits) as total_credits
from (select a.roll_number, a.name,  a.course_id, b.number_of_credits 
from cwsl as a, cc as b
where a.course_id=b.course_id
order by a.roll_number
) as table_1
group by roll_number ,name
having total_credits>40;
end
$
delimiter ;



drop PROCEDURE tt_violation;
delimiter $
CREATE PROCEDURE tt_violation()
begin
select distinct name,roll_number, 
case
when course_1<course_2 then course_1
else course_2
end,
case
when course_1>course_2 then course_1
else course_2
end 
from
(select distinct * from
(select table_1.roll_number,table_1.name,table_1.course_id as course_1, table_2.course_id as course_2
from(select a.roll_number , a.name, a.course_id, a.email, b.exam_date, b.start_time , b.end_time
from cwsl as a , ett as b
where a.course_id=b.course_id
order by a.roll_number
) as table_1,
(select a.roll_number , a.name, a.course_id, a.email, b.exam_date, b.start_time , b.end_time
from cwsl as a , ett as b
where a.course_id=b.course_id
order by a.roll_number
) as table_2
where table_1.course_id<>table_2.course_id and table_2.roll_number=table_1.roll_number and table_1.exam_date=table_2.exam_date and table_1.start_time=table_2.start_time
order by table_1.course_id) as tabel_3
order by name) as table_4;
end
$
delimiter ;
















select table_4.name,table_4.roll_number,table_4.course_1,table_4.course_2,table_5.course_1,table_5.course_2 from 

(select distinct * from
(select table_1.roll_number,table_1.name,table_1.course_id as course_1, table_2.course_id as course_2
from(select a.roll_number , a.name, a.course_id, a.email, b.exam_date, b.start_time , b.end_time
from cwsl as a , ett as b
where a.course_id=b.course_id
order by a.roll_number
) as table_1,
(select a.roll_number , a.name, a.course_id, a.email, b.exam_date, b.start_time , b.end_time
from cwsl as a , ett as b
where a.course_id=b.course_id
order by a.roll_number
) as table_2
where table_1.course_id<>table_2.course_id and table_2.roll_number=table_1.roll_number and table_1.exam_date=table_2.exam_date and table_1.start_time=table_2.start_time
order by table_1.course_id) as tabel_3
order by name)as table_4,

(select distinct * from
(select table_1.roll_number,table_1.name,table_1.course_id as course_1, table_2.course_id as course_2
from(select a.roll_number , a.name, a.course_id, a.email, b.exam_date, b.start_time , b.end_time
from cwsl as a , ett as b
where a.course_id=b.course_id
order by a.roll_number
) as table_1,
(select a.roll_number , a.name, a.course_id, a.email, b.exam_date, b.start_time , b.end_time
from cwsl as a , ett as b
where a.course_id=b.course_id
order by a.roll_number
) as table_2
where table_1.course_id<>table_2.course_id and table_2.roll_number=table_1.roll_number and table_1.exam_date=table_2.exam_date and table_1.start_time=table_2.start_time
order by table_1.course_id) as tabel_3
order by name)as table_5
where table_4.name=table_5.name and table_4.course_1=table_5.course_1 
;
