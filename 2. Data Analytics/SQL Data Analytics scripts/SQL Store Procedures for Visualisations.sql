CREATE PROCEDURE CreateOverallPerformanceTable
AS
BEGIN
    -- Step 1: Drop the table if it already exists
    IF OBJECT_ID('OverallPerformance', 'U') IS NOT NULL
        DROP TABLE OverallPerformance;

    -- Step 2: Create the new table for overall performance monitoring
    CREATE TABLE OverallPerformance (
        PerformanceID INT PRIMARY KEY IDENTITY(1,1),
        FlightID INT,
        Origin NVARCHAR(255),
        Destination NVARCHAR(255),
        Routes NVARCHAR(500),
        DateFlown DATE,
        TotalReviews INT,
        AverageRating FLOAT,
        PercentageRecommended FLOAT,
        AverageSeatComfort FLOAT,
        AverageCabinStaffService FLOAT,
        AverageFoodAndBeverages FLOAT,
        AverageInflightEntertainment FLOAT,
        AverageGroundService FLOAT,
        AverageValueForMoney FLOAT,
        TravellerType NVARCHAR(100),
        SeatType NVARCHAR(100),
        AuthorLocation NVARCHAR(255)
    );

    -- Step 3: Insert aggregated data into the new table
    INSERT INTO OverallPerformance (
        FlightID, Origin, Destination, Routes, DateFlown, TotalReviews, AverageRating, 
        PercentageRecommended, AverageSeatComfort, AverageCabinStaffService, 
        AverageFoodAndBeverages, AverageInflightEntertainment, AverageGroundService, 
        AverageValueForMoney, TravellerType, SeatType, AuthorLocation
    )
    SELECT 
        F.FlightID,
        F.Origin,
        F.Destination,
        F.Routes,
        F.[Date Flown],
        COUNT(AR.ReviewID) AS TotalReviews,
        AVG(R.[Rating Value]) AS AverageRating,
        AVG(CASE WHEN FR.[Recommended Service] = 'Yes' THEN 1.0 ELSE 0.0 END) * 100 AS PercentageRecommended,
        AVG(FR.[Seat Comfort]) AS AverageSeatComfort,
        AVG(FR.[Cabin Staff Service]) AS AverageCabinStaffService,
        AVG(FR.[Food And Beverages]) AS AverageFoodAndBeverages,
        AVG(FR.[Inflight Entertainment]) AS AverageInflightEntertainment,
        AVG(FR.[Ground Service]) AS AverageGroundService,
        AVG(FR.[Value For Money]) AS AverageValueForMoney,
        T.[Traveller Type] AS TravellerType,
        S.[Seat Type] AS SeatType,
        A.[Author Location] AS AuthorLocation
    FROM 
        [Authur Reviews] AR
    INNER JOIN 
        Authors A ON AR.AuthorID = A.AuthorID
    INNER JOIN 
        Travellers T ON AR.TravellerID = T.TravellerID
    INNER JOIN 
        Seats S ON AR.SeatID = S.SeatID
    INNER JOIN 
        Flights F ON AR.FlightID = F.FlightID
    INNER JOIN 
        Ratings R ON AR.RatingID = R.RatingID
    LEFT JOIN 
        [Flight Ratings] FR ON AR.FlightID = FR.FlightID
    GROUP BY 
        F.FlightID, F.Origin, F.Destination, F.Routes, F.[Date Flown], 
        T.[Traveller Type], S.[Seat Type], A.[Author Location];

    -- Step 4: Optionally, return a success message
    PRINT 'OverallPerformance table created and populated successfully.';
END;

EXEC CreateOverallPerformanceTable;



