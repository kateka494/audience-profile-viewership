--EDA-Explanatory Data Analysis
SELECT * FROM TV.USER.VIEWERSHIP;

SELECT DISTINCT CHANNEL2
FROM TV.USER.VIEWERSHIP;

---Minimum watch time
SELECT MIN(DURATION_2) AS MINIMUM_DURATION
FROM TV.USER.VIEWERSHIP;

---Maximum watch time
SELECT MAX(DURATION_2) AS MAXIMUM_DURATION
FROM TV.USER.VIEWERSHIP;

-- Date and time analysis
SELECT 
    RecordDate2,
    DATE(RecordDate2) AS RecordDate,
    TIME(RecordDate2) AS RecordTime,
    YEAR(RecordDate2) AS Year,
    MONTH(RecordDate2) AS Month,
    DAYNAME(RecordDate2) AS Day_Name,
    MONTHNAME(RecordDate2) AS Month_Name
FROM TV.USER.VIEWERSHIP;

-- Time range analysis
SELECT MIN(TIME(RecordDate2)) AS MINIMUM_TIME
FROM TV.USER.VIEWERSHIP;

SELECT MAX(TIME(RecordDate2)) AS MAXIMUM_TIME  
FROM TV.USER.VIEWERSHIP;

--Day of the week with more views
SELECT 
    DAYNAME(RECORDDATE2) AS Day_Of_Week,
    COUNT(*) AS View_Count
FROM TV.USER.VIEWERSHIP_VIEW
GROUP BY DAYNAME(RecordDate2)
ORDER BY 
    CASE 
        WHEN DAYNAME(RecordDate2) ='Sunday' THEN 'Sunday'
        WHEN DAYNAME(RecordDate2) = 'Monday' THEN 'Monday'
        WHEN DAYNAME(RecordDate2) =  'Tuesday' THEN 'Tuesday'
        WHEN DAYNAME(RecordDate2) = 'Wednesday' THEN 'Wednesday' 
        WHEN DAYNAME(RecordDate2) = 'Thursday' THEN 'Thursday'
        WHEN DAYNAME(RecordDate2) = 'Friday' THEN 'Friday'
        WHEN DAYNAME(RecordDate2) = 'Saturday' THEN 'Saturday'
    END;


-- Duration and time analysis (original query)
SELECT 
    DURATION_2,
    TIME(RECORDDATE2),
    MONTHNAME(RecordDate2),
    CASE
        WHEN Duration_2 BETWEEN '00:00:00' AND '00:05:59' THEN '0-5 MINUTES'
        WHEN Duration_2 BETWEEN '00:06:00' AND '00:15:59' THEN '6-15 MINUTES'
        WHEN Duration_2 BETWEEN '00:16:00' AND '00:30:59' THEN '16-30 MINUTES'
        WHEN Duration_2 BETWEEN '00:31:00' AND '01:00:59' THEN '31-60 MINUTES'
        WHEN Duration_2 BETWEEN '01:01:00' AND '02:00:59' THEN '1-2 HOURS'
        WHEN Duration_2 BETWEEN '02:01:00' AND '03:00:59' THEN '2-3 HOURS'
        WHEN Duration_2 BETWEEN '03:01:00' AND '04:00:59' THEN '3-4 HOURS'
        WHEN Duration_2 BETWEEN '04:01:00' AND '06:00:59' THEN '4-6 HOURS'
        WHEN Duration_2 BETWEEN '06:01:00' AND '08:00:59' THEN '6-8 HOURS'
        ELSE '8+ HOURS'
    END AS DURATION_BRACKET,
    CASE 
        WHEN TIME(RecordDate2) BETWEEN '00:00:00' AND '10:00:00' THEN 'Morning'
        WHEN TIME(RecordDate2) BETWEEN '10:00:01' AND '16:00:00' THEN 'Afternoon'
        WHEN TIME(RecordDate2) BETWEEN '16:00:01' AND '20:00:00' THEN 'Evening'
        WHEN TIME(RecordDate2) BETWEEN '20:00:01' AND '23:59:59' THEN 'Night'
        ELSE 'Other'
    END AS Time_Bracket
