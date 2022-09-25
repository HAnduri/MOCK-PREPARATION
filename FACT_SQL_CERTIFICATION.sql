DIM_CUST_1_SQL_IN1542

select * from FACT_SALES_infa_IN1542
CREATE TABLE FACT_SALES_SQL_IN1542(

OREDER_NO	BIGINT	NOT NULL                      ,
LINE_NO	INTEGER	NOT NULL						  ,
CUSTOMER_ID	VARCHAR(50)	NOT NULL				  ,
ITEM_KEY	INTEGER	NOT NULL					  ,
UPC	VARCHAR(255)							  ,
SERVICE_ID	INTEGER	NOT NULL					  ,
QUANTITY	INTEGER							  ,
ITEM_PRICE	FLOAT							  ,
ITEM_COST	FLOAT							  ,
Order_Amt	FLOAT							  ,
PRODUCT_TAX	FLOAT							  ,
GIFTWRAP_TAX	FLOAT						  ,
SHIPPING_TAX	FLOAT						  ,
SHIPPING_CHARGES	FLOAT					  ,
GIFTWRAP_CHARGES	FLOAT					  ,
SHIP_TO_CUSTOMER_ADDRESS_ID	INTEGER	NOT NULL	  ,
AUTH_DATE	VARCHAR(255)					  ,
ADJUST_DATE	DATETIME						  ,
AUTH_AMOUNT	FLOAT							  ,
AUTH_COST	FLOAT							  ,
TOTAL_TAX FLOAT		,
TOTAL_CHARGES FLOAT		)

DA_C2_Src.S_Sales
DA_C2_Src.Dim_Item
DIM_CUST_1_SQL_IN1542


 TRUNCATE TABLE FACT_SALES_SQL_IN1542
