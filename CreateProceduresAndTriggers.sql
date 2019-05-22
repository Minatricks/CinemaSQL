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
