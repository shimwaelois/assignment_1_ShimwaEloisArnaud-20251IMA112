-- Sunrise Supermarket | Oracle SQL
-- Schema + sample data

CREATE TABLE customers (
  customer_id   NUMBER PRIMARY KEY,
  customer_name VARCHAR2(100),
  email         VARCHAR2(100),
  city          VARCHAR2(50)
);

CREATE TABLE products (
  product_id   NUMBER PRIMARY KEY,
  product_name VARCHAR2(100),
  category     VARCHAR2(50),
  price        NUMBER(10,2)
);

CREATE TABLE orders (
  order_id    NUMBER PRIMARY KEY,
  customer_id NUMBER REFERENCES customers(customer_id),
  order_date  DATE
);

CREATE TABLE order_items (
  order_item_id NUMBER PRIMARY KEY,
  order_id      NUMBER REFERENCES orders(order_id),
  product_id    NUMBER REFERENCES products(product_id),
  quantity      NUMBER
);

-- Customers (6, one has never ordered)
INSERT INTO customers VALUES (1, 'Alice Uwase',     'alice@mail.com',   'Kigali');
INSERT INTO customers VALUES (2, 'Brian Mugisha',   'brian@mail.com',   'Huye');
INSERT INTO customers VALUES (3, 'Chantal Ingabire','chantal@mail.com', 'Musanze');
INSERT INTO customers VALUES (4, 'David Habimana',  'david@mail.com',   'Kigali');
INSERT INTO customers VALUES (5, 'Esther Mukamana', 'esther@mail.com',  'Rubavu');
INSERT INTO customers VALUES (6, 'Frank Niyonzima', 'frank@mail.com',   'Kigali');

-- Products (8, 4 categories)
INSERT INTO products VALUES (1, 'Rice 5kg',            'Grocery',   6500);
INSERT INTO products VALUES (2, 'Cooking Oil 3L',      'Grocery',   9000);
INSERT INTO products VALUES (3, 'Milk 1L',             'Dairy',     1200);
INSERT INTO products VALUES (4, 'Cheese 500g',         'Dairy',     4500);
INSERT INTO products VALUES (5, 'Orange Juice 1L',     'Beverages', 2500);
INSERT INTO products VALUES (6, 'Bottled Water 6-pack','Beverages', 3000);
INSERT INTO products VALUES (7, 'Laundry Detergent',   'Household', 5500);
INSERT INTO products VALUES (8, 'Dish Soap',           'Household', 2000);

-- Orders (15)
INSERT INTO orders VALUES (1,  1, DATE '2026-01-05');
INSERT INTO orders VALUES (2,  2, DATE '2026-01-08');
INSERT INTO orders VALUES (3,  1, DATE '2026-01-20');
INSERT INTO orders VALUES (4,  3, DATE '2026-02-02');
INSERT INTO orders VALUES (5,  4, DATE '2026-02-10');
INSERT INTO orders VALUES (6,  2, DATE '2026-02-15');
INSERT INTO orders VALUES (7,  1, DATE '2026-02-25');
INSERT INTO orders VALUES (8,  5, DATE '2026-03-03');
INSERT INTO orders VALUES (9,  3, DATE '2026-03-12');
INSERT INTO orders VALUES (10, 4, DATE '2026-03-18');
INSERT INTO orders VALUES (11, 1, DATE '2026-03-30');
INSERT INTO orders VALUES (12, 2, DATE '2026-04-05');
INSERT INTO orders VALUES (13, 5, DATE '2026-04-14');
INSERT INTO orders VALUES (14, 3, DATE '2026-04-22');
INSERT INTO orders VALUES (15, 4, DATE '2026-05-06');

-- Order items (25)
INSERT INTO order_items VALUES (1,  1, 2, 2);
INSERT INTO order_items VALUES (2,  1, 3, 4);
INSERT INTO order_items VALUES (3,  2, 1, 1);
INSERT INTO order_items VALUES (4,  2, 5, 3);
INSERT INTO order_items VALUES (5,  3, 4, 1);
INSERT INTO order_items VALUES (6,  3, 6, 2);
INSERT INTO order_items VALUES (7,  4, 7, 1);
INSERT INTO order_items VALUES (8,  4, 8, 2);
INSERT INTO order_items VALUES (9,  5, 1, 1);
INSERT INTO order_items VALUES (10, 5, 3, 6);
INSERT INTO order_items VALUES (11, 6, 2, 2);
INSERT INTO order_items VALUES (12, 6, 4, 1);
INSERT INTO order_items VALUES (13, 7, 5, 4);
INSERT INTO order_items VALUES (14, 7, 6, 1);
INSERT INTO order_items VALUES (15, 8, 1, 2);
INSERT INTO order_items VALUES (16, 8, 7, 1);
INSERT INTO order_items VALUES (17, 9, 3, 3);
INSERT INTO order_items VALUES (18, 9, 8, 1);
INSERT INTO order_items VALUES (19, 10, 2, 1);
INSERT INTO order_items VALUES (20, 10, 5, 2);
INSERT INTO order_items VALUES (21, 11, 7, 2);
INSERT INTO order_items VALUES (22, 12, 1, 1);
INSERT INTO order_items VALUES (23, 13, 4, 2);
INSERT INTO order_items VALUES (24, 14, 6, 3);
INSERT INTO order_items VALUES (25, 15, 2, 1);

COMMIT;
