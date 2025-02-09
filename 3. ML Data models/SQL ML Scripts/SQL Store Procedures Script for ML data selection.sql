

CREATE PROCEDURE PrepareDataForML
AS
BEGIN
    IF OBJECT_ID('MLData', 'U') IS NOT NULL
        DROP TABLE MLData;

    CREATE TABLE MLData (
        FlightID INT,
        Origin NVARCHAR(255),
        Destination NVARCHAR(255),
        Routes NVARCHAR(500),
        DateFlown DATE,
        TravellerType NVARCHAR(100),
        SeatType NVARCHAR(100),
        SeatComfort FLOAT,
        CabinStaffService FLOAT,
        FoodAndBeverages FLOAT,
        InflightEntertainment FLOAT,
        GroundService FLOAT,
        ValueForMoney FLOAT,
        RecommendedService NVARCHAR(10),
        ReviewTitle NVARCHAR(255),
        Review NVARCHAR(MAX),
        RatingValue FLOAT
    );

    INSERT INTO MLData (
        FlightID, Origin, Destination, Routes, DateFlown, TravellerType, SeatType,
        SeatComfort, CabinStaffService, FoodAndBeverages, InflightEntertainment,
        GroundService, ValueForMoney, RecommendedService, ReviewTitle, Review, RatingValue
    )
    SELECT 
        F.FlightID,
        F.Origin,
        F.Destination,
        F.Routes,
        F.[Date Flown],
        T.[Traveller Type] AS TravellerType,
        S.[Seat Type] AS SeatType,
        FR.[Seat Comfort],
        FR.[Cabin Staff Service],
        FR.[Food And Beverages],
        FR.[Inflight Entertainment],
        FR.[Ground Service],
        FR.[Value For Money],
        FR.[Recommended Service],
        AR.[Review Title],
        AR.[Review],
        R.[Rating Value]
    FROM 
        [Authur Reviews] AR
    INNER JOIN 
        Flights F ON AR.FlightID = F.FlightID
    INNER JOIN 
        Travellers T ON AR.TravellerID = T.TravellerID
    INNER JOIN 
        Seats S ON AR.SeatID = S.SeatID
    INNER JOIN 
        Ratings R ON AR.RatingID = R.RatingID
    LEFT JOIN 
        [Flight Ratings] FR ON AR.FlightID = FR.FlightID;

    PRINT 'MLData table created and populated successfully.';
END;