INSERT INTO FACT_SALES_SQL_IN1542
SELECT *,
(K.PRODUCT_TAX + K.GIFTWRAP_TAX +K.SHIPPING_TAX) TOTAL_TAX,
(K.SHIPPING_CHARGES + K.GIFTWRAP_CHARGES) TOTAL_CHARGES
FROM
(
SELECT 
IIF(S.[Order_No] IS NULL OR ISNUMERIC(S.[Order_No])=0,-1,CONVERT(BIGINT,(S.[Order_No])))
OREDER_NO
,IIF(S.[Line_No] IS NULL ,-1,S.[Line_No])LINE_NO
,IIF(S.[Customer_Id] IS NULL,'NA',CONVERT(VARCHAR(50),[Customer_Id]))CUSTOMER_ID
,IIF(I.[Item_Key] IS NULL,-1,I.[Item_Key])  ITEM_KEY
,I.[UPC]  UPC
,IIF(S.[service_id] IS NULL,-1,S.[service_id]) SERVICE_ID
,CONVERT(INT,S.[Quantity])  QUANTITY
,S.[Item_Price] ITEM_PRICE
,S.[Item_Cost] ITEM_COST
,(S.[Item_Price]*S.[Quantity])     Order_Amt
,SUM(S.[Product_Tax]) PRODUCT_TAX
,SUM(S.[giftwrap_tax]) GIFTWRAP_TAX
,SUM(S.[shipping_tax]) SHIPPING_TAX
,SUM(S.[shipping_charges])SHIPPING_CHARGES
,SUM(S.[giftwrap_charges])  GIFTWRAP_CHARGES
,IIF(S.SHIP_TO_CUSTOMER_ADDRESS_ID IS NULL,-1,CONVERT(INT,S.[ship_to_customer_address_id]))SHIP_TO_CUSTOMER_ADDRESS_ID
,CONVERT(VARCHAR(255),S.[Auth_Date]) AUTH_DATE
,S.ADJUSTED_DATE AS ADJUST_DATE
,SUM(S.AUTH_AMOUNT)  AUTH_AMOUNT
,SUM(S.AUTH_COST) AUTH_COST
FROM [DA_C2_Src].[S_Sales] S LEFT JOIN DIM_CUST_1_SQL_IN1542 C
ON CONCAT('CUST-',S.[Customer_Id])=C.CUST_ID
LEFT JOIN [DA_C2_Src].[Dim_Item] I
ON S.[Item_Id]=I.[Item_Id]
WHERE
S.[Original_Line_No] Is Null And (S.Service_Id =0 or S.Service_Id =8)
	
---
select
count(a.Customer_id) as Customer_id,
count(a.Item_key) as Item_key
from FACT_SALES_SQL_IN1542 a
left join DIM_CUST_1_SQL_IN1542 b
on a.Customer_id = convert(varchar,b.Cust_key)
left join DA_C2_Src.Dim_Item c
on a.Item_key = c.Item_key
where b.cust_id is null and
c.Item_Id is null
---
GROUP BY S.Order_No,S.[Line_No],S.[Customer_Id],I.[Item_Key],I.[UPC],S.[service_id],
S.[Quantity],S.[Item_Price],S.[Item_Cost],S.[Product_Tax],S.[giftwrap_tax],
S.[shipping_tax],S.[shipping_charges],S.[giftwrap_charges],S.SHIP_TO_CUSTOMER_ADDRESS_ID,
S.[Auth_Date],S.ADJUSTED_DATE,S.AUTH_AMOUNT,S.AUTH_COST
UNION ALL
SELECT 
A.[Order_No]                        ,
A.LINE_NO							 ,
ISNULL(A.CUSTOMER_ID,-1)						 ,
A.ITEM_KEY						 ,
A.UPC								 ,
A.SERVICE_ID						 ,
A.QUANTITY						 ,
A.ITEM_PRICE						 ,
A.ITEM_COST						 ,
A.Order_Amt						 ,
A.[Produst_Tax]						 ,
A.GIFTWRAP_TAX					 ,
A.SHIPPING_TAX					 ,
A.SHIPPING_CHARGES				 ,
A.GIFTWRAP_CHARGES				 ,
A.SHIP_TO_CUSTOMER_ADDRESS_ID		 ,
A.AUTH_DATE						 ,
A.ADJUST_DATE						 ,
A.AUTH_AMOUNT                      ,
A.AUTH_COST						 
FROM [DA_C2_Src].[S_Adjustments] A)  K
--------------------------------------------------------ROW COUNT----------
SELECT COUNT(*) FROM FACT_SALES_SQL_IN1542
SELECT COUNT(*) FROM (SELECT *,
(K.PRODUCT_TAX + K.GIFTWRAP_TAX +K.SHIPPING_TAX) TOTAL_TAX,
(K.SHIPPING_CHARGES + K.GIFTWRAP_CHARGES) TOTAL_CHARGES
FROM
(
SELECT 
IIF(S.[Order_No] IS NULL OR ISNUMERIC(S.[Order_No])=0,-1,CONVERT(BIGINT,(S.[Order_No])))
OREDER_NO
,IIF(S.[Line_No] IS NULL ,-1,S.[Line_No])LINE_NO
,IIF(S.[Customer_Id] IS NULL,'NA',CONVERT(VARCHAR(50),[Customer_Id]))CUSTOMER_ID
,IIF(I.[Item_Key] IS NULL,-1,I.[Item_Key])  ITEM_KEY
,I.[UPC]  UPC
,IIF(S.[service_id] IS NULL,-1,S.[service_id]) SERVICE_ID
,CONVERT(INT,S.[Quantity])  QUANTITY
,S.[Item_Price] ITEM_PRICE
,S.[Item_Cost] ITEM_COST
,(S.[Item_Price]*S.[Quantity])     Order_Amt
,SUM(S.[Product_Tax]) PRODUCT_TAX
,SUM(S.[giftwrap_tax]) GIFTWRAP_TAX
,SUM(S.[shipping_tax]) SHIPPING_TAX
,SUM(S.[shipping_charges])SHIPPING_CHARGES
,SUM(S.[giftwrap_charges])  GIFTWRAP_CHARGES
,IIF(S.SHIP_TO_CUSTOMER_ADDRESS_ID IS NULL,-1,CONVERT(INT,S.[ship_to_customer_address_id]))SHIP_TO_CUSTOMER_ADDRESS_ID
,CONVERT(VARCHAR(255),S.[Auth_Date]) AUTH_DATE
,S.ADJUSTED_DATE AS ADJUST_DATE
,SUM(S.AUTH_AMOUNT)  AUTH_AMOUNT
,SUM(S.AUTH_COST) AUTH_COST
FROM [DA_C2_Src].[S_Sales] S LEFT JOIN DIM_CUST_1_SQL_IN1542 C
ON CONCAT('CUST-',S.[Customer_Id])=C.CUST_ID
LEFT JOIN [DA_C2_Src].[Dim_Item] I
ON S.[Item_Id]=I.[Item_Id]
WHERE S.Order_No Is NOT Null And S.Service_Id In (0,8)
GROUP BY S.Order_No,S.[Line_No],S.[Customer_Id],I.[Item_Key],I.[UPC],S.[service_id],
S.[Quantity],S.[Item_Price],S.[Item_Cost],S.[Product_Tax],S.[giftwrap_tax],
S.[shipping_tax],S.[shipping_charges],S.[giftwrap_charges],S.SHIP_TO_CUSTOMER_ADDRESS_ID,
S.[Auth_Date],S.ADJUSTED_DATE,S.AUTH_AMOUNT,S.AUTH_COST
UNION ALL
SELECT 
A.[Order_No]                        ,
A.LINE_NO							 ,
ISNULL(A.CUSTOMER_ID,-1)						 ,
A.ITEM_KEY						 ,
A.UPC								 ,
A.SERVICE_ID						 ,
A.QUANTITY						 ,
A.ITEM_PRICE						 ,
A.ITEM_COST						 ,
A.Order_Amt						 ,
A.[Produst_Tax]						 ,
A.GIFTWRAP_TAX					 ,
A.SHIPPING_TAX					 ,
A.SHIPPING_CHARGES				 ,
A.GIFTWRAP_CHARGES				 ,
A.SHIP_TO_CUSTOMER_ADDRESS_ID		 ,
A.AUTH_DATE						 ,
A.ADJUST_DATE						 ,
A.AUTH_AMOUNT                      ,
A.AUTH_COST						 
FROM [DA_C2_Src].[S_Adjustments] A)  K) B
-----------------ROW_COUNT_GROUPBY--------------
SELECT SERVICE_ID,COUNT(*) FROM FACT_SALES_SQL_IN1542 GROUP BY SERVICE_ID

