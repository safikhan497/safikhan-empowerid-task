

--=========================================================================================
--=================================Source DB SQL Scripts===================================
--=========================================================================================

--=================
--==DDL Scripts===
--=================
DROP TABLE IF EXISTS [dbo].[Order_Products];
DROP TABLE IF EXISTS [dbo].[Orders];
DROP TABLE IF EXISTS [dbo].[Products];
DROP TABLE IF EXISTS [dbo].[Categories];
DROP TABLE IF EXISTS [dbo].[Application_Events_Log];

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

CREATE TABLE [dbo].[Application_Events_Log](
	[event_id] [int] IDENTITY(1,1) NOT NULL CONSTRAINT [PK_Application_Events_Log] PRIMARY KEY,
	[event_name] [nvarchar](1000) NULL,
	[event_status] [varchar](1000) NULL,
	[user_query] [varchar](max) NULL,
	[event_description] [nvarchar](max) NULL,
	[event_time] [datetimeoffset](7) NULL CONSTRAINT [DF_Application_Events_Log_event_time]  DEFAULT (sysdatetimeoffset()),
	[event_output] [nvarchar](max) NULL,
	[created_on] [datetime] NULL CONSTRAINT [DF_Application_Events_Log_created_on]  DEFAULT (getdate()),
	[created_by] [varchar](500) NULL CONSTRAINT [DF_Application_Events_Log_created_by]  DEFAULT (suser_name()))
GO

CREATE TRIGGER dbo.[Events_Table_Trigger]
   ON  dbo.[Application_Events_Log]
   AFTER INSERT
AS 
BEGIN
	SET NOCOUNT ON;

	   DECLARE @maxID INT = (SELECT MAX(event_id) FROM dbo.[Application_Events_Log]);

	   UPDATE dbo.[Application_Events_Log] 
	   SET 
	   user_query=CASE WHEN user_query='---' THEN NULL ELSE user_query END, 
	   event_output=CASE WHEN event_output='---' THEN NULL ELSE event_output END
	   WHERE event_id=@maxID
END
GO



--=================
--==DML Scripts===
--=================
INSERT INTO [dbo].[Categories](category_id,category_name,created_on,created_by)
SELECT 101,'Mountain Bikes','2023-03-12 12:42:11.030','dbo' UNION ALL
SELECT 102,'Road Bikes','2023-03-12 12:42:11.031','dbo' UNION ALL
SELECT 103,'Touring Bikes','2023-03-12 12:42:11.032','dbo' UNION ALL
SELECT 104,'Handlebars','2023-03-12 12:42:11.033','dbo' UNION ALL
SELECT 105,'Bottom Brackets','2023-03-12 12:42:11.034','dbo' UNION ALL
SELECT 106,'Brakes','2023-03-12 12:42:11.035','dbo' UNION ALL
SELECT 107,'Chains','2023-03-12 12:42:11.036','dbo' UNION ALL
SELECT 108,'Cranksets','2023-03-12 12:42:11.037','dbo' UNION ALL
SELECT 109,'Derailleurs','2023-03-12 12:42:11.038','dbo' UNION ALL
SELECT 110,'Forks','2023-03-12 12:42:11.039','dbo' UNION ALL
SELECT 111,'Headsets','2023-03-12 12:42:11.040','dbo' UNION ALL
SELECT 112,'Mountain Frames','2023-03-12 12:42:11.041','dbo' UNION ALL
SELECT 113,'Pedals','2023-03-12 12:42:11.042','dbo' UNION ALL
SELECT 114,'Road Frames','2023-03-12 12:42:11.043','dbo' UNION ALL
SELECT 115,'Saddles','2023-03-12 12:42:11.044','dbo' UNION ALL
SELECT 116,'Touring Frames','2023-03-12 12:42:11.045','dbo' UNION ALL
SELECT 117,'Wheels','2023-03-12 12:42:11.046','dbo' UNION ALL
SELECT 118,'Bib-Shorts','2023-03-12 12:42:11.047','dbo' UNION ALL
SELECT 119,'Caps','2023-03-12 12:42:11.048','dbo' UNION ALL
SELECT 120,'Gloves','2023-03-12 12:42:11.049','dbo' UNION ALL
SELECT 121,'Jerseys','2023-03-12 12:42:11.050','dbo' UNION ALL
SELECT 122,'Shorts','2023-03-12 12:42:11.051','dbo' UNION ALL
SELECT 123,'Socks','2023-03-12 12:42:11.052','dbo' UNION ALL
SELECT 124,'Tights','2023-03-12 12:42:11.053','dbo' UNION ALL
SELECT 125,'Vests','2023-03-12 12:42:11.054','dbo' UNION ALL
SELECT 126,'Bike Racks','2023-03-12 12:42:11.055','dbo' UNION ALL
SELECT 127,'Bike Stands','2023-03-12 12:42:11.056','dbo' UNION ALL
SELECT 128,'Bottles and Cages','2023-03-12 12:42:11.057','dbo' UNION ALL
SELECT 129,'Cleaners','2023-03-12 12:42:11.058','dbo' UNION ALL
SELECT 130,'Fenders','2023-03-12 12:42:11.059','dbo' UNION ALL
SELECT 131,'Helmets','2023-03-12 12:42:11.060','dbo' UNION ALL
SELECT 132,'Hydration Packs','2023-03-12 12:42:11.061','dbo' UNION ALL
SELECT 133,'Lights','2023-03-12 12:42:11.062','dbo' UNION ALL
SELECT 134,'Locks','2023-03-12 12:42:11.063','dbo' UNION ALL
SELECT 135,'Panniers','2023-03-12 12:42:11.064','dbo' UNION ALL
SELECT 136,'Pumps','2023-03-12 12:42:11.065','dbo' UNION ALL
SELECT 137,'Tires and Tubes','2023-03-12 12:42:11.066','dbo'


