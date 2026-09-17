DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city VARCHAR(50),
    email VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE
);

CREATE TABLE order_details (
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT,
    PRIMARY KEY (order_id, product_id)
);
INSERT INTO customers VALUES
(1, 'Aman', 'Delhi', 'aman@gmail.com'),
(2, 'Priya', 'Faridabad', 'priya@gmail.com'),
(3, 'Rohit', 'Gurgaon', 'rohit@gmail.com'),
(4, 'Neha', 'Delhi', 'neha@gmail.com'),
(5, 'Karan', 'Noida', 'karan@gmail.com');

INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 50000),
(102, 'Headphones', 'Electronics', 2000),
(103, 'Shoes', 'Fashion', 3000),
(104, 'Watch', 'Accessories', 5000),
(105, 'Backpack', 'Fashion', 1500);

INSERT INTO orders VALUES
(1001, 1, '2026-01-10'),
(1002, 2, '2026-01-15'),
(1003, 1, '2026-02-05'),
(1004, 3, '2026-02-12'),
(1005, 4, '2026-03-01');

INSERT INTO order_details VALUES
(1001, 101, 1),
(1001, 102, 2),
(1002, 103, 2),
(1003, 104, 1),
(1003, 102, 1),
(1004, 105, 3),
(1005, 103, 1);
SELECT * FROM customers;
SELECT * FROM products;

SELECT
    p.product_name,
    od.quantity,
    p.price,
    p.price * od.quantity AS total_amount
FROM order_details od
JOIN products p
    ON od.product_id = p.product_id;
--Total Sales revenue 
SELECT
    SUM(p.price * od.quantity) AS total_revenue
FROM order_details od
--Top selling products
SELECT
    p.product_name,
    SUM(od.quantity) AS total_quantity_sold
FROM products p
JOIN order_details od
    ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC;
--City wise analysis
SELECT
    c.city,
    SUM(p.price * od.quantity) AS city_revenue
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_details od
    ON o.order_id = od.order_id
JOIN products p
    ON od.product_id = p.product_id
GROUP BY c.city
ORDER BY city_revenue DESC;
--Top 5 customer
SELECT
    c.customer_name,
    c.city,
    SUM(p.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_details od
    ON o.order_id = od.order_id
JOIN products p
    ON od.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spent DESC
LIMIT 5;
--Monthly sales analysis
SELECT
    TO_CHAR(o.order_date, 'Month') AS sales_month,
    SUM(p.price * od.quantity) AS monthly_revenue
FROM orders o
JOIN order_details od
    ON o.order_id = od.order_id
JOIN products p
    ON od.product_id = p.product_id
GROUP BY DATE_TRUNC('month', o.order_date),
         TO_CHAR(o.order_date, 'Month')
ORDER BY DATE_TRUNC('month', o.order_date);