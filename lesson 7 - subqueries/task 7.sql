/*
Из таблицы user_actions отберите все заказы, которые не были отменены пользователями. 
Выведите колонку с id этих заказов. Результат запроса отсортируйте по возрастанию id заказа. 
Выведите только первые 1000 строк результирующей таблицы.

Поле в результирующей таблице: order_id
*/

SELECT order_id 
FROM user_actions 
WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order') 
ORDER BY order_id 
LIMIT 1000
