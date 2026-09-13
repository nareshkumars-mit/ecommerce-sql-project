CREATE TABLE product_category (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    "desc" TEXT,
    created_at TIMESTAMP,
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP
);

ALTER TABLE product_category
ADD COLUMN parent_category_id INT;

ALTER TABLE product_category
ADD CONSTRAINT fk_parent_category
FOREIGN KEY (parent_category_id)
REFERENCES product_category(id);

CREATE TABLE product_inventory (
    id INT PRIMARY KEY,
    quantity INT NOT NULL,
    created_at TIMESTAMP,
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE TABLE discount (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    "desc" TEXT,
    discount_percent DECIMAL(5,2),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP,
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP
);

CREATE TABLE "user" (
    id INT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    password TEXT NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    telephone VARCHAR(20),
    created_at TIMESTAMP,
    modified_at TIMESTAMP
);

CREATE TABLE product (
    id INT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    "desc" TEXT,
    sku VARCHAR(50) UNIQUE NOT NULL,
    category_id INT NOT NULL,
    inventory_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    discount_id INT,
    created_at TIMESTAMP,
    modified_at TIMESTAMP,
    deleted_at TIMESTAMP,

    FOREIGN KEY (category_id)
        REFERENCES product_category(id),

    FOREIGN KEY (inventory_id)
        REFERENCES product_inventory(id),

    FOREIGN KEY (discount_id)
        REFERENCES discount(id)
);

CREATE TABLE user_address (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    address_line1 VARCHAR(200) NOT NULL,
    address_line2 VARCHAR(200),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country VARCHAR(100),
    telephone VARCHAR(20),
    mobile VARCHAR(20),

    FOREIGN KEY (user_id)
        REFERENCES "user"(id)
);

CREATE TABLE user_payment (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    payment_type VARCHAR(50),
    provider VARCHAR(100),
    account_no VARCHAR(50),
    expiry DATE,

    FOREIGN KEY (user_id)
        REFERENCES "user"(id)
);

CREATE TABLE shopping_session (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    total DECIMAL(10,2) DEFAULT 0,
    created_at TIMESTAMP,
    modified_at TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES "user"(id)
);

CREATE TABLE cart_item (
    id INT PRIMARY KEY,
    session_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,

    created_at TIMESTAMP,

    FOREIGN KEY (session_id)
        REFERENCES shopping_session(id),

    FOREIGN KEY (product_id)
        REFERENCES product(id)
);

CREATE TABLE order_details (
    id INT PRIMARY KEY,
    user_id INT NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    payment_id INT,
    created_at TIMESTAMP,
    modified_at TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES "user"(id)
);

CREATE TABLE order_items (
    id INT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,

    created_at TIMESTAMP,
    modified_at TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES order_details(id),

    FOREIGN KEY (product_id)
        REFERENCES product(id)
);

CREATE TABLE payment_details (
    id INT PRIMARY KEY,
    order_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    provider VARCHAR(100),
    status VARCHAR(30),
    created_at TIMESTAMP,
    modified_at TIMESTAMP,

    FOREIGN KEY (order_id)
        REFERENCES order_details(id)
);

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN (
      'product_category',
      'product',
      'product_inventory',
      'discount',
      'user',
      'user_address',
      'user_payment',
      'shopping_session',
      'cart_item',
      'order_details',
      'order_items',
      'payment_details'
  )
ORDER BY table_name;

SELECT
    tc.table_name,
    kcu.column_name,
    ccu.table_name AS referenced_table,
    ccu.column_name AS referenced_column
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON tc.constraint_name = ccu.constraint_name
    AND tc.table_schema = ccu.table_schema
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name, kcu.column_name;

SELECT
    tc.table_name,
    kcu.column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
WHERE tc.constraint_type = 'PRIMARY KEY'
ORDER BY tc.table_name;

INSERT INTO product_category
    (id, name, "desc", parent_category_id, created_at, modified_at)
VALUES
    (1, 'Electronics', 'Electronic devices and accessories',
        NULL, '2026-01-05 09:00:00', '2026-01-05 09:00:00'),

    (2, 'Computers', 'Laptops, desktops and computer accessories',
        1, '2026-01-05 09:05:00', '2026-01-05 09:05:00'),

    (3, 'Mobile Phones', 'Smartphones and mobile accessories',
        1, '2026-01-05 09:10:00', '2026-01-05 09:10:00'),

    (4, 'Accessories', 'Accessories for electronic devices',
        1, '2026-01-05 09:15:00', '2026-01-05 09:15:00'),

    (5, 'Home Appliances', 'Appliances and equipment for home use',
        NULL, '2026-01-05 09:20:00', '2026-01-05 09:20:00'),

    (6, 'Fashion', 'Clothing, footwear and fashion accessories',
        NULL, '2026-01-05 09:25:00', '2026-01-05 09:25:00'),

    (7, 'Books', 'Books and educational materials',
        NULL, '2026-01-05 09:30:00', '2026-01-05 09:30:00'),

    (8, 'Sports', 'Sports equipment and fitness products',
        NULL, '2026-01-05 09:35:00', '2026-01-05 09:35:00'),

    (9, 'Beauty', 'Beauty and personal care products',
        NULL, '2026-01-05 09:40:00', '2026-01-05 09:40:00');
    
 SELECT
    child.id,
    child.name,
    parent.name AS parent_category
FROM product_category child
LEFT JOIN product_category parent
    ON child.parent_category_id = parent.id
ORDER BY child.id;

INSERT INTO product_inventory
    (id, quantity, created_at, modified_at)
VALUES
    (1, 45, '2026-01-10 09:00:00', '2026-08-20 10:00:00'),
    (2, 12, '2026-01-10 09:05:00', '2026-08-21 11:00:00'),
    (3, 78, '2026-01-10 09:10:00', '2026-08-19 14:00:00'),
    (4, 6,  '2026-01-10 09:15:00', '2026-08-22 09:30:00'),
    (5, 120,'2026-01-10 09:20:00', '2026-08-18 16:00:00'),
    (6, 32, '2026-01-10 09:25:00', '2026-08-20 12:00:00'),
    (7, 4,  '2026-01-10 09:30:00', '2026-08-23 08:45:00'),
    (8, 67, '2026-01-10 09:35:00', '2026-08-21 13:00:00'),
    (9, 25, '2026-01-10 09:40:00', '2026-08-19 15:30:00'),
    (10, 90,'2026-01-10 09:45:00', '2026-08-17 10:15:00'),
    (11, 15,'2026-01-11 10:00:00', '2026-08-22 11:20:00'),
    (12, 53,'2026-01-11 10:05:00', '2026-08-20 14:10:00'),
    (13, 8, '2026-01-11 10:10:00', '2026-08-23 12:00:00'),
    (14, 41,'2026-01-11 10:15:00', '2026-08-19 09:45:00'),
    (15, 3, '2026-01-11 10:20:00', '2026-08-24 16:30:00'),
    (16, 72,'2026-01-11 10:25:00', '2026-08-18 13:40:00'),
    (17, 19,'2026-01-11 10:30:00', '2026-08-21 10:50:00'),
    (18, 105,'2026-01-11 10:35:00', '2026-08-20 15:00:00'),
    (19, 7, '2026-01-11 10:40:00', '2026-08-24 09:20:00'),
    (20, 36,'2026-01-11 10:45:00', '2026-08-22 14:30:00'),
    (21, 64,'2026-01-12 11:00:00', '2026-08-19 11:10:00'),
    (22, 10,'2026-01-12 11:05:00', '2026-08-23 15:20:00'),
    (23, 29,'2026-01-12 11:10:00', '2026-08-21 16:00:00'),
    (24, 5, '2026-01-12 11:15:00', '2026-08-24 10:30:00'),
    (25, 88,'2026-01-12 11:20:00', '2026-08-18 12:20:00'),
    (26, 17,'2026-01-12 11:25:00', '2026-08-20 09:50:00'),
    (27, 49,'2026-01-12 11:30:00', '2026-08-22 13:15:00'),
    (28, 2, '2026-01-12 11:35:00', '2026-08-24 15:45:00'),
    (29, 31,'2026-01-12 11:40:00', '2026-08-21 12:40:00'),
    (30, 95,'2026-01-12 11:45:00', '2026-08-19 14:50:00');

SELECT COUNT(*) AS inventory_records
FROM product_inventory;

SELECT *
FROM product_inventory
WHERE quantity < 10
ORDER BY quantity;

INSERT INTO discount
    (id, name, "desc", discount_percent, active, created_at, modified_at)
VALUES
    (1, 'Welcome Offer', 'Discount for new customers',
        5.00, TRUE, '2026-01-15 09:00:00', '2026-06-01 10:00:00'),

    (2, 'Summer Sale', 'Summer season promotional discount',
        10.00, TRUE, '2026-02-01 09:00:00', '2026-08-01 11:00:00'),

    (3, 'Festival Sale', 'Special festival promotional discount',
        15.00, TRUE, '2026-02-15 09:00:00', '2026-07-15 12:00:00'),

    (4, 'Premium Deal', 'Higher discount on selected premium products',
        20.00, TRUE, '2026-03-01 09:00:00', '2026-08-10 14:00:00'),

    (5, 'Clearance', 'Clearance discount for selected products',
        30.00, TRUE, '2026-03-15 09:00:00', '2026-08-15 15:00:00'),

    (6, 'New Year Sale', 'New year promotional campaign',
        12.00, FALSE, '2026-01-01 09:00:00', '2026-02-01 10:00:00'),

    (7, 'Student Offer', 'Discount for eligible student purchases',
        8.00, TRUE, '2026-04-01 09:00:00', '2026-08-05 13:00:00'),

    (8, 'Weekend Special', 'Limited promotional weekend discount',
        7.50, FALSE, '2026-05-01 09:00:00', '2026-06-01 09:00:00');
    
SELECT
    id,
    name,
    discount_percent,
    active
FROM discount
ORDER BY id;

SELECT *
FROM discount
WHERE discount_percent < 0
   OR discount_percent > 100;

INSERT INTO "user"
    (id, username, password, first_name, last_name, telephone, created_at, modified_at)
VALUES
    (1, 'user001', 'hash_001_a8f31c', 'Aarav', 'Sharma', '9000000001', '2026-01-05 09:00:00', '2026-01-05 09:00:00'),
    (2, 'user002', 'hash_002_b7d42e', 'Vivaan', 'Patel', '9000000002', '2026-01-07 10:15:00', '2026-01-07 10:15:00'),
    (3, 'user003', 'hash_003_c6e53f', 'Aditya', 'Kumar', '9000000003', '2026-01-09 11:30:00', '2026-01-09 11:30:00'),
    (4, 'user004', 'hash_004_d5f64a', 'Arjun', 'Reddy', '9000000004', '2026-01-12 12:00:00', '2026-01-12 12:00:00'),
    (5, 'user005', 'hash_005_e4a75b', 'Ishaan', 'Gupta', '9000000005', '2026-01-15 14:20:00', '2026-01-15 14:20:00'),
    (6, 'user006', 'hash_006_f3b86c', 'Rohan', 'Mehta', '9000000006', '2026-01-18 09:45:00', '2026-01-18 09:45:00'),
    (7, 'user007', 'hash_007_g2c97d', 'Karthik', 'Nair', '9000000007', '2026-01-20 16:10:00', '2026-01-20 16:10:00'),
    (8, 'user008', 'hash_008_h1d08e', 'Rahul', 'Verma', '9000000008', '2026-01-22 10:30:00', '2026-01-22 10:30:00'),
    (9, 'user009', 'hash_009_i0e19f', 'Siddharth', 'Iyer', '9000000009', '2026-01-25 13:00:00', '2026-01-25 13:00:00'),
    (10, 'user010', 'hash_010_j9f20a', 'Akash', 'Joshi', '9000000010', '2026-01-28 15:40:00', '2026-01-28 15:40:00'),

    (11, 'user011', 'hash_011_k8g31b', 'Ananya', 'Sharma', '9000000011', '2026-02-02 09:20:00', '2026-02-02 09:20:00'),
    (12, 'user012', 'hash_012_l7h42c', 'Diya', 'Patel', '9000000012', '2026-02-05 11:10:00', '2026-02-05 11:10:00'),
    (13, 'user013', 'hash_013_m6i53d', 'Priya', 'Kumar', '9000000013', '2026-02-08 14:00:00', '2026-02-08 14:00:00'),
    (14, 'user014', 'hash_014_n5j64e', 'Meera', 'Reddy', '9000000014', '2026-02-10 10:50:00', '2026-02-10 10:50:00'),
    (15, 'user015', 'hash_015_o4k75f', 'Kavya', 'Gupta', '9000000015', '2026-02-13 16:30:00', '2026-02-13 16:30:00'),
    (16, 'user016', 'hash_016_p3l86g', 'Sneha', 'Mehta', '9000000016', '2026-02-16 12:15:00', '2026-02-16 12:15:00'),
    (17, 'user017', 'hash_017_q2m97h', 'Pooja', 'Nair', '9000000017', '2026-02-19 09:35:00', '2026-02-19 09:35:00'),
    (18, 'user018', 'hash_018_r1n08i', 'Neha', 'Verma', '9000000018', '2026-02-21 13:45:00', '2026-02-21 13:45:00'),
    (19, 'user019', 'hash_019_s0o19j', 'Nisha', 'Iyer', '9000000019', '2026-02-24 15:20:00', '2026-02-24 15:20:00'),
    (20, 'user020', 'hash_020_t9p20k', 'Riya', 'Joshi', '9000000020', '2026-02-27 10:05:00', '2026-02-27 10:05:00'),

    (21, 'user021', 'hash_021_u8q31l', 'Dev', 'Sharma', '9000000021', '2026-03-02 11:25:00', '2026-03-02 11:25:00'),
    (22, 'user022', 'hash_022_v7r42m', 'Kabir', 'Patel', '9000000022', '2026-03-05 14:10:00', '2026-03-05 14:10:00'),
    (23, 'user023', 'hash_023_w6s53n', 'Manav', 'Kumar', '9000000023', '2026-03-08 09:15:00', '2026-03-08 09:15:00'),
    (24, 'user024', 'hash_024_x5t64o', 'Yash', 'Reddy', '9000000024', '2026-03-11 16:00:00', '2026-03-11 16:00:00'),
    (25, 'user025', 'hash_025_y4u75p', 'Varun', 'Gupta', '9000000025', '2026-03-14 12:30:00', '2026-03-14 12:30:00'),
    (26, 'user026', 'hash_026_z3v86q', 'Aditi', 'Mehta', '9000000026', '2026-03-17 10:45:00', '2026-03-17 10:45:00'),
    (27, 'user027', 'hash_027_a2w97r', 'Ira', 'Nair', '9000000027', '2026-03-20 13:20:00', '2026-03-20 13:20:00'),
    (28, 'user028', 'hash_028_b1x08s', 'Tanya', 'Verma', '9000000028', '2026-03-23 15:15:00', '2026-03-23 15:15:00'),
    (29, 'user029', 'hash_029_c0y19t', 'Maya', 'Iyer', '9000000029', '2026-03-26 09:50:00', '2026-03-26 09:50:00'),
    (30, 'user030', 'hash_030_d9z20u', 'Sara', 'Joshi', '9000000030', '2026-03-29 11:40:00', '2026-03-29 11:40:00'),

    (31, 'user031', 'hash_031_e8a31v', 'Nikhil', 'Sharma', '9000000031', '2026-04-02 14:25:00', '2026-04-02 14:25:00'),
    (32, 'user032', 'hash_032_f7b42w', 'Sahil', 'Patel', '9000000032', '2026-04-05 10:10:00', '2026-04-05 10:10:00'),
    (33, 'user033', 'hash_033_g6c53x', 'Mohit', 'Kumar', '9000000033', '2026-04-08 16:45:00', '2026-04-08 16:45:00'),
    (34, 'user034', 'hash_034_h5d64y', 'Aman', 'Reddy', '9000000034', '2026-04-11 12:00:00', '2026-04-11 12:00:00'),
    (35, 'user035', 'hash_035_i4e75z', 'Raj', 'Gupta', '9000000035', '2026-04-14 09:30:00', '2026-04-14 09:30:00'),
    (36, 'user036', 'hash_036_j3f86a', 'Simran', 'Mehta', '9000000036', '2026-04-17 13:15:00', '2026-04-17 13:15:00'),
    (37, 'user037', 'hash_037_k2g97b', 'Shreya', 'Nair', '9000000037', '2026-04-20 15:50:00', '2026-04-20 15:50:00'),
    (38, 'user038', 'hash_038_l1h08c', 'Ishita', 'Verma', '9000000038', '2026-04-23 11:05:00', '2026-04-23 11:05:00'),
    (39, 'user039', 'hash_039_m0i19d', 'Kriti', 'Iyer', '9000000039', '2026-04-26 14:40:00', '2026-04-26 14:40:00'),
    (40, 'user040', 'hash_040_n9j20e', 'Muskan', 'Joshi', '9000000040', '2026-04-29 10:25:00', '2026-04-29 10:25:00'),

    (41, 'user041', 'hash_041_o8k31f', 'Raghav', 'Sharma', '9000000041', '2026-05-03 12:10:00', '2026-05-03 12:10:00'),
    (42, 'user042', 'hash_042_p7l42g', 'Kunal', 'Patel', '9000000042', '2026-05-07 09:45:00', '2026-05-07 09:45:00'),
    (43, 'user043', 'hash_043_q6m53h', 'Harsh', 'Kumar', '9000000043', '2026-05-11 15:30:00', '2026-05-11 15:30:00'),
    (44, 'user044', 'hash_044_r5n64i', 'Vikram', 'Reddy', '9000000044', '2026-05-15 11:20:00', '2026-05-15 11:20:00'),
    (45, 'user045', 'hash_045_s4o75j', 'Ankit', 'Gupta', '9000000045', '2026-05-19 13:55:00', '2026-05-19 13:55:00'),
    (46, 'user046', 'hash_046_t3p86k', 'Deepak', 'Mehta', '9000000046', '2026-05-23 10:35:00', '2026-05-23 10:35:00'),
    (47, 'user047', 'hash_047_u2q97l', 'Abhishek', 'Nair', '9000000047', '2026-05-27 16:15:00', '2026-05-27 16:15:00'),
    (48, 'user048', 'hash_048_v1r08m', 'Varun', 'Verma', '9000000048', '2026-05-30 14:05:00', '2026-05-30 14:05:00'),
    (49, 'user049', 'hash_049_w0s19n', 'Suresh', 'Iyer', '9000000049', '2026-06-03 09:25:00', '2026-06-03 09:25:00'),
    (50, 'user050', 'hash_050_x9t20o', 'Pranav', 'Joshi', '9000000050', '2026-06-07 12:45:00', '2026-06-07 12:45:00');
    
SELECT COUNT(*) AS total_users
FROM "user";

SELECT
    COUNT(*) AS total_users,
    COUNT(DISTINCT username) AS unique_usernames,
    COUNT(DISTINCT password) AS unique_password_hashes
FROM "user";

INSERT INTO product
    (id, name, "desc", sku, category_id, inventory_id, price, discount_id, created_at, modified_at)
VALUES
    (1, 'Dell Inspiron 15', '15-inch performance laptop',
        'LAP-DELL-001', 2, 1, 65000.00, 2, '2026-01-15 10:00:00', '2026-08-20 10:00:00'),

    (2, 'HP Pavilion 14', 'Compact everyday laptop',
        'LAP-HP-002', 2, 2, 58000.00, 3, '2026-01-15 10:10:00', '2026-08-21 11:00:00'),

    (3, 'Lenovo ThinkPad E14', 'Business productivity laptop',
        'LAP-LEN-003', 2, 3, 72000.00, 4, '2026-01-16 09:00:00', '2026-08-19 14:00:00'),

    (4, 'Samsung Galaxy S25', 'Flagship Android smartphone',
        'PHN-SAM-004', 3, 4, 74999.00, 4, '2026-01-18 11:00:00', '2026-08-22 09:30:00'),

    (5, 'iPhone 16', 'Apple smartphone',
        'PHN-APP-005', 3, 5, 79999.00, 3, '2026-01-18 11:15:00', '2026-08-18 16:00:00'),

    (6, 'OnePlus 13', 'Premium Android smartphone',
        'PHN-ONE-006', 3, 6, 69999.00, NULL, '2026-01-20 12:00:00', '2026-08-20 12:00:00'),

    (7, 'Logitech MX Master 3S', 'Wireless productivity mouse',
        'ACC-LOG-007', 4, 7, 8999.00, 2, '2026-01-22 09:30:00', '2026-08-23 08:45:00'),

    (8, 'Keychron K2 Keyboard', 'Mechanical wireless keyboard',
        'ACC-KEY-008', 4, 8, 8990.00, 1, '2026-01-22 10:00:00', '2026-08-21 13:00:00'),

    (9, 'Anker 65W Charger', 'Fast USB-C charging adapter',
        'ACC-ANK-009', 4, 9, 3499.00, NULL, '2026-01-25 14:00:00', '2026-08-19 15:30:00'),

    (10, 'Samsung 27-inch Monitor', 'Full HD productivity monitor',
        'MON-SAM-010', 2, 10, 18999.00, 3, '2026-01-26 15:00:00', '2026-08-17 10:15:00'),

    (11, 'LG 55-inch Smart TV', '4K smart television',
        'TV-LG-011', 5, 11, 52999.00, 5, '2026-02-01 10:00:00', '2026-08-22 11:20:00'),

    (12, 'Samsung 253L Refrigerator', 'Double-door refrigerator',
        'APP-SAM-012', 5, 12, 31999.00, 2, '2026-02-02 11:00:00', '2026-08-20 14:10:00'),

    (13, 'Philips Air Fryer', 'Digital air fryer',
        'APP-PHI-013', 5, 13, 7999.00, 1, '2026-02-03 12:00:00', '2026-08-23 12:00:00'),

    (14, 'Bajaj Mixer Grinder', '750W kitchen mixer grinder',
        'APP-BAJ-014', 5, 14, 4999.00, NULL, '2026-02-04 13:00:00', '2026-08-19 09:45:00'),

    (15, 'Nike Running Shoes', 'Lightweight running shoes',
        'FAS-NIK-015', 6, 15, 6999.00, 3, '2026-02-08 09:00:00', '2026-08-24 16:30:00'),

    (16, 'Levi''s Slim Fit Jeans', 'Classic slim-fit denim',
        'FAS-LEV-016', 6, 16, 3499.00, 2, '2026-02-09 10:00:00', '2026-08-18 13:40:00'),

    (17, 'Allen Solly Casual Shirt', 'Cotton casual shirt',
        'FAS-ALS-017', 6, 17, 2499.00, 1, '2026-02-10 11:00:00', '2026-08-21 10:50:00'),

    (18, 'Adidas Hoodie', 'Comfortable sports hoodie',
        'FAS-ADI-018', 6, 18, 3999.00, NULL, '2026-02-11 12:00:00', '2026-08-20 15:00:00'),

    (19, 'Atomic Habits', 'Personal development book',
        'BOK-JAM-019', 7, 19, 599.00, 7, '2026-02-15 09:00:00', '2026-08-24 09:20:00'),

    (20, 'Clean Code', 'Software development book',
        'BOK-ROB-020', 7, 20, 899.00, NULL, '2026-02-16 10:00:00', '2026-08-22 14:30:00'),

    (21, 'Data Engineering with Python', 'Data engineering reference book',
        'BOK-DAT-021', 7, 21, 1299.00, 7, '2026-02-17 11:00:00', '2026-08-19 11:10:00'),

    (22, 'SQL Interview Guide', 'SQL interview preparation book',
        'BOK-SQL-022', 7, 22, 799.00, 1, '2026-02-18 12:00:00', '2026-08-23 15:20:00'),

    (23, 'Yonex Badminton Racket', 'Intermediate badminton racket',
        'SPT-YON-023', 8, 23, 4999.00, 2, '2026-02-20 09:30:00', '2026-08-21 16:00:00'),

    (24, 'SG Cricket Bat', 'English willow cricket bat',
        'SPT-SG-024', 8, 24, 8999.00, 3, '2026-02-21 10:30:00', '2026-08-24 10:30:00'),

    (25, 'Nike Football', 'Professional training football',
        'SPT-NIK-025', 8, 25, 1999.00, NULL, '2026-02-22 11:30:00', '2026-08-18 12:20:00'),

    (26, 'Decathlon Dumbbell Set', 'Adjustable home workout dumbbells',
        'SPT-DEC-026', 8, 26, 2999.00, 5, '2026-02-23 12:30:00', '2026-08-20 09:50:00'),

    (27, 'Lakme Face Cream', 'Daily moisturizing face cream',
        'BEA-LAK-027', 9, 27, 899.00, 1, '2026-03-01 09:00:00', '2026-08-22 13:15:00'),

    (28, 'L''Oreal Shampoo', 'Nourishing hair shampoo',
        'BEA-LOR-028', 9, 28, 799.00, 2, '2026-03-02 10:00:00', '2026-08-24 15:45:00'),

    (29, 'Nivea Body Lotion', 'Moisturizing body lotion',
        'BEA-NIV-029', 9, 29, 599.00, NULL, '2026-03-03 11:00:00', '2026-08-21 12:40:00'),

    (30, 'Philips Trimmer', 'Cordless rechargeable trimmer',
        'BEA-PHI-030', 9, 30, 2499.00, 4, '2026-03-04 12:00:00', '2026-08-19 14:50:00');
    
SELECT COUNT(*) AS total_products
FROM product;

SELECT
    p.id,
    p.name,
    pc.name AS category,
    p.price,
    d.discount_percent,
    pi.quantity AS stock
FROM product p
JOIN product_category pc
    ON p.category_id = pc.id
JOIN product_inventory pi
    ON p.inventory_id = pi.id
LEFT JOIN discount d
    ON p.discount_id = d.id
ORDER BY p.id;

INSERT INTO user_address
    (id, user_id, address_line1, address_line2, city, postal_code, country, telephone, mobile)
VALUES
    (1, 1, '12 MG Road', 'Near Central Mall', 'Bengaluru', '560001', 'India', '08040000001', '9001000001'),
    (2, 2, '45 FC Road', 'Shivajinagar', 'Pune', '411005', 'India', '02040000002', '9001000002'),
    (3, 3, '18 Anna Salai', 'Teynampet', 'Chennai', '600018', 'India', '04440000003', '9001000003'),
    (4, 4, '22 Banjara Hills', 'Road No 10', 'Hyderabad', '500034', 'India', '04040000004', '9001000004'),
    (5, 5, '31 Koramangala 5th Block', NULL, 'Bengaluru', '560095', 'India', '08040000005', '9001000005'),
    (6, 6, '16 Andheri West', 'Near Metro Station', 'Mumbai', '400058', 'India', '02240000006', '9001000006'),
    (7, 7, '8 Marine Drive', NULL, 'Mumbai', '400020', 'India', '02240000007', '9001000007'),
    (8, 8, '27 Sector 17', 'Chandigarh', 'Chandigarh', '160017', 'India', '01724000008', '9001000008'),
    (9, 9, '14 Indiranagar 12th Main', NULL, 'Bengaluru', '560038', 'India', '08040000009', '9001000009'),
    (10, 10, '52 C Scheme', 'Near Railway Station', 'Jaipur', '302001', 'India', '01414000010', '9001000010'),

    (11, 11, '19 Salt Lake Sector V', NULL, 'Kolkata', '700091', 'India', '03340000011', '9001000011'),
    (12, 12, '34 Viman Nagar', NULL, 'Pune', '411014', 'India', '02040000012', '9001000012'),
    (13, 13, '7 Adyar', 'Near Beach Road', 'Chennai', '600020', 'India', '04440000013', '9001000013'),
    (14, 14, '25 Jubilee Hills', NULL, 'Hyderabad', '500033', 'India', '04040000014', '9001000014'),
    (15, 15, '41 Powai', 'Hiranandani Gardens', 'Mumbai', '400076', 'India', '02240000015', '9001000015'),
    (16, 16, '63 Whitefield Main Road', NULL, 'Bengaluru', '560066', 'India', '08040000016', '9001000016'),
    (17, 17, '9 Civil Lines', NULL, 'Delhi', '110054', 'India', '01140000017', '9001000017'),
    (18, 18, '28 Noida Sector 18', NULL, 'Noida', '201301', 'India', '01204000018', '9001000018'),
    (19, 19, '11 Koregaon Park', NULL, 'Pune', '411001', 'India', '02040000019', '9001000019'),
    (20, 20, '38 HSR Layout', NULL, 'Bengaluru', '560102', 'India', '08040000020', '9001000020'),

    (21, 21, '17 Alwarpet', NULL, 'Chennai', '600018', 'India', '04440000021', '9001000021'),
    (22, 22, '46 Kondapur', NULL, 'Hyderabad', '500084', 'India', '04040000022', '9001000022'),
    (23, 23, '29 Thane West', NULL, 'Thane', '400601', 'India', '02240000023', '9001000023'),
    (24, 24, '55 Dwarka Sector 10', NULL, 'Delhi', '110075', 'India', '01140000024', '9001000024'),
    (25, 25, '72 Baner Road', NULL, 'Pune', '411045', 'India', '02040000025', '9001000025'),
    (26, 26, '13 Electronic City', NULL, 'Bengaluru', '560100', 'India', '08040000026', '9001000026'),
    (27, 27, '36 Velachery Main Road', NULL, 'Chennai', '600042', 'India', '04440000027', '9001000027'),
    (28, 28, '21 Gachibowli', NULL, 'Hyderabad', '500032', 'India', '04040000028', '9001000028'),
    (29, 29, '44 Powai Lake Road', NULL, 'Mumbai', '400076', 'India', '02240000029', '9001000029'),
    (30, 30, '6 Malviya Nagar', NULL, 'Jaipur', '302017', 'India', '01414000030', '9001000030'),

    (31, 31, '15 Rajouri Garden', NULL, 'Delhi', '110027', 'India', '01140000031', '9001000031'),
    (32, 32, '33 Hinjewadi Phase 1', NULL, 'Pune', '411057', 'India', '02040000032', '9001000032'),
    (33, 33, '48 Anna Nagar', NULL, 'Chennai', '600040', 'India', '04440000033', '9001000033'),
    (34, 34, '19 Madhapur', NULL, 'Hyderabad', '500081', 'India', '04040000034', '9001000034'),
    (35, 35, '62 Borivali West', NULL, 'Mumbai', '400092', 'India', '02240000035', '9001000035'),
    (36, 36, '24 Marathahalli', NULL, 'Bengaluru', '560037', 'India', '08040000036', '9001000036'),
    (37, 37, '7 Vasant Kunj', NULL, 'Delhi', '110070', 'India', '01140000037', '9001000037'),
    (38, 38, '39 Wakad', NULL, 'Pune', '411057', 'India', '02040000038', '9001000038'),
    (39, 39, '26 Besant Nagar', NULL, 'Chennai', '600090', 'India', '04440000039', '9001000039'),
    (40, 40, '51 Kukatpally', NULL, 'Hyderabad', '500072', 'India', '04040000040', '9001000040'),

    (41, 41, '18 Bandra East', NULL, 'Mumbai', '400051', 'India', '02240000041', '9001000041'),
    (42, 42, '42 Yelahanka', NULL, 'Bengaluru', '560064', 'India', '08040000042', '9001000042'),
    (43, 43, '16 Greater Kailash', NULL, 'Delhi', '110048', 'India', '01140000043', '9001000043'),
    (44, 44, '8 Kothrud', NULL, 'Pune', '411038', 'India', '02040000044', '9001000044'),
    (45, 45, '35 T Nagar', NULL, 'Chennai', '600017', 'India', '04440000045', '9001000045'),
    (46, 46, '23 Secunderabad', NULL, 'Hyderabad', '500003', 'India', '04040000046', '9001000046'),
    (47, 47, '57 Goregaon East', NULL, 'Mumbai', '400063', 'India', '02240000047', '9001000047'),
    (48, 48, '11 JP Nagar', NULL, 'Bengaluru', '560078', 'India', '08040000048', '9001000048'),
    (49, 49, '29 Saket', NULL, 'Delhi', '110017', 'India', '01140000049', '9001000049'),
    (50, 50, '64 Aundh', NULL, 'Pune', '411007', 'India', '02040000050', '9001000050'),

    -- Additional addresses for users with multiple addresses
    (51, 1, '88 Whitefield Road', 'ITPL Main Road', 'Bengaluru', '560066', 'India', '08040000051', '9001000051'),
    (52, 5, '17 MG Road', 'Near Trinity Metro', 'Bengaluru', '560001', 'India', '08040000052', '9001000052'),
    (53, 10, '21 Vaishali Nagar', NULL, 'Jaipur', '302021', 'India', '01414000053', '9001000053'),
    (54, 15, '9 Powai Main Road', NULL, 'Mumbai', '400076', 'India', '02240000054', '9001000054'),
    (55, 20, '73 Sarjapur Road', NULL, 'Bengaluru', '560035', 'India', '08040000055', '9001000055'),
    (56, 25, '12 Kalyani Nagar', NULL, 'Pune', '411006', 'India', '02040000056', '9001000056'),
    (57, 30, '41 C-Scheme', NULL, 'Jaipur', '302001', 'India', '01414000057', '9001000057'),
    (58, 35, '6 Andheri East', NULL, 'Mumbai', '400069', 'India', '02240000058', '9001000058'),
    (59, 40, '14 Banjara Hills', NULL, 'Hyderabad', '500034', 'India', '04040000059', '9001000059'),
    (60, 45, '27 Adyar Extension', NULL, 'Chennai', '600020', 'India', '04440000060', '9001000060');

SELECT COUNT(*) AS total_addresses
FROM user_address;

SELECT
    user_id,
    COUNT(*) AS address_count
FROM user_address
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY user_id;

INSERT INTO user_payment
    (id, user_id, payment_type, provider, account_no, expiry)
VALUES
    (1, 1, 'Credit Card', 'HDFC Bank', '411111000001', '2028-01-31'),
    (2, 2, 'Debit Card', 'ICICI Bank', '522222000002', '2027-06-30'),
    (3, 3, 'UPI', 'Google Pay', 'upi_user003', NULL),
    (4, 4, 'Credit Card', 'Axis Bank', '433333000004', '2029-03-31'),
    (5, 5, 'Debit Card', 'SBI', '544444000005', '2028-09-30'),
    (6, 6, 'UPI', 'PhonePe', 'upi_user006', NULL),
    (7, 7, 'Credit Card', 'ICICI Bank', '455555000007', '2027-12-31'),
    (8, 8, 'Debit Card', 'HDFC Bank', '566666000008', '2029-02-28'),
    (9, 9, 'UPI', 'Google Pay', 'upi_user009', NULL),
    (10, 10, 'Credit Card', 'SBI', '477777000010', '2028-05-31'),

    (11, 11, 'Debit Card', 'Axis Bank', '588888000011', '2027-11-30'),
    (12, 12, 'UPI', 'PhonePe', 'upi_user012', NULL),
    (13, 13, 'Credit Card', 'HDFC Bank', '499999000013', '2029-07-31'),
    (14, 14, 'Debit Card', 'ICICI Bank', '511111000014', '2028-04-30'),
    (15, 15, 'UPI', 'Google Pay', 'upi_user015', NULL),
    (16, 16, 'Credit Card', 'Axis Bank', '422222000016', '2027-08-31'),
    (17, 17, 'Debit Card', 'SBI', '533333000017', '2029-01-31'),
    (18, 18, 'UPI', 'PhonePe', 'upi_user018', NULL),
    (19, 19, 'Credit Card', 'ICICI Bank', '444444000019', '2028-10-31'),
    (20, 20, 'Debit Card', 'HDFC Bank', '555555000020', '2027-05-31'),

    (21, 21, 'UPI', 'Google Pay', 'upi_user021', NULL),
    (22, 22, 'Credit Card', 'SBI', '466666000022', '2029-06-30'),
    (23, 23, 'Debit Card', 'Axis Bank', '577777000023', '2028-12-31'),
    (24, 24, 'UPI', 'PhonePe', 'upi_user024', NULL),
    (25, 25, 'Credit Card', 'HDFC Bank', '488888000025', '2027-09-30'),
    (26, 26, 'Debit Card', 'ICICI Bank', '599999000026', '2029-04-30'),
    (27, 27, 'UPI', 'Google Pay', 'upi_user027', NULL),
    (28, 28, 'Credit Card', 'Axis Bank', '400000000028', '2028-02-29'),
    (29, 29, 'Debit Card', 'SBI', '511111000029', '2027-07-31'),
    (30, 30, 'UPI', 'PhonePe', 'upi_user030', NULL),

    (31, 31, 'Credit Card', 'ICICI Bank', '422222000031', '2029-08-31'),
    (32, 32, 'Debit Card', 'HDFC Bank', '533333000032', '2028-11-30'),
    (33, 33, 'UPI', 'Google Pay', 'upi_user033', NULL),
    (34, 34, 'Credit Card', 'Axis Bank', '444444000034', '2027-10-31'),
    (35, 35, 'Debit Card', 'SBI', '555555000035', '2029-05-31'),
    (36, 36, 'UPI', 'PhonePe', 'upi_user036', NULL),
    (37, 37, 'Credit Card', 'HDFC Bank', '466666000037', '2028-03-31'),
    (38, 38, 'Debit Card', 'ICICI Bank', '577777000038', '2027-12-31'),
    (39, 39, 'UPI', 'Google Pay', 'upi_user039', NULL),
    (40, 40, 'Credit Card', 'SBI', '488888000040', '2029-09-30'),

    (41, 41, 'Debit Card', 'Axis Bank', '499999000041', '2028-06-30'),
    (42, 42, 'UPI', 'PhonePe', 'upi_user042', NULL),
    (43, 43, 'Credit Card', 'ICICI Bank', '511111000043', '2027-04-30'),
    (44, 44, 'Debit Card', 'HDFC Bank', '522222000044', '2029-02-28'),
    (45, 45, 'UPI', 'Google Pay', 'upi_user045', NULL),
    (46, 46, 'Credit Card', 'Axis Bank', '533333000046', '2028-08-31'),
    (47, 47, 'Debit Card', 'SBI', '544444000047', '2027-11-30'),
    (48, 48, 'UPI', 'PhonePe', 'upi_user048', NULL),
    (49, 49, 'Credit Card', 'HDFC Bank', '555555000049', '2029-01-31'),
    (50, 50, 'Debit Card', 'ICICI Bank', '566666000050', '2028-05-31'),

    -- Additional payment methods
    (51, 3, 'UPI', 'Google Pay', 'upi_user001', NULL),
    (52, 8, 'Credit Card', 'ICICI Bank', '477777000052', '2029-06-30'),
    (53, 13, 'UPI', 'PhonePe', 'upi_user010', NULL),
    (54, 18, 'Debit Card', 'SBI', '588888000054', '2028-10-31'),
    (55, 23, 'Credit Card', 'Axis Bank', '499999000055', '2027-08-31'),
    (56, 28, 'UPI', 'Google Pay', 'upi_user025', NULL),
    (57, 33, 'Credit Card', 'HDFC Bank', '511111000057', '2029-03-31'),
    (58, 38, 'UPI', 'PhonePe', 'upi_user035', NULL),
    (59, 43, 'Debit Card', 'ICICI Bank', '522222000059', '2028-12-31'),
    (60, 48, 'UPI', 'Google Pay', 'upi_user045_alt', NULL);

SELECT COUNT(*) AS total_payment_methods
FROM user_payment;

SELECT
    user_id,
    COUNT(*) AS payment_method_count
FROM user_payment
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY user_id;

INSERT INTO shopping_session
    (id, user_id, total, created_at, modified_at)
VALUES
    (1, 1, 72999.00, '2026-02-01 10:15:00', '2026-02-01 10:45:00'),
    (2, 2, 8999.00, '2026-02-03 14:20:00', '2026-02-03 14:50:00'),
    (3, 3, 0.00, '2026-02-05 09:30:00', '2026-02-05 09:35:00'),
    (4, 4, 74999.00, '2026-02-07 18:10:00', '2026-02-07 18:45:00'),
    (5, 5, 13998.00, '2026-02-09 11:00:00', '2026-02-09 11:30:00'),
    (6, 6, 3499.00, '2026-02-11 16:20:00', '2026-02-11 16:45:00'),
    (7, 7, 0.00, '2026-02-13 12:10:00', '2026-02-13 12:15:00'),
    (8, 8, 18999.00, '2026-02-15 19:00:00', '2026-02-15 19:40:00'),
    (9, 9, 6999.00, '2026-02-17 10:30:00', '2026-02-17 11:00:00'),
    (10, 10, 52999.00, '2026-02-19 15:15:00', '2026-02-19 16:00:00'),

    (11, 11, 599.00, '2026-02-21 09:20:00', '2026-02-21 09:35:00'),
    (12, 12, 4999.00, '2026-02-23 13:00:00', '2026-02-23 13:25:00'),
    (13, 13, 7999.00, '2026-02-25 17:30:00', '2026-02-25 18:00:00'),
    (14, 14, 0.00, '2026-02-27 11:45:00', '2026-02-27 11:50:00'),
    (15, 15, 6999.00, '2026-03-01 14:10:00', '2026-03-01 14:40:00'),
    (16, 16, 3999.00, '2026-03-03 10:00:00', '2026-03-03 10:25:00'),
    (17, 17, 2499.00, '2026-03-05 18:20:00', '2026-03-05 18:50:00'),
    (18, 18, 0.00, '2026-03-07 12:30:00', '2026-03-07 12:35:00'),
    (19, 19, 1299.00, '2026-03-09 16:00:00', '2026-03-09 16:20:00'),
    (20, 20, 899.00, '2026-03-11 09:45:00', '2026-03-11 10:10:00'),

    (21, 21, 4999.00, '2026-03-13 13:15:00', '2026-03-13 13:45:00'),
    (22, 22, 8999.00, '2026-03-15 17:00:00', '2026-03-15 17:35:00'),
    (23, 23, 1999.00, '2026-03-17 11:20:00', '2026-03-17 11:45:00'),
    (24, 24, 2999.00, '2026-03-19 15:30:00', '2026-03-19 16:00:00'),
    (25, 25, 0.00, '2026-03-21 10:10:00', '2026-03-21 10:15:00'),
    (26, 26, 899.00, '2026-03-23 18:10:00', '2026-03-23 18:35:00'),
    (27, 27, 799.00, '2026-03-25 12:00:00', '2026-03-25 12:20:00'),
    (28, 28, 2499.00, '2026-03-27 09:30:00', '2026-03-27 09:50:00'),
    (29, 29, 0.00, '2026-03-29 14:45:00', '2026-03-29 14:50:00'),
    (30, 30, 31999.00, '2026-03-31 16:15:00', '2026-03-31 16:50:00'),

    (31, 31, 65000.00, '2026-04-02 10:00:00', '2026-04-02 10:40:00'),
    (32, 32, 3499.00, '2026-04-04 13:30:00', '2026-04-04 14:00:00'),
    (33, 33, 0.00, '2026-04-06 17:15:00', '2026-04-06 17:20:00'),
    (34, 34, 52999.00, '2026-04-08 11:00:00', '2026-04-08 11:45:00'),
    (35, 35, 6999.00, '2026-04-10 15:20:00', '2026-04-10 15:50:00'),
    (36, 36, 1299.00, '2026-04-12 09:15:00', '2026-04-12 09:35:00'),
    (37, 37, 4999.00, '2026-04-14 18:00:00', '2026-04-14 18:30:00'),
    (38, 38, 0.00, '2026-04-16 12:40:00', '2026-04-16 12:45:00'),
    (39, 39, 899.00, '2026-04-18 14:10:00', '2026-04-18 14:35:00'),
    (40, 40, 18999.00, '2026-04-20 16:30:00', '2026-04-20 17:00:00'),

    (41, 41, 7999.00, '2026-04-22 10:20:00', '2026-04-22 10:50:00'),
    (42, 42, 2499.00, '2026-04-24 13:00:00', '2026-04-24 13:25:00'),
    (43, 43, 0.00, '2026-04-26 17:40:00', '2026-04-26 17:45:00'),
    (44, 44, 8999.00, '2026-04-28 11:30:00', '2026-04-28 12:00:00'),
    (45, 45, 599.00, '2026-04-30 15:00:00', '2026-04-30 15:20:00'),
    (46, 46, 2999.00, '2026-05-02 09:45:00', '2026-05-02 10:10:00'),
    (47, 47, 3499.00, '2026-05-04 18:15:00', '2026-05-04 18:40:00'),
    (48, 48, 0.00, '2026-05-06 12:20:00', '2026-05-06 12:25:00'),
    (49, 49, 4999.00, '2026-05-08 14:30:00', '2026-05-08 15:00:00'),
    (50, 50, 7999.00, '2026-05-10 16:00:00', '2026-05-10 16:30:00'),

    -- Additional sessions for selected users
    (51, 1, 8999.00, '2026-05-15 10:00:00', '2026-05-15 10:25:00'),
    (52, 3, 74999.00, '2026-05-17 14:00:00', '2026-05-17 14:40:00'),
    (53, 5, 0.00, '2026-05-19 18:00:00', '2026-05-19 18:05:00'),
    (54, 8, 18999.00, '2026-05-21 11:30:00', '2026-05-21 12:00:00'),
    (55, 10, 52999.00, '2026-05-23 15:00:00', '2026-05-23 15:45:00'),
    (56, 15, 6999.00, '2026-05-25 09:30:00', '2026-05-25 09:55:00'),
    (57, 20, 1299.00, '2026-05-27 13:15:00', '2026-05-27 13:35:00'),
    (58, 25, 4999.00, '2026-05-29 17:00:00', '2026-05-29 17:30:00'),
    (59, 30, 0.00, '2026-06-01 10:45:00', '2026-06-01 10:50:00'),
    (60, 35, 3999.00, '2026-06-03 14:20:00', '2026-06-03 14:45:00'),

    (61, 40, 2499.00, '2026-06-05 18:10:00', '2026-06-05 18:35:00'),
    (62, 45, 599.00, '2026-06-07 11:00:00', '2026-06-07 11:20:00'),
    (63, 48, 799.00, '2026-06-09 15:30:00', '2026-06-09 15:50:00'),
    (64, 2, 65000.00, '2026-06-11 09:15:00', '2026-06-11 10:00:00'),
    (65, 12, 4999.00, '2026-06-13 13:00:00', '2026-06-13 13:25:00'),
    (66, 18, 0.00, '2026-06-15 17:20:00', '2026-06-15 17:25:00'),
    (67, 28, 2499.00, '2026-06-17 12:10:00', '2026-06-17 12:35:00'),
    (68, 33, 8999.00, '2026-06-19 16:00:00', '2026-06-19 16:30:00'),
    (69, 43, 6999.00, '2026-06-21 10:30:00', '2026-06-21 11:00:00'),
    (70, 48, 0.00, '2026-06-23 14:15:00', '2026-06-23 14:20:00');

SELECT COUNT(*) AS total_sessions
FROM shopping_session;

SELECT
    user_id,
    COUNT(*) AS session_count
FROM shopping_session
GROUP BY user_id
HAVING COUNT(*) > 1
ORDER BY user_id;

INSERT INTO cart_item
    (id, session_id, product_id, quantity, created_at)
VALUES
    (1, 1, 1, 1, '2026-02-01 10:20:00'),
    (2, 1, 9, 1, '2026-02-01 10:25:00'),
    (3, 2, 8, 1, '2026-02-03 14:25:00'),
    (4, 3, 5, 1, '2026-02-05 09:32:00'),
    (5, 4, 5, 1, '2026-02-07 18:20:00'),
    (6, 5, 15, 1, '2026-02-09 11:10:00'),
    (7, 5, 16, 2, '2026-02-09 11:15:00'),
    (8, 6, 9, 1, '2026-02-11 16:25:00'),
    (9, 7, 25, 1, '2026-02-13 12:12:00'),
    (10, 8, 10, 1, '2026-02-15 19:10:00'),
    (11, 9, 15, 1, '2026-02-17 10:35:00'),
    (12, 10, 11, 1, '2026-02-19 15:20:00'),
    (13, 11, 19, 1, '2026-02-21 09:25:00'),
    (14, 12, 14, 1, '2026-02-23 13:05:00'),
    (15, 13, 13, 1, '2026-02-25 17:35:00'),
    (16, 14, 6, 1, '2026-02-27 11:47:00'),
    (17, 15, 15, 1, '2026-03-01 14:15:00'),
    (18, 16, 18, 1, '2026-03-03 10:05:00'),
    (19, 17, 17, 1, '2026-03-05 18:25:00'),
    (20, 18, 20, 1, '2026-03-07 12:32:00'),
    (21, 19, 21, 1, '2026-03-09 16:05:00'),
    (22, 20, 20, 1, '2026-03-11 09:50:00'),
    (23, 21, 23, 1, '2026-03-13 13:20:00'),
    (24, 22, 24, 1, '2026-03-15 17:05:00'),
    (25, 23, 25, 1, '2026-03-17 11:25:00'),
    (26, 24, 26, 1, '2026-03-19 15:35:00'),
    (27, 25, 27, 1, '2026-03-21 10:12:00'),
    (28, 26, 27, 1, '2026-03-23 18:15:00'),
    (29, 27, 28, 1, '2026-03-25 12:05:00'),
    (30, 28, 30, 1, '2026-03-27 09:35:00'),
    (31, 29, 29, 1, '2026-03-29 14:47:00'),
    (32, 30, 12, 1, '2026-03-31 16:20:00'),
    (33, 31, 1, 1, '2026-04-02 10:10:00'),
    (34, 31, 7, 1, '2026-04-02 10:15:00'),
    (35, 32, 9, 1, '2026-04-04 13:35:00'),
    (36, 33, 6, 1, '2026-04-06 17:17:00'),
    (37, 34, 11, 1, '2026-04-08 11:10:00'),
    (38, 35, 15, 1, '2026-04-10 15:25:00'),
    (39, 36, 21, 1, '2026-04-12 09:20:00'),
    (40, 37, 23, 1, '2026-04-14 18:05:00'),
    (41, 38, 20, 1, '2026-04-16 12:42:00'),
    (42, 39, 27, 1, '2026-04-18 14:15:00'),
    (43, 40, 10, 1, '2026-04-20 16:35:00'),
    (44, 41, 13, 1, '2026-04-22 10:25:00'),
    (45, 42, 17, 1, '2026-04-24 13:05:00'),
    (46, 43, 18, 1, '2026-04-26 17:42:00'),
    (47, 44, 24, 1, '2026-04-28 11:35:00'),
    (48, 45, 19, 1, '2026-04-30 15:05:00'),
    (49, 46, 26, 1, '2026-05-02 09:50:00'),
    (50, 47, 9, 1, '2026-05-04 18:20:00'),
    (51, 48, 28, 1, '2026-05-06 12:22:00'),
    (52, 49, 23, 1, '2026-05-08 14:35:00'),
    (53, 50, 13, 1, '2026-05-10 16:05:00'),

    -- Additional items for richer cart behavior
    (54, 1, 7, 1, '2026-02-01 10:30:00'),
    (55, 4, 9, 1, '2026-02-07 18:25:00'),
    (56, 5, 17, 1, '2026-02-09 11:20:00'),
    (57, 8, 9, 1, '2026-02-15 19:15:00'),
    (58, 10, 12, 1, '2026-02-19 15:25:00'),
    (59, 15, 16, 1, '2026-03-01 14:20:00'),
    (60, 21, 25, 1, '2026-03-13 13:25:00'),
    (61, 22, 23, 1, '2026-03-15 17:10:00'),
    (62, 24, 27, 1, '2026-03-19 15:40:00'),
    (63, 30, 13, 1, '2026-03-31 16:25:00'),
    (64, 31, 9, 2, '2026-04-02 10:20:00'),
    (65, 34, 12, 1, '2026-04-08 11:15:00'),
    (66, 35, 17, 1, '2026-04-10 15:30:00'),
    (67, 37, 24, 1, '2026-04-14 18:10:00'),
    (68, 40, 9, 2, '2026-04-20 16:40:00'),
    (69, 41, 27, 1, '2026-04-22 10:30:00'),
    (70, 44, 23, 1, '2026-04-28 11:40:00'),
    (71, 47, 8, 1, '2026-05-04 18:25:00'),
    (72, 49, 24, 1, '2026-05-08 14:40:00'),

    -- More multi-product sessions
    (73, 51, 8, 1, '2026-05-15 10:05:00'),
    (74, 51, 9, 1, '2026-05-15 10:10:00'),
    (75, 52, 4, 1, '2026-05-17 14:05:00'),
    (76, 52, 3, 1, '2026-05-17 14:10:00'),
    (77, 53, 6, 1, '2026-05-19 18:02:00'),
    (78, 54, 10, 1, '2026-05-21 11:35:00'),
    (79, 54, 7, 1, '2026-05-21 11:40:00'),
    (80, 55, 11, 1, '2026-05-23 15:05:00'),
    (81, 55, 12, 1, '2026-05-23 15:10:00'),
    (82, 56, 15, 1, '2026-05-25 09:35:00'),
    (83, 57, 21, 1, '2026-05-27 13:20:00'),
    (84, 58, 23, 1, '2026-05-29 17:05:00'),
    (85, 58, 25, 1, '2026-05-29 17:10:00'),
    (86, 59, 29, 1, '2026-06-01 10:47:00'),
    (87, 60, 18, 1, '2026-06-03 14:25:00'),
    (88, 61, 30, 1, '2026-06-05 18:15:00'),
    (89, 62, 19, 1, '2026-06-07 11:05:00'),
    (90, 63, 28, 1, '2026-06-09 15:35:00'),
    (91, 64, 1, 1, '2026-06-11 09:20:00'),
    (92, 65, 14, 1, '2026-06-13 13:05:00'),
    (93, 66, 20, 1, '2026-06-15 17:22:00'),
    (94, 67, 30, 1, '2026-06-17 12:15:00'),
    (95, 68, 8, 1, '2026-06-19 16:05:00'),
    (96, 69, 15, 1, '2026-06-21 10:35:00'),
    (97, 70, 27, 1, '2026-06-23 14:17:00'),

    -- Additional quantity variation
    (98, 2, 8, 2, '2026-02-03 14:30:00'),
    (99, 5, 16, 1, '2026-02-09 11:25:00'),
    (100, 10, 11, 1, '2026-02-19 15:30:00'),
    (101, 12, 14, 2, '2026-02-23 13:10:00'),
    (102, 15, 16, 2, '2026-03-01 14:25:00'),
    (103, 22, 24, 2, '2026-03-15 17:15:00'),
    (104, 31, 7, 2, '2026-04-02 10:25:00'),
    (105, 40, 10, 2, '2026-04-20 16:45:00'),
    (106, 52, 3, 1, '2026-05-17 14:15:00'),
    (107, 55, 11, 1, '2026-05-23 15:15:00'),
    (108, 58, 25, 2, '2026-05-29 17:15:00'),
    (109, 64, 1, 1, '2026-06-11 09:25:00'),
    (110, 68, 8, 2, '2026-06-19 16:10:00'),
    (111, 69, 15, 2, '2026-06-21 10:40:00'),
    (112, 70, 27, 1, '2026-06-23 14:22:00');

SELECT COUNT(*) AS total_cart_items
FROM cart_item;

SELECT
    session_id,
    COUNT(*) AS item_count,
    SUM(quantity) AS total_quantity
FROM cart_item
GROUP BY session_id
ORDER BY session_id;

SELECT COUNT(*) AS invalid_cart_items
FROM cart_item ci
LEFT JOIN product p
    ON ci.product_id = p.id
WHERE p.id IS NULL;

INSERT INTO order_details
    (id, user_id, total, payment_id, created_at, modified_at)
VALUES
    (1, 1, 73998.00, NULL, '2026-02-02 11:00:00', '2026-02-02 11:30:00'),
    (2, 2, 17998.00, NULL, '2026-02-04 15:00:00', '2026-02-04 15:30:00'),
    (3, 4, 74999.00, NULL, '2026-02-08 10:00:00', '2026-02-08 10:30:00'),
    (4, 5, 18997.00, NULL, '2026-02-10 12:00:00', '2026-02-10 12:30:00'),
    (5, 6, 3499.00, NULL, '2026-02-12 14:00:00', '2026-02-12 14:20:00'),
    (6, 8, 18999.00, NULL, '2026-02-16 10:00:00', '2026-02-16 10:30:00'),
    (7, 9, 6999.00, NULL, '2026-02-18 11:00:00', '2026-02-18 11:25:00'),
    (8, 10, 52999.00, NULL, '2026-02-20 16:00:00', '2026-02-20 16:30:00'),
    (9, 11, 599.00, NULL, '2026-02-22 09:30:00', '2026-02-22 09:45:00'),
    (10, 12, 4999.00, NULL, '2026-02-24 14:00:00', '2026-02-24 14:20:00'),

    (11, 13, 7999.00, NULL, '2026-02-26 18:00:00', '2026-02-26 18:25:00'),
    (12, 15, 6999.00, NULL, '2026-03-02 15:00:00', '2026-03-02 15:25:00'),
    (13, 16, 3999.00, NULL, '2026-03-04 11:00:00', '2026-03-04 11:20:00'),
    (14, 17, 2499.00, NULL, '2026-03-06 19:00:00', '2026-03-06 19:20:00'),
    (15, 19, 1299.00, NULL, '2026-03-10 17:00:00', '2026-03-10 17:20:00'),
    (16, 20, 899.00, NULL, '2026-03-12 10:30:00', '2026-03-12 10:45:00'),
    (17, 21, 4999.00, NULL, '2026-03-14 14:00:00', '2026-03-14 14:25:00'),
    (18, 22, 8999.00, NULL, '2026-03-16 18:00:00', '2026-03-16 18:25:00'),
    (19, 23, 1999.00, NULL, '2026-03-18 12:00:00', '2026-03-18 12:20:00'),
    (20, 24, 2999.00, NULL, '2026-03-20 16:00:00', '2026-03-20 16:20:00'),

    (21, 26, 899.00, NULL, '2026-03-24 10:00:00', '2026-03-24 10:20:00'),
    (22, 27, 799.00, NULL, '2026-03-26 13:00:00', '2026-03-26 13:20:00'),
    (23, 28, 2499.00, NULL, '2026-03-28 10:00:00', '2026-03-28 10:20:00'),
    (24, 30, 31999.00, NULL, '2026-04-01 17:00:00', '2026-04-01 17:30:00'),
    (25, 31, 65000.00, NULL, '2026-04-03 11:00:00', '2026-04-03 11:30:00'),
    (26, 32, 3499.00, NULL, '2026-04-05 14:00:00', '2026-04-05 14:20:00'),
    (27, 34, 52999.00, NULL, '2026-04-09 12:00:00', '2026-04-09 12:30:00'),
    (28, 35, 6999.00, NULL, '2026-04-11 16:00:00', '2026-04-11 16:20:00'),
    (29, 36, 1299.00, NULL, '2026-04-13 10:00:00', '2026-04-13 10:20:00'),
    (30, 37, 4999.00, NULL, '2026-04-15 18:30:00', '2026-04-15 18:50:00'),

    (31, 39, 899.00, NULL, '2026-04-19 15:00:00', '2026-04-19 15:20:00'),
    (32, 40, 18999.00, NULL, '2026-04-21 17:00:00', '2026-04-21 17:30:00'),
    (33, 41, 7999.00, NULL, '2026-04-23 11:00:00', '2026-04-23 11:25:00'),
    (34, 42, 2499.00, NULL, '2026-04-25 14:00:00', '2026-04-25 14:20:00'),
    (35, 44, 8999.00, NULL, '2026-04-29 12:00:00', '2026-04-29 12:25:00'),
    (36, 45, 599.00, NULL, '2026-05-01 16:00:00', '2026-05-01 16:15:00'),
    (37, 46, 2999.00, NULL, '2026-05-03 10:30:00', '2026-05-03 10:50:00'),
    (38, 47, 3499.00, NULL, '2026-05-05 18:00:00', '2026-05-05 18:20:00'),
    (39, 49, 4999.00, NULL, '2026-05-09 15:00:00', '2026-05-09 15:20:00'),
    (40, 50, 7999.00, NULL, '2026-05-11 17:00:00', '2026-05-11 17:25:00'),

    -- Repeat orders
    (41, 1, 8999.00, NULL, '2026-05-16 11:00:00', '2026-05-16 11:20:00'),
    (42, 2, 65000.00, NULL, '2026-06-12 10:00:00', '2026-06-12 10:30:00'),
    (43, 3, 74999.00, NULL, '2026-05-18 15:00:00', '2026-05-18 15:30:00'),
    (44, 4, 3499.00, NULL, '2026-05-20 12:00:00', '2026-05-20 12:20:00'),
    (45, 5, 6999.00, NULL, '2026-05-21 16:00:00', '2026-05-21 16:20:00'),
    (46, 8, 18999.00, NULL, '2026-05-22 14:00:00', '2026-05-22 14:25:00'),
    (47, 10, 52999.00, NULL, '2026-05-24 11:00:00', '2026-05-24 11:30:00'),
    (48, 12, 4999.00, NULL, '2026-05-25 15:00:00', '2026-05-25 15:20:00'),
    (49, 15, 3999.00, NULL, '2026-05-26 10:00:00', '2026-05-26 10:20:00'),
    (50, 20, 1299.00, NULL, '2026-05-28 13:00:00', '2026-05-28 13:20:00'),

    (51, 21, 4999.00, NULL, '2026-05-30 17:00:00', '2026-05-30 17:25:00'),
    (52, 22, 8999.00, NULL, '2026-06-01 11:00:00', '2026-06-01 11:25:00'),
    (53, 23, 1999.00, NULL, '2026-06-02 14:00:00', '2026-06-02 14:20:00'),
    (54, 25, 8999.00, NULL, '2026-06-04 16:00:00', '2026-06-04 16:20:00'),
    (55, 28, 2499.00, NULL, '2026-06-06 10:00:00', '2026-06-06 10:20:00'),
    (56, 30, 31999.00, NULL, '2026-06-08 12:00:00', '2026-06-08 12:30:00'),
    (57, 31, 65000.00, NULL, '2026-06-10 15:00:00', '2026-06-10 15:30:00'),
    (58, 35, 6999.00, NULL, '2026-06-12 18:00:00', '2026-06-12 18:20:00'),
    (59, 40, 18999.00, NULL, '2026-06-14 11:00:00', '2026-06-14 11:25:00'),
    (60, 45, 599.00, NULL, '2026-06-16 13:00:00', '2026-06-16 13:15:00'),

    (61, 48, 799.00, NULL, '2026-06-18 16:00:00', '2026-06-18 16:15:00'),
    (62, 50, 7999.00, NULL, '2026-06-20 10:00:00', '2026-06-20 10:25:00'),

    -- Additional transactions
    (63, 1, 74999.00, NULL, '2026-06-22 11:00:00', '2026-06-22 11:30:00'),
    (64, 3, 8999.00, NULL, '2026-06-23 14:00:00', '2026-06-23 14:20:00'),
    (65, 5, 18999.00, NULL, '2026-06-24 16:00:00', '2026-06-24 16:25:00'),
    (66, 8, 3499.00, NULL, '2026-06-25 12:00:00', '2026-06-25 12:20:00'),
    (67, 10, 79999.00, NULL, '2026-06-26 10:00:00', '2026-06-26 10:35:00'),
    (68, 12, 1299.00, NULL, '2026-06-27 15:00:00', '2026-06-27 15:20:00'),
    (69, 15, 6999.00, NULL, '2026-06-28 11:00:00', '2026-06-28 11:20:00'),
    (70, 18, 2499.00, NULL, '2026-06-29 18:00:00', '2026-06-29 18:20:00'),
    (71, 20, 899.00, NULL, '2026-06-30 13:00:00', '2026-06-30 13:15:00'),
    (72, 23, 4999.00, NULL, '2026-07-01 16:00:00', '2026-07-01 16:20:00'),

    (73, 25, 1999.00, NULL, '2026-07-02 10:00:00', '2026-07-02 10:20:00'),
    (74, 28, 2499.00, NULL, '2026-07-03 14:00:00', '2026-07-03 14:20:00'),
    (75, 30, 31999.00, NULL, '2026-07-04 12:00:00', '2026-07-04 12:30:00'),
    (76, 31, 65000.00, NULL, '2026-07-05 15:00:00', '2026-07-05 15:30:00'),
    (77, 33, 8999.00, NULL, '2026-07-06 17:00:00', '2026-07-06 17:20:00'),
    (78, 35, 6999.00, NULL, '2026-07-07 11:00:00', '2026-07-07 11:20:00'),
    (79, 38, 799.00, NULL, '2026-07-08 13:00:00', '2026-07-08 13:15:00'),
    (80, 40, 18999.00, NULL, '2026-07-09 16:00:00', '2026-07-09 16:25:00'),
    (81, 43, 6999.00, NULL, '2026-07-10 10:00:00', '2026-07-10 10:20:00'),
    (82, 45, 599.00, NULL, '2026-07-11 14:00:00', '2026-07-11 14:15:00'),

    (83, 48, 799.00, NULL, '2026-07-12 18:00:00', '2026-07-12 18:15:00'),
    (84, 50, 7999.00, NULL, '2026-07-13 11:00:00', '2026-07-13 11:20:00'),
    (85, 2, 17998.00, NULL, '2026-07-14 13:00:00', '2026-07-14 13:25:00'),
    (86, 4, 74999.00, NULL, '2026-07-15 15:00:00', '2026-07-15 15:30:00'),
    (87, 6, 3499.00, NULL, '2026-07-16 10:00:00', '2026-07-16 10:20:00'),
    (88, 9, 6999.00, NULL, '2026-07-17 12:00:00', '2026-07-17 12:20:00'),
    (89, 11, 599.00, NULL, '2026-07-18 14:00:00', '2026-07-18 14:15:00'),
    (90, 13, 7999.00, NULL, '2026-07-19 16:00:00', '2026-07-19 16:20:00'),
    (91, 16, 3999.00, NULL, '2026-07-20 11:00:00', '2026-07-20 11:20:00'),
    (92, 17, 2499.00, NULL, '2026-07-21 13:00:00', '2026-07-21 13:20:00'),

    (93, 19, 1299.00, NULL, '2026-07-22 15:00:00', '2026-07-22 15:20:00'),
    (94, 21, 4999.00, NULL, '2026-07-23 10:00:00', '2026-07-23 10:20:00'),
    (95, 22, 8999.00, NULL, '2026-07-24 12:00:00', '2026-07-24 12:20:00'),
    (96, 24, 2999.00, NULL, '2026-07-25 14:00:00', '2026-07-25 14:20:00'),
    (97, 26, 899.00, NULL, '2026-07-26 16:00:00', '2026-07-26 16:15:00'),
    (98, 27, 799.00, NULL, '2026-07-27 11:00:00', '2026-07-27 11:15:00'),
    (99, 29, 599.00, NULL, '2026-07-28 13:00:00', '2026-07-28 13:15:00'),
    (100, 32, 3499.00, NULL, '2026-07-29 15:00:00', '2026-07-29 15:20:00'),

    (101, 34, 52999.00, NULL, '2026-07-30 10:00:00', '2026-07-30 10:30:00'),
    (102, 36, 1299.00, NULL, '2026-07-31 12:00:00', '2026-07-31 12:20:00'),
    (103, 37, 4999.00, NULL, '2026-08-01 14:00:00', '2026-08-01 14:20:00'),
    (104, 39, 899.00, NULL, '2026-08-02 16:00:00', '2026-08-02 16:15:00'),
    (105, 41, 7999.00, NULL, '2026-08-03 11:00:00', '2026-08-03 11:20:00'),
    (106, 42, 2499.00, NULL, '2026-08-04 13:00:00', '2026-08-04 13:20:00'),
    (107, 44, 8999.00, NULL, '2026-08-05 15:00:00', '2026-08-05 15:20:00'),
    (108, 46, 2999.00, NULL, '2026-08-06 10:00:00', '2026-08-06 10:20:00'),
    (109, 47, 3499.00, NULL, '2026-08-07 12:00:00', '2026-08-07 12:20:00'),
    (110, 49, 4999.00, NULL, '2026-08-08 14:00:00', '2026-08-08 14:20:00'),

    (111, 1, 3499.00, NULL, '2026-08-09 16:00:00', '2026-08-09 16:20:00'),
    (112, 5, 3999.00, NULL, '2026-08-10 11:00:00', '2026-08-10 11:20:00'),
    (113, 10, 18999.00, NULL, '2026-08-11 13:00:00', '2026-08-11 13:25:00'),
    (114, 15, 6999.00, NULL, '2026-08-12 15:00:00', '2026-08-12 15:20:00'),
    (115, 20, 1299.00, NULL, '2026-08-13 10:00:00', '2026-08-13 10:20:00'),
    (116, 25, 1999.00, NULL, '2026-08-14 12:00:00', '2026-08-14 12:20:00'),
    (117, 30, 31999.00, NULL, '2026-08-15 14:00:00', '2026-08-15 14:30:00'),
    (118, 35, 6999.00, NULL, '2026-08-16 16:00:00', '2026-08-16 16:20:00'),
    (119, 40, 18999.00, NULL, '2026-08-17 11:00:00', '2026-08-17 11:25:00'),
    (120, 45, 599.00, NULL, '2026-08-18 13:00:00', '2026-08-18 13:15:00'),

    (121, 48, 799.00, NULL, '2026-08-19 15:00:00', '2026-08-19 15:15:00'),
    (122, 50, 7999.00, NULL, '2026-08-20 10:00:00', '2026-08-20 10:20:00'),
    (123, 3, 74999.00, NULL, '2026-08-21 12:00:00', '2026-08-21 12:30:00'),
    (124, 8, 18999.00, NULL, '2026-08-22 14:00:00', '2026-08-22 14:25:00'),
    (125, 12, 4999.00, NULL, '2026-08-23 16:00:00', '2026-08-23 16:20:00'),
    (126, 18, 2499.00, NULL, '2026-08-24 11:00:00', '2026-08-24 11:20:00'),
    (127, 23, 4999.00, NULL, '2026-08-25 13:00:00', '2026-08-25 13:20:00'),
    (128, 28, 2499.00, NULL, '2026-08-26 15:00:00', '2026-08-26 15:20:00'),
    (129, 33, 8999.00, NULL, '2026-08-27 10:00:00', '2026-08-27 10:20:00'),
    (130, 38, 799.00, NULL, '2026-08-28 12:00:00', '2026-08-28 12:15:00'),

    (131, 43, 6999.00, NULL, '2026-08-28 14:00:00', '2026-08-28 14:20:00'),
    (132, 48, 799.00, NULL, '2026-08-29 10:00:00', '2026-08-29 10:15:00'),
    (133, 2, 17998.00, NULL, '2026-08-29 12:00:00', '2026-08-29 12:20:00'),
    (134, 4, 74999.00, NULL, '2026-08-29 14:00:00', '2026-08-29 14:30:00'),
    (135, 6, 3499.00, NULL, '2026-08-29 16:00:00', '2026-08-29 16:20:00'),
    (136, 9, 6999.00, NULL, '2026-08-30 10:00:00', '2026-08-30 10:20:00'),
    (137, 11, 599.00, NULL, '2026-08-30 11:00:00', '2026-08-30 11:15:00'),
    (138, 13, 7999.00, NULL, '2026-08-30 12:00:00', '2026-08-30 12:20:00'),
    (139, 16, 3999.00, NULL, '2026-08-30 13:00:00', '2026-08-30 13:20:00'),
    (140, 17, 2499.00, NULL, '2026-08-30 14:00:00', '2026-08-30 14:20:00'),

    (141, 19, 1299.00, NULL, '2026-08-30 15:00:00', '2026-08-30 15:20:00'),
    (142, 21, 4999.00, NULL, '2026-08-30 16:00:00', '2026-08-30 16:20:00'),
    (143, 22, 8999.00, NULL, '2026-08-30 17:00:00', '2026-08-30 17:20:00'),
    (144, 24, 2999.00, NULL, '2026-08-30 17:30:00', '2026-08-30 17:50:00'),
    (145, 26, 899.00, NULL, '2026-08-30 18:00:00', '2026-08-30 18:15:00'),
    (146, 27, 799.00, NULL, '2026-08-30 18:30:00', '2026-08-30 18:45:00'),
    (147, 29, 599.00, NULL, '2026-08-30 19:00:00', '2026-08-30 19:15:00'),
    (148, 32, 3499.00, NULL, '2026-08-30 19:30:00', '2026-08-30 19:50:00'),
    (149, 36, 1299.00, NULL, '2026-08-30 20:00:00', '2026-08-30 20:15:00'),
    (150, 41, 7999.00, NULL, '2026-08-30 20:30:00', '2026-08-30 20:50:00');
    
SELECT COUNT(*) AS total_orders
FROM order_details;

SELECT COUNT(*) AS invalid_orders
FROM order_details od
LEFT JOIN "user" u
    ON od.user_id = u.id
WHERE u.id IS NULL;

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'order_items'
ORDER BY ordinal_position;

INSERT INTO order_items
    (id, order_id, product_id, quantity, created_at, modified_at)

SELECT
    ROW_NUMBER() OVER (ORDER BY od.id, x.item_no) AS id,
    od.id AS order_id,
    ((od.id + x.item_no * 7 - 1) % 30) + 1 AS product_id,
    1 + ((od.id + x.item_no) % 3) AS quantity,
    od.created_at,
    od.modified_at
FROM order_details od
CROSS JOIN LATERAL
    generate_series(
        1,
        CASE
            WHEN od.id % 5 = 0 THEN 3
            WHEN od.id % 2 = 0 THEN 2
            ELSE 1
        END
    ) AS x(item_no);

SELECT COUNT(*) AS total_order_items
FROM order_items;

SELECT
    order_id,
    COUNT(*) AS different_products,
    SUM(quantity) AS total_units
FROM order_items
GROUP BY order_id
ORDER BY order_id
LIMIT 20;

SELECT
    oi.order_id,
    SUM(
        p.price
        * oi.quantity
        * (1 - COALESCE(d.discount_percent, 0) / 100)
    ) AS calculated_total,
    od.total AS stored_total
FROM order_items oi
JOIN product p
    ON oi.product_id = p.id
LEFT JOIN discount d
    ON p.discount_id = d.id
JOIN order_details od
    ON oi.order_id = od.id
GROUP BY
    oi.order_id,
    od.total
ORDER BY oi.order_id
LIMIT 20;

UPDATE order_details od
SET total = x.calculated_total
FROM (
    SELECT
        oi.order_id,
        ROUND(
            SUM(
                p.price
                * oi.quantity
                * (1 - COALESCE(d.discount_percent, 0) / 100)
            ),
            2
        ) AS calculated_total
    FROM order_items oi
    JOIN product p
        ON oi.product_id = p.id
    LEFT JOIN discount d
        ON p.discount_id = d.id
    GROUP BY oi.order_id
) x
WHERE od.id = x.order_id;

SELECT
    COUNT(*) AS mismatched_orders
FROM order_details od
JOIN (
    SELECT
        oi.order_id,
        ROUND(
            SUM(
                p.price
                * oi.quantity
                * (1 - COALESCE(d.discount_percent, 0) / 100)
            ),
            2
        ) AS calculated_total
    FROM order_items oi
    JOIN product p
        ON oi.product_id = p.id
    LEFT JOIN discount d
        ON p.discount_id = d.id
    GROUP BY oi.order_id
) x
    ON od.id = x.order_id
WHERE od.total <> x.calculated_total;

SELECT
    column_name,
    data_type
FROM information_schema.columns
WHERE table_name = 'payment_details'
ORDER BY ordinal_position;

INSERT INTO payment_details
    (id, order_id, amount, provider, status, created_at, modified_at)

SELECT
    id,
    id AS order_id,
    total AS amount,

    CASE
        WHEN id % 4 = 1 THEN 'HDFC Bank'
        WHEN id % 4 = 2 THEN 'ICICI Bank'
        WHEN id % 4 = 3 THEN 'Axis Bank'
        ELSE 'SBI'
    END AS provider,

    CASE
        WHEN id % 20 = 0 THEN 'Failed'
        WHEN id % 10 = 0 THEN 'Pending'
        ELSE 'Completed'
    END AS status,

    created_at + INTERVAL '5 minutes',
    created_at + INTERVAL '5 minutes'

FROM order_details;

SELECT COUNT(*) AS invalid_payments
FROM payment_details pd
LEFT JOIN order_details od
    ON pd.order_id = od.id
WHERE od.id IS NULL;

SELECT COUNT(*) AS amount_mismatches
FROM payment_details pd
JOIN order_details od
    ON pd.order_id = od.id
WHERE pd.amount <> od.total;

UPDATE order_details od
SET payment_id = pd.id
FROM payment_details pd
WHERE od.id = pd.order_id;

SELECT COUNT(*) AS orders_without_payment
FROM order_details
WHERE payment_id IS NULL;

SELECT
    od.id AS order_id,
    od.total AS order_total,
    pd.amount AS payment_amount,
    pd.provider,
    pd.status
FROM order_details od
JOIN payment_details pd
    ON od.payment_id = pd.id
ORDER BY od.id
LIMIT 20;

ALTER TABLE order_details
ADD COLUMN session_id INT;

ALTER TABLE order_details
ADD CONSTRAINT fk_order_session
FOREIGN KEY (session_id)
REFERENCES shopping_session(id);

DELETE FROM payment_details;

DELETE FROM order_items;

DELETE FROM order_details;

SELECT
    ss.id AS session_id,
    ss.user_id,
    COUNT(ci.id) AS cart_lines,
    SUM(ci.quantity) AS total_units
FROM shopping_session ss
LEFT JOIN cart_item ci
    ON ss.id = ci.session_id
GROUP BY
    ss.id,
    ss.user_id
ORDER BY ss.id;

SELECT
    ss.id AS session_id,
    ss.user_id,
    COUNT(ci.id) AS cart_lines
FROM shopping_session ss
JOIN cart_item ci
    ON ss.id = ci.session_id
GROUP BY
    ss.id,
    ss.user_id
ORDER BY ss.id;

INSERT INTO order_details
    (id, user_id, session_id, total, payment_id, created_at, modified_at)
SELECT
    ROW_NUMBER() OVER (ORDER BY ss.id) AS id,
    ss.user_id,
    ss.id AS session_id,
    0.00 AS total,
    NULL AS payment_id,
    ss.created_at + INTERVAL '10 minutes',
    ss.modified_at + INTERVAL '10 minutes'
FROM shopping_session ss
ORDER BY ss.id
LIMIT 45;

SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT session_id) AS sessions_converted
FROM order_details;

