/*
Для каждого пользователя в таблице user_actions посчитайте порядковый номер каждого заказа.
Отменённые заказы не учитывайте. Новую колонку с порядковым номером заказа назовите order_number. 
Результат отсортируйте сначала по возрастанию id пользователя, затем по возрастанию order_number. 
Добавьте LIMIT 1000.

Поля в результирующей таблице: user_id, order_id, time, order_number
*/

SELECT user_id,
       order_id,
       time,
       row_number() OVER(PARTITION BY user_id
                         ORDER BY time) as order_number
FROM   user_actions
WHERE  order_id not in (SELECT order_id
                        FROM   user_actions
                        WHERE  action = 'cancel_order') limit 1000
