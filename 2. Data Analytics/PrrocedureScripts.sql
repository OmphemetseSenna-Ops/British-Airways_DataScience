


------------------------------------------------------------------------------ Procedure 1
----CREATE TABLE [Traveller Review Counts] (
----    [Traveller Type] NVARCHAR(100),
----    [Traveller Count] INT,
----    PRIMARY KEY ([Traveller Type])
----);

----CREATE PROCEDURE PopulateTravellerReviewCounts
----AS
----BEGIN
----    -- Clear the table for fresh data
----    TRUNCATE TABLE [Traveller Review Counts];

----    -- Insert the latest review counts into the table
----    INSERT INTO [Traveller Review Counts] ([Traveller Type], [Traveller Count])
----    SELECT 
----        t.[Traveller Type], 
----        COUNT(*) AS TravellerCount
----    FROM 
----        [Authur Reviews] r
----    JOIN 
----        Travellers t ON r.TravellerID = t.TravellerID
----    GROUP BY 
----        t.[Traveller Type];
----END;

----EXEC PopulateTravellerReviewCounts;





----------------------------------------------------------------------------- Procedure 2

------ Seat Ratings Analysis
----CREATE TABLE [Average Seat Ratings] (
----    [Seat Type] NVARCHAR(100),
----    [Average Seat Comfort] FLOAT,
----    [Rating Count] INT
----);

----CREATE PROCEDURE InsertAverageSeatRatings
----AS
----BEGIN
----    -- Clear existing data in the AvgSeatRatings table
----    TRUNCATE TABLE [Average Seat Ratings];

----    -- Insert the average seat ratings into the AvgSeatRatings table
----    INSERT INTO [Average Seat Ratings] ([Seat Type], [Average Seat Comfort], [Rating Count])
----    SELECT 
----        s.[Seat Type],
----        AVG(fr.[Seat Comfort]) AS AvgSeatComfort,
----        COUNT(fr.FlightRatingID) AS RatingCount
----    FROM 
----        Seats s
----    LEFT JOIN 
----        [Authur Reviews] r ON s.SeatID = r.SeatID
----    LEFT JOIN 
----        [Flight Ratings] fr ON r.FlightID = fr.FlightID
----    GROUP BY 
----        s.[Seat Type];
----END;

----EXEC InsertAverageSeatRatings;

----Chart Type: Use a bar chart or column chart.
----Axis: Set the SeatType on the X-axis.
----Values: Set AvgSeatComfort for the Y-axis to visualize the average comfort score per seat type.




----------------------------------------------------------------------------- Procedure 3
----Yearly Review Counts
--CREATE TABLE [Yearly Review Counts] (
--    [Review Year] INT PRIMARY KEY,
--    [Review Count] INT
--);

--CREATE PROCEDURE [Yearly Review Counts]
--AS
--BEGIN
--    -- Clear previous data in the table to start fresh
--    TRUNCATE TABLE YearlyReviewCounts;

--    -- Insert aggregated yearly review counts into the table
--    INSERT INTO [Yearly Review Counts] ([Review Year], [Review Count])
--    SELECT 
--        YEAR(r.[Review Date]) AS ReviewYear,
--        COUNT(r.ReviewID) AS ReviewCount
--    FROM 
--        [Authur Reviews] r
--    GROUP BY 
--        YEAR(r.[Review Date])
--    ORDER BY 
--        ReviewYear;
--END;

--EXEC PopulateYearlyReviewCounts;

----Axis: ReviewYear
----Values: ReviewCount
----Chart Type: Bar Chart or Column Chart






----------------------------------------------------------------------------- Procedure 4
----Non-Recommendation Counts
--CREATE TABLE [Yearly Non-Recommended Counts] (
--    [Review Year] INT PRIMARY KEY,
--    [Non-Recommended Count] INT
--);

--CREATE PROCEDURE PopulateYearlyNonRecommendedCounts
--AS
--BEGIN
--    -- Clear previous data in the table to start fresh
--    TRUNCATE TABLE [Yearly Non-Recommended Counts];

