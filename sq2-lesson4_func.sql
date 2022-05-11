-- create function
-- Создать функцию, которая найдет менеджера по имени и фамилии см. внизу
-- 01.08.34 l4--

USE employees;
-- DROP function IF EXISTS to_upper;

-- DELIMITER $$
-- USE `employees`$$
-- CREATE FUNCTION to_upper (to_upp varchar (100)) RETURNS varchar(100)
-- deterministic
-- begin
-- declare result varchar(100);
-- set result = upper(to_upp);
-- RETURN (result);
-- end
-- -- 01.08.34 l4--$$

-- DELIMITER ;
select  to_upper('test');
-- test func to_upper
-- select name from mysql.proc where type='function';
-- SHOW FUNCTION STATUS;
SELECT * FROM INFORMATION_SCHEMA.ROUTINES;
-- работaeт -- хочу получить список всех сохраненных пользователем функций
select dept_name, to_upper(dept_name) from departments;
--

-- Создать функцию, которая найдет менеджера по имени и фамилии
-- 
-- v.0.1 start
-- CREATE FUNCTION get_mngr_name (f_name varchar(20), l_name varchar(20))
-- RETURNS varchar(100)
-- deterministic
-- READS SQL DATA
-- begin
-- declare result varchar(100);
-- select
-- 	 dep.emp_no into result
-- from
--      employees emp, dept_manager dep
-- where 
--      emp.first_name = f_name
--      and emp.last_name = l_name
--      and emp.emp_no = dep.emp_no
--      ;
-- RETURN (result);
-- end
-- v.0.1 end

-- v.1.0
-- CREATE DEFINER=`serdi`@`%` FUNCTION `get_mngr_name`(f_name varchar(20), l_name varchar(20)) RETURNS varchar(100) CHARSET utf8mb4
--     READS SQL DATA
--     DETERMINISTIC
--     COMMENT '-- Создать функцию, которая найдет менеджера по имени и фамилии '
-- begin
-- declare result varchar(100);
-- select
-- 	 e.emp_no into result
-- from
--      employees e
--       
--      left join dept_manager de on de.emp_no = e.emp_no
-- where 
--      e.first_name = f_name
--      and
--      e.last_name = l_name
--      ;
-- RETURN (result);
-- end
-- end v.1.0 -- это работает 


select 
e.*,
de.emp_no as 'depart_number'
from employees e
left join dept_manager de on de.emp_no = e.emp_no
where de.emp_no = get_mngr_name('Arie', 'Staelin')
;

select get_mngr_name('Arie', 'Staelin') as result;

SELECT DATABASE(); -- return string default db_name

select * from employees e
inner join dept_manager dept on e.emp_no = dept.emp_no;