CREATE PROCEDURE CreateServicesOverviewTable
AS
BEGIN

    IF OBJECT_ID('ServicesOverview', 'U') IS NOT NULL
        DROP TABLE ServicesOverview;


    CREATE TABLE ServicesOverview (
        ServiceID INT PRIMARY KEY IDENTITY(1,1),
        FlightID INT,
        SeatType NVARCHAR(100),
        AverageSeatComfort FLOAT,
        AverageCabinStaffService FLOAT,
        AverageFoodAndBeverages FLOAT,
        AverageInflightEntertainment FLOAT,
        AverageGroundService FLOAT,
        AverageValueForMoney FLOAT
    );


    INSERT INTO ServicesOverview (
        FlightID, SeatType, AverageSeatComfort, AverageCabinStaffService, 
        AverageFoodAndBeverages, AverageInflightEntertainment, 
        AverageGroundService, AverageValueForMoney
    )
    SELECT 
        F.FlightID,
        S.[Seat Type] AS SeatType,
        AVG(FR.[Seat Comfort]) AS AverageSeatComfort,
        AVG(FR.[Cabin Staff Service]) AS AverageCabinStaffService,
        AVG(FR.[Food And Beverages]) AS AverageFoodAndBeverages,
        AVG(FR.[Inflight Entertainment]) AS AverageInflightEntertainment,
        AVG(FR.[Ground Service]) AS AverageGroundService,
        AVG(FR.[Value For Money]) AS AverageValueForMoney
    FROM 
        [Flight Ratings] FR
    INNER JOIN 
        Flights F ON FR.FlightID = F.FlightID
    INNER JOIN 
        Seats S ON FR.FlightID = S.SeatID
    GROUP BY 
        F.FlightID, S.[Seat Type];


    PRINT 'ServicesOverview table created and populated successfully.';
END;

EXEC CreateServicesOverviewTable



CREATE PROCEDURE CreateFlightsOverviewTable
AS
BEGIN

    IF OBJECT_ID('FlightsOverview', 'U') IS NOT NULL
        DROP TABLE FlightsOverview;


    CREATE TABLE FlightsOverview (
        FlightID INT PRIMARY KEY,
        Origin NVARCHAR(255),
        Destination NVARCHAR(255),
        Routes NVARCHAR(500),
        DateFlown DATE,
        TotalReviews INT,
        AverageRating FLOAT,
        PercentageRecommended FLOAT
    );


    INSERT INTO FlightsOverview (
        FlightID, Origin, Destination, Routes, DateFlown, TotalReviews, AverageRating, PercentageRecommended
    )
    SELECT 
        F.FlightID,
        F.Origin,
        F.Destination,
        F.Routes,
        F.[Date Flown],
        COUNT(AR.ReviewID) AS TotalReviews,
        AVG(R.[Rating Value]) AS AverageRating,
        AVG(CASE WHEN FR.[Recommended Service] = 'Yes' THEN 1.0 ELSE 0.0 END) * 100 AS PercentageRecommended
    FROM 
        [Authur Reviews] AR
    INNER JOIN 
        Flights F ON AR.FlightID = F.FlightID
    INNER JOIN 
        Ratings R ON AR.RatingID = R.RatingID
    LEFT JOIN 
        [Flight Ratings] FR ON AR.FlightID = FR.FlightID
    GROUP BY 
        F.FlightID, F.Origin, F.Destination, F.Routes, F.[Date Flown];


    PRINT 'FlightsOverview table created and populated successfully.';
END;


EXEC CreateFlightsOverviewTable


CREATE PROCEDURE CreateFlightPerformanceByRoute
AS
BEGIN
    IF OBJECT_ID('FlightPerformanceByRoute', 'U') IS NOT NULL
        DROP TABLE FlightPerformanceByRoute;

    CREATE TABLE FlightPerformanceByRoute (
        Route NVARCHAR(500),
        TotalFlights INT,
        AverageRating FLOAT,
        TotalReviews INT,
        PercentageRecommended FLOAT
    );

    INSERT INTO FlightPerformanceByRoute (
        Route, TotalFlights, AverageRating, TotalReviews, PercentageRecommended
    )
    SELECT 
        F.Routes AS Route,
        COUNT(DISTINCT F.FlightID) AS TotalFlights,
        AVG(R.[Rating Value]) AS AverageRating,
        COUNT(AR.ReviewID) AS TotalReviews,
        AVG(CASE WHEN FR.[Recommended Service] = 'Yes' THEN 1.0 ELSE 0.0 END) * 100 AS PercentageRecommended
    FROM 
        Flights F
    INNER JOIN 
        [Authur Reviews] AR ON F.FlightID = AR.FlightID
    INNER JOIN 
        Ratings R ON AR.RatingID = R.RatingID
    LEFT JOIN 
        [Flight Ratings] FR ON AR.FlightID = FR.FlightID
    GROUP BY 
        F.Routes;

    PRINT 'FlightPerformanceByRoute table created and populated successfully.';
