/*
Сначала на основе таблицы orders сформируйте новую таблицу с общим числом заказов по дням. 
При подсчёте числа заказов не учитывайте отменённые заказы. Колонку с числом заказов назовите orders_count.
Затем поместите полученную таблицу в подзапрос и примените к ней оконную функцию в паре с агрегирующей функцией AVG 
для расчёта скользящего среднего числа заказов. Скользящее среднее для каждой записи считайте по трём предыдущим дням.
Полученные значения скользящего среднего округлите до двух знаков после запятой. 
Колонку с рассчитанным показателем назовите moving_avg.

Поля в результирующей таблице: date, orders_count, moving_avg
*/

SELECT date,
       orders_count,
       round(avg(orders_count) OVER(ORDER BY date rows between 3 preceding and 1 preceding),
             2) as moving_avg
FROM   (SELECT cast(creation_time as date) as date,
               count(order_id) as orders_count
        FROM   orders
        WHERE  order_id not in (SELECT order_id
                                FROM   user_actions
                                WHERE  action = 'cancel_order')
        GROUP BY cast(creation_time as date)) t1
