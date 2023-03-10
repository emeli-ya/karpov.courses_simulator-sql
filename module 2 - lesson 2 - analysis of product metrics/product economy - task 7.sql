/*
Для каждого дня рассчитайте следующие показатели:

Выручку, полученную в этот день.
Затраты, образовавшиеся в этот день.
Сумму НДС с продажи товаров в этот день.
Валовую прибыль в этот день (выручка за вычетом затрат и НДС).
Суммарную выручку на текущий день.
Суммарные затраты на текущий день.
Суммарный НДС на текущий день.
Суммарную валовую прибыль на текущий день.
Долю валовой прибыли в выручке за этот день (долю п.4 в п.1).
Долю суммарной валовой прибыли в суммарной выручке на текущий день (долю п.8 в п.5).
Колонки с показателями назовите соответственно revenue, costs, tax, gross_profit, total_revenue, total_costs, total_tax, total_gross_profit, 
gross_profit_ratio, total_gross_profit_ratio
Колонку с датами назовите date.

Долю валовой прибыли в выручке необходимо выразить в процентах, округлив значения до двух знаков после запятой.
Результат должен быть отсортирован по возрастанию даты.

Поля в результирующей таблице: date, revenue, costs, tax, gross_profit, total_revenue, total_costs, total_tax, total_gross_profit, gross_profit_ratio,total_gross_profit_ratio
*/

with Q1 as (select date, sum(order_sb) as order_sb_t, 
case when date_part('month', date) = 8 then 120000 else 150000 end as fixed
from
(select creation_time::date as date, order_id, 
case 
when date_part('month', creation_time) = 8 
then 140 
else 115 
end as order_sb
from orders
where order_id not in (select order_id from user_actions where action = 'cancel_order')) t
group by date
order by date),
Q2 as (with b as (select date, courier_id, order_count, del_pay, 
case 
when date_part('month', date) = 8 and order_count >= 5 then 400
when date_part('month', date) = 9 and order_count >= 5 then 500
else 0 end as bonus
from
(select time::date as date, courier_id, count(order_id) order_count, count(order_id)*150 as del_pay 
from courier_actions
where action = 'deliver_order'
group by courier_id, date) a)
select date, sum(del_pay) as del_pay_t, sum(bonus) as bonus_t
from b
group by date
order by date),
cost as (select date, (order_sb_t+fixed+del_pay_t+bonus_t)::int as costs
from
(select Q1.date, order_sb_t, fixed, del_pay_t, bonus_t
from Q1
left join Q2
using (date)) c),
w as (select creation_time::date as date, order_id, unnest(product_ids) as product_id
from orders
where order_id not in (select order_id from user_actions where action = 'cancel_order')),
e as (SELECT product_id, name, price, 
CASE WHEN name IN 
('сахар', 'сухарики', 'сушки', 'семечки', 'масло льняное', 'виноград', 'масло оливковое', 'арбуз', 
'батон', 'йогурт', 'сливки', 'гречка', 'овсянка', 'макароны', 'баранина', 'апельсины', 'бублики', 
'хлеб', 'горох', 'сметана', 'рыба копченая', 'мука', 'шпроты', 'сосиски', 'свинина', 'рис', 
'масло кунжутное', 'сгущенка', 'ананас', 'говядина', 'соль', 'рыба вяленая', 'масло подсолнечное', 
'яблоки', 'груши', 'лепешка', 'молоко', 'курица', 'лаваш', 'вафли', 'мандарины') 
THEN ROUND(price/110*10, 2) 
ELSE ROUND(price/120*20, 2) 
END AS tax
FROM products),
tax as (select date, sum(tax) as tax
from w 
left join e 
using (product_id)
group by date
order by date),
rev as (SELECT date, sum(order_sum) as revenue
FROM   (SELECT DISTINCT date, order_id, sum(price) as order_sum
        FROM w 
        LEFT JOIN e 
        using (product_id)
        GROUP BY order_id, date) t3
GROUP BY date)
select date, revenue, costs, tax, gross_profit, total_revenue, total_costs::decimal, total_tax, total_gross_profit,
round(gross_profit/revenue*100,2) as gross_profit_ratio, round(total_gross_profit/total_revenue*100,2) as total_gross_profit_ratio
from
(select rev.date, revenue, costs, tax, (revenue-costs-tax) as gross_profit, sum(revenue) over(order by date) as total_revenue,
sum(costs) over(order by date) as total_costs, sum(tax) over(order by date) as total_tax, 
sum(revenue-costs-tax) over(order by date) as total_gross_profit
from rev
left join cost
using (date)
left join tax
using (date)) p
