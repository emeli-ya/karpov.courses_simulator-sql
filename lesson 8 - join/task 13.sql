/*
Используя запрос из предыдущего задания, рассчитайте суммарную стоимость каждого заказа. 
Выведите колонки с id заказов и их стоимостью. Колонку со стоимостью заказа назовите order_price. 
Результат отсортируйте по возрастанию id заказа.
Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

Поля в результирующей таблице: order_id, order_pric
*/

SELECT order_id, SUM(price) AS order_price 
FROM ( SELECT order_id, product_ids, UNNEST(product_ids) AS product_id FROM orders ) t1 
LEFT JOIN products USING(product_id) 
GROUP BY order_id 
ORDER BY order_id 
LIMIT 1000
