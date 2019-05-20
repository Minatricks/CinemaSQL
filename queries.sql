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
--Select movies that have more than two genres
SELECT COUNT(Id_Genre) AS CountGenresInMovie,Name_Movie FROM 
Movie INNER JOIN Genre ON Movie.Id_Movie = Genre.Id_Movie
GROUP BY Name_Movie
HAVING COUNT(Id_Genre) > 1

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

SELECT Name_Movie,CONVERT(VARCHAR,(SUM(Price)/@AllProfit)*100) + ' %' AS profitabilityLastMonth 
FROM Place JOIN Ticket ON Place.Id_Place = Ticket.Id_Place
JOIN ScheduleItem ON Ticket.Id_ScheduleItem = ScheduleItem.Id_ScheduleItem
JOIN Movie ON ScheduleItem.Id_Movie = Movie.Id_Movie
WHERE (MONTH(GETDATE()) - 1) = MONTH(StartDate)
GROUP BY Name_Movie
 

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
CREATE TRIGGER CustomScheduleItemDelete
ON ScheduleItem
INSTEAD OF DELETE
AS
UPDATE ScheduleItem
SET IsDeleted = 1
WHERE ScheduleItem.Id_ScheduleItem =(SELECT deleted.Id_ScheduleItem FROM deleted)

GO
ENABLE TRIGGER CustomScheduleItemDelete ON ScheduleItem

GO
CREATE PROCEDURE MakeOrder 
	@Name NVARCHAR(100),
	@Phone NVARCHAR(20),
	@ScheduleItemId INT,
	@IdHall INT,
	@IdPlace INT,
	@SuccessfulOrder BIT OUTPUT
AS 
SET @SuccessfulOrder = 0
DECLARE @IdOrder INT;
IF ( @IdHall = (SELECT TOP 1 @IdHall FROM Place WHERE Id_Place = @IdPlace) )
	BEGIN
	IF( @IdPlace = (SELECT TOP 1 Id_Place FROM Ticket WHERE Id_ScheduleItem = @ScheduleItemId))
		 PRINT('EROR There is place booked in this hall.');
	ELSE
		BEGIN
		INSERT INTO TicketsOrder(CustomerName,CustomerPhone) VALUES(@Name,@Phone)
		SET @IdOrder = (SELECT TOP 1 Id_TicketsOrder FROM TicketsOrder ORDER BY Id_TicketsOrder DESC)
		INSERT INTO Ticket(Id_Place,Id_TicketsOrder,Id_ScheduleItem) VALUES (@IdPlace,@IdOrder,@ScheduleItemId)
		SET @SuccessfulOrder = 1
		PRINT('Your order has been successfully created.')
		END
	END
ELSE PRINT('EROR There is no such place in this hall.');
	 
GO
DECLARE @SuccessfulOrder BIT
EXEC MakeOrder 'Dima Kirieiev','sdfsdf',2,4,220,@SuccessfulOrder OUTPUT
PRINT(@SuccessfulOrder)

GO
CREATE VIEW MovieWithShortDescription AS
SELECT Id_Movie,Name_Movie,Duration,SUBSTRING(Movie.Description, 1, 20) + '...' AS ShortDescription 
FROM Movie

GO
SELECT * FROM MovieWithShortDescription


