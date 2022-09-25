GET_DATE_PART( date, format )
GET_DATE_PART( DATE_SHIPPED, 'HH' )
GET_DATE_PART( DATE_SHIPPED, 'HH12' )
GET_DATE_PART( DATE_SHIPPED, 'HH24' )
GET_DATE_PART( DATE_SHIPPED, 'D' )
GET_DATE_PART( DATE_SHIPPED, 'DD' )
GET_DATE_PART( DATE_SHIPPED, 'DDD' )
GET_DATE_PART( DATE_SHIPPED, 'DY' )
GET_DATE_PART( DATE_SHIPPED, 'DAY' )
GET_DATE_PART( DATE_SHIPPED, 'MM' )
GET_DATE_PART( DATE_SHIPPED, 'MON' )
GET_DATE_PART( DATE_SHIPPED, 'MONTH' )
GET_DATE_PART( DATE_SHIPPED, 'Y' )
GET_DATE_PART( DATE_SHIPPED, 'YY' )
GET_DATE_PART( DATE_SHIPPED, 'YYY' )
GET_DATE_PART( DATE_SHIPPED, 'YYYY' )
------------------------------
IS_DATE( INVOICE_DATE )-
'04/01/98'---0
'04/01/1998 00:12:15.7008'---1
-------------------------------------------
IS_DATE( INVOICE_DATE, 'YYYY/MM/DD' )
'1998/01/12'---1
'04/01/98'---0
'1998/11/21 00:00:13'--0
-----------------------------------
IN_STR(CNAME,'/')=0 
THEN WE GER
---------------------------

----------------------------
IMP____TS___
IIF(ISNULL(UPD_TS) or UPD_TS='NULL' OR INSTR(UPD_TS,'/')=0 OR IS_DATE(UPD_TS),TO_DATE('01/01/1900','MM/DD/YYYY'),TO_DATE(UPD_TS,'MM/DD/YYYY HH12:MI:SS'))
------------------------------------
TS
IIF(ISNULL(UPD_TS) or UPD_TS='NULL' OR  INSTR(UPD_TS,'/')=0,TO_DATE('01/01/1900','MM/DD/YYYY'),TO_DATE(UPD_TS,'MM/DD/YYYY HH12:MI:SS'))
----id
IIF(IS_NUMBER(ACCT_STS_ID)=0,101,TO_INTEGER(SRC_CUST_ID))
IIF(ISNULL(UPD_TS) or UPD_TS='NULL'  OR IS_DATE(UPD_TS)=0,TO_DATE('01/01/1900','MM/DD/YYYY'),TO_DATE(UPD_TS,'MM/DD/YYYY HH12:MI:SS'))
WITH--AM/PM___TS
IIF(ISNULL(UPD_TS) or UPD_TS='NULL',TO_DATE('01/01/1900' ,'MM/DD/YYYY'),TO_DATE(substr(UPD_TS,1,20),'MM DD YYYY HH12:MI:SS'))
IIF(ISNULL(UPD_TS) or UPD_TS='NULL','N/A',TO_CHAR(TO_DATE(substr(UPD_TS,1,10),' DD MONTH YYYY')))

DATETIME TO N_VARCHAR YY/MM/DD
TO_CHAR(IIF(ISNULL(OFFR_START_TS) or OFFR_START_TS='NULL',TO_DATE('01/01/1900','MM/DD/YYYY'),TO_DATE(substr(OFFR_START_TS,1,10),'MM/DD/YYYY')), 'YY/MM/DD')
TO_CHAR(IIF(ISNULL(UPD_TS) or UPD_TS='NULL',TO_DATE('01/01/1900','MM/DD/YYYY'),TO_DATE(substr(UPD_TS,1,10),'MM/DD/YYYY')), 'DD/MONTH/YYYY')

select * from Dim_OFFR_infa_IN1542 
SELECT * FROM [BCMPWMT].[OFFR]

BCMPWMT.RPT_HRCHY
select * from  [BCMPWMT].[RTN_ORDER_LINE]dim_rpt_hrchy_infa_IN1542

DIM_CUST_infa_IN1542
dim_CUST_ACCT_infa_IN1542

UPD_TS:
IIF(ISNULL(UPD_TS) or UPD_TS='NULL',TO_DATE('01/01/1900','MM/DD/YYYY'),TO_DATE(substr(UPD_TS,1,10),'MM/DD/YYYY'))

 SELECT * FROM [BCMPWMT].[RTN_ORDER_LINE]
 IIF(ISNULL(UPD_TS1) OR IS_DATE(UPD_TS1,'DD/MM/YYYY HH12:MI:SS') OR UPD_TS1 = 'NULL',TO_CHAR(TO_DATE('01-01-1900','MM-DD-YYYY')),TO_CHAR(TO_DATE(UPD_TS1,'MM-DD-YYYY HH12:MI:SS')))

