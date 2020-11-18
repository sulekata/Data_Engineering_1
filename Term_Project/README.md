## Overview ##
This folder contains the two SQL scripts and the entity relationship diagram created by Kata Süle as part of the Term Project for the Data Engineering 1 course.
The script titled 'Kata-Sule_term-project_part-1' contains the creation of the schema used in the project, while the script titled 'Kata-Sule_term-project_part-2' consists of queries and commands that create the analytical layer, the ETL pipeline as well as the data marts. The entity relationship diagram shows how the tables are connected to each other in the used schema.
A more detailed description of the project and the used queries can be found in the SQL scripts, however the main goals and steps are also outlined below.

### Operational Layer ###
The dvd_rental schema contains rental data on a DVD rental company having stores in Australia and Canada. The schema has 16 tables which can be seen in the entity relationship diagram below.
The source of the schema is the following website: <https://dev.mysql.com/doc/index-other.html>.
![alt text](https://github.com/sulekata/Data_Engineering_1/blob/master/Term_Project/er_diagram.png)

### Analytics Plan ###
The aim of the analytics is to find out how the counts of rental times vary when focusing on the different aspects of movies the DVD rental company has in its inventory. One of these aspects is the original language and whether the preferences of people differ in different countries when it comes to watching movies in their original languages, while the other aspect is the category and determining which categories are most popular among customers in general. Consequently the structure of the data store is as follows:
* Fact: Count of Rental Times
	* Dimension 1: Language, Original Language
	* Dimension 2: Category
	* Dimension 3: Country of Store
	* Dimension 4: Population of Country

Using the created data store two data marts are going to be created with the help of views. The questions they aim to answer are the following: 
* View 1:
	Is the per capita ratio of renting non-dubbed movies higher in Canada than in Australia?
* View 2:
	Have customers rented more comedies than action movies?

### Analytical layer and ETL pipeline ###
The analytical layer is created with a stored procedure which joins necessary tables and returns with the analytical layer as a new table called 'datastore'. Furthermore, a trigger is created to add a new row into the datastore table whenever a new row gets inserted into the rental table. This is necessary because a new rental event would modify the values of both the rental of non-dubbed movies per capita and the number of rental of comedy vs action movies which are the two questions of the analytics process. The trigger is tested to make sure it works properly.

### Data Marts ###
Two data marts are created with the help of views. The first one 'Orig_Lang' makes it possible to answer the question whether the per capita ratio of renting non-dubbed movies higher in Canada than in Australia, while the second one 'Comedy_vs_Action' helps to find out whether customers rented more comedies than action movies.
After running queries on each of the the views it can be concluded that customers in Australia watched more movies in their original language, however the difference from Canada is very small and that customers rented more action movies than comedies.
