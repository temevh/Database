
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
    ON DELETE CASCADE,
  FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
    ON DELETE CASCADE
);
 
CREATE TABLE products (
  ProductID integer PRIMARY KEY AUTOINCREMENT,
  CategoryID integer,
  InStock integer,
  UnitPrice integer,
  
  FOREIGN KEY (CategoryID) REFERENCES categories(CategoryID)
    ON DELETE CASCADE
);

CREATE TABLE suppliers(
  SupplierID integer PRIMARY KEY AUTOINCREMENT,
  SupplierName varchar(30),
  SupplierEmail varchar(30)
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
  CategoryName char(12)
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
  ('Phoenix Express', 'phoenixexpress@pex.com');
  
--Populate suppliers table
INSERT INTO suppliers (SupplierName, SupplierEmail)
VALUES
	("Asus clothing", "support@asus.com"),
    ("Sup-layers", "sup@layers-com"),
    ("JKEA", "nordic@jkea.com"),
    ("Bookworm", "support@worm.com"),
    ("General store", "general@store.com");

--Populate procuts table
INSERT INTO products (CategoryID, InStock, UnitPrice)
VALUES
  (1, 19, 120),
  (1, 0, 850),
  (2, 42, 30),
  (3, 10, 16),
  (4, 14, 203),
  (5, 1738, 69);


--Populate categories table
INSERT INTO categories (CategoryName)
VALUES
  ("clothing"),
  ("furniture"),
  ("books"),
  ("movies"),
  ("electronics"),
  ("other");


--Populate customers table
INSERT INTO customers (CustName, CustEmail, CustPhone)
VALUES
("Sarah Johnson", "sarah.j@gmail.com", "555-1234"),
("Luke Skywalker", "star.wars@lucas.com", "123-12388994"),
("Mr. Bombastic", "callme@fantastic.com", "-"),
("Brian Kottarainen", "BrianK@LUT.fi", "044-5678956"),
("Tatti Tutterson", "Tattitutti@gmail.com", "897-11144243");

--Populate orders table
INSERT INTO orders (OrderID) 
VALUES
(1),
(2),
(3),
(4),
(5),
(6);

--Populate order_details table
INSERT INTO order_details (OrderID, ProductID, CustomerID, OrderDate, Address, isFilled)
VALUES
(1, 5, 2, "2023-3-12", "345 main st. NY", 0),
(2, 3, 1, "2023-3-14", "Leirikatu 1 B LPR", 1),
(3, 2, 5, "2001-12-3", "Bourbon Street 42 JKL", 0),
(4, 1, 3, "2023-2-5", "Beatles boulevard 152 HEL", 1),
(5, 1, 4, "2022-2-30", "Under the Golden gate bridge CAL", 1),
(6, 2, 4, "2022-2-31", "Under the Golden gate bridge CAL",1);


--Populate productSupply table
INSERT INTO productSupply (ProductID, SupplierID)
VALUES
(1, 2),
(2, 1),
(3, 3),
(4, 4),
(5, 5),
(6, 5);

--Retrieve all customers and their info
SELECT * FROM customers;

--Retrieve all orders that have not been filled yet along with the customer name and email address.
SELECT order_details.OrderID, customers.CustName, customers.CustEmail
FROM order_details
INNER JOIN customers ON order_details.CustomerID = customers.CustomerID
WHERE order_details.isFilled = 0;

--Retrieve the name and email of all suppliers who supply product with ProductID=1
SELECT suppliers.SupplierName, suppliers.SupplierEmail
FROM suppliers
INNER JOIN productSupply ON suppliers.SupplierID = productSupply.SupplierID
WHERE productSupply.ProductID = 1;

--Retrieve all orders made by the customer with the customerID of 4.
SELECT order_details.OrderID, products.ProductID, products.UnitPrice, order_details.OrderDate
FROM order_details
INNER JOIN customers ON order_details.CustomerID = customers.CustomerID
INNER JOIN products ON order_details.ProductID = products.ProductID
WHERE customers.CustomerID = 4;

--Retrieve the total number of products in stock for each category.
SELECT categories.CategoryName, SUM(products.InStock) AS TotalStock
FROM products
INNER JOIN categories ON products.CategoryID = categories.CategoryID
GROUP BY categories.CategoryName;


