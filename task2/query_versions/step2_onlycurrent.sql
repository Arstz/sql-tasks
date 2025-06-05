SELECT e.first_name, e.last_name, d.dept_name, t.title, s.salary
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN titles t ON e.emp_no = t.emp_no AND t.to_date = '9999-01-01'
JOIN salaries s ON e.emp_no = s.emp_no AND s.to_date = '9999-01-01'
WHERE e.hire_date < '1995-01-01'
  AND dm.from_date < '1990-01-01'
ORDER BY s.salary DESC;
