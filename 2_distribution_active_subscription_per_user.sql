/*
QUESTION 2:
Create the distribution of active subscriptions per user 
i.e how many users have 1 subscription, how many have 2 
subscriptions, how many have 3 subscriptions and so on. 

Dialect: POSTGRESQL

Result:
|num_active_subs_per_user|num_of_users|
|------------------------|------------|
|                       1|           2|
|                       2|           1|
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
        (8943,'2j12f5k','mp','2018-01-20',NULL),
        (12345,'2j13d5k','mp','2018-01-20',NULL)
),


-- Solution Start's Here ...
, active_subscription_per_user as(
    SELECT UserId,
        COUNT(SubscriptionId) as num_active_subs_per_user
    FROM subscription
    WHERE (
            SubscriptionStartDate IS NOT NULL
            AND SubscriptionEndDate IS NULL
        )
    GROUP BY UserId
)

SELECT num_active_subs_per_user,
    count(UserId) as num_of_users
FROM active_subscription_per_user
GROUP BY num_active_subs_per_user
ORDER BY num_active_subs_per_user ASC
