create table DIM_CUST_1_SQL_IN1542(
CUST_KEY	INTEGER	PRIMARY KEY identity(1,1) not null                ,
CUST_ID	VARCHAR(50)	not null   default ('CID-0001+SU')             ,
CUST_NAME	VARCHAR(50)	not null        DEFAULT('N/A')    ,
CUST_USER_ID	VARCHAR(50)	not null    DEFAULT('N/A')      ,
CUST_EMAIL_ID	VARCHAR(50)	not null    DEFAULT('Not Available')      ,
CUST_STREET	VARCHAR(50)	not null         DEFAULT('N/A')     ,
CUST_APARTMENT_NO	VARCHAR(50)	NOT null DEFAULT('N/A')  ,
CUST_SUITE_NO	VARCHAR(50)	not null   DEFAULT('N/A')   ,
CUST_CITY	VARCHAR(50)	null                ,
CUST_STATE	VARCHAR(50)	null                ,
CUST_COUNTRY	VARCHAR(50)	null            ,
CUST_SIGN_UP_DATE	DATE	not null    DEFAULT('01/01/1900')      ,
CUST_PHONE_NO	VARCHAR(50)	not null   DEFAULT('(000)-000-0000')   ,
CUST_TYPE	VARCHAR(50)	null                ,
SITE_ID	VARCHAR(50)	null                    ,
SITE_NAME	VARCHAR(50)	null                ,
SITE_DESC	VARCHAR(50)	null                ,
SITE_STATUS	VARCHAR(2)	null                ,
SITE_TYPE	VARCHAR(50)	null                ,
SITE_CITY	VARCHAR(50)	null                ,
SITE_STATE	VARCHAR(50)	null                ,
SITE_COUNTRY	VARCHAR(50)	null            ,
START_DATE	DATETIME	not null             ,
END_DATE	DATETIME	null)

----------------------------------TRUNCATE TABLE 
create table DIM_CUST_1_INFA_IN1542(
CUST_KEY	INTEGER	PRIMARY KEY  not null                ,
CUST_ID	VARCHAR(50)	not null               ,
CUST_NAME	VARCHAR(50)	not null          ,
CUST_USER_ID	VARCHAR(50)	not null         ,
CUST_EMAIL_ID	VARCHAR(50)	not null        ,
CUST_STREET	VARCHAR(50)	not null             ,
CUST_APARTMENT_NO	VARCHAR(50)	NOT null  ,
CUST_SUITE_NO	VARCHAR(50)	not null     ,
CUST_CITY	VARCHAR(50)	null                ,
CUST_STATE	VARCHAR(50)	null                ,
CUST_COUNTRY	VARCHAR(50)	null            ,
CUST_SIGN_UP_DATE	DATE	not null          ,
CUST_PHONE_NO	VARCHAR(50)	not null     ,
CUST_TYPE	VARCHAR(50)	null                ,
SITE_ID	VARCHAR(50)	null                    ,
SITE_NAME	VARCHAR(50)	null                ,
SITE_DESC	VARCHAR(50)	null                ,
SITE_STATUS	VARCHAR(2)	null                ,
SITE_TYPE	VARCHAR(50)	null                ,
SITE_CITY	VARCHAR(50)	null                ,
SITE_STATE	VARCHAR(50)	null                ,
SITE_COUNTRY	VARCHAR(50)	null            ,
START_DATE	DATETIME	not null             ,
END_DATE	DATETIME	null)
--------------------------------------------------
drop table DIM_CUST_1_SQL_IN1542 
SELECT * FROM DIM_CUST_1_SQL_IN1542 
TRUNCATE TABLE  DIM_CUST_1_SQL_IN1542 
---------------DML--------------------------
INSERT INTO DIM_CUST_1_SQL_IN1542 
SELECT DISTINCT
IIF(LCU.[Customer_Id] IS NULL, 'CID-0001+SU',CONCAT('CID-',LCU.[Customer_Id],'+SU'))CUST_ID,
CASE WHEN 
[Middle_Name] IS NULL THEN CONCAT(LCU .[First_Name],' ',LCU .[Last_Name])
ELSE CONCAT(LCU .[First_Name],' ',LCU .[Middle_Name],' ',LCU .[Last_Name])
END AS CUST_NAME,
CONCAT(SUBSTRING( LCU.[First_Name],1,1),SUBSTRING(LCU.[Last_Name],1,5))CUST_USER_ID,
CASE WHEN LCU.[Email_Address] NOT LIKE '%@abc.com' THEN  'Invalid Email' 
ELSE 
LCU.[Email_Address]
END AS CUST_EMAIL_ID,
REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),1))CUST_STREET,
REVERSE(PARSENAME(REPLACE(REVERSE(REPLACE(LCU.[Address],'.','')),',','.'),2))CUST_APARTMENT_NO,
REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),3))CUST_SUITE_NO,
LCI.[City]  CUST_CITY,
LCI.[State] CUST_STATE,
LCI.[Country] CUST_COUNTRY  ,                            
 CONVERT(varchar, LCU.[SignUp_Date], 101) CUST_SIGN_UP_DATE,
