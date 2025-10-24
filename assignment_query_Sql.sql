CREATE DATABASE online_shopping;
USE online_shopping;

CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_unique_id VARCHAR(50),
    customer_zip_code_prefix VARCHAR(20),
    customer_city VARCHAR(100),
    customer_state VARCHAR(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state);

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    customer_id VARCHAR(50),
    order_status VARCHAR(50),
    order_purchase_timestamp VARCHAR(50),
    order_approved_at VARCHAR(50),
    order_delivered_carrier_date VARCHAR(50),
    order_delivered_customer_date VARCHAR(50),
    order_estimated_delivery_date VARCHAR(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, order_purchase_timestamp, order_approved_at, order_delivered_carrier_date, order_delivered_customer_date, order_estimated_delivery_date);

CREATE TABLE order_items (
    order_id VARCHAR(50),
    order_item_id INT,
    product_id VARCHAR(50),
    seller_id VARCHAR(50),
    shipping_limit_date VARCHAR(50),
    price DECIMAL(10,2) NULL,
    freight_value DECIMAL(10,2) NULL
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, order_item_id, product_id, seller_id, shipping_limit_date, price, freight_value);

CREATE TABLE payments (
    order_id VARCHAR(50),
    payment_sequential INT,
    payment_type VARCHAR(50),
    payment_installments INT,
    payment_value DECIMAL(10,2) NULL
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/payments.csv'
INTO TABLE payments
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(order_id, payment_sequential, payment_type, payment_installments, payment_value);

CREATE TABLE sellers (
    seller_id VARCHAR(50) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(20),
    seller_city VARCHAR(100),
    seller_state VARCHAR(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sellers.csv'
INTO TABLE sellers
CHARACTER SET latin1
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(seller_id, seller_zip_code_prefix, seller_city, seller_state);


CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_category VARCHAR(100),
    product_name_length VARCHAR(10),
    product_description_length VARCHAR(10),
    product_photos_qty VARCHAR(10),
    product_weight_g VARCHAR(20),
    product_length_cm VARCHAR(20),
    product_height_cm VARCHAR(20),
    product_width_cm VARCHAR(20)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(product_id, product_category, product_name_length, product_description_length, product_photos_qty, product_weight_g, product_length_cm, product_height_cm, product_width_cm);

CREATE TABLE geolocation (
    geolocation_zip_code_prefix VARCHAR(20),
    geolocation_lat DECIMAL(9,6) NULL,
    geolocation_lng DECIMAL(9,6) NULL,
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(50)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/geolocation.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state);

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_items;
SELECT COUNT(*) FROM sellers;
SELECT COUNT(*) FROM payments;
SELECT COUNT(*) FROM geolocation;

SELECT  * FROM customers;
SELECT * FROM products;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM sellers;
SELECT * FROM payments;
SELECT * FROM geolocation;

#Basic Level Questions 
## List all unique cities where customers are located
SELECT DISTINCT customer_city
FROM customers
WHERE customer_city IS NOT NULL AND TRIM(customer_city) <> ''
ORDER BY customer_city;

##Count the number of orders placed in 2017
SELECT COUNT(*) AS orders_2017
FROM orders
WHERE
  order_purchase_timestamp IS NOT NULL
  AND STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') IS NOT NULL
  AND YEAR(STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')) = 2017;

##Find the total sales per category
SELECT p.product_category,
       ROUND(SUM(oi.price),2) AS total_sales
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category
ORDER BY total_sales DESC;

##Calculate the percentage of orders that were paid in installments
SELECT 
    ROUND(100 * SUM(CASE
                WHEN payment_installments > 1 THEN 1
                ELSE 0
            END) / COUNT(*),
            2) AS pct_paid_in_installments
FROM
    payments;

##Count the number of customers from each state
SELECT customer_state, COUNT(*) AS num_customers
FROM customers
GROUP BY customer_state
ORDER BY num_customers DESC;

#INTERMEDIATE PROBLEMS
##Number of orders per month in 2018
SELECT MONTH(dt) AS month, COUNT(*) AS orders
FROM (
  SELECT order_id, STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') AS dt
  FROM orders
) t
WHERE YEAR(dt) = 2018
GROUP BY MONTH(dt)
ORDER BY MONTH(dt);

##Average number of products per order, grouped by customer city
WITH items_per_order AS (
    SELECT 
        order_id,
        COUNT(order_item_id) AS items_count
    FROM order_items
    GROUP BY order_id
)
SELECT 
    c.customer_city,
    ROUND(AVG(ipo.items_count), 0) AS avg_products_per_order
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN items_per_order ipo ON o.order_id = ipo.order_id
GROUP BY c.customer_city
ORDER BY avg_products_per_order DESC;

##Percentage of total revenue contributed by each product category
WITH revenue_by_category AS (
  SELECT p.product_category, SUM(oi.price) AS rev
  FROM order_items oi
  JOIN products p ON oi.product_id = p.product_id
  GROUP BY p.product_category
)
SELECT product_category,
       ROUND(rev,2) AS revenue,
       ROUND(100 * rev / (SELECT SUM(rev) FROM revenue_by_category), 2) AS pct_total_revenue
FROM revenue_by_category
ORDER BY rev DESC;

##Correlation between product price and number of times a product has been purchased
WITH product_stats AS (
    SELECT 
        oi.product_id,
        AVG(oi.price) AS avg_price,
        COUNT(*) AS times_sold
    FROM order_items oi
    GROUP BY oi.product_id
)
SELECT 
    ROUND(
        (SUM((avg_price - (SELECT AVG(avg_price) FROM product_stats)) * 
             (times_sold - (SELECT AVG(times_sold) FROM product_stats))) /
        SQRT(SUM(POW(avg_price - (SELECT AVG(avg_price) FROM product_stats), 2)) * 
             SUM(POW(times_sold - (SELECT AVG(times_sold) FROM product_stats), 2)))
        ), 4
    ) AS correlation_coefficient
FROM product_stats;


##Total revenue generated by each seller and rank them by revenue
SELECT s.seller_id,
       s.seller_city,
       s.seller_state,
       ROUND(SUM(oi.price),2) AS total_revenue,
       RANK() OVER (ORDER BY SUM(oi.price) DESC) AS revenue_rank
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY s.seller_id, s.seller_city, s.seller_state
ORDER BY total_revenue DESC;

#ADVANCED PROBLEMS
##Moving average of order values for each customer over their order history
WITH order_values AS (
  SELECT o.order_id, o.customer_id,
         SUM(oi.price) AS order_value,
         STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') AS purchase_dt
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  GROUP BY o.order_id, o.customer_id, purchase_dt
)
SELECT customer_id, order_id, purchase_dt, order_value,
       ROUND(AVG(order_value) OVER (PARTITION BY customer_id ORDER BY purchase_dt ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS moving_avg_3_orders
FROM order_values
ORDER BY customer_id, purchase_dt;

##Cumulative sales per month for each year
WITH monthly AS (
  SELECT DATE_FORMAT(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'), '%Y') AS yr,
         DATE_FORMAT(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s'), '%Y-%m') AS ym,
         SUM(oi.price) AS monthly_sales
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  WHERE STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') IS NOT NULL
  GROUP BY yr, ym
)
SELECT yr, ym, monthly_sales,
       SUM(monthly_sales) OVER (PARTITION BY yr ORDER BY ym) AS cumulative_sales_in_year
FROM monthly
ORDER BY yr, ym;

##Year-over-year growth rate of total sales
WITH annual AS (
  SELECT YEAR(STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')) AS yr,
         SUM(oi.price) AS revenue
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  GROUP BY yr
)
SELECT yr, revenue,
       ROUND(100 * (revenue - LAG(revenue) OVER (ORDER BY yr)) / LAG(revenue) OVER (ORDER BY yr), 2) AS yoy_pct_change
FROM annual
ORDER BY yr;

##Customer retention rate: % customers who make another purchase within 6 months of their first purchase
WITH cust_first AS (
  SELECT customer_id, MIN(STR_TO_DATE(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')) AS first_purchase
  FROM orders
  GROUP BY customer_id
),
cust_next AS (
  SELECT o.customer_id, MIN(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')) AS next_purchase
  FROM orders o
  JOIN cust_first cf ON o.customer_id = cf.customer_id
  WHERE STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') > cf.first_purchase
  GROUP BY o.customer_id
)
SELECT 
  ROUND(100 * SUM(CASE WHEN TIMESTAMPDIFF(MONTH, cf.first_purchase, cn.next_purchase) <= 6 THEN 1 ELSE 0 END) / COUNT(*), 2) AS retention_pct_within_6_months
FROM cust_first cf
LEFT JOIN cust_next cn ON cf.customer_id = cn.customer_id;

##Top 3 customers who spent the most money in each year
WITH cust_yearly AS (
  SELECT o.customer_id, YEAR(STR_TO_DATE(o.order_purchase_timestamp, '%Y-%m-%d %H:%i:%s')) AS yr,
         SUM(oi.price) AS total_spent
  FROM orders o
  JOIN order_items oi ON o.order_id = oi.order_id
  GROUP BY o.customer_id, yr
)
SELECT yr, customer_id, total_spent
FROM (
  SELECT cy.*, ROW_NUMBER() OVER (PARTITION BY yr ORDER BY total_spent DESC) AS rn
  FROM cust_yearly cy
) t
WHERE rn <= 3
ORDER BY yr,total_spent desc;
