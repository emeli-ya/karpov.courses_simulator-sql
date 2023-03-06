/*
Посчитайте, сколько пользователей никогда не отменяли свой заказ. 
Полученный столбец назовите users_count.

Поле в результирующе таблице: users_count
*/

SELECT COUNT(DISTINCT user_id) - COUNT(DISTINCT user_id) FILTER (WHERE action='cancel_order') AS users_count 
FROM user_actions
