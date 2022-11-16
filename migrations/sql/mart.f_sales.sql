DELETE FROM mart.f_sales
 WHERE start_date = '{{ds}}' AND end_date = '{{ds}}';
 

INSERT INTO mart.f_sales (date_id, item_id, customer_id, city_id, quantity, payment_amount, status, start_date, end_date)
SELECT t2.*
  FROM (
            SELECT dc.date_id, 
                item_id,
                customer_id,
                city_id,
                quantity,
                CASE
                        WHEN uol.status = 'refunded' then -1 * payment_amount ELSE payment_amount
                END as payment_amount,
                uol.status,
                '{{ds}}'::date as start_date,
                '{{ds}}'::date as end_date
            FROM staging.user_order_log uol
            LEFT JOIN mart.d_calendar dc on uol.date_time::date = dc.date_actual) AS t2
WHERE NOT EXISTS (
   SELECT * 
     FROM mart.f_sales as ms
    WHERE ms.date_id::text = t2.date_id::text and ms.item_id = t2.item_id and ms.customer_id = t2.customer_id and ms.city_id = t2.item_id and
    ms.quantity = t2.quantity and ms.status = t2.status and ms.start_date = t2.start_date and ms.end_date = t2.end_date) ;