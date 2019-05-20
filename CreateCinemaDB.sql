CREATE DATABASE Cinema_DimaKireiev
GO


USE Cinema_DimaKireiev
GO

CREATE TABLE Hall
(
	Id_Hall INT IDENTITY(1,1) PRIMARY KEY,
	Name_Hall NVARCHAR(100) NOT NULL,
	PlaceCount INT CHECK(PlaceCount > 1) 
)

CREATE TABLE Place
(
	Id_Place INT IDENTITY(1,1) PRIMARY KEY,
	TypePlace TINYINT NOT NULL,
	Price MONEY NOT NULL CHECK(Price > 0),
	Id_Hall INT REFERENCES Hall(Id_Hall) NOT NULL
)

CREATE TABLE Movie
(
	Id_Movie INT IDENTITY(1,1) PRIMARY KEY,
	Name_Movie NVARCHAR(300) NOT NULL,
	Duration TIME NOT NULL,
	Description NVARCHAR(1000) NOT NULL,
)


CREATE TABLE Genre
(
	Id_Genre INT PRIMARY KEY,
	Name_Genre NVARCHAR(300) NOT NULL,
	Parent_Id INT REFERENCES Genre(Id_Genre),
	Id_Movie INT REFERENCES Movie(Id_Movie)
)


GO
ALTER TABLE Movie
ADD CONSTRAINT UQ_Name_Movie UNIQUE(Name_Movie)
GO

CREATE TABLE DeliveryMovieMethod
(
	Id_Movie INT REFERENCES Movie(Id_Movie),
	DeliveryMethod NVARCHAR(10),
	PRIMARY KEY(Id_Movie,DeliveryMethod)
)

CREATE TABLE ScheduleItem
(
	Id_ScheduleItem INT IDENTITY(1,1) PRIMARY KEY,
 	Id_Hall INT REFERENCES Hall(Id_Hall) NOT NULL,
	Id_Movie INT REFERENCES Movie(Id_Movie) NOT NULL,
	StartDate DATETIME NOT NULL 
)

CREATE TABLE TicketsOrder
(
	Id_TicketsOrder INT IDENTITY(1,1) PRIMARY KEY, 
	CustomerName NVARCHAR(200),
	CustomerPhone NVARCHAR(30)
)

CREATE TABLE Ticket
(
	TicketNumber INT IDENTITY(1,1) UNIQUE, 
	Id_Place INT REFERENCES Place(Id_Place),
	Id_TicketsOrder INT REFERENCES TicketsOrder(Id_TicketsOrder),
	Id_ScheduleItem INT REFERENCES ScheduleItem(Id_ScheduleItem),
	PRIMARY KEY(Id_Place,Id_ScheduleItem)
)

GO 

INSERT INTO Hall(Name_Hall,PlaceCount) VALUES
('Red',50),
('Blue',70),
('Yellow',20),
('Green',100)
GO 



/*
  TypePlace values :
		1 -> First pay zone(1-3 row)
		2 -> Expensive zone
		3 -> Cheapest zone

*/
CREATE PROCEDURE AddPlacesInHall
    @TypePlaceInHalls TINYINT,
    @IdHall INT,
    @CountPlace INT,
    @PriceForPlace MONEY
AS
DECLARE @Index iNT;
SET @Index = 0;
WHILE @Index < @CountPlace
BEGIN
	INSERT INTO Place(TypePlace,Price,Id_Hall) VALUES (@TypePlaceInHalls,@PriceForPlace,@IdHall)
	SET @Index = @Index + 1;
END

/* ADD PLACES IN FIRST HALL */
GO
EXEC AddPlacesInHall 1,1,20,120

GO
EXEC AddPlacesInHall 2,1,15,200

GO
EXEC AddPlacesInHall 3,1,15,200


/* ADD PLACES IN SECOND HALL */
GO
EXEC AddPlacesInHall 1,2,25,120

GO
EXEC AddPlacesInHall 2,2,20,200

GO
EXEC AddPlacesInHall 3,2,25,200


/* ADD PLACES IN THIRD HALL */
GO
EXEC AddPlacesInHall 1,3,5,120

GO
EXEC AddPlacesInHall 2,3,10,200

GO
EXEC AddPlacesInHall 3,3,5,200


/* ADD PLACES IN FOURTH HALL */
GO
EXEC AddPlacesInHall 1,4,30,120

GO
EXEC AddPlacesInHall 2,4,50,200

GO
EXEC AddPlacesInHall 3,4,20,200

