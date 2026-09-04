-- ============================================================
--  FreshMart Ghana Analytics Database
--  SQL Assignment Seed File
--  Course: Introduction to SQL for Data Analysis
-- ============================================================

-- (Schema + seed data: customers, products, orders, order_items, suppliers, returns)
-- Full seed file available on request.

-- ============================================================
--  SAMPLE ANALYTICAL QUERIES
-- ============================================================

-- Top spending customers (JOIN + GROUP BY + aggregate)
SELECT c.first_name || ' ' || c.last_name AS customer, ROUND(SUM(o.total_amount),2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 3;

-- Best-selling products by quantity (JOIN + GROUP BY)
SELECT p.product_name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id
ORDER BY units_sold DESC
LIMIT 3;

-- Customers spending above the average order value (subquery)
SELECT COUNT(*) AS above_avg_customers FROM (
  SELECT customer_id, SUM(total_amount) AS spent
  FROM orders
  WHERE status = 'Delivered'
  GROUP BY customer_id
  HAVING spent > (SELECT AVG(total_amount) FROM orders WHERE status = 'Delivered')
);

-- Revenue by loyalty tier (JOIN + GROUP BY)
SELECT c.loyalty_tier, ROUND(SUM(o.total_amount),2) AS revenue, COUNT(DISTINCT o.customer_id) AS customers
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.loyalty_tier
ORDER BY revenue DESC;

-- Returns and refunds by product (JOIN + GROUP BY)
SELECT p.product_name, COUNT(r.return_id) AS return_count, ROUND(SUM(r.refund_amount),2) AS total_refunded
FROM returns r
JOIN products p ON r.product_id = p.product_id
GROUP BY p.product_id
ORDER BY return_count DESC;

-- ============================================================
--  KEY RESULTS
-- ============================================================
-- Total revenue (delivered orders):        GHS 1,912.50
-- Gold-tier customers (5 of 15) drove:      GHS 1,528.50 (80% of revenue)
-- Best-selling product by units:            Bottled Water (1.5L) — 25 units
-- Total refunded:                           GHS 243.50 (~12.7% of revenue)
-- Returns concentrated in:                  Frozen Beef & Chicken Breast
