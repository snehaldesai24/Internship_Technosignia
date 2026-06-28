--- CREATE DATABASE
CREATE DATABASE Techno1;
USE Techno1;

/*====================================================
    CREATE DEPARTMENT TABLE
====================================================*/

CREATE TABLE Department
(
    DeptID INT PRIMARY KEY,          -- Unique Department ID
    DeptName VARCHAR(50) NOT NULL    -- Department Name
);


/*====================================================
    CREATE EMPLOYEE TABLE
====================================================*/

CREATE TABLE Employee
(
    EmpID INT PRIMARY KEY,               -- Unique Employee ID
    EmpName VARCHAR(50) NOT NULL,        -- Employee Name
    Salary DECIMAL(10,2),                -- Employee Salary
    DeptID INT,                          -- Department ID (Foreign Key)
    HireDate DATE,                       -- Employee Joining Date

    FOREIGN KEY (DeptID)
    REFERENCES Department(DeptID)
);


/*====================================================
    INSERT DATA INTO DEPARTMENT TABLE
====================================================*/

INSERT INTO Department (DeptID, DeptName)
VALUES
(1, 'HR'),
(2, 'IT'),
(3, 'Finance'),
(4, 'Sales'),
(5, 'Marketing'),
(6, 'Admin'),
(7, 'Operations'),
(8, 'Support'),
(9, 'Legal'),
(10, 'Research');


/*====================================================
    INSERT DATA INTO EMPLOYEE TABLE
====================================================*/

INSERT INTO Employee (EmpID, EmpName, Salary, DeptID, HireDate)
VALUES
(101, 'Megha', 75000, 2, '2026-02-10'),
(102, 'Rahul', 65000, 1, '2025-12-15'),
(103, 'Amit', 90000, 2, '2026-01-20'),
(104, 'Priya', 85000, 3, '2025-11-10'),
(105, 'Sneha', 60000, 4, '2026-03-05'),
(106, 'Vikas', 95000, 2, '2025-10-01'),
(107, 'Neha', 70000, 5, '2026-04-12'),
(108, 'Kiran', 55000, 1, '2026-05-01'),
(109, 'Rohan', 80000, 3, '2026-01-15'),
(110, 'Pooja', 68000, 4, '2026-06-01');


/*====================================================
    DISPLAY ALL RECORDS
====================================================*/

-- View Department Table
SELECT *
FROM Department;

-- View Employee Table
SELECT *
FROM Employee;


/*====================================================
    1. TOP 5 HIGHEST SALARY EMPLOYEES
====================================================*/

SELECT TOP 5 *
FROM Employee
ORDER BY Salary DESC;


/*====================================================
    2. DEPARTMENT-WISE EMPLOYEE COUNT
====================================================*/

SELECT
    d.DeptName,
    COUNT(e.EmpID) AS EmployeeCount
FROM Department d
INNER JOIN Employee e
    ON d.DeptID = e.DeptID
GROUP BY d.DeptName;


/*====================================================
    3. SECOND HIGHEST SALARY
====================================================*/

SELECT MAX(Salary) AS SecondHighestSalary
FROM Employee
WHERE Salary <
(
    SELECT MAX(Salary)
    FROM Employee
);


/*====================================================
    4. EMPLOYEES WHOSE SALARY IS GREATER
       THAN THEIR DEPARTMENT AVERAGE
====================================================*/

SELECT *
FROM Employee e
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employee
    WHERE DeptID = e.DeptID
);


/*====================================================
    5. INNER JOIN
====================================================*/

SELECT
    e.EmpID,
    e.EmpName,
    d.DeptName,
    e.Salary
FROM Employee e
INNER JOIN Department d
ON e.DeptID = d.DeptID;


/*====================================================
    6. LEFT JOIN
====================================================*/

SELECT
    d.DeptID,
    d.DeptName,
    e.EmpName
FROM Department d
LEFT JOIN Employee e
ON d.DeptID = e.DeptID;


/*====================================================
    7. GROUP BY WITH HAVING
    DEPARTMENTS HAVING MORE THAN 1 EMPLOYEE
====================================================*/

SELECT
    DeptID,
    COUNT(*) AS TotalEmployees
FROM Employee
GROUP BY DeptID
HAVING COUNT(*) > 1;


/*====================================================
    8. EMPLOYEES HIRED IN LAST 6 MONTHS
====================================================*/

SELECT *
FROM Employee
WHERE HireDate >= DATEADD(MONTH, -6, GETDATE());


/*====================================================
    9. INSERT DUPLICATE RECORDS FOR PRACTICE
====================================================*/

INSERT INTO Employee
VALUES
(111, 'Megha', 75000, 2, '2025-02-10'),
(112, 'Rahul', 65000, 1, '2024-12-15');


/*====================================================
    FIND DUPLICATE RECORDS
====================================================*/