--    -- Insert aggregated yearly non-recommendation counts into the table
--    INSERT INTO [Yearly Non-Recommended Counts] ([Review Year], [Non-Recommended Count])
--    SELECT 
--        YEAR(r.[Review Date]) AS ReviewYear,
--        COUNT(fr.FlightRatingID) AS NonRecommendedCount
--    FROM 
--        [Authur Reviews] r
--    INNER JOIN 
--        [Flight Ratings] fr ON r.FlightID = fr.FlightID
--    WHERE 
--        fr.[Recommended Service] = 'No'
--    GROUP BY 
--        YEAR(r.[Review Date])
--    ORDER BY 
--        ReviewYear;
--END;


----------------------------------------------------------------------------- Procedure 5
----Non-Recommendation Counts
--CREATE TABLE [Yearly Recommended Counts] (
--    [Review Year] INT PRIMARY KEY,
--    [Recommended Count] INT
--);

--CREATE PROCEDURE PopulateYearlyRecommendedCounts
--AS
--BEGIN
--    -- Clear previous data in the table to start fresh
--    TRUNCATE TABLE [Yearly Recommended Counts];

--    -- Insert aggregated yearly non-recommendation counts into the table
--    INSERT INTO [Yearly Recommended Counts] ([Review Year], [Recommended Count])
--    SELECT 
--        YEAR(r.[Review Date]) AS ReviewYear,
--        COUNT(fr.FlightRatingID) AS RecommendedCount
--    FROM 
--        [Authur Reviews] r
--    INNER JOIN 
--        [Flight Ratings] fr ON r.FlightID = fr.FlightID
--    WHERE 
--        fr.[Recommended Service] = 'Yes'
--    GROUP BY 
--        YEAR(r.[Review Date])
--    ORDER BY 
--        ReviewYear;
--END;

--EXEC PopulateYearlyRecommendedCounts;
----Axis: ReviewYear
----Values: RecommendedCount
----Chart Type: Column Chart or Bar Chart



----------------------------------------------------------------------------- Procedure 6
---- Recent Non-Recommendation Counts
--CREATE TABLE [Recent Non-Recommended Counts] (
--    Period VARCHAR(20) PRIMARY KEY,  -- e.g., 'Last 3 Months'
--    [Non-Recommended Count] INT
--);

--CREATE PROCEDURE PopulateRecentNonRecommendedCounts
--AS
--BEGIN
--    -- Clear previous data in the table to start fresh
--    TRUNCATE TABLE [Recent Non-Recommended Counts];

--    -- Insert count of non-recommendations in the past 3 months
--    INSERT INTO [Recent Non-Recommended Counts] (Period, [Non-Recommended Count])
--    SELECT 
--        'Last 3 Months' AS Period,
--        COUNT(fr.FlightRatingID) AS NonRecommendedCount
--    FROM 
--        [Authur Reviews] r
--    INNER JOIN 
--        [Flight Ratings] fr ON r.FlightID = fr.FlightID
--    WHERE 
--        fr.[Recommended Service] = 'No'
--        AND r.[Review Date] >= DATEADD(MONTH, -3, GETDATE()); -- Last 3 months
--END;

--EXEC PopulateRecentNonRecommendedCounts;

----Category: Period
----Values: NonRecommendedCount
----Chart Type: Card or Single Value to show the count directly.




--CREATE TABLE [Recent Recommended Counts] (
--    Period VARCHAR(20) PRIMARY KEY,  -- e.g., 'Last 3 Months'
--    [Recommended Count] INT
--);



--CREATE PROCEDURE PopulateRecentRecommendedCounts
--AS
--BEGIN
--    -- Clear previous data in the table to start fresh
--    TRUNCATE TABLE [Recent Recommended Counts];

--    -- Insert count of non-recommendations in the past 3 months
--    INSERT INTO [Recent Recommended Counts] (Period, [Recommended Count])
--    SELECT 
--        'Last 3 Months' AS Period,
--        COUNT(fr.FlightRatingID) AS RecommendedCount
--    FROM 
--        [Authur Reviews] r
--    INNER JOIN 
--        [Flight Ratings] fr ON r.FlightID = fr.FlightID
--    WHERE 
--        fr.[Recommended Service] = 'Yes'
--        AND r.[Review Date] >= DATEADD(MONTH, -3, GETDATE()); -- Last 3 months
--END;

--EXEC PopulateRecentRecommendedCounts;






















----------------------------------------------------------------------------- Procedure 7
---- year has the best services
--CREATE TABLE [Yearly Service Averages] (
--    [Average Review Date] INT PRIMARY KEY,
--    [Average Seat Comfort] FLOAT,
--    [Average Cabin Staff Service] FLOAT,
--    [Average Food And Beverages] FLOAT,
--    [Average Inflight Entertainment] FLOAT,
--    [Average Ground Service] FLOAT,
--    [Average Value For Money] FLOAT
--);


