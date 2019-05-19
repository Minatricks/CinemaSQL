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

CREATE TABLE Genre
(
	Id_Genre INT PRIMARY KEY,
	Name_Genre NVARCHAR(300) NOT NULL,
	Parent_Id INT REFERENCES Genre(Id_Genre)
)

CREATE TABLE Movie
(
	Id_Movie INT IDENTITY(1,1) PRIMARY KEY,
	Name_Movie NVARCHAR(300) NOT NULL,
	Duration TIME NOT NULL,
	Description NVARCHAR(1000) NOT NULL,
	Id_Genre INT REFERENCES Genre(Id_Genre) NOT NULL
)

CREATE TABLE DeliveryMovieMethod
(
	Id_Movie INT REFERENCES Movie(Id_Movie),
	IsMovie3D BIT,
	PRIMARY KEY(Id_Movie,IsMovie3D)
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
INSERT INTO Genre(Id_Genre,Name_Genre) VALUES(1,'Drama')
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(2,'Melodrama',1)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES (3,'Drama comedy',1)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(4,'Turkish melodrama',2)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(5,'Russian melodrama',2)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(6,'Turkish melodrama about the Sultan',4)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(7,'Tragicomedy',3)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(8,'Fantasy',NULL)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(9,'Tail',8)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(10,'Black fantasy',8)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(11,'Action movie',NULL)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(12,'Action hollywood',11)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(13,'Comedy',NULL)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(14,'Black comedy',13)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(15,'Parody',13)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(16,'Family comedy',13)
INSERT INTO Genre(Id_Genre,Name_Genre,Parent_Id) VALUES(17,'Adult comedy',13)


GO
INSERT INTO Movie(Name_Movie,Duration,Description,Id_Genre) VALUES
('John Wick: Chapter 3','02:30:00','After gunning down a member of the High Table -- the shadowy international assassins guild -- legendary hit man John Wick finds himself stripped of the organizations protective services.',12),
('Pokémon Detective Pikachu','03:00:00','Ace detective Harry Goodman goes mysteriously missing, prompting his 21-year-old son, Tim, to find out what happened. Aiding in the investigation is Harrys former Pokémon partner, wise-cracking, adorable super-sleuth Detective Pikachu.',13)