SELECT COUNT(*) AS abandoned_sessions
FROM shopping_session ss
LEFT JOIN order_details od
    ON ss.id = od.session_id
WHERE od.id IS NULL;

INSERT INTO order_items
    (id, order_id, product_id, quantity, created_at, modified_at)
SELECT
    ROW_NUMBER() OVER (ORDER BY od.id, ci.id) AS id,
    od.id AS order_id,
    ci.product_id,
    ci.quantity,
    od.created_at,
    od.modified_at
FROM order_details od
JOIN cart_item ci
    ON od.session_id = ci.session_id;

SELECT
    COUNT(*) AS total_order_items
FROM order_items;

SELECT
    od.id AS order_id,
    od.session_id,
    COUNT(oi.id) AS order_item_lines,
    SUM(oi.quantity) AS total_units
FROM order_details od
JOIN order_items oi
    ON od.id = oi.order_id
GROUP BY
    od.id,
    od.session_id
ORDER BY od.id;

SELECT COUNT(*) AS mismatched_items
FROM order_details od
JOIN cart_item ci
    ON od.session_id = ci.session_id
LEFT JOIN order_items oi
    ON oi.order_id = od.id
   AND oi.product_id = ci.product_id
WHERE oi.id IS NULL
   OR oi.quantity <> ci.quantity;