FORMAT(LCU .[Phone],'(###)-###-####') AS CUST_PHONE_NO,
case when  LCU.CUSTOMER_TYPE = 1 then 'Loyal Customers'
when  LCU.CUSTOMER_TYPE = 2 then 'Impulse Customers'
when LCU.CUSTOMER_TYPE =3 then 'Discount Customers'
when  LCU.CUSTOMER_TYPE =4 then 'Need-Based Customers'
when  LCU.CUSTOMER_TYPE =5 then 'Wandering Customers'
else 'Other Customers' 
end as CUST_TYPE,
LSI.[Site_Id]  SITE_ID ,                
IIF(LSI.[SITE_NAME] IS NULL,'UNK',UPPER(LSI.[SITE_NAME])) SITE_NAME,
CASE WHEN LSI.[NOTES] IS NULL THEN 'UnKnown Site'
when LSI.[NOTES] like 'R5%' THEN CONCAT(LSI.[NOTES],'KIT')
ELSE LSI.[NOTES]
END AS SITE_DESC,
 LSI.[IS_ACTIVE] SITE_STATUS,
 LCO.[Com_Desc] SITE_TYPE  ,
 LCI.[City]   SITE_CITY,
LCI.[State] SITE_STATE,
LCI.[Country] SITE_COUNTRY,
GETDATE() AS START_DATE,
 NULL AS END_DATE
FROM
[DA_C2_Src].[Lu_Site] LSI 
LEFT JOIN
[DA_C2_Src].[Lu_City] LCI1
ON LSI.[Customer_City_Id]=LCI1.[City_Id]
RIGHT JOIN 
[DA_C2_Src].[Lu_Customer] LCU
ON LCU.[Site_Id]=LSI.[Site_Id]
LEFT JOIN 
[DA_C2_Src].[Lu_Com] LCO
ON  CONVERT(INT,CONCAT('100',CONVERT(VARCHAR(10),LCO.[Com_Id])))=LCU.[Site_Id]
LEFT JOIN 
[DA_C2_Src].[Lu_City] LCI
ON LCI.[City_Id]=LSI.[Site_City_Id]
WHERE  LCU.CUSTOMER_ID IS NOT NULL and LSI.IS_ACTIVE  NOT LIKE 'D'		
--------------------------------------------------

TESTING

SELECT COUNT(*) FROM DIM_CUST_1_SQL_IN1542

SELECT COUNT(*) 
FROM (
SELECT DISTINCT
IIF(LCU.[Customer_Id] IS NULL, 'CID-0001+SU',CONCAT('CID-',LCU.[Customer_Id],'+SU'))CUST_ID,
CASE WHEN 
[Middle_Name] IS NULL THEN CONCAT(LCU .[First_Name],' ',LCU .[Last_Name])
ELSE CONCAT(LCU .[First_Name],' ',LCU .[Middle_Name],' ',LCU .[Last_Name])
END AS CUST_NAME,
CONCAT(SUBSTRING( LCU.[First_Name],1,1),SUBSTRING(LCU.[Last_Name],1,5))CUST_USER_ID,
CASE WHEN LCU.[Email_Address] NOT LIKE '%@abc.com' THEN  'Invalid Email' 
ELSE 
LCU.[Email_Address]
END AS CUST_EMAIL_ID,
REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),1))CUST_STREET,
isnull(REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),2)),'NA')CUST_APARTMENT_NO,
isnull(REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),3)),'NA')CUST_SUITE_NO,
LCI.[City]  CUST_CITY,
LCI.[State] CUST_STATE,
LCI.[Country] CUST_COUNTRY  ,                            
 CONVERT(varchar, LCU.[SignUp_Date], 101) CUST_SIGN_UP_DATE,
