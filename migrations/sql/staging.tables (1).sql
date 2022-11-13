DROP TABLE IF EXISTS staging.customer_research;
DROP TABLE IF EXISTS  staging.user_order_log;
DROP TABLE IF EXISTS  staging.user_activity_log;

--customer_research
CREATE TABLE staging.customer_research (
    id                  SERIAL,
    date_id             TIMESTAMP WITHOUT TIME ZONE,
    category_id         BIGINT,
    geo_id              BIGINT,
    sales_qty           BIGINT,
    sales_amt           NUMERIC(14,2)
);

--user_order_log
CREATE TABLE staging.user_order_log (
    id                  SERIAL,
    date_time           TIMESTAMP WITHOUT TIME ZONE,
    city_id             BIGINT,
    city_name           VARCHAR(100),
    customer_id         BIGINT,
    first_name          VARCHAR(100),
    last_name           VARCHAR(100),
    item_id             BIGINT,
    item_name           VARCHAR(100),
    quantity            BIGINT,
    payment_amount      NUMERIC(14,2)
);


ALTER TABLE staging.user_order_log
  ADD COLUMN IF NOT EXISTS status VARCHAR(50)
  DEFAULT 'shipped';


--user_activity_log
CREATE TABLE staging.user_activity_log (
    id                  SERIAL,
    date_time           TIMESTAMP WITHOUT TIME ZONE,
    action_id           BIGINT,
    customer_id         BIGINT,
    quantity            BIGINT
);

