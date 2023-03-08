/*
для каждого дня рассчитайте следующие показатели:

Число платящих пользователей на одного активного курьера.
Число заказов на одного активного курьера.
Колонки с показателями назовите соответственно users_per_courier и orders_per_courier. 
Колонку с датами назовите date. При расчёте показателей округляйте значения до двух знаков после запятой.

В расчётах учитывайте только неотменённые заказы. 
При расчёте числа курьеров учитывайте только тех, которые в текущий день приняли хотя бы один заказ (который был в последствии доставлен) 
или доставили любой заказ. При расчёте числа пользователей также учитывайте только тех, кто сделал хотя бы один заказ.

Результирующая таблица должна быть отсортирована по возрастанию даты.

Поля в результирующей таблице: date, users_per_courier, orders_per_courier
*/

with t1 as (SELECT time::date as date,
                   count(distinct user_id) as paying_users
            FROM   user_actions
            WHERE  action = 'create_order'
                   and order_id not in (SELECT order_id
                                    FROM   user_actions
                                    WHERE  action = 'cancel_order')
            GROUP BY date
            ORDER BY date), 
      t2 as (SELECT time::date as date, count(distinct courier_id) as active_couriers
             FROM   courier_actions
             WHERE  (action = 'accept_order'
                     or action = 'deliver_order')
                     and order_id not in (SELECT order_id
                                          FROM   user_actions
                                          WHERE  action = 'cancel_order')
                       GROUP BY date
                       ORDER BY date),
       q1 as (SELECT time::date as date, count(order_id) as orders
              FROM   user_actions
              WHERE  order_id not in (SELECT order_id
                                    FROM   user_actions
                                    WHERE  action = 'cancel_order')
            GROUP BY date
            ORDER BY date)
select t1.date, round(paying_users::decimal/active_couriers,2) as users_per_courier,
round(orders::decimal/active_couriers,2) as orders_per_courier
from t1 
left join t2
on t1.date = t2.date
left join q1
on t1.date = q1.date
