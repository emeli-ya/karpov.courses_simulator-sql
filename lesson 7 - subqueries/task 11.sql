/*
Назначьте скидку 15% на товары, цена которых превышает среднюю цену на все товары на 50 и более рублей, 
а также скидку 10% на товары, цена которых ниже средней на 50 и более рублей. 
Цену остальных товаров внутри диапазона (среднее - 50; среднее + 50) оставьте без изменений. 
При расчёте средней цены, округлите её до двух знаков после запятой.
Выведите информацию о всех товарах с указанием старой и новой цены. 
Колонку с новой ценой назовите new_price. 
Результат отсортируйте сначала по убыванию прежней цены в колонке price, затем по возрастанию id товара.

Поля в результирующей таблице: product_id, name, price, new_price
*/

WITH avg_price AS ( SELECT ROUND(AVG(price), 2) AS price FROM products ) 
SELECT product_id, name, price, 
CASE WHEN price >= (SELECT * FROM avg_price) + 50 THEN price*0.85 
WHEN price <= (SELECT * FROM avg_price) - 50 THEN price*0.9 ELSE price 
END AS new_price 
FROM products 
ORDER BY price DESC, product_id
