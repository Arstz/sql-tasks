select e.first_name, e.last_name, d.dept_name, t.title, s.salary
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN titles t ON e.emp_no = t.emp_no
JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.hire_date < '1995-01-01'
  AND d.dept_name IN (
      SELECT dept_name
      FROM departments
      WHERE dept_no IN (
          SELECT dept_no
          FROM dept_manager
          WHERE from_date < '1990-01-01'
      )
  )
ORDER BY s.salary DESC;
