/*
Для каждого товара за весь период времени рассчитайте следующие показатели:

Суммарную выручку, полученную от продажи этого товара за весь период.
Долю выручки от продажи этого товара в общей выручке, полученной за весь период.
Колонки с показателями назовите соответственно revenue и share_in_revenue. Колонку с наименованиями товаров назовите product_name.
Долю выручки с каждого товара необходимо выразить в процентах. При её расчёте округляйте значения до двух знаков после запятой.
Товары, округлённая доля которых в выручке составляет менее 0.5%, объедините в общую группу с названием «ДРУГОЕ» (без кавычек).
Результат должен быть отсортирован по убыванию выручки от продажи товара.

Поля в результирующей таблице: product_name, revenue, share_in_revenue
*/

select product_name, sum(revenue) as revenue, sum(share_in_revenue) as share_in_revenue
from (select name, revenue, round(revenue/(sum(revenue) over())*100,2) as share_in_revenue,
case when round(revenue/(sum(revenue) over())*100,2) < 0.5
then 'ДРУГОЕ'
else name
end as product_name
                        from (with t1 as (SELECT creation_time::date as date,
                   unnest(product_ids) as product_id,
                   order_id
            FROM   orders
            WHERE  order_id not in (SELECT order_id
                                    FROM   user_actions
                                    WHERE  action = 'cancel_order')), t2 as (SELECT product_id, name,
                                                price
                                         FROM   products)
SELECT name, sum(order_sum) as revenue
                FROM   (SELECT name, order_id, sum(price) as order_sum
                        FROM   t1
                            LEFT JOIN t2
                                ON t1.product_id = t2.product_id
                        GROUP BY name, order_id) Q1
                        group by name
                        order by revenue desc) a) b
                        group by product_name
                        order by revenue desc