SELECT
    session_id,
    product_id,
    COUNT(*) AS cart_rows,
    SUM(quantity) AS cart_quantity
FROM cart_item
GROUP BY session_id, product_id
HAVING COUNT(*) > 1
ORDER BY session_id, product_id;

DELETE FROM order_items;

INSERT INTO order_items
    (id, order_id, product_id, quantity, created_at, modified_at)
SELECT
    ROW_NUMBER() OVER (ORDER BY od.id, ci.product_id) AS id,
    od.id AS order_id,
    ci.product_id,
    SUM(ci.quantity) AS quantity,
    od.created_at,
    od.modified_at
FROM order_details od
JOIN cart_item ci
    ON od.session_id = ci.session_id
GROUP BY
    od.id,
    ci.product_id,
    od.created_at,
    od.modified_at;

SELECT
    order_id,
    product_id,
    COUNT(*) AS rows_per_product
FROM order_items
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;

SELECT COUNT(*) AS mismatched_items
FROM (
    SELECT
        od.id AS order_id,
        ci.product_id,
        SUM(ci.quantity) AS cart_quantity,
        oi.quantity AS order_quantity
    FROM order_details od
    JOIN cart_item ci
        ON od.session_id = ci.session_id
    JOIN order_items oi
        ON oi.order_id = od.id
       AND oi.product_id = ci.product_id
    GROUP BY
        od.id,
        ci.product_id,
        oi.quantity
) x
WHERE cart_quantity <> order_quantity;

