USE Cinema_DimaKireiev
GO

--Select all movies information with possible delivery method
SELECT * FROM Movie
INNER JOIN DeliveryMovieMethod ON Movie.Id_Movie = DeliveryMovieMethod.Id_Movie 

GO
--Select movies with genres	
SELECT * FROM Genre INNER JOIN 
Movie ON Genre.Id_Movie = Movie.Id_Movie


Go
SET STATISTICS TIME OFF 
--Select movies that have more than two genres
SELECT  COUNT(Genre.Id_Movie) AS CountGenresInMovie,Movie.Name_Movie FROM 
Genre INNER JOIN Movie ON Genre.Id_Movie = Movie.Id_Movie
GROUP BY Movie.Name_Movie
HAVING COUNT(Genre.Id_Movie) > 1

GO
--Select schedule for today with all movies in all cinema halls and delivery methods specified
SELECT Name_Movie,Duration,IsMovie3D,StartDate FROM ScheduleItem
INNER JOIN Movie ON ScheduleItem.Id_Movie = Movie.Id_Movie
INNER JOIN DeliveryMovieMethod ON Movie.Id_Movie = DeliveryMovieMethod.Id_Movie
WHERE DATEDIFF(day,StartDate, GETDATE()) < 1 

GO
--Show count of genres.
SELECT COUNT(Id_Genre) FROM Genre

GO 
--profitability for movies in cinema last month
DECLARE @AllProfit MONEY;
SET @AllProfit = (SELECT SUM(Price) FROM Place JOIN Ticket ON Place.Id_Place = Ticket.Id_Place
					JOIN ScheduleItem ON Ticket.Id_ScheduleItem = ScheduleItem.Id_ScheduleItem
					WHERE (MONTH(GETDATE()) - 1) = MONTH(StartDate))

SELECT Movie.Id_Movie,CONVERT(VARCHAR,(SUM(Price)/@AllProfit)*100) + ' %' AS profitabilityLastMonth 
FROM Place JOIN Ticket ON Place.Id_Place = Ticket.Id_Place
JOIN ScheduleItem ON Ticket.Id_ScheduleItem = ScheduleItem.Id_ScheduleItem
JOIN Movie ON ScheduleItem.Id_Movie = Movie.Id_Movie
WHERE (MONTH(GETDATE()) - 1) = MONTH(StartDate)
GROUP BY Movie.Id_Movie
 

GO
--Select all genres and tree level as number for genre
WITH AllGenresWithSubGenres AS
(
	SELECT G.Id_Genre AS ChildId,G.Parent_Id AS ParentId,G.Name_Genre, 1 AS level
	FROM Genre G
	WHERE G.Parent_Id IS NULL 	

	UNION ALL

	SELECT G.Id_Genre AS ChildId,G.Parent_Id AS ParentId,G.Name_Genre, AllGenresWithSubGenres.level + 1 AS level
	FROM Genre G JOIN AllGenresWithSubGenres ON AllGenresWithSubGenres.ChildId = G.Parent_Id
)

SELECT * FROM AllGenresWithSubGenres

GO 
ALTER TABLE ScheduleItem
ADD IsDeleted BIT 
GO
UPDATE ScheduleItem
SET IsDeleted = 0
WHERE Id_ScheduleItem > 0

GO
ENABLE TRIGGER CustomScheduleItemDelete ON ScheduleItem

GO
DECLARE @SuccessfulOrder BIT
EXEC MakeOrder 'Dima Kirieiev','sdfsdf',2,4,220,@SuccessfulOrder OUTPUT
PRINT(@SuccessfulOrder)

GO
SELECT * FROM MovieWithShortDescription

