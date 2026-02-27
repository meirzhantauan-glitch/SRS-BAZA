-- 1. РӨЛДЕР МЕН ПАЙДАЛАНУШЫЛАРДЫ ҚҰРУ
-- Жаңа рөлдер құру
CREATE ROLE admin_role;
CREATE ROLE customer_role;

-- Пайдаланушыларды (логин/пароль) құру
CREATE USER shop_admin WITH PASSWORD 'admin123';
CREATE USER shop_user WITH PASSWORD 'user123';

-- Пайдаланушыларға рөлдерді бекіту
GRANT admin_role TO shop_admin;
GRANT customer_role TO shop_user;

-- Құқықтар (privileges) беру
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_role;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO customer_role;

-- 2. КЕСТЕЛЕРДІ ҚҰРУ ЖӘНЕ ШЕКТЕУЛЕР (Constraints)
CREATE TABLE Categories (
  category_id SERIAL PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Users (
  user_id SERIAL PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  registration_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Products (
  product_id SERIAL PRIMARY KEY,
  name VARCHAR(200) NOT NULL,
  price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
  stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
  category_id INT NOT NULL,
  CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES Categories (category_id)
);

CREATE TABLE Orders (
  order_id SERIAL PRIMARY KEY,
  user_id INT NOT NULL,
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
  status VARCHAR(50) DEFAULT 'Pending',
  CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES Users (user_id)
);

CREATE TABLE Order_Items (
  order_item_id SERIAL PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL CHECK (quantity > 0),
  price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
  CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES Orders (order_id),
  CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES Products (product_id)
);

-- 3. ИНДЕКСТЕРДІ ҚОСУ (Өнімділікті арттыру үшін)
CREATE INDEX idx_products_category ON Products(category_id);
CREATE INDEX idx_orders_user ON Orders(user_id);

-- 4. ТЕСТІЛІК ДЕРЕКТЕРДІ ЕНГІЗУ (INSERT)
INSERT INTO Categories (category_name) VALUES 
('Смартфондар'), 
('Ноутбуктер');

INSERT INTO Users (name, email, password_hash) VALUES 
('Алихан Смаилов', 'alikhan@mail.com', 'hash1'), 
('Айгерім Мақсатқызы', 'aika@mail.com', 'hash2');

INSERT INTO Products (name, price, stock_quantity, category_id) VALUES 
('iPhone 15 Pro', 600000, 15, 1), 
('Samsung Galaxy S24', 500000, 20, 1),
('MacBook Air M2', 750000, 10, 2);

INSERT INTO Orders (user_id, total_amount, status) VALUES 
(1, 600000, 'Delivered'), 
(2, 1250000, 'Processing');

INSERT INTO Order_Items (order_id, product_id, quantity, price) VALUES 
(1, 1, 1, 600000), 
(2, 2, 1, 500000),
(2, 3, 1, 750000);

-- 5. ТЕСТІЛІК SQL СҰРАНЫСТАРЫ (SELECT)

-- 5.1. JOIN: Клиенттердің қандай тауарлар сатып алғанын көру
SELECT u.name AS Client, o.order_date, p.name AS Product, oi.quantity
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
JOIN Order_Items oi ON o.order_id = oi.order_id
JOIN Products p ON oi.product_id = p.product_id;

-- 5.2. GROUP BY + HAVING: Жалпы сомасы 500 000-нан асатын үлкен тапсырыстар
SELECT u.name, COUNT(o.order_id) AS total_orders, SUM(o.total_amount) AS total_spent
FROM Users u
JOIN Orders o ON u.user_id = o.user_id
GROUP BY u.name
HAVING SUM(o.total_amount) > 500000;

-- 5.3. WHERE фильтрациясы: Смартфондар санатындағы қымбат тауарлар
SELECT p.name, p.price, c.category_name
FROM Products p
JOIN Categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Смартфондар' AND p.price > 400000;

-- 5.4. EXPLAIN ANALYZE: Индекстің жұмысын тексеру
EXPLAIN ANALYZE SELECT * FROM Products WHERE category_id = 1;
