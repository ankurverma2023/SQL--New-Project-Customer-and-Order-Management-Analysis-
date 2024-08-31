-- Top 20 Basic to Intermediate SQL Interview Questions with Examples
-- Project Name: Customer and Order Management Analysis

CREATE DATABASE DATA_ENGINEER
USE DATA_ENGINEER

--Create Table CustomerProfiles
Create Table CustomerProfiles
(
CustomerID INT IDENTITY(1,1) PRIMARY KEY,
CustomerName VARCHAR(50),
Email VARCHAR(50),
Phone VARCHAR(15),
JoinDate DATE
)
INSERT INTO CustomerProfiles VALUES('Vijay Kumar','Vijaykumar@yahoo.com','8888555500','2024-01-01'),
('Ashish Verma','Ashish20@gmail.com','9999966666','2024-02-10'),
('Ankur verma','Ankur78@outlook.com','8888777700','2024-03-15'),
('Ravi sharma','Ravi55@gmail.com','6665550011','2024-04-20'),
('Dishant Gautam','Dishant@35yahoo.com','9966332200','2024-05-21'),
('Vivek Bohra','Vivek66@gmail.com','5555500000','2024-06-17'),
('Porag Bohra','Porag@yahoo.com','7788996600','2024-07-13'),
('Yash Gupta','Yash89@gmail.com','1234567890','2024-08-25')

SELECT * FROM CustomerProfiles

--Create Table CustomerOrders
Create Table CustomerOrders
(
OrderID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
CustomerID INT NOT NULL,
OderDate Date,
OrderAmount DECIMAL(10,2),
ProductID INT,
FOREIGN KEY (CustomerID) REFERENCES CustomerProfiles(CustomerID)
)
INSERT INTO CustomerOrders VALUES(1,'2024-01-15',250.00,101),
(2,'2024-02-17',150.00,102),
(3,'2024-03-25',300.00,103),
(4,'2024-04-28',450.00,104),
(5,'2024-06-02',500.00,105),
(6,'2024-06-30',650.00,106),
(7,'2024-07-23',750.00,107),
(8,'2024-09-13',900.00,108)

SELECT * FROM CustomerOrders

--Q1- What is SQL?
-- SQL (Structured Query Language) is used for managing and manipulating relational databases.

--Q2- What is the difference between INNER JOIN and LEFT JOIN?
--Inner Join - returns only the rows with matching values in both tables. 
--LEFT JOIN - returns all rows from the left table and, matched rows from the right table; if no match, NULL is returned.

SELECT * FROM CustomerOrders
INNER JOIN CustomerProfiles ON CustomerOrders.CustomerID = CustomerProfiles.CustomerID

SELECT * FROM CustomerOrders
LEFT JOIN CustomerProfiles ON CustomerOrders.CustomerID = CustomerProfiles.CustomerID

--Q3- How do you retrieve all the columns from a table?

SELECT * FROM CustomerProfiles

SELECT * FROM CustomerOrders

--Q4-How do you select distinct values from a column?

SELECT DISTINCT ProductID FROM CustomerOrders

--Q5- What is the purpose of the GROUP BY clause?
--	It groups rows that have the same values into summary rows

SELECT CustomerID, COUNT(*) AS OrderCount
from CustomerOrders
GROUP BY CustomerID

--Q6- How do you filter results using WHERE clause?
-- Use the WHERE clause to specify conditions.

SELECT * FROM CustomerOrders
WHERE OrderAmount > 200         --Greater Then

SELECT * FROM CustomerOrders
WHERE OrderAmount < 200         -- Less Then

--Q7- How do you sort results in ascending or descending order?
-- Use the ORDER BY clause.

SELECT * FROM CustomerOrders
ORDER BY OderDate DESC 

--Q8-What is an aggregate function? Provide examples.
--Aggregate functions perform a calculation on a set of values and return a single value. 
--Examples include COUNT(), SUM(), AVG(), MIN(), and MAX().