SELECT SERVICE_ID,COUNT(*) FROM (SELECT *,
(K.PRODUCT_TAX + K.GIFTWRAP_TAX +K.SHIPPING_TAX) TOTAL_TAX,
(K.SHIPPING_CHARGES + K.GIFTWRAP_CHARGES) TOTAL_CHARGES
FROM
(
SELECT 
IIF(S.[Order_No] IS NULL OR ISNUMERIC(S.[Order_No])=0,-1,CONVERT(BIGINT,(S.[Order_No])))
OREDER_NO
,IIF(S.[Line_No] IS NULL ,-1,S.[Line_No])LINE_NO
,IIF(S.[Customer_Id] IS NULL,'NA',CONVERT(VARCHAR(50),[Customer_Id]))CUSTOMER_ID
,IIF(I.[Item_Key] IS NULL,-1,I.[Item_Key])  ITEM_KEY
,I.[UPC]  UPC
,IIF(S.[service_id] IS NULL,-1,S.[service_id]) SERVICE_ID
,CONVERT(INT,S.[Quantity])  QUANTITY
,S.[Item_Price] ITEM_PRICE
,S.[Item_Cost] ITEM_COST
,(S.[Item_Price]*S.[Quantity])     Order_Amt
,SUM(S.[Product_Tax]) PRODUCT_TAX
,SUM(S.[giftwrap_tax]) GIFTWRAP_TAX
,SUM(S.[shipping_tax]) SHIPPING_TAX
,SUM(S.[shipping_charges])SHIPPING_CHARGES
,SUM(S.[giftwrap_charges])  GIFTWRAP_CHARGES
,IIF(S.SHIP_TO_CUSTOMER_ADDRESS_ID IS NULL,-1,CONVERT(INT,S.[ship_to_customer_address_id]))SHIP_TO_CUSTOMER_ADDRESS_ID
,CONVERT(VARCHAR(255),S.[Auth_Date]) AUTH_DATE
,S.ADJUSTED_DATE AS ADJUST_DATE
,SUM(S.AUTH_AMOUNT)  AUTH_AMOUNT
,SUM(S.AUTH_COST) AUTH_COST
FROM [DA_C2_Src].[S_Sales] S LEFT JOIN DIM_CUST_1_SQL_IN1542 C
ON CONCAT('CUST-',S.[Customer_Id])=C.CUST_ID
LEFT JOIN [DA_C2_Src].[Dim_Item] I
ON S.[Item_Id]=I.[Item_Id]
WHERE S.Order_No Is NOT Null And S.Service_Id In (0,8)
GROUP BY S.Order_No,S.[Line_No],S.[Customer_Id],I.[Item_Key],I.[UPC],S.[service_id],
S.[Quantity],S.[Item_Price],S.[Item_Cost],S.[Product_Tax],S.[giftwrap_tax],
S.[shipping_tax],S.[shipping_charges],S.[giftwrap_charges],S.SHIP_TO_CUSTOMER_ADDRESS_ID,
S.[Auth_Date],S.ADJUSTED_DATE,S.AUTH_AMOUNT,S.AUTH_COST
UNION ALL
SELECT 
A.[Order_No]                        ,
A.LINE_NO							 ,
ISNULL(A.CUSTOMER_ID,-1)						 ,
A.ITEM_KEY						 ,
A.UPC								 ,
A.SERVICE_ID						 ,
A.QUANTITY						 ,
A.ITEM_PRICE						 ,
A.ITEM_COST						 ,
A.Order_Amt						 ,
A.[Produst_Tax]						 ,
A.GIFTWRAP_TAX					 ,
A.SHIPPING_TAX					 ,
A.SHIPPING_CHARGES				 ,
A.GIFTWRAP_CHARGES				 ,
A.SHIP_TO_CUSTOMER_ADDRESS_ID		 ,
A.AUTH_DATE						 ,
A.ADJUST_DATE						 ,
A.AUTH_AMOUNT                      ,
A.AUTH_COST						 
FROM [DA_C2_Src].[S_Adjustments] A)  K) B
GROUP BY SERVICE_ID
-------------------REFERENCE INTEGEGRITY---

--SATIFICATION CHECK---
SELECT SUM(Order_Amt) O_A, SUM(PRODUCT_TAX) P_T FROM FACT_SALES_SQL_IN1542 	

