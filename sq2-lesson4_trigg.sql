INSERT INTO employees 
(emp_no, birth_date, first_name, last_name, gender, hire_date)
SELECT @id:=(max(emp_no)+1), '1990-01-01', 'Ivan', 'Ivanov', 'M', current_date() FROM employees
-- SELECT max(emp_no)+1, '1990-01-01', 'Ivan', 'Ivanov', 'M', current_date() FROM employees
; 

-- DELETE !
delete from employees
where 
emp_no = 500000
and first_name = 'Ivan'
;

-- after 
-- триггер на поступление/insert в employees/ 
-- авто pay in salaries/ bonus=1345
drop trigger if exists pay_bonus_employees;
-- simple log trigger 
delimiter $$
create trigger pay_bonus_employees
 after insert on employees
 for each row
 BEGIN
 declare bonus int default 1345;
 -- set emp_id = @id;
 insert into salaries SET
 emp_no = @id,
 salary = bonus,
 from_date = CURRENT_DATE(),
 to_date = '9999-01-01';
 end;
$$
delimiter ;

-- select debug 
select ((SELECT max(emp_no) FROM employees  LIMIT 1)+1);
SELECT max(emp_no) FROM employees  LIMIT 1;
SELECT * FROM employees ORDER BY emp_no desc LIMIT 2;
SELECT * FROM log_employees;
select * from salaries order by emp_no desc limit 2;
select @id:=(max(emp_no)+1) from employees;
select @id;
;
-- end debug


drop trigger if exists log_ins_employees;
-- simple log trigger 
delimiter $$
create trigger log_ins_employees
 after insert on employees
 for each row
 insert into log_employees Set
 time_stamp = CURRENT_TIMESTAMP(),
 emp_no=NEW.emp_no,
 birth_date = NEW.birth_date,
 first_name = NEW.first_name,
 last_name = NEW.last_name,
 gender = NEW.gender,
 hire_date = NEW.hire_date,
 log_v = 'i';
$$
delimiter ;

drop trigger if exists log_del_employees;
-- simple log trigger 
delimiter $$
create trigger log_del_employees
 after delete on employees
 for each row
 insert into log_employees Set
 time_stamp = CURRENT_TIMESTAMP(),
 emp_no=OLD.emp_no,
 birth_date = OLD.birth_date,
 first_name = OLD.first_name,
 last_name = OLD.last_name,
 gender = OLD.gender,
 hire_date = OLD.hire_date,
 log_v = 'D';
$$
delimiter ;

drop table if exists log_employees;
-- таблица для хранения измененных строк in employees
CREATE TABLE `log_employees` (
  `id` int primary key auto_increment not null,
  `time_stamp` datetime not null,
  `emp_no` int NOT NULL,
  `birth_date` date NOT NULL,
  `first_name` varchar(14) NOT NULL,
  `last_name` varchar(16) NOT NULL,
  `gender` enum('M','F') NOT NULL,
  `hire_date` date NOT NULL,
   `log_v` enum('U', 'D', 'I') not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

