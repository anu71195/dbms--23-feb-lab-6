drop procedure if exists count_credits;#if  the procedure exists already then delete it
delimiter $ #delimiter changing to $ #
create procedure count_credits() #starting the procedure count_credits
begin #command to start the procedure
	DECLARE v_outer, v_inner BOOLEAN DEFAULT FALSE; #declaring variables to keep track whether the cursor has reached the end of the table or not
	DECLARE v_name varchar(50);  #name of the student fetched from the table
	DECLARE temp_name varchar(50) default NULL; #name to keep track whether the name of the student fetched newly is changed or not if chawnged then print the entry if the course credit sum is greater than 40 for that student
	DECLARE v_course_id varchar(50); #course student is taking 
	DECLARE v_roll int ; #roll number of the student
	DECLARE row_number int default 0; #entry number for which the credit sum is greater than 40
	DECLARE temp_roll int default 0 ; #keeps track if the roll number is changed or not
	DECLARE temp_credits int default 0; #keeps tracks for the sum of credits for each student
	DECLARE v_credits int; #credits of the course for each students
	DECLARE CURSOR_1 CURSOR FOR SELECT name, roll_number,course_id,number_of_credits FROM (select a.roll_number, a.name,  a.course_id, b.number_of_credits 
from cwsl as a, cc as b
where a.course_id=b.course_id
order by a.roll_number
) as table_1;  #declaring cursor for the table as created from the query
DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_outer = TRUE; #stating if the table has reached to its end then make v_outer set so that we can come out of the loop
OPEN CURSOR_1; #start the cursor
    LOOP_1: LOOP #starting the loop
    FETCH FROM CURSOR_1 INTO v_name,v_roll,v_course_id,v_credits; #fetching entries from the cursor one by one
    if v_roll <> temp_roll THEN #checking if the roll number has changed with this fetch
    	if temp_credits>40 THEN #if yes and credit sum is greater than 40 then print that entry
    		set row_number=row_number+1; #increment the entry number for which credit is greater than 40
	    	select row_number, temp_roll,temp_name, temp_credits; #printing the required entry
    	end if; #ending the if statement for the temp_credits>40
    	set temp_name=v_name; #updating temp_name to the new name
    	set temp_credits=0; #making credit sum equals to 0
    	set temp_roll=v_roll; # updating roll number to the new roll number
    end if; #ending the if statement for changing roll number conditional if statement
        
        IF v_outer THEN #checking if the entry has reached to the end of teh table
        if temp_credits>40 THEN #if yes and credit is greater htan 40 then print the required entry
	        select temp_roll,temp_name,temp_credits; #printing the required entry
        end if; #ending the if stateent for v_outer set condition
        CLOSE CURSOR_1; #closing the cursor if fetched has reached to its end
        LEAVE LOOP_1; #leaving the loop if fetche has reached to its end
        END IF; #ending if statement if v_outer has reached to its end
    set temp_credits=temp_credits+v_credits; #increment sum credits for new credit with different course_id but with same roll number
END LOOP LOOP_1; #exiting loop_1
end $ #exiting the procedure
delimiter ; #again changing the delimiter to its original values