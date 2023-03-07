/*
Выберите все колонки из таблицы orders, но в качестве последней колонки укажите функцию unnest, применённую к колонке product_ids. 
Новую колонку назовите product_id. Выведите только первые 100 записей результирующей таблицы. 

Поля в результирующей таблице: creation_time, order_id, product_ids, product_id
*/

SELECT creation_time, order_id, product_ids, unnest(product_ids) AS product_id 
FROM orders 
LIMIT 100
