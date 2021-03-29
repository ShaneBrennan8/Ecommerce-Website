### Shows all the details of the products that have a price greater than 100.
SELECT * FROM
product
WHERE UnitPrice > 100;


### Show all the products along with the supplier detail who supplied the products.
SELECT product.ProductName, product.ProductID, supplier.*
FROM product
INNER JOIN supplier
ON product.supplierID = supplier.supplierID;


### Use of an already created stored procedure that takes the start and end dates of the sales 
### and display all the sales transactions between the start and the end dates.

call Get_Spring_Sales('2020-02-01', '2020-05-01');

### Use of an already created view that shows the total number of items a customer buys from 
### the business in October 2020 along with the total price 

select * from Oct_2020_Customer_Purchases;

### Use of an already created trigger that adjusts the stock level every time a product is sold.

INSERT INTO OrderItem VALUES("3548142404745220","37-3B-E3-78-67-21","21695203", 1);

SELECT * FROM Product
WHERE productName= "Bench";

### Creation of a report of the annual sales (2020) of the 
### business showing the total number of products sold 
## each month

select month(orders.OrderDate) as month_Number, count(*) as products_sold
from Orders
group by month(orders.OrderDate) WITH ROLLUP;


###	Displaying the growth in sales/services (as a percentage) 
### for the business, from the 1st month of opening until now. 

SELECT Period,
 Orders,
 IFNULL(((Orders - LAG(Orders) OVER(ORDER BY Period))/LAG(Orders) OVER(ORDER BY Period)*100),'') AS Growth_Rate
 FROM (
 SELECT DATE_FORMAT(Orders.OrderDate,'%Y-%m') AS Period, COUNT(*) AS Orders
 FROM Orders
 GROUP BY Period WITH ROLLUP
 ) AS x
 WHERE Period IS NOT NULL;


### The below would be used to delete all customers who never buy a product from the business 
### but the current business model does not collect customer information. 

DELETE FROM Customer 
WHERE customerid 
NOT IN
(SELECT Orders.CustomerId from Orders);