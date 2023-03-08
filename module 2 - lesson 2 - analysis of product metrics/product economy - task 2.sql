/*
Для каждого дня рассчитайте следующие показатели:

Выручку на пользователя (ARPU) за текущий день.
Выручку на платящего пользователя (ARPPU) за текущий день.
Выручку с заказа, или средний чек (AOV) за текущий день.

При расчёте всех показателей округляйте значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты. 

Поля в результирующей таблице: date, arpu, arppu, aov
*/

with t1 as (SELECT creation_time::date as date,
                   unnest(product_ids) as product_id,
                   order_id
            FROM   orders
            WHERE  order_id not in (SELECT order_id
                                    FROM   user_actions
                                    WHERE  action = 'cancel_order')), t2 as (SELECT product_id,
                                                price
                                         FROM   products), t3 as (SELECT date,
                                sum(order_sum) as revenue
                         FROM   (SELECT DISTINCT date,
                                                 order_id,
                                                 sum(price) as order_sum
                                 FROM   t1
                                     LEFT JOIN t2
                                         ON t1.product_id = t2.product_id
                                 GROUP BY order_id, date) t4
                         GROUP BY date), t5 as (SELECT time::date as date,
                              count(distinct user_id) as total_users
                       FROM   user_actions
                       GROUP BY date
                       ORDER BY date), t6 as (SELECT time::date as date,
                              count(distinct user_id) as paying_users
                       FROM   user_actions
                       WHERE  action = 'create_order'
                          and order_id not in (SELECT order_id
                                            FROM   user_actions
                                            WHERE  action = 'cancel_order')
                       GROUP BY date
                       ORDER BY date), t7 as (SELECT time::date as date,
                              count(order_id) as orders
                       FROM   user_actions
                       WHERE  order_id not in (SELECT order_id
                                               FROM   user_actions
                                               WHERE  action = 'cancel_order')
                       GROUP BY date
                       ORDER BY date)
SELECT t3.date,
       round(revenue::decimal/total_users, 2) as arpu,
       round(revenue::decimal/paying_users, 2) as arppu,
       round(revenue::decimal/orders, 2) as aov
FROM   t3
    LEFT JOIN t5
        ON t3.date = t5.date
    LEFT JOIN t6
        ON t3.date = t6.date
    LEFT JOIN t7
        ON t3.date = t7.date