CRE_DT:
IIF(ISNULL(CRE_DT) or CRE_DT='NULL',TO_DATE('01/01/1900','MM/DD/YYYY'),
to_date(iif(instr(
iif(instr(CRE_DT,'/',1,1)=2,CONCAT('0',CRE_DT),CRE_DT),'/',1,2)=5,concat(concat(substr(iif(instr(CRE_DT,'/',1,1)=2,CONCAT('0',CRE_DT),CRE_DT),1,3),'0'),
substr(iif(instr(CRE_DT,'/',1,1)=2,CONCAT('0',CRE_DT),CRE_DT),4,6)),CRE_DT),'MM/DD/YYYY'))

--------------------------------------

IIF(ISNULL(SRC_CRE_TS) OR SRC_CRE_TS='NULL' OR IS_DATE(SRC_CRE_TS)=0,'N/A',TO_CHAR(TO_DATE(SUBSTR(SRC_CRE_TS,1,INSTR(SRC_CRE_TS,'.',1,1)-1),'MM/DD/YYYY HH12:MI:SS')))
------------------------------

IIF(ISNULL(SRC_MODFD_TS) OR SRC_MODFD_TS='NULL' OR IS_DATE(SRC_MODFD_TS)=0,'N/A',TO_CHAR(TO_DATE(SUBSTR(SRC_MODFD_TS,1,INSTR(SRC_MODFD_TS,'.',1,1)-1),'MM/DD/YYYY HH12:MI:SS')))
----------------------------4/4/2017 10:37:48.000000-07:00------------------------------2017-04-04 10:37:24.000

to_date(IIF(ISNULL(SRC_HRCHY_MODFD_TS) or SRC_HRCHY_MODFD_TS = 'NULL' or SRC_HRCHY_MODFD_TS = '?' or is_number(SRC_HRCHY_MODFD_TS) = 1,'01/01/1900 00:00:00',iif(instr(SRC_HRCHY_MODFD_TS,'/',1,2)=4,substr(SRC_HRCHY_MODFD_TS,1,17),substr(SRC_HRCHY_MODFD_TS,1,18))))

-------------------------------3/25/2016============2016-03-25
IIF(ISNULL(CRE_DT) or CRE_DT='NULL' or CRE_DT='?' or is_number(CRE_DT)=1,TO_DATE('01/01/1900','MM/DD/YYYY'),
to_date(iif(instr(
iif(instr(CRE_DT,'/',1,1)=2,CONCAT('0',CRE_DT),CRE_DT),'/',1,2)=5,concat(concat(substr(iif(instr(CRE_DT,'/',1,1)=2,CONCAT('0',CRE_DT),CRE_DT),1,3),'0'),
substr(iif(instr(CRE_DT,'/',1,1)=2,CONCAT('0',CRE_DT),CRE_DT),4,6)),CRE_DT),'MM/DD/YYYY'))

-----------------------------------------------4/20/2017 16:01:46.890000-07:00=====2017-04-20 16:01:46.000
to_date(IIF(ISNULL(UPD_TS) or UPD_TS = 'NULL' or UPD_TS = '?' or is_number(UPD_TS) = 1,'01/01/1900 00:00:00',iif(instr(UPD_TS,'/',1,2)=4,substr(UPD_TS,1,17),substr(UPD_TS,1,18))))
BCMPWMT.ORDER_LINE_CHRG
-------------------------------------------------
SELECT * INTO Dim_ORG_TYPE_LKP_infa_IN1542

FROM Dim_ORG_TYPE_LKP_SQL_IN1542
--------------------------------------------------
INSERT INTO TABLE NAME
SELECT * FROM OLF_TABLE


 ---------

 length         LENGTH(Column_Name) 
--------------substr-------------------------
Remove First Two Characters     SUBSTR('abcdef',3)
 Extract Third and Fourth Character  SUBSTR('abcdef',3,2)
 to extract last 3 characters from the string.  SUBSTR('abcdef',-3,3)
 ---------------------------lpad/rpad---------------------
Pads Marks With 0's and the length of the string is always uniformLPAD       ----(Marks, 3, '0') ---10-->010
RPAD (Column, 5, '-’)  		Test-------->Test-
----------------rtrim/ltrim-------------------
RTRIM (ITEM) 'haritha '--'haritha'
RTRIM (ITEM,'10') --- 0510 -    05
-----------------concat------------------
Concatenation Operator - ||
---------------------------------------------
last date of the month
LAST_DAY( ORDER_DATE ) 
Apr 1 1998 12:00:00AM   --------Apr 30 1998 12:00:00AM
---------------
ADD_TO_DATE(ADD_TO_DATE(LAST_DAY( ORDER_DATE ),'MM',-1),'DD',1)
 first day of the month for each date in the
 ----------------------------
  GET_DATE_PART ( DATE_SHIPPED, 'D' )
