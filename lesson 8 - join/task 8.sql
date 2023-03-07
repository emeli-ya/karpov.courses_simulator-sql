/*
Из таблицы users отберите id первых 100 пользователей и объедините их со всеми наименованиями товаров из таблицы products. 
Выведите две колонки — id пользователя и наименование товара. 
Результат отсортируйте сначала по возрастанию id пользователя, затем по имени товара — тоже по возрастанию.

Поля в результирующей таблице: user_id, name
*/

SELECT user_id, name 
FROM ( SELECT user_id FROM users LIMIT 100 ) t1 
CROSS JOIN ( SELECT name FROM products ) t2 
ORDER BY user_id, name