FORMAT(LCU .[Phone],'(###)-###-####') AS CUST_PHONE_NO,
case when  LCU.CUSTOMER_TYPE = 1 then 'Loyal Customers'
when  LCU.CUSTOMER_TYPE = 2 then 'Impulse Customers'
when LCU.CUSTOMER_TYPE =3 then 'Discount Customers'
when  LCU.CUSTOMER_TYPE =4 then 'Need-Based Customers'
when  LCU.CUSTOMER_TYPE =5 then 'Wandering Customers'
else 'Other Customers' 
end as CUST_TYPE,
LSI.[Site_Id]  SITE_ID ,                
IIF(LSI.[SITE_NAME] IS NULL,'UNK',UPPER(LSI.[SITE_NAME])) SITE_NAME,
CASE WHEN LSI.[NOTES] IS NULL THEN 'UnKnown Site'
when LSI.[NOTES] like 'R5%' THEN CONCAT(LSI.[NOTES],'KIT')
ELSE LSI.[NOTES]
END AS SITE_DESC,
 LSI.[IS_ACTIVE] SITE_STATUS,
 LCO.[Com_Desc] SITE_TYPE  ,
 LCI.[City]   SITE_CITY,
LCI.[State] SITE_STATE,
LCI.[Country] SITE_COUNTRY,
GETDATE() AS START_DATE,
 NULL AS END_DATE
FROM
[DA_C2_Src].[Lu_Site] LSI 
LEFT JOIN
[DA_C2_Src].[Lu_City] LCI1
ON LSI.[Customer_City_Id]=LCI1.[City_Id]
RIGHT JOIN 
[DA_C2_Src].[Lu_Customer] LCU
ON LCU.[Site_Id]=LSI.[Site_Id]
LEFT JOIN 
[DA_C2_Src].[Lu_Com] LCO
ON  CONVERT(INT,CONCAT('100',CONVERT(VARCHAR(10),LCO.[Com_Id])))=LCU.[Site_Id]
LEFT JOIN 
[DA_C2_Src].[Lu_City] LCI
ON LCI.[City_Id]=LSI.[Site_City_Id]
WHERE  LCU.CUSTOMER_ID IS NOT NULL and LSI.IS_ACTIVE  NOT LIKE 'D')C
---------------------------------------
---ROW COUNT GROUP BY---


SELECT CUST_TYPE,COUNT(*) FROM DIM_CUST_1_SQL_IN1542 
 
 GROUP BY CUST_TYPE




SELECT  CUST_TYPE,COUNT(*) 
FROM (
SELECT DISTINCT
IIF(LCU.[Customer_Id] IS NULL, 'CID-0001+SU',CONCAT('CID-',LCU.[Customer_Id],'+SU'))CUST_ID,
CASE WHEN 
[Middle_Name] IS NULL THEN CONCAT(LCU .[First_Name],' ',LCU .[Last_Name])
ELSE CONCAT(LCU .[First_Name],' ',LCU .[Middle_Name],' ',LCU .[Last_Name])
END AS CUST_NAME,
CONCAT(SUBSTRING( LCU.[First_Name],1,1),SUBSTRING(LCU.[Last_Name],1,5))CUST_USER_ID,
CASE WHEN LCU.[Email_Address] NOT LIKE '%@abc.com' THEN  'Invalid Email' 
ELSE 
LCU.[Email_Address]
END AS CUST_EMAIL_ID,
REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),1))CUST_STREET,
isnull(REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),2)),'NA')CUST_APARTMENT_NO,
isnull(REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),3)),'NA')CUST_SUITE_NO,
LCI.[City]  CUST_CITY,
LCI.[State] CUST_STATE,
LCI.[Country] CUST_COUNTRY  ,                            
 CONVERT(varchar, LCU.[SignUp_Date], 101) CUST_SIGN_UP_DATE,
