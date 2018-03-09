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
