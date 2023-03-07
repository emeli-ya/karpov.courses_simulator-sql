/*
Сначала на основе таблицы orders сформируйте новую таблицу с общим числом заказов по дням. 
При подсчёте числа заказов не учитывайте отменённые заказы. 
Колонку с днями назовите date, а колонку с числом заказов — orders_count.
Затем поместите полученную таблицу в подзапрос и примените к ней оконную функцию в паре с агрегирующей функцией SUM 
для расчёта накопительной суммы числа заказов. Колонку с накопительной суммой назовите orders_cum_count. 
В результате такой операции значение накопительной суммы для последнего дня должно получиться равным общему числу заказов за весь период.

Поля в результирующей таблице: date, orders_count, orders_cum_count
*/

SELECT date,
       orders_count,
       sum(orders_count) OVER(ORDER BY date) orders_cum_count
FROM   (SELECT cast(creation_time as date) as date,
               count(order_id) as orders_count
        FROM   orders
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY cast(creation_time as date)) t1
