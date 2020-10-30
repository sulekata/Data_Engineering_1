-- The schema 'restaurant' contains information about a restaurant as well as its customers and contains 9 tables.
-- Data source: https://github.com/scottsimpson/restaurant-database

-- creating the schema
CREATE SCHEMA restaurant;

USE restaurant;

-- creating the structure of the customers table
CREATE TABLE customers (
  CustomerID INT(6) NOT NULL AUTO_INCREMENT,
  FirstName VARCHAR(200) NOT NULL DEFAULT '',
  LastName VARCHAR(200) NOT NULL DEFAULT '',
  Email VARCHAR(200) DEFAULT NULL,
  Address VARCHAR(200) DEFAULT NULL,
  City VARCHAR(200) DEFAULT NULL,
  State CHAR(2) DEFAULT NULL,
  Phone VARCHAR(20) NOT NULL DEFAULT '',
  Birthday DATE DEFAULT NULL,
  FavoriteDish INT(6) DEFAULT NULL,
  PRIMARY KEY (CustomerID)
);

-- inserting the values into the customers table
-- getting the path where the .csv files should be stored
SHOW VARIABLES LIKE "secure_file_priv";

-- filling in the table with values
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv' 
INTO TABLE customers 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(CustomerID, FirstName, LastName, Email, Address, City, State, Phone, Birthday, FavoriteDish);

-- creating the structure of the customersdishes table
CREATE TABLE customersdishes (
  CustomersDishesID INT(6) NOT NULL AUTO_INCREMENT,
  CustomerID INT(6) DEFAULT NULL,
  DishID INT(6) DEFAULT NULL,
  PRIMARY KEY (CustomersDishesID)
);

-- inserting the values into the table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customersdishes.csv' 
INTO TABLE customersdishes
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(CustomersDishesID, CustomerID, DishID);

-- creating the structure of the customersevents table
CREATE TABLE customersevents (
  CustomersEventsID INT(6) NOT NULL AUTO_INCREMENT,
  CustomerID INT(6) DEFAULT NULL,
  EventID INT(6) DEFAULT NULL,
  PRIMARY KEY (CustomersEventsID)
);

-- inserting the values into the table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customersevents.csv' 
INTO TABLE customersevents
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(CustomersEventsID, CustomerID, EventID);

-- creating the structure of the dishes table
CREATE TABLE dishes (
  DishID INT(6) NOT NULL AUTO_INCREMENT,
  Name VARCHAR(200) DEFAULT NULL,
  Price DECIMAL(3,2) DEFAULT NULL,
  PRIMARY KEY (DishID)
);

-- inserting the values into the table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/dishes2.csv' 
INTO TABLE dishes
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(DishID, Name, Price);

-- creating the structure of the events table
CREATE TABLE events (
  EventID INT(6) NOT NULL AUTO_INCREMENT,
  Name VARCHAR(200) DEFAULT NULL,
  Description VARCHAR(500) DEFAULT NULL,
  Date DATETIME DEFAULT NULL,
  Location VARCHAR(200) DEFAULT '',
  PRIMARY KEY (EventID)
);

-- inserting the values into the table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events2.csv' 
INTO TABLE events
FIELDS TERMINATED BY ';' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(EventID, Name, Description, Date, Location);

-- creating the structure of the eventslocations table
CREATE TABLE eventslocations (
  id INT(11) unsigned NOT NULL AUTO_INCREMENT,
  EventName VARCHAR(200) DEFAULT NULL,
  Location VARCHAR(200) DEFAULT NULL,
  PRIMARY KEY (id)
);

-- inserting the values into the table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/eventslocations.csv' 
INTO TABLE eventslocations
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(id, EventName, Location);

-- creating the structure of the orders table
drop table orders;
CREATE TABLE orders (
  OrderID INT(6) NOT NULL AUTO_INCREMENT,
  CustomerID INT(6) DEFAULT NULL,
  OrderDate DATETIME DEFAULT NULL,
  PRIMARY KEY (OrderID)
);

-- inserting the values into the table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv' 
INTO TABLE orders
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(OrderID, CustomerID, OrderDate);

-- creating the structure of the ordersdishes table
CREATE TABLE ordersdishes (
  OrdersDishesID INT(6) NOT NULL AUTO_INCREMENT,
  OrderID INT(6) DEFAULT NULL,
  DishID INT(6) DEFAULT NULL,
  PRIMARY KEY (`OrdersDishesID`)
);

-- inserting the values into the table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/ordersdishes.csv' 
INTO TABLE ordersdishes
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(OrdersDishesID, OrderID, DishID);

-- creating the structure of the reservations table
CREATE TABLE reservations (
  ReservationID INT(6) NOT NULL AUTO_INCREMENT,
  CustomerID INT(6) DEFAULT NULL,
  Date DATETIME DEFAULT NULL,
  PartySize INT(3) DEFAULT NULL,
  PRIMARY KEY (ReservationID)
);

-- inserting the values into the table
LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/reservations.csv' 
INTO TABLE reservations
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(ReservationID, CustomerID, Date, PartySize);