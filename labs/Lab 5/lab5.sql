CREATE TABLE customers (customer_id SERIAL PRIMARY KEY, name VARCHAR(100), email VARCHAR(100), created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE TABLE products (product_id SERIAL PRIMARY KEY, name VARCHAR(100), price DECIMAL(10, 2));

CREATE TABLE orders (order_id SERIAL PRIMARY KEY, customer_id INT REFERENCES customers(customer_id), order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE TABLE order_items (order_item_id SERIAL PRIMARY KEY,order_id INT REFERENCES orders(order_id),product_id INT REFERENCES products(product_id), quantity INT, price DECIMAL(10, 2));

-- Insert sample data
INSERT INTO customers (name, email) VALUES ('John Doe', 'john@example.com');
INSERT INTO products (name, price) VALUES ('Product A', 100.00), ('Product B', 200.00);

INSERT INTO orders (customer_id) VALUES (1);
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (1, 1, 2, 100.00), (1, 2, 1, 200.00);