SELECT SUM(Order_Amt), SUM(PRODUCT_TAX) FROM (SELECT *,
(K.PRODUCT_TAX + K.GIFTWRAP_TAX +K.SHIPPING_TAX) TOTAL_TAX,
(K.SHIPPING_CHARGES + K.GIFTWRAP_CHARGES) TOTAL_CHARGES
FROM
(
SELECT 
IIF(S.[Order_No] IS NULL OR ISNUMERIC(S.[Order_No])=0,-1,CONVERT(BIGINT,(S.[Order_No])))
OREDER_NO
,IIF(S.[Line_No] IS NULL ,-1,S.[Line_No])LINE_NO
,IIF(S.[Customer_Id] IS NULL,'NA',CONVERT(VARCHAR(50),[Customer_Id]))CUSTOMER_ID
,IIF(I.[Item_Key] IS NULL,-1,I.[Item_Key])  ITEM_KEY
,I.[UPC]  UPC
,IIF(S.[service_id] IS NULL,-1,S.[service_id]) SERVICE_ID
,CONVERT(INT,S.[Quantity])  QUANTITY
,S.[Item_Price] ITEM_PRICE
,S.[Item_Cost] ITEM_COST
,(S.[Item_Price]*S.[Quantity])     Order_Amt
,SUM(S.[Product_Tax]) PRODUCT_TAX
,SUM(S.[giftwrap_tax]) GIFTWRAP_TAX
,SUM(S.[shipping_tax]) SHIPPING_TAX
,SUM(S.[shipping_charges])SHIPPING_CHARGES
,SUM(S.[giftwrap_charges])  GIFTWRAP_CHARGES
,IIF(S.SHIP_TO_CUSTOMER_ADDRESS_ID IS NULL,-1,CONVERT(INT,S.[ship_to_customer_address_id]))SHIP_TO_CUSTOMER_ADDRESS_ID
,CONVERT(VARCHAR(255),S.[Auth_Date]) AUTH_DATE
,S.ADJUSTED_DATE AS ADJUST_DATE
,SUM(S.AUTH_AMOUNT)  AUTH_AMOUNT
,SUM(S.AUTH_COST) AUTH_COST
FROM [DA_C2_Src].[S_Sales] S LEFT JOIN DIM_CUST_1_SQL_IN1542 C
ON CONCAT('CUST-',S.[Customer_Id])=C.CUST_ID
LEFT JOIN [DA_C2_Src].[Dim_Item] I
ON S.[Item_Id]=I.[Item_Id]
WHERE S.Order_No Is NOT Null And S.Service_Id In (0,8)
GROUP BY S.Order_No,S.[Line_No],S.[Customer_Id],I.[Item_Key],I.[UPC],S.[service_id],
S.[Quantity],S.[Item_Price],S.[Item_Cost],S.[Product_Tax],S.[giftwrap_tax],
S.[shipping_tax],S.[shipping_charges],S.[giftwrap_charges],S.SHIP_TO_CUSTOMER_ADDRESS_ID,
S.[Auth_Date],S.ADJUSTED_DATE,S.AUTH_AMOUNT,S.AUTH_COST
UNION ALL
SELECT 
A.[Order_No]                        ,
A.LINE_NO							 ,
ISNULL(A.CUSTOMER_ID,-1)						 ,
A.ITEM_KEY						 ,
A.UPC								 ,
A.SERVICE_ID						 ,
A.QUANTITY						 ,
A.ITEM_PRICE						 ,
A.ITEM_COST						 ,
A.Order_Amt						 ,
A.[Produst_Tax]						 ,
A.GIFTWRAP_TAX					 ,
A.SHIPPING_TAX					 ,
A.SHIPPING_CHARGES				 ,
A.GIFTWRAP_CHARGES				 ,
A.SHIP_TO_CUSTOMER_ADDRESS_ID		 ,
A.AUTH_DATE						 ,
A.ADJUST_DATE						 ,
A.AUTH_AMOUNT                      ,
A.AUTH_COST						 
FROM [DA_C2_Src].[S_Adjustments] A)  K) B
----------------------------SATIFICATION GROUP BY----
SELECT SERVICE_ID, SUM(Order_Amt) O_A, SUM(PRODUCT_TAX) P_T FROM FACT_SALES_SQL_IN1542 	GROUP BY SERVICE_ID

