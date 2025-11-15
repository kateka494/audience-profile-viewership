SELECT * FROM TV.USER.PROFILE;
SELECT * FROM TV.USER.VIEWERSHIP;

--View table to join users and viewership
CREATE OR REPLACE VIEW TV.USER.COMBINED_ANALYSIS_VIEW AS
SELECT 
    -- Viewership data
    v."UserID" AS USERID,  
    v.CHANNEL2,
    v.DURATION_2,
    v.RecordDate2,
    
    -- Profile demographics
    p.GENDER,
    p.RACE,
    p.AGE,
    p.PROVINCE,
    
    -- Categorized demographics
    uv.AGE_BRACKET,
    uv.GENDER_BRACKET,
    uv.PROVINCE_BRACKET,
    uv.RACE_BRACKET,
    
    -- Viewership categories
    vv.DURATION_BRACKET,
    vv.TIME_BRACKET,
    
    -- Date/Time analysis
    DAYNAME(v.RecordDate2) AS DAY_OF_WEEK,
    MONTHNAME(v.RecordDate2) AS MONTH_NAME,
    YEAR(v.RecordDate2) AS YEAR,
    TIME(v.RecordDate2) AS TIME_OF_DAY
    
FROM TV.USER.VIEWERSHIP v
INNER JOIN TV.USER.PROFILE p ON v."UserID" = p.USERID  
INNER JOIN TV.USER.USER_PROFILE_VIEW uv ON p.USERID = uv.USERID
INNER JOIN TV.USER.VIEWERSHIP_VIEW vv ON v."UserID" = vv.USERID;  

SELECT *
FROM TV.USER.COMBINED_ANALYSIS_VIEW;