INSERT INTO [dbo].[Orders] (order_id,order_date,customer_name,created_on,created_by)
SELECT 501,'2023-02-04 00:00:00.000','Claudia McDonald','2023-03-12 12:36:37.283','dbo' UNION ALL
SELECT 502,'2023-02-21 00:00:00.000','Abigail Rogers','2023-03-12 12:36:37.284','dbo' UNION ALL
SELECT 503,'2022-11-15 00:00:00.000','Jillian Srini','2023-03-12 12:36:37.285','dbo' UNION ALL
SELECT 504,'2023-02-07 00:00:00.000','Ian Morris','2023-03-12 12:36:37.286','dbo' UNION ALL
SELECT 505,'2022-11-19 00:00:00.000','Christine Chande','2023-03-12 12:36:37.287','dbo' UNION ALL
SELECT 506,'2022-12-21 00:00:00.000','Emma White','2023-03-12 12:36:37.288','dbo' UNION ALL
SELECT 507,'2023-02-22 00:00:00.000','Kaylee Cooper','2023-03-12 12:36:37.289','dbo' UNION ALL
SELECT 508,'2022-12-21 00:00:00.000','Eric Carter','2023-03-12 12:36:37.290','dbo' UNION ALL
SELECT 509,'2023-02-11 00:00:00.000','April Deng','2023-03-12 12:36:37.291','dbo' UNION ALL
SELECT 510,'2022-12-08 00:00:00.000','Aaron Washington','2023-03-12 12:36:37.292','dbo' UNION ALL
SELECT 511,'2022-11-19 00:00:00.000','Julie Taft-Rider','2023-03-12 12:36:37.293','dbo' UNION ALL
SELECT 512,'2022-12-04 00:00:00.000','Grace Patterson','2023-03-12 12:36:37.294','dbo' UNION ALL
SELECT 513,'2023-01-07 00:00:00.000','Sophia Baker','2023-03-12 12:36:37.295','dbo' UNION ALL
SELECT 514,'2022-12-23 00:00:00.000','Noah Griffin','2023-03-12 12:36:37.296','dbo' UNION ALL
SELECT 515,'2023-01-10 00:00:00.000','Calvin Chander','2023-03-12 12:36:37.297','dbo' UNION ALL
SELECT 516,'2023-01-26 00:00:00.000','Pedro Sanz','2023-03-12 12:36:37.298','dbo' UNION ALL
SELECT 517,'2022-11-28 00:00:00.000','Rachel Lewis','2023-03-12 12:36:37.299','dbo' UNION ALL
SELECT 518,'2022-11-03 00:00:00.000','Kaitlyn Morris','2023-03-12 12:36:37.300','dbo' UNION ALL
SELECT 519,'2023-01-18 00:00:00.000','Clifford Weber','2023-03-12 12:36:37.301','dbo' UNION ALL
SELECT 520,'2023-01-26 00:00:00.000','Kellie Romero','2023-03-12 12:36:37.302','dbo' UNION ALL
SELECT 521,'2023-02-15 00:00:00.000','Emmanuel Patel','2023-03-12 12:36:37.303','dbo' UNION ALL
SELECT 522,'2022-11-07 00:00:00.000','Marcus Young','2023-03-12 12:36:37.304','dbo' UNION ALL
SELECT 523,'2022-12-19 00:00:00.000','Leslie Gomez','2023-03-12 12:36:37.305','dbo' UNION ALL
SELECT 524,'2022-11-23 00:00:00.000','Rosa Zeng','2023-03-12 12:36:37.306','dbo' UNION ALL
SELECT 525,'2023-01-04 00:00:00.000','Miranda Foster','2023-03-12 12:36:37.307','dbo' UNION ALL
SELECT 526,'2022-11-19 00:00:00.000','John Lee','2023-03-12 12:36:37.308','dbo' UNION ALL
SELECT 527,'2022-12-29 00:00:00.000','Walter Carlson','2023-03-12 12:36:37.309','dbo' UNION ALL
SELECT 528,'2023-01-07 00:00:00.000','Homer Villa','2023-03-12 12:36:37.310','dbo' UNION ALL
SELECT 529,'2023-02-11 00:00:00.000','Hannah Thomas','2023-03-12 12:36:37.311','dbo' UNION ALL
SELECT 530,'2023-02-04 00:00:00.000','Bianca Chen','2023-03-12 12:36:37.312','dbo' UNION ALL
SELECT 531,'2022-12-13 00:00:00.000','Luis Bryant','2023-03-12 12:36:37.313','dbo' UNION ALL
SELECT 532,'2023-01-19 00:00:00.000','Arthur Vazquez','2023-03-12 12:36:37.314','dbo' UNION ALL
SELECT 533,'2022-11-03 00:00:00.000','Johnathan Sanchez','2023-03-12 12:36:37.315','dbo' UNION ALL
SELECT 534,'2023-02-12 00:00:00.000','Aaron Jenkins','2023-03-12 12:36:37.316','dbo' UNION ALL
SELECT 535,'2022-11-28 00:00:00.000','Bradley Lal','2023-03-12 12:36:37.317','dbo' UNION ALL
SELECT 536,'2023-01-08 00:00:00.000','Christopher Harris','2023-03-12 12:36:37.318','dbo' UNION ALL
SELECT 537,'2023-01-24 00:00:00.000','Arturo Lal','2023-03-12 12:36:37.319','dbo' UNION ALL
SELECT 538,'2023-01-27 00:00:00.000','Darren Gehring','2023-03-12 12:36:37.320','dbo' UNION ALL
SELECT 539,'2023-01-11 00:00:00.000','Latoya Luo','2023-03-12 12:36:37.321','dbo' UNION ALL
SELECT 540,'2022-11-23 00:00:00.000','Jackson Foster','2023-03-12 12:36:37.322','dbo' UNION ALL
SELECT 541,'2023-01-16 00:00:00.000','Isaiah Turner','2023-03-12 12:36:37.323','dbo' UNION ALL
SELECT 542,'2022-12-03 00:00:00.000','Janelle Perez','2023-03-12 12:36:37.324','dbo' UNION ALL
SELECT 543,'2022-12-10 00:00:00.000','Richard Brown','2023-03-12 12:36:37.325','dbo' UNION ALL
SELECT 544,'2022-11-30 00:00:00.000','Noah Shan','2023-03-12 12:36:37.326','dbo' UNION ALL
SELECT 545,'2022-11-08 00:00:00.000','Nathaniel Watson','2023-03-12 12:36:37.327','dbo' UNION ALL
SELECT 546,'2023-02-06 00:00:00.000','Francisco Javier Castrejón','2023-03-12 12:36:37.328','dbo' UNION ALL
SELECT 547,'2022-12-22 00:00:00.000','Daisy Ortega','2023-03-12 12:36:37.329','dbo' UNION ALL
SELECT 548,'2022-11-09 00:00:00.000','Whitney Gonzalez','2023-03-12 12:36:37.330','dbo' UNION ALL
SELECT 549,'2023-02-28 00:00:00.000','Christy Kumar','2023-03-12 12:36:37.331','dbo' UNION ALL
SELECT 550,'2023-01-20 00:00:00.000','Marvin Allen','2023-03-12 12:36:37.332','dbo' UNION ALL
SELECT 551,'2022-12-30 00:00:00.000','José Saraiva','2023-03-12 12:36:37.333','dbo' UNION ALL
SELECT 552,'2023-01-27 00:00:00.000','Emma Wilson','2023-03-12 12:36:37.334','dbo' UNION ALL
SELECT 553,'2022-11-01 00:00:00.000','Ronald Rodriguez','2023-03-12 12:36:37.335','dbo' UNION ALL
SELECT 554,'2023-01-24 00:00:00.000','Darren Sai','2023-03-12 12:36:37.336','dbo' UNION ALL
SELECT 555,'2022-12-10 00:00:00.000','Christopher Moore','2023-03-12 12:36:37.337','dbo' UNION ALL
SELECT 556,'2023-02-28 00:00:00.000','Austin Zhang','2023-03-12 12:36:37.338','dbo' UNION ALL
SELECT 557,'2022-11-04 00:00:00.000','Shaun Shen','2023-03-12 12:36:37.339','dbo' UNION ALL
SELECT 558,'2022-11-19 00:00:00.000','Stephanie Baker','2023-03-12 12:36:37.340','dbo' UNION ALL
SELECT 559,'2022-12-21 00:00:00.000','Charles Reed','2023-03-12 12:36:37.341','dbo' UNION ALL
SELECT 560,'2023-01-09 00:00:00.000','Donald Subram','2023-03-12 12:36:37.342','dbo' UNION ALL
SELECT 561,'2023-01-17 00:00:00.000','Samantha Miller','2023-03-12 12:36:37.343','dbo' UNION ALL
SELECT 562,'2022-11-11 00:00:00.000','Bradley Carson','2023-03-12 12:36:37.344','dbo' UNION ALL
SELECT 563,'2023-02-04 00:00:00.000','John Arthur','2023-03-12 12:36:37.345','dbo' UNION ALL
SELECT 564,'2022-12-12 00:00:00.000','Bradley Raje','2023-03-12 12:36:37.346','dbo' UNION ALL
SELECT 565,'2022-11-27 00:00:00.000','Katherine Mitchell','2023-03-12 12:36:37.347','dbo' UNION ALL
SELECT 566,'2022-12-29 00:00:00.000','Jesse Green','2023-03-12 12:36:37.348','dbo' UNION ALL
SELECT 567,'2022-12-19 00:00:00.000','Nicole Gonzales','2023-03-12 12:36:37.349','dbo' UNION ALL
SELECT 568,'2022-12-03 00:00:00.000','Mariah Patterson','2023-03-12 12:36:37.350','dbo' UNION ALL
SELECT 569,'2023-01-11 00:00:00.000','Martin Rienstra','2023-03-12 12:36:37.351','dbo' UNION ALL
SELECT 570,'2023-01-12 00:00:00.000','Julia Mitchell','2023-03-12 12:36:37.352','dbo' UNION ALL
SELECT 571,'2023-01-07 00:00:00.000','Virginia Rodriguez','2023-03-12 12:36:37.353','dbo' UNION ALL
SELECT 572,'2023-01-21 00:00:00.000','Wyatt Foster','2023-03-12 12:36:37.354','dbo' UNION ALL
SELECT 573,'2023-02-13 00:00:00.000','Jason Shan','2023-03-12 12:36:37.355','dbo' UNION ALL
SELECT 574,'2023-01-09 00:00:00.000','Jessica Ross','2023-03-12 12:36:37.356','dbo' UNION ALL
SELECT 575,'2022-11-09 00:00:00.000','Erick Sai','2023-03-12 12:36:37.357','dbo' UNION ALL
SELECT 576,'2022-11-22 00:00:00.000','Sean Adams','2023-03-12 12:36:37.358','dbo' UNION ALL
SELECT 577,'2022-12-26 00:00:00.000','Mary Allen','2023-03-12 12:36:37.359','dbo' UNION ALL
SELECT 578,'2022-11-14 00:00:00.000','Byron Hernandez','2023-03-12 12:36:37.360','dbo' UNION ALL
SELECT 579,'2022-11-10 00:00:00.000','Thomas Carter','2023-03-12 12:36:37.361','dbo' UNION ALL
SELECT 580,'2023-01-18 00:00:00.000','Vanessa Washington','2023-03-12 12:36:37.362','dbo' UNION ALL
SELECT 581,'2022-11-07 00:00:00.000','Rafael Zhang','2023-03-12 12:36:37.363','dbo' UNION ALL
SELECT 582,'2022-12-04 00:00:00.000','Katelyn Sanders','2023-03-12 12:36:37.364','dbo' UNION ALL
SELECT 583,'2022-12-31 00:00:00.000','Angel Peterson','2023-03-12 12:36:37.365','dbo' UNION ALL
SELECT 584,'2022-12-03 00:00:00.000','Emmanuel Martinez','2023-03-12 12:36:37.366','dbo' UNION ALL
SELECT 585,'2022-11-11 00:00:00.000','Summer Sanchez','2023-03-12 12:36:37.367','dbo' UNION ALL
SELECT 586,'2023-01-05 00:00:00.000','Renee Gomez','2023-03-12 12:36:37.368','dbo' UNION ALL
SELECT 587,'2022-11-19 00:00:00.000','Renee Dominguez','2023-03-12 12:36:37.369','dbo' UNION ALL
SELECT 588,'2022-12-15 00:00:00.000','Corey Xie','2023-03-12 12:36:37.370','dbo' UNION ALL
SELECT 589,'2023-01-19 00:00:00.000','Robertson Lee','2023-03-12 12:36:37.371','dbo' UNION ALL
SELECT 590,'2023-02-17 00:00:00.000','Kenneth Tang','2023-03-12 12:36:37.372','dbo' UNION ALL
SELECT 591,'2022-12-31 00:00:00.000','Veronica Sara','2023-03-12 12:36:37.373','dbo' UNION ALL
SELECT 592,'2022-11-02 00:00:00.000','Megan Kelly','2023-03-12 12:36:37.374','dbo' UNION ALL
SELECT 593,'2022-12-18 00:00:00.000','Linda Mitchell','2023-03-12 12:36:37.375','dbo' UNION ALL
SELECT 594,'2022-11-05 00:00:00.000','Dale Raji','2023-03-12 12:36:37.376','dbo' UNION ALL
SELECT 595,'2023-01-28 00:00:00.000','Alexandra Scott','2023-03-12 12:36:37.377','dbo' UNION ALL
SELECT 596,'2023-01-25 00:00:00.000','Jordyn Henderson','2023-03-12 12:36:37.378','dbo' UNION ALL
SELECT 597,'2022-11-04 00:00:00.000','Sarah Washington','2023-03-12 12:36:37.379','dbo' UNION ALL
SELECT 598,'2023-02-01 00:00:00.000','Jonathan Green','2023-03-12 12:36:37.380','dbo' UNION ALL
SELECT 599,'2023-01-22 00:00:00.000','Chloe Scott','2023-03-12 12:36:37.381','dbo' UNION ALL
SELECT 600,'2022-12-23 00:00:00.000','Sharon Yuan','2023-03-12 12:36:37.382','dbo' UNION ALL
SELECT 601,'2022-11-01 00:00:00.000','Melanie Russell','2023-03-12 12:36:37.383','dbo' UNION ALL
SELECT 602,'2023-02-18 00:00:00.000','Arturo Liang','2023-03-12 12:36:37.384','dbo' UNION ALL
SELECT 603,'2022-12-19 00:00:00.000','Eduardo Morgan','2023-03-12 12:36:37.385','dbo' UNION ALL
SELECT 604,'2022-12-27 00:00:00.000','Kevin Hernandez','2023-03-12 12:36:37.386','dbo' UNION ALL
SELECT 605,'2022-11-13 00:00:00.000','Ryan Foster','2023-03-12 12:36:37.387','dbo' UNION ALL
SELECT 606,'2022-11-25 00:00:00.000','Michele Malhotra','2023-03-12 12:36:37.388','dbo' UNION ALL
SELECT 607,'2022-12-06 00:00:00.000','Linda Moreno','2023-03-12 12:36:37.389','dbo' UNION ALL
SELECT 608,'2022-11-03 00:00:00.000','Rachel Davis','2023-03-12 12:36:37.390','dbo' UNION ALL
SELECT 609,'2022-12-27 00:00:00.000','Neil Vazquez','2023-03-12 12:36:37.391','dbo' UNION ALL
SELECT 610,'2022-11-30 00:00:00.000','Alexandria Cox','2023-03-12 12:36:37.392','dbo' UNION ALL
SELECT 611,'2023-01-07 00:00:00.000','Sharon Salavaria','2023-03-12 12:36:37.393','dbo' UNION ALL
SELECT 612,'2022-12-19 00:00:00.000','Tom Higginbotham','2023-03-12 12:36:37.394','dbo' UNION ALL
SELECT 613,'2023-01-19 00:00:00.000','Julie Becker','2023-03-12 12:36:37.395','dbo' UNION ALL
SELECT 614,'2023-01-11 00:00:00.000','Connor Shan','2023-03-12 12:36:37.396','dbo' UNION ALL
SELECT 615,'2022-11-18 00:00:00.000','Brian Howard','2023-03-12 12:36:37.397','dbo' UNION ALL
SELECT 616,'2023-01-21 00:00:00.000','Brooke Rogers','2023-03-12 12:36:37.398','dbo' UNION ALL
SELECT 617,'2023-01-18 00:00:00.000','Destiny Kelly','2023-03-12 12:36:37.399','dbo' UNION ALL
SELECT 618,'2022-12-22 00:00:00.000','Aimee Wang','2023-03-12 12:36:37.400','dbo' UNION ALL
SELECT 619,'2022-12-12 00:00:00.000','Mya Diaz','2023-03-12 12:36:37.401','dbo' UNION ALL
SELECT 620,'2022-11-18 00:00:00.000','Colleen Guo','2023-03-12 12:36:37.402','dbo' UNION ALL
SELECT 621,'2022-11-06 00:00:00.000','Bryant Mehta','2023-03-12 12:36:37.403','dbo' UNION ALL
SELECT 622,'2022-12-30 00:00:00.000','Colleen Tang','2023-03-12 12:36:37.404','dbo' UNION ALL
SELECT 623,'2023-02-25 00:00:00.000','Roger Lin','2023-03-12 12:36:37.405','dbo' UNION ALL
SELECT 624,'2022-11-29 00:00:00.000','Courtney Campbell','2023-03-12 12:36:37.406','dbo' UNION ALL
SELECT 625,'2022-12-17 00:00:00.000','Jocelyn Hughes','2023-03-12 12:36:37.407','dbo' UNION ALL
SELECT 626,'2023-02-27 00:00:00.000','Jamie Lin','2023-03-12 12:36:37.408','dbo' UNION ALL
SELECT 627,'2023-01-03 00:00:00.000','Danny Ruiz','2023-03-12 12:36:37.409','dbo' UNION ALL
SELECT 628,'2022-12-30 00:00:00.000','Cindy Sanchez','2023-03-12 12:36:37.410','dbo' UNION ALL
SELECT 629,'2022-12-20 00:00:00.000','Danielle Reed','2023-03-12 12:36:37.411','dbo' UNION ALL
SELECT 630,'2022-12-05 00:00:00.000','Julia Miller','2023-03-12 12:36:37.412','dbo' UNION ALL
SELECT 631,'2022-12-22 00:00:00.000','Mary Billstrom','2023-03-12 12:36:37.413','dbo' UNION ALL
SELECT 632,'2022-11-01 00:00:00.000','Glenn Lin','2023-03-12 12:36:37.414','dbo' UNION ALL
SELECT 633,'2022-12-27 00:00:00.000','Mason Carter','2023-03-12 12:36:37.415','dbo' UNION ALL
SELECT 634,'2023-02-20 00:00:00.000','Robyn Navarro','2023-03-12 12:36:37.416','dbo' UNION ALL
SELECT 635,'2022-12-03 00:00:00.000','Wesley Xu','2023-03-12 12:36:37.417','dbo' UNION ALL
SELECT 636,'2023-01-21 00:00:00.000','Carly Beck','2023-03-12 12:36:37.418','dbo' UNION ALL
SELECT 637,'2023-02-13 00:00:00.000','Katherine Lee','2023-03-12 12:36:37.419','dbo' UNION ALL
SELECT 638,'2022-11-24 00:00:00.000','Julian Butler','2023-03-12 12:36:37.420','dbo' UNION ALL
SELECT 639,'2023-02-22 00:00:00.000','Victoria Jenkins','2023-03-12 12:36:37.421','dbo' UNION ALL
SELECT 640,'2022-12-30 00:00:00.000','Elijah Griffin','2023-03-12 12:36:37.422','dbo' UNION ALL
SELECT 641,'2023-02-05 00:00:00.000','Isaiah Rogers','2023-03-12 12:36:37.423','dbo' UNION ALL
SELECT 642,'2022-12-08 00:00:00.000','Alyssa Kelly','2023-03-12 12:36:37.424','dbo' UNION ALL
SELECT 643,'2022-11-09 00:00:00.000','Margaret Zheng','2023-03-12 12:36:37.425','dbo' UNION ALL
SELECT 644,'2023-02-24 00:00:00.000','Krystal Li','2023-03-12 12:36:37.426','dbo' UNION ALL
SELECT 645,'2023-02-06 00:00:00.000','Christine Nara','2023-03-12 12:36:37.427','dbo' UNION ALL
SELECT 646,'2022-11-30 00:00:00.000','Julia Patterson','2023-03-12 12:36:37.428','dbo' UNION ALL
SELECT 647,'2022-11-03 00:00:00.000','Victoria Richardson','2023-03-12 12:36:37.429','dbo' UNION ALL
SELECT 648,'2023-02-17 00:00:00.000','Seth Phillips','2023-03-12 12:36:37.430','dbo' UNION ALL
SELECT 649,'2023-02-04 00:00:00.000','Jaclyn Kumar','2023-03-12 12:36:37.431','dbo' UNION ALL
SELECT 650,'2022-12-28 00:00:00.000','Shelby Cook','2023-03-12 12:36:37.432','dbo' UNION ALL
SELECT 651,'2023-02-25 00:00:00.000','Josue Blanco','2023-03-12 12:36:37.433','dbo' UNION ALL
SELECT 652,'2022-12-21 00:00:00.000','Wendy Ortega','2023-03-12 12:36:37.434','dbo' UNION ALL
SELECT 653,'2022-12-02 00:00:00.000','Julia Gonzalez','2023-03-12 12:36:37.435','dbo' UNION ALL
SELECT 654,'2023-02-05 00:00:00.000','Julia Brooks','2023-03-12 12:36:37.436','dbo' UNION ALL
SELECT 655,'2022-11-22 00:00:00.000','Morgan Bailey','2023-03-12 12:36:37.437','dbo' UNION ALL
SELECT 656,'2022-12-29 00:00:00.000','Xavier Murphy','2023-03-12 12:36:37.438','dbo' UNION ALL
SELECT 657,'2022-11-27 00:00:00.000','Kyle Scott','2023-03-12 12:36:37.439','dbo' UNION ALL
SELECT 658,'2023-02-17 00:00:00.000','Natalie Jackson','2023-03-12 12:36:37.440','dbo' UNION ALL
SELECT 659,'2023-01-01 00:00:00.000','Xavier Edwards','2023-03-12 12:36:37.441','dbo' UNION ALL
SELECT 660,'2023-01-10 00:00:00.000','Emma Jenkins','2023-03-12 12:36:37.442','dbo' UNION ALL
SELECT 661,'2023-01-07 00:00:00.000','Robyn Diaz','2023-03-12 12:36:37.443','dbo' UNION ALL
SELECT 662,'2022-12-25 00:00:00.000','Victoria Barnes','2023-03-12 12:36:37.444','dbo' UNION ALL
SELECT 663,'2022-11-28 00:00:00.000','Francisco Suri','2023-03-12 12:36:37.445','dbo' UNION ALL
SELECT 664,'2023-02-13 00:00:00.000','Jermaine Perez','2023-03-12 12:36:37.446','dbo' UNION ALL
SELECT 665,'2023-02-26 00:00:00.000','Krista Jimenez','2023-03-12 12:36:37.447','dbo' UNION ALL
SELECT 666,'2023-01-14 00:00:00.000','Manuel Martinez','2023-03-12 12:36:37.448','dbo' UNION ALL
SELECT 667,'2022-12-04 00:00:00.000','Stacey Hee','2023-03-12 12:36:37.449','dbo' UNION ALL
SELECT 668,'2022-12-31 00:00:00.000','Luis Roberts','2023-03-12 12:36:37.450','dbo' UNION ALL
SELECT 669,'2022-11-27 00:00:00.000','Meghan Rowe','2023-03-12 12:36:37.451','dbo' UNION ALL
SELECT 670,'2022-11-19 00:00:00.000','Warren Wang','2023-03-12 12:36:37.452','dbo' UNION ALL
SELECT 671,'2022-11-12 00:00:00.000','Trisha Cai','2023-03-12 12:36:37.453','dbo' UNION ALL
SELECT 672,'2023-01-25 00:00:00.000','Eduardo Gonzales','2023-03-12 12:36:37.454','dbo' UNION ALL
SELECT 673,'2022-12-30 00:00:00.000','Latasha Ramos','2023-03-12 12:36:37.455','dbo' UNION ALL
SELECT 674,'2022-11-15 00:00:00.000','Gary Navarro','2023-03-12 12:36:37.456','dbo' UNION ALL
SELECT 675,'2023-02-09 00:00:00.000','Ronnie Yang','2023-03-12 12:36:37.457','dbo' UNION ALL
SELECT 676,'2022-12-03 00:00:00.000','Miguel Powell','2023-03-12 12:36:37.458','dbo' UNION ALL
SELECT 677,'2023-02-14 00:00:00.000','Jasmine Bell','2023-03-12 12:36:37.459','dbo' UNION ALL
SELECT 678,'2023-01-25 00:00:00.000','Ana Barnes','2023-03-12 12:36:37.460','dbo' UNION ALL
SELECT 679,'2022-11-19 00:00:00.000','Carolee Brown','2023-03-12 12:36:37.461','dbo' UNION ALL
SELECT 680,'2023-02-17 00:00:00.000','Alejandro Chander','2023-03-12 12:36:37.462','dbo' UNION ALL
SELECT 681,'2022-12-29 00:00:00.000','Anne Martin','2023-03-12 12:36:37.463','dbo' UNION ALL
SELECT 682,'2022-12-06 00:00:00.000','Gerald Jimenez','2023-03-12 12:36:37.464','dbo' UNION ALL
SELECT 683,'2023-02-06 00:00:00.000','Molly Rodriguez','2023-03-12 12:36:37.465','dbo' UNION ALL
SELECT 684,'2022-11-01 00:00:00.000','Richard Garcia','2023-03-12 12:36:37.466','dbo' UNION ALL
SELECT 685,'2023-02-16 00:00:00.000','Irene Hernandez','2023-03-12 12:36:37.467','dbo' UNION ALL
SELECT 686,'2022-12-15 00:00:00.000','Sarah Johnson','2023-03-12 12:36:37.468','dbo' UNION ALL
SELECT 687,'2022-12-08 00:00:00.000','Jonathan Hernandez','2023-03-12 12:36:37.469','dbo' UNION ALL
SELECT 688,'2023-02-13 00:00:00.000','Ariana Sanders','2023-03-12 12:36:37.470','dbo' UNION ALL
SELECT 689,'2022-11-27 00:00:00.000','Zheng Mu','2023-03-12 12:36:37.471','dbo' UNION ALL
SELECT 690,'2023-02-20 00:00:00.000','Lorraine Nay','2023-03-12 12:36:37.472','dbo' UNION ALL
SELECT 691,'2023-02-22 00:00:00.000','Hailey Flores','2023-03-12 12:36:37.473','dbo' UNION ALL
SELECT 692,'2022-11-22 00:00:00.000','Krista Blanco','2023-03-12 12:36:37.474','dbo' UNION ALL
SELECT 693,'2022-12-23 00:00:00.000','Joan Morgan','2023-03-12 12:36:37.475','dbo' UNION ALL
SELECT 694,'2023-01-30 00:00:00.000','Michele Andersen','2023-03-12 12:36:37.476','dbo' UNION ALL
SELECT 695,'2022-11-12 00:00:00.000','Karl Shan','2023-03-12 12:36:37.477','dbo' UNION ALL
SELECT 696,'2022-11-16 00:00:00.000','Anna Harris','2023-03-12 12:36:37.478','dbo' UNION ALL
SELECT 697,'2022-12-06 00:00:00.000','Hannah Wilson','2023-03-12 12:36:37.479','dbo' UNION ALL
SELECT 698,'2022-11-16 00:00:00.000','Suzanne Hu','2023-03-12 12:36:37.480','dbo' UNION ALL
SELECT 699,'2022-12-08 00:00:00.000','Jaclyn Wu','2023-03-12 12:36:37.481','dbo' UNION ALL
SELECT 700,'2023-02-04 00:00:00.000','Cheryl Hernandez','2023-03-12 12:36:37.482','dbo'

