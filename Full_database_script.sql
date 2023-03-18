drop database mess_managament;
create database mess_management;
use mess_management;

-- drop database mess_managament;

create table mess(
mess_id INT PRIMARY KEY NOT NULL,
mess_name VARCHAR(20),
num_of_employee INT,
number_of_student INT
);

create table mess_local_contact( 
local_contact bigint(10) NOT NULL,
mess_id INT NOT NULL,
PRIMARY KEY (local_contact,mess_id),
FOREIGN KEY (mess_id) REFERENCES mess(mess_id)
);


create table contractor_manages(contractor_id INT PRIMARY KEY NOT NULL,
mess_id INT NOT NULL,
FOREIGN KEY (mess_id) REFERENCES mess(mess_id),
contractor_name VARCHAR(20) NOT NULL,
hq_street_number INT,
hq_street_name VARCHAR(20),
hq_office_number INT,
hq_city VARCHAR(20),
hq_state VARCHAR(20),
hq_pincode INT
);


create table contractor_contact(hq_contact_number BIGINT(10) PRIMARY KEY NOT NULL,
contractor_id INT  NOT NULL,
FOREIGN KEY (contractor_id) REFERENCES contractor_manages(contractor_id)
);


create table feedback_received( feedback_id INT PRIMARY KEY NOT NULL,
mess_id INT NOT NULL,
FOREIGN KEY (mess_id) REFERENCES mess(mess_id),
star_rating INT,
comment VARCHAR(200),
photo BLOB,
name VARCHAR(20),
date DATETIME,
slot VARCHAR(20)
);


create table employee_works(employee_id INT PRIMARY KEY NOT NULL,
mess_id INT NOT NULL,
FOREIGN KEY (mess_id) REFERENCES mess(mess_id),
name VARCHAR(20) NOT NULL,
street_name VARCHAR(20),
house_no VARCHAR(20),
city VARCHAR(20),
state VARCHAR(20),
pincode INT,
designation VARCHAR(20),
gender VARCHAR(20),
dob DATE,
salary INT CHECK (SALARY>=5000),
email VARCHAR(40) NOT NULL UNIQUE,
password VARCHAR(20)
);


create table employee_contact( contact_number BIGINT(10) PRIMARY KEY NOT NULL,
employee_id INT  NOT NULL,
FOREIGN KEY (employee_id) REFERENCES employee_works(employee_id)
);


create table day_slot( 
	dayslot_id INT PRIMARY KEY NOT NULL,
	day_sl VARCHAR(10),
	slot VARCHAR(20)
);

create table operates_at(
	mess_id INT  NOT NULL,
	dayslot_id INT  NOT NULL,
    PRIMARY KEY (mess_id,dayslot_id),
    FOREIGN KEY (mess_id) REFERENCES mess(mess_id),
    FOREIGN KEY (dayslot_id) REFERENCES day_slot(dayslot_id),
	price INT NOT NULL
);


create table balance_sheet( 
	balance_id INT PRIMARY KEY NOT NULL,
	mess_id INT NOT NULL,
	FOREIGN KEY (mess_id) REFERENCES mess(mess_id),
	from_student INT,
	from_guest INT,
	to_employee INT,
	to_vendor INT,
	miscellaneous INT,
	month VARCHAR(20),
	year INT
);

create table date_slot(
	date_slot_id INT PRIMARY KEY NOT NULL,
	date DATE,
	slot VARCHAR(20)
);

create table wastage( 
    mess_id INT  NOT NULL,
	date_slot_id INT NOT NULL ,
    PRIMARY KEY (mess_id,date_slot_id),
    FOREIGN KEY (mess_id) REFERENCES mess(mess_id),
    FOREIGN KEY (date_slot_id) REFERENCES date_slot(date_slot_id),
	food_wasted DECIMAL(5,3)
);

create table stock_contains(
	product_id INT PRIMARY KEY NOT NULL,
	mess_id INT NOT NULL,
    FOREIGN KEY (mess_id) REFERENCES mess(mess_id),
	quantity DECIMAL(10,3) ,
	in_date DATE,
	expiry DATE
);

create table student_allocated( roll_number INT PRIMARY KEY NOT NULL,
	mess_id INT NOT NULL,
    FOREIGN KEY (mess_id) REFERENCES mess(mess_id),
	name VARCHAR(20),
	email VARCHAR(40) UNIQUE NOT NULL,
	password VARCHAR(20),
	gender VARCHAR(20)
);

