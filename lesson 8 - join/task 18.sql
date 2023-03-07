/*
Произведите замену списков с id товаров из таблицы orders на списки с наименованиями товаров. 
Наименования возьмите из таблицы products. Колонку с новыми списками наименований назовите product_names. 
Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

Поля в результирующей таблице: order_id, product_names
*/

SELECT order_id, array_agg(name) AS product_names 
FROM ( SELECT order_id, unnest(product_ids) AS product_id FROM orders ) t 
JOIN products 
USING(product_id) 
GROUP BY order_id 
LIMIT 1000