FORMAT(LCU .[Phone],'(###)-###-####') AS [Formatted Phone],
case when  LCU.CUSTOMER_TYPE = 1 then 'Loyal Customers'
when  LCU.CUSTOMER_TYPE = 2 then 'Impulse Customers'
when LCU.CUSTOMER_TYPE =3 then 'Discount Customers'
when  LCU.CUSTOMER_TYPE =4 then 'Need-Based Customers'
when  LCU.CUSTOMER_TYPE =5 then 'Wandering Customers'
else 'Other Customers' 
end as CUST_TYPE,
LSI.[Site_Id]  SITE_ID ,                
IIF(LSI.[SITE_NAME] IS NULL,'UNK',UPPER(LSI.[SITE_NAME])) SITE_NAME,
CASE WHEN LSI.[NOTES] IS NULL THEN 'UnKnown Site'
when LSI.[NOTES] like 'R5%' THEN CONCAT(LSI.[NOTES],'KIT')
ELSE LSI.[NOTES]
END AS SITE_DESC,
 LSI.[IS_ACTIVE] SITE_STATUS,
 LCO.[Com_Desc] SITE_TYPE  ,
 LCI.[City]   SITE_CITY,
LCI.[State] SITE_STATE,
LCI.[Country] SITE_COUNTRY,
GETDATE() AS START_DATE,
 NULL AS END_DATE
FROM
[DA_C2_Src].[Lu_Site] LSI 
LEFT JOIN
[DA_C2_Src].[Lu_City] LCI1
ON LSI.[Customer_City_Id]=LCI1.[City_Id]
RIGHT JOIN 
[DA_C2_Src].[Lu_Customer] LCU
ON LCU.[Site_Id]=LSI.[Site_Id]
LEFT JOIN 
[DA_C2_Src].[Lu_Com] LCO
ON  CONVERT(INT,CONCAT('100',CONVERT(VARCHAR(10),LCO.[Com_Id])))=LCU.[Site_Id]
LEFT JOIN 
[DA_C2_Src].[Lu_City] LCI
ON LCI.[City_Id]=LSI.[Site_City_Id]
WHERE  LCU.CUSTOMER_ID IS NOT NULL and LSI.IS_ACTIVE  NOT LIKE 'D')C
 GROUP BY CUST_TYPE
 -----------------------------------------------
 select email_address,
 case when len(email_address)-len(replace(email_address,'@',''))>0
 then 'invalid'
 else email_address
 end as email
 from [DA_C2_Src].[Lu_Customer]
 

 ----DISTINCT---
 SELECT CUST_ID, COUNT(*)   
 FROM  DIM_CUST_1_SQL_IN1542 
 GROUP BY CUST_ID
 HAVING COUNT(*) >1
 ----------------------------------
 ---COLUMN LEVEL CHECK---
 SELECT COUNT(*) 
 FROM  DIM_CUST_1_SQL_IN1542 T 
 LEFT JOIN 
 (
SELECT DISTINCT
IIF(LCU.[Customer_Id] IS NULL, 'CID-0001+SU',CONCAT('CID-',LCU.[Customer_Id],'+SU'))CUST_ID,
CASE WHEN 
[Middle_Name] IS NULL THEN CONCAT(LCU .[First_Name],' ',LCU .[Last_Name])
ELSE CONCAT(LCU .[First_Name],' ',LCU .[Middle_Name],' ',LCU .[Last_Name])
END AS CUST_NAME,
CONCAT(SUBSTRING( LCU.[First_Name],1,1),SUBSTRING(LCU.[Last_Name],1,5))CUST_USER_ID,
CASE WHEN LCU.[Email_Address] NOT LIKE '%@abc.com' THEN  'Invalid Email' 
ELSE 
LCU.[Email_Address]
END AS CUST_EMAIL_ID,
REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),1))CUST_STREET,
isnull(REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),2)),'NA')CUST_APARTMENT_NO,
isnull(REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),3)),'NA')CUST_SUITE_NO,
LCI.[City]  CUST_CITY,
LCI.[State] CUST_STATE,
LCI.[Country] CUST_COUNTRY  ,                            
 CONVERT(varchar, LCU.[SignUp_Date], 101) CUST_SIGN_UP_DATE,