END;



CREATE PROCEDURE CreateServicePerformanceBySeatTypes
AS
BEGIN
    IF OBJECT_ID('ServicePerformanceBySeatType', 'U') IS NOT NULL
        DROP TABLE ServicePerformanceBySeatType;

    CREATE TABLE ServicePerformanceBySeatType (
        SeatType NVARCHAR(100),
        AverageSeatComfort FLOAT,
        AverageCabinStaffService FLOAT,
        AverageFoodAndBeverages FLOAT,
        AverageInflightEntertainment FLOAT,
        AverageGroundService FLOAT,
        AverageValueForMoney FLOAT
    );

    INSERT INTO ServicePerformanceBySeatType (
        SeatType, AverageSeatComfort, AverageCabinStaffService, 
        AverageFoodAndBeverages, AverageInflightEntertainment, 
        AverageGroundService, AverageValueForMoney
    )
    SELECT 
        S.[Seat Type] AS SeatType,
        AVG(FR.[Seat Comfort]) AS AverageSeatComfort,
        AVG(FR.[Cabin Staff Service]) AS AverageCabinStaffService,
        AVG(FR.[Food And Beverages]) AS AverageFoodAndBeverages,
        AVG(FR.[Inflight Entertainment]) AS AverageInflightEntertainment,
        AVG(FR.[Ground Service]) AS AverageGroundService,
        AVG(FR.[Value For Money]) AS AverageValueForMoney
    FROM 
        [Flight Ratings] FR
    INNER JOIN 
        Seats S ON FR.FlightID = S.SeatID
    GROUP BY 
        S.[Seat Type];

    PRINT 'Service Performance By Seat Type table created and populated successfully.';
END;


CREATE PROCEDURE CreateProblemIdentificationByFlight
AS
BEGIN
    IF OBJECT_ID('ProblemIdentificationByFlight', 'U') IS NOT NULL
        DROP TABLE ProblemIdentificationByFlight;

    CREATE TABLE ProblemIdentificationByFlight (
        FlightID INT,
        Origin NVARCHAR(255),
        Destination NVARCHAR(255),
        Routes NVARCHAR(500),
        DateFlown DATE,
        AverageRating FLOAT,
        TotalReviews INT,
        LowRatingFlag BIT, -- 1 if AverageRating < 3, else 0
        LowSeatComfortFlag BIT, -- 1 if AverageSeatComfort < 3, else 0
        LowCabinStaffServiceFlag BIT, -- 1 if AverageCabinStaffService < 3, else 0
        LowFoodAndBeveragesFlag BIT, -- 1 if AverageFoodAndBeverages < 3, else 0
        LowInflightEntertainmentFlag BIT, -- 1 if AverageInflightEntertainment < 3, else 0
        LowGroundServiceFlag BIT, -- 1 if AverageGroundService < 3, else 0
        LowValueForMoneyFlag BIT -- 1 if AverageValueForMoney < 3, else 0
    );

    INSERT INTO ProblemIdentificationByFlight (
        FlightID, Origin, Destination, Routes, DateFlown, AverageRating, TotalReviews,
        LowRatingFlag, LowSeatComfortFlag, LowCabinStaffServiceFlag, LowFoodAndBeveragesFlag,
        LowInflightEntertainmentFlag, LowGroundServiceFlag, LowValueForMoneyFlag
    )
    SELECT 
        F.FlightID,
        F.Origin,
        F.Destination,
        F.Routes,
        F.[Date Flown],
        AVG(R.[Rating Value]) AS AverageRating,
        COUNT(AR.ReviewID) AS TotalReviews,
        CASE WHEN AVG(R.[Rating Value]) < 3 THEN 1 ELSE 0 END AS LowRatingFlag,
        CASE WHEN AVG(FR.[Seat Comfort]) < 3 THEN 1 ELSE 0 END AS LowSeatComfortFlag,
        CASE WHEN AVG(FR.[Cabin Staff Service]) < 3 THEN 1 ELSE 0 END AS LowCabinStaffServiceFlag,
        CASE WHEN AVG(FR.[Food And Beverages]) < 3 THEN 1 ELSE 0 END AS LowFoodAndBeveragesFlag,
        CASE WHEN AVG(FR.[Inflight Entertainment]) < 3 THEN 1 ELSE 0 END AS LowInflightEntertainmentFlag,
        CASE WHEN AVG(FR.[Ground Service]) < 3 THEN 1 ELSE 0 END AS LowGroundServiceFlag,
        CASE WHEN AVG(FR.[Value For Money]) < 3 THEN 1 ELSE 0 END AS LowValueForMoneyFlag
    FROM 
        [Authur Reviews] AR
    INNER JOIN 
        Flights F ON AR.FlightID = F.FlightID
    INNER JOIN 
        Ratings R ON AR.RatingID = R.RatingID
    LEFT JOIN 
        [Flight Ratings] FR ON AR.FlightID = FR.FlightID
    GROUP BY 
        F.FlightID, F.Origin, F.Destination, F.Routes, F.[Date Flown];

    PRINT 'Problem Identification By Flight table created and populated successfully.';