--CREATE PROCEDURE PopulateYearlyServiceAverages
--AS
--BEGIN
--    -- Clear previous data in the table to start fresh
--    TRUNCATE TABLE [Yearly Service Averages];

--    -- Insert yearly averages for service ratings into the table
--    INSERT INTO YearlyServiceAverages ([Average Review Date], [Average Seat Comfort], [Average Cabin Staff Service], [Average Food And Beverages], [Average Inflight Entertainment], [Average Ground Service], [Average Value For Money])
--    SELECT 
--        YEAR(r.[Review Date]) AS ReviewYear,
--        AVG(fr.[Seat Comfort]) AS AverageSeatComfort,
--        AVG(fr.[Cabin Staff Service]) AS AverageCabinStaffService,
--        AVG(fr.[Food And Beverages]) AS AverageFoodAndBeverages,
--        AVG(fr.[Inflight Entertainment]) AS AverageInflightEntertainment,
--        AVG(fr.[Ground Service]) AS AverageGroundService,
--        AVG(fr.[Value For Money]) AS AverageValueForMoney
--    FROM 
--        [Authur Reviews] r
--    INNER JOIN 
--        [Flight Ratings] fr ON r.FlightID = fr.FlightID
--    GROUP BY 
--        YEAR(r.[Review Date])
--    ORDER BY 
--        ReviewYear;
--END;


--EXEC PopulateYearlyServiceAverages;


---- Overall Average Ratings by Year: Bar Chart

----Drag ReviewYear to the "Axis" field.
---- Create a measure for the Overall Average using DAX
---- Drag this measure to the "Values" field of the Bar Chart.

----OverallAverage = 
----(SUM(YearlyServiceAverages[AverageSeatComfort]) + 
-- --SUM(YearlyServiceAverages[AverageCabinStaffService]) + 
-- --SUM(YearlyServiceAverages[AverageFoodAndBeverages]) + 
-- --SUM(YearlyServiceAverages[AverageInflightEntertainment]) + 
-- --SUM(YearlyServiceAverages[AverageGroundService]) + 
-- --SUM(YearlyServiceAverages[AverageValueForMoney])) / 6



----------------------------------------------------------------------------- Procedure 8
---- last six months Averages

--CREATE TABLE [Monthly Service Averages] (
--    [Review Month] DATE PRIMARY KEY,
--    [Average Seat Comfort] FLOAT,
--    [Average Cabin Staff Service] FLOAT,
--    [Average Food And Beverages] FLOAT,
--    [Average Inflight Entertainment] FLOAT,
--    [Average Ground Service] FLOAT,
--    [Average Value For Money] FLOAT
--);


--CREATE PROCEDURE PopulateMonthlyServiceAverages
--AS
--BEGIN
--    -- Clear previous data in the table to start fresh
--    TRUNCATE TABLE [Monthly Service Averages];

--    -- Insert monthly averages for service ratings into the table for the last 6 months
--    INSERT INTO [Monthly Service Averages] ([Review Month], [Average Seat Comfort], [Average Cabin Staff Service], [Average Food And Beverages], [Average Inflight Entertainment], [Average Ground Service], [Average Value For Money])
--    SELECT 
--        DATEADD(MONTH, DATEDIFF(MONTH, 0, r.[Review Date]), 0) AS ReviewMonth,  -- First day of the month
--        AVG(fr.[Seat Comfort]) AS AverageSeatComfort,
--        AVG(fr.[Cabin Staff Service]) AS AverageCabinStaffService,
--        AVG(fr.[Food And Beverages]) AS AverageFoodAndBeverages,
--        AVG(fr.[Inflight Entertainment]) AS AverageInflightEntertainment,
--        AVG(fr.[Ground Service]) AS AverageGroundService,
--        AVG(fr.[Value For Money]) AS AverageValueForMoney
--    FROM 
--        [Authur Reviews] r
--    INNER JOIN 
--        [Flight Ratings] fr ON r.FlightID = fr.FlightID
--    WHERE 
--        r.[Review Date] >= DATEADD(MONTH, -6, GETDATE())  -- Last 6 months
--    GROUP BY 
--        DATEADD(MONTH, DATEDIFF(MONTH, 0, r.[Review Date]), 0)
--    ORDER BY 
--        ReviewMonth;
--END;