SELECT
    COUNT(*) AS converted_sessions
FROM shopping_session ss
JOIN order_details od
    ON ss.id = od.session_id;

SELECT
    COUNT(*) AS abandoned_sessions
FROM shopping_session ss
LEFT JOIN order_details od
    ON ss.id = od.session_id
WHERE od.id IS NULL;

UPDATE order_details od
SET total = x.calculated_total
FROM (
    SELECT
        oi.order_id,
        ROUND(
            SUM(
                p.price
                * oi.quantity
                * (1 - COALESCE(d.discount_percent, 0) / 100)
            ),
            2
        ) AS calculated_total
    FROM order_items oi
    JOIN product p
        ON oi.product_id = p.id
    LEFT JOIN discount d
        ON p.discount_id = d.id
    GROUP BY oi.order_id
) x
WHERE od.id = x.order_id;

SELECT
    COUNT(*) AS zero_total_orders
FROM order_details
WHERE total = 0;

SELECT
    id AS order_id,
    user_id,
    session_id,
    total
FROM order_details
ORDER BY id
LIMIT 15;

SELECT COUNT(*) AS mismatched_orders
FROM order_details od
JOIN (
    SELECT
        oi.order_id,
        ROUND(
            SUM(
                p.price
                * oi.quantity
                * (1 - COALESCE(d.discount_percent, 0) / 100)
            ),
            2
        ) AS calculated_total
    FROM order_items oi
    JOIN product p
        ON oi.product_id = p.id
    LEFT JOIN discount d
        ON p.discount_id = d.id
    GROUP BY oi.order_id
) x
    ON od.id = x.order_id
