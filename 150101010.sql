DROP DATABASE 150101010_23feb2018;
CREATE DATABASE 150101010_23feb2018;
USE 150101010_23feb2018;
CREATE TABLE ett(
	line_number int PRIMARY KEY AUTO_INCREMENT,
	course_id varchar(6),
	exam_date date,
	start_time time,
	end_time time,
	UNIQUE(course_id,exam_date,start_time,end_time)
);
CREATE TABLE cc(
	course_id varchar(6) PRIMARY KEY,
	number_of_credits int
);
CREATE TABLE cwsl
(
	serial_number int AUTO_INCREMENT,
	roll_number int,
	name varchar(50),
	email varchar(50),
	course_id varchar(6),
	PRIMARY KEY(serial_number),
	UNIQUE(roll_number,course_id)
);


CREATE PROCEDURE count_credits()


(select a.roll_number, a.name, a.email, a.course_id, b.number_of_credits 
from cwsl as a, cc as b
where a.course_id=b.course_id) as table_1