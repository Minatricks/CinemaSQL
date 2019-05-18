Create db structure for application that manages Movie sessions is cinema
Application should allow schedule Sessions in several Cinema halls (assume 4). And create ticket orders.
Movie characterized with description, name, duration. It can be delivered as 2D, 3D movie.
Movie session is scheduled in the cinema hall.
Movie assigned to one or many Genres. Which can be organized as the genres tree. (genres and subgenres)
Cinema halls has different capacity with other characteristics (your choice).
Application should allow to create ticket orders with specified place, session.
It can be assumed that all tickets in session hall has the same price.
 
Tasks 1:
Create DB structure. Provide columns to store data, use reasonable data types, possibility to have null data.
Design keys and relationship between tables.
Create tables and insert basic data.
Design indexes. Provide motivation for selected indexes.
Delivery method for movie session should not allow anything except (2D or 3D)
Price cannot be lower than 0
Order should contain at least one ticket
Movie name should be unique

Task1*: design option to have different price for places in movie hall
 
Task 2:
Select all movies information with possible delivery method
Select movies with genres
Select schedule for today with all movies in all cinema halls and delivery methods specified 
Select movies that have more than two genres. Show count of genres.
Select the most popular movie in cinema.
Select profitability for movies in cinema last month. Round to 2 decimal places. (Profitability is ratio of total profit for all movie sessions to total cinema profit)

Task3:
Select all genres and tree level as number for genre

Task 3*:
Add option for ticket orders  ticket is booked, bought or bought after booking.
Select schedule for this week with all movies in all cinema halls and delivery methods specified. Provide count of occupied  places (booked/bought), and total places. Format date as short date. 

Task4: Add soft delete for sessions(not actually delete it from the database but mark is as deleted. Be aware of related tables, also when we do “Delete” query, no records should be deleted)! 

Task5: Add SP to create ticket request. Make sure that 2 uses will not book the same place.

Task6: Add possibility to show short description (20 chars with three dots in the end). Show 'No - description' if empty. Modify movies info query to show short description.

http://www.sql-ex.ru/
