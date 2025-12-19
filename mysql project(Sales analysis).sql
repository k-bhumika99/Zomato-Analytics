Create database sales_analysis;
use sales_analysis;

#---Q1.	Create the Salespeople as below screenshot.---------#
CREATE TABLE Salespeople (
    snum INT PRIMARY KEY,
    sname VARCHAR(50) NOT NULL,
    city VARCHAR(50),
    comm DECIMAL(3, 2)
);

INSERT INTO Salespeople (snum, sname, city, comm) VALUES
(1001, 'Peel', 'London', 0.12),
(1002, 'Serres', 'San Jose', 0.13),
(1003, 'Axelrod', 'New york', 0.10),
(1004, 'Motika', 'London', 0.11),
(1007, 'Rafkin', 'Barcelona', 0.15);

SELECT * FROM Salespeople;

#-----Q2. Create the Cust Table as below Screenshot----------#
CREATE TABLE Cust (
    cnum INT PRIMARY KEY,
    cname VARCHAR(50) NOT NULL,
    city VARCHAR(50),
    rating INT,
    snum INT,
    FOREIGN KEY (snum) REFERENCES Salespeople (snum)
);

INSERT INTO Cust (cnum, cname, city, rating, snum) VALUES
(2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Giovanne', 'Rome', 200, 1003),
(2003, 'Liu', 'San Jose', 300, 1002),
(2004, 'Grass', 'Berlin', 100, 1002),
(2006, 'Clemens', 'London', 300, 1007),
(2007, 'Pereira', 'Rome', 100, 1004),
(2008, 'James', 'London', 200, 1007);

SELECT * FROM Cust;

#----------Q3.Create orders table as below screenshot.------#
CREATE TABLE Orders (
    onum INT PRIMARY KEY,
    amt DECIMAL(10, 2) NOT NULL,
    odate DATE NOT NULL,
    cnum INT,
    snum INT,
    FOREIGN KEY (cnum) REFERENCES Cust (cnum),
    FOREIGN KEY (snum) REFERENCES Salespeople (snum)
);

INSERT INTO Orders (onum, amt, odate, cnum, snum) VALUES
(3001, 18.69, '1994-10-03', 2008, 1007),
(3002, 1900.10, '1994-10-03', 2007, 1004),
(3003, 767.19, '1994-10-03', 2001, 1001),
(3005, 5160.45, '1994-10-03', 2003, 1002),
(3006, 1098.16, '1994-10-04', 2008, 1007),
(3007, 75.75, '1994-10-05', 2004, 1002),
(3008, 4723.00, '1994-10-05', 2006, 1001),
(3009, 1713.23, '1994-10-04', 2002, 1003),
(3010, 1309.95, '1994-10-06', 2004, 1002),
(3011, 9891.88, '1994-10-06', 2006, 1001);

SELECT * FROM Orders;

#------Q4.Write a query to match the salespeople to the customers according to the city they are living.---------#
SELECT
    S.sname AS "Salesperson Name",
    C.cname AS "Customer Name",
    S.city AS "Shared City"
FROM Salespeople S
JOIN Cust C ON S.city = C.city
ORDER BY S.city, S.sname, C.cname;

#------Q5.Write a query to select the names of customers and the salespersons who are providing service to them.----#
SELECT
    C.cname AS "Customer Name",
    S.sname AS "Salesperson Name"
FROM Cust C
JOIN Salespeople S ON C.snum = S.snum
ORDER BY C.cname;

#----Q6. Write a query to find out all orders by customers not located in the same cities as that of their salespeople-----#
SELECT
    O.onum AS "Order Number",
    O.amt AS "Amount",
    C.cname AS "Customer Name",
    C.city AS "Customer City",
    S.sname AS "Salesperson Name",
    S.city AS "Salesperson City"
FROM Orders O
JOIN Cust C ON O.cnum = C.cnum  -- Link Order to Customer
JOIN Salespeople S ON C.snum = S.snum -- Link Customer to Salesperson
WHERE C.city <> S.city; -- Filter where cities are NOT equal

#------Q7. Write a query that lists each order number followed by name of customer who made that order-----#
SELECT
    O.onum AS "Order Number",
    C.cname AS "Customer Name"
FROM  Orders O
JOIN Cust C ON O.cnum = C.cnum
ORDER BY O.onum;

#------Q8.Write a query that finds all pairs of customers having the same rating-------#
SELECT
    A.cname AS "Customer 1 Name",
    A.rating AS "Rating",
    B.cname AS "Customer 2 Name"
FROM Cust A
JOIN Cust B ON A.rating = B.rating
WHERE A.cnum < B.cnum
ORDER BY A.rating, A.cname;

#------Q9. Write a query to find out all pairs of customers served by a single salesperson-----#
SELECT
    C1.cname AS "Customer 1 Name",
    C2.cname AS "Customer 2 Name",
    C1.snum AS "Salesperson ID"
FROM Cust C1
JOIN Cust C2 ON C1.snum = C2.snum
WHERE C1.cnum < C2.cnum
ORDER BY C1.snum, C1.cname;

#------Q10.	Write a query that produces all pairs of salespeople who are living in same city-------#
SELECT
    S1.sname AS "Salesperson 1",
    S2.sname AS "Salesperson 2",
    S1.city AS "Shared City"
FROM Salespeople S1
JOIN Salespeople S2 ON S1.city = S2.city
WHERE S1.snum < S2.snum
ORDER BY S1.city, S1.sname;

#-------Q11.	Write a Query to find all orders credited to the same salesperson who services Customer 2008------#
SELECT
    onum AS "Order Number",
    amt AS "Order Amount",
    odate AS "Order Date",
    snum AS "Salesperson ID"
FROM Orders
WHERE
    snum = (
        SELECT snum
        FROM Cust
        WHERE cnum = 2008 -- Subquery: Finds the snum of Customer 2008
    );
    
#-----Q12.Write a Query to find out all orders that are greater than the average for Oct 4th-------#
SELECT
    onum AS "Order Number",
    amt AS "Order Amount",
    odate AS "Order Date"
FROM Orders
WHERE
    amt > (
        -- Subquery: Calculates the average order amount for '1994-10-04'
        SELECT AVG(amt)
        FROM Orders
        WHERE odate = '1994-10-04' -- Subquery: Calculates the average order amount for '1994-10-04'
    );  
    
#----Q13.Write a Query to find all orders attributed to salespeople in London.------#
SELECT
    O.onum AS "Order Number",
    O.amt AS "Amount",
    O.odate AS "Date"
FROM Orders O
JOIN Salespeople S ON O.snum = S.snum
WHERE S.city = 'London';  

#-----Q14.Write a query to find all the customers whose cnum is 1000 above the snum of Serres. -------#
SELECT
    cname AS "Customer Name",
    cnum AS "Customer Number"
FROM Cust
WHERE cnum = 1000 + (
        SELECT snum
        FROM Salespeople
        WHERE sname = 'Serres'-- Subquery: Finds the snum of salesperson 'Serres'
    );  
    
    
#--------Q15.Write a query to count customers with ratings above San Jose’s average rating.-------# 
SELECT COUNT(cnum) AS "Customers with Rating Above San Jose Avg"
FROM Cust
WHERE rating > (
        SELECT AVG(rating)
        FROM Cust
        WHERE city = 'San Jose'-- Subquery: Calculates the average rating for customers in San Jose
    );
    
#--------Q16.Write a query to show each salesperson with multiple customers.------# 
   
SELECT
    S.sname AS "Salesperson Name",
    S.snum AS "Salesperson ID",
    COUNT(C.cnum) AS "Customer Count"
FROM Cust C
JOIN Salespeople S ON C.snum = S.snum
GROUP BY S.snum, S.sname
HAVING COUNT(C.cnum) > 1;
    

    