WHERE od.total <> x.calculated_total;

INSERT INTO payment_details
    (id, order_id, amount, provider, status, created_at, modified_at)
SELECT
    id,
    id AS order_id,
    total AS amount,

    CASE
        WHEN id % 4 = 1 THEN 'HDFC Bank'
        WHEN id % 4 = 2 THEN 'ICICI Bank'
        WHEN id % 4 = 3 THEN 'Axis Bank'
        ELSE 'SBI'
    END AS provider,

    CASE
        WHEN id % 10 = 0 THEN 'Pending'
        WHEN id % 7 = 0 THEN 'Failed'
        ELSE 'Completed'
    END AS status,

    created_at + INTERVAL '5 minutes',
    created_at + INTERVAL '5 minutes'

FROM order_details;

SELECT COUNT(*) AS invalid_payments
FROM payment_details pd
LEFT JOIN order_details od
    ON pd.order_id = od.id
WHERE od.id IS NULL;

SELECT COUNT(*) AS amount_mismatches
FROM payment_details pd
JOIN order_details od
    ON pd.order_id = od.id
WHERE pd.amount <> od.total;

UPDATE order_details od
SET payment_id = pd.id
FROM payment_details pd
WHERE od.id = pd.order_id;

SELECT COUNT(*) AS orders_without_payment
FROM order_details
WHERE payment_id IS NULL;

