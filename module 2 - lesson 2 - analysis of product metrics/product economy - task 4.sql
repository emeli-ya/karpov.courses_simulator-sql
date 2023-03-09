/*
Для каждого дня недели рассчитайте следующие показатели:

Выручку на пользователя (ARPU).
Выручку на платящего пользователя (ARPPU).
Выручку на заказ (AOV).
При расчётах учитывайте данные только за период с 26 августа 2022 года по 8 сентября 2022 года включительно.

В результирующую таблицу включите как наименования дней недели (например, Monday), 
так и порядковый номер дня недели (от 1 до 7, где 1 — это Monday, 7 — это Sunday).

Колонки с показателями назовите соответственно arpu, arppu, aov. 
Колонку с наименованием дня недели назовите weekday, а колонку с порядковым номером дня недели weekday_number.
При расчёте всех показателей округляйте значения до двух знаков после запятой.
Результат должен быть отсортирован по возрастанию порядкового номера дня недели.

Поля в результирующей таблице: weekday, weekday_number, arpu, arppu, aov
*/

SELECT t2.weekday, t2.weekday_number,
       round(revenue::decimal / users, 2) as arpu,
       round(revenue::decimal / paying_users, 2) as arppu,
       round(revenue::decimal / orders, 2) as aov
FROM   (SELECT weekday, weekday_number,
               count(distinct order_id) as orders,
               sum(price) as revenue
        FROM   (SELECT to_char(creation_time, 'Day') as weekday, DATE_PART('isodow', creation_time) AS weekday_number, order_id,
                       creation_time,
                       unnest(product_ids) as product_id
                FROM   orders
                WHERE  order_id not in (SELECT order_id
                                        FROM   user_actions
                                        WHERE  action = 'cancel_order') and creation_time BETWEEN '2022-08-26' AND '2022-09-09') t1
            LEFT JOIN products using(product_id)
        GROUP BY weekday, weekday_number) t2
    LEFT JOIN (SELECT to_char(time, 'Day') as weekday, DATE_PART('isodow', time) AS weekday_number,
                      count(distinct user_id) as users
               FROM   user_actions
               where time BETWEEN '2022-08-26' AND '2022-09-09'
               GROUP BY weekday, weekday_number) t3 using (weekday_number)
    LEFT JOIN (SELECT to_char(time, 'Day') as weekday, DATE_PART('isodow', time) AS weekday_number,
                      count(distinct user_id) as paying_users
               FROM   user_actions
               WHERE  order_id not in (SELECT order_id
                                       FROM   user_actions
                                       WHERE  action = 'cancel_order') and time BETWEEN '2022-08-26' AND '2022-09-09'
               GROUP BY weekday, weekday_number) t4 using (weekday_number)
ORDER BY weekday_number
