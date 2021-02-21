/*
QUESTION 4:

Create a time series of DRU who used one platform exclusively 
on a given day, the results should be a table with ts_date 
column and 3 DRU columns

Dialect: POSTGRESQL

Result:
|ts_date   |dru_desktop_only|dru_mobile_only|dru_tablet_only|
|----------|----------------|---------------|---------------|
|2018-07-09|               1|              1|              0|
|2018-07-10|               1|              0|              0|

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

, data_ref as(
SELECT
    ts_date,
    userid,
    SUM(
        CASE
            WHEN platform = 'desktop' THEN 1
            ELSE 0
        END
    ) as on_desktop,
    SUM(
        CASE
            WHEN platform = 'mobile' THEN 1
            ELSE 0
        END
    ) as on_mobile,
    SUM(
        CASE
            WHEN platform = 'tablet' THEN 1
            ELSE 0
        END
    ) as on_tablet
    FROM mone
    WHERE userid IS NOT NULL
    GROUP BY ts_date,
        userid
)

SELECT ts_date,
    SUM(
        case
            when (on_desktop > 0
            and (on_mobile + on_tablet) = 0) THEN 1
            ELSE 0
        END
    ) as dru_desktop_only,
    SUM(
        case
            when (on_mobile > 0
            and (on_desktop + on_tablet) = 0) THEN 1
            ELSE 0
        END
    ) as dru_mobile_only,
    SUM(
        case
            when (on_tablet > 0
            and (on_desktop + on_mobile) = 0) THEN 1
            ELSE 0
        END
    ) as dru_tablet_only
FROM data_ref
GROUP BY ts_date
ORDER BY ts_date asc