--EXEC PopulateMonthlyServiceAverages;

---- X-Axis: ReviewMonth 
---- Y-Axis: (AverageSeatComfort, AverageCabinStaffService, AverageFoodAndBeverages, AverageInflightEntertainment, AverageGroundService, AverageValueForMoney)
---- a line chart or bar chart


----------------------------------------------------------------------------- Procedure 9
----Route Service Averages

--CREATE TABLE RouteServiceAverages (
--    Route VARCHAR(255) PRIMARY KEY,
--    AverageSeatComfort FLOAT,
--    AverageCabinStaffService FLOAT,
--    AverageFoodAndBeverages FLOAT,
--    AverageInflightEntertainment FLOAT,
--    AverageGroundService FLOAT,
--    AverageValueForMoney FLOAT,
--    OverallServiceRating FLOAT  -- New column for overall service rating
--);

--CREATE PROCEDURE PopulateRouteServiceAverages
--AS
--BEGIN
--    -- Clear previous data in the table to start fresh
--    TRUNCATE TABLE RouteServiceAverages;

--    -- Insert route averages for service ratings, including overall rating
--    INSERT INTO RouteServiceAverages (Route, AverageSeatComfort, AverageCabinStaffService, AverageFoodAndBeverages, AverageInflightEntertainment, AverageGroundService, AverageValueForMoney, OverallServiceRating)
--    SELECT 
--        CONCAT(r.Origin, ' to ', r.Destination) AS Route,  -- Concatenate origin and destination
--        AVG(fr.[Seat Comfort]) AS AverageSeatComfort,
--        AVG(fr.[Cabin Staff Service]) AS AverageCabinStaffService,
--        AVG(fr.[Food And Beverages]) AS AverageFoodAndBeverages,
--        AVG(fr.[Inflight Entertainment]) AS AverageInflightEntertainment,
--        AVG(fr.[Ground Service]) AS AverageGroundService,
--        AVG(fr.[Value For Money]) AS AverageValueForMoney,
--        (
--            AVG(fr.[Seat Comfort]) + 
--            AVG(fr.[Cabin Staff Service]) + 
--            AVG(fr.[Food And Beverages]) + 
--            AVG(fr.[Inflight Entertainment]) + 
--            AVG(fr.[Ground Service]) + 
--            AVG(fr.[Value For Money])
--        ) / 6 AS OverallServiceRating  -- Calculate overall average
--    FROM 
--        [Flights] r
--    INNER JOIN 
--        [Flight Ratings] fr ON r.FlightID = fr.FlightID
--    GROUP BY 
--        r.Origin, r.Destination  -- Group by origin and destination
--    ORDER BY 
--        Route;
--END;

--EXEC PopulateRouteServiceAverages;


---- Create a New Measure
----Rank by Overall Service Rating =
----RANKX (
----    ALL ( RouteServiceAverages[OverallServiceRating] ),
----    RouteServiceAverages[OverallServiceRating],
----    DESC
----)



----------------------------------------------------------------------------- Procedure 10

----CREATE TABLE [3-Months Recommended Counts] (
----    Period VARCHAR(20) PRIMARY KEY,  -- e.g., 'Last 3 Months'
----    [Recommended Count] INT
----);



----CREATE PROCEDURE Populate3MonthsNonRecommendedCounts
----AS
----BEGIN
----    -- Clear previous data in the table to start fresh
----    TRUNCATE TABLE [3-Months Recommended Counts];

----    -- Insert count of non-recommendations in the past 3 months
----    INSERT INTO [3-Months Recommended Counts] (Period, [Recommended Count])
----    SELECT 
----		FORMAT(r.[Review Date], 'yyyy-MM') AS Period,
----		COUNT(fr.FlightRatingID) AS RecommendedCount
----	FROM 
----		[Authur Reviews] r
----	INNER JOIN 
----		[Flight Ratings] fr ON r.FlightID = fr.FlightID
----	WHERE 
----		fr.[Recommended Service] = 'Yes'
----		AND r.[Review Date] < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) -- skip this month
----		AND r.[Review Date] >= DATEADD(MONTH, -3, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) -- Last 3 full months
----	GROUP BY 
----		FORMAT(r.[Review Date], 'yyyy-MM')
----	ORDER BY 
----		FORMAT(r.[Review Date], 'yyyy-MM') DESC; -- Order by most recent
----END;

