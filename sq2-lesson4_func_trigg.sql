-- simple procedure
drop procedure if exists sim_test;
delimiter //
CREATE  PROCEDURE `sim_test` (OUT param1 int)
BEGIN
select count(*) into param1 from departments;
END
//
-- end simple procedure

delimiter ;
-- test
set @param1 =0;
call employees.sim_test(@param1);
select @param1;
-- test simple procedure

-- поиск финансирования отделов
-- после даты 2000-01-01
select
   dept.dept_name,
   Count(d.emp_no) as counts,
   sum(sal.salary) as budget
from departments dept
   join dept_emp d on dept.dept_no = d.dept_no
        and date(d.to_date) > '2022-01-01'
   join salaries sal on d.emp_no = sal.emp_no
        and date(sal.emp_no) > '2022-01-01'
group by dept.dept_no
order by dept.dept_name
;
   

-- кон.поиск финансирования отделов

-- find_fin procedure
drop procedure if exists budget_dept;
delimiter //
CREATE  PROCEDURE `budget_dept` (OUT param1 int, dept varchar(100))
BEGIN
select
--   dept.dept_name,
--   Count(d.emp_no) as counts,
   sum(sal.salary) into param1
from departments dept
   join dept_emp d on dept.dept_no = d.dept_no
        and date(d.to_date) > '2022-01-01'
   join salaries sal on d.emp_no = sal.emp_no
        and date(sal.emp_no) > '2022-01-01'
where dept.dept_name = dept
group by dept.dept_no
-- order by dept.dept_name
;
END
//

delimiter ;
-- test
select * from departments;

-- set @param1 =0;
call employees.budget_dept(@param1, 'Customer Service');
select @param1;
-- test budget dept procedure