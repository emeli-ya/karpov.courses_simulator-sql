/*
Посчитайте количество уникальных пользователей сервиса, количество уникальных заказов и рассчитайте, сколько заказов приходится на одного пользователя. 
Показатель числа заказов на пользователя округлите до двух знаков после запятой.
В результирующей таблице отобразите все три значения — поля назовите соответственно unique_users, unique_orders, orders_per_user. 
Все расчёты проведите на основе таблицы user_actions.
Поля в результирующей таблице: unique_users, unique_orders, orders_per_user
*/

SELECT COUNT(DISTINCT user_id) AS unique_users, COUNT(DISTINCT order_id) AS unique_orders, 
ROUND(COUNT(DISTINCT order_id)::decimal / COUNT(DISTINCT user_id), 2) AS orders_per_user 
FROM user_actions
