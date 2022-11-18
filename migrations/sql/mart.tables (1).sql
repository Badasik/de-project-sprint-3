DROP TABLE IF EXISTS mart.d_calendar CASCADE;
DROP TABLE IF EXISTS mart.d_city;
DROP TABLE IF EXISTS mart.d_customer CASCADE;
DROP TABLE IF EXISTS mart.d_item CASCADE;
DROP TABLE IF EXISTS mart.f_sales;


--d_calendar
CREATE TABLE mart.d_calendar (
    date_id                 BIGINT PRIMARY KEY,
    date_actual             DATE,
    day_of_month            BIGINT,
    month_actual            BIGINT,
    month_name              VARCHAR(50),
    year_actual             BIGINT,
    "week"                  BIGINT
);

CREATE INDEX d_calendar_id ON mart.d_calendar (date_id);

--d_city
CREATE TABLE mart.d_city (
    id                      SERIAL PRIMARY KEY,
    city_id                 BIGINT UNIQUE,
    city_name               VARCHAR(50)
);

CREATE INDEX d_city_id ON mart.d_city (city_id);

--d_customer
CREATE TABLE mart.d_customer (
    id                      SERIAL PRIMARY KEY,
    customer_id             BIGINT NOT NULL UNIQUE,
    first_name              VARCHAR(100),
    last_name               VARCHAR(100),
    city_id                 BIGINT
);

CREATE INDEX d_customer_id ON mart.d_customer (customer_id);

--d_item
CREATE TABLE mart.d_item (
    id                      SERIAL PRIMARY KEY,
    item_id                 BIGINT NOT NULL UNIQUE,
    item_name               VARCHAR(50)
);

CREATE INDEX d_item_id ON mart.d_item(item_id);

--f_sales
CREATE TABLE mart.f_sales (
    id                      SERIAL PRIMARY KEY,
    date_id                 BIGINT  REFERENCES mart.d_calendar,
    item_id                 BIGINT  REFERENCES mart.d_item (item_id),
    customer_id             BIGINT  REFERENCES mart.d_customer (customer_id),
    city_id                 BIGINT,
    quantity                BIGINT,
    payment_amount          NUMERIC(14,2)
);

ALTER TABLE mart.f_sales ADD COLUMN IF NOT EXISTS status VARCHAR(50)
  DEFAULT 'shipped';

ALTER TABLE mart.f_sales ADD COLUMN IF NOT EXISTS start_date date;
ALTER TABLE mart.f_sales ADD COLUMN IF NOT EXISTS end_date date;


CREATE INDEX f_sales_1 ON mart.f_sales (date_id);

CREATE INDEX f_sales_2 ON mart.f_sales (item_id);

CREATE INDEX f_sales_3 ON mart.f_sales (customer_id);

CREATE INDEX f_sales_4 ON mart.f_sales (city_id);




--f_customer_retention
CREATE TABLE mart.f_customer_retention (
	period_name					TEXT,
	period_id					TEXT,
	item_id						BIGINT DEFAULT 0,
	new_customers_count			BIGINT DEFAULT 0,
	new_customers_revenue		NUMERIC(14,2) DEFAULT 0,
	returning_customers_count	BIGINT DEFAULT 0,
	returning_customers_revenue	NUMERIC(14,2) DEFAULT 0,
	refunded_customers_count	BIGINT DEFAULT 0,
	customers_refunded			BIGINT DEFAULT 0
	)
