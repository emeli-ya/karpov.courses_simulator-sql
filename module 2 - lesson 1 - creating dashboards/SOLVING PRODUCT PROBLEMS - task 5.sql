/*
Для каждого дня рассчитайте следующие показатели:

Общее число заказов.
Число первых заказов (заказов, сделанных пользователями впервые).
Число заказов новых пользователей (заказов, сделанных пользователями в тот же день, когда они впервые воспользовались сервисом).
Долю первых заказов в общем числе заказов (долю п.2 в п.1).
Долю заказов новых пользователей в общем числе заказов (долю п.3 в п.1).
Колонки с показателями назовите соответственно orders, first_orders, new_users_orders, first_orders_share, new_users_orders_share. 
Колонку с датами назовите date. Проследите за тем, чтобы во всех случаях количество заказов было выражено целым числом. Все показатели с долями необходимо выразить в процентах. При расчёте долей округляйте значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, orders, first_orders, new_users_orders, first_orders_share, new_users_orders_share
*/

with q1 as 
 (select time::date as date, count(order_id) as orders
  from user_actions
  where order_id not in 
        (select order_id from user_actions where action = 'cancel_order')
  group by date
  order by date),
q2 as 
 (select min_date, count(user_id) as first_orders 
  from
    (select min(time::date) as min_date, user_id 
     from user_actions 
     where order_id not in (select order_id from user_actions where action = 'cancel_order') 
     group by user_id) t1
  group by min_date order by min_date),
q3 as 
 (select min_date, count(order_id) as new_users_orders
  from
     (select time::date as date, min(time::date) over(partition by user_id) as min_date, user_id, order_id
      from user_actions) t1
  where order_id not in (select order_id from user_actions where action = 'cancel_order') and date = min_date
  group by min_date order by min_date)
select date, orders, first_orders, new_users_orders, round(first_orders::decimal/orders*100,2) as first_orders_share,
round(new_users_orders::decimal/orders*100,2) as new_users_orders_share
from q1
left join q2 
on q1.date = q2.min_date
left join q3 
on q1.date = q3.min_date
