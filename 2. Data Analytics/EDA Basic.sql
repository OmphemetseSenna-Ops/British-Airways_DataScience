



USE BritishAirwaysDB;

-- Top 5 Authors with the Most Reviews
SELECT TOP 5
    [Author], 
    COUNT(*) AS ReviewCount
FROM 
    UniqueReviews
GROUP BY 
    [Author]
ORDER BY 
    ReviewCount DESC;



-- Retrieve Average Rating for Each Type of Traveller
SELECT 
    [Type Of Traveller], 
    AVG([Rating]) AS AverageRating
FROM 
    UniqueReviews
GROUP BY 
    [Type Of Traveller]
ORDER BY 
    AverageRating DESC;


-- Check Reviews Per Seat Type
SELECT 
    [Seat Type], 
    COUNT(*) AS ReviewCount
FROM 
    UniqueReviews
GROUP BY 
    [Seat Type]
ORDER BY 
    ReviewCount DESC;



-- Monthly Trends of Ratings
SELECT 
    YEAR([Review Date]) AS ReviewYear, 
    MONTH([Review Date]) AS ReviewMonth, 
    AVG([Rating]) AS AverageRating
FROM 
    UniqueReviews
GROUP BY 
    YEAR([Review Date]), 
    MONTH([Review Date])
ORDER BY 
    ReviewYear, 
    ReviewMonth;


-- Distribution of Recommended Services
SELECT 
    [Recommended Service], 
    COUNT(*) AS Count
FROM 
    UniqueReviews
GROUP BY 
    [Recommended Service];


-- Count Reviews by Year
SELECT 
    YEAR([Review Date]) AS ReviewYear, 
    COUNT(*) AS ReviewCount
FROM 
    UniqueReviews
GROUP BY 
    YEAR([Review Date])
ORDER BY 
    ReviewYear;


-- Percentage of Reviews with High Ratings
SELECT 
    COUNT(CASE WHEN [Rating] >= 5 THEN 1 END) * 100.0 / COUNT(*) AS [High Rating Percentage]
FROM 
    UniqueReviews;


-- Find top 10 Routes with the Most Reviews
SELECT TOP (10)
    [Route], 
    COUNT(*) AS ReviewCount
FROM 
    UniqueReviews
GROUP BY 
    [Route]
ORDER BY 
    ReviewCount DESC;


--Top 5 rated routes with more than 5 reviews
SELECT TOP (3)
    [Route], 
    AVG([Rating]) AS AverageRating
FROM 
    UniqueReviews
GROUP BY 
    [Route]
HAVING 
    COUNT(*) > 5
ORDER BY 
    AverageRating ASC;
