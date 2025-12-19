#---------------------Employee Department Analysis----------------#
Create database employee_analysis;
use employee_analysis;

#-------Q2.Create the Dept Table as below-----#
CREATE TABLE Dept (
    deptno INT PRIMARY KEY,
    dname VARCHAR(50),
    loc VARCHAR(50)
);

INSERT INTO Dept (deptno, dname, loc) VALUES
(10, 'OPERATIONS', 'DALLAS'),
(20, 'RESEARCH', 'CHICAGO'),
(30, 'SALES', 'NEW YORK'),
(40, 'ACCOUNTING', 'BOSTON');

Select * from Dept;

#-----Q1.Create the Employee Table as per the Below Data Provided----#
CREATE TABLE Employee (
    empno INT PRIMARY KEY,
    ename VARCHAR(50),
    job VARCHAR(50) DEFAULT 'CLERK',
    mgr INT,
    hiredate DATE,
    sal DECIMAL(10, 2) CHECK (sal > 0),
    comm DECIMAL(10, 2),
    deptno INT,
    FOREIGN KEY (deptno) REFERENCES Dept (deptno)
);

INSERT INTO Employee (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7369, 'SMITH', 'CLERK', 7902, '1980-12-17', 800.00, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600.00, 300.00, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250.00, 500.00, 30),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975.00, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250.00, 1400.00, 30),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850.00, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450.00, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-04-19', 3000.00, NULL, 20),
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000.00, NULL, 10),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500.00, 0.00, 30),
(7876, 'ADAMS', 'CLERK', 7788, '1987-05-23', 1100.00, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950.00, NULL, 30),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000.00, NULL, 20),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300.00, NULL, 10);

Select * from Employee;

#--------Q3. List the Names and salary of the employee whose salary is greater than 1000--------#
SELECT ename,sal
FROM Employee
WHERE sal > 1000;


#-------Q4.	List the details of the employees who have joined before end of September 81.------#
SELECT * FROM Employee
WHERE hiredate < '1981-10-01';


#------Q5. List Employee Names having I as second character.------#
SELECT ename FROM Employee
WHERE ename LIKE '_I%';

#------Q6.	List Employee Name, Salary, Allowances (40% of Sal), P.F. (10 % of Sal) and Net Salary. Also assign the alias name for the columns--------#
SELECT
    ename AS "Employee Name",
    sal AS "Salary",
    sal * 0.40 AS "Allowances (40% of Sal)",
    sal * 0.10 AS "P.F. (10% of Sal)",
    (sal + (sal * 0.40) - (sal * 0.10)) AS "Net Salary"
FROM Employee;

#--------Q7. List Employee Names with designations who does not report to anybody--------#
SELECT ename AS "Employee Name",job AS "Designation"
FROM Employee
WHERE mgr IS NULL;

#-----Q8. List Empno, Ename and Salary in the ascending order of salary.----------#
SELECT empno,ename,sal
FROM Employee
ORDER BY sal ASC;

#----Q9.	How many jobs are available in the Organization ------#
SELECT COUNT(DISTINCT job) AS "Number of Distinct Jobs"
FROM Employee;

#------Q10.	Determine total payable salary of salesman category------#
SELECT SUM(sal) AS "Total Salesman Salary"
FROM Employee
WHERE job = 'SALESMAN';

#-------Q11. List average monthly salary for each job within each department   -------#
SELECT
    deptno AS "Department",
    job AS "Job Title",
    AVG(sal) AS "Average Monthly Salary"
FROM Employee
GROUP BY deptno, job
ORDER BY deptno, job;


#-----Q12. Use the Same EMP and DEPT table used in the Case study to Display EMPNAME, SALARY and DEPTNAME in which the employee is working.---------#
SELECT
    E.ename AS "Employee Name",
    E.sal AS "Salary",
    D.dname AS "Department Name"
FROM Employee E
JOIN Dept D ON E.deptno = D.deptno;

#-------Q13. Create the Job Grades Table as below-----#
CREATE TABLE Job_Grades (
    grade VARCHAR(2) PRIMARY KEY,
    lowest_sal DECIMAL(10, 2) NOT NULL,
    highest_sal DECIMAL(10, 2) NOT NULL
);

INSERT INTO Job_Grades (grade, lowest_sal, highest_sal) VALUES
('A', 0, 999),
('B', 1000, 1999),
('C', 2000, 2999),
('D', 3000, 3999),
('E', 4000, 5000);

SELECT * FROM Job_Grades;

#-----Q14. Display the last name, salary and  Corresponding Grade.------#
SELECT
    Employee.ename AS "Last Name",
    Employee.sal AS "Salary",
    Job_Grades.grade AS "Grade"
FROM Employee
JOIN Job_Grades ON Employee.sal BETWEEN Job_Grades.lowest_sal AND Job_Grades.highest_sal;

#-----Q15. Display the Emp name and the Manager name under whom the Employee works in the below format .Emp Report to Mgr.-----#
SELECT
    E.ename AS "Employee Name",
    M.ename AS "Manager Name",
    CONCAT(E.ename, ' Report to ', M.ename) AS "Emp Report to Mgr."
FROM Employee E  -- E represents the Employee
LEFT JOIN Employee M ON E.mgr = M.empno; -- M represents the Manager


#----Q16. Display Empname and Total sal where Total Sal (sal + Comm)------#
SELECT
    ename AS "Employee Name",
    (sal + COALESCE(comm, 0)) AS "Total Salary"
FROM Employee;

#-----------------------------(or)-----------------------#
SELECT
    ename AS "Employee Name",
    (sal + IFNULL(comm, 0)) AS "Total Salary"
FROM Employee;


#-----Q17. Display Empname and Sal whose empno is a odd number-------#
SELECT
    ename AS "Employee Name",
    sal AS "Salary"
FROM Employee
WHERE empno % 2 = 1;

#-------Q18. Display Empname , Rank of sal in Organisation , Rank of Sal in their department-------#
SELECT
    ename AS "Employee Name",
    sal AS "Salary",
    RANK() OVER (ORDER BY sal DESC) AS "Org Rank (Sal)",-- 1. Rank of Salary in the entire Organization
    RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS "Dept Rank (Sal)"-- 2. Rank of Salary within their Department
FROM Employee
ORDER BY "Org Rank (Sal)";

#--------Q19. Display Top 3 Empnames based on their Salary-------#
SELECT ename AS "Employee Name",sal AS "Salary"
FROM Employee
ORDER BY sal DESC
LIMIT 3;

#-----Q20. Display Empname who has highest Salary in Each Department.----#
SELECT ename AS "Employee Name",sal AS "Salary",deptno AS "Department"
FROM(
        SELECT ename,sal,deptno,
		RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS dept_sal_rank
        FROM Employee
    ) AS RankedEmployees
WHERE
    dept_sal_rank = 1;
    
    