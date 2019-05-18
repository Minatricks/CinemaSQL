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
	Id_Genre INT IDENTITY(1,1) PRIMARY KEY,
	Name_Genre NVARCHAR(300) NOT NULL,
	Parent_Id INT REFERENCES Genre(Id_Genre)
)

CREATE TABLE Movie
(
	Id_Movie INT IDENTITY(1,1) PRIMARY KEY,
	Name_Movie NVARCHAR(300) NOT NULL,
	Duration TIME NOT NULL,
	Description NVARCHAR(1000) NOT NULL,
	Id_Hall INT REFERENCES Hall(Id_Hall) NOT NULL,
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



