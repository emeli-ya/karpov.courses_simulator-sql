/*
Рассчитайте возраст самого молодого курьера мужского пола в таблице couriers, 
но в этот раз в качестве первой даты используйте последнюю дату из таблицы courier_actions. 
Возраст курьера измерьте количеством лет, месяцев и дней и переведите его в тип VARCHAR. 
Полученную колонку со значением возраста назовите min_age.

Поле в результирующей таблице: min_age
*/

SELECT MIN(AGE((SELECT MAX(time)::DATE 
FROM courier_actions), birth_date))::varchar AS min_age 
FROM couriers 
WHERE sex = 'male'
