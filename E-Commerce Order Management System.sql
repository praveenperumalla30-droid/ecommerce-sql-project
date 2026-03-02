CREATE DATABASE ecommerce_db;
USE ecommerce_db;

SHOW DATABASES;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    city VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price DECIMAL(10,2) CHECK (price > 0),
    stock INT CHECK (stock >= 0)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT CHECK (quantity > 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    payment_method VARCHAR(50),
    amount DECIMAL(10,2),
    payment_date DATE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


INSERT INTO customers (name, email, city) VALUES
('Rahul Sharma', 'rahul@gmail.com', 'Delhi'),
('Anjali Verma', 'anjali@gmail.com', 'Mumbai'),
('Kiran Reddy', 'kiran@gmail.com', 'Hyderabad'),
('Sneha Patel', 'sneha@gmail.com', 'Ahmedabad'),
('Arjun Rao', 'arjun@gmail.com', 'Bangalore');


INSERT INTO products (product_name, category, price, stock) VALUES
('Laptop', 'Electronics', 60000, 10),
('Smartphone', 'Electronics', 25000, 20),
('Headphones', 'Accessories', 2000, 50),
('Shoes', 'Fashion', 3000, 30),
('Backpack', 'Fashion', 1500, 40);

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2026-03-01'),
(2, '2026-03-01'),
(3, '2026-03-02'),
(1, '2026-03-03');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1),
(3, 4, 2),
(4, 5, 3);

INSERT INTO payments (order_id, payment_method, amount, payment_date) VALUES
(1, 'UPI', 64000, '2026-03-01'),
(2, 'Credit Card', 25000, '2026-03-01'),
(3, 'Cash', 6000, '2026-03-02'),
(4, 'Debit Card', 4500, '2026-03-03');

SELECT 
    o.order_id,
    c.name,
    o.order_date
FROM orders o
JOIN customers c 
ON o.customer_id = c.customer_id;


SELECT 
    o.order_id,
    c.name AS customer_name,
    p.product_name,
    oi.quantity,
    p.price,
    (oi.quantity * p.price) AS total_price
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON oi.product_id = p.product_id;

SELECT SUM(amount) AS total_revenue
FROM payments;

SELECT 
    c.city,
    SUM(p.amount) AS city_revenue
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.city;

SELECT 
    c.name,
    SUM(p.amount) AS total_spent
FROM payments p
JOIN orders o ON p.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name
ORDER BY total_spent DESC
LIMIT 1;

SELECT 
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 1;

SELECT 
    c.name,
    COUNT(o.order_id) AS total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.name
HAVING total_orders > 1;
