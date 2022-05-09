-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

create table employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);



CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

CREATE TABLE dept_emp (
emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

drop table titles;
CREATE TABLE titles (
  emp_no INT NOT NULL,
  title varchar(40) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no,title,from_date)
);


SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

select * from retirement_info;

drop table retirement_info; 
-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager tables
SELECT departments.dept_name,
     dept_manager.emp_no,
     dept_manager.from_date,
     dept_manager.to_date
FROM departments
INNER JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

-- Joining retirement_info and dept_emp tables
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no = dept_emp.emp_no;

--nicknames for tables
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
	FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

 
-- Joining departments and dept_manager tables with abreviations
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;

--left join reitrement info and dept emp tables
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
into each_dept
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
order by de.dept_no;

--Employee Information(7.2.5): A list of employees containing their unique employee number, their last name, first name, gender, and salary
select * from salaries
order by to_date desc;

SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

drop table emp_info;

SELECT e.emp_no,
    e.first_name,
e.last_name,
    e.gender,
    s.salary,
    de.to_date
	INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	      AND (de.to_date = '9999-01-01');
	 
--Management: A list of managers for each department, including the department number, name, and the manager's employee number, last name, first name, and the starting and ending employment dates
-- List of managers per department
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

--Department Retirees: An updated current_emp list that includes everything it currently has, but also the employee's departments
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);


--sales team with emp no, emp firt, emp last, emp dept

SELECT  dm.emp_no,
        ce.last_name,
        ce.first_name,
        d.dept_name
INTO sales_team
FROM dept_manager AS dm
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no)
    INNER JOIN departments AS d
        ON (dm.dept_no=d.dept_no);
		
select * from current_emp;

--sales and development teams

select current_emp.emp_no,
		current_emp.last_name,
		current_emp.first_name,
		dept_emp.dept_no
into sales_force
from current_emp 
	    INNER JOIN dept_emp 
        ON (current_emp.emp_no=dept_emp.emp_no)
	where dept_no = 'd005' 
	or dept_no = 'd007';
	

select e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees as e
	   inner join titles as t
        ON (e.emp_no = t.emp_no)
	WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
	--AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
order by birth_date asc;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO retirement_unique
from retirement_titles
WHERE (to_date = '9999-01-01')
ORDER BY emp_no asc, to_date DESC;

--number of employees by their most recent job title who are about to retire.
select count(emp_no), title
into retiring_titles
from retirement_unique
group by title
order by count desc;

--mentorship program
select e.emp_no, e.first_name, e.last_name, e.birth_date, de.from_date, de.to_date
into mentorship_eligibility
from employees as e
	inner join titles as t ON (e.emp_no = t.emp_no)
    INNER JOIN dept_emp AS de ON (e.emp_no=de.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
order by emp_no; 
		