----EXEC Populate3MonthsNonRecommendedCounts;




----------------------------------------------------------------------------- Procedure 11

----CREATE TABLE [3-Months Non-Recommended Counts] (
----    Period VARCHAR(20) PRIMARY KEY,  -- e.g., 'Last 3 Months'
----    [Non-Recommended Count] INT
----);


----CREATE PROCEDURE Populate3MonthsRecommendedCounts
----AS
----BEGIN
----    -- Clear previous data in the table to start fresh
----    TRUNCATE TABLE [3-Months Non-Recommended Counts];

----    -- Insert count of non-recommendations in the past 3 months
----    INSERT INTO [3-Months Non-Recommended Counts] (Period, [Non-Recommended Count])
----    SELECT 
----		FORMAT(r.[Review Date], 'yyyy-MM') AS Period,
----		COUNT(fr.FlightRatingID) AS NonRecommendedCount
----	FROM 
----		[Authur Reviews] r
----	INNER JOIN 
----		[Flight Ratings] fr ON r.FlightID = fr.FlightID
----	WHERE 
----		fr.[Non-Recommended Count] = 'No'
----		AND r.[Review Date] < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) -- skip this month
----		AND r.[Review Date] >= DATEADD(MONTH, -3, DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) -- Last 3 full months
----	GROUP BY 
----		FORMAT(r.[Review Date], 'yyyy-MM')
----	ORDER BY 
----		FORMAT(r.[Review Date], 'yyyy-MM') DESC; -- Order by most recent
----END;

----EXEC Populate3MonthsRecommendedCounts;



----------------------------------------------------------------------------- Procedure 12
-- Recommended Flights Analysis

--CREATE TABLE [Recommended Flight Service Counts] (
--    [Recommended Service] VARCHAR(20) PRIMARY KEY,
--    [Recommended Flight Count] INT
--);

--CREATE PROCEDURE RecommendedFlightsAnalysis
--AS
--BEGIN

--	TRUNCATE TABLE [Recommended Flight Service Counts];
--    INSERT INTO [Recommended Flight Service Counts] ([Recommended Service], [Recommended Flight Count])
--    SELECT 
--        fr.[Recommended Service],
--        COUNT(fr.FlightRatingID) AS FlightCount
--    FROM 
--        [Flight Ratings] fr
--    GROUP BY 
--        fr.[Recommended Service]
--END;

--EXEC RecommendedFlightsAnalysis;





----------------------------------------------------------------------------- Procedure 13

--Author Review Count by Location
--CREATE TABLE [Author Review Count By Location] (
--    [Author Location] VARCHAR(200) PRIMARY KEY,
--    [Review Count] INT
--);



--CREATE PROCEDURE AuthorReviewCountByLocation
--AS
--BEGIN

--	TRUNCATE TABLE [Author Review Count By Location];
--    INSERT INTO [Author Review Count By Location] ([Author Location], [Review Count])

--    SELECT 
--        a.[Author Location],
--        COUNT(r.ReviewID) AS ReviewCount
--    FROM 
--        Authors a
--    INNER JOIN 
--        [Authur Reviews] r ON a.AuthorID = r.AuthorID
--    GROUP BY 
--        a.[Author Location];
--END;

--EXEC AuthorReviewCountByLocation









----------------------------------------------------------------------------- Procedure 14

------ Flight Performance By Origin And Destination


--CREATE TABLE [Flight Performance By Origin And Destination] (
--    Origin VARCHAR(255),
--	Destination VARCHAR(255),
--    [Average Seat Comfort] FLOAT,
--    [Average Cabin Staff Service] FLOAT,
--    [Average Food And Beverages] FLOAT,
--    [Average Inflight Entertainment] FLOAT,
--    [Average Ground Service] FLOAT,
--    [Average Value For Money] FLOAT,
--	[Overall Service Rating] FLOAT
--);



--CREATE PROCEDURE FlightPerformanceByOriginAndDestination
--AS
--BEGIN
--	TRUNCATE TABLE [Flight Performance By Origin And Destination];
--	INSERT INTO [Flight Performance By Origin And Destination] (Origin, Destination, [Average Seat Comfort], [Average Cabin Staff Service], [Average Food And Beverages], [Average Inflight Entertainment], [Average Ground Service], [Average Value For Money], [Overall Service Rating])
    
