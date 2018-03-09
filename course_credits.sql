drop procedure proj_attr;
DELIMITER $
CREATE PROCEDURE proj_attr()
BEGIN   
    DECLARE v_outer, v_inner BOOLEAN DEFAULT FALSE;    

    declare v_course_id varchar(6);
    declare  v_course_id_2 varchar(6) ;
    declare temp , temp2 int default 0; 
    DECLARE curProjects CURSOR FOR SELECT course_id FROM cwsl;  
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_outer = TRUE;
    set temp =0;
    OPEN curProjects;
    cur_project_loop: LOOP
    FETCH FROM curProjects INTO v_course_id;
    	set temp=temp+1;
        IF v_outer THEN
        CLOSE curProjects;
        LEAVE cur_project_loop;
        END IF;
        -- select v_course_id;




        BLOCK2: BEGIN
        DECLARE curAttribute CURSOR FOR SELECT course_id FROM cc;
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_inner = TRUE;
        set temp2=0;
        OPEN curAttribute; 
        cur_attribute_loop: LOOP
        FETCH FROM curAttribute INTO v_course_id_2;   
            set temp2=temp2+1;

            IF v_inner THEN
            set v_outer = false;
            set v_inner=false;
            CLOSE curAttribute;
            LEAVE cur_attribute_loop;
            END IF;
            if v_course_id=v_course_id_2 THEN
	            select v_course_id, v_course_id_2; 
            end if;
        END LOOP cur_attribute_loop;
        -- select temp2;
        END BLOCK2;




    END LOOP cur_project_loop;
    -- select temp;
END $
DELIMITER ;