SELECT
    table_name,
    column_name,
    data_type,
    is_nullable
FROM information_schema.columns
WHERE table_name IN (
    'shopping_session',
    'cart_item',
    'order_details',
    'order_items',
    'payment_details'
)
ORDER BY
    table_name,
    ordinal_position;

-- ============================================================
-- ADD REPEAT-CUSTOMER TRANSACTIONS
-- Creates 20 new sessions → carts → orders → order items → payments
-- ============================================================

BEGIN;


-- ============================================================
-- 1. CREATE 20 NEW SHOPPING SESSIONS
--    These belong to customers who already have orders.
-- ============================================================

CREATE TEMP TABLE new_sessions AS
WITH repeat_customers AS (
    SELECT
        user_id,
        ROW_NUMBER() OVER (ORDER BY user_id) AS rn
    FROM (
        SELECT DISTINCT user_id
        FROM order_details
    ) x
    ORDER BY user_id
    LIMIT 20
),
new_session_ids AS (
    SELECT
        user_id,
        rn,
        (SELECT COALESCE(MAX(id), 0) FROM shopping_session)
            + rn AS session_id
    FROM repeat_customers
)
SELECT
    session_id,
    user_id,
    rn,
    (
        SELECT MAX(created_at)
        FROM order_details
    ) + (rn * INTERVAL '2 days') AS session_date