SELECT AVG(OrderAmount) AS AverageOrderAmount
from CustomerOrders

--Q9-How do you update data in a table?
--Use the UPDATE statement.

UPDATE CustomerOrders
SET OrderAmount = 275.00
WHERE OrderID = 1

SELECT * FROM CustomerOrders

--Q10- How do you delete data from a table?
--Use the DELETE statement.

DELETE FROM CustomerOrders
WHERE OrderID = 1


--Q11- What is a subquery?
-- A subquery is a query within another query.

SELECT * FROM CustomerOrders
WHERE CustomerID IN (SELECT CustomerID FROM CustomerProfiles WHERE JoinDate > '2023-03-15')

--Q12- How do you create a new table?
-- Use the CREATE TABLE statement.

Create Table NewTable
(
ID INT PRIMARY KEY,
Name Varchar(50)
)

SELECT * FROM NewTable

--Q13- How do you add a new column to an existing table?
-- Use the ALTER TABLE statement.

ALTER TABLE CustomerOrders
ADD Status VARCHAR(50)

SELECT * FROM CustomerOrders

--Q14- How do you find the maximum value in a column?
-- Use the MAX() function.

SELECT MAX(OrderAmount) AS MaxOrderAmount
from CustomerOrders

--Q15- How do you find the total number of rows in a table?
-- Use the COUNT() function.

SELECT COUNT(*) AS TotalOrders
from CustomerOrders

--Q16- How do you create a view?

CREATE VIEW CustomerOrderSummary AS
SELECT CustomerID, COUNT(*) AS OrderCount, SUM(OrderAmount) AS TotalAmount
from CustomerOrders
GROUP BY CustomerID

SELECT * FROM CustomerOrderSummary

-- Customer Spending Summary View - This view summarizes the total spending of each customer.

CREATE VIEW CustomerSpendingSummary AS
SELECT
     CP.CustomerName,
	 SUM(CO.OrderAmount) AS TotalSpent
FROM
   CustomerOrders co
INNER JOIN
   CustomerProfiles CP ON CO.CustomerID = CP.CustomerID
GROUP BY
   CP.CustomerName

SELECT * FROM CustomerSpendingSummary

--Q17- Procedure 
--A stored procedure is a precompiled collection of one or more SQL statements that can be executed as a single unit. 
--It is used to encapsulate business logic, and it can accept parameters.

CREATE PROCEDURE AddNewOrder
    @CustomerID INT,
	@OrderDate DATE,
	@OrderAmount DECIMAL,
	@ProductID INT
AS
BEGIN
    INSERT INTO CustomerOrders (CustomerID, OderDate, OrderAmount, ProductID)
	VALUES (@CustomerID, @OrderDate, @OrderAmount, @ProductID)
END

EXEC AddNewOrder @CustomerID = 2, @OrderDate = '2024-02-17', @OrderAmount = 150.00, @ProductID = 102

--Q18- Trigger
--A trigger is a special type of stored procedure that automatically executes when an event occurs in a table 
--(INSERT, UPDATE, DELETE).

CREATE TRIGGER OrderInsertTrigger
ON CustomerOrders
AFTER INSERT
AS
BEGIN
    INSERT INTO OrderLog (OrderID, LogMessage, LogDate)
	SELECT
	     inserted.OrderID,
		 'New Order Inserted',
		 GETDATE()
	FROM
	    inserted
END


--Q19- Schema Binding
--Schema binding ensures that the schema of a table cannot be changed if a view that references it exists. 
--This ensures that the view remains valid even if underlying table structures change.

CREATE VIEW CustomerOrderSummarize
WITH SCHEMABINDING
AS
SELECT
     CO.CustomerID,
	 COUNT(*) AS OrderCount,
	 SUM(CO.OrderAmount) AS TotalAmount
FROM
    dbo.CustomerOrders co
GROUP BY
   CO.CustomerID

SELECT * FROM CustomerOrderSummarize