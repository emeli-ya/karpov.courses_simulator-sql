/*
Для каждой записи в таблице user_actions посчитайте, сколько заказов сделал и сколько отменил каждый пользователь на момент совершения нового действия.
Колонки назовите соответственно created_orders и canceled_orders. 
На основе этих двух колонок для каждой записи пользователя посчитайте показатель cancel_rate, 
т.е. долю отменённых заказов в общем количестве оформленных заказов. Значения показателя округлите до двух знаков после запятой. 
Колонку с ним назовите cancel_rate.

В результирующей таблице отразите все колонки из исходной таблицы вместе с новыми колонками. 
Отсортируйте результат по колонкам user_id, order_id, time — по возрастанию значений в каждой.
Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

Поля в результирующей таблице: user_id, order_id, action, time, created_orders, canceled_orders, cancel_rate
*/

SELECT user_id,
       order_id,
       action,
       time,
       created_orders,
       canceled_orders,
       round(canceled_orders::decimal/created_orders, 2) as cancel_rate
FROM   (SELECT user_id,
               order_id,
               action,
               time,
               count(action) filter (WHERE time in (SELECT time
                                             FROM   user_actions
                                             WHERE  action = 'create_order'))
        OVER(
        PARTITION BY user_id
        ORDER BY time rows between unbounded preceding and current row) as created_orders, count(action) filter (
        WHERE  time in (SELECT time
                        FROM   user_actions
                        WHERE  action = 'cancel_order'))
        OVER(
        PARTITION BY user_id
        ORDER BY time rows between unbounded preceding and current row) as canceled_orders
        FROM   user_actions) t1
ORDER BY user_id, order_id, time limit 1000
