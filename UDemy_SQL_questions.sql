#DB overview
#find list of tables in database 
SHOW TABLES;
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES;
#find list of columns in database
DESC employees;
SELECT * FROM employees; 
SELECT table_name, column_name FROM information_schema.columns;
SELECT column_name FROM information_schema.columns WHERE table_name = 'employees';


SELECT dept_no FROM departments;
SELECT * FROM departments;

SELECT * FROM employees WHERE first_name = 'Elvis';

SELECT * FROM employees WHERE first_name = 'Kellie' AND gender = 'F';

SELECT * FROM employees WHERE first_name = 'Kellie' OR first_name = 'Aruna';

SELECT * FROM employees WHERE gender = 'F' AND (first_name = 'Kellie'OR first_name = 'Aruna'); 
    
SELECT * FROM employees WHERE first_name IN ('Denis', 'Elvis');

SELECT * FROM employees WHERE first_name NOT IN ('John', 'Mark', 'Jacob');

SELECT * FROM employees WHERE first_name LIKE ('Mark%');
SELECT * FROM employees WHERE hire_date LIKE ('%2000%');
SELECT * FROM employees WHERE emp_no LIKE ('1000_');

SELECT * FROM employees WHERE first_name LIKE ('%jack%');
SELECT * FROM employees WHERE first_name NOT LIKE ('%jack%');

DESC salaries;
SELECT * FROM salaries WHERE salary BETWEEN '66000' AND '70000';
SELECT * FROM employees WHERE emp_no NOT BETWEEN '10004' AND '10012';
DESC departments;
SELECT dept_name FROM departments WHERE dept_no BETWEEN 'd003' AND 'd006';

SELECT dept_name FROM departments WHERE dept_no IS NOT NULL;

DESC employees;
#could also use hire_date >= '2000-01-01'
SELECT * FROM employees WHERE gender = 'F' AND hire_date >= '2000-01-01';
DESC salaries;
SELECT * FROM salaries WHERE salary > 150000;

DESC employees;
SELECT DISTINCT hire_date FROM employees; 

SELECT COUNT(salary) FROM salaries WHERE salary >= 100000;
SHOW TABLES;
DESC dept_manager;
#can use either emp_no or just count all from dept_manager
SELECT COUNT(DISTINCT emp_no) FROM dept_manager;
SELECT COUNT(*) FROM dept_manager; 

DESC employees;
SELECT * FROM employees ORDER BY hire_date DESC;

DESC salaries;
SELECT salary, COUNT(emp_no) AS emps_with_same_salary FROM salaries WHERE salary >  80000 GROUP BY salary ORDER BY salary ASC; 

DESC salaries;
#dont need to order by secondary column becuase we are already grouping by emp_no 
SELECT emp_no, AVG(salary) FROM salaries GROUP BY emp_no HAVING AVG(salary) > 120000 ORDER BY emp_no;
#will end up with higher avg salaries than previous query because we are only using individual records >= 120000 to calculate avg salary
SELECT *, AVG(salary) FROM salaries WHERE salary > 120000 GROUP BY emp_no ORDER BY emp_no;

DESC dept_emp;
SELECT * FROM dept_emp;
SELECT emp_no, COUNT(emp_no) AS number_of_contracts FROM dept_emp WHERE from_date > '2000-01-01' GROUP BY emp_no HAVING COUNT(emp_no) > 1;

SELECT * FROM dept_emp LIMIT 100;

SELECT * FROM dept_emp LIMIT 10;
SELECT COUNT(DISTINCT dept_no) FROM dept_emp;

SELECT * FROM salaries LIMIT 10;
SELECT SUM(salary) FROM salaries WHERE from_date > '1997-01-01';

SELECT * FROM employees LIMIT 10; 
SELECT MAX(emp_no) FROM employees; 
SELECT MIN(emp_no) FROM employees; 

SELECT AVG(salary) FROM salaries WHERE from_date > '1997-01-01';

SELECT ROUND(AVG(salary),2) FROM salaries WHERE from_date > '1997-01-01';

DROP TABLE IF EXISTS departments_dup;
CREATE TABLE departments_dup
(
dept_no CHAR(4) NULL,
dept_name VARCHAR(40) NULL
);

INSERT INTO departments_dup
(
dept_no,
dept_name
)SELECT
	*
FROM
	departments;

INSERT INTO departments_dup (dept_name)
VALUES ('Public Relations');

SET SQL_SAFE_UPDATES = 0;
DELETE FROM departments_dup
WHERE
    dept_no = 'd002'; 

INSERT INTO departments_dup(dept_no) VALUES ('d010'), ('d011');

DROP TABLE IF EXISTS dept_manager_dup;

CREATE TABLE dept_manager_dup (
  emp_no int(11) NOT NULL,
  dept_no char(4) NULL,
  from_date date NOT NULL,
  to_date date NULL
  );

INSERT INTO dept_manager_dup
select * from dept_manager; 

