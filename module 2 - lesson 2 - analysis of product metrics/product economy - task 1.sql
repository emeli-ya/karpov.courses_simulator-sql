/*
Для каждого дня рассчитайте следующие показатели:

Выручку, полученную в этот день.
Суммарную выручку на текущий день.
Прирост выручки, полученной в этот день, относительно значения выручки за предыдущий день.
Колонки с показателями назовите соответственно revenue, total_revenue, revenue_change. Колонку с датами назовите date.

Прирост выручки рассчитайте в процентах и округлите значения до двух знаков после запятой.

Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, revenue, total_revenue, revenue_change
*/

with t1 as (select creation_time::date as date, unnest(product_ids) as product_id, order_id
            from orders
            where order_id not in (select order_id from user_actions where action = 'cancel_order')),
t2 as (select product_id, price
       from products)
select date, revenue, total_revenue, round((revenue-diff)/diff*100,2) as revenue_change
from
       (select date, revenue, sum(revenue) over(order by date rows between unbounded preceding and current row) as total_revenue, 
        lag(revenue,1) over (order by date) as diff
        from
             (select date, sum(order_sum) as revenue
              from
                    (select distinct date, order_id, sum(price) as order_sum
                     from t1
                     left join 
                      t2
                      on t1.product_id = t2.product_id
                      group by order_id, date) t3
          group by date) t4) t5
