/*
Oтберите из таблицы courier_actions всех курьеров, которые работают 10 и более дней. 
Также рассчитайте, сколько заказов они уже успели доставить за всё время работы.
Текущей отметкой времени считайте время последнего действия в таблице courier_actions. 
Учитывайте только целые дни, прошедшие с первого выхода курьера на работу (часы и минуты не учитывайте).

В результат включите три колонки: id курьера, продолжительность работы в днях и число доставленных заказов. 
Две новые колонки назовите соответственно days_employed и delivered_orders. 
Результат отсортируйте сначала по убыванию количества отработанных дней, затем по возрастанию id курьера.

Поля в результирующей таблице: courier_id, days_employed, delivered_orders
*/

SELECT courier_id,
       days_employed,
       delivered_orders
FROM   (SELECT DISTINCT courier_id,
                        date_part('days',
                                  max(time) OVER()-min(time) OVER(PARTITION BY courier_id)) days_employed,
                        count(order_id) OVER(PARTITION BY courier_id)/2 as delivered_orders
        FROM   courier_actions) t1
WHERE  days_employed >= 10
ORDER BY 2 desc, 1
