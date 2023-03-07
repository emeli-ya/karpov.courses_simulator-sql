/*
Посчитайте количество уникальных id в колонке user_id, пришедшей из левой таблицы user_actions. 
Выведите это количество в качестве результата. Колонку с посчитанным значением назовите users_count.

Поле в результирующей таблице: users_count
*/

SELECT COUNT(DISTINCT a.user_id) AS users_count 
FROM user_actions a 
LEFT JOIN users b 
USING (user_id)
