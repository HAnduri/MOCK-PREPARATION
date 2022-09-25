---Initcap---
SELECT notes,(SELECT STRING_AGG(UPPER(LEFT(VALUE,1))+SUBSTRING(VALUE,2,len(value)),' ')
FROM
STRING_SPLIT(notes,SPACE(1)))
from
[BCMPPBS].[titles]
--Abb----------------
SELECT notes,
iif(notes is null,'NA',(SELECT STRING_AGG(UPPER(LEFT(VALUE,1)),' ')
FROM
STRING_SPLIT(notes,SPACE(1))))
from
[BCMPPBS].[titles]
-------------address-one column to 3 columns -----
select LCU.[Address],
REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),1))CUST_STREET,
REVERSE(PARSENAME(REPLACE(REVERSE(REPLACE(LCU.[Address],'.','')),',','.'),2))CUST_APARTMENT_NO,
REVERSE(PARSENAME(REPLACE(REVERSE(LCU.[Address]),',','.'),3))CUST_SUITE_NO
from [DA_C2_Src].[Lu_Customer] LCU
-----------phone--
select LCU .[Phone],
FORMAT(LCU .[Phone],'(###)-###-####') AS CUST_PHONE_NO
from [DA_C2_Src].[Lu_Customer] LCU
---------------case--
select LCU.CUSTOMER_TYPE,
case when  LCU.CUSTOMER_TYPE = 1 then 'Loyal Customers'
when  LCU.CUSTOMER_TYPE = 2 then 'Impulse Customers'
when LCU.CUSTOMER_TYPE =3 then 'Discount Customers'
when  LCU.CUSTOMER_TYPE =4 then 'Need-Based Customers'
when  LCU.CUSTOMER_TYPE =5 then 'Wandering Customers'
else 'Other Customers' 
end as CUST_TYPE
from [DA_C2_Src].[Lu_Customer] LCU
----------------------------------email------
select LCU.[Email_Address],
CASE WHEN LCU.[Email_Address] NOT LIKE '%@abc.com' THEN  'Invalid Email' 
ELSE 
LCU.[Email_Address]
END AS CUST_EMAIL_ID
from [DA_C2_Src].[Lu_Customer] LCU
--------------1st two last two------
select title,left([title],2)+right([title],2)
from
[BCMPPBS].[titles]
---------sencond word capital all lower case---------
select title,stuff(lower(title),2,1,upper(substring(title,2,1)))
from [BCMPPBS].[titles]
---------------------------charindex/patindex--------
select charindex('t',title) from [BCMPPBS].[titles]
select patindex('%t%',title) from [BCMPPBS].[titles]
-------------------replace all the digits,replace all the alpa--------------

select translate('harith123abc','0123456789',replicate('0',10))

select translate('harith123abc','aeiou',replicate('$',5))
---------------------------------ZIP-------------------------------------
left(cast(A.ZIP as varchar(15))+replicate('0',6),6) ( ----0)
RIGHT(replicate('0',6)+cast(A.ZIP as varchar(15)),6)  (0----)

select stuff('kalaAA',2,3,'*&')
-----------replace 2nd and with empty-----------------
SELECT   STUFF('Haritha AND reddy AND anduri',
CHARINDEX('AND','Haritha AND reddy AND anduri',CHARINDEX('AND','Haritha AND reddy AND anduri')+1),
LEN('AND'),
'')
-------------replace second , to empty-------------
SELECT   STUFF('Haritha,reddy,anduri',
CHARINDEX(',','Haritha,reddy,anduri',CHARINDEX(',','Haritha,reddy,anduri')+1),
LEN(','),
'')
--------------------------