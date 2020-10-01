USE birdstrikes;

-- Exercise 1
-- What state figures in the 145th line of our database?
SELECT * FROM birdstrikes LIMIT 144,1;
-- Tennessee

-- Exercise 2
-- What is flight_date of the latest birdstrike in this database?
SELECT * FROM birdstrikes ORDER BY flight_date DESC;
-- 2000-04-18

-- Exercise 3
-- What was the cost of the 50th most expensive damage?
SELECT DISTINCT cost FROM birdstrikes ORDER BY cost DESC LIMIT 49,1;
-- 5345

-- Exercise 4
-- What state figures in the 2nd record, if you filter out all records which have no state and no bird_size specified?
SELECT * FROM birdstrikes WHERE state IS NOT NULL AND bird_size IS NOT NULL;
-- Empty string

-- Exercise 5
-- How many days elapsed between the current date and the flights happening in week 52, for incidents from Colorado?
SELECT DATEDIFF(NOW(), (SELECT flight_date FROM birdstrikes WHERE WEEKOFYEAR(flight_date) = 52 AND state = "Colorado"));
-- 7579 days