--	SELECT 
--        f.Origin,
--        f.Destination,
--        AVG(fr.[Seat Comfort]) AS AvgSeatComfort,
--        AVG(fr.[Cabin Staff Service]) AS AvgCabinStaffService,
--        AVG(fr.[Food And Beverages]) AS AvgFoodAndBeverages,
--        AVG(fr.[Inflight Entertainment]) AS AvgInflightEntertainment,
--        AVG(fr.[Ground Service]) AS AvgGroundService,
--        AVG(fr.[Value For Money]) AS AvgValueForMoney,
--		ROUND(((
--            AVG(fr.[Seat Comfort]) + 
--            AVG(fr.[Cabin Staff Service]) + 
--            AVG(fr.[Food And Beverages]) + 
--            AVG(fr.[Inflight Entertainment]) + 
--            AVG(fr.[Ground Service]) + 
--            AVG(fr.[Value For Money])
--        ) / 6), 2) AS OverallServiceRating  -- Calculate overall average
--    FROM 
--        Flights f
--    INNER JOIN 
--        [Flight Ratings] fr ON f.FlightID = fr.FlightID
--    GROUP BY 
--        f.Origin,
--        f.Destination;
--END;




---------------------------------------------------------------------------------------------SERVICES ANALYSIS
-- Most Satisfactory Service Analysis
--CREATE TABLE [Most Satisfactory Service Analysis] (
--    [Service Rating ID] INT PRIMARY KEY IDENTITY(1,1),
--    [Service Type] NVARCHAR(255),
--    [Avg Rating] FLOAT,
--    [Analysis Date] DATETIME DEFAULT GETDATE()
--);




--CREATE PROCEDURE InsertMostSatisfactoryServiceAnalysis
--AS
--BEGIN
--    -- Clear existing data if needed
--    DELETE FROM [Most Satisfactory Service Analysis];

--    -- Insert new analysis results
--    INSERT INTO [Most Satisfactory Service Analysis] ([Service Type], [Avg Rating])
--    SELECT 
--        'Cabin Staff Service' AS ServiceType, AVG(fr.[Cabin Staff Service]) AS AvgRating
--    FROM 
--        [Flight Ratings] fr
--    UNION ALL
--    SELECT 
--        'Food And Beverages', AVG(fr.[Food And Beverages])
--    FROM 
--        [Flight Ratings] fr 
--    UNION ALL
--    SELECT 
--        'Inflight Entertainment', AVG(fr.[Inflight Entertainment])
--    FROM 
--        [Flight Ratings] fr
--    UNION ALL
--    SELECT 
--        'Ground Service', AVG(fr.[Ground Service])
--    FROM 
--        [Flight Ratings] fr
--    UNION ALL
--    SELECT 
--        'Value For Money', AVG(fr.[Value For Money])
--    FROM 
--        [Flight Ratings] fr;
--END;


--EXEC InsertMostSatisfactoryServiceAnalysis;







---------------------------------------------------------------------------------------------SERVICES ANALYSIS

--CREATE TABLE [Flight Service Below Average Summary] (
--    SummaryID INT IDENTITY(1,1) PRIMARY KEY,
--    [Count Rated Below 5] INT,
--    [Avg Cabin Staff Service] DECIMAL(3,2),
--    [Avg Food And Beverages] DECIMAL(3,2),
--    [Avg Inflight Entertainment] DECIMAL(3,2),
--    [Avg Ground Service] DECIMAL(3,2),
--    [Avg Value For Money] DECIMAL(3,2),
--    [Record Date] DATETIME DEFAULT GETDATE()
--);


--CREATE TABLE [Flight Service Above Average Summary] (
--    SummaryID INT IDENTITY(1,1) PRIMARY KEY,
--    [Count Rated Above 5] INT,
--    [Avg Cabin Staff Service] DECIMAL(3,2),
--    [Avg Food And Beverages] DECIMAL(3,2),
--    [Avg Inflight Entertainment] DECIMAL(3,2),
--    [Avg Ground Service] DECIMAL(3,2),
--    [Avg Value For Money] DECIMAL(3,2),
--    [Record Date] DATETIME DEFAULT GETDATE()
--);




--DELETE FROM [Flight Service Above Average Summary];

