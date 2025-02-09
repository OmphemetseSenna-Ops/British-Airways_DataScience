

-- 1. How many reviews are being submitted?
SELECT 
    COUNT(ReviewID) AS [Total Reviews]
FROM 
    [Authur Reviews];




-- 2. What is the average rating for flights?
SELECT 
    AVG([Rating Value]) AS [Average Rating]
FROM 
    Ratings;



-- 3. What is the average rating for each flight services (e.g., seat comfort, cabin service)?
SELECT 
    AVG([Seat Comfort]) AS [Average Seat Comfort],
    AVG([Cabin Staff Service]) AS [Average Cabin Staff Service],
	AVG([Food And Beverages]) AS [Average Food And Beverages],
	AVG([Inflight Entertainment]) AS [Average Inflight Entertainment],
	AVG([Ground Service]) AS [Average Ground Service],
	AVG([Value For Money]) AS [Average Value For Money]
FROM 
    [Flight Ratings];



-- How many flights are being recommended?
SELECT 
    FlightID,
    COUNT(*) AS [Recommended Count]
FROM 
    [Flight Ratings]
WHERE 
    [Recommended Service] = 'Yes'
GROUP BY 
    FlightID;



-- How are different traveller types represented in the reviews?
SELECT 
    [Traveller Type], 
    COUNT(*) AS [Traveller Count]
FROM 
    [Authur Reviews] r
JOIN 
    Travellers t ON r.TravellerID = t.TravellerID
GROUP BY 
    [Traveller Type];





-- Which routes are underperforming based on reviews?
SELECT 
    f.Origin,
    f.Destination,
    COUNT(r.ReviewID) AS ReviewCount,
    AVG(rt.[Rating Value]) AS AvgRating
FROM 
    Flights f
JOIN 
    [Authur Reviews] r ON f.FlightID = r.FlightID
JOIN 
    Ratings rt ON r.RatingID = rt.RatingID
GROUP BY 
    f.Origin, f.Destination
HAVING 
    COUNT(r.ReviewID) < 10 AND AVG(rt.[Rating Value]) < 3
ORDER BY 
    AvgRating ASC;



-- How many reviews are being written per month or year?
SELECT 
    YEAR([Review Date]) AS ReviewYear,
    MONTH([Review Date]) AS ReviewMonth,
    COUNT(ReviewID) AS ReviewCount
FROM 
    [Authur Reviews]
GROUP BY 
    YEAR([Review Date]), MONTH([Review Date])
ORDER BY 
    ReviewYear DESC, ReviewMonth DESC;



-- How many customers are returning to leave reviews for multiple flights?
SELECT 
    r.TravellerID, 
    COUNT(DISTINCT r.FlightID) AS FlightCount
FROM 
    [Authur Reviews] r
GROUP BY 
    r.TravellerID
HAVING 
    COUNT(DISTINCT r.FlightID) > 1



-- Identify the worst-rated reviews to understand customer dissatisfaction.
SELECT TOP 10
    r.ReviewID, 
    f.Origin, 
    f.Destination, 
    rt.[Rating Value], 
    r.[Review Title], 
    r.[Review Date]
FROM 
    [Authur Reviews] r
JOIN 
    Flights f ON r.FlightID = f.FlightID
JOIN 
    Ratings rt ON r.RatingID = rt.RatingID
ORDER BY 
    rt.[Rating Value] ASC;






-- Identify routes (Origin-Destination pairs) with the highest number of negative reviews (e.g., ratings under 3).
SELECT TOP 5
    f.Origin, 
    f.Destination, 
    COUNT(r.ReviewID) AS [Negative Review Count]
FROM 
    [Authur Reviews] r
JOIN 
    Flights f ON r.FlightID = f.FlightID
JOIN 
    Ratings rt ON r.RatingID = rt.RatingID
WHERE 
    rt.[Rating Value] < 3
GROUP BY 
    f.Origin, f.Destination
ORDER BY 
    [Negative Review Count] DESC;


-- Identify the most active customers, potentially loyal or highly engaged.
SELECT TOP 5
    r.TravellerID, 
    COUNT(r.ReviewID) AS ReviewCount
FROM 
    [Authur Reviews] r
GROUP BY 
    r.TravellerID
ORDER BY 
    ReviewCount DESC;








-- Show how different traveller types rate their flights on average.
SELECT 
    t.[Traveller Type],
    AVG(rt.[Rating Value]) AS AverageRating
FROM 
    [Authur Reviews] r
JOIN 
    Travellers t ON r.TravellerID = t.TravellerID
JOIN 
    Ratings rt ON r.RatingID = rt.RatingID
GROUP BY 
    t.[Traveller Type]
ORDER BY 
    AverageRating DESC;



