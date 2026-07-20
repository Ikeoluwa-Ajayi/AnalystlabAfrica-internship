SELECT * FROM customer;

SELECT * FROM customer
WHERE country = 'Canada';

SELECT * FROM customer
ORDER BY city ASC;

SELECT * FROM customer
WHERE country = 'Canada'
ORDER BY city ASC;

SELECT COUNT(*) FROM customer;

SELECT country, COUNT(*) AS total_customers
FROM customer
GROUP BY country
ORDER BY total_customers DESC;

SELECT country, COUNT(*) AS total_customers
FROM customer
GROUP BY country
HAVING COUNT(*) > 3
ORDER BY total_customers DESC;

select * from invoice;
SELECT 
    SUM(total) AS total_revenue,
    AVG(total) AS average_invoice_value
FROM invoice;

SELECT customer_id, SUM(total) AS total_spent
FROM invoice
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

SELECT c.first_name, c.last_name, SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;

SELECT c.first_name, c.last_name, i.invoice_id
FROM customer c
LEFT JOIN invoice i ON c.customer_id = i.customer_id
WHERE i.invoice_id IS NULL;

SELECT first_name, last_name, country
FROM customer
WHERE country = (
    SELECT country FROM customer WHERE customer_id = 1
);

SELECT first_name, last_name, country
FROM customer
WHERE country = (
    SELECT country FROM customer WHERE customer_id = 3
);

SELECT customer_id, SUM(total) AS total_spent
FROM invoice
GROUP BY customer_id;

SELECT AVG(total_spent) 
FROM (
    SELECT customer_id, SUM(total) AS total_spent
    FROM invoice
    GROUP BY customer_id
) AS customer_totals;

SELECT c.first_name, c.last_name, SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.first_name, c.last_name
HAVING SUM(i.total) > (
    SELECT AVG(total_spent)
    FROM (
        SELECT customer_id, SUM(total) AS total_spent
        FROM invoice
        GROUP BY customer_id
    ) AS customer_totals
)
ORDER BY total_spent DESC;

SELECT customer_id, total, invoice_date,
    ROW_NUMBER() OVER (ORDER BY total DESC) AS rank_by_spend
FROM invoice
LIMIT 15;

SELECT customer_id, SUM(total) AS total_spent
FROM invoice
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

SELECT customer_id, total, invoice_date,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY total DESC) AS rank_within_customer
FROM invoice
ORDER BY customer_id, rank_within_customer
LIMIT 20;

SELECT * FROM (
    SELECT customer_id, total, invoice_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY total DESC) AS rank_within_customer
    FROM invoice
) AS ranked_invoices
WHERE rank_within_customer = 1
ORDER BY customer_id;

SELECT customer_id, total,
    RANK() OVER (ORDER BY total DESC) AS rank_by_spend
FROM invoice
LIMIT 15;

CREATE INDEX idx_customer_id ON invoice(customer_id);
