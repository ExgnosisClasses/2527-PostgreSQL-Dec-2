EXPLAIN
SELECT 
    c.customer_id, 
    c.name, 
    COUNT(o.order_id) AS total_orders, 
    SUM(oi.price * oi.quantity) AS total_spent
FROM 
    customers c
JOIN 
    orders o ON c.customer_id = o.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id
GROUP BY 
    c.customer_id, c.name
ORDER BY 
    total_spent DESC;

-- EXPLAIN (ANALYZE, VERBOSE, BUFFERS, COSTS)