INSERT INTO dept_manager_dup (emp_no, from_date)

VALUES (999904, '2017-01-01'),
(999905, '2017-01-01'),
(999906, '2017-01-01'),
(999907, '2017-01-01');

DELETE FROM dept_manager_dup
WHERE
	dept_no = 'd001';
    
SET SQL_SAFE_UPDATES = 1;

SELECT dm.dept_no, dm.emp_no, dm.from_date, e.first_name
FROM dept_manager dm
INNER JOIN employees e ON dm.emp_no = e.emp_no
ORDER BY dm.emp_no;

SELECT e.emp_no, e.first_name, e.Last_name, dm.dept_no, dm.from_date
FROM employees e 
LEFT JOIN dept_manager dm ON e.emp_no = dm.emp_no
WHERE e.last_name = 'Markovich'
ORDER BY dm.dept_no DESC, dm.emp_no;

SELECT dm.emp_no, dm.dept_no, e.first_name, e.last_name, e.hire_date
FROM dept_manager dm, employees e
WHERE dm.emp_no = e.emp_no;

SELECT dm.emp_no, dm.dept_no, e.first_name, e.last_name, e.hire_date
FROM dept_manager dm 
JOIN employees e ON dm.emp_no = e.emp_no;

select @@global.sql_mode;
set @@global.sql_mode := replace(@@global.sql_mode, 'ONLY_FULL_GROUP_BY', '');

SELECT e.emp_no, e.first_name, e.last_name, e.hire_date, t.title
FROM employees e JOIN titles t
ON e.emp_no = t.emp_no 
WHERE e.first_name = 'Margareta' AND e.last_name = 'Markovich'
ORDER BY e.emp_no;

SELECT dm.*, d.*
FROM dept_manager dm CROSS JOIN departments d
WHERE dm.dept_no = '009'
ORDER BY dm.emp_no;

SELECT e.*, de.*
FROM employees e CROSS JOIN dept_emp de
WHERE e.emp_no <= '10010'
GROUP BY e.emp_no 
ORDER BY e.emp_no;

SELECT e.first_name, e.last_name, e.hire_date, t.title, dm.from_date, d.dept_name 
FROM employees e JOIN titles t ON e.emp_no = t.emp_no 
JOIN dept_manager dm ON t.from_date = dm.from_date
JOIN departments d ON dm.dept_no = d.dept_no
WHERE t.title = 'Manager'
ORDER BY e.emp_no;
#OR
SELECT e.first_name, e.last_name, e.hire_date, t.title, dm.from_date, d.dept_name 
FROM employees e JOIN titles t ON e.emp_no = t.emp_no 
JOIN dept_manager dm ON t.from_date = dm.from_date AND e.emp_no = dm.emp_no 
JOIN departments d ON dm.dept_no = d.dept_no 
ORDER BY e.emp_no;

SELECT e.gender, COUNT(e.emp_no) AS employee_count 
FROM employees e JOIN dept_manager dm ON e.emp_no = dm.emp_no 
GROUP BY e.gender; 

SELECT 
    *
FROM
    (SELECT 
        e.emp_no,
            e.first_name,
            e.last_name,
            NULL AS dept_no,
            NULL AS from_date
    FROM
        employees e
    WHERE
        last_name = 'Denis' UNION SELECT 
        NULL AS emp_no,
            NULL AS first_name,
            NULL AS last_name,
            dm.dept_no,
            dm.from_date
    FROM
        dept_manager dm) AS a
ORDER BY -a.emp_no DESC;

SELECT * FROM dept_manager dm WHERE dm.emp_no IN (SELECT e.emp_no FROM employees e WHERE e.hire_date BETWEEN '1990-01-01' AND '1995-01-01');
SELECT * FROM employees e WHERE EXISTS (SELECT t.title FROM titles t WHERE t.emp_no = e.emp_no AND t.title = 'Assistant Engineer'); 

DROP TABLE IF EXISTS emp_manager;
CREATE TABLE emp_manager (
   emp_no INT(11) NOT NULL,
   dept_no CHAR(4) NULL,
   manager_no INT(11) NOT NULL
);

INSERT INTO emp_manager
SELECT 
	U.*