INSERT INTO [dbo].[Products] (product_id,product_name,category_id,price,[description],image_url,date_added,created_on,created_by)
SELECT 680,'HL Road Frame - Black, 58',114,1432.00,'Product HL Road Frame - Black, 58','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 706,'HL Road Frame - Red, 58',114,1432.00,'Product HL Road Frame - Red, 58','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 707,'Sport-100 Helmet, Red',131,35.00,'Product Sport-100 Helmet, Red','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 708,'Sport-100 Helmet, Black',131,35.00,'Product Sport-100 Helmet, Black','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 709,'Mountain Bike Socks, M',123,10.00,'Product Mountain Bike Socks, M','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 710,'Mountain Bike Socks, L',123,10.00,'Product Mountain Bike Socks, L','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 711,'Sport-100 Helmet, Blue',131,35.00,'Product Sport-100 Helmet, Blue','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 712,'AWC Logo Cap',119,9.00,'Product AWC Logo Cap','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 713,'Long-Sleeve Logo Jersey, S',121,50.00,'Product Long-Sleeve Logo Jersey, S','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 714,'Long-Sleeve Logo Jersey, M',121,50.00,'Product Long-Sleeve Logo Jersey, M','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 715,'Long-Sleeve Logo Jersey, L',121,50.00,'Product Long-Sleeve Logo Jersey, L','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 716,'Long-Sleeve Logo Jersey, XL',121,50.00,'Product Long-Sleeve Logo Jersey, XL','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 717,'HL Road Frame - Red, 62',114,1432.00,'Product HL Road Frame - Red, 62','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 718,'HL Road Frame - Red, 44',114,1432.00,'Product HL Road Frame - Red, 44','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 719,'HL Road Frame - Red, 48',114,1432.00,'Product HL Road Frame - Red, 48','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 720,'HL Road Frame - Red, 52',114,1432.00,'Product HL Road Frame - Red, 52','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 721,'HL Road Frame - Red, 56',114,1432.00,'Product HL Road Frame - Red, 56','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 722,'LL Road Frame - Black, 58',114,338.00,'Product LL Road Frame - Black, 58','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 723,'LL Road Frame - Black, 60',114,338.00,'Product LL Road Frame - Black, 60','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 724,'LL Road Frame - Black, 62',114,338.00,'Product LL Road Frame - Black, 62','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 725,'LL Road Frame - Red, 44',114,338.00,'Product LL Road Frame - Red, 44','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 726,'LL Road Frame - Red, 48',114,338.00,'Product LL Road Frame - Red, 48','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 727,'LL Road Frame - Red, 52',114,338.00,'Product LL Road Frame - Red, 52','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 728,'LL Road Frame - Red, 58',114,338.00,'Product LL Road Frame - Red, 58','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 729,'LL Road Frame - Red, 60',114,338.00,'Product LL Road Frame - Red, 60','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 730,'LL Road Frame - Red, 62',114,338.00,'Product LL Road Frame - Red, 62','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 731,'ML Road Frame - Red, 44',114,595.00,'Product ML Road Frame - Red, 44','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 732,'ML Road Frame - Red, 48',114,595.00,'Product ML Road Frame - Red, 48','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 733,'ML Road Frame - Red, 52',114,595.00,'Product ML Road Frame - Red, 52','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 734,'ML Road Frame - Red, 58',114,595.00,'Product ML Road Frame - Red, 58','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 735,'ML Road Frame - Red, 60',114,595.00,'Product ML Road Frame - Red, 60','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 736,'LL Road Frame - Black, 44',114,338.00,'Product LL Road Frame - Black, 44','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 737,'LL Road Frame - Black, 48',114,338.00,'Product LL Road Frame - Black, 48','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 738,'LL Road Frame - Black, 52',114,338.00,'Product LL Road Frame - Black, 52','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 739,'HL Mountain Frame - Silver, 42',112,1365.00,'Product HL Mountain Frame - Silver, 42','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 740,'HL Mountain Frame - Silver, 44',112,1365.00,'Product HL Mountain Frame - Silver, 44','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 741,'HL Mountain Frame - Silver, 48',112,1365.00,'Product HL Mountain Frame - Silver, 48','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 742,'HL Mountain Frame - Silver, 46',112,1365.00,'Product HL Mountain Frame - Silver, 46','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 743,'HL Mountain Frame - Black, 42',112,1350.00,'Product HL Mountain Frame - Black, 42','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 744,'HL Mountain Frame - Black, 44',112,1350.00,'Product HL Mountain Frame - Black, 44','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 745,'HL Mountain Frame - Black, 48',112,1350.00,'Product HL Mountain Frame - Black, 48','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 746,'HL Mountain Frame - Black, 46',112,1350.00,'Product HL Mountain Frame - Black, 46','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 747,'HL Mountain Frame - Black, 38',112,1350.00,'Product HL Mountain Frame - Black, 38','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 748,'HL Mountain Frame - Silver, 38',112,1365.00,'Product HL Mountain Frame - Silver, 38','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 749,'Road-150 Red, 62',102,3579.00,'Product Road-150 Red, 62','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 750,'Road-150 Red, 44',102,3579.00,'Product Road-150 Red, 44','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 751,'Road-150 Red, 48',102,3579.00,'Product Road-150 Red, 48','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 752,'Road-150 Red, 52',102,3579.00,'Product Road-150 Red, 52','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 753,'Road-150 Red, 56',102,3579.00,'Product Road-150 Red, 56','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 754,'Road-450 Red, 58',102,1458.00,'Product Road-450 Red, 58','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 755,'Road-450 Red, 60',102,1458.00,'Product Road-450 Red, 60','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 756,'Road-450 Red, 44',102,1458.00,'Product Road-450 Red, 44','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 757,'Road-450 Red, 48',102,1458.00,'Product Road-450 Red, 48','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 758,'Road-450 Red, 52',102,1458.00,'Product Road-450 Red, 52','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 759,'Road-650 Red, 58',102,783.00,'Product Road-650 Red, 58','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 760,'Road-650 Red, 60',102,783.00,'Product Road-650 Red, 60','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 761,'Road-650 Red, 62',102,783.00,'Product Road-650 Red, 62','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 762,'Road-650 Red, 44',102,783.00,'Product Road-650 Red, 44','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 763,'Road-650 Red, 48',102,783.00,'Product Road-650 Red, 48','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 764,'Road-650 Red, 52',102,783.00,'Product Road-650 Red, 52','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 765,'Road-650 Black, 58',102,783.00,'Product Road-650 Black, 58','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 766,'Road-650 Black, 60',102,783.00,'Product Road-650 Black, 60','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 767,'Road-650 Black, 62',102,783.00,'Product Road-650 Black, 62','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 768,'Road-650 Black, 44',102,783.00,'Product Road-650 Black, 44','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 769,'Road-650 Black, 48',102,783.00,'Product Road-650 Black, 48','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 770,'Road-650 Black, 52',102,783.00,'Product Road-650 Black, 52','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 771,'Mountain-100 Silver, 38',101,3400.00,'Product Mountain-100 Silver, 38','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 772,'Mountain-100 Silver, 42',101,3400.00,'Product Mountain-100 Silver, 42','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 773,'Mountain-100 Silver, 44',101,3400.00,'Product Mountain-100 Silver, 44','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 774,'Mountain-100 Silver, 48',101,3400.00,'Product Mountain-100 Silver, 48','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 775,'Mountain-100 Black, 38',101,3375.00,'Product Mountain-100 Black, 38','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 776,'Mountain-100 Black, 42',101,3375.00,'Product Mountain-100 Black, 42','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 777,'Mountain-100 Black, 44',101,3375.00,'Product Mountain-100 Black, 44','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 778,'Mountain-100 Black, 48',101,3375.00,'Product Mountain-100 Black, 48','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 779,'Mountain-200 Silver, 38',101,2320.00,'Product Mountain-200 Silver, 38','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 780,'Mountain-200 Silver, 42',101,2320.00,'Product Mountain-200 Silver, 42','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 781,'Mountain-200 Silver, 46',101,2320.00,'Product Mountain-200 Silver, 46','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 782,'Mountain-200 Black, 38',101,2295.00,'Product Mountain-200 Black, 38','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 783,'Mountain-200 Black, 42',101,2295.00,'Product Mountain-200 Black, 42','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 784,'Mountain-200 Black, 46',101,2295.00,'Product Mountain-200 Black, 46','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 785,'Mountain-300 Black, 38',101,1080.00,'Product Mountain-300 Black, 38','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 786,'Mountain-300 Black, 40',101,1080.00,'Product Mountain-300 Black, 40','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 787,'Mountain-300 Black, 44',101,1080.00,'Product Mountain-300 Black, 44','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 788,'Mountain-300 Black, 48',101,1080.00,'Product Mountain-300 Black, 48','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 789,'Road-250 Red, 44',102,2444.00,'Product Road-250 Red, 44','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 790,'Road-250 Red, 48',102,2444.00,'Product Road-250 Red, 48','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 791,'Road-250 Red, 52',102,2444.00,'Product Road-250 Red, 52','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 792,'Road-250 Red, 58',102,2444.00,'Product Road-250 Red, 58','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 793,'Road-250 Black, 44',102,2444.00,'Product Road-250 Black, 44','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 794,'Road-250 Black, 48',102,2444.00,'Product Road-250 Black, 48','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 795,'Road-250 Black, 52',102,2444.00,'Product Road-250 Black, 52','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 796,'Road-250 Black, 58',102,2444.00,'Product Road-250 Black, 58','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 797,'Road-550-W Yellow, 38',102,1121.00,'Product Road-550-W Yellow, 38','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 798,'Road-550-W Yellow, 40',102,1121.00,'Product Road-550-W Yellow, 40','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 799,'Road-550-W Yellow, 42',102,1121.00,'Product Road-550-W Yellow, 42','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 800,'Road-550-W Yellow, 44',102,1121.00,'Product Road-550-W Yellow, 44','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 801,'Road-550-W Yellow, 48',102,1121.00,'Product Road-550-W Yellow, 48','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 802,'LL Fork',110,149.00,'Product LL Fork','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 803,'ML Fork',110,176.00,'Product ML Fork','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 804,'HL Fork',110,230.00,'Product HL Fork','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 805,'LL Headset',111,35.00,'Product LL Headset','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 806,'ML Headset',111,103.00,'Product ML Headset','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 807,'HL Headset',111,125.00,'Product HL Headset','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 808,'LL Mountain Handlebars',104,45.00,'Product LL Mountain Handlebars','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 809,'ML Mountain Handlebars',104,62.00,'Product ML Mountain Handlebars','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 810,'HL Mountain Handlebars',104,121.00,'Product HL Mountain Handlebars','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 811,'LL Road Handlebars',104,45.00,'Product LL Road Handlebars','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 812,'ML Road Handlebars',104,62.00,'Product ML Road Handlebars','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 813,'HL Road Handlebars',104,121.00,'Product HL Road Handlebars','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 814,'ML Mountain Frame - Black, 38',112,349.00,'Product ML Mountain Frame - Black, 38','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 815,'LL Mountain Front Wheel',117,61.00,'Product LL Mountain Front Wheel','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 816,'ML Mountain Front Wheel',117,210.00,'Product ML Mountain Front Wheel','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 817,'HL Mountain Front Wheel',117,301.00,'Product HL Mountain Front Wheel','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 818,'LL Road Front Wheel',117,86.00,'Product LL Road Front Wheel','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 819,'ML Road Front Wheel',117,249.00,'Product ML Road Front Wheel','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 820,'HL Road Front Wheel',117,331.00,'Product HL Road Front Wheel','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 821,'Touring Front Wheel',117,219.00,'Product Touring Front Wheel','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 822,'ML Road Frame-W - Yellow, 38',114,595.00,'Product ML Road Frame-W - Yellow, 38','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 823,'LL Mountain Rear Wheel',117,88.00,'Product LL Mountain Rear Wheel','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 824,'ML Mountain Rear Wheel',117,237.00,'Product ML Mountain Rear Wheel','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 825,'HL Mountain Rear Wheel',117,328.00,'Product HL Mountain Rear Wheel','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 826,'LL Road Rear Wheel',117,113.00,'Product LL Road Rear Wheel','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 827,'ML Road Rear Wheel',117,276.00,'Product ML Road Rear Wheel','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 828,'HL Road Rear Wheel',117,358.00,'Product HL Road Rear Wheel','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 829,'Touring Rear Wheel',117,246.00,'Product Touring Rear Wheel','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 830,'ML Mountain Frame - Black, 40',112,349.00,'Product ML Mountain Frame - Black, 40','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 831,'ML Mountain Frame - Black, 44',112,349.00,'Product ML Mountain Frame - Black, 44','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 832,'ML Mountain Frame - Black, 48',112,349.00,'Product ML Mountain Frame - Black, 48','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 833,'ML Road Frame-W - Yellow, 40',114,595.00,'Product ML Road Frame-W - Yellow, 40','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 834,'ML Road Frame-W - Yellow, 42',114,595.00,'Product ML Road Frame-W - Yellow, 42','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 835,'ML Road Frame-W - Yellow, 44',114,595.00,'Product ML Road Frame-W - Yellow, 44','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 836,'ML Road Frame-W - Yellow, 48',114,595.00,'Product ML Road Frame-W - Yellow, 48','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 837,'HL Road Frame - Black, 62',114,1432.00,'Product HL Road Frame - Black, 62','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 838,'HL Road Frame - Black, 44',114,1432.00,'Product HL Road Frame - Black, 44','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 839,'HL Road Frame - Black, 48',114,1432.00,'Product HL Road Frame - Black, 48','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 840,'HL Road Frame - Black, 52',114,1432.00,'Product HL Road Frame - Black, 52','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 841,'Men''s Sports Shorts, S',122,60.00,'Product Men''s Sports Shorts, S','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 842,'Touring-Panniers, Large',135,125.00,'Product Touring-Panniers, Large','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 843,'Cable Lock',134,25.00,'Product Cable Lock','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 844,'Minipump',136,20.00,'Product Minipump','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 845,'Mountain Pump',136,25.00,'Product Mountain Pump','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 846,'Taillights - Battery-Powered',133,14.00,'Product Taillights - Battery-Powered','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 847,'Headlights - Dual-Beam',133,35.00,'Product Headlights - Dual-Beam','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 848,'Headlights - Weatherproof',133,45.00,'Product Headlights - Weatherproof','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 849,'Men''s Sports Shorts, M',122,60.00,'Product Men''s Sports Shorts, M','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 850,'Men''s Sports Shorts, L',122,60.00,'Product Men''s Sports Shorts, L','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 851,'Men''s Sports Shorts, XL',122,60.00,'Product Men''s Sports Shorts, XL','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 852,'Women''s Tights, S',124,75.00,'Product Women''s Tights, S','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 853,'Women''s Tights, M',124,75.00,'Product Women''s Tights, M','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 854,'Women''s Tights, L',124,75.00,'Product Women''s Tights, L','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 855,'Men''s Bib-Shorts, S',118,90.00,'Product Men''s Bib-Shorts, S','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 856,'Men''s Bib-Shorts, M',118,90.00,'Product Men''s Bib-Shorts, M','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 857,'Men''s Bib-Shorts, L',118,90.00,'Product Men''s Bib-Shorts, L','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 858,'Half-Finger Gloves, S',120,25.00,'Product Half-Finger Gloves, S','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 859,'Half-Finger Gloves, M',120,25.00,'Product Half-Finger Gloves, M','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 860,'Half-Finger Gloves, L',120,25.00,'Product Half-Finger Gloves, L','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 861,'Full-Finger Gloves, S',120,38.00,'Product Full-Finger Gloves, S','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 862,'Full-Finger Gloves, M',120,38.00,'Product Full-Finger Gloves, M','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 863,'Full-Finger Gloves, L',120,38.00,'Product Full-Finger Gloves, L','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 864,'Classic Vest, S',125,64.00,'Product Classic Vest, S','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 865,'Classic Vest, M',125,64.00,'Product Classic Vest, M','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 866,'Classic Vest, L',125,64.00,'Product Classic Vest, L','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 867,'Women''s Mountain Shorts, S',122,70.00,'Product Women''s Mountain Shorts, S','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 868,'Women''s Mountain Shorts, M',122,70.00,'Product Women''s Mountain Shorts, M','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 869,'Women''s Mountain Shorts, L',122,70.00,'Product Women''s Mountain Shorts, L','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 870,'Water Bottle - 30 oz.',128,5.00,'Product Water Bottle - 30 oz.','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 871,'Mountain Bottle Cage',128,10.00,'Product Mountain Bottle Cage','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 872,'Road Bottle Cage',128,9.00,'Product Road Bottle Cage','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 873,'Patch Kit/8 Patches',137,3.00,'Product Patch Kit/8 Patches','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 874,'Racing Socks, M',123,9.00,'Product Racing Socks, M','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 875,'Racing Socks, L',123,9.00,'Product Racing Socks, L','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 876,'Hitch Rack - 4-Bike',126,120.00,'Product Hitch Rack - 4-Bike','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 877,'Bike Wash - Dissolver',129,8.00,'Product Bike Wash - Dissolver','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 878,'Fender Set - Mountain',130,22.00,'Product Fender Set - Mountain','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 879,'All-Purpose Bike Stand',127,159.00,'Product All-Purpose Bike Stand','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 880,'Hydration Pack - 70 oz.',132,55.00,'Product Hydration Pack - 70 oz.','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 881,'Short-Sleeve Classic Jersey, S',121,54.00,'Product Short-Sleeve Classic Jersey, S','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 882,'Short-Sleeve Classic Jersey, M',121,54.00,'Product Short-Sleeve Classic Jersey, M','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 883,'Short-Sleeve Classic Jersey, L',121,54.00,'Product Short-Sleeve Classic Jersey, L','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 884,'Short-Sleeve Classic Jersey, XL',121,54.00,'Product Short-Sleeve Classic Jersey, XL','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 885,'HL Touring Frame - Yellow, 60',116,1004.00,'Product HL Touring Frame - Yellow, 60','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 886,'LL Touring Frame - Yellow, 62',116,334.00,'Product LL Touring Frame - Yellow, 62','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 887,'HL Touring Frame - Yellow, 46',116,1004.00,'Product HL Touring Frame - Yellow, 46','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 888,'HL Touring Frame - Yellow, 50',116,1004.00,'Product HL Touring Frame - Yellow, 50','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 889,'HL Touring Frame - Yellow, 54',116,1004.00,'Product HL Touring Frame - Yellow, 54','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 890,'HL Touring Frame - Blue, 46',116,1004.00,'Product HL Touring Frame - Blue, 46','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 891,'HL Touring Frame - Blue, 50',116,1004.00,'Product HL Touring Frame - Blue, 50','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 892,'HL Touring Frame - Blue, 54',116,1004.00,'Product HL Touring Frame - Blue, 54','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 893,'HL Touring Frame - Blue, 60',116,1004.00,'Product HL Touring Frame - Blue, 60','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 894,'Rear Derailleur',109,122.00,'Product Rear Derailleur','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 895,'LL Touring Frame - Blue, 50',116,334.00,'Product LL Touring Frame - Blue, 50','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 896,'LL Touring Frame - Blue, 54',116,334.00,'Product LL Touring Frame - Blue, 54','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 897,'LL Touring Frame - Blue, 58',116,334.00,'Product LL Touring Frame - Blue, 58','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 898,'LL Touring Frame - Blue, 62',116,334.00,'Product LL Touring Frame - Blue, 62','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 899,'LL Touring Frame - Yellow, 44',116,334.00,'Product LL Touring Frame - Yellow, 44','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 900,'LL Touring Frame - Yellow, 50',116,334.00,'Product LL Touring Frame - Yellow, 50','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 901,'LL Touring Frame - Yellow, 54',116,334.00,'Product LL Touring Frame - Yellow, 54','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 902,'LL Touring Frame - Yellow, 58',116,334.00,'Product LL Touring Frame - Yellow, 58','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 903,'LL Touring Frame - Blue, 44',116,334.00,'Product LL Touring Frame - Blue, 44','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 904,'ML Mountain Frame-W - Silver, 40',112,365.00,'Product ML Mountain Frame-W - Silver, 40','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 905,'ML Mountain Frame-W - Silver, 42',112,365.00,'Product ML Mountain Frame-W - Silver, 42','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 906,'ML Mountain Frame-W - Silver, 46',112,365.00,'Product ML Mountain Frame-W - Silver, 46','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 907,'Rear Brakes',106,107.00,'Product Rear Brakes','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 908,'LL Mountain Seat/Saddle',115,28.00,'Product LL Mountain Seat/Saddle','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 909,'ML Mountain Seat/Saddle',115,40.00,'Product ML Mountain Seat/Saddle','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 910,'HL Mountain Seat/Saddle',115,53.00,'Product HL Mountain Seat/Saddle','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 911,'LL Road Seat/Saddle',115,28.00,'Product LL Road Seat/Saddle','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 912,'ML Road Seat/Saddle',115,40.00,'Product ML Road Seat/Saddle','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 913,'HL Road Seat/Saddle',115,53.00,'Product HL Road Seat/Saddle','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 914,'LL Touring Seat/Saddle',115,28.00,'Product LL Touring Seat/Saddle','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 915,'ML Touring Seat/Saddle',115,40.00,'Product ML Touring Seat/Saddle','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 916,'HL Touring Seat/Saddle',115,53.00,'Product HL Touring Seat/Saddle','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 917,'LL Mountain Frame - Silver, 42',112,265.00,'Product LL Mountain Frame - Silver, 42','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 918,'LL Mountain Frame - Silver, 44',112,265.00,'Product LL Mountain Frame - Silver, 44','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 919,'LL Mountain Frame - Silver, 48',112,265.00,'Product LL Mountain Frame - Silver, 48','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 920,'LL Mountain Frame - Silver, 52',112,265.00,'Product LL Mountain Frame - Silver, 52','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 921,'Mountain Tire Tube',137,5.00,'Product Mountain Tire Tube','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 922,'Road Tire Tube',137,4.00,'Product Road Tire Tube','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 923,'Touring Tire Tube',137,5.00,'Product Touring Tire Tube','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 924,'LL Mountain Frame - Black, 42',112,250.00,'Product LL Mountain Frame - Black, 42','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 925,'LL Mountain Frame - Black, 44',112,250.00,'Product LL Mountain Frame - Black, 44','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 926,'LL Mountain Frame - Black, 48',112,250.00,'Product LL Mountain Frame - Black, 48','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 927,'LL Mountain Frame - Black, 52',112,250.00,'Product LL Mountain Frame - Black, 52','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 928,'LL Mountain Tire',137,25.00,'Product LL Mountain Tire','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 929,'ML Mountain Tire',137,30.00,'Product ML Mountain Tire','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 930,'HL Mountain Tire',137,35.00,'Product HL Mountain Tire','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 931,'LL Road Tire',137,22.00,'Product LL Road Tire','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 932,'ML Road Tire',137,25.00,'Product ML Road Tire','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 933,'HL Road Tire',137,33.00,'Product HL Road Tire','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 934,'Touring Tire',137,29.00,'Product Touring Tire','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 935,'LL Mountain Pedal',113,41.00,'Product LL Mountain Pedal','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 936,'ML Mountain Pedal',113,63.00,'Product ML Mountain Pedal','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 937,'HL Mountain Pedal',113,81.00,'Product HL Mountain Pedal','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 938,'LL Road Pedal',113,41.00,'Product LL Road Pedal','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 939,'ML Road Pedal',113,63.00,'Product ML Road Pedal','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 940,'HL Road Pedal',113,81.00,'Product HL Road Pedal','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 941,'Touring Pedal',113,81.00,'Product Touring Pedal','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 942,'ML Mountain Frame-W - Silver, 38',112,365.00,'Product ML Mountain Frame-W - Silver, 38','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 943,'LL Mountain Frame - Black, 40',112,250.00,'Product LL Mountain Frame - Black, 40','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 944,'LL Mountain Frame - Silver, 40',112,265.00,'Product LL Mountain Frame - Silver, 40','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 945,'Front Derailleur',109,92.00,'Product Front Derailleur','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 946,'LL Touring Handlebars',104,47.00,'Product LL Touring Handlebars','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 947,'HL Touring Handlebars',104,92.00,'Product HL Touring Handlebars','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 948,'Front Brakes',106,107.00,'Product Front Brakes','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 949,'LL Crankset',108,176.00,'Product LL Crankset','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 950,'ML Crankset',108,257.00,'Product ML Crankset','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 951,'HL Crankset',108,405.00,'Product HL Crankset','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 952,'Chain',107,21.00,'Product Chain','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 953,'Touring-2000 Blue, 60',103,1215.00,'Product Touring-2000 Blue, 60','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 954,'Touring-1000 Yellow, 46',103,2385.00,'Product Touring-1000 Yellow, 46','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 955,'Touring-1000 Yellow, 50',103,2385.00,'Product Touring-1000 Yellow, 50','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 956,'Touring-1000 Yellow, 54',103,2385.00,'Product Touring-1000 Yellow, 54','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 957,'Touring-1000 Yellow, 60',103,2385.00,'Product Touring-1000 Yellow, 60','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 958,'Touring-3000 Blue, 54',103,743.00,'Product Touring-3000 Blue, 54','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 959,'Touring-3000 Blue, 58',103,743.00,'Product Touring-3000 Blue, 58','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 960,'Touring-3000 Blue, 62',103,743.00,'Product Touring-3000 Blue, 62','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 961,'Touring-3000 Yellow, 44',103,743.00,'Product Touring-3000 Yellow, 44','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 962,'Touring-3000 Yellow, 50',103,743.00,'Product Touring-3000 Yellow, 50','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 963,'Touring-3000 Yellow, 54',103,743.00,'Product Touring-3000 Yellow, 54','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 964,'Touring-3000 Yellow, 58',103,743.00,'Product Touring-3000 Yellow, 58','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 965,'Touring-3000 Yellow, 62',103,743.00,'Product Touring-3000 Yellow, 62','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 966,'Touring-1000 Blue, 46',103,2385.00,'Product Touring-1000 Blue, 46','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 967,'Touring-1000 Blue, 50',103,2385.00,'Product Touring-1000 Blue, 50','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 968,'Touring-1000 Blue, 54',103,2385.00,'Product Touring-1000 Blue, 54','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 969,'Touring-1000 Blue, 60',103,2385.00,'Product Touring-1000 Blue, 60','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 970,'Touring-2000 Blue, 46',103,1215.00,'Product Touring-2000 Blue, 46','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 971,'Touring-2000 Blue, 50',103,1215.00,'Product Touring-2000 Blue, 50','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 972,'Touring-2000 Blue, 54',103,1215.00,'Product Touring-2000 Blue, 54','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 973,'Road-350-W Yellow, 40',102,1701.00,'Product Road-350-W Yellow, 40','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 974,'Road-350-W Yellow, 42',102,1701.00,'Product Road-350-W Yellow, 42','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 975,'Road-350-W Yellow, 44',102,1701.00,'Product Road-350-W Yellow, 44','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 976,'Road-350-W Yellow, 48',102,1701.00,'Product Road-350-W Yellow, 48','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 977,'Road-750 Black, 58',102,540.00,'Product Road-750 Black, 58','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 978,'Touring-3000 Blue, 44',103,743.00,'Product Touring-3000 Blue, 44','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 979,'Touring-3000 Blue, 50',103,743.00,'Product Touring-3000 Blue, 50','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 980,'Mountain-400-W Silver, 38',101,770.00,'Product Mountain-400-W Silver, 38','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 981,'Mountain-400-W Silver, 40',101,770.00,'Product Mountain-400-W Silver, 40','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 982,'Mountain-400-W Silver, 42',101,770.00,'Product Mountain-400-W Silver, 42','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 983,'Mountain-400-W Silver, 46',101,770.00,'Product Mountain-400-W Silver, 46','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 984,'Mountain-500 Silver, 40',101,565.00,'Product Mountain-500 Silver, 40','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 985,'Mountain-500 Silver, 42',101,565.00,'Product Mountain-500 Silver, 42','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 986,'Mountain-500 Silver, 44',101,565.00,'Product Mountain-500 Silver, 44','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 987,'Mountain-500 Silver, 48',101,565.00,'Product Mountain-500 Silver, 48','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 988,'Mountain-500 Silver, 52',101,565.00,'Product Mountain-500 Silver, 52','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 989,'Mountain-500 Black, 40',101,540.00,'Product Mountain-500 Black, 40','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 990,'Mountain-500 Black, 42',101,540.00,'Product Mountain-500 Black, 42','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 991,'Mountain-500 Black, 44',101,540.00,'Product Mountain-500 Black, 44','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 992,'Mountain-500 Black, 48',101,540.00,'Product Mountain-500 Black, 48','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 993,'Mountain-500 Black, 52',101,540.00,'Product Mountain-500 Black, 52','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 994,'LL Bottom Bracket',105,54.00,'Product LL Bottom Bracket','https://www.apple.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 995,'ML Bottom Bracket',105,102.00,'Product ML Bottom Bracket','https://www.samsung.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 996,'HL Bottom Bracket',105,122.00,'Product HL Bottom Bracket','https://www.ebay.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 997,'Road-750 Black, 44',102,540.00,'Product Road-750 Black, 44','https://www.flipkart.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 998,'Road-750 Black, 48',102,540.00,'Product Road-750 Black, 48','https://www.snapdeal.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo' UNION ALL 
SELECT 999,'Road-750 Black, 52',102,540.00,'Product Road-750 Black, 52','https://www.amazon.com/','2023-03-12 12:47:53.810','2023-03-12 12:47:53.810','dbo'