--CREATE PROCEDURE InsertFlightRatingCounts
--AS
--BEGIN
--    -- Declare variables to hold counts and averages
--    DECLARE @CountRatedAbove5 INT;
--    DECLARE @AvgCabinStaffServices DECIMAL(3,2), @AvgFoodAndBeverages DECIMAL(3,2);
--    DECLARE @AvgInflightEntertainments DECIMAL(3,2), @AvgGroundServices DECIMAL(3,2);
--    DECLARE @AvgValueForMoneys DECIMAL(3,2);

--	DECLARE @CountRatedBelow5 INT;
--    DECLARE @AvgCabinStaffService DECIMAL(3,2), @AvgFoodAndBeverage DECIMAL(3,2);
--    DECLARE @AvgInflightEntertainment DECIMAL(3,2), @AvgGroundService DECIMAL(3,2);
--    DECLARE @AvgValueForMoney DECIMAL(3,2);

--    -- Calculate counts and averages for ratings above 5
--    SELECT 
--        @CountRatedAbove5 = COUNT(f.FlightID),
--        @AvgCabinStaffServices = AVG(fr.[Cabin Staff Service]),
--        @AvgFoodAndBeverages = AVG(fr.[Food And Beverages]),
--        @AvgInflightEntertainments = AVG(fr.[Inflight Entertainment]),
--        @AvgGroundServices = AVG(fr.[Ground Service]),
--        @AvgValueForMoneys = AVG(fr.[Value For Money])
--    FROM 
--        Flights f
--    JOIN 
--        [Flight Ratings] fr ON f.FlightID = fr.FlightID
--    WHERE 
--        fr.[Cabin Staff Service] >= 5 AND
--        fr.[Food And Beverages] >= 5 AND
--        fr.[Inflight Entertainment] >= 5 AND
--        fr.[Ground Service] >= 5 AND
--        fr.[Value For Money] >= 5;

--    -- Calculate counts and averages for ratings below 5
--    SELECT 
--        @CountRatedBelow5 = COUNT(f.FlightID),
--        @AvgCabinStaffService = AVG(fr.[Cabin Staff Service]),
--        @AvgFoodAndBeverage = AVG(fr.[Food And Beverages]),
--        @AvgInflightEntertainment = AVG(fr.[Inflight Entertainment]),
--        @AvgGroundService = AVG(fr.[Ground Service]),
--        @AvgValueForMoney = AVG(fr.[Value For Money])
--    FROM 
--        Flights f
--    JOIN 
--        [Flight Ratings] fr ON f.FlightID = fr.FlightID
--    WHERE 
--        fr.[Cabin Staff Service] < 5 AND
--        fr.[Food And Beverages] < 5 AND
--        fr.[Inflight Entertainment] < 5 AND
--        fr.[Ground Service] < 5 AND
--        fr.[Value For Money] < 5;

--    -- Insert the gathered information into the FlightRatingSummary table
--    INSERT INTO [Flight Service Above Average Summary] 
--        ([Count Rated Above 5], [Avg Cabin Staff Service],
--         [Avg Food And Beverages], [Avg Inflight Entertainment], 
--         [Avg Ground Service], [Avg Value For Money])
--    VALUES 
--        (@CountRatedAbove5, 
--         @AvgCabinStaffServices, @AvgFoodAndBeverages, 
--         @AvgInflightEntertainments, @AvgGroundServices, 
--         @AvgValueForMoneys);

--	-- Insert the gathered information into the FlightRatingSummary table
--    INSERT INTO [Flight Service Below Average Summary] 
--        ([Count Rated Below 5], [Avg Cabin Staff Service],
--         [Avg Food And Beverages], [Avg Inflight Entertainment], 
--         [Avg Ground Service], [Avg Value For Money])
--    VALUES 
--        (@CountRatedBelow5, 
--         @AvgCabinStaffService, @AvgFoodAndBeverage, 
--         @AvgInflightEntertainment, @AvgGroundService, 
--         @AvgValueForMoney);

--END;




--EXEC InsertFlightRatingCounts;










--CREATE TABLE [Flight Service Below Average Data] (
--    [Summary ID] INT IDENTITY(1,1) PRIMARY KEY,
--    [Flight] INT,
--	Origin VARCHAR(250),
--	Destination VARCHAR(250),
--    [Avg Cabin Staff Service] DECIMAL(3,2),
--    [Avg Food And Beverages] DECIMAL(3,2),
--    [Avg Inflight Entertainment] DECIMAL(3,2),
--    [Avg Ground Service] DECIMAL(3,2),
--    [Avg Value For Money] DECIMAL(3,2),
--    [Record Date] DATETIME DEFAULT GETDATE()
--);