SELECT SERVICE_ID,SUM(Order_Amt), SUM(PRODUCT_TAX) FROM (SELECT *,
(K.PRODUCT_TAX + K.GIFTWRAP_TAX +K.SHIPPING_TAX) TOTAL_TAX,
(K.SHIPPING_CHARGES + K.GIFTWRAP_CHARGES) TOTAL_CHARGES
FROM
(
SELECT 
IIF(S.[Order_No] IS NULL OR ISNUMERIC(S.[Order_No])=0,-1,CONVERT(BIGINT,(S.[Order_No])))
OREDER_NO
,IIF(S.[Line_No] IS NULL ,-1,S.[Line_No])LINE_NO
,IIF(S.[Customer_Id] IS NULL,'NA',CONVERT(VARCHAR(50),[Customer_Id]))CUSTOMER_ID
,IIF(I.[Item_Key] IS NULL,-1,I.[Item_Key])  ITEM_KEY
,I.[UPC]  UPC
,IIF(S.[service_id] IS NULL,-1,S.[service_id]) SERVICE_ID
,CONVERT(INT,S.[Quantity])  QUANTITY
,S.[Item_Price] ITEM_PRICE
,S.[Item_Cost] ITEM_COST
,(S.[Item_Price]*S.[Quantity])     Order_Amt
,SUM(S.[Product_Tax]) PRODUCT_TAX
,SUM(S.[giftwrap_tax]) GIFTWRAP_TAX
,SUM(S.[shipping_tax]) SHIPPING_TAX
,SUM(S.[shipping_charges])SHIPPING_CHARGES
,SUM(S.[giftwrap_charges])  GIFTWRAP_CHARGES
,IIF(S.SHIP_TO_CUSTOMER_ADDRESS_ID IS NULL,-1,CONVERT(INT,S.[ship_to_customer_address_id]))SHIP_TO_CUSTOMER_ADDRESS_ID
,CONVERT(VARCHAR(255),S.[Auth_Date]) AUTH_DATE
,S.ADJUSTED_DATE AS ADJUST_DATE
,SUM(S.AUTH_AMOUNT)  AUTH_AMOUNT
,SUM(S.AUTH_COST) AUTH_COST
FROM [DA_C2_Src].[S_Sales] S LEFT JOIN DIM_CUST_1_SQL_IN1542 C
ON CONCAT('CUST-',S.[Customer_Id])=C.CUST_ID
LEFT JOIN [DA_C2_Src].[Dim_Item] I
ON S.[Item_Id]=I.[Item_Id]
WHERE S.Order_No Is NOT Null And S.Service_Id In (0,8)
GROUP BY S.Order_No,S.[Line_No],S.[Customer_Id],I.[Item_Key],I.[UPC],S.[service_id],
S.[Quantity],S.[Item_Price],S.[Item_Cost],S.[Product_Tax],S.[giftwrap_tax],
S.[shipping_tax],S.[shipping_charges],S.[giftwrap_charges],S.SHIP_TO_CUSTOMER_ADDRESS_ID,
S.[Auth_Date],S.ADJUSTED_DATE,S.AUTH_AMOUNT,S.AUTH_COST
UNION ALL
SELECT 
A.[Order_No]                        ,
A.LINE_NO							 ,
ISNULL(A.CUSTOMER_ID,-1)						 ,
A.ITEM_KEY						 ,
A.UPC								 ,
A.SERVICE_ID						 ,
A.QUANTITY						 ,
A.ITEM_PRICE						 ,
A.ITEM_COST						 ,
A.Order_Amt						 ,
A.[Produst_Tax]						 ,
A.GIFTWRAP_TAX					 ,
A.SHIPPING_TAX					 ,
A.SHIPPING_CHARGES				 ,
A.GIFTWRAP_CHARGES				 ,
A.SHIP_TO_CUSTOMER_ADDRESS_ID		 ,
A.AUTH_DATE						 ,
A.ADJUST_DATE						 ,
A.AUTH_AMOUNT                      ,
A.AUTH_COST						 
FROM [DA_C2_Src].[S_Adjustments] A)  K) B
GROUP BY SERVICE_ID
--------------REFERENCE INTEGERITY--------------
select count(ITEM_KEY)
FROM FACT_SALES_SQL_IN1542
WHERE OREDER_NO  IS NULL 
---------------------------------------------
DIM_CUST_1_SQL_IN1542

CREATE TABLE FACT_SALES_INFA_IN1542(

OREDER_NO	BIGINT	NOT NULL                      ,
LINE_NO	INTEGER	NOT NULL						  ,
CUSTOMER_ID	VARCHAR(50)	NOT NULL				  ,
ITEM_KEY	INTEGER	NOT NULL					  ,
UPC	VARCHAR(255)							  ,
SERVICE_ID	INTEGER	NOT NULL					  ,
QUANTITY	INTEGER							  ,
ITEM_PRICE	FLOAT							  ,
ITEM_COST	FLOAT							  ,
Order_Amt	FLOAT							  ,
PRODUCT_TAX	FLOAT							  ,
GIFTWRAP_TAX	FLOAT						  ,
SHIPPING_TAX	FLOAT						  ,
SHIPPING_CHARGES	FLOAT					  ,
GIFTWRAP_CHARGES	FLOAT					  ,
SHIP_TO_CUSTOMER_ADDRESS_ID	INTEGER	NOT NULL	  ,
AUTH_DATE	VARCHAR(255)					  ,
ADJUST_DATE	DATETIME						  ,
AUTH_AMOUNT	FLOAT							  ,
AUTH_COST	FLOAT							  ,
	)

	TRUNCATE TABLE  FACT_SALES_INFA_IN1542

	SELECT * FROM FACT_SALES_INFA_IN1542
	SELECT COUNT(*) FROM FACT_SALES_INFA_IN1542
