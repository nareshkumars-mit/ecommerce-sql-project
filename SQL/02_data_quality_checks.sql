SELECT 'user' AS table_name, COUNT(*) AS row_count FROM "user"
UNION ALL
SELECT 'user_address', COUNT(*) FROM user_address
UNION ALL
SELECT 'user_payment', COUNT(*) FROM user_payment
UNION ALL
SELECT 'product_category', COUNT(*) FROM product_category
UNION ALL
SELECT 'product_inventory', COUNT(*) FROM product_inventory
UNION ALL
SELECT 'discount', COUNT(*) FROM discount
UNION ALL
SELECT 'product', COUNT(*) FROM product
UNION ALL
SELECT 'shopping_session', COUNT(*) FROM shopping_session
UNION ALL
SELECT 'cart_item', COUNT(*) FROM cart_item
UNION ALL
SELECT 'order_details', COUNT(*) FROM order_details
UNION ALL
SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL
SELECT 'payment_details', COUNT(*) FROM payment_details;


SELECT COUNT(*) AS orphan_products
FROM product p
LEFT JOIN product_category pc
    ON p.category_id = pc.id
WHERE pc.id IS NULL;

SELECT COUNT(*) AS orphan_inventory
FROM product p
LEFT JOIN product_inventory pi
    ON p.inventory_id = pi.id
WHERE pi.id IS NULL;

SELECT COUNT(*) AS products_without_discount
FROM product
WHERE discount_id IS NULL;

SELECT COUNT(*) AS orphan_orders
FROM order_details od
LEFT JOIN "user" u
    ON od.user_id = u.id
WHERE u.id IS NULL;

SELECT COUNT(*) AS orphan_order_items
FROM order_items oi
LEFT JOIN order_details od
    ON oi.order_id = od.id
WHERE od.id IS NULL;

SELECT COUNT(*) AS orphan_order_products
FROM order_items oi
LEFT JOIN product p
    ON oi.product_id = p.id
WHERE p.id IS NULL;

SELECT COUNT(*) AS orphan_payments
FROM payment_details pd
LEFT JOIN order_details od
    ON pd.order_id = od.id
WHERE od.id IS NULL;

SELECT COUNT(*) AS orders_without_payment
FROM order_details
WHERE payment_id IS NULL;

SELECT COUNT(*) AS mismatched_orders
FROM order_details od
JOIN (
    SELECT
        oi.order_id,
        ROUND(SUM(p.price * oi.quantity * (1 - COALESCE(d.discount_percent, 0) / 100)),2) AS calculated_total
    FROM order_items oi
    JOIN product p
        ON oi.product_id = p.id
    LEFT JOIN discount d
        ON p.discount_id = d.id
    GROUP BY oi.order_id
) x
    ON od.id = x.order_id
WHERE od.total <> x.calculated_total;

SELECT COUNT(*) AS invalid_quantities
FROM order_items
WHERE quantity <= 0;

SELECT COUNT(*) AS invalid_cart_quantities
FROM cart_item
WHERE quantity <= 0;

SELECT COUNT(*) AS invalid_prices
FROM product
WHERE price < 0;

SELECT 'Shopping Sessions' AS metric, COUNT(*) AS value
FROM shopping_session
UNION ALL
SELECT 'Cart Items', COUNT(*)
FROM cart_item
UNION ALL
SELECT 'Orders', COUNT(*)
FROM order_details
UNION ALL
SELECT 'Order Items', COUNT(*)
FROM order_items
UNION ALL
SELECT 'Payments', COUNT(*)
FROM payment_details;

SELECT COUNT(*) AS invalid_orders
FROM order_details
WHERE session_id IS NULL;

SELECT COUNT(*) AS orders_without_items
FROM order_details od
LEFT JOIN order_items oi
    ON od.id = oi.order_id
WHERE oi.id IS NULL;

SELECT COUNT(*) AS orders_without_payment
FROM order_details
WHERE payment_id IS NULL;

SELECT COUNT(*) AS payment_mismatches
FROM payment_details pd
JOIN order_details od
    ON pd.order_id = od.id
WHERE pd.amount <> od.total;

SELECT COUNT(*) AS abandoned_sessions
FROM shopping_session ss
LEFT JOIN order_details od
    ON ss.id = od.session_id
WHERE od.id IS NULL;

SELECT
    order_id,
    product_id,
    COUNT(*) AS duplicate_rows
FROM order_items
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS total_orders
FROM order_details;

SELECT
    COUNT(*) AS orders_without_session
FROM order_details
WHERE session_id IS NULL;

SELECT
    COUNT(*) AS orders_without_payment
FROM order_details
WHERE payment_id IS NULL;

SELECT
    COUNT(*) AS orders_without_items
FROM order_details od
LEFT JOIN order_items oi
    ON od.id = oi.order_id
WHERE oi.order_id IS NULL;

SELECT
    ss.id AS session_id,
    ss.total AS session_total,
    od.id AS order_id,
    od.total AS order_total
FROM shopping_session ss
JOIN order_details od
    ON ss.id = od.session_id
ORDER BY ss.id DESC
LIMIT 20;