--CREATE TABLE [Flight Service Above Average Data] (
--    [Summary ID] INT IDENTITY(1,1) PRIMARY KEY,
--    [Flight] INT,
--	Origin VARCHAR(250),
--	Destination VARCHAR(250),
--    [Avg Cabin Staff Service] DECIMAL(3,2),
--    [Avg Food And Beverages] DECIMAL(3,2),
--    [Avg Inflight Entertainment] DECIMAL(3,2),
--    [Avg Ground Service] DECIMAL(3,2),
--    [Avg Value For Money] DECIMAL(3,2),
--    [Record Date] DATETIME DEFAULT GETDATE()
--);


--CREATE PROCEDURE WorstPerformingFlightsByService
--AS
--BEGIN

--    DELETE FROM [Flight Service Below Average Data];

--    -- Insert new data into the [Flight Service Below Average Data] table
--    INSERT INTO [Flight Service Below Average Data] ([Flight],Origin, Destination, [Avg Cabin Staff Service], [Avg Food And Beverages], [Avg Inflight Entertainment], [Avg Ground Service], [Avg Value For Money])
--    SELECT TOP 10
--        f.FlightID,
--        f.Origin,
--        f.Destination,
--        AVG(fr.[Cabin Staff Service]) AS AvgCabinStaffService,
--        AVG(fr.[Food And Beverages]) AS AvgFoodAndBeverages,
--        AVG(fr.[Inflight Entertainment]) AS AvgInflightEntertainment,
--        AVG(fr.[Ground Service]) AS AvgGroundService,
--        AVG(fr.[Value For Money]) AS AvgValueForMoney
--    FROM 
--        Flights f
--    JOIN 
--        [Flight Ratings] fr ON f.FlightID = fr.FlightID
--    GROUP BY 
--        f.FlightID, f.Origin, f.Destination
--    HAVING 
--        AVG(fr.[Cabin Staff Service]) < 5 AND
--        AVG(fr.[Food And Beverages]) < 5 AND
--        AVG(fr.[Inflight Entertainment]) < 5 AND
--        AVG(fr.[Ground Service]) < 5 AND
--        AVG(fr.[Value For Money]) < 5
--    ORDER BY 
--        AvgCabinStaffService, AvgFoodAndBeverages, AvgInflightEntertainment, AvgGroundService, AvgValueForMoney;
--END;

--EXEC WorstPerformingFlightsByService



--CREATE PROCEDURE BestPerformingFlightsByService
--AS
--BEGIN

--    DELETE FROM [Flight Service Above Average Data];

--    -- Insert new data into the [Flight Service Above Average Data] table
--    INSERT INTO [Flight Service Above Average Data] ([Flight],Origin, Destination, [Avg Cabin Staff Service], [Avg Food And Beverages], [Avg Inflight Entertainment], [Avg Ground Service], [Avg Value For Money])
--    SELECT TOP 10
--        f.FlightID,
--        f.Origin,
--        f.Destination,
--        AVG(fr.[Cabin Staff Service]) AS AvgCabinStaffService,
--        AVG(fr.[Food And Beverages]) AS AvgFoodAndBeverages,
--        AVG(fr.[Inflight Entertainment]) AS AvgInflightEntertainment,
--        AVG(fr.[Ground Service]) AS AvgGroundService,
--        AVG(fr.[Value For Money]) AS AvgValueForMoney
--    FROM 
--        Flights f
--    JOIN 
--        [Flight Ratings] fr ON f.FlightID = fr.FlightID
--    GROUP BY 
--        f.FlightID, f.Origin, f.Destination
--    HAVING 
--        AVG(fr.[Cabin Staff Service]) >= 5 AND
--        AVG(fr.[Food And Beverages]) >= 5 AND
--        AVG(fr.[Inflight Entertainment]) >= 5 AND
--        AVG(fr.[Ground Service]) >= 5 AND
--        AVG(fr.[Value For Money]) >= 5
--    ORDER BY 
--        AvgCabinStaffService, AvgFoodAndBeverages, AvgInflightEntertainment, AvgGroundService, AvgValueForMoney;
--END;

--EXEC BestPerformingFlightsByService