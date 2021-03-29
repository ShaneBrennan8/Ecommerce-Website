### Preface 
### This script covers the creation of the database, insertion of the tables, and the population of these tables using DDL. 
### It makes use of a bridging table called "OrderItem". Details of both can be found down beside their respective piece of SQL.

### Set up and data prep
# Load the 3 CSV files into C:\ProgramData\MySQL\MySQL Server 8.0\Uploads

### Creation of corresponding database using DDL.

DROP DATABASE IF EXISTS BigBulk;

CREATE DATABASE BigBulk;

### Creation of all the necessary tables identified using DDL

USE BigBulk;

CREATE TABLE Customer
(CustomerID MEDIUMINT NOT NULL AUTO_INCREMENT, 
CustomerName VARCHAR (100) NOT NULL, 
CustomerDeliveryAddress VARCHAR (100) NOT NULL,
CustomerBillingAddress VARCHAR (100),
Email varchar(100) NOT NULL,
Phone varchar (100),
PRIMARY KEY (CustomerID));

#Use of auto increment. There is no 'CustomerID' coloumn in the CSV file that I uploaded below
ALTER TABLE Customer AUTO_INCREMENT=0001;

CREATE TABLE Staff
(StaffID SMALLINT NOT NULL AUTO_INCREMENT,
StaffName VARCHAR (20) NOT NULL,
PRIMARY KEY (StaffID));

ALTER TABLE Staff AUTO_INCREMENT=101;

CREATE TABLE Orders
(OrderID VARCHAR (40) NOT NULL, 
OrderDate DATETIME NOT NULL,
CustomerID  MEDIUMINT NOT NULL, 
StaffID SMALLINT NOT NULL,
PRIMARY KEY (OrderID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
FOREIGN KEY (StaffID) REFERENCES Staff(StaffID)
);

CREATE TABLE Supplier
(SupplierID VARCHAR (10) NOT NULL,
SupplierName VARCHAR (20),
Address VARCHAR (100),
PRIMARY KEY (SupplierID)
);

CREATE TABLE Product
(ProductID VARCHAR (20) NOT NULL,
ProductName VARCHAR (50) NOT NULL,
Description VARCHAR (200),
UnitPrice INT (5) NOT NULL,
SupplierID VARCHAR (10) NOT NULL,
Stock INT (5),
PRIMARY KEY (ProductID),
FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);


CREATE TABLE OrderItem
(ItemID VARCHAR (50) NOT NULL,
OrderID VARCHAR (40) NOT NULL,
ProductID VARCHAR (20) NOT NULL,
Quantity INT (10),
PRIMARY KEY (ItemID),
FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);



### Population of at least 3 tables with data using DDL. 


INSERT INTO Staff(StaffName) VALUES("Javier Marquez");

INSERT INTO Staff(StaffName) VALUES("Irena Blastoff");

INSERT INTO Staff(StaffName) VALUES("Mark O'Shea");


INSERT INTO Supplier VALUES("SP-0401","Xplosive","4 Rue D'Atlas, Toulouse, France");

INSERT INTO Supplier VALUES("SP-0402","Big G Sports","8 Strad  Allem, Colonge, Germany");

INSERT INTO Supplier VALUES("SP-0403","Gym partz","48 Quay Way, Waterford, Ireland");

INSERT INTO Supplier VALUES("SP-0404","Xplosive","30A Edwards Way, Brentford, UK");

INSERT INTO Supplier VALUES("SP-0405","Big Red Lifting","52 Plaza di Buisnozette, Milan, Italy");

INSERT INTO Supplier VALUES("SP-0406","Sweatz","Unit 4A Greypark Business Center, Dublin, Ireland");


INSERT INTO Customer
(CustomerName,
CustomerDeliveryAddress,
CustomerBillingAddress,
Email,
Phone) VALUES(
"Meggi Conningham","Ardlahan, Limerick",'Aghanagh, Sligo',"mconningham0@tuttocitta.it
", "829 219 3789"
);

INSERT INTO Customer(
CustomerName,
CustomerDeliveryAddress,
CustomerBillingAddress,
Email,
Phone) VALUES(
"Daveta Barnett","Ardmore, Galway","Agharrow, Sligo","dbarnett1@newyorker.com", "829 219 3789"
);

INSERT INTO Customer(
CustomerName,
CustomerDeliveryAddress,
CustomerBillingAddress,
Email,
Phone) VALUES(
"Nonna Butte","Ardra, Cavan","Ardra, Cavan","nbutte2@buzzfeed.com", "978 857 0626"
);


INSERT INTO Orders VALUES("33-29-25-8A-37-34","2020-03-22", "0001","101");

INSERT INTO Orders VALUES("D1-96-6A-FC-95-A0","2020-04-16","0002", "102");

INSERT INTO Orders VALUES("D3D-0E-DB-64-18-E0","2020-03-02","0003", "103");


### Insertion of Customer information from CSV file dataset

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CustomerCA.csv' 
INTO TABLE Customer
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 4 ROWS #Skipped 4 rows to avoid a dplication error as there are already 3 entries and a header. 
(CustomerName, CustomerDeliveryAddress, CustomerBillingAddress, Email, Phone);

#As I am using a bridging table here which is OrderItems (further down the code) both it and Orders have to uploaded to get the full picture of the transactions
#This file contains over 10,000 rows of information 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/OrdersCA.csv' 
INTO TABLE Orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 4 ROWS
(OrderID, OrderDate, CustomerID, StaffID);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ProductsCA.csv' 
INTO TABLE Product
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProductID, ProductName, Description, UnitPrice, SupplierID, Stock);



INSERT INTO OrderItem VALUES("3567143528145730","33-29-25-8A-37-34","68084229", "5");
INSERT INTO OrderItem VALUES("5388919967437380","D1-96-6A-FC-95-A0","16590058", "7");
INSERT INTO OrderItem VALUES("5576423984648420","93-27-E8-BC-88-1B","66993663", "29");
INSERT INTO OrderItem VALUES("374283303511505","E6-AB-5F-58-B4-FF","51991836", "3");
INSERT INTO OrderItem VALUES("341578409382010","20-30-C7-59-5F-48","43419802", "31");
INSERT INTO OrderItem VALUES("3557603631585950","68-A3-AE-46-97-D0","504367067", "10");
INSERT INTO OrderItem VALUES("201755677683043","27-72-66-27-BA-91","17714016", "29");
INSERT INTO OrderItem VALUES("374622988213327","93-E7-83-40-14-CB","369872864", "25");
INSERT INTO OrderItem VALUES("5602215714373920","AA-41-A4-1C-A4-EE","3783023", "6");
INSERT INTO OrderItem VALUES("5556057146534190","36-AB-0F-6D-80-5C","41520388", "7");


# Full order transaction information can be found using the join below although it only returns 10 transactions
# This is supplimental and designed to provide clarity and context only for the user before we start to query the database
SELECT orders.*, orderItem.*
FROM Orders
INNER JOIN OrderItem
where orders.OrderID = OrderItem.OrderID