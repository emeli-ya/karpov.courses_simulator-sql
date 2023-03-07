/*
рассчитайте стоимость каждого заказа, ежедневную выручку сервиса и долю стоимости каждого заказа в ежедневной выручке, выраженную в процентах. 
В результат включите следующие колонки: id заказа, время создания заказа, стоимость заказа, выручку за день, в который был совершён заказ, 
а также долю стоимости заказа в выручке за день, выраженную в процентах.
При расчёте долей округляйте их до трёх знаков после запятой.

Результат отсортируйте сначала по убыванию даты совершения заказа (именно даты, а не времени), 
потом по убыванию доли заказа в выручке за день, затем по возрастанию id заказа.

При проведении расчётов отменённые заказы не учитывайте.

Поля в результирующей таблице: order_id, creation_time, order_price, daily_revenue, percentage_of_daily_revenue
*/

with t1 as (SELECT DISTINCT order_id,
                            creation_time,
                            sum(price) OVER (PARTITION BY order_id) order_price
            FROM   (SELECT order_id,
                           creation_time,
                           product_ids,
                           unnest(product_ids) as product_id
                    FROM   orders) as t
                LEFT JOIN products using(product_id)
            WHERE  order_id not in (SELECT order_id
                                    FROM   user_actions
                                    WHERE  action = 'cancel_order'))
SELECT order_id,
       creation_time,
       order_price,
       sum(order_price) OVER(PARTITION BY cast(creation_time as date)) daily_revenue,
       round((order_price/(sum(order_price) OVER(PARTITION BY cast(creation_time as date)))*100),
             3) percentage_of_daily_revenue
FROM   t1
ORDER BY cast(creation_time as date) desc, percentage_of_daily_revenue desc, order_id
