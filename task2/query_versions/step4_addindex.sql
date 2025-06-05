CREATE INDEX idx_employees_hire_date ON employees(hire_date);
CREATE INDEX idx_salaries_emp_to_date ON salaries(emp_no, to_date);
CREATE INDEX idx_titles_emp_to_date ON titles(emp_no, to_date);
CREATE INDEX idx_dept_manager_from_date ON dept_manager(dept_no, from_date);