create table inventory_present_at(
	inventory_id INT PRIMARY KEY NOT NULL,
	mess_id INT NOT NULL,
    FOREIGN KEY (mess_id) REFERENCES mess(mess_id),
	quantity DECIMAL(10,3),
	type VARCHAR(20)
);

create table present_on(
	employee_id INT NOT NULL,
	date_slot_id INT NOT NULL,
    PRIMARY KEY (employee_id,date_slot_id),
    FOREIGN KEY (employee_id) REFERENCES employee_works(employee_id),
    FOREIGN KEY (date_slot_id) REFERENCES date_slot(date_slot_id)
);

create table mess_item(
	item_id INT PRIMARY KEY NOT NULL,
	item_name VARCHAR(20),
	price INT NOT NULL ,
	is_special VARCHAR(20),
	protein DECIMAL(5,3) ,
	calorie DECIMAL(5,3)
);

create table menu(
	item_id INT  NOT NULL,
	dayslot_id INT NOT NULL ,
    PRIMARY KEY (item_id,dayslot_id),
    FOREIGN KEY (item_id) REFERENCES mess_item(item_id),
    FOREIGN KEY (dayslot_id) REFERENCES day_slot(dayslot_id)
    
);


create table guest_sales_receives(
	invoice_id INT PRIMARY KEY NOT NULL,
	mess_id INT NOT NULL,
    FOREIGN KEY (mess_id) REFERENCES mess(mess_id),
	amount INT
);

create table invoice_items( 
	invoice_id INT  NOT NULL,
	item_id INT NOT NULL ,
    PRIMARY KEY (item_id,invoice_id),
    FOREIGN KEY (item_id) REFERENCES mess_item(item_id),
    FOREIGN KEY (invoice_id) REFERENCES guest_sales_receives(invoice_id),
	quantity DECIMAL(10,3)
);

create table buys_on(invoice_id INT NOT NULL ,
date_slot_id INT NOT NULL,
PRIMARY KEY (invoice_id,date_slot_id),
FOREIGN KEY (invoice_id) REFERENCES guest_sales_receives(invoice_id),
FOREIGN KEY (date_slot_id) REFERENCES date_slot(date_slot_id)
);


create table visits( roll_number INT NOT NULL ,
date_slot_id INT NOT NULL,
PRIMARY KEY (roll_number,date_slot_id),
FOREIGN KEY (roll_number) REFERENCES student_allocated(roll_number),
FOREIGN KEY (date_slot_id) REFERENCES date_slot(date_slot_id)
 );


create table student_represntative_coordinates(
position_id INT PRIMARY KEY NOT NULL,
roll_number INT NOT NULL,
FOREIGN KEY (roll_number) REFERENCES student_allocated(roll_number),
position VARCHAR (20),
tenure INT(2) DEFAULT 12 ,
start_date DATE
);


insert into mess values
(1,'jaiswal',3,4),
(2,'mohani',3,4),
(3,'hetchin',3,4);

-- select * from mess;

insert into mess_local_contact values
(9000437501,1),
(8347643212,2),
(7547643216,3);

insert into contractor_manages values
(1,1,'abc',01,'shivaji',1,'s1','GJ',382355),
(2,2,'def',02,'ratrani',2,'s2','GJ',382350),
(3,3,'ghi',03,'panchayat',3,'s3','GJ',382340);


insert into contractor_contact values
(7541211789,1),
(3546214891,2),
(9768215716,3);


insert into feedback_received  values 
(1,1,5,'good',LOAD_FILE('D:\\simple\\a1.jpg'),'S_N_1','2023-01-01','breakfast'),
(2,2,4,'normal',LOAD_FILE('D:\\simple\\a2.jpg'),'S_N_2','2023-01-01','lunch'),
(3,3,4,'not bad',LOAD_FILE('D:\\simple\\a3.jpg'),'S_N_3','2023-01-02','dinner');


