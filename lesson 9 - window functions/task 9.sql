/*
Отметьте в отдельной таблице тех курьеров, которые доставили в сентябре заказов больше, чем в среднем все курьеры.
Если курьер доставил больше заказов, чем в среднем все курьеры, то в отдельном столбце укажите число 1, в противном случае укажите 0.
Колонку с результатом сравнения назовите is_above_avg, колонку с числом доставленных заказов каждым курьером — delivered_orders, 
а колонку со средним значением — avg_delivered_orders. При расчёте среднего значения округлите его до двух знаков после запятой. 
Результат отсортируйте по возрастанию id курьера.

Поля в результирующей таблице: courier_id, delivered_orders, avg_delivered_orders, is_above_avg
*/

SELECT courier_id,
       delivered_orders,
       round(avg(delivered_orders) OVER(), 2) as avg_delivered_orders,
       case when delivered_orders > avg(delivered_orders) OVER() then 1
            else 0 end as is_above_avg
FROM   (SELECT courier_id,
               count(distinct order_id) as delivered_orders
        FROM   courier_actions
        WHERE  date_part('month', time)::varchar = '9'
        GROUP BY courier_id) t1
ORDER BY courier_id
