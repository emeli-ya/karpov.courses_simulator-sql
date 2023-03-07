/*
Для каждого дня рассчитайте следующие показатели:

Долю пользователей, сделавших в этот день всего один заказ, в общем количестве платящих пользователей.
Долю пользователей, сделавших в этот день несколько заказов, в общем количестве платящих пользователей.
Колонки с показателями назовите соответственно single_order_users_share, several_orders_users_share. 
Колонку с датами назовите date. Все показатели с долями необходимо выразить в процентах. 
При расчёте долей округляйте значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, single_order_users_share, several_orders_users_share
*/

with t2 as (with t1 as (select time::date as date, user_id, count(distinct order_id) as order_count
from user_actions
where order_id not in (SELECT order_id
                                 FROM   user_actions
                                 WHERE  action = 'cancel_order')
group by date, user_id)
select date, count(distinct user_id) filter (where order_count = 1) as one_order,
count(distinct user_id) filter (where order_count >= 2) as two_orders
from t1
group by date),
t3 as (SELECT time::date as date,
                   count(distinct user_id) as paying_users
            FROM   user_actions
            WHERE  action = 'create_order'
               and order_id not in (SELECT order_id
                                 FROM   user_actions
                                 WHERE  action = 'cancel_order')
            GROUP BY date
            ORDER BY date)
select date, round(one_order::decimal/paying_users*100,2) as single_order_users_share, 
round(two_orders::decimal/paying_users*100,2) as several_orders_users_share
from t2
join t3
using (date)
