/*
рассчитайте показатель дневного Retention для всех пользователей, разбив их на когорты по дате первого взаимодействия с нашим приложением.
В результат включите четыре колонки: месяц первого взаимодействия, дату первого взаимодействия, 
количество дней, прошедших с даты первого взаимодействия (порядковый номер дня начиная с 0), и само значение Retention.
Колонки со значениями назовите соответственно start_month, start_date, day_number, retention.
Метрику необходимо выразить в виде доли, округлив полученные значения до двух знаков после запятой.
Месяц первого взаимодействия укажите в виде даты, округлённой до первого числа месяца.
Результат должен быть отсортирован сначала по возрастанию даты первого взаимодействия, затем по возрастанию порядкового номера дня.
Поля в результирующей таблице: start_month, start_date, day_number, retention
*/

select date_trunc('month', start_date)::date as start_month, start_date, date - start_date as day_number,
round(count(distinct user_id)::decimal/max(count(distinct user_id)) over(partition by start_date),2) as retention
from
(select user_id, min(time::date) over(partition by user_id) as start_date, time::date as date
from user_actions) q
group by date, start_date
order by start_date
