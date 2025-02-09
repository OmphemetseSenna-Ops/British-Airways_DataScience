

USE BritishAirwaysDB;

GO

CREATE PROCEDURE InsertUniqueReview
AS
BEGIN
    -- Create a new table to hold unique reviews if it doesn't already exist
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'UniqueReviews')
    BEGIN
        CREATE TABLE UniqueReviews (
            Id INT PRIMARY KEY IDENTITY(1,1),
            [Rating] FLOAT,
            [Author] NVARCHAR(255),
            [Author Location] NVARCHAR(255),
            [Review Date] DATETIME,
            [Review Title] NVARCHAR(255),
            [Review] NVARCHAR(MAX),
            [Type Of Traveller] NVARCHAR(255),
            [Seat Type] NVARCHAR(255),
            [Route] NVARCHAR(255),
            [Date Flown] DATETIME,
            [Seat Comfort] FLOAT,
            [Cabin Staff Service] FLOAT,
            [Food And Beverages] FLOAT,
            [Inflight Entertainment] FLOAT,
            [Ground Service] FLOAT,
            [Value For Money] INT,
            [Recommended Service] NVARCHAR(255)
        );
    END

    INSERT INTO UniqueReviews (Rating, Author, [Author Location], [Review Date], [Review Title], [Review], [Type Of Traveller], 
	[Seat Type], [Route], [Date Flown], [Seat Comfort], [Cabin Staff Service], [Food And Beverages], [Inflight Entertainment], 
	[Ground Service], [Value For Money], [Recommended Service])
    SELECT 
        Rating, Author, [Author Location], [Review Date], [Review Title], [Review], [Type Of Traveller], [Seat Type], 
		[Route], [Date Flown], [Seat Comfort], [Cabin Staff Service], [Food And Beverages], [Inflight Entertainment], 
		[Ground Service], [Value For Money], [Recommended Service]
    FROM (
        SELECT 
            *, 
            ROW_NUMBER() OVER (PARTITION BY Rating, Author, [Review Date], [Review Title] ORDER BY Id) AS RowNum
        FROM 
            Reviews
    ) AS CTE
    WHERE RowNum = 1; 
END;

EXEC InsertUniqueReviews