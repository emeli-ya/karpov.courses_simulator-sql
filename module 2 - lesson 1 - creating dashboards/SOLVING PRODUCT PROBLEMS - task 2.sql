/*
Для каждого дня, представленного в таблицах user_actions и courier_actions, дополнительно рассчитайте следующие показатели:

Прирост числа новых пользователей.
Прирост числа новых курьеров.
Прирост общего числа пользователей.
Прирост общего числа курьеров.
Показатели, рассчитанные на предыдущем шаге, также включите в результирующую таблицу.

Колонки с новыми показателями назовите соответственно new_users_change, new_couriers_change, total_users_growth, total_couriers_growth. 
Колонку с датами назовите date.
Все показатели прироста считайте в процентах относительно значений в предыдущий день. 
При расчёте показателей округляйте значения до двух знаков после запятой.
Результирующая таблица должна быть отсортирована по возрастанию даты.

Поля в результирующей таблице: date, new_users, new_couriers, total_users, total_couriers, 
new_users_change, new_couriers_change, total_users_growth, total_couriers_growth
*/

select date, new_users, new_couriers, total_users, total_couriers, 
round(new_users::decimal*100/LU-100,2) as new_users_change, round(new_couriers::decimal*100/LC-100,2) as new_couriers_change,
round(total_users::decimal*100/LUU-100,2) as total_users_growth, round(total_couriers::decimal*100/LCC-100,2) as total_couriers_growth
from (with A as (SELECT start_date as date,
       new_users,
       new_couriers,
       (sum(new_users) OVER (ORDER BY start_date))::int as total_users,
       (sum(new_couriers) OVER (ORDER BY start_date))::int as total_couriers, lag(new_users,1) over() as LU, lag(new_couriers,1) over() as LC
FROM   (SELECT start_date,
               count(courier_id) as new_couriers
        FROM   (SELECT courier_id,
                       min(time::date) as start_date
                FROM   courier_actions
                GROUP BY courier_id) t1
        GROUP BY start_date) t2
    LEFT JOIN (SELECT start_date,
                      count(user_id) as new_users
               FROM   (SELECT user_id,
                              min(time::date) as start_date
                       FROM   user_actions
                       GROUP BY user_id) t3
               GROUP BY start_date) t4 using (start_date))
select date, new_users, new_couriers, total_users, total_couriers, 
LU, LC, lag(total_users,1) over() as LUU, lag(total_couriers,1) over() as LCC 
from A) as B