FROM 
	(SELECT 
		A.* 
	FROM 
		(SELECT 
		e.emp_no AS employee_ID, 
			MIN(de.dept_no) AS department_code, 
			(SELECT 
					emp_no 
				FROM 
					dept_manager 
				WHERE 
					emp_no = 110022) AS manager_ID 
	FROM 
		employees e 
	JOIN dept_emp de ON e.emp_no = de.emp_no 
	WHERE 
		e.emp_no <= 10020 
	GROUP BY e.emp_no 
	ORDER BY e.emp_no) AS A UNION SELECT 
		B.* 
	FROM
		(SELECT 
		e.emp_no AS employee_ID, 
			MIN(de.dept_no) AS department_code, 
			(SELECT 
					emp_no 
				FROM 
					dept_manager 
				WHERE 
					emp_no = 110039) AS manager_ID 
	FROM 
		employees e 
	JOIN dept_emp de ON e.emp_no = de.emp_no 
	WHERE 
		e.emp_no > 10020 
	GROUP BY e.emp_no 
	ORDER BY e.emp_no 
	LIMIT 20) AS B UNION SELECT 
		C.* 
	FROM 
		(SELECT 
		e.emp_no AS employee_ID, 
			MIN(de.dept_no) AS department_code, 
			(SELECT 
					emp_no 
				FROM 
					dept_manager 
				WHERE 
					emp_no = 110039) AS manager_ID 
	FROM 
		employees e 
	JOIN dept_emp de ON e.emp_no = de.emp_no 
	WHERE 
		e.emp_no = 110022) AS C UNION SELECT 
		D.* 
	FROM 
		(SELECT 
		e.emp_no AS employee_ID, 
			MIN(de.dept_no) AS department_code, 
			(SELECT 
					emp_no 
				FROM 
					dept_manager 
				WHERE 
						emp_no = 110022) AS manager_ID 
	FROM 
		employees e 
	JOIN dept_emp de ON e.emp_no = de.emp_no 
	WHERE 
		e.emp_no = 110039) AS D) AS U;

USE employees 
DROP PROCEDURE IF EXISTS 
DELIMITER $$
CREATE PROCEDURE avg_salary() 
BEGIN 
	SELECT 
		AVG(salary) 
	FROM 
		salaries; 
END $$ 
DELIMITER ; 

CALL employees.avg_salary();
# or can specify what database to use 
USE employees; 
CALL avg_salary();

USE employees; 
DROP PROCEDURE IF EXISTS employee_num; 
DELIMITER $$
CREATE PROCEDURE employee_num(IN p_first_name VARCHAR(255), IN p_last_name VARCHAR(255), OUT p_employee_num INTEGER)
BEGIN 
	SELECT e.emp_no 
    INTO p_employee_num
    FROM employees e 
    WHERE p_first_name = e.first_name AND p_last_name = e.last_name
    LIMIT 1; 
END $$
DELIMITER ;

SELECT * FROM employees LIMIT 1;

SET @v_emp_no = 0; 
CALL employees.employee_num('Aruna', 'Journel', @v_emp_no); 
SELECT @v_emp_no; 

#do SELECT statement for v_max_from_date before v_salary because v_salary needs v_max_from_date in WHERE clause

DELIMITER $$
CREATE FUNCTION f_emp_info(p_first_name VARCHAR(14), p_last_name VARCHAR(16)) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN 
	DECLARE v_max_from_date DATE;
	DECLARE v_salary DECIMAL(10,2);
SELECT MAX(from_date)
INTO v_max_from_date 
FROM salaries s 
	JOIN employees e ON s.emp_no = e.emp_no
WHERE p_first_name = e.first_name AND p_last_name = e.last_name;
SELECT s.salary 
INTO v_salary 
FROM salaries s 
	JOIN employees e ON s.emp_no = e.emp_no 
WHERE p_first_name = e.first_name AND p_last_name = e.last_name AND s.from_date = v_max_from_date;
RETURN v_salary;
END $$ 
DELIMITER ; 

SELECT e.emp_no, e.first_name, e.last_name, 
CASE 
	WHEN dm.emp_no IS NOT NULL THEN 'manager'
    ELSE 'employee'  
END AS is_manager
FROM employees e LEFT JOIN dept_manager dm ON e.emp_no = dm.emp_no
WHERE e.emp_no > 109990;

SELECT e.emp_no, e.first_name, e.last_name, (MAX(s.salary) - MIN(s.salary)) AS salary_raise,
CASE 
	WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'True' 
    ELSE 'False'
END AS '>30,000'
FROM employees e JOIN salaries s ON e.emp_no = s.emp_no JOIN dept_manager dm ON dm.emp_no = s.emp_no
GROUP BY emp_no;
#OR
SELECT e.emp_no, e.first_name, e.last_name, (MAX(s.salary) - MIN(s.salary)) AS salary_raise,
IF (MAX(s.salary) - MIN(s.salary) > 30000, 'salary raised above 30000', 'salary raised under 30000') AS salary_difference
FROM employees e JOIN salaries s ON e.emp_no = s.emp_no JOIN dept_manager dm ON dm.emp_no = s.emp_no
GROUP BY emp_no;

SELECT e.emp_no, e.first_name, e.last_name,
CASE 
	WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
    ELSE 'Not an employee anymore' 
END AS current_employee
FROM employees e JOIN dept_emp de ON e.emp_no = de.emp_no
GROUP BY de.emp_no
LIMIT 100;
#or 
SELECT e.emp_no, e.first_name, e.last_name, 
IF(MAX(de.to_date) > SYSDATE(), 'Is still employed', 'Not an employee anymore') AS current_employee
FROM employees e JOIN dept_emp de on e.emp_no = de.emp_no
GROUP BY de.emp_no
LIMIT 100; 
