-- Homework 5
-- Continue the last script: complete the US local phones to international using the city code.
-- Hint: for this you need to find a data source with domestic prefixes mapped to cities,
-- import as a table to the database and add new business logic to the procedure.

-- importing the areacodes table that contains US cities with their area codes
USE classicmodels;

CREATE TABLE areacodes
(area VARCHAR(50),
AreaCode INT(50));

SHOW VARIABLES LIKE "secure_file_priv";

LOAD DATA INFILE 'c:/ProgramData/MySQL/MySQL Server 8.0/Uploads/hw5_cities.csv' 
INTO TABLE areacodes 
FIELDS TERMINATED BY ',' 
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(area, AreaCode);

-- creating the stored procedure
DROP PROCEDURE IF EXISTS FixUSPhones; 

DELIMITER $$

CREATE PROCEDURE FixUSPhones ()
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE phone VARCHAR(50) DEFAULT "x";
	DECLARE customerNumber INT DEFAULT 0;
	DECLARE country VARCHAR(50) DEFAULT "";
    DECLARE city VARCHAR(50) DEFAULT "";
    DECLARE areacode VARCHAR(50) DEFAULT "";

	-- declare cursor for customer
	DECLARE curPhone
		CURSOR FOR 
				SELECT customers.customerNumber, customers.phone, customers.country , customers.city
					FROM classicmodels.customers;

	-- declare NOT FOUND handler
    -- when the cursor ends finished becomes 1
	DECLARE CONTINUE HANDLER 
        FOR NOT FOUND SET finished = 1;

	OPEN curPhone;
    
    	-- create a copy of the customer table 
	DROP TABLE IF EXISTS classicmodels.fixed_customers;
	CREATE TABLE classicmodels.fixed_customers LIKE classicmodels.customers;
	INSERT fixed_customers SELECT * FROM classicmodels.customers;

	fixPhone: LOOP
		FETCH curPhone INTO customerNumber, phone, country, city;
		IF finished = 1 THEN 
			LEAVE fixPhone;
		END IF;
        
        
		IF country = 'USA'  THEN
			IF phone NOT LIKE '+%' THEN
				IF LENGTH(phone) = 10 THEN 
					SET  phone = CONCAT('+1', phone);
					UPDATE classicmodels.fixed_customers 
						SET fixed_customers.phone=phone 
							WHERE fixed_customers.customerNumber = customerNumber;
				ELSEIF LENGTH(phone) = 7 THEN
					SET areacode = (SELECT areacodes.AreaCode FROM areacodes WHERE areacodes.area = city);
					SET phone = CONCAT('+1', areacode, phone);
                    UPDATE classicmodels.fixed_customers 
						SET fixed_customers.phone=phone 
							WHERE fixed_customers.customerNumber = customerNumber;
				END IF;    
			END IF;
		END IF;

	END LOOP fixPhone;
	CLOSE curPhone;

END$$
DELIMITER ;

-- calling the stored procedure
CALL FixUSPhones();

-- checking if all phone numbers have the correct format
SELECT * FROM fixed_customers WHERE country = 'USA';