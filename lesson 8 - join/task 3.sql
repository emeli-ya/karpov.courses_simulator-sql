/*
С помощью LEFT JOIN объедините таблицы user_actions и users. 
Обратите внимание на порядок таблиц — слева users_actions, справа users. В результат включите две колонки с user_id из обеих таблиц. 
Эти две колонки назовите соответственно user_id_left и user_id_right. 
Также в результат включите колонки order_id, time, action, sex, birth_date. 
Отсортируйте получившуюся таблицу по возрастанию id пользователя (в колонке из левой таблицы).

Поля в результирующей таблице: user_id_left, user_id_right,  order_id, time, action, sex, birth_date
*/

SELECT a.user_id AS user_id_left, b.user_id AS user_id_right, order_id, time, action, sex, birth_date 
FROM user_actions a 
LEFT JOIN users b 
USING (user_id) 
ORDER BY user_id_left 
LIMIT 1000
