-- create table joining employees and titles table
SELECT e.emp_no,
	   e.first_name,
	   e.last_name,
	   ti.title,
	   ti.from_date,
	   ti.to_date
INTO emp_titles
FROM employees AS e
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (et.emp_no) et.emp_no,
					et.first_name,
					et.last_name,
					et.title
INTO unique_titles
FROM emp_titles AS et
WHERE (et.to_date = '9999-01-01')
ORDER BY et.emp_no, et.to_date DESC;

-- empoyees by recent job title
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles AS ut
GROUP BY ut.title
ORDER BY COUNT(ut.title) DESC

-- extract birth year from employee table
SELECT EXTRACT (year FROM e.birth_date), e.emp_no
INTO emp_birth_year
FROM employees AS e

-- create table of retirement eligible employees based on birth year
SELECT 	ut.emp_no,
		ut.first_name,
		ut.last_name,
		ut.title,
		eby.date_part
INTO retirement_date
FROM unique_titles AS ut
LEFT JOIN emp_birth_year AS eby
ON (ut.emp_no = eby.emp_no)

-- retirement eligible employees based on birth year
SELECT COUNT(rd.date_part), rd.date_part
FROM retirement_date AS rd
GROUP BY rd.date_part
ORDER BY COUNT(rd.date_part)

-- create mentorship eligibility table 
SELECT DISTINCT ON (e.emp_no) e.emp_no,
		e.first_name,
		e.last_name,
		e.birth_date,
		de.from_date,
		de.to_date,
		ti.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ti
ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY e.emp_no

-- query mentorship eligibility table to group based on title
SELECT COUNT (me.title), me.title
FROM mentorship_eligibility AS me
GROUP BY me.title
ORDER BY COUNT (me.title) DESC