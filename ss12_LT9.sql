CREATE TABLE customers (
                           customer_id SERIAL PRIMARY KEY,
                           name VARCHAR(50) NOT NULL,
                           email VARCHAR(50)
);
CREATE TABLE products (
                          product_id SERIAL PRIMARY KEY,
                          name VARCHAR(50) NOT NULL,
                          price NUMERIC(10, 2) NOT NULL,
                          stock INT NOT NULL
);
CREATE TABLE orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT REFERENCES customers(customer_id),
                        product_id INT REFERENCES products(product_id),
                        quantity INT NOT NULL,
                        total_amount NUMERIC(12,2),
                        order_date TIMESTAMP DEFAULT NOW()
);
BEGIN;
SELECT COUNT(*) FROM orders WHERE quantity > 5;
-- chờ Session B thêm đơn hàng
SELECT COUNT(*) FROM orders WHERE quantity > 5;
COMMIT;
INSERT INTO orders (customer_id, product_id, quantity, total_amount)
VALUES (1, 1, 10, 100.00);
COMMIT;