FORMAT(LCU .[Phone],'(###)-###-####') AS CUST_PHONE_NO,
case when  LCU.CUSTOMER_TYPE = 1 then 'Loyal Customers'
when  LCU.CUSTOMER_TYPE = 2 then 'Impulse Customers'
when LCU.CUSTOMER_TYPE =3 then 'Discount Customers'
when  LCU.CUSTOMER_TYPE =4 then 'Need-Based Customers'
when  LCU.CUSTOMER_TYPE =5 then 'Wandering Customers'
else 'Other Customers' 
end as CUST_TYPE,
LSI.[Site_Id]  SITE_ID ,                
IIF(LSI.[SITE_NAME] IS NULL,'UNK',UPPER(LSI.[SITE_NAME])) SITE_NAME,
CASE WHEN LSI.[NOTES] IS NULL THEN 'UnKnown Site'
when LSI.[NOTES] like 'R5%' THEN CONCAT(LSI.[NOTES],'KIT')
ELSE LSI.[NOTES]
END AS SITE_DESC,
 LSI.[IS_ACTIVE] SITE_STATUS,
 LCO.[Com_Desc] SITE_TYPE  ,
 LCI.[City]   SITE_CITY,
LCI.[State] SITE_STATE,
LCI.[Country] SITE_COUNTRY,
GETDATE() AS START_DATE,
 NULL AS END_DATE
FROM
[DA_C2_Src].[Lu_Site] LSI 
LEFT JOIN
[DA_C2_Src].[Lu_City] LCI1
ON LSI.[Customer_City_Id]=LCI1.[City_Id]
RIGHT JOIN 
[DA_C2_Src].[Lu_Customer] LCU
ON LCU.[Site_Id]=LSI.[Site_Id]
LEFT JOIN 
[DA_C2_Src].[Lu_Com] LCO
ON  CONVERT(INT,CONCAT('100',CONVERT(VARCHAR(10),LCO.[Com_Id])))=LCU.[Site_Id]
LEFT JOIN 
[DA_C2_Src].[Lu_City] LCI
ON LCI.[City_Id]=LSI.[Site_City_Id]
WHERE  LCU.CUSTOMER_ID IS NOT NULL and LSI.IS_ACTIVE  NOT LIKE 'D')S
ON S.CUST_ID=T.CUST_ID


WHERE T.CUST_ID IS NOT NULL
AND 
(
(T.CUST_NAME<>S.CUST_NAME) OR
(T.CUST_USER_ID<>S.CUST_USER_ID) OR
(T.CUST_EMAIL_ID<>S.CUST_EMAIL_ID) OR
(T.CUST_STREET<>S.CUST_STREET) OR
(T.CUST_APARTMENT_NO<>S.CUST_APARTMENT_NO) OR
(T.CUST_SUITE_NO<>S.CUST_SUITE_NO) OR
(T.CUST_CITY<>S.CUST_CITY) OR
(T.CUST_STATE<>S.CUST_STATE) OR
(T.CUST_COUNTRY<>S.CUST_COUNTRY) OR
(T.CUST_SIGN_UP_DATE<>S.CUST_SIGN_UP_DATE) OR
(T.CUST_PHONE_NO<>S.CUST_PHONE_NO) OR
(T.CUST_TYPE<>S.CUST_TYPE) OR
(T.SITE_ID<>S.SITE_ID) OR
(T.SITE_NAME<>S.SITE_NAME) OR
(T.SITE_DESC<>S.SITE_DESC) OR
(T.SITE_STATUS<>S.SITE_STATUS) OR
(T.SITE_TYPE<>S.SITE_TYPE) OR
(T.SITE_CITY<>S.SITE_CITY) OR
(T.SITE_STATE<>S.SITE_STATE) OR
(T.SITE_COUNTRY<>S.SITE_COUNTRY) OR
(T.START_DATE<>S.START_DATE) OR
(T.END_DATE<>S.END_DATE) 
)
----------------------------------------------------




























SELECT * FROM DIM_CUST_1_SQL_IN1542


SELECT 
*
FROM
[DA_C2_Src].[Lu_Site]




LSI.CUSTOMER_CITY_ID=LCI1.CITY_ID(+)



LEFT JOIN [DA_C2_Src].[Lu_City] LCI1

ON 

SELECT * FROM [DA_C2_Src].[Lu_Customer]