END;

CREATE PROCEDURE CreateReviewTrendsOverTime
AS
BEGIN
    IF OBJECT_ID('ReviewTrendsOverTime', 'U') IS NOT NULL
        DROP TABLE ReviewTrendsOverTime;

    CREATE TABLE ReviewTrendsOverTime (
        ReviewDate DATE,
        TotalReviews INT,
        AverageRating FLOAT
    );

    INSERT INTO ReviewTrendsOverTime (
        ReviewDate, TotalReviews, AverageRating
    )
    SELECT 
        CAST(AR.[Review Date] AS DATE) AS ReviewDate,
        COUNT(AR.ReviewID) AS TotalReviews,
        AVG(R.[Rating Value]) AS AverageRating
    FROM 
        [Authur Reviews] AR
    INNER JOIN 
        Ratings R ON AR.RatingID = R.RatingID
    GROUP BY 
        CAST(AR.[Review Date] AS DATE);

    PRINT 'ReviewTrendsOverTime table created and populated successfully.';
END;



EXEC CreateFlightPerformanceByRoute;
EXEC CreateServicePerformanceBySeatTypes;
EXEC CreateProblemIdentificationByFlight;
EXEC CreateReviewTrendsOverTime;







CREATE PROCEDURE CreatePerformancePast6Months
AS
BEGIN
    IF OBJECT_ID('PerformancePast6Months', 'U') IS NOT NULL
        DROP TABLE PerformancePast6Months;

    CREATE TABLE PerformancePast6Months (
        Month DATE,
        TotalFlights INT,
        AverageRating FLOAT,
        TotalReviews INT,
        PercentageRecommended FLOAT
    );

    INSERT INTO PerformancePast6Months (
        Month, TotalFlights, AverageRating, TotalReviews, PercentageRecommended
    )
    SELECT 
        DATEFROMPARTS(YEAR(F.[Date Flown]), MONTH(F.[Date Flown]), 1) AS Month,
        COUNT(DISTINCT F.FlightID) AS TotalFlights,
        AVG(R.[Rating Value]) AS AverageRating,
        COUNT(AR.ReviewID) AS TotalReviews,
        AVG(CASE WHEN FR.[Recommended Service] = 'Yes' THEN 1.0 ELSE 0.0 END) * 100 AS PercentageRecommended
    FROM 
        Flights F
    INNER JOIN 
        [Authur Reviews] AR ON F.FlightID = AR.FlightID
    INNER JOIN 
        Ratings R ON AR.RatingID = R.RatingID
    LEFT JOIN 
        [Flight Ratings] FR ON AR.FlightID = FR.FlightID
    WHERE 
        F.[Date Flown] >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY 
        DATEFROMPARTS(YEAR(F.[Date Flown]), MONTH(F.[Date Flown]), 1);

    PRINT 'PerformancePast6Months table created and populated successfully.';
