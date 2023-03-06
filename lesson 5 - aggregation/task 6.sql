/*
Посчитайте количество заказов в таблице orders с девятью и более товарами.  
Полученный столбец назовите orders_count.
Поле в результирующей таблице: orders_count
*/

SELECT COUNT(order_id) AS orders_count 
FROM orders 
WHERE array_length(product_ids, 1) >= 9
