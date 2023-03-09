/*
--This index can be helpful when searching for a specific shipper by name.
CREATE INDEX idx_shippers_shipperName ON shippers (ShipperName);
--This index can be helpful when joining the orders table with other tables based on the OrderID.
CREATE INDEX idx_orders_orderID ON orders (OrderID);
--This index can be helpful when joining the products table with other tables based on the CategoryID.
CREATE INDEX idx_products_CategoryID ON products (CategoryID);

--These indices can be helpful when joining the order_details table with other tables based on the OrderID, ProductID, and CustomerID.
CREATE INDEX idx_order_details_OrderID ON order_details (OrderID);
CREATE INDEX idx_order_details_ProductID ON order_details (ProductID);
CREATE INDEX idx_order_details_CustomerID ON order_details (CustomerID);

--This index can be helpful when searching for a specific category by name.
CREATE INDEX idx_categories_CategoryName ON categories (CategoryName);
*/

CREATE TABLE shippers (
  ShipperID integer PRIMARY KEY AUTOINCREMENT,
  ShipperName varchar(30) NOT NULL,
  ShipperEmail varchar(30) NOT NULL
);

CREATE TABLE orders(
  OrderID integer PRIMARY KEY AUTOINCREMENT
);

CREATE TABLE order_details (
OrderID integer NOT NULL,
ProductID integer NOT NULL,
CustomerID integer NOT NULL,
OrderDate DATE NOT NULL,
Address varchar(45) NOT NULL,
isFilled boolean NOT NULL,

FOREIGN KEY (OrderID) REFERENCES orders(OrderID)
  ON DELETE CASCADE,
FOREIGN KEY (ProductID) REFERENCES products(ProductID)
  ON DELETE SET NULL,
FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
  ON DELETE SET NULL
);
 
CREATE TABLE products (
  ProductID integer PRIMARY KEY AUTOINCREMENT,
  CategoryID integer,
  InStock integer NOT NULL,
  UnitPrice integer NOT NULL,
  
  FOREIGN KEY (CategoryID) REFERENCES categories(CategoryID)
    ON DELETE CASCADE
);

CREATE TABLE suppliers(
  SupplierID integer PRIMARY KEY AUTOINCREMENT,
  SupplierName varchar(30) NOT NULL,
  SupplierEmail varchar(30) NOT NULL
);

