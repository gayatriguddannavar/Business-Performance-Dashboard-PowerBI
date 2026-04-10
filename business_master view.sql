CREATE VIEW business_master AS
SELECT
    oi.order_id,
    o.order_purchase_timestamp,
    o.order_status,
    c.customer_id,
    c.customer_state,
    oi.product_id,
    p.product_category_name,
    oi.seller_id,
    oi.price,
    oi.freight_value,
    pay.payment_value
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o 
    ON oi.order_id = o.order_id
JOIN olist_customers_dataset c 
    ON o.customer_id = c.customer_id
JOIN olist_products_dataset p 
    ON oi.product_id = p.product_id
JOIN olist_order_payments_dataset pay 
    ON oi.order_id = pay.order_id;
    
SELECT COUNT(*) FROM business_master;

-- Total Revenue
SELECT SUM(price) AS total_revenue
FROM business_master
WHERE order_status = 'delivered';

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS total_orders
FROM business_master
WHERE order_status = 'delivered';

-- Total Customers
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM business_master
WHERE order_status = 'delivered';

-- Average Order Value (AOV)
	SELECT 
		SUM(price) / COUNT(DISTINCT order_id) AS avg_order_value
	FROM business_master
	WHERE order_status = 'delivered';

-- Monthly Revenue Trend
SELECT 
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month,
    SUM(price) AS revenue
FROM business_master
WHERE order_status = 'delivered'
GROUP BY month
ORDER BY month; 

-- Repeat Purchase Rate
-- Orders per customer
SELECT 
    customer_id, 
    COUNT(DISTINCT order_id) AS order_count
FROM business_master
WHERE order_status = 'delivered'
GROUP BY customer_id; 

-- Repeat customers %
SELECT 
    COUNT(*) * 100.0 / 
    (SELECT COUNT(DISTINCT customer_id) FROM business_master WHERE order_status='delivered')
    AS repeat_purchase_rate
FROM (
    SELECT customer_id
    FROM business_master
    WHERE order_status = 'delivered'
    GROUP BY customer_id
    HAVING COUNT(DISTINCT order_id) > 1
) AS repeat_customers; 

-- Top Product Categories
SELECT 
    product_category_name,
    SUM(price) AS revenue
FROM business_master
WHERE order_status = 'delivered'
GROUP BY product_category_name
ORDER BY revenue DESC
LIMIT 10; 

-- Region-wise Sales
SELECT 
    customer_state,
    SUM(price) AS revenue
FROM business_master
WHERE order_status = 'delivered'
GROUP BY customer_state
ORDER BY revenue DESC;

-- Revenue per Customer
SELECT 
    SUM(price) / COUNT(DISTINCT customer_id) AS revenue_per_customer
FROM business_master
WHERE order_status = 'delivered';

-- Orders per Customer
SELECT 
    COUNT(DISTINCT order_id) / COUNT(DISTINCT customer_id) AS orders_per_customer
FROM business_master
WHERE order_status = 'delivered'; 

 



    
    