SELECT
    EmpName,
    Salary,
    COUNT(*) AS DuplicateCount
FROM Employee
GROUP BY EmpName, Salary
HAVING COUNT(*) > 1;


/*====================================================
    10. REMOVE DUPLICATE RECORDS
====================================================*/

WITH DuplicateRecords AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY EmpName, Salary
               ORDER BY EmpID
           ) AS RN
    FROM Employee
)

DELETE
FROM DuplicateRecords
WHERE RN > 1;


/*====================================================
    HIGHEST SALARY IN EACH DEPARTMENT
====================================================*/

SELECT
    d.DeptName,
    MAX(e.Salary) AS HighestSalary
FROM Employee e
INNER JOIN Department d
ON e.DeptID = d.DeptID
GROUP BY d.DeptName;


/*====================================================
    THIRD HIGHEST SALARY
====================================================*/

SELECT DISTINCT Salary
FROM Employee
ORDER BY Salary DESC
OFFSET 2 ROWS
FETCH NEXT 1 ROW ONLY;


/*====================================================
    ROW_NUMBER EXAMPLE
====================================================*/

SELECT
    EmpID,
    EmpName,
    Salary,
    ROW_NUMBER() OVER(ORDER BY Salary DESC) AS RowNum
FROM Employee;


/*====================================================
    RANK EXAMPLE
====================================================*/

SELECT
    EmpID,
    EmpName,
    Salary,
    RANK() OVER(ORDER BY Salary DESC) AS RankNo
FROM Employee;


/*====================================================
    DENSE_RANK EXAMPLE
====================================================*/

SELECT
    EmpID,
    EmpName,
    Salary,
    DENSE_RANK() OVER(ORDER BY Salary DESC) AS DenseRankNo
FROM Employee;
------------------------
-- Insert additional employees

INSERT INTO Employee
VALUES
(113,'Anjali',72000,5,'2025-03-15'),
(114,'Suresh',88000,3,'2025-02-20'),
(115,'Ravi',62000,7,'2025-01-10'),
(116,'Komal',78000,8,'2025-04-05'),
(117,'Nikhil',69000,10,'2025-05-12');

--- Window Functions
--- 1.ROW_NUMBER()
SELECT
    EmpID,
    EmpName,
    Salary,
    ROW_NUMBER() OVER(ORDER BY Salary DESC) AS RowNum
FROM Employee;

--- 2.RANK()
SELECT
    EmpID,
    EmpName,
    Salary,
    RANK() OVER(ORDER BY Salary DESC) AS RankNo
FROM Employee;

--- 3.DENSE_RANK()
SELECT
    EmpID,
    EmpName,
    Salary,
    DENSE_RANK() OVER(ORDER BY Salary DESC) AS DenseRankNo
FROM Employee;

--- Department Wise Salary Ranking
SELECT
    EmpName,
    Salary,
    DeptID,
    RANK() OVER
    (
        PARTITION BY DeptID
        ORDER BY Salary DESC
    ) AS DeptRank
FROM Employee;

----- Find second highest salary

SELECT MAX(Salary) AS SecondHighestSalary
FROM Employee
WHERE Salary <
(
    SELECT MAX(Salary)
    FROM Employee
);

-- Employees Whose Salary > Department Average Salary
SELECT
    EmpID,
    EmpName,
    Salary,
    DeptID
FROM Employee e
WHERE Salary >
(
    SELECT AVG(Salary)
    FROM Employee
    WHERE DeptID = e.DeptID
);

--- INNER JOIN

SELECT
    e.EmpID,
    e.EmpName,
    e.Salary,
    d.DeptName
FROM Employee e
INNER JOIN Department d
ON e.DeptID = d.DeptID;

--- LEFT JOIN

SELECT
    d.DeptID,
    d.DeptName,
    e.EmpName
FROM Department d
LEFT JOIN Employee e
ON d.DeptID = e.DeptID;

--- GROUP BY with HAVING

SELECT
    DeptID,
    COUNT(*) AS EmployeeCount
FROM Employee
GROUP BY DeptID
HAVING COUNT(*) > 1;

--- Employees Hired in Last 6 Months

SELECT *
FROM Employee
WHERE HireDate >= DATEADD(MONTH,-6,GETDATE());

---Find Duplicate Records

SELECT
    EmpName,
    Salary,
    COUNT(*) AS DuplicateCount
FROM Employee
GROUP BY EmpName, Salary
HAVING COUNT(*) > 1;

--- Remove Duplicate Records

WITH DuplicateRecords AS
(
    SELECT *,
           ROW_NUMBER() OVER
           (
               PARTITION BY EmpName, Salary
               ORDER BY EmpID
           ) AS RN
    FROM Employee
)

DELETE
FROM DuplicateRecords
WHERE RN > 1;