-- Урок 4. Объединение запросов, хранимые процедуры, триггеры, функции
--

-- 1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.
--
-- -----------------------------------------------------
-- View `employees`.`count_employees`
-- -----------------------------------------------------
USE `employees`;
CREATE OR REPLACE 
VIEW `employees`.`count_employees` AS
    SELECT 
        COUNT(0) AS `count_employee`
    FROM
        `employees`.`employees`;

-- -----------------------------------------------------
-- View `employees`.`departm_empl_finans`
-- -----------------------------------------------------
USE `employees`;
CREATE OR REPLACE 
VIEW `employees`.`departm_empl_finans` AS
    SELECT 
        SUM(`sl`.`salary`) AS `sum_salary`,
        `dp`.`dept_name` AS `department_name`,
        COUNT(`emp`.`emp_no`) AS `count_employees`
    FROM
        (`employees`.`departments` `dp`
        LEFT JOIN ((`employees`.`salaries` `sl`
        LEFT JOIN `employees`.`employees` `emp` ON ((`sl`.`emp_no` = `emp`.`emp_no`)))
        JOIN `employees`.`dept_emp` `dept_` ON ((`emp`.`emp_no` = `dept_`.`emp_no`))) ON ((`dp`.`dept_no` = `dept_`.`dept_no`)))
    GROUP BY `department_name`
    ORDER BY `sum_salary` DESC;

-- -----------------------------------------------------
-- View `employees`.`get_average_salary`
-- -----------------------------------------------------
USE `employees`;
CREATE OR REPLACE 
VIEW `employees`.`get_average_salary` AS
    SELECT 
        AVG(`sl`.`salary`) AS `average_salary`,
        `dp`.`dept_name` AS `department_name`
    FROM
        (`employees`.`departments` `dp`
        LEFT JOIN ((`employees`.`salaries` `sl`
        LEFT JOIN `employees`.`employees` `emp` ON ((`sl`.`emp_no` = `emp`.`emp_no`)))
        JOIN `employees`.`dept_emp` `dept_` ON ((`emp`.`emp_no` = `dept_`.`emp_no`))) ON ((`dp`.`dept_no` = `dept_`.`dept_no`)))
    GROUP BY `department_name`
    ORDER BY `average_salary` DESC;

-- -----------------------------------------------------
-- View `employees`.`get_max_salary`
-- -----------------------------------------------------
USE `employees`;
CREATE OR REPLACE 
VIEW `employees`.`get_max_salary` AS
    SELECT 
        MAX(`sl`.`salary`) AS `max_salary`,
        CONCAT(`emp`.`first_name`,
                '  ',
                `emp`.`last_name`) AS `EMPLOYEE_full_NAME`
    FROM
        (`employees`.`salaries` `sl`
        LEFT JOIN `employees`.`employees` `emp` ON ((`emp`.`emp_no` = `sl`.`emp_no`)))
    GROUP BY `EMPLOYEE_full_NAME`
    ORDER BY `max_salary` DESC;
USE `geodata` ;


-- -----------------------------------------------------
-- View `geodata`.`city_region_country`
-- -----------------------------------------------------
USE `geodata`;
CREATE OR REPLACE 
VIEW `geodata`.`city_region_country` AS
    SELECT 
        `ci`.`id` AS `ID`,
        `ci`.`country_id` AS `country ID`,
        `ci`.`region_id` AS `region ID`,
        `ci`.`important` AS `is capital`,
        `ci`.`title` AS `city`,
        `co`.`title` AS `country`,
        `re`.`title` AS `region`
    FROM
        ((`geodata`.`_cities` `ci`
        LEFT JOIN `geodata`.`_countries` `co` ON ((`ci`.`country_id` = `co`.`id`)))
        LEFT JOIN `geodata`.`_regions` `re` ON ((`ci`.`region_id` = `re`.`id`)));

-- -----------------------------------------------------
-- View `geodata`.`find_city_in_moskou_region`
-- -----------------------------------------------------
USE `geodata`;
CREATE OR REPLACE 
VIEW `geodata`.`find_city_in_moskou_region` AS
    SELECT 
        `ci`.`id` AS `id`,
        `ci`.`country_id` AS `country_id`,
        `ci`.`important` AS `important`,
        `ci`.`region_id` AS `region_id`,
        `ci`.`title` AS `title`,
        `re`.`title` AS `region`
    FROM
        (`geodata`.`_cities` `ci`
        LEFT JOIN `geodata`.`_regions` `re` ON ((`ci`.`region_id` = `re`.`id`)))
    WHERE
        (`re`.`title` LIKE 'московская%');

-- ------------------------------------------------------------

-- 2. Создать функцию, которая найдет менеджера по имени и фамилии.
--
-- test
select
e.*,
de.emp_no as 'depart_number'
from employees e
left join dept_manager de on de.emp_no = e.emp_no
where de.emp_no = get_mngr_name('Arie', 'Staelin')
;

--
DROP function IF EXISTS `employees`.`get_mngr_name`;
--
CREATE FUNCTION `get_mngr_name`(f_name varchar(20), l_name varchar(20)) RETURNS varchar(100) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
    COMMENT '-- Создать функцию, которая найдет менеджера по имени и фамилии '
begin
declare result varchar(100);
select
	 de.emp_no into result
from
     employees e
     left join dept_manager de on de.emp_no = e.emp_no
where
     e.first_name = f_name
     and
     e.last_name = l_name
     ;
RETURN (result);
end


-- 3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус, занося запись об этом в таблицу salary.
--
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
