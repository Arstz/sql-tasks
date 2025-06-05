The following task illustrates 4 query optimization steps in practice

Original query is as follows:

```
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
```

Runtime: 8.025 sec.
Cost: 414k

Step 1: Eliminate Nested Subqueries

Nested subqueries make code less readable, in this particular case we can exchange them for equal joins:

```
SELECT e.first_name, e.last_name, d.dept_name, t.title, s.salary
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN titles t ON e.emp_no = t.emp_no
JOIN salaries s ON e.emp_no = s.emp_no
WHERE e.hire_date < '1995-01-01'
  AND dm.from_date < '1990-01-01'
ORDER BY s.salary DESC;
```

Runtime: 12.245 sec.
Cost: 477k
Comment: While we sacrificed both time and cost, we improved code readability

Step 2: Filter only current salaries

For some reason it is common to have current employees marked as to_date = '9999-01-01'. That way we would eliminate duplicates in the output and reduce cost.

```
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
```

Runtime: 2.243 sec.
Cost: 102k
Comment: Eliminating duplicated significantly improved both time and cost

Step 3: Limiting the output

```
SELECT e.first_name, e.last_name, d.dept_name, t.title, s.salary
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no
JOIN departments d ON de.dept_no = d.dept_no
JOIN dept_manager dm ON d.dept_no = dm.dept_no
JOIN titles t ON e.emp_no = t.emp_no AND t.to_date = '9999-01-01'
JOIN salaries s ON e.emp_no = s.emp_no AND s.to_date = '9999-01-01'
WHERE e.hire_date < '1995-01-01'
  AND dm.from_date < '1990-01-01'
ORDER BY s.salary DESC
LIMIT 20;
```

Runtime: 2.207 sec.
Cost: 101k
Comment: While limiting did affect the query perfomance, it is insignificant. Nevertheless it does make the output more readable

Step 4: Indexing

Adding indexes on the values should theoretically improve perfomance, I reran the last query for reference

```
CREATE INDEX idx_employees_hire_date ON employees(hire_date);
CREATE INDEX idx_salaries_emp_to_date ON salaries(emp_no, to_date);
CREATE INDEX idx_titles_emp_to_date ON titles(emp_no, to_date);
CREATE INDEX idx_dept_manager_from_date ON dept_manager(dept_no, from_date);
```

Runtime: 12.076 sec.
Cost: 164k
Comment: In practice the adding the indexes only made it run worse, even the preliminaly execution plan stated that the perfomance would tank about in half. 
But executing the query gave even worse result - almost 6 fold increase in runtime and 60 percent in cost.
While we did eliminate the Full table scan in 4th loop, only 15k rows where affected, instead we added a significant load on the first loop with 442k rows.

