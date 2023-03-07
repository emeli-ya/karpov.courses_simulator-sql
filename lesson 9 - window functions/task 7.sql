/*
На основе запроса из предыдущего задания для каждого пользователя рассчитайте, сколько в среднем времени проходит между его заказами. 
Не считайте этот показатель для тех пользователей, которые за всё время оформили лишь один заказ. 
Полученное среднее значение (интервал) переведите в часы, а затем округлите до целого числа. 
Колонку со средним значением часов назовите hours_between_orders. Результат отсортируйте по возрастанию id пользователя.
Добавьте LIMIT 1000.

Поля в результирующей таблице: user_id, hours_between_orders
*/

SELECT user_id,
       round(extract(epoch
FROM   avg(time_diff))/3600) as hours_between_orders
FROM   (SELECT user_id,
               order_id,
               time,
               row_number() OVER(PARTITION BY user_id
                                 ORDER BY time) as order_number,
               lag(time, 1) OVER(PARTITION BY user_id
                                 ORDER BY user_id) time_lag,
               time-lag(time, 1) OVER(PARTITION BY user_id
                                      ORDER BY user_id) as time_diff
        FROM   user_actions
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        ORDER BY user_id, order_number) t1
GROUP BY user_id having count(order_id) > 1 limit 1000