-- Flight Ratings Breakdown: shows the detailed flight ratings for each flight, broken down by individual services
SELECT 
    fr.FlightID,
    f.Origin,
    f.Destination,
    fr.[Seat Comfort],
    fr.[Cabin Staff Service],
    fr.[Food And Beverages],
    fr.[Inflight Entertainment],
    fr.[Ground Service],
    fr.[Value For Money],
    fr.[Recommended Service]
FROM 
    [Flight Ratings] fr
JOIN 
    Flights f ON fr.FlightID = f.FlightID
ORDER BY 
    f.Origin, f.Destination;


-- identify the top-rated flights based on the recommended service and overall ratings.
SELECT 
    f.FlightID,
    f.Origin,
    f.Destination,
    AVG(fr.[Seat Comfort] + fr.[Cabin Staff Service] + fr.[Food And Beverages] + fr.[Inflight Entertainment] + fr.[Ground Service] + fr.[Value For Money]) AS TotalRating,
    fr.[Recommended Service]
FROM 
    [Flight Ratings] fr
JOIN 
    Flights f ON fr.FlightID = f.FlightID
WHERE 
    fr.[Recommended Service] = 'Yes'
GROUP BY 
    f.FlightID, f.Origin, f.Destination, fr.[Recommended Service]
ORDER BY 
    TotalRating DESC;




-- Review Insights by Seat Type: how seat types are perceived in reviews and compares them based on the ratings they received.
SELECT 
    s.[Seat Type],
    COUNT(r.ReviewID) AS TotalReviews,
    AVG(rt.[Rating Value]) AS AverageRating
FROM 
    [Authur Reviews] r
JOIN 
    Seats s ON r.SeatID = s.SeatID
JOIN 
    Ratings rt ON r.RatingID = rt.RatingID
GROUP BY 
    s.[Seat Type]
ORDER BY 
    AverageRating DESC;




-- explores the most frequent flight routes and their ratings.
SELECT 
    f.Origin,
    f.Destination,
    COUNT(f.FlightID) AS NumberOfFlights,
    AVG(rt.[Rating Value]) AS AverageFlightRating
FROM 
    Flights f
JOIN 
    [Authur Reviews] r ON f.FlightID = r.FlightID
JOIN 
    Ratings rt ON r.RatingID = rt.RatingID
GROUP BY 
    f.Origin, f.Destination
ORDER BY 
    NumberOfFlights DESC;

-- Get an insight into which flight routes have the most reviews and their average ratings.
SELECT 
    f.Origin,
    f.Destination,
    COUNT(r.ReviewID) AS ReviewCount,
    AVG(rt.[Rating Value]) AS AverageRating
FROM 
    Flights f
JOIN 
    [Authur Reviews] r ON f.FlightID = r.FlightID
JOIN 
    Ratings rt ON r.RatingID = rt.RatingID
GROUP BY 
    f.Origin, f.Destination
ORDER BY 
    ReviewCount DESC;

-- Flight Rating Summary: provides a summary of flight ratings for each category (seat comfort, staff service, food, etc.) and calculates the overall rating for each flight.
SELECT 
    f.FlightID,
    f.Origin,
    f.Destination,
    AVG(fr.[Seat Comfort]) AS AvgSeatComfort,
    AVG(fr.[Cabin Staff Service]) AS AvgCabinStaffService,
    AVG(fr.[Food And Beverages]) AS AvgFoodAndBeverages,
    AVG(fr.[Inflight Entertainment]) AS AvgInflightEntertainment,
    AVG(fr.[Ground Service]) AS AvgGroundService,
    AVG(fr.[Value For Money]) AS AvgValueForMoney,
    AVG(
        fr.[Seat Comfort] + 
        fr.[Cabin Staff Service] + 
        fr.[Food And Beverages] + 
        fr.[Inflight Entertainment] + 
        fr.[Ground Service] + 
        fr.[Value For Money]
    ) AS OverallRating
FROM 
    [Flight Ratings] fr
JOIN 
    Flights f ON fr.FlightID = f.FlightID
GROUP BY 
    f.FlightID, f.Origin, f.Destination
ORDER BY 
    OverallRating DESC;





SELECT 
    f.FlightID,
    f.Origin,
    f.Destination,
    AVG(
        fr.[Seat Comfort] + 
        fr.[Cabin Staff Service] + 
        fr.[Food And Beverages] + 
        fr.[Inflight Entertainment] + 
        fr.[Ground Service] + 
        fr.[Value For Money]
    ) AS OverallRating
FROM 
    [Flight Ratings] fr
JOIN 
    Flights f ON fr.FlightID = f.FlightID
GROUP BY 
    f.FlightID, f.Origin, f.Destination
ORDER BY 
    OverallRating DESC;


