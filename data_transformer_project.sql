CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    RegistrationDate DATE
);

INSERT INTO Customers (CustomerID, FirstName, LastName, Email, RegistrationDate)
VALUES
(1, 'John', 'Doe', 'john.doe@example.com', '2024-01-15'),
(2, 'Jane', 'Smith', 'jane.smith@example.com', '2024-02-20'),
(3, 'Michael', 'Johnson', 'michael.johnson@example.com', '2024-03-01'),
(4, 'Emily', 'Davis', 'emily.davis@example.com', '2024-03-10'),
(5, 'David', 'Miller', 'david.miller@example.com', '2024-03-12');

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10, 2)
);

INSERT INTO Employees (EmployeeID, FirstName, LastName, Department, HireDate, Salary)
VALUES
(1, 'Alice', 'Walker', 'HR', '2020-05-10', 55000.00),
(2, 'Bob', 'Williams', 'IT', '2021-07-22', 62000.00),
(3, 'Charlie', 'Brown', 'Finance', '2019-11-15', 70000.00),
(4, 'Diana', 'Smith', 'Marketing', '2023-01-30', 48000.00),
(5, 'Ethan', 'Johnson', 'Sales', '2022-09-18', 53000.00);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(1, 1, '2024-01-20', 150.75),
(2, 2, '2024-02-22', 250.50),
(3, 3, '2024-03-05', 320.00),
(4, 4, '2024-03-11', 180.40),
(5, 5, '2024-03-15', 290.99),
(6, 1, '2024-03-20', 180.50),
(7, 2, '2024-03-25', 210.75),
(8, 3, '2024-03-28', 400.00),
(9, 4, '2024-03-18', 250.90),
(10, 5, '2024-03-22', 350.30);

-- Queries to perform:


-- Inner Join: Retrieve all orders and customer details where order exist
SELECT e.CustomerID, e.FirstName, e.LastName, e.Email, o.OrderID, o.OrderDate, o.TotalAmount FROM Customers e
JOIN Orders o ON e.CustomerID=o.CustomerID;


-- Left Join: Retrieve all customers and their corresponding orders (if any)
SELECT e.CustomerID, e.FirstName, e.LastName, e.Email, o.OrderID, o.OrderDate, o.TotalAmount FROM Customers e
LEFT JOIN Orders o ON e.CustomerID=o.CustomerID;


-- Right Join: Retrieve all orders and their corresponding customers (if any)
SELECT e.CustomerID, e.FirstName, e.LastName, e.Email, o.OrderID, o.OrderDate, o.TotalAmount FROM Customers e
RIGHT JOIN Orders o ON e.CustomerID=o.CustomerID;


-- Full Outer Join: Retrieve all customers and all orders, regardless of matching
SELECT e.CustomerID, e.FirstName, e.LastName, e.Email, o.OrderID, o.OrderDate, o.TotalAmount FROM Customers e
LEFT JOIN Orders o ON e.CustomerID=o.CustomerID

UNION

SELECT e.CustomerID, e.FirstName, e.LastName, e.Email, o.OrderID, o.OrderDate, o.TotalAmount FROM Customers e
RIGHT JOIN Orders o ON e.CustomerID=o.CustomerID;


-- Subquery to find customers who have placed orders worth more than the average amount
SELECT e.CustomerID, e.FirstName, e.LastName, e.Email, o.TotalAmount FROM Customers e WHERE o.TotalAmount>(SELECT AVG(o.TotalAmount) FROM Orders o);


-- Subquery to find employees with salaries above the average salary
SELECT e.EmployeeID, e.FirstName, e.LastName, e.Department, e.Salary FROM Employees e
WHERE e.Salary>(SELECT AVG(e1.Salary) FROM Employees e1);


-- Extract the year and month from the OrderDate
SELECT MONTH(OrderDate) AS order_date_month, YEAR(OrderDate) AS order_date_year FROM Orders;


-- Calculate the difference in days between two dates (order date and current date)
SELECT DATEDIFF(CURDATE(),OrderDate) AS day_difference_between_current_date_and_order_date FROM Orders;


-- Format the OrderDate to a more readable format (e.g., 'DD-MM-YYYY')
SELECT DATE_FORMAT(OrderDate,'%d-%m-%Y') AS order_date_in_readable_format FROM Orders;


-- Concatenate FirstName and LastName to form a FullName
SELECT CONCAT(FirstName," ",LastName) AS FullName FROM Customers;


-- Replace part of a string (e.g., replace 'John' to 'Jonathan')
SELECT REPLACE(FirstName,'John','Jonathan') AS updated_name_data FROM Customers;


-- Convert FirstName to uppercase and LastName to lowercase
SELECT UPPER(FirstName) AS firstname_in_capital_letters, LOWER(LastName) AS lastname_in_small_letters FROM Customers;


-- Trim the extra spaces from the Email field
SELECT TRIM(Email) AS updated_email_data FROM Customers;


-- Calculate the running total of TotamAmount of each order
SELECT OrderID, CustomerID, OrderDate, TotalAmount, SUM(TotalAmount) OVER( ORDER BY TotalAmount ) AS cumulative_total FROM Orders; 


-- Rank orders based on TotalAmount using the RANK() function
SELECT OrderID, CustomerID, OrderDate, TotalAmount, RANK() OVER(ORDER BY TotalAmount DESC) AS rank_according_total_amount FROM Orders;


-- Assign a discount based on TotalAmount in orders (e.g., > 1000: 10% off, > 500: 5% off)
SELECT OrderID, CustomerID, OrderDate, TotalAmount,
CASE 
    WHEN TotalAmount>=300 THEN TotalAmount*0.1
    WHEN TotalAmount>=100 THEN TotalAmount*0.05
    ELSE TotalAmount
END AS discount_according_totalamount 
FROM Orders;


-- Categorize employees's salaries as high, medium, and low
SELECT EmployeeID, FirstName, LastName, Salary,
CASE 
    WHEN Salary>=70000 THEN "High"
    WHEN Salary>=50000 THEN "Medium"
    ELSE "Low"
END AS salary_grade
FROM Employees;