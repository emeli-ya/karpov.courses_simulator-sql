/*
По таблицам orders и courier_actions определите id десяти заказов, которые доставляли дольше всего.

Поле в результирующей таблице: order_id
*/

SELECT order_id 
FROM orders 
LEFT JOIN ( SELECT order_id, time FROM courier_actions WHERE action = 'deliver_order' ) AS t 
USING (order_id) 
ORDER BY time - creation_time DESC 
LIMIT 10