GO
INSERT INTO Movie(Name_Movie,Duration,Description) VALUES
('John Wick: Chapter 3','02:30:00','After gunning down a member of the High Table -- the shadowy international assassins guild -- legendary hit man John Wick finds himself stripped of the organizations protective services.'),
('Pokémon Detective Pikachu','03:00:00','Ace detective Harry Goodman goes mysteriously missing, prompting his 21-year-old son, Tim, to find out what happened. Aiding in the investigation is Harrys former Pokémon partner, wise-cracking, adorable super-sleuth Detective Pikachu.'),
('Avengers: Endgame','01:40:00','Adrift in space with no food or water, Tony Stark sends a message to Pepper Potts as his oxygen supply starts to dwindle'),
('The Hustle','02:00:00','Josephine Chesterfield is a glamorous, seductive British woman who has a penchant for defrauding gullible men out of their money.')


GO
INSERT INTO Genre(Id_Genre,Name_Genre,Id_Movie) VALUES(1,'Drama',1)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(2,'Melodrama',1,NULL)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES (3,'Drama comedy',1,1)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(4,'Turkish melodrama',2,NULL)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(5,'Russian melodrama',2,NULL)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(6,'Turkish melodrama about the Sultan',4,NULL)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(7,'Tragicomedy',3,NULL)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(8,'Fantasy',NULL,2)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(9,'Tail',8,3)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(10,'Black fantasy',8,NULL)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(11,'Action movie',NULL,4)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(12,'Action hollywood',11,4)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(13,'Comedy',NULL,2)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(14,'Black comedy',13,NULL)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(15,'Parody',13,NULL)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(16,'Family comedy',13,2)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id,Id_Movie) VALUES(17,'Adult comedy',13,NULL)



GO 
INSERT INTO DeliveryMovieMethod VALUES
(1,'2D'),
(1,'3D'),
(2,'2D'),
(3,'2D'),
(3,'3D'),
(4,'2D')

 


GO 
INSERT INTO ScheduleItem(Id_Hall,Id_Movie,StartDate) VALUES
(1,1,'2019-05-18 12:35:00'),
(2,1,'2019-05-18 19:35:00'),
(3,1,'2019-05-18 22:35:00'),
(4,1,'2019-05-18 9:00:00'),
(3,2,'2019-05-22 12:35:00'),
(4,2,'2019-05-26 19:35:00'),
(1,3,'2019-05-18 12:35:00'),
(2,3,'2019-05-18 19:35:00'),
(3,3,'2019-05-18 22:35:00'),
(4,3,'2019-05-18 9:00:00'),
(1,3,'2019-05-18 10:35:00'),
(2,3,'2019-05-18 17:35:00'),
(3,3,'2019-05-15 20:35:00'),
(4,3,'2019-05-18 11:00:00'),
(1,3,'2019-05-21 21:35:00'),
(2,3,'2019-05-28 10:35:00'),
(3,3,'2019-05-27 17:35:00'),
(4,3,'2019-05-26 19:00:00'),
(1,4,'2019-05-30 12:35:00'),
(4,4,'2019-05-30 19:35:00')



GO
INSERT INTO TicketsOrder(CustomerName,CustomerPhone) VALUES
('Den Shvayger',NULL),
('Asuyh Nashd',NULL),
('Aswrf Ssdgfs',NULL),
('Ngjlsfh flskdj',NULL),
('SDPAfu sdg',NULL)

GO 
INSERT INTO Ticket(Id_ScheduleItem,Id_Place,Id_TicketsOrder) VALUES
(1,1,1),
(7,1,1),
(11,1,1),
(15,1,1),
(19,1,1),
(1,2,2),
(7,2,2),
(11,2,2),
(15,2,3),
(11,33,4),
(15,33,5),
(19,34,3),
(2,68,4),
(12,65,5),
(16,67,1),
(8,67,1),
(8,68,2),
(12,68,3),
(8,65,4)

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
CREATE TRIGGER CustomScheduleItemDelete
ON ScheduleItem
INSTEAD OF DELETE
AS
UPDATE ScheduleItem
SET IsDeleted = 1
WHERE ScheduleItem.Id_ScheduleItem =(SELECT deleted.Id_ScheduleItem FROM deleted)

GO
CREATE VIEW MovieWithShortDescription AS
SELECT Id_Movie,Name_Movie,Duration,SUBSTRING(Movie.Description, 1, 20) + '...' AS ShortDescription 
FROM Movie WHERE Movie.Description IS NOT NULL
UNION
SELECT Id_Movie,Name_Movie,Duration,'No - description' AS ShortDescription 
FROM Movie WHERE Movie.Description IS NULL
