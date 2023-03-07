/*
Выясните, какие пары товаров покупают вместе чаще всего. Пары товаров сформируйте на основе таблицы с заказами. Отменённые заказы не учитывайте. 
В качестве результата выведите две колонки — колонку с парами наименований товаров и колонку со значениями, 
показывающими, сколько раз конкретная пара встретилась в заказах пользователей. Колонки назовите соответственно pair и count_pair.
Пары товаров должны быть представлены в виде списков из двух наименований. 
Пары товаров внутри списков должны быть отсортированы в порядке возрастания наименования. 
Результат отсортируйте сначала по убыванию частоты встречаемости пары товаров в заказах, затем по колонке pair — по возрастанию.

Поля в результирующей таблице: pair, count_pair
*/

with TT as (select order_id, name from (select order_id, unnest(product_ids) as product_id from orders
where order_id not in (select order_id from user_actions where action = 'cancel_order')) T
join products
on T.product_id = products.product_id)
select array[t1.name, t2.name] as pair, count(distinct t1.order_id) as count_pair from TT as t1 inner join TT as t2 on t1.order_id = t2.order_id
where t1.name < t2.name and t1.name != t2.name
group by pair
order by count_pair desc, pair
