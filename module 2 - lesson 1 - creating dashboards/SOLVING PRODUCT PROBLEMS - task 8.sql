/*
для каждого часа в сутках рассчитайте следующие показатели:

Число успешных (доставленных) заказов.
Число отменённых заказов.
Долю отменённых заказов в общем числе заказов (cancel rate).
Колонки с показателями назовите соответственно successful_orders, canceled_orders, cancel_rate. 
Колонку с часом оформления заказа назовите hour. П
ри расчёте доли отменённых заказов округляйте значения до трёх знаков после запятой.

Результирующая таблица должна быть отсортирована по возрастанию колонки с часом оформления заказа.

Поля в результирующей таблице: hour, successful_orders, canceled_orders, cancel_rate
*/

with t1 as (select extract (hour from creation_time) as hour, count(order_id) as canceled_orders
            from orders
            where order_id not in (select order_id from courier_actions where action = 'deliver_order')
            group by hour
            order by hour),
t2 as (select extract (hour from creation_time) as hour, count(order_id) as successful_orders
       from orders
       where order_id in (select order_id from courier_actions where action = 'deliver_order')
       group by hour
       order by hour)
select t1.hour::int, successful_orders, canceled_orders, round(canceled_orders::decimal/(successful_orders+canceled_orders),3) as cancel_rate
from t1
left join 
t2
on t1.hour = t2.hour
