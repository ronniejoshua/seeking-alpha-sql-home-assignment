/*
QUESTION 3:
Create a time series for Total DRU and DRU for each platform, 
the results should be a table with ts_date column and 4 DRU columns

Dialect: POSTGRESQL

RESULT:

|ts_date   |dru_total|dru_desktop|dru_mobile|dru_tablet|
|----------|---------|-----------|----------|----------|
|2018-07-10|        3|          2|         0|         1|
|2018-07-09|        2|          1|         1|         0|
*/

-- This is for code just for replication and testing the query
-- It may be different than what is provided in the assignment

with mone(ts_date, UserId, MachineCookie, Platform) as (
    values ('2018-07-10', 8943, 759827895732, 'desktop'),
        ('2018-07-10', 8943, 430928402308, 'tablet'),
        ('2018-07-10', 583689, 748927589287, 'desktop'),
        ('2018-07-09', 43984, 985420580298, 'mobile'),
        ('2018-07-09', 8943, 759827895732, 'desktop'),
        ('2018-07-09', NULL, 473878094774, 'mobile')
)

-- Solution Start's Here ...
SELECT ts_date,
    COUNT(UserId) AS dru_total,
    SUM(
        CASE
            WHEN platform = 'desktop' THEN 1
            ELSE 0
        END
    ) AS dru_desktop,
    SUM(
        CASE
            WHEN platform = 'mobile' THEN 1
            ELSE 0
        END
    ) AS dru_mobile,
    SUM(
        CASE
            WHEN platform = 'tablet' THEN 1
            ELSE 0
        END
    ) AS dru_tablet
FROM mone
WHERE userid IS NOT NULL
GROUP BY ts_date