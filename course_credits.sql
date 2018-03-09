use 150101010_23feb2018;
drop procedure if exists count_credits;
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


