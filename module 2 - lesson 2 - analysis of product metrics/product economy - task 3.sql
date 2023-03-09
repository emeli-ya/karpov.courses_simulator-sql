/*
для каждого дня рассчитайте следующие показатели:

Накопленную выручку на пользователя (Running ARPU).
Накопленную выручку на платящего пользователя (Running ARPPU).
Накопленную выручку с заказа, или средний чек (Running AOV).
Колонки с показателями назовите соответственно running_arpu, running_arppu, running_aov. Колонку с датами назовите date. 

При расчёте всех показателей округляйте значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты. 

Поля в результирующей таблице: date, running_arpu, running_arppu, running_aov
*/

with t1 as (SELECT creation_time::date as date,
                   unnest(product_ids) as product_id,
                   order_id
            FROM   orders
            WHERE  order_id not in (SELECT order_id
                                    FROM   user_actions
                                    WHERE  action = 'cancel_order')), t2 as (SELECT product_id,
                                                price
                                         FROM   products),
       t3 as (select date, sum(revenue) over (order by date) as run_revenue from
        (SELECT date,
                sum(order_sum) as revenue
        FROM   (SELECT DISTINCT date, order_id, sum(price) as order_sum
                FROM   t1
                LEFT JOIN t2
                ON t1.product_id = t2.product_id
                GROUP BY order_id, date) t4
                group by date) Q1),
        t5 as (select date, sum(new_users_count) over(order by date) as run_users, 
        sum(new_paying_users_count) over(order by date) as run_paying_users from (SELECT time::DATE as date, 
        COUNT(DISTINCT user_id) FILTER (WHERE time::DATE = first_date) AS new_users_count,
        COUNT(DISTINCT user_id) FILTER (WHERE time::DATE = first_order) AS new_paying_users_count
    FROM
        (SELECT user_id, MIN(time::DATE) AS first_date, MIN(time::DATE) FILTER (WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order')) AS first_order
        FROM user_actions
        GROUP BY user_id) AS Q1
    LEFT JOIN user_actions USING(user_id) group by date) QQ
    GROUP BY date, new_users_count, new_paying_users_count), 
                       t7 as (select date, sum(orders) over(order by date) as run_orders from (SELECT time::date as date,
                              count(order_id) as orders
                       FROM   user_actions
                       WHERE  order_id not in (SELECT order_id
                                               FROM   user_actions
                                               WHERE  action = 'cancel_order')
                       GROUP BY date
                       ORDER BY date) Q4)
SELECT t3.date,
       round(run_revenue::decimal/run_users, 2) as running_arpu,
       round(run_revenue::decimal/run_paying_users, 2) as running_arppu,
       round(run_revenue::decimal/run_orders, 2) as running_aov
FROM   t3
    LEFT JOIN t5
        ON t3.date = t5.date
    LEFT JOIN t7
        ON t3.date = t7.date
