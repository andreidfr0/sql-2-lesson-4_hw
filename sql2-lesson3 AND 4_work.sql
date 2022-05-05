-- Практическое задание
--  1. База данных «Страны и города мира»:
--   1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
--   2. Выбрать все города из Московской области.
--  2. База данных «Сотрудники»:
--   1. Выбрать среднюю зарплату по отделам.
--   2. Выбрать максимальную зарплату у сотрудника.
--   3. Удалить одного сотрудника, у которого максимальная зарплата.
--   4. Посчитать количество сотрудников во всех отделах.
--   5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.

use geodata
;
-- 1.1 Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
select
 ci.id AS 'ID',
 ci.country_id AS 'country ID',
 ci.region_id AS 'region ID',
 ci.important AS ' is capital',
 ci.title AS city,
 co.title AS country,
 re.title AS region
from _cities ci
	left join _countries co ON ci.country_id = co.id
    left join _regions re ON ci.region_id = re.id
;

-- 1.2 Выбрать все города из Московской области.
select
 ci.*,
 re.title AS region
from _cities ci
    left join _regions re
        ON ci.region_id = re.id
where
	re.title like 'московская%'   
;
-- или так
select 	*
from _cities
where region_id =
		(
		select id
		from _regions
		where title like 'московская%'
            )
-- into outfile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/out.log'
;
-- или так
select 	*
from _cities
where exists
		(
		select id
		from _regions
		where id = _cities.region_id and title like 'москов%'
            )
-- into outfile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/out3.log'           
;

use employees
;
-- 2.1 Выбрать среднюю зарплату по отделам.

select 
	avg(sl.salary) as average_salary,
    dp.dept_name as department_name
from salaries sl
	left join employees emp on sl.emp_no = emp.emp_no
	inner join dept_emp dept_ on emp.emp_no = dept_.emp_no 
    right join departments dp on dp.dept_no = dept_.dept_no
group by department_name
order by average_salary desc
;

-- 2.2 Выбрать максимальную зарплату у сотрудника.
select 
	max(sl.salary) as max_salary,
    CONCAT(COALESCE(emp.FIRST_NAME,''),' ',COALESCE(emp.LAST_NAME,'')) as EMPLOYEE_full_NAME
from salaries sl
	left join employees emp on emp.emp_no = sl.emp_no 
group by EMPLOYEE_full_NAME
order by max_salary desc
;

-- 2.3 Удалить одного сотрудника, у которого максимальная зарплата.
delete from employees
where emp_no = (
	select emp_no
	from salaries
    order by salary desc
    limit 1
    )
;

-- 2.4 Посчитать количество сотрудников во всех отделах.
SELECT 
  COUNT(DISTINCT EMP_NO)
FROM DEPT_EMP;
-- или 
select count(*) from employees;

-- количество струдников в каждом отделе
select 
	count(emp.emp_no) as counts,
    dp.dept_name as department_name
from employees emp
	left join dept_emp dept_ on emp.emp_no = dept_.emp_no 
    right join departments dp on dp.dept_no = dept_.dept_no
group by department_name
order by counts desc
-- -- сотрудник может работать в нескольких отделах
; 

-- 2.5 Найти количество сотрудников в отделах и 
--	   посмотреть, сколько всего денег получает отдел.
select 
	sum(sl.salary) as sum_salary,
    dp.dept_name as department_name,
    count(emp.emp_no) as count_employees
from salaries sl
	left join employees emp on sl.emp_no = emp.emp_no
	 join dept_emp dept_ on emp.emp_no = dept_.emp_no 
    right join departments dp on dp.dept_no = dept_.dept_no
group by department_name
order by sum_salary desc
-- -- сотрудник может работать в нескольких отделах
;