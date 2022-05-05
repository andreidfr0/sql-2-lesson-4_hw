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