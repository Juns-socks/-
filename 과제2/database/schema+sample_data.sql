use store;
DROP TABLE IF EXISTS Product_Vendor;
DROP TABLE IF EXISTS Vendors;
DROP TABLE IF EXISTS Sales_Transactions;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Stores;
DROP TABLE IF EXISTS Customers;

CREATE TABLE stores (
    store_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    address VARCHAR(50) NOT NULL,
    open_time TIME NOT NULL,
    close_time TIME NOT NULL,
    ownership_type VARCHAR(50) NOT NULL 
		check (ownership_type in ('Franchise','Corporate','Independent'))
);

CREATE TABLE products (
    product_upc VARCHAR(50) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    package_type VARCHAR(50) NOT NULL
		check (package_type in ('Box','Bottle','Pack')),
    size VARCHAR(50) NOT NULL
		check (size in ('Large','Medium','Small')),
    price DECIMAL(10, 2) NOT NULL check(price>0)
);

CREATE TABLE inventory (
    store_id INT,
    product_upc VARCHAR(50),
    inventory_level INT NOT NULL check(inventory_level >=0),
    reorder_thresholds INT NOT NULL check(reorder_thresholds>0),
    reorder_quantitys INT NOT NULL check(reorder_quantitys>0),
    recent_order_history DATE NOT NULL,
    PRIMARY KEY (store_id, product_upc),
    FOREIGN KEY (store_id) REFERENCES Stores(store_id) ON DELETE CASCADE,
    FOREIGN KEY (product_upc) REFERENCES Products(product_upc) ON DELETE CASCADE
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone_num VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    loyality VARCHAR(50) NOT NULL
		check(loyality in ('VIP','normal'))
);