END;





CREATE PROCEDURE CreateBestAndWorstTravellerTypes
AS
BEGIN
    IF OBJECT_ID('BestAndWorstTravellerTypes', 'U') IS NOT NULL
        DROP TABLE BestAndWorstTravellerTypes;

    CREATE TABLE BestAndWorstTravellerTypes (
        TravellerType NVARCHAR(100),
        AverageRating FLOAT,
        Category NVARCHAR(50) -- Best or Worst
    );

    -- Insert best traveller types
    INSERT INTO BestAndWorstTravellerTypes (
        TravellerType, AverageRating, Category
    )
    SELECT TOP 5
        T.[Traveller Type] AS TravellerType,
        AVG(R.[Rating Value]) AS AverageRating,
        'Best' AS Category
    FROM 
        [Authur Reviews] AR
    INNER JOIN 
        Travellers T ON AR.TravellerID = T.TravellerID
    INNER JOIN 
        Ratings R ON AR.RatingID = R.RatingID
    GROUP BY 
        T.[Traveller Type]
    ORDER BY 
        AVG(R.[Rating Value]) DESC;

    -- Insert worst traveller types
    INSERT INTO BestAndWorstTravellerTypes (
        TravellerType, AverageRating, Category
    )
    SELECT TOP 5
        T.[Traveller Type] AS TravellerType,
        AVG(R.[Rating Value]) AS AverageRating,
        'Worst' AS Category
    FROM 
        [Authur Reviews] AR
    INNER JOIN 
        Travellers T ON AR.TravellerID = T.TravellerID
    INNER JOIN 
        Ratings R ON AR.RatingID = R.RatingID
    GROUP BY 
        T.[Traveller Type]
    ORDER BY 
        AVG(R.[Rating Value]) ASC;

    PRINT 'BestAndWorstTravellerTypes table created and populated successfully.';
END;



CREATE PROCEDURE CreateBestAndWorstSeatTypes
AS
BEGIN
    IF OBJECT_ID('BestAndWorstSeatTypes', 'U') IS NOT NULL
        DROP TABLE BestAndWorstSeatTypes;

    CREATE TABLE BestAndWorstSeatTypes (
        SeatType NVARCHAR(100),
        AverageRating FLOAT,
        Category NVARCHAR(50) -- Best or Worst
    );

    -- Insert best seat types
    INSERT INTO BestAndWorstSeatTypes (
        SeatType, AverageRating, Category
    )
    SELECT TOP 5
        S.[Seat Type] AS SeatType,
        AVG(R.[Rating Value]) AS AverageRating,
        'Best' AS Category
    FROM 
        [Authur Reviews] AR
    INNER JOIN 
        Seats S ON AR.SeatID = S.SeatID
    INNER JOIN 
        Ratings R ON AR.RatingID = R.RatingID
    GROUP BY 
        S.[Seat Type]
    ORDER BY 
        AVG(R.[Rating Value]) DESC;

    -- Insert worst seat types
    INSERT INTO BestAndWorstSeatTypes (
        SeatType, AverageRating, Category
    )
    SELECT TOP 5
        S.[Seat Type] AS SeatType,
        AVG(R.[Rating Value]) AS AverageRating,
        'Worst' AS Category
    FROM 
        [Authur Reviews] AR
    INNER JOIN 
        Seats S ON AR.SeatID = S.SeatID
    INNER JOIN 
        Ratings R ON AR.RatingID = R.RatingID
    GROUP BY 
        S.[Seat Type]
    ORDER BY 
        AVG(R.[Rating Value]) ASC;

    PRINT 'BestAndWorstSeatTypes table created and populated successfully.';
END;



EXEC CreatePerformancePast6Months;
EXEC CreateBestAndWorstTravellerTypes;
EXEC CreateBestAndWorstSeatTypes;