insert into employee_works values
(1,1,'WN_1','W_SN_1','W_HN_1','W_C_1','W_S_1',382388,'manager','male','1995-01-01',10000,'W_EM_1@gmail.com','W_PASS_1'),
(2,1,'WN_2','W_SN_2','W_HN_2','W_C_2','W_S_2',382389,'chef','male','1995-02-01',7000,'W_EM_2@gmail.com','W_PASS_2'),
(3,1,'WN_3','W_SN_3','W_HN_3','W_C_3','W_S_3',382390,'worker','female','1995-03-01',6000,'W_EM_3@gmail.com','W_PASS_3'),
(4,2,'WN_4','W_SN_4','W_HN_4','W_C_4','W_S_4',382391,'manager','male','1995-04-01',10000,'W_EM_4@gmail.com','W_PASS_4'),
(5,2,'WN_5','W_SN_5','W_HN_5','W_C_5','W_S_5',382392,'chef','female','1995-05-01',7000,'W_EM_5@gmail.com','W_PASS_5'),
(6,2,'WN_6','W_SN_6','W_HN_6','W_C_6','W_S_6',382393,'worker','male','1995-06-01',6000,'W_EM_6@gmail.com','W_PASS_6'),
(7,3,'WN_7','W_SN_7','W_HN_7','W_C_7','W_S_7',382394,'manager','male','1995-07-01',10000,'W_EM_7@gmail.com','W_PASS_7'),
(8,3,'WN_8','W_SN_8','W_HN_8','W_C_8','W_S_8',382395,'chef','female','1995-08-01',7000,'W_EM_8@gmail.com','W_PASS_8'),
(9,3,'WN_9','W_SN_9','W_HN_9','W_C_9','W_S_9',382396,'worker','female','1995-09-01',6000,'W_EM_9@gmail.com','W_PASS_9');

-- select * from employee_works;

insert into employee_contact values
(9120367891,1),(9120367892,2),(9120367893,3),(9120367894,4),(9120367895,5),(9120367896,6),(9120367897,7),(9120367898,8),(9120367899,9);

-- select * from employee_contact;

insert into day_slot values
(1,'monday','breakfast'),(2,'monday','lunch'),(3,'monday','snacks'),(4,'monday','dinner'),
(5,'tuesday','breakfast'),(6,'tuesday','lunch'),(7,'tuesday','snacks'),(8,'tuesday','dinner');

-- select * from day_slot;

insert into operates_at values
(1,1,45),(1,2,65),(1,3,40),(1,4,70),(1,5,40),(1,6,70),(1,7,50),(1,8,80),
(2,1,45),(2,2,65),(2,3,40),(2,4,70),(2,5,40),(2,6,70),(2,7,50),(2,8,80),
(3,1,45),(3,2,65),(3,3,40),(3,4,70),(3,5,40),(3,6,70),(3,7,50),(3,8,80);

-- select * from operates_at;

-- drop table balance_sheet;
insert into balance_sheet values 
(1,1,1840,125,1534,5000,1000,'jan',2023),
(2,2,1840,145,1534,5000,1500,'jan',2023),
(3,3,1840,140,1534,5000,1000,'jan',2023);


-- select * from balance_sheet;

insert into date_slot values
(1,'2023-01-01','breakfast'),(2,'2023-01-01','lunch'),(3,'2023-01-01','snacks'),(4,'2023-01-01','dinner'),
(5,'2023-01-02','breakfast'),(6,'2023-01-02','lunch'),(7,'2023-01-1','snacks'),(8,'2023-01-1','dinner');

-- select * from date_slot;

insert into wastage values
(1,1,1.5),
(1,2,1.4),
(1,3,0.5),
(1,4,1.5),
(1,5,1.4),
(1,6,1.6),
(1,7,0.7),
(1,8,1.8),
(2, 1, 1.7),
(2, 2, 1.6),
(2, 3, 0.7),
(2, 4, 1.7),
(2, 5, 1.8),
(2, 6, 1.9),
(2, 7, 0.6),
(2, 8, 1.7),
(3,1,1.2),
(3,2,1.4),
(3,3,0.2),
(3,4,1.6),
(3,5,1.2),
(3,6,1.6),
(3,7,1.1),
(3,8,1.6);

-- select * from wastage;

insert into stock_contains values
(1,1,10,'2022-12-30','2023-04-30'),
(2,1,12,'2022-12-30','2023-04-30'),
(3,1,5,'2022-12-30','2023-04-30'),
(4,2,12,'2022-12-31','2023-03-30'),
(5,2,11,'2022-12-31','2023-03-30'),
(6,2,6,'2022-12-31','2023-03-30'),
(7,3,13,'2022-12-29','2023-05-30'),
(8,3,10,'2022-12-29','2023-05-30'),
(9,3,7,'2022-12-29','2023-05-30');

-- select * from stock_contains;

