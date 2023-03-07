/*
Возьмите запрос из задания 3, где вы объединяли таблицы user_actions и users с помощью LEFT JOIN, 
добавьте к запросу оператор WHERE и исключите NULL значения в колонке user_id из правой таблицы. 
Включите в результат все те же колонки и отсортируйте получившуюся таблицу по возрастанию id пользователя в колонке из левой таблицы.

Поля в результирующей таблице: user_id_left, user_id_right,  order_id, time, action, sex, birth_date
*/

SELECT a.user_id AS user_id_left, b.user_id AS user_id_right, order_id, time, action, sex, birth_date 
FROM user_actions a 
LEFT JOIN users b 
USING (user_id) 
WHERE b.user_id IS NOT NULL 
ORDER BY user_id_left 
LIMIT 1000