SELECT COUNT(*) 
FROM(
SELECT 
IIF(S.[Order_No] IS NULL OR ISNUMERIC(S.[Order_No])=0,-1,CONVERT(BIGINT,(S.[Order_No])))
OREDER_NO
,IIF(S.[Line_No] IS NULL ,-1,S.[Line_No])LINE_NO
,IIF(S.[Customer_Id] IS NULL,'NA',CONVERT(VARCHAR(50),[Customer_Id]))CUSTOMER_ID
,IIF(I.[Item_Key] IS NULL,-1,I.[Item_Key])  ITEM_KEY
,I.[UPC]  UPC
,IIF(S.[service_id] IS NULL,-1,S.[service_id]) SERVICE_ID
,CONVERT(INT,S.[Quantity])  QUANTITY
,S.[Item_Price] ITEM_PRICE
,S.[Item_Cost] ITEM_COST
,(S.[Item_Price]*S.[Quantity])     Order_Amt
,SUM(S.[Product_Tax]) PRODUCT_TAX
,SUM(S.[giftwrap_tax]) GIFTWRAP_TAX
,SUM(S.[shipping_tax]) SHIPPING_TAX
,SUM(S.[shipping_charges])SHIPPING_CHARGES
,SUM(S.[giftwrap_charges])  GIFTWRAP_CHARGES
,IIF(S.SHIP_TO_CUSTOMER_ADDRESS_ID IS NULL,-1,CONVERT(INT,S.[ship_to_customer_address_id]))SHIP_TO_CUSTOMER_ADDRESS_ID
,CONVERT(VARCHAR(255),S.[Auth_Date]) AUTH_DATE
,S.ADJUSTED_DATE AS ADJUST_DATE
,SUM(S.AUTH_AMOUNT)  AUTH_AMOUNT
,SUM(S.AUTH_COST) AUTH_COST
FROM [DA_C2_Src].[S_Sales] S LEFT JOIN DIM_CUST_1_SQL_IN1542 C
ON CONCAT('CUST-',S.[Customer_Id])=C.CUST_ID
LEFT JOIN [DA_C2_Src].[Dim_Item] I
ON S.[Item_Id]=I.[Item_Id]
WHERE S.Order_No Is NOT Null And S.Service_Id In (0,8)
GROUP BY S.Order_No,S.[Line_No],S.[Customer_Id],I.[Item_Key],I.[UPC],S.[service_id],
S.[Quantity],S.[Item_Price],S.[Item_Cost],S.[Product_Tax],S.[giftwrap_tax],
S.[shipping_tax],S.[shipping_charges],S.[giftwrap_charges],S.SHIP_TO_CUSTOMER_ADDRESS_ID,
S.[Auth_Date],S.ADJUSTED_DATE,S.AUTH_AMOUNT,S.AUTH_COST)S

-----------------ROW_COUNT_GROUPBY--------------
SELECT SERVICE_ID,COUNT(*) FROM FACT_SALES_SQL_IN1542 GROUP BY SERVICE_ID

SELECT SERVICE_ID,COUNT(*) FROM (SELECT *,
(K.PRODUCT_TAX + K.GIFTWRAP_TAX +K.SHIPPING_TAX) TOTAL_TAX,
(K.SHIPPING_CHARGES + K.GIFTWRAP_CHARGES) TOTAL_CHARGES
FROM
(
SELECT 
IIF(S.[Order_No] IS NULL OR ISNUMERIC(S.[Order_No])=0,-1,CONVERT(BIGINT,(S.[Order_No])))
OREDER_NO
,IIF(S.[Line_No] IS NULL ,-1,S.[Line_No])LINE_NO
,IIF(S.[Customer_Id] IS NULL,'NA',CONVERT(VARCHAR(50),[Customer_Id]))CUSTOMER_ID
,IIF(I.[Item_Key] IS NULL,-1,I.[Item_Key])  ITEM_KEY
,I.[UPC]  UPC
,IIF(S.[service_id] IS NULL,-1,S.[service_id]) SERVICE_ID
,CONVERT(INT,S.[Quantity])  QUANTITY
,S.[Item_Price] ITEM_PRICE
,S.[Item_Cost] ITEM_COST
,(S.[Item_Price]*S.[Quantity])     Order_Amt
,SUM(S.[Product_Tax]) PRODUCT_TAX
,SUM(S.[giftwrap_tax]) GIFTWRAP_TAX
,SUM(S.[shipping_tax]) SHIPPING_TAX
,SUM(S.[shipping_charges])SHIPPING_CHARGES
,SUM(S.[giftwrap_charges])  GIFTWRAP_CHARGES
,IIF(S.SHIP_TO_CUSTOMER_ADDRESS_ID IS NULL,-1,CONVERT(INT,S.[ship_to_customer_address_id]))SHIP_TO_CUSTOMER_ADDRESS_ID
,CONVERT(VARCHAR(255),S.[Auth_Date]) AUTH_DATE
,S.ADJUSTED_DATE AS ADJUST_DATE
,SUM(S.AUTH_AMOUNT)  AUTH_AMOUNT
,SUM(S.AUTH_COST) AUTH_COST
FROM [DA_C2_Src].[S_Sales] S LEFT JOIN DIM_CUST_1_SQL_IN1542 C
ON CONCAT('CUST-',S.[Customer_Id])=C.CUST_ID
LEFT JOIN [DA_C2_Src].[Dim_Item] I
ON S.[Item_Id]=I.[Item_Id]
WHERE S.Order_No Is NOT Null And S.Service_Id In (0,8)
GROUP BY S.Order_No,S.[Line_No],S.[Customer_Id],I.[Item_Key],I.[UPC],S.[service_id],
S.[Quantity],S.[Item_Price],S.[Item_Cost],S.[Product_Tax],S.[giftwrap_tax],
S.[shipping_tax],S.[shipping_charges],S.[giftwrap_charges],S.SHIP_TO_CUSTOMER_ADDRESS_ID,
S.[Auth_Date],S.ADJUSTED_DATE,S.AUTH_AMOUNT,S.AUTH_COST
UNION ALL
SELECT 
A.[Order_No]                        ,
A.LINE_NO							 ,
ISNULL(A.CUSTOMER_ID,-1)						 ,
A.ITEM_KEY						 ,
A.UPC								 ,
A.SERVICE_ID						 ,
A.QUANTITY						 ,
A.ITEM_PRICE						 ,
A.ITEM_COST						 ,
A.Order_Amt						 ,
A.[Produst_Tax]						 ,
A.GIFTWRAP_TAX					 ,
A.SHIPPING_TAX					 ,
A.SHIPPING_CHARGES				 ,
A.GIFTWRAP_CHARGES				 ,
A.SHIP_TO_CUSTOMER_ADDRESS_ID		 ,
A.AUTH_DATE						 ,
A.ADJUST_DATE						 ,
A.AUTH_AMOUNT                      ,
A.AUTH_COST						 
FROM [DA_C2_Src].[S_Adjustments] A)  K) B
GROUP BY SERVICE_ID
-------------------REFERENCE INTEGEGRITY---