INSERT INTO [dbo].[Order_Products] (order_id,product_id,quantity,created_on,created_by)
SELECT 501,712,12,'2023-03-12 12:32:09.470','dbo' UNION ALL
SELECT 502,845,45,'2023-03-12 12:32:09.471','dbo' UNION ALL
SELECT 503,836,36,'2023-03-12 12:32:09.472','dbo' UNION ALL
SELECT 504,952,52,'2023-03-12 12:32:09.473','dbo' UNION ALL
SELECT 505,890,90,'2023-03-12 12:32:09.474','dbo' UNION ALL
SELECT 506,785,85,'2023-03-12 12:32:09.475','dbo' UNION ALL
SELECT 507,737,37,'2023-03-12 12:32:09.476','dbo' UNION ALL
SELECT 508,870,70,'2023-03-12 12:32:09.477','dbo' UNION ALL
SELECT 509,808,8,'2023-03-12 12:32:09.478','dbo' UNION ALL
SELECT 510,856,56,'2023-03-12 12:32:09.479','dbo' UNION ALL
SELECT 511,901,1,'2023-03-12 12:32:09.480','dbo' UNION ALL
SELECT 512,998,98,'2023-03-12 12:32:09.481','dbo' UNION ALL
SELECT 513,938,38,'2023-03-12 12:32:09.482','dbo' UNION ALL
SELECT 514,909,9,'2023-03-12 12:32:09.483','dbo' UNION ALL
SELECT 515,992,92,'2023-03-12 12:32:09.484','dbo' UNION ALL
SELECT 516,929,29,'2023-03-12 12:32:09.485','dbo' UNION ALL
SELECT 517,812,12,'2023-03-12 12:32:09.486','dbo' UNION ALL
SELECT 518,963,63,'2023-03-12 12:32:09.487','dbo' UNION ALL
SELECT 519,786,86,'2023-03-12 12:32:09.488','dbo' UNION ALL
SELECT 520,813,13,'2023-03-12 12:32:09.489','dbo' UNION ALL
SELECT 521,792,92,'2023-03-12 12:32:09.490','dbo' UNION ALL
SELECT 522,924,24,'2023-03-12 12:32:09.491','dbo' UNION ALL
SELECT 523,751,51,'2023-03-12 12:32:09.492','dbo' UNION ALL
SELECT 524,877,77,'2023-03-12 12:32:09.493','dbo' UNION ALL
SELECT 525,718,18,'2023-03-12 12:32:09.494','dbo' UNION ALL
SELECT 526,768,68,'2023-03-12 12:32:09.495','dbo' UNION ALL
SELECT 527,767,67,'2023-03-12 12:32:09.496','dbo' UNION ALL
SELECT 528,829,29,'2023-03-12 12:32:09.497','dbo' UNION ALL
SELECT 529,854,54,'2023-03-12 12:32:09.498','dbo' UNION ALL
SELECT 530,777,77,'2023-03-12 12:32:09.499','dbo' UNION ALL
SELECT 531,746,46,'2023-03-12 12:32:09.500','dbo' UNION ALL
SELECT 532,865,65,'2023-03-12 12:32:09.501','dbo' UNION ALL
SELECT 533,847,47,'2023-03-12 12:32:09.502','dbo' UNION ALL
SELECT 534,816,16,'2023-03-12 12:32:09.503','dbo' UNION ALL
SELECT 535,820,20,'2023-03-12 12:32:09.504','dbo' UNION ALL
SELECT 536,797,97,'2023-03-12 12:32:09.505','dbo' UNION ALL
SELECT 537,823,23,'2023-03-12 12:32:09.506','dbo' UNION ALL
SELECT 538,913,13,'2023-03-12 12:32:09.507','dbo' UNION ALL
SELECT 539,991,91,'2023-03-12 12:32:09.508','dbo' UNION ALL
SELECT 540,873,73,'2023-03-12 12:32:09.509','dbo' UNION ALL
SELECT 541,979,79,'2023-03-12 12:32:09.510','dbo' UNION ALL
SELECT 542,719,19,'2023-03-12 12:32:09.511','dbo' UNION ALL
SELECT 543,858,58,'2023-03-12 12:32:09.512','dbo' UNION ALL
SELECT 544,960,60,'2023-03-12 12:32:09.513','dbo' UNION ALL
SELECT 545,866,66,'2023-03-12 12:32:09.514','dbo' UNION ALL
SELECT 546,864,64,'2023-03-12 12:32:09.515','dbo' UNION ALL
SELECT 547,921,21,'2023-03-12 12:32:09.516','dbo' UNION ALL
SELECT 548,835,35,'2023-03-12 12:32:09.517','dbo' UNION ALL
SELECT 549,941,41,'2023-03-12 12:32:09.518','dbo' UNION ALL
SELECT 550,734,34,'2023-03-12 12:32:09.519','dbo' UNION ALL
SELECT 551,762,62,'2023-03-12 12:32:09.520','dbo' UNION ALL
SELECT 552,756,56,'2023-03-12 12:32:09.521','dbo' UNION ALL
SELECT 553,709,9,'2023-03-12 12:32:09.522','dbo' UNION ALL
SELECT 554,879,79,'2023-03-12 12:32:09.523','dbo' UNION ALL
SELECT 555,888,88,'2023-03-12 12:32:09.524','dbo' UNION ALL
SELECT 556,997,97,'2023-03-12 12:32:09.525','dbo' UNION ALL
SELECT 557,769,69,'2023-03-12 12:32:09.526','dbo' UNION ALL
SELECT 558,852,52,'2023-03-12 12:32:09.527','dbo' UNION ALL
SELECT 559,726,26,'2023-03-12 12:32:09.528','dbo' UNION ALL
SELECT 560,904,4,'2023-03-12 12:32:09.529','dbo' UNION ALL
SELECT 561,962,62,'2023-03-12 12:32:09.530','dbo' UNION ALL
SELECT 562,953,53,'2023-03-12 12:32:09.531','dbo' UNION ALL
SELECT 563,880,80,'2023-03-12 12:32:09.532','dbo' UNION ALL
SELECT 564,779,79,'2023-03-12 12:32:09.533','dbo' UNION ALL
SELECT 565,827,27,'2023-03-12 12:32:09.534','dbo' UNION ALL
SELECT 566,802,2,'2023-03-12 12:32:09.535','dbo' UNION ALL
SELECT 567,914,14,'2023-03-12 12:32:09.536','dbo' UNION ALL
SELECT 568,886,86,'2023-03-12 12:32:09.537','dbo' UNION ALL
SELECT 569,903,3,'2023-03-12 12:32:09.538','dbo' UNION ALL
SELECT 570,989,89,'2023-03-12 12:32:09.539','dbo' UNION ALL
SELECT 571,776,76,'2023-03-12 12:32:09.540','dbo' UNION ALL
SELECT 572,707,7,'2023-03-12 12:32:09.541','dbo' UNION ALL
SELECT 573,736,36,'2023-03-12 12:32:09.542','dbo' UNION ALL
SELECT 574,782,82,'2023-03-12 12:32:09.543','dbo' UNION ALL
SELECT 575,984,84,'2023-03-12 12:32:09.544','dbo' UNION ALL
SELECT 576,764,64,'2023-03-12 12:32:09.545','dbo' UNION ALL
SELECT 577,910,10,'2023-03-12 12:32:09.546','dbo' UNION ALL
SELECT 578,720,20,'2023-03-12 12:32:09.547','dbo' UNION ALL
SELECT 579,822,22,'2023-03-12 12:32:09.548','dbo' UNION ALL
SELECT 580,814,14,'2023-03-12 12:32:09.549','dbo' UNION ALL
SELECT 581,800,0,'2023-03-12 12:32:09.550','dbo' UNION ALL
SELECT 582,723,23,'2023-03-12 12:32:09.551','dbo' UNION ALL
SELECT 583,784,84,'2023-03-12 12:32:09.552','dbo' UNION ALL
SELECT 584,943,43,'2023-03-12 12:32:09.553','dbo' UNION ALL
SELECT 585,971,71,'2023-03-12 12:32:09.554','dbo' UNION ALL
SELECT 586,881,81,'2023-03-12 12:32:09.555','dbo' UNION ALL
SELECT 587,843,43,'2023-03-12 12:32:09.556','dbo' UNION ALL
SELECT 588,919,19,'2023-03-12 12:32:09.557','dbo' UNION ALL
SELECT 589,878,78,'2023-03-12 12:32:09.558','dbo' UNION ALL
SELECT 590,796,96,'2023-03-12 12:32:09.559','dbo' UNION ALL
SELECT 591,949,49,'2023-03-12 12:32:09.560','dbo' UNION ALL
SELECT 592,862,62,'2023-03-12 12:32:09.561','dbo' UNION ALL
SELECT 593,710,10,'2023-03-12 12:32:09.562','dbo' UNION ALL
SELECT 594,918,18,'2023-03-12 12:32:09.563','dbo' UNION ALL
SELECT 595,759,59,'2023-03-12 12:32:09.564','dbo' UNION ALL
SELECT 596,993,93,'2023-03-12 12:32:09.565','dbo' UNION ALL
SELECT 597,869,69,'2023-03-12 12:32:09.566','dbo' UNION ALL
SELECT 598,857,57,'2023-03-12 12:32:09.567','dbo' UNION ALL
SELECT 599,730,30,'2023-03-12 12:32:09.568','dbo' UNION ALL
SELECT 600,711,11,'2023-03-12 12:32:09.569','dbo' UNION ALL
SELECT 601,849,49,'2023-03-12 12:32:09.570','dbo' UNION ALL
SELECT 602,999,99,'2023-03-12 12:32:09.571','dbo' UNION ALL
SELECT 603,969,69,'2023-03-12 12:32:09.572','dbo' UNION ALL
SELECT 604,778,78,'2023-03-12 12:32:09.573','dbo' UNION ALL
SELECT 605,817,17,'2023-03-12 12:32:09.574','dbo' UNION ALL
SELECT 606,742,42,'2023-03-12 12:32:09.575','dbo' UNION ALL
SELECT 607,928,28,'2023-03-12 12:32:09.576','dbo' UNION ALL
SELECT 608,724,24,'2023-03-12 12:32:09.577','dbo' UNION ALL
SELECT 609,821,21,'2023-03-12 12:32:09.578','dbo' UNION ALL
SELECT 610,974,74,'2023-03-12 12:32:09.579','dbo' UNION ALL
SELECT 611,824,24,'2023-03-12 12:32:09.580','dbo' UNION ALL
SELECT 612,876,76,'2023-03-12 12:32:09.581','dbo' UNION ALL
SELECT 613,863,63,'2023-03-12 12:32:09.582','dbo' UNION ALL
SELECT 614,815,15,'2023-03-12 12:32:09.583','dbo' UNION ALL
SELECT 615,780,80,'2023-03-12 12:32:09.584','dbo' UNION ALL
SELECT 616,733,33,'2023-03-12 12:32:09.585','dbo' UNION ALL
SELECT 617,834,34,'2023-03-12 12:32:09.586','dbo' UNION ALL
SELECT 618,922,22,'2023-03-12 12:32:09.587','dbo' UNION ALL
SELECT 619,916,16,'2023-03-12 12:32:09.588','dbo' UNION ALL
SELECT 620,920,20,'2023-03-12 12:32:09.589','dbo' UNION ALL
SELECT 621,826,26,'2023-03-12 12:32:09.590','dbo' UNION ALL
SELECT 622,757,57,'2023-03-12 12:32:09.591','dbo' UNION ALL
SELECT 623,763,63,'2023-03-12 12:32:09.592','dbo' UNION ALL
SELECT 624,908,8,'2023-03-12 12:32:09.593','dbo' UNION ALL
SELECT 625,842,42,'2023-03-12 12:32:09.594','dbo' UNION ALL
SELECT 626,819,19,'2023-03-12 12:32:09.595','dbo' UNION ALL
SELECT 627,729,29,'2023-03-12 12:32:09.596','dbo' UNION ALL
SELECT 628,934,34,'2023-03-12 12:32:09.597','dbo' UNION ALL
SELECT 629,706,6,'2023-03-12 12:32:09.598','dbo' UNION ALL
SELECT 630,774,74,'2023-03-12 12:32:09.599','dbo' UNION ALL
SELECT 631,828,28,'2023-03-12 12:32:09.600','dbo' UNION ALL
SELECT 632,840,40,'2023-03-12 12:32:09.601','dbo' UNION ALL
SELECT 633,937,37,'2023-03-12 12:32:09.602','dbo' UNION ALL
SELECT 634,825,25,'2023-03-12 12:32:09.603','dbo' UNION ALL
SELECT 635,917,17,'2023-03-12 12:32:09.604','dbo' UNION ALL
SELECT 636,803,3,'2023-03-12 12:32:09.605','dbo' UNION ALL
SELECT 637,945,45,'2023-03-12 12:32:09.606','dbo' UNION ALL
SELECT 638,795,95,'2023-03-12 12:32:09.607','dbo' UNION ALL
SELECT 639,891,91,'2023-03-12 12:32:09.608','dbo' UNION ALL
SELECT 640,851,51,'2023-03-12 12:32:09.609','dbo' UNION ALL
SELECT 641,731,31,'2023-03-12 12:32:09.610','dbo' UNION ALL
SELECT 642,925,25,'2023-03-12 12:32:09.611','dbo' UNION ALL
SELECT 643,889,89,'2023-03-12 12:32:09.612','dbo' UNION ALL
SELECT 644,936,36,'2023-03-12 12:32:09.613','dbo' UNION ALL
SELECT 645,987,87,'2023-03-12 12:32:09.614','dbo' UNION ALL
SELECT 646,727,27,'2023-03-12 12:32:09.615','dbo' UNION ALL
SELECT 647,902,2,'2023-03-12 12:32:09.616','dbo' UNION ALL
SELECT 648,995,95,'2023-03-12 12:32:09.617','dbo' UNION ALL
SELECT 649,958,58,'2023-03-12 12:32:09.618','dbo' UNION ALL
SELECT 650,752,52,'2023-03-12 12:32:09.619','dbo' UNION ALL
SELECT 651,755,55,'2023-03-12 12:32:09.620','dbo' UNION ALL
SELECT 652,805,5,'2023-03-12 12:32:09.621','dbo' UNION ALL
SELECT 653,976,76,'2023-03-12 12:32:09.622','dbo' UNION ALL
SELECT 654,806,6,'2023-03-12 12:32:09.623','dbo' UNION ALL
SELECT 655,772,72,'2023-03-12 12:32:09.624','dbo' UNION ALL
SELECT 656,758,58,'2023-03-12 12:32:09.625','dbo' UNION ALL
SELECT 657,732,32,'2023-03-12 12:32:09.626','dbo' UNION ALL
SELECT 658,944,44,'2023-03-12 12:32:09.627','dbo' UNION ALL
SELECT 659,932,32,'2023-03-12 12:32:09.628','dbo' UNION ALL
SELECT 660,972,72,'2023-03-12 12:32:09.629','dbo' UNION ALL
SELECT 661,743,43,'2023-03-12 12:32:09.630','dbo' UNION ALL
SELECT 662,915,15,'2023-03-12 12:32:09.631','dbo' UNION ALL
SELECT 663,787,87,'2023-03-12 12:32:09.632','dbo' UNION ALL
SELECT 664,713,13,'2023-03-12 12:32:09.633','dbo' UNION ALL
SELECT 665,966,66,'2023-03-12 12:32:09.634','dbo' UNION ALL
SELECT 666,859,59,'2023-03-12 12:32:09.635','dbo' UNION ALL
SELECT 667,982,82,'2023-03-12 12:32:09.636','dbo' UNION ALL
SELECT 668,996,96,'2023-03-12 12:32:09.637','dbo' UNION ALL
SELECT 669,951,51,'2023-03-12 12:32:09.638','dbo' UNION ALL
SELECT 670,957,57,'2023-03-12 12:32:09.639','dbo' UNION ALL
SELECT 671,965,65,'2023-03-12 12:32:09.640','dbo' UNION ALL
SELECT 672,896,96,'2023-03-12 12:32:09.641','dbo' UNION ALL
SELECT 673,898,98,'2023-03-12 12:32:09.642','dbo' UNION ALL
SELECT 674,930,30,'2023-03-12 12:32:09.643','dbo' UNION ALL
SELECT 675,959,59,'2023-03-12 12:32:09.644','dbo' UNION ALL
SELECT 676,790,90,'2023-03-12 12:32:09.645','dbo' UNION ALL
SELECT 677,931,31,'2023-03-12 12:32:09.646','dbo' UNION ALL
SELECT 678,807,7,'2023-03-12 12:32:09.647','dbo' UNION ALL
SELECT 679,725,25,'2023-03-12 12:32:09.648','dbo' UNION ALL
SELECT 680,947,47,'2023-03-12 12:32:09.649','dbo' UNION ALL
SELECT 681,946,46,'2023-03-12 12:32:09.650','dbo' UNION ALL
SELECT 682,754,54,'2023-03-12 12:32:09.651','dbo' UNION ALL
SELECT 683,749,49,'2023-03-12 12:32:09.652','dbo' UNION ALL
SELECT 684,940,40,'2023-03-12 12:32:09.653','dbo' UNION ALL
SELECT 685,885,85,'2023-03-12 12:32:09.654','dbo' UNION ALL
SELECT 686,739,39,'2023-03-12 12:32:09.655','dbo' UNION ALL
SELECT 687,894,94,'2023-03-12 12:32:09.656','dbo' UNION ALL
SELECT 688,905,5,'2023-03-12 12:32:09.657','dbo' UNION ALL
SELECT 689,942,42,'2023-03-12 12:32:09.658','dbo' UNION ALL
SELECT 690,985,85,'2023-03-12 12:32:09.659','dbo' UNION ALL
SELECT 691,933,33,'2023-03-12 12:32:09.660','dbo' UNION ALL
SELECT 692,907,7,'2023-03-12 12:32:09.661','dbo' UNION ALL
SELECT 693,899,99,'2023-03-12 12:32:09.662','dbo' UNION ALL
SELECT 694,883,83,'2023-03-12 12:32:09.663','dbo' UNION ALL
SELECT 695,680,80,'2023-03-12 12:32:09.664','dbo' UNION ALL
SELECT 696,833,33,'2023-03-12 12:32:09.665','dbo' UNION ALL
SELECT 697,750,50,'2023-03-12 12:32:09.666','dbo' UNION ALL
SELECT 698,831,31,'2023-03-12 12:32:09.667','dbo' UNION ALL
SELECT 699,994,94,'2023-03-12 12:32:09.668','dbo' UNION ALL
SELECT 700,860,60,'2023-03-12 12:32:09.669','dbo'
