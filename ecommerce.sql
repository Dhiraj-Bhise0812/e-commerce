create database ecommerce;
use ecommerce;
CREATE TABLE Customers (
    Customer_ID     VARCHAR(10) PRIMARY KEY,
    Name            VARCHAR(100),
    City            VARCHAR(100),
    Contact_Number  VARCHAR(20),
    Email           VARCHAR(100),
    Gender          VARCHAR(10),
    Address         text
);

CREATE TABLE Products (
    Product_ID      INT PRIMARY KEY,
    Product_Name    VARCHAR(100),
    Category        VARCHAR(50),
    Price           DECIMAL(10,2),
    Occasion        VARCHAR(50),
    Description     TEXT
);

CREATE TABLE Orders (
    Order_ID        INT PRIMARY KEY,
    Customer_ID     VARCHAR(10),
    Product_ID      INT,
    Quantity        INT,
    Order_Date      VARCHAR(10),   
    Order_Time      TIME,
    Delivery_Date   VARCHAR(10),   
    Delivery_Time   TIME,
    Location        VARCHAR(100),
    Occasion        VARCHAR(50)
    );

select * from customers;
select * from products;
select * from orders;



SELECT Order_ID, Customer_ID, Product_ID, Quantity, Order_Date
FROM Orders
WHERE Quantity >= 4
ORDER BY STR_TO_DATE(Order_Date, '%d-%m-%Y') DESC
LIMIT 10;


SELECT Category, COUNT(*) AS product_count
FROM Products
GROUP BY Category
ORDER BY product_count DESC;







SELECT o.Order_ID, c.Name, p.Product_Name, o.Quantity, p.Price
FROM Orders o
INNER JOIN Customers c ON o.Customer_ID = c.Customer_ID
INNER JOIN Products p  ON o.Product_ID  = p.Product_ID
LIMIT 10;


SELECT p.Product_ID, p.Product_Name
FROM Orders o
RIGHT JOIN Products p ON o.Product_ID = p.Product_ID
WHERE o.Order_ID IS NULL;



SELECT Product_Name, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products)
ORDER BY Price DESC;


SELECT Customer_ID, Name
FROM Customers
WHERE Customer_ID IN (
    SELECT Customer_ID FROM Orders
    GROUP BY Customer_ID
    HAVING COUNT(*) > 5
);



SELECT p.Category,
SUM(o.Quantity)   AS total_units_sold,
AVG(p.Price)   AS avg_price,
SUM(o.Quantity * p.Price)  AS total_revenue
FROM Orders o
JOIN Products p ON o.Product_ID = p.Product_ID
GROUP BY p.Category
ORDER BY total_revenue DESC;




SELECT Occasion,
COUNT(*)       AS num_orders,
MIN(Quantity)  AS min_qty,
MAX(Quantity)  AS max_qty,
AVG(Quantity)  AS avg_qty
FROM Orders
GROUP BY Occasion
ORDER BY num_orders DESC;





CREATE VIEW vw_order_revenue AS
SELECT o.Order_ID, o.Customer_ID, o.Product_ID, o.Quantity, p.Price,
       (o.Quantity * p.Price) AS Revenue,
       STR_TO_DATE(o.Order_Date, '%d-%m-%Y') AS Order_Date
FROM Orders o
JOIN Products p ON o.Product_ID = p.Product_ID;

SELECT * FROM vw_order_revenue WHERE Revenue > 5000;



CREATE INDEX idx_orders_customer   ON Orders(Customer_ID);
CREATE INDEX idx_orders_product    ON Orders(Product_ID);
CREATE INDEX idx_products_category ON Products(Category);


CREATE INDEX idx_orders_cust_date ON Orders(Customer_ID, Order_Date);

EXPLAIN SELECT * FROM Orders WHERE Customer_ID = 'C001';

