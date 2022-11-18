INSERT INTO mart.f_customer_retention (
	period_name,
	period_id,
	item_id,
	new_customers_count,
	new_customers_revenue,
	returning_customers_count,
	returning_customers_revenue,
	refunded_customers_count,
	customers_refunded)
WITH summary AS (
				SELECT       d.week_of_month || '.' || d.month_actual AS period_id,
                             d.date_actual,
                             s.date_id,
                             s.item_id,
                             s.customer_id,
                             s.status,
                             s.payment_amount,
                             s.quantity
                 FROM mart.f_sales s
                 LEFT JOIN mart.d_calendar AS d ON s.date_id = d.date_id),
     customers AS (
     			SELECT 	  	 period_id,
                          	 item_id,
                          	 count(*)            AS count_customer,
                          	 sum(payment_amount) AS payment_customer
                  FROM summary s2
                 GROUP BY period_id, item_id),
     refunded_customer AS (
    			SELECT 		 period_id,
                             item_id,
                             count(*)      AS count_customer,
                             sum(quantity) AS quantity_customer
                  FROM summary s2
                 WHERE s2.status = 'refunded'
				 GROUP BY customer_id, period_id, item_id),
     summary_ids AS (
       			SELECT DISTINCT 'weekly' AS period_name, period_id, item_id
                  FROM summary
     )
   select t2.*
  from ( SELECT 
         case when s.period_name is null then '0' else  s.period_name end AS p1,
         case when s.period_id is null then '0' else s.period_id end AS p2,
         case when s.item_id  is null then 0 else s.item_id end AS p3,
         case when new_customers.new_customers_count is null then 0 else new_customers.new_customers_count end AS p4,
         case when new_customers.new_customers_revenue is null then 0 else new_customers.new_customers_revenue end AS p5,
         case when returning_customers.returning_customers_count is null then 0 else returning_customers.returning_customers_count end AS p6,
         case when returning_customers.returning_customers_revenue is null then 0 else returning_customers.returning_customers_revenue end AS p7,
         case when refunded_customer.refunded_customer_count is null then 0 else refunded_customer.refunded_customer_count end AS p8,
         case when refunded_customer.customers_refunded is null then 0 else refunded_customer.customers_refunded end AS p9
   FROM summary_ids s
   LEFT JOIN
      (SELECT c.period_id,
               c.item_id,
               sum(c.count_customer)   new_customers_count,
               sum(c.payment_customer) new_customers_revenue
         FROM customers c
         WHERE c.count_customer = 1
         GROUP BY c.period_id, c.item_id) new_customers
      ON s.period_id = new_customers.period_id AND s.item_id = new_customers.item_id
   LEFT JOIN
      (SELECT c.period_id,
               c.item_id,
               sum(c.count_customer)   returning_customers_count,
               sum(c.payment_customer) returning_customers_revenue
         FROM customers c
         WHERE c.count_customer > 1
         GROUP BY c.period_id, c.item_id) returning_customers
      ON s.period_id = returning_customers.period_id AND s.item_id = returning_customers.item_id
   LEFT JOIN
      (SELECT c.period_id,
               c.item_id,
               sum(c.count_customer)    refunded_customer_count,
               sum(c.quantity_customer) customers_refunded
         FROM refunded_customer c
         GROUP BY c.period_id, c.item_id) refunded_customer
      ON s.period_id = refunded_customer.period_id AND s.item_id = refunded_customer.item_id ) AS t2
   where NOT EXISTS (
      select *
      from mart.f_customer_retention as fcr
      where fcr.period_name = t2.p1 AND
            fcr.period_id = t2.p2 AND
            fcr.item_id = t2.p3 AND
            new_customers_count = t2.p4 AND
	         new_customers_revenue = t2.p5 AND
	         returning_customers_count = t2.p6 AND
	         returning_customers_revenue = t2.p7 AND
	         refunded_customers_count = t2.p8 AND
	         customers_refunded = t2.p9
             );



