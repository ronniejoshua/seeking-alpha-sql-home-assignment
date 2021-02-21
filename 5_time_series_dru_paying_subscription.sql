/*
QUESTION 5:

Create a time series of DRU that are also paying for a subscription, 
the results should be a table with ts_Date column and 3 DRU 
columns (one for all paying, one for paying for pro, one for 
paying for mp) You can use the subscription table to determine 
who is a paying subscriber.

Dialect: POSTGRESQL

Result:
|ts_date   |all_paying_users|paying_for_pro|paying_for_mp|
|----------|----------------|--------------|-------------|
|2018-07-10|               2|             1|            1|
|2018-07-09|               1|             1|            0|

*/
-- This is for code just for replication and testing the query
-- It may be different than what is provided in the assignment

with subscription(
    UserId,
    SubscriptionId,
    ProductId,
    SubscriptionStartDate,
    SubscriptionEndDate
) as (
    values 
        (8943,'7h49f9s','pro','2018-03-04',NUll),
        (583689,'4h98f7v','mp','2017-12-27','2018-07-28'),
        (684,'5j43g2u','pro','2018-05-13',NULL),
        (8943,'2j12d5k','mp','2018-01-20','2018-03-01'),
        (12345,'2j13d5k','mp','2018-01-20',NULL)
)


, mone(ts_date, UserId, MachineCookie, Platform) as (
    values ('2018-07-10', 8943, 759827895732, 'desktop'),
        ('2018-07-10', 8943, 430928402308, 'tablet'),
        ('2018-07-10', 583689, 748927589287, 'desktop'),
        ('2018-07-09', 43984, 985420580298, 'mobile'),
        ('2018-07-09', 8943, 759827895732, 'desktop'),
        ('2018-07-09', NULL, 473878094774, 'mobile')
)

-- Solution Start's Here ...
, asu_data as (
    SELECT userid,
        productid,
        SubscriptionStartDate,
        SubscriptionEndDate
    FROM subscription
),

dru_data as (
    SELECT DISTINCT ts_date,
        userid
    FROM mone
    WHERE userid IS NOT NULL
)

,
data_ref as (
    SELECT d.ts_date,
        d.userid,
        a.productid
    FROM dru_data as d
        CROSS JOIN asu_data as a
    WHERE d.userid = a.userid
        AND (
            (
                d.ts_date >= a.SubscriptionStartDate
                AND a.SubscriptionEndDate IS NULL
            )
            OR (
                d.ts_date BETWEEN a.SubscriptionStartDate AND a.SubscriptionEndDate
            )
        )
),


SELECT ts_date,
    COUNT(userid) AS all_paying_users,
    SUM(
        CASE
            WHEN productid = 'pro' THEN 1
            ELSE 0
        END
    ) AS paying_for_pro,
    SUM(
        CASE
            WHEN productid = 'mp' THEN 1
            ELSE 0
        END
    ) AS paying_for_mp
FROM data_ref
GROUP BY ts_date;
