-- ---------------------------------------------------------
-- TERM PROJECT PART II.
-- ---------------------------------------------------------
-- This SQL script contains the second part of the Term Project created by Kata Süle for the Data Engineering 1 course.
-- The second part consists of the analytics plan, the creation of the analytical layer, the ETL pipeline and the data marts.

-- ---------------------------------------------------------
-- ANALYTICS PLAN
-- ---------------------------------------------------------
-- The aim of the analytics is to find out how the counts of rental times vary when focusing on the different aspects of movies 
-- the DVD rental company has in its inventory. One of these aspects is the original language and whether the preferences of people differ
-- in different countries when it comes to watching movies in their original languages, while the other aspect is the category and
-- determining which categories are most popular among customers in general.

-- Consequently the structure of the data store is as follows:
-- Fact: Count of Rental Times
-- Dimension 1: Language, Original Language
-- Dimension 2: Category
-- Dimension 3: Country of Store
-- Dimension 4: Population of Country

-- Using the created data store two data marts are created with the help of views. The questions they aim to answer are the
-- following: 
-- View 1:
-- Is the per capita ratio of renting non-dubbed movies higher in Canada than in Australia?
-- View 2:
-- Have customers rented more comedies than action movies?

-- ---------------------------------------------------------
-- CREATING THE ANALYTICAL LAYER AND THE ETL PIPELINE
-- ---------------------------------------------------------
USE dvd_rental;

-- Creating a stored procedure to join necessary tables and return with the analytical layer as a new table called 'datastore'.
DROP PROCEDURE IF EXISTS CreateDataStore;

DELIMITER $$

CREATE PROCEDURE CreateDataStore()
BEGIN
	DROP TABLE IF EXISTS datastore;

	CREATE TABLE datastore AS
    SELECT
		film.film_id,
		film.title,
		film.language_id,
		IFNULL(original_language_id, FLOOR(RAND() * 6) + 1) AS original_language_id,
		category.name AS category,
        rental.rental_id,
		rental.rental_date,
		country.country,
		population.population
	FROM
		film
	INNER JOIN language
		ON film.language_id = language.language_id
	INNER JOIN film_category
		USING (film_id)
	INNER JOIN category
		USING (category_id)
	INNER JOIN inventory
		USING (film_id)
	INNER JOIN rental
		USING (inventory_id)
	INNER JOIN store
		USING (store_id)
	INNER JOIN address
		USING (address_id)
	INNER JOIN city
		USING (city_id)
	INNER JOIN country
		USING (country_id)
	INNER JOIN population
		USING (country_id);

END$$

DELIMITER ;

CALL CreateDataStore();

-- Creating a trigger that would refresh the datastore table whenever a new row is inserted into the rental table since this changes
-- the values of both the rental of non-dubbed movies per capita and the number of rental of comedy vs action movies which are the two 
-- questions of this analytics process.
-- Creating a table in which the newly added rental_ids can be logged.
CREATE TABLE messages (message varchar(255) NOT NULL);

-- Creating the trigger itself.
DROP TRIGGER IF EXISTS after_rental_insert; 

DELIMITER $$

CREATE TRIGGER after_rental_insert
AFTER INSERT
ON rental FOR EACH ROW
BEGIN
	
	INSERT INTO messages SELECT CONCAT('new rental_id: ', NEW.rental_id);

  	INSERT INTO datastore
    SELECT
		film.film_id,
		film.title,
		film.language_id,
		IFNULL(original_language_id, FLOOR(RAND() * 6) + 1) AS original_language_id,
		category.name AS category,
        rental.rental_id,
		rental.rental_date,
		country.country,
		population.population
	FROM
		film
	INNER JOIN language
		ON film.language_id = language.language_id
	INNER JOIN film_category
		USING (film_id)
	INNER JOIN category
		USING (category_id)
	INNER JOIN inventory
		USING (film_id)
	INNER JOIN rental
		USING (inventory_id)
	INNER JOIN store
		USING (store_id)
	INNER JOIN address
		USING (address_id)
	INNER JOIN city
		USING (city_id)
	INNER JOIN country
		USING (country_id)
	INNER JOIN population
		USING (country_id)
	WHERE rental.rental_id = NEW.rental_id;
END $$

DELIMITER ;

-- Testing if the trigger works.
-- Checking the number of rows and the last rental_id in the datastore table before inserting a new row to the rental table.
SELECT COUNT(*) FROM datastore;
SELECT rental_id FROM datastore ORDER BY rental_id DESC LIMIT 1;
-- Before activating the trigger the table has 16044 rows and the last rental_id is 16049.

-- Inserting a new row into rental to activate the trigger.
INSERT INTO rental VALUES (16050,NULL,772,103,'2012-04-12 04:22:11',2,'2012-04-12 04:22:11');

-- Checking the content of the messages table.
SELECT * FROM messages;
-- It has a rental_id in it.

-- Checking the number of rows and the last rental_id in the datastore table.
SELECT COUNT(*) FROM datastore;
SELECT rental_id FROM datastore ORDER BY rental_id DESC LIMIT 1;
-- The new row with rental_id 16050 has been inserted so there are 16045 rows in the data store table.

-- ---------------------------------------------------------
-- CREATING THE DATA MARTS
-- ---------------------------------------------------------
-- The two data marts are created with the help of views.

-- Data Mart 1. : Is the per capita ratio of renting non-dubbed movies higher in Canada than in Australia?
-- The language_id column indicates the language into which the movie was dubbed, consequently if a value in this column
-- is the same as in the original_language_id column then the movie was not dubbed.
DROP VIEW IF EXISTS Orig_Lang;

CREATE VIEW `Orig_Lang` AS
SELECT film_id, language_id, original_language_id, rental_id, country, population FROM datastore
WHERE country IN('Canada', 'Australia') AND language_id = original_language_id;

-- With the help of this view it is possible to answer the first question of the analytics.
SELECT country, COUNT(rental_id)/population AS rented_per_capita
FROM Orig_Lang
GROUP BY country;
-- Based on the rented_per_capita value we can say that customers in Australia watched more movies in their original language, however the 
-- difference from Canada is very small.

-- Data Mart 2. : Have customers rented more comedies than action movies?
DROP VIEW IF EXISTS Comedy_vs_Action;

CREATE VIEW `Comedy_vs_Action` AS
SELECT film_id, category, rental_id FROM datastore
WHERE category IN('Comedy', 'Action');

-- With the help of this view it is possible to answer the second question of the analytics.
SELECT category, COUNT(rental_id) AS number_of_rentals
FROM Comedy_vs_Action
GROUP BY category;
-- We can conclude that customers have rented more action movies (1112) than comedies (941).