FROM TV.USER.VIEWERSHIP;

---Create view with categorized data
CREATE OR REPLACE VIEW TV.USER.VIEWERSHIP_VIEW AS
SELECT 
    "UserID" AS USERID,  -- Alias
    CHANNEL2,
    DURATION_2,
    RecordDate2,

    /* Duration bucket */
    CASE
        WHEN Duration_2 BETWEEN '00:00:00' AND '00:05:59' THEN '0-5 MINUTES'
        WHEN Duration_2 BETWEEN '00:06:00' AND '00:15:59' THEN '6-15 MINUTES'
        WHEN Duration_2 BETWEEN '00:16:00' AND '00:30:59' THEN '16-30 MINUTES'
        WHEN Duration_2 BETWEEN '00:31:00' AND '01:00:59' THEN '31-60 MINUTES'
        WHEN Duration_2 BETWEEN '01:01:00' AND '02:00:59' THEN '1-2 HOURS'
        WHEN Duration_2 BETWEEN '02:01:00' AND '03:00:59' THEN '2-3 HOURS'
        WHEN Duration_2 BETWEEN '03:01:00' AND '04:00:59' THEN '3-4 HOURS'
        WHEN Duration_2 BETWEEN '04:01:00' AND '06:00:59' THEN '4-6 HOURS'
        WHEN Duration_2 BETWEEN '06:01:00' AND '08:00:59' THEN '6-8 HOURS'
        ELSE '8+ HOURS'
    END AS DURATION_BRACKET,

    /* Time of day bucket */
    CASE 
        WHEN TIME(RecordDate2) BETWEEN '00:00:00' AND '10:00:00' THEN 'Morning'
        WHEN TIME(RecordDate2) BETWEEN '10:00:01' AND '16:00:00' THEN 'Afternoon'
        WHEN TIME(RecordDate2) BETWEEN '16:00:01' AND '20:00:00' THEN 'Evening'
        WHEN TIME(RecordDate2) BETWEEN '20:00:01' AND '23:59:59' THEN 'Night'
        ELSE 'Other'
    END AS TIME_BRACKET
FROM TV.USER.VIEWERSHIP;


-- Which Channel has more views
SELECT 
    CHANNEL2,
    COUNT(*) AS View_Count
FROM TV.USER.VIEWERSHIP_VIEW
GROUP BY CHANNEL2
ORDER BY View_Count DESC;

-- Time which users mostly watch
SELECT 
    TIME_BRACKET,
    COUNT(*) AS Views
FROM TV.USER.VIEWERSHIP_VIEW
GROUP BY TIME_BRACKET
ORDER BY Views DESC;

-- Popular channels by time of day
SELECT 
    TIME_BRACKET,
    CHANNEL2,
    COUNT(*) AS View_Count
FROM TV.USER.VIEWERSHIP_VIEW
GROUP BY TIME_BRACKET, CHANNEL2
ORDER BY TIME_BRACKET, View_Count DESC;

-- Day of the week which gets most views
SELECT 
    DAYNAME(RecordDate2) AS DayOfWeek,
    COUNT(*) AS ViewCount
FROM TV.USER.VIEWERSHIP_VIEW
GROUP BY DayOfWeek
ORDER BY ViewCount DESC;

-- Channels by day of week
SELECT 
    DAYNAME(RecordDate2) AS DayOfWeek,
    CHANNEL2,
    COUNT(*) AS ViewCount
FROM TV.USER.VIEWERSHIP_VIEW
GROUP BY DayOfWeek, CHANNEL2
ORDER BY DayOfWeek, ViewCount DESC;

-- Which channels people watch longer
SELECT 
    CHANNEL2,
    DURATION_BRACKET,
    COUNT(*) AS Count_Views
FROM TV.USER.VIEWERSHIP_VIEW
GROUP BY CHANNEL2, DURATION_BRACKET
ORDER BY CHANNEL2, Count_Views DESC;

