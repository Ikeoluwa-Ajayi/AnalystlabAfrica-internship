CREATE TABLE sales_data (
    order_number INT,
    quantity_ordered INT,
    price_each NUMERIC,
    order_line_number INT,
    sales NUMERIC,
    order_date VARCHAR(30),
    status VARCHAR(20),
    qtr_id INT,
    month_id INT,
    year_id INT,
    product_line VARCHAR(50),
    msrp INT,
    product_code VARCHAR(20),
    customer_name VARCHAR(100),
    phone VARCHAR(30),
    address_line1 VARCHAR(100),
    address_line2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    territory VARCHAR(50),
    contact_last_name VARCHAR(50),
    contact_first_name VARCHAR(50),
    deal_size VARCHAR(20)
);

SELECT * FROM sales_data limit 5;
SELECT COUNT(*) FROM sales_data;

ALTER TABLE sales_data
ALTER COLUMN order_date TYPE TIMESTAMP
USING TO_TIMESTAMP(order_date, 'MM/DD/YYYY HH24:MI');

SELECT order_date FROM sales_data LIMIT 5;

SELECT product_line, SUM(sales) AS total_revenue
FROM sales_data
GROUP BY product_line
ORDER BY total_revenue DESC;

select customer_name, sum(sales) as total_spent
from sales_data
group by customer_name
order by total_spent desc
limit 10;

SELECT year_id, month_id, SUM(sales) AS monthly_revenue
FROM sales_data
GROUP BY year_id, month_id
ORDER BY year_id, month_id;

SELECT customer_name, 
    COUNT(DISTINCT order_number) AS total_orders,
    SUM(sales) AS total_spent,
    AVG(sales) AS avg_order_value
FROM sales_data
GROUP BY customer_name
ORDER BY total_spent DESC
LIMIT 10;

SELECT * FROM (
    SELECT customer_name, order_number, SUM(sales) AS order_total,
        RANK() OVER (PARTITION BY customer_name ORDER BY SUM(sales) DESC) AS rank_within_customer
    FROM sales_data
    GROUP BY customer_name, order_number
) AS ranked_orders
WHERE rank_within_customer = 1
ORDER BY order_total DESC;

CREATE INDEX idx_customer_name ON sales_data(customer_name);
CREATE INDEX idx_product_line ON sales_data(product_line);