FROM new_session_ids;


INSERT INTO shopping_session
    (id, user_id, total, created_at, modified_at)
SELECT
    session_id,
    user_id,
    0,
    session_date,
    session_date
FROM new_sessions;


-- ============================================================
-- 2. CREATE CART ITEMS FOR THE NEW SESSIONS
--    Each new session gets 2 products.
-- ============================================================

CREATE TEMP TABLE new_cart_items AS
SELECT
    ns.session_id,
    ns.user_id,
    ns.session_date,
    p.id AS product_id,
    CASE
        WHEN p.id % 3 = 0 THEN 2
        ELSE 1
    END AS quantity
FROM new_sessions ns
JOIN product p
    ON p.id IN (
        ((ns.rn - 1) % 30) + 1,
        ((ns.rn + 9) % 30) + 1
    );


INSERT INTO cart_item
    (id, session_id, product_id, quantity, created_at)
SELECT
    (SELECT COALESCE(MAX(id), 0) FROM cart_item)
        + ROW_NUMBER() OVER (ORDER BY session_id, product_id),
    session_id,
    product_id,
    quantity,
    session_date
FROM new_cart_items;


-- ============================================================
-- 3. CALCULATE THE SHOPPING SESSION TOTAL
-- ============================================================

UPDATE shopping_session ss
SET
    total = x.session_total,
    modified_at = ss.created_at
FROM (
    SELECT
        nci.session_id,
        ROUND(
            SUM(
                nci.quantity
                * p.price
                * (
                    1
                    - COALESCE(
                        CASE
                            WHEN d.active = TRUE
                            THEN d.discount_percent
                            ELSE 0
                        END,
                        0
                    ) / 100
                )
            ),
            2
        ) AS session_total
    FROM new_cart_items nci
    JOIN product p
        ON nci.product_id = p.id
    LEFT JOIN discount d
        ON p.discount_id = d.id
    GROUP BY nci.session_id
) x
WHERE ss.id = x.session_id;


-- ============================================================
-- 4. CREATE ORDERS FROM THE NEW SHOPPING SESSIONS
-- ============================================================

CREATE TEMP TABLE new_orders AS
SELECT
    (SELECT COALESCE(MAX(id), 0) FROM order_details)
        + ROW_NUMBER() OVER (ORDER BY ns.session_id) AS order_id,
    ns.session_id,
    ns.user_id,
    ns.session_date
FROM new_sessions ns;


INSERT INTO order_details
    (id, user_id, total, payment_id, created_at, modified_at, session_id)
SELECT
    no.order_id,
    no.user_id,
    ss.total,
    NULL,
    no.session_date + INTERVAL '30 minutes',
    no.session_date + INTERVAL '30 minutes',
    no.session_id
FROM new_orders no
JOIN shopping_session ss
    ON no.session_id = ss.id;


-- ============================================================
-- 5. CREATE ORDER ITEMS FROM THE CART
--    One row per product per order.
-- ============================================================

INSERT INTO order_items
    (id, order_id, product_id, quantity, created_at, modified_at)
SELECT
    (SELECT COALESCE(MAX(id), 0) FROM order_items)
        + ROW_NUMBER() OVER (ORDER BY no.order_id, nci.product_id),
    no.order_id,
    nci.product_id,
    SUM(nci.quantity),
    no.session_date + INTERVAL '30 minutes',
    no.session_date + INTERVAL '30 minutes'
FROM new_orders no
JOIN new_cart_items nci
    ON no.session_id = nci.session_id
GROUP BY
    no.order_id,
    nci.product_id,
    no.session_date;


-- ============================================================
-- 6. CREATE ONE PAYMENT FOR EACH NEW ORDER
-- ============================================================

CREATE TEMP TABLE new_payments AS
SELECT
    no.order_id,
    od.total AS amount,
    CASE
        WHEN no.order_id % 4 = 1 THEN 'HDFC Bank'
        WHEN no.order_id % 4 = 2 THEN 'ICICI Bank'
        WHEN no.order_id % 4 = 3 THEN 'Axis Bank'
        ELSE 'SBI'
    END AS provider,
    'Completed' AS status,
    od.created_at + INTERVAL '5 minutes' AS payment_date
FROM new_orders no
JOIN order_details od
    ON no.order_id = od.id;


INSERT INTO payment_details
    (id, order_id, amount, provider, status, created_at, modified_at)
SELECT
    (SELECT COALESCE(MAX(id), 0) FROM payment_details)
        + ROW_NUMBER() OVER (ORDER BY order_id),
    order_id,
    amount,
    provider,
    status,
    payment_date,
    payment_date
FROM new_payments;


-- ============================================================
-- 7. LINK EACH ORDER TO ITS PAYMENT
-- ============================================================

UPDATE order_details od
SET payment_id = pd.id
FROM payment_details pd
WHERE od.id = pd.order_id
  AND od.session_id IN (
      SELECT session_id
      FROM new_sessions
  );


-- ============================================================
-- 8. VERIFY THE NEW ORDERS BEFORE COMMITTING
-- ============================================================

SELECT
    COUNT(*) AS new_orders
FROM new_orders;


SELECT
    COUNT(*) AS new_order_items
FROM order_items oi
JOIN new_orders no
    ON oi.order_id = no.order_id;


SELECT
    COUNT(*) AS new_payments
FROM payment_details pd
JOIN new_orders no
    ON pd.order_id = no.order_id;


-- ============================================================
-- 9. COMMIT
-- ============================================================

COMMIT;


-- ============================================================
-- END
-- ============================================================