DELETE FROM mart.f_sales
 WHERE start_date = '{{ds}}' AND end_date = '{{ds}}';
 


INSERT INTO mart.f_sales (date_id, item_id, customer_id, city_id, quantity, payment_amount, status, start_date, end_date)
SELECT dc.date_id,
	   item_id,
	   customer_id,
	   city_id,
	   quantity,
	   CASE
	   		WHEN uol.status = 'refunded' then -1 * payment_amount ELSE payment_amount
	   END as payment_amount,
	   uol.status,
	   '{{ds}}' as start_date,
	   '{{ds}}' as end_date
  FROM staging.user_order_log uol
  LEFT JOIN mart.d_calendar dc on uol.date_time::date = dc.date_actual;