
-- Check Missing Values
SELECT 
    SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS [Missing Rating],
    SUM(CASE WHEN Author IS NULL THEN 1 ELSE 0 END) AS [Missing Author],
    SUM(CASE WHEN [Author Location] IS NULL THEN 1 ELSE 0 END) AS [Missing Author Location],
    SUM(CASE WHEN [Review Date] IS NULL THEN 1 ELSE 0 END) AS [Missing Review Date],
    SUM(CASE WHEN [Review Title] IS NULL THEN 1 ELSE 0 END) AS [Missing Review Title],
    SUM(CASE WHEN [Review] IS NULL THEN 1 ELSE 0 END) AS [Missing Review],
    SUM(CASE WHEN [Type Of Traveller] IS NULL THEN 1 ELSE 0 END) AS [Missing Type Of Traveller],
    SUM(CASE WHEN [Seat Type] IS NULL THEN 1 ELSE 0 END) AS [Missing Seat Type],
    SUM(CASE WHEN [Route] IS NULL THEN 1 ELSE 0 END) AS [Missing Route]
FROM UniqueReviews;

SELECT 
    SUM(CASE WHEN [Date Flown] IS NULL THEN 1 ELSE 0 END) AS [Missing Date Flown],
    SUM(CASE WHEN [Seat Comfort] IS NULL THEN 1 ELSE 0 END) AS [Missing Seat Comfort],
    SUM(CASE WHEN [Cabin Staff Service] IS NULL THEN 1 ELSE 0 END) AS [Missing Cabin Staff Service],
    SUM(CASE WHEN [Food And Beverages] IS NULL THEN 1 ELSE 0 END) AS [Missing Food And Beverages],
    SUM(CASE WHEN [Inflight Entertainment] IS NULL THEN 1 ELSE 0 END) AS [Missing Inflight Entertainment],
    SUM(CASE WHEN [Ground Service] IS NULL THEN 1 ELSE 0 END) AS [Missing Ground Service],
    SUM(CASE WHEN [Value For Money] IS NULL THEN 1 ELSE 0 END) AS [Missing Value For Money],
    SUM(CASE WHEN [Recommended Service] IS NULL THEN 1 ELSE 0 END) AS [Missing Recommended Service]
FROM UniqueReviews;


-- Check duplicates
SELECT 
    [Rating], 
    [Author], 
    [Review Date], 
	[Date Flown],
	[Recommended Service],
    COUNT(*) AS DuplicateCount
FROM 
    UniqueReviews
GROUP BY 
    [Rating], [Author], [Review Date], [Date Flown], [Recommended Service]
HAVING COUNT(*) > 1;




SELECT 
    [Rating], 
    [Author], 
    [Review Date], 
    [Review Title], 
    [Review], 
    [Type Of Traveller], 
    [Seat Type], 
    [Route], 
    [Date Flown], 
    [Seat Comfort], 
    [Cabin Staff Service], 
    [Food And Beverages], 
    [Inflight Entertainment], 
    [Ground Service], 
    [Value For Money], 
    [Recommended Service],
    COUNT(*) AS DuplicateCount
FROM 
    UniqueReviews
GROUP BY 
    [Rating], 
    [Author], 
    [Review Date], 
    [Review Title], 
    [Review], 
    [Type Of Traveller], 
    [Seat Type], 
    [Route], 
    [Date Flown], 
    [Seat Comfort], 
    [Cabin Staff Service], 
    [Food And Beverages], 
    [Inflight Entertainment], 
    [Ground Service], 
    [Value For Money], 
    [Recommended Service]
HAVING COUNT(*) > 1;





-- Check Invalid Ratings
SELECT 
	SUM(CASE WHEN Rating < 0 OR Rating > 10 THEN 1 ELSE 0 END) AS [Invalid Ratings],
	SUM(CASE WHEN [Seat Comfort] < 0 OR [Seat Comfort] > 10 THEN 1 ELSE 0 END) AS [Invalid Seat Comfort],
	SUM(CASE WHEN [Cabin Staff Service] < 0 OR [Cabin Staff Service] > 10 THEN 1 ELSE 0 END) AS [Invalid Cabin Staff Service],
	SUM(CASE WHEN [Food And Beverages] < 0 OR [Food And Beverages] > 10 THEN 1 ELSE 0 END) AS [Invalid Food And Beverages],
	SUM(CASE WHEN [Inflight Entertainment] < 0 OR [Inflight Entertainment] > 10 THEN 1 ELSE 0 END) AS [Invalid Inflight Entertainment],
	SUM(CASE WHEN [Ground Service] < 0 OR [Ground Service] > 10 THEN 1 ELSE 0 END) AS [Invalid [Ground Service]
FROM UniqueReviews;


SELECT 
    MIN([Rating]) AS Min_Rating,
    MAX([Rating]) AS Max_Rating,
    AVG([Rating]) AS Avg_Rating,
    STDEV([Rating]) AS Rating_StdDev
FROM 
    UniqueReviews;

SELECT *
FROM UniqueReviews
WHERE [Rating] IN (1, 10);