--SATIFICATION CHECK---
SELECT SUM(Order_Amt) O_A, SUM(PRODUCT_TAX) P_T FROM FACT_SALES_SQL_IN1542 	

SELECT SUM(Order_Amt), SUM(PRODUCT_TAX) FROM (SELECT *,
(K.PRODUCT_TAX + K.GIFTWRAP_TAX +K.SHIPPING_TAX) TOTAL_TAX,
(K.SHIPPING_CHARGES + K.GIFTWRAP_CHARGES) TOTAL_CHARGES
FROM
(
SELECT 
IIF(S.[Order_No] IS NULL OR ISNUMERIC(S.[Order_No])=0,-1,CONVERT(BIGINT,(S.[Order_No])))
OREDER_NO
,IIF(S.[Line_No] IS NULL ,-1,S.[Line_No])LINE_NO
,IIF(S.[Customer_Id] IS NULL,'NA',CONVERT(VARCHAR(50),[Customer_Id]))CUSTOMER_ID
,IIF(I.[Item_Key] IS NULL,-1,I.[Item_Key])  ITEM_KEY
,I.[UPC]  UPC
,IIF(S.[service_id] IS NULL,-1,S.[service_id]) SERVICE_ID
,CONVERT(INT,S.[Quantity])  QUANTITY
,S.[Item_Price] ITEM_PRICE
,S.[Item_Cost] ITEM_COST
,(S.[Item_Price]*S.[Quantity])     Order_Amt
,SUM(S.[Product_Tax]) PRODUCT_TAX
,SUM(S.[giftwrap_tax]) GIFTWRAP_TAX
,SUM(S.[shipping_tax]) SHIPPING_TAX
,SUM(S.[shipping_charges])SHIPPING_CHARGES
,SUM(S.[giftwrap_charges])  GIFTWRAP_CHARGES
,IIF(S.SHIP_TO_CUSTOMER_ADDRESS_ID IS NULL,-1,CONVERT(INT,S.[ship_to_customer_address_id]))SHIP_TO_CUSTOMER_ADDRESS_ID
,CONVERT(VARCHAR(255),S.[Auth_Date]) AUTH_DATE
,S.ADJUSTED_DATE AS ADJUST_DATE
,SUM(S.AUTH_AMOUNT)  AUTH_AMOUNT
,SUM(S.AUTH_COST) AUTH_COST
FROM [DA_C2_Src].[S_Sales] S LEFT JOIN DIM_CUST_1_SQL_IN1542 C
ON CONCAT('CUST-',S.[Customer_Id])=C.CUST_ID
LEFT JOIN [DA_C2_Src].[Dim_Item] I
ON S.[Item_Id]=I.[Item_Id]
WHERE S.Order_No Is NOT Null And S.Service_Id In (0,8)
GROUP BY S.Order_No,S.[Line_No],S.[Customer_Id],I.[Item_Key],I.[UPC],S.[service_id],
S.[Quantity],S.[Item_Price],S.[Item_Cost],S.[Product_Tax],S.[giftwrap_tax],
S.[shipping_tax],S.[shipping_charges],S.[giftwrap_charges],S.SHIP_TO_CUSTOMER_ADDRESS_ID,
S.[Auth_Date],S.ADJUSTED_DATE,S.AUTH_AMOUNT,S.AUTH_COST
UNION ALL
SELECT 
A.[Order_No]                        ,
A.LINE_NO							 ,
ISNULL(A.CUSTOMER_ID,-1)						 ,
A.ITEM_KEY						 ,
A.UPC								 ,
A.SERVICE_ID						 ,
A.QUANTITY						 ,
A.ITEM_PRICE						 ,
A.ITEM_COST						 ,
A.Order_Amt						 ,
A.[Produst_Tax]						 ,
A.GIFTWRAP_TAX					 ,
A.SHIPPING_TAX					 ,
A.SHIPPING_CHARGES				 ,
A.GIFTWRAP_CHARGES				 ,
A.SHIP_TO_CUSTOMER_ADDRESS_ID		 ,
A.AUTH_DATE						 ,
A.ADJUST_DATE						 ,
A.AUTH_AMOUNT                      ,
A.AUTH_COST						 
FROM [DA_C2_Src].[S_Adjustments] A)  K) B
----------------------------SATIFICATION GROUP BY----
SELECT SERVICE_ID, SUM(Order_Amt) O_A, SUM(PRODUCT_TAX) P_T FROM FACT_SALES_SQL_IN1542 	GROUP BY SERVICE_ID