insert into student_allocated values
(19110100,1,'S_N_0','S_Em_0@gmail.com','S_passwd_0','male'),
(19110101,1,'S_N_1','S_Em_1@gmail.com','S_passwd_1','female'),
(19110102,1,'S_N_2','S_Em_2@gmail.com','S_passwd_2','male'),
(19110103,1,'S_N_3','S_Em_3@gmail.com','S_passwd_3','male'),
(19110104,2,'S_N_4','S_Em_4@gmail.com','S_passwd_4','male'),
(19110105,2,'S_N_5','S_Em_5@gmail.com','S_passwd_5','female'),
(19110106,2,'S_N_6','S_Em_6@gmail.com','S_passwd_6','male'),
(19110107,2,'S_N_7','S_Em_7@gmail.com','S_passwd_7','male'),
(19110108,3,'S_N_8','S_Em_8@gmail.com','S_passwd_8','female'),
(19110109,3,'S_N_9','S_Em_9@gmail.com','S_passwd_9','female'),
(19110110,3,'S_N_10','S_Em_10@gmail.com','S_passwd_10','male'),
(19110111,3,'S_N_11','S_Em_11@gmail.com','S_passwd_11','male');

-- select * from student_allocated;

insert into inventory_present_at values
(1,1,20,'chairs'),
(2,1,15,'tables'),
(3,1,10,'utensils'),
('4',2,22,'chairs'),
('5',2,17,'tables'),
('6',2,8,'utensils'),
('7',3,19,'chairs'),
('8',3,17,'tables'),
('9',3,12,'utensils');

-- select * from inventory_present_at;

insert into present_on values
(1,1),(1,3),(1,5),(1,7),(2,2),(2,4),(2,6),(2,8),(3,2),(3,3),(3,4),(3,5),(4,1),(4,3),(4,5),(4,7),(5,2),(5,4),
(5,6),(5,8),(6,2),(6,3),(6,4),(6,5),(7,1),(7,3),(7,5),(7,7),(8,2),(8,4),(8,6),(8,8),(9,2),(9,3),(9,4),(9,5);

-- select * from present_on;

insert into mess_item values
(1,'IN_1',20,'False',34,90),
(2,'IN_2',10,'False',28,80),
(3,'IN_3',30,'True',12,99),
(4,'IN_4',15,'False',16,60);


-- select * from mess_item;

insert into menu values 
(1,1),(2,1),(4,1),
(2,2),(3,2),(4,2),
(1,3),(4,3),
(1,4),(3,4),(4,4),
(2,5),(4,5),
(3,6),(4,6),
(1,7),(3,7),(4,7),
(1,8),(2,8),(3,8),(4,8);

-- select * from menu;

insert into guest_sales_receives values
(1,1,40),(2,1,15),(3,1,10),(4,1,60),
(5,2,40),(6,2,45),(7,2,30),(8,2,30),
(9,3,40),(10,3,30),(11,3,10),(12,3,60);

-- select * from guest_sales_receives;

insert into invoice_items values
(1,1,2),(2,2,4),(3,2,1),(4,3,2),(5,1,2),(6,4,3),(7,3,1),(8,4,2),(9,1,2),(10,4,2),(11,2,1),(12,3,2);

-- select * from invoice_items;

insert into buys_on values
(1,1),(2,1),(3,2),(4,2),(4,3),(5,3),(5,4),(6,4),(6,5),(7,5),(7,6),(8,6),(9,7),(10,7),(11,8),(12,8);

-- select * from buys_on;

insert into visits values
(19110100,1),(19110100,2),(19110100,3),(19110100,4),(19110100,5),(19110100,6),(19110100,7),
(19110101,1),(19110101,3),(19110101,4),(19110101,7),(19110101,8),
(19110102,2),(19110102,3),(19110102,4),(19110102,5),
(19110103,4),(19110103,5),(19110103,6),(19110103,7),(19110103,8),
(19110104,1),(19110104,3),(19110104,6),(19110104,7),(19110104,8),
(19110105,2),(19110105,4),(19110105,5),(19110105,8),
(19110106,2),(19110106,3),(19110106,4),(19110106,5),
(19110107,5),(19110107,6),(19110107,7),(19110107,8),
(19110108,4),(19110108,5),(19110108,6),(19110108,7),
(19110109,2),(19110109,3),(19110109,4),(19110109,5),
(19110110,3),(19110110,4),(19110110,5),(19110110,6),
(19110111,1),(19110111,2),(19110111,3),(19110111,4),(19110111,5),(19110111,6);

-- select * from visits;

