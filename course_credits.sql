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
