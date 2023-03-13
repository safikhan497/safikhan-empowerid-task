

--==============================================================================================
--=================================Destination DB SQL Scripts===================================
--==============================================================================================

--=================
--==DDL Scripts===
--=================
DROP TABLE IF EXISTS [dbo].[Order_Products];
DROP TABLE IF EXISTS [dbo].[Orders];
DROP TABLE IF EXISTS [dbo].[Products];
DROP TABLE IF EXISTS [dbo].[Categories];

CREATE TABLE [dbo].[Categories] (
   category_id INT CONSTRAINT [pk_categoryid_Categories] PRIMARY KEY,
   category_name VARCHAR(1000) NULL,   
   created_on DATETIME CONSTRAINT [def_createdon_Categories] DEFAULT GETDATE(),
   created_by VARCHAR(100) CONSTRAINT [def_createdby_Categories] DEFAULT SUSER_NAME(),
);

CREATE TABLE [dbo].[Products] (
   product_id INT CONSTRAINT [pk_productid_Products] PRIMARY KEY,
   product_name VARCHAR(1000) NULL,
   category_id INT FOREIGN KEY REFERENCES Categories(category_id),
   price DECIMAL(23,6),
   [description] VARCHAR(MAX),
   image_url VARCHAR(MAX),
   date_added DATETIME CONSTRAINT [def_dateadded_Products] DEFAULT GETDATE(),   
   created_on DATETIME CONSTRAINT [def_createdon_Products] DEFAULT GETDATE(),
   created_by VARCHAR(100) CONSTRAINT [def_createdby_Products] DEFAULT SUSER_NAME(),
);

CREATE TABLE [dbo].[Orders] (
   order_id INT CONSTRAINT [pk_orderid_Orders] PRIMARY KEY,
   order_date DATETIME,
   customer_name VARCHAR(200),   
   created_on DATETIME CONSTRAINT [def_createdon_Orders] DEFAULT GETDATE(),
   created_by VARCHAR(100) CONSTRAINT [def_createdby_Orders] DEFAULT SUSER_NAME(),
);

CREATE TABLE [dbo].[Order_Products] (
   order_id INT,
   product_id INT,
   quantity INT,   
   created_on DATETIME CONSTRAINT [def_createdon_OrderProducts] DEFAULT GETDATE(),
   created_by VARCHAR(100) CONSTRAINT [def_createdby_OrderProducts] DEFAULT SUSER_NAME(),   
   CONSTRAINT [pk_orderid_productid_OrderProducts] PRIMARY KEY (order_id, product_id),
   CONSTRAINT [fk_orderid_OrderProducts] FOREIGN KEY (order_id) REFERENCES Orders(order_id),
   CONSTRAINT [fk_productid_OrderProducts] FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

