/*
Выясните, кто заказывал и доставлял самые большие заказы. Самыми большими считайте заказы с наибольшим числом товаров.
Выведите id заказа, id пользователя и id курьера. Также в отдельных колонках укажите возраст пользователя и возраст курьера. 
Возраст измерьте числом полных лет. 
Считайте его относительно последней даты в таблице user_actions — как для пользователей, так и для курьеров. 
Колонки с возрастом назовите user_age и courier_age. Результат отсортируйте по возрастанию id заказа.

Поля в результирующей таблице: order_id, user_id, user_age, courier_id, courier_age
*/

WITH order_id_large_size AS ( SELECT order_id FROM orders WHERE array_length(product_ids, 1) = (SELECT MAX(array_length(product_ids, 1)) FROM orders) ) 
SELECT DISTINCT order_id, user_id, DATE_PART('year', AGE((SELECT MAX(time) FROM user_actions), users.birth_date)) AS user_age, 
courier_id, DATE_PART('year', AGE((SELECT MAX(time) FROM user_actions), couriers.birth_date)) AS courier_age 
FROM ( SELECT order_id, user_id FROM user_actions WHERE order_id IN (SELECT * FROM order_id_large_size) ) t1 
LEFT JOIN ( SELECT order_id, courier_id FROM courier_actions WHERE order_id IN (SELECT * FROM order_id_large_size) ) t2 
USING(order_id) 
LEFT JOIN users 
USING(user_id) 
LEFT JOIN couriers 
USING(courier_id) 
ORDER BY order_id
