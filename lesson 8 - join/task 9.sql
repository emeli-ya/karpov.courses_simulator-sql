/*
Для начала объедините таблицы user_actions и orders. 
Выведите id пользователей и заказов, а также список товаров в заказе. 
Отсортируйте таблицу по id пользователя по возрастанию, затем по id заказа — тоже по возрастанию.
Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.

Поля в результирующей таблице: user_id, order_id, product_ids
*/

SELECT user_id, order_id, product_ids 
FROM user_actions 
LEFT JOIN orders 
USING(order_id) 
ORDER BY user_id, order_id 
LIMIT 1000