insert into student_represntative_coordinates values
(1,19110101,'food',06,'2023-01-01'),
(2,19110102,'manage',06,'2023-01-01'),
(3,19110103,'finance',06,'2023-01-01'),
(4,19110104,'hygiene',06,'2023-01-01');



CREATE UNIQUE INDEX id_desig ON employee_works(employee_id, designation);

CREATE UNIQUE INDEX rollno ON student_allocated(mess_id, roll_number);

CREATE INDEX dateidx ON date_slot(date);

CREATE UNIQUE INDEX itemn ON mess_item(item_name);

CREATE INDEX productnexp ON stock_contains(mess_id, expiry);

CREATE UNIQUE INDEX saleid ON guest_sales_receives(invoice_id);

CREATE INDEX permonth ON balance_sheet(month, year);

CREATE UNIQUE INDEX feed_id ON feedback_received(feedback_id, star_rating);

CREATE UNIQUE INDEX waste ON wastage(mess_id, date_slot_id);

create table mess_1_sales as (select * from guest_sales_receives where mess_id = 1);

create table mess_2_sales as (select * from guest_sales_receives where mess_id = 2);

create table mess_3_sales as (select * from guest_sales_receives where mess_id = 3);



select * from employee_works;
ALTER TABLE employee_works ADD COLUMN location JSON;

UPDATE employee_works SET location = JSON_OBJECT(
    'street_name', street_name,
    'house_no', house_no,
    'city', city,
    'state', state,
    'pin_code', pincode
);

ALTER TABLE employee_works DROP COLUMN street_name, DROP COLUMN house_no, DROP COLUMN city, DROP COLUMN state, DROP COLUMN pincode;
select * from employee_works;



ALTER TABLE contractor_manages ADD COLUMN location JSON;

UPDATE contractor_manages SET location = JSON_OBJECT(
    'hq_street_name', hq_street_name,
    'hq_street_number', hq_street_number,
    'hq_office_number', hq_office_number,
    'city', hq_city,
    'state', hq_state,
    'pin_code', hq_pincode
);

ALTER TABLE contractor_manages DROP COLUMN hq_street_name, DROP COLUMN hq_office_number, DROP COLUMN hq_street_number, DROP COLUMN hq_city, DROP COLUMN hq_state, DROP COLUMN hq_pincode;


create table mess_1_sales as (select * from guest_sales_receives where mess_id = 1);

create table mess_2_sales as (select * from guest_sales_receives where mess_id = 2);

create table mess_3_sales as (select * from guest_sales_receives where mess_id = 3);




create USER 'user1'@'localhost' IDENTIFIED by 'password1';
use mess_management;
select * from contractor_manages;
CREATE VIEW view1 AS SELECT contractor_name, location, hq_contact_number  FROM contractor_manages 
AS cm INNER JOIN contractor_contact AS cc ON cm.contractor_id = cc.contractor_id;

CREATE VIEW view2 AS SELECT contact_number, location, name  FROM  employee_works 
INNER JOIN employee_contact ON employee_works.employee_id = employee_contact.employee_id;

GRANT UPDATE, DELETE, SELECT on mess_managament.student_allocated TO 'user1'@'localhost';
SHOW GRANTS FOR 'user1'@'localhost';
GRANT SELECT on mess_managament.view1 to 'user1'@'localhost';

-- change user to  user1;
select mess_id,count(*) as number_student from student_allocated GROUP BY mess_id;
UPDATE student_allocated SET mess_id=1 where roll_number=19110106;
SELECT * from student_allocated;
DELETE from student_allocated WHERE roll_number=19110110;

SELECT * FROM visits;
SELECT * from student_represntative_coordinates;
SELECT * from view1;
UPDATE view1 set contractor_name='mohini_contra' WHERE hq_contact_number=7541211789;
DELETE from view1 WHERE contractor_name='abc';
REVOKE UPDATE, DELETE ON student_allocated from 'user1'@'localhost';

select mess_id,count(*) as number_student from student_allocated GROUP BY mess_id;
UPDATE student_allocated SET mess_id=1 where roll_number=19110106;
SELECT * from student_allocated;
DELETE from student_allocated WHERE roll_number=19110110;

SELECT * FROM visits;
SELECT * from student_represntative_coordinates;
SELECT * from view1;
UPDATE view1 set contractor_name='mohini_contra' WHERE hq_contact_number=7541211789;
DELETE from view1 WHERE contractor_name='abc';


