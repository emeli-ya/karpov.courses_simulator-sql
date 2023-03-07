/*
рассчитайте ежедневную выручку сервиса и отразите её в колонке daily_revenue. Затем посчитайте ежедневный прирост выручки. 
Прирост выручки отразите как в абсолютных значениях, так и в % относительно предыдущего дня. 
Колонку с абсолютным приростом назовите revenue_growth_abs, а колонку с относительным — revenue_growth_percentage.

Для самого первого дня укажите прирост равным 0 в обеих колонках. При проведении расчётов отменённые заказы не учитывайте. 
Результат отсортируйте по колонке с датами по возрастанию.

Метрики daily_revenue, revenue_growth_abs, revenue_growth_percentage округлите до одного знака.

Поля в результирующей таблице: date, daily_revenue, revenue_growth_abs, revenue_growth_percentage
*/

with t2 as (SELECT DISTINCT date,
                            sum(price) OVER (PARTITION BY date) daily_revenue
            FROM   (SELECT order_id,
                           cast(creation_time as date) as date,
                           unnest(product_ids) as product_id
                    FROM   orders) t1
                LEFT JOIN products using(product_id)
            WHERE  order_id not in (SELECT order_id
                                    FROM   user_actions
                                    WHERE  action = 'cancel_order')
            ORDER BY date)
SELECT date,
       daily_revenue,
       coalesce(round(daily_revenue-(lag(daily_revenue, 1) OVER()), 1),
                0) as revenue_growth_abs,
       coalesce(round(((daily_revenue-(lag(daily_revenue, 1) OVER()))*100/lag(daily_revenue, 1) OVER()), 1),
                0) as revenue_growth_percentage
FROM   t2
