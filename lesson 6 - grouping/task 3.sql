/*
Разбейте пользователей из таблицы users на группы по возрасту (возраст измеряем количеством полных лет) и посчитайте число пользователей каждого возраста. 
Колонку с возрастом назовите age, а колонку с числом пользователей — users_count. 
Отсортируйте полученный результат по возрастанию возраста. 
Не забудем и про тех пользователей, у которых вместо возраста будет пропуск, для этой группы также подсчитаем число пользователей.

Поля в результирующей таблице: age, users_count
*/

SELECT DATE_PART('year', AGE(birth_date)) AS age, COUNT(user_id) AS users_count 
FROM users 
GROUP BY age 
ORDER BY age
