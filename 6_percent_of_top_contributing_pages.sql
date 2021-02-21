/*
QUESTION 6:

Using SQL, provide the percent of the top contributing 
page of each day out of all the days.

The required results:
    ts_date, 
    page_before_subscription , 
    Percentage out of total subscription that day, 
    Percentage out of total subscription 

The Percentage should have 2 places after the decimal 
and with ‘%’ sign

Dialect: POSTGRESQL

RESULT:
|ts_date   |page_before_subscription|percent_of_daily_total|percent_frm_total_sub|
|----------|------------------------|----------------------|---------------------|
|2020-06-01|checkout                |  47.25%              |  22.11%             |
|2020-06-01|portfolio               |   1.83%              |    .86%             |
|2020-06-01|premium                 |  43.22%              |  20.22%             |
|2020-06-01|lp_premium_1_screeners  |   2.75%              |   1.29%             |
|2020-06-01|lp_premium_1            |   2.56%              |   1.20%             |
|2020-06-01|lp_premium_testimonials |   2.38%              |   1.11%             |
|2020-06-02|premium                 |  42.31%              |  19.11%             |
|2020-06-02|portfolio               |   2.28%              |   1.03%             |
|2020-06-02|checkout                |  50.66%              |  22.88%             |
|2020-06-02|lp_premium_1_screeners  |   2.66%              |   1.20%             |
|2020-06-02|subs                    |   2.09%              |    .94%             |
|2020-06-03|checkout                |  54.26%              |   4.37%             |
|2020-06-03|premium                 |  45.74%              |   3.68%             |

*/

-- This is for code just for replication and testing the query
-- It may be different than what is provided in the assignment

with data_ref(
    ts_date,
    page_before_subscription,
    total_subscriptions
) as (
    values ('2020-06-01', 'checkout', 258),
        ('2020-06-01', 'portfolio', 10),
        ('2020-06-01', 'premium', 236),
        ('2020-06-01', 'lp_premium_1_screeners', 15),
        ('2020-06-01', 'lp_premium_1', 14),
        ('2020-06-01', 'lp_premium_testimonials', 13),
        ('2020-06-02', 'premium', 223),
        ('2020-06-02', 'portfolio', 12),
        ('2020-06-02', 'checkout', 267),
        ('2020-06-02', 'lp_premium_1_screeners', 14),
        ('2020-06-02', 'subs', 11),
        ('2020-06-03', 'checkout', 51),
        ('2020-06-03', 'premium', 43)
)

-- Solution Start's Here ...
SELECT 
ts_date,
page_before_subscription,
TO_CHAR(ROUND(total_subscriptions*1.0/sum(total_subscriptions)over(partition by ts_date),4)*100, '999D99%') as percent_of_daily_total,
TO_CHAR(ROUND(total_subscriptions*1.0/sum(total_subscriptions)over(),4)*100, '999D99%') as percent_frm_total_sub
FROM data_ref