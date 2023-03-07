/*
Для каждого дня, представленного в таблицах user_actions и courier_actions, рассчитайте следующие показатели:

Число новых пользователей.
Число новых курьеров.
Общее число пользователей на текущий день.
Общее число курьеров на текущий день.
Колонки с показателями назовите соответственно new_users, new_couriers, total_users, total_couriers. 
Колонку с датами назовите date. Проследите за тем, чтобы показатели были выражены целыми числами. 
Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, new_users, new_couriers, total_users, total_couriers
*/

with A as 
(select t3.date, new_users, new_couriers from (select date, count(user_id) as new_users from (select user_id, date_trunc('day', min(time))::date as date
from user_actions
group by user_id
order by user_id) t1
group by date
order by date) t3
left join
(select date, count(courier_id) as new_couriers from (select courier_id, date_trunc('day', min(time))::date as date
from courier_actions
group by courier_id
order by courier_id) t2
group by date
order by date) as t4
on t3.date = t4.date)
select date, new_users, new_couriers, 
sum(new_users) over(order by date)::integer as total_users, sum(new_couriers) over(order by date)::integer as total_couriers
from A
