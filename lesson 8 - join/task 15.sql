/*
По таблицам courier_actions , orders и products определите 10 самых популярных товаров, доставленных в сентябре 2022 года. 
Самыми популярными товарами будем считать те, которые встречались в заказах чаще всего. 
Если товар встречается в одном заказе несколько раз (было куплено несколько единиц товара), то при подсчёте учитываем только одну единицу товара. 
Выведите наименования товаров и сколько раз они встречались в заказах. Новую колонку с количеством покупок товара назовите times_purchased. 

Поля в результирующей таблице: name, times_purchased
*/

SELECT name, COUNT(product_id) AS times_purchased 
FROM ( 
    SELECT DISTINCT order_id, UNNEST(product_ids) AS product_id 
    FROM orders 
    WHERE order_id NOT IN (SELECT order_id FROM user_actions WHERE action = 'cancel_order') ) AS t 
LEFT JOIN products 
USING (product_id) 
GROUP BY name 
ORDER BY times_purchased DESC 
LIMIT 10