SELECT SERVICE_ID,SUM(Order_Amt), SUM(PRODUCT_TAX) FROM (SELECT *,
(K.PRODUCT_TAX + K.GIFTWRAP_TAX +K.SHIPPING_TAX) TOTAL_TAX,
(K.SHIPPING_CHARGES + K.GIFTWRAP_CHARGES) TOTAL_CHARGES
FROM
(
SELECT 
IIF(S.[Order_No] IS NULL OR ISNUMERIC(S.[Order_No])=0,-1,CONVERT(BIGINT,(S.[Order_No])))
OREDER_NO
,IIF(S.[Line_No] IS NULL ,-1,S.[Line_No])LINE_NO
,IIF(S.[Customer_Id] IS NULL,'NA',CONVERT(VARCHAR(50),[Customer_Id]))CUSTOMER_ID
,IIF(I.[Item_Key] IS NULL,-1,I.[Item_Key])  ITEM_KEY
,I.[UPC]  UPC
,IIF(S.[service_id] IS NULL,-1,S.[service_id]) SERVICE_ID
,CONVERT(INT,S.[Quantity])  QUANTITY
,S.[Item_Price] ITEM_PRICE
,S.[Item_Cost] ITEM_COST
,(S.[Item_Price]*S.[Quantity])     Order_Amt
,SUM(S.[Product_Tax]) PRODUCT_TAX
,SUM(S.[giftwrap_tax]) GIFTWRAP_TAX
,SUM(S.[shipping_tax]) SHIPPING_TAX
,SUM(S.[shipping_charges])SHIPPING_CHARGES
,SUM(S.[giftwrap_charges])  GIFTWRAP_CHARGES
,IIF(S.SHIP_TO_CUSTOMER_ADDRESS_ID IS NULL,-1,CONVERT(INT,S.[ship_to_customer_address_id]))SHIP_TO_CUSTOMER_ADDRESS_ID
,CONVERT(VARCHAR(255),S.[Auth_Date]) AUTH_DATE
,S.ADJUSTED_DATE AS ADJUST_DATE
,SUM(S.AUTH_AMOUNT)  AUTH_AMOUNT
,SUM(S.AUTH_COST) AUTH_COST
FROM [DA_C2_Src].[S_Sales] S LEFT JOIN DIM_CUST_1_SQL_IN1542 C
ON CONCAT('CUST-',S.[Customer_Id])=C.CUST_ID
LEFT JOIN [DA_C2_Src].[Dim_Item] I
ON S.[Item_Id]=I.[Item_Id]
WHERE S.Order_No Is NOT Null And S.Service_Id In (0,8)
GROUP BY S.Order_No,S.[Line_No],S.[Customer_Id],I.[Item_Key],I.[UPC],S.[service_id],
S.[Quantity],S.[Item_Price],S.[Item_Cost],S.[Product_Tax],S.[giftwrap_tax],
S.[shipping_tax],S.[shipping_charges],S.[giftwrap_charges],S.SHIP_TO_CUSTOMER_ADDRESS_ID,
S.[Auth_Date],S.ADJUSTED_DATE,S.AUTH_AMOUNT,S.AUTH_COST
UNION ALL
SELECT 
A.[Order_No]                        ,
A.LINE_NO							 ,
ISNULL(A.CUSTOMER_ID,-1)						 ,
A.ITEM_KEY						 ,
A.UPC								 ,
A.SERVICE_ID						 ,
A.QUANTITY						 ,
A.ITEM_PRICE						 ,
A.ITEM_COST						 ,
A.Order_Amt						 ,
A.[Produst_Tax]						 ,
A.GIFTWRAP_TAX					 ,
A.SHIPPING_TAX					 ,
A.SHIPPING_CHARGES				 ,
A.GIFTWRAP_CHARGES				 ,
A.SHIP_TO_CUSTOMER_ADDRESS_ID		 ,
A.AUTH_DATE						 ,
A.ADJUST_DATE						 ,
A.AUTH_AMOUNT                      ,
A.AUTH_COST						 
FROM [DA_C2_Src].[S_Adjustments] A)  K) B
GROUP BY SERVICE_ID
--------------REFERENCE INTEGERITY--------------
select count(ITEM_KEY)
FROM FACT_SALES_SQL_IN1542
WHERE OREDER_NO  IS NULL 


select
count(Customer_id) as Customer_id,
count(a.Item_key) as Item_key
from FACT_SALES_SQL_IN1542 a
left join DIM_CUST_SQL_IN1542 b
on a.Customer_id = convert(varchar,b.Cust_key)
left join DA_C2_Src.Dim_Item c
on a.Item_key = c.Item_key
where b.cust_id is null and
c.Item_Id is null