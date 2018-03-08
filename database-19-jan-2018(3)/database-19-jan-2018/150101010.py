import os
import csv
a=os.walk('course-wise-students-list')
directories=[];
for i in a:
	directories.append(i[0]);
directories.pop(0)
count=0
fw=open("cwsl_queries.sql","w")
for i in directories:
	b=os.walk(i);
	for temp in b:
		files=[];
		for temp2 in temp:
			files.append(temp2)
		files.pop(0)
		files.pop(0)
		for file_name in files[0]:
			path=i+'/'+file_name
			fp=open(path,"r");
			info=csv.reader(fp)
			for line in info:
				line.pop(0)
				line.append(file_name.split('.')[0]);
				count+=1;
				fw.write('INSERT INTO cwsl (roll_number,name,email,course_id) VALUES("')				
				fw.write(('","').join(line))
				fw.write('");\n')

print(count)