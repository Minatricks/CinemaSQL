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
	@IdPlace INT
AS 
DECLARE @IdOrder INT;
BEGIN TRANSACTION;
	BEGIN TRY 
		INSERT INTO TicketsOrder(CustomerName,CustomerPhone) VALUES(@Name,@Phone)
		SET @IdOrder = (SELECT TOP 1 Id_TicketsOrder FROM TicketsOrder WHERE CustomerName = @Name AND CustomerPhone = @Phone)
			IF @IdOrder = 0 
				THROW 51000, 'The record does not exist.',11
		INSERT INTO Ticket(Id_Place,Id_TicketsOrder,Id_ScheduleItem) VALUES (@IdPlace,@IdOrder,@ScheduleItemId)
	END TRY

	BEGIN CATCH 
	 IF @@TRANCOUNT > 0  
        ROLLBACK TRANSACTION; 
	END CATCH
IF @@TRANCOUNT > 0  
    COMMIT TRANSACTION;  


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
