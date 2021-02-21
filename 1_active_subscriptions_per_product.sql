/*
QUESTION 1:
List the number of active subscriptions per product in 
descending order. 

Dialect: POSTGRESQL

Result:
|productid|num_active_subscription|
|---------|-----------------------|
|pro      |                      2|
|mp       |                      1|
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


-- Solution Start's Here ...
SELECT ProductId,
    COUNT(SubscriptionId) as num_active_subscription
FROM subscription
WHERE (
        SubscriptionStartDate IS NOT NULL
        AND SubscriptionEndDate IS NULL
    )
GROUP BY ProductId
ORDER BY num_active_subscription desc