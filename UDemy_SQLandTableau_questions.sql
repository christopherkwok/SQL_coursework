# Udemy #
# Combining SQL and Tableau Questions #

USE employees_mod;

#Task1#
SELECT 
	YEAR(de.from_date) AS calendar_year, e.gender, COUNT(e.emp_no) AS num_employees
FROM t_dept_emp de
	JOIN
	t_employees e ON de.emp_no = e.emp_no
GROUP BY calendar_year, e.gender
HAVING calendar_year >= 1990;

#Task2#
SELECT d.dept_name, ee.gender, dm.emp_no, dm.from_date, dm.to_date, e.calendar_year, CASE
	WHEN e.calendar_year >= YEAR(dm.from_date) AND e.calendar_year <= YEAR(dm.to_date) THEN 1
		ELSE 0 
	END AS active 
FROM 
	(SELECT YEAR(hire_date) AS calendar_year 
    FROM t_employees
    GROUP BY calendar_year) e 
    CROSS JOIN 
		t_dept_manager dm 
	JOIN
		t_departments d ON dm.dept_no = d.dept_no
	JOIN 
		t_employees ee ON ee.emp_no = dm.emp_no
ORDER BY dm.emp_no, e.calendar_year; 
    
#Task3#
SELECT e.gender, d.dept_name, ROUND(AVG(s.salary), 2) AS avg_salary, YEAR(s.from_date) AS calendar_year 
FROM t_salaries s
	JOIN 
		t_employees e ON s.emp_no = e.emp_no
	JOIN 
		t_dept_emp de ON e.emp_no = de.emp_no 
	JOIN 
		t_departments d ON de.dept_no = d.dept_no 
GROUP BY d.dept_name, e.gender, calendar_year
HAVING calendar_year <= 2002 
ORDER BY d.dept_no;
		
#Task4#


DELIMITER $$
CREATE PROCEDURE avg_salary_MF (IN lower_range FLOAT, IN upper_range FLOAT)
BEGIN
	SELECT d.dept_name, e.gender, AVG(s.salary) AS avg_salary  
    FROM t_salaries s 
		JOIN t_employees e ON s.emp_no = e.emp_no
		JOIN t_dept_emp de ON e.emp_no = de.emp_no
		JOIN t_departments d ON de.dept_no = d.dept_no
	WHERE salary >= lower_range AND salary <= upper_range
    GROUP BY d.dept_name, e.gender
    ORDER BY avg_salary; 
END $$
DELIMITER ; 