CREATE TABLE productSupply(
    ProductID integer NOT NULL,
    SupplierID integer NOT NULL,
    CONSTRAINT product_supply_pk
        PRIMARY KEY (ProductID, SupplierID)
    FOREIGN KEY (ProductID)
        REFERENCES products(ProductID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
    FOREIGN KEY (SupplierID)
        REFERENCES suppliers(SupplierID)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE categories (
  CategoryID integer PRIMARY KEY AUTOINCREMENT,
  CategoryName char(12) NOT NULL
);

CREATE TABLE customers (
  CustomerID integer PRIMARY KEY AUTOINCREMENT,
  CustName varchar(30),
  CustEmail varchar(30) NOT NULL,
  CustPhone varchar(15)
);


--Populate shippers table
INSERT INTO shippers (ShipperName, ShipperEmail)
VALUES
  ('Fast & Furious Shipping Co.', 'fastfurious@ff.com'),
  ('Jolly Roger Shipping', 'jollyroger@roger.com'),
  ('Purple Parrot Shipping', 'purpleparrot@pp.com'),
  ('Hippogriff Haulers', 'hippogriffhaulers@hippers.com'),
  ('Phoenix Express', 'phoenixexpress@pex.com'),
  ('Fast shippers', 'fastexp@ress.com'),
  ('Faster shippers' , 'faster@ships.com'),
  ('014-kuljetus', '014@kuljetus.com');
  
--Populate suppliers table
INSERT INTO suppliers (SupplierName, SupplierEmail)
VALUES
	("Asus clothing", "support@asus.com"),
  ("Sup-layers", "sup@layers-com"),
  ("JKEA", "nordic@jkea.com"),
  ("Bookworm", "support@worm.com"),
  ("General store", "general@store.com"),
  ("Toys R sus", "toys@sus.com");

--Populate procuts table
INSERT INTO products (CategoryID, InStock, UnitPrice)
VALUES
  (1, 19, 120),
  (1, 0, 850),
  (2, 98, 30),
  (3, 120, 16),
  (4, 14252, 203),
  (5, 1738, 69),
  (6, 12, 1200);


--Populate categories table
INSERT INTO categories (CategoryName)
VALUES
  ("Clothing"),
  ("Furniture"),
  ("Books"),
  ("Movies"),
  ("Electronics"),
  ("Other"),
  ("Cooking & kitchen"),
  ("Sports"),
  ("Toys");


--Populate customers table
INSERT INTO customers (CustName, CustEmail, CustPhone)
VALUES
("Sarah Johnson", "sarah.j@gmail.com", "555-1234"),
("Luke Skywalker", "star.wars@lucas.com", "123-12388994"),
("Mr. Bombastic", "callme@fantastic.com", "-"),
("Brian Kottarainen", "BrianK@LUT.fi", "044-5678956"),
("Tatti Tutterson", "Tattitutti@gmail.com", "897-11144243"),
("Homer Simpson", "Homer.j.Simpson@yellowmail.com", "527-14402122"),
("Joel Huotari", "Joel.h@luukku.com", "636-1424021");

--Populate orders table
INSERT INTO orders (OrderID) 
VALUES
(1),
(2),
(3),
(4),
(5),
(6),
(7);

--Populate order_details table
INSERT INTO order_details (OrderID, ProductID, CustomerID, OrderDate, Address, isFilled)
VALUES
(1, 5, 2, "2023-3-12", "345 main st. NY", 0),
(2, 3, 1, "2023-3-14", "Leirikatu 1 B LPR", 0),
(3, 2, 5, "2001-12-3", "Bourbon Street 42 JKL", 0),
(4, 1, 3, "2023-2-5", "Beatles boulevard 152 HEL", 1),
(5, 1, 4, "2022-2-30", "Under the Golden gate bridge CAL", 0),
(6, 2, 4, "2022-2-31", "Under the Golden gate bridge CAL",1),
(7, 4, 4, "2023-3-21", "Yliopistonkatu 34 LPR", 0);


--Populate productSupply table
INSERT INTO productSupply (ProductID, SupplierID)
VALUES
(1, 1),
(1, 2),
(2, 1),
(3, 3),
(4, 4),
(5, 5),
(6, 5);


--Retrieve all customers and their info
SELECT * FROM customers;

--Retrieve all orders and their informations, ordered by OrderDate
--SELECT * FROM order_details ORDER BY OrderDate;

--Retrieve all orders that have not been filled yet along with the address, customers name and email.
SELECT order_details.OrderID, order_details.Address, customers.CustName, customers.CustEmail
FROM order_details
INNER JOIN customers ON order_details.CustomerID = customers.CustomerID
WHERE order_details.isFilled = 0;

--Retrieve the name and email of all suppliers who supply product with ProductID=1
SELECT suppliers.SupplierName as "Supplier" , suppliers.SupplierEmail as "Email"
FROM suppliers
INNER JOIN productSupply ON suppliers.SupplierID = productSupply.SupplierID
WHERE productSupply.ProductID = 1;

--Retrieve all orders made by the customer with the CustName Brian Kottarainen.
SELECT order_details.OrderID, products.ProductID, products.UnitPrice, order_details.OrderDate, order_details.isFilled
FROM order_details
INNER JOIN customers ON order_details.CustomerID = customers.CustomerID
INNER JOIN products ON order_details.ProductID = products.ProductID
WHERE customers.CustName = "Brian Kottarainen";

--Retrieve the total number of products in stock for each category.
SELECT c.CategoryName, COALESCE(SUM(p.InStock), 0) AS InStockAmount
FROM categories c
LEFT JOIN products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName;



