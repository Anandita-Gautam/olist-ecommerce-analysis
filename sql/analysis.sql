USE olist;

-- Query 1: Total revenue and delivered orders
SELECT
    COUNT(DISTINCT o.order_id) AS delivered_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- Query 2: Revenue by month
SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

-- Query 3: Month-over-month growth
WITH monthly AS (
    SELECT
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month,
        SUM(oi.price) AS revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY month
)
SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(LAG(revenue) OVER (ORDER BY month), 2) AS prev_month,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month))
          / LAG(revenue) OVER (ORDER BY month) * 100, 1) AS growth_pct
FROM monthly
ORDER BY month;

-- Query 4: Top 10 categories by revenue
SELECT
    p.product_category_name_english AS category,
    COUNT(DISTINCT oi.order_id) AS orders,
    ROUND(SUM(oi.price), 2) AS revenue
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = 'delivered'
GROUP BY category
ORDER BY revenue DESC
LIMIT 10;

-- Query 5: Average review score, late vs on-time deliveries
WITH review_per_order AS (
    SELECT order_id, AVG(review_score) AS score
    FROM order_reviews
    GROUP BY order_id
)
SELECT
    o.is_late,
    COUNT(*) AS orders,
    ROUND(AVG(r.score), 2) AS avg_review_score
FROM orders o
JOIN review_per_order r ON o.order_id = r.order_id
WHERE o.order_status = 'delivered'
  AND o.is_late IS NOT NULL
GROUP BY o.is_late;

-- Query 6: Repeat-customer rate
WITH cust AS (
    SELECT c.customer_unique_id, COUNT(DISTINCT o.order_id) AS n_orders
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
    COUNT(*) AS customers,
    SUM(n_orders > 1) AS repeat_customers,
    ROUND(SUM(n_orders > 1) / COUNT(*) * 100, 2) AS repeat_pct
FROM cust;