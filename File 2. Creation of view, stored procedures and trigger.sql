### Stored procedure
# I had to use two where clauses here because I had to join Orders and OrderItem due to my utilisation of the bridging table
DROP PROCEDURE IF EXISTS Get_Spring_Sales;
call DELIMITER $$
CREATE PROCEDURE `Get_Spring_Sales`(IN StartDate datetime, FinishDate datetime)
BEGIN
SELECT orders.*, orderItem.*
FROM Orders
JOIN OrderItem
where orders.OrderID = OrderItem.OrderID
AND
orders.OrderDate BETWEEN StartDate AND FinishDate ;
END$$
DELIMITER ;

# Test
call Get_Spring_Sales('2020-02-01', '2020-05-01');


### View
DROP VIEW IF EXISTS Oct_2020_Customer_Purchases;

CREATE VIEW Oct_2020_Customer_Purchases AS 
select count(OrderID) AS Orders_Made, customer.CustomerName 
FROM Orders JOIN customer ON Orders.customerID = customer.customerID
WHERE year (OrderDate) = 2020
GROUP BY orders.customerID
order by count(OrderID) DESC;

#Test 
select * from Oct_2020_Customer_Purchases;

### Trigger
# Get a feel for the table
SELECT * FROM Product
WHERE productName= "Bench";

DROP TRIGGER IF EXISTS Bench_stock;
DELIMITER $$
CREATE TRIGGER Bench_stock
	### Dictate whether its before or after an update (or insert) and on which table
	AFTER INSERT ON OrderItem
    ### Make it run for each row you've updated
	FOR EACH ROW BEGIN
    ### Defined which table to update
    UPDATE Product
    ### Define the field/s to update
	SET Product.Stock = Product.Stock - 1
    ### Set the conditions to ensure it only updates the correct rows on the treatment table i.e. match patient ID, status and check that the issue status
    WHERE new.ProductID = "21695203" and new.quantity = 1;
END $$
DELIMITER ;