/*
Возьмите запрос, составленный на одном из прошлых уроков, и подтяните в него из таблицы users данные о поле пользователей таким образом, 
чтобы все пользователи из таблицы users_actions остались в результате. 
Затем посчитайте среднее значение cancel_rate для каждого пола, округлив его до трёх знаков после запятой. 
Колонку с посчитанным средним значением назовите avg_cancel_rate.

Помните про отсутствие информации о поле некоторых пользователей после join, так как не все пользователи из таблицы user_action есть в таблице users. 
Для этой группы тоже посчитайте cancel_rate и в результирующей таблице для пустого значения в колонке с полом укажите ‘unknown’ (без кавычек). 
Результат отсортируйте по колонке с полом пользователя по возрастанию.

Поля в результирующей таблице: sex, avg_cancel_rate
*/

SELECT COALESCE(sex, 'unknown') AS sex, ROUND(AVG(cancel_rate), 3) AS avg_cancel_rate 
FROM ( 
   SELECT user_id, sex, COUNT(DISTINCT order_id) FILTER (WHERE action = 'cancel_order')::decimal / COUNT(DISTINCT order_id) AS cancel_rate 
   FROM user_actions 
   LEFT JOIN users USING(user_id) 
   GROUP BY user_id, sex 
   ORDER BY cancel_rate DESC ) t 
GROUP BY sex 
ORDER BY sex