CREATE TABLE sales_Transactions (
    sale_ID INT PRIMARY KEY,
    store_id INT,
    product_upc VARCHAR(50),
    customer_id INT,
    payment_method VARCHAR(50) NOT NULL
		check(payment_method in ('Credit Card','Cash')),
    total_amount INT NOT NULL check(total_amount>0),
    buy_date DATE NOT NULL,
    FOREIGN KEY (store_id) REFERENCES Stores(store_id) ON DELETE CASCADE,
    FOREIGN KEY (product_upc) REFERENCES Products(product_upc) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

CREATE TABLE vendors (
    vendor_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    phone_num VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL
);

CREATE TABLE product_Vendor (
    product_upc VARCHAR(50),
    vendor_id INT,
    product_num INT NOT NULL check(product_num>0),
    PRIMARY KEY (product_upc, vendor_id),
    FOREIGN KEY (product_upc) REFERENCES Products(product_upc) ON DELETE CASCADE,
    FOREIGN KEY (vendor_id) REFERENCES Vendors(vendor_id) ON DELETE CASCADE
);

INSERT INTO stores (store_id, name, address, open_time, close_time, ownership_type) VALUES
(1, 'CU', 'Sangdo', '09:00', '21:00', 'Franchise'),
(2, 'GS25', 'Mapo', '10:00', '22:00', 'Corporate'),
(3, '7eleven', 'Songdo', '08:00', '20:00', 'Franchise'),
(4, 'emart24', 'Yongsan', '09:30', '21:30', 'Independent'),
(5, 'wamart', 'Gangnam', '07:00', '23:00', 'Franchise'),
(6, 'hanaro', 'Incheon', '10:00', '20:00', 'Corporate'),
(7, 'good25', 'Borame', '11:00', '19:00', 'Corporate'),
(8, 'snowmart', 'Mokdong', '08:30', '21:00', 'Franchise'),
(9, 'bongbong', 'Sogang', '09:00', '22:00', 'Independent'),
(10, 'sunnymart', 'Seoul', '07:30', '20:30', 'Franchise');

INSERT INTO products (product_upc, name, brand, package_type, size, price) VALUES
('1001','Choco_pie' ,'Orion', 'Box', 'Medium', 12.99),
('1002','Coca-cola' , 'Coca-cola', 'Bottle', 'Small', 5.49),
('1003','Shin_Ramyun' , 'Nongshim', 'Pack', 'Large', 19.99),
('1004','kimbab' , 'bbq', 'Box', 'Large', 15.99),
('1005','Pokari' , 'Donga', 'Pack', 'Small', 3.99),
('1006','lettuce' , 'Farm', 'Pack', 'Medium', 7.99),
('1007','suncream' , 'docterg', 'Pack', 'Large', 8.49),
('1008','notebook' , 'Samsung', 'Box', 'Large', 300.99),
('1009','gum' , 'Nongshim', 'Bottle', 'Medium', 11.49),
('1010','coffee' , 'starbucks', 'Bottle', 'Large', 6.99);


INSERT INTO inventory (store_id, product_upc, inventory_level, reorder_thresholds, reorder_quantitys, recent_order_history) VALUES
(1, '1001', 50, 20, 30, '2025-05-20'),
(1, '1002', 80, 30, 50, '2025-05-15'),
(1, '1003', 10, 5, 20, '2025-05-22'),
(2, '1003', 10, 5, 20, '2025-05-22'),
(2, '1004', 25, 10, 15, '2025-05-18'),
(3, '1001', 10, 20, 40, '2025-05-13'),
(3, '1002', 20, 30, 40, '2025-05-12'),
(3, '1005', 100, 50, 50, '2025-05-10'),
(3, '1006', 15, 5, 10, '2025-05-25'),
(4, '1007', 30, 10, 20, '2025-05-28'),
(5, '1009', 70, 30, 40, '2025-05-21'),
(6, '1002', 20, 25, 50, '2025-05-19'),
(6, '1003', 40, 15, 25, '2025-05-22'),
(6, '1005', 10, 15, 30, '2025-05-27'),
(6, '1007', 40, 15, 25, '2025-05-13'),
(6, '1008', 10, 5, 10, '2025-05-28'),
(7, '1010', 20, 8, 12, '2025-05-26'),
(7, '1001', 15, 5, 10, '2025-05-28'),
(7, '1003', 25, 15, 30, '2025-05-28'),
(8, '1005', 10, 20, 40, '2025-05-28'),
(8, '1006', 20, 10, 20, '2025-05-28'),
(9, '1007', 10, 5, 10, '2025-05-28'),
(10, '1009', 20, 10, 20, '2025-05-28'),
(10, '1001', 15, 10, 20, '2025-05-28'),
(10, '1004', 25, 10, 20, '2025-05-28'),
(10, '1010', 20, 8, 12, '2025-05-26');



INSERT INTO customers (customer_id, name, phone_num, email, loyality) VALUES
(1, 'John', '010-456-4321', 'john@naver.com', 'VIP'),
(2, 'Jane', '010-567-4321', 'jane@naver.com', 'VIP'),
(3, 'Alice', '010-678-4321', 'alice@naver.com', 'VIP'),
(4, 'Bob', '010-789-4321', 'bob@naver.com', 'VIP'),
(5, 'Carol', '010-890-4321', 'carol@naver.com', 'VIP'),
(6, 'Dave', '010-901-4321', 'dave@naver.com', 'normal'),
(7, 'Emma', '010-012-4321', 'emma@naver.com', 'normal'),
(8, 'Frank', '010-123-4321', 'frank@naver.com', 'normal'),
(9, 'Grace', '010-234-4321', 'grace@naver.com', 'normal'),
(10, 'Harry', '010-345-4321', 'harry@naver.com', 'normal');

INSERT INTO sales_Transactions (sale_ID, store_id, product_upc, customer_id, payment_method, total_amount,buy_date) VALUES
(1, 1, '1001', 1, 'Credit Card', 3,"2025-05-01"),
(2, 1, '1002', 2, 'Cash', 2,"2025-05-03"),
(3, 1, '1003', 3, 'Credit Card', 4,"2025-05-01"),
(4, 2, '1003', 4, 'Cash', 2,"2025-05-04"),
(5, 2, '1004', 5, 'Credit Card', 3,"2025-05-12"),
(7, 3, '1001', 7, 'Credit Card', 4,"2025-05-01"),
(8, 3, '1002', 8, 'Cash', 3,"2025-05-05"),
(9, 3, '1005', 9, 'Credit Card', 1,"2025-05-23"),
(10, 4, '1007', 1, 'Credit Card', 4,"2025-05-22"),
(11, 5, '1009', 2, 'Cash', 1,"2025-05-12"),
(12, 6, '1002', 3, 'Cash', 3,"2025-05-15"),
(13, 6, '1003', 4, 'Credit Card', 4,"2025-05-19"),
(14, 6, '1005', 5, 'Credit Card', 3,"2025-05-29"),
(15, 6, '1007', 6, 'Cash', 2,"2025-05-27"),
(16, 6, '1008', 7, 'Credit Card', 4,"2025-05-23"),
(17, 7, '1010', 8, 'Cash', 3,"2025-05-01"),
(18, 7, '1001', 9, 'Credit Card', 1,"2025-05-05"),
(19, 7, '1003', 1, 'Cash', 2,"2025-05-01"),
(20, 8, '1005', 2, 'Cash', 3,"2025-05-16"),
(21, 8, '1006', 3, 'Credit Card', 2,"2025-05-08"),
(22, 9, '1007', 4, 'Credit Card', 4,"2025-05-19"),
(23, 10, '1009', 5, 'Cash', 1,"2025-05-11"),
(24, 10, '1010', 3, 'Credit Card', 2,"2025-05-14"),
(25, 6, '1007', 2, 'Cash', 4,"2025-05-13"),
(26, 6, '1007', 5, 'Cash', 1,"2025-05-15"),
(27, 10, '1001', 3, 'Credit Card', 1,"2025-05-14"),
(28, 10, '1004', 3, 'Credit Card', 2,"2025-05-14"),
(29, 10, '1009', 3, 'Credit Card', 3,"2025-05-14"),
(30, 6, '1007', 3, 'Cash', 2,"2025-05-17");

INSERT INTO vendors (vendor_id, name, phone_num, email) VALUES
(1, 'samsung', '010-456-1234', 'samsung@naver.com'),
(2, 'hyndai', '010-567-1234', 'hyndai@naver.com'),
(3, 'kia', '010-678-1234', 'kia@naver.com'),
(4, 'doosan', '010-789-1234', 'doosan@naver.com'),
(5, 'kakao', '010-890-1234', 'kakao@naver.com'),
(6, 'shinhan', '010-901-1234', 'shinhan@naver.com'),
(7, 'naver', '010-012-1234', 'naver@naver.com'),
(8, 'kb_bank', '010-123-1234', 'kb_bank@naver.com'),
(9, 'lg', '010-234-1234', 'lg@naver.com'),
(10, 'microsoft', '010-345-1234', 'mircrosoft@naver.com');

INSERT INTO product_Vendor (product_upc, vendor_id, product_num) VALUES
('1001', 1, 150),
('1001', 2, 50),
('1002', 3, 100),
('1002', 4, 250),
('1003', 5, 200),
('1003', 6, 150),
('1004', 7, 50),
('1005', 8, 100),
('1005', 9, 150),
('1006', 6, 200),
('1007', 10, 250),
('1008', 1, 50),
('1009', 3, 150),
('1010', 4, 100),
('1010', 5, 250);

