----------------
import pyodbc
import pandas as pd
from datetime import datetime
import re

credentials={'username':'B32022_HAnduri','password':'sgFNnvSGXE8fA'
             ,'server':'systechtraining.database.windows.net'
             ,'database':'bootcamp'}

username= credentials['username']
password= credentials['password']
server= credentials['server']
database=credentials['database']


conn = pyodbc.connect('Driver={SQL Server Native Client 11.0};'
                      'Server={systechtraining.database.windows.net};'
                      'Database={bootcamp};'
                      'UID={B32022_HAnduri};'
                      'PWD={sgFNnvSGXE8fA};'
                      'Trusted_Connection=no;')
    #conn=pyodbc.connect(connstr)
cursor=conn.cursor()
    

 

    -------------------
    









    

    src_q='''select * from [BCMPWMT].[PROD]'''

    df=pd.read_sql(src_q,conn)

    df['CATLG_ITEM_ID'] = df['CATLG_ITEM_ID'] .replace('NULL',101).astype(int).fillna(101)
    df['PRMRY_DSTRBTR_NM'] = df['PRMRY_DSTRBTR_NM'].str.strip().replace('NULL','N/A').astype('str').fillna('N/A')
    df['PRMRY_VEND_NUM'] = df['PRMRY_VEND_NUM'].replace('NULL',101).astype(int).fillna(101)
    df['SRC_IMS_CRE_TS'] = df['SRC_IMS_CRE_TS'].str.strip().replace('NULL','N/A').astype('str').fillna('N/A')
    df['SRC_IMS_MODFD_TS'] = df['SRC_IMS_MODFD_TS'].str.strip().replace('NULL','N/A').astype('str').fillna('N/A')
    df['VEND_PACK_QTY'] = df['VEND_PACK_QTY'].replace('NULL',0).astype(int).fillna(0) 
    df['WHSE_PACK_QTY'] = df['WHSE_PACK_QTY'].replace('NULL',0).astype(int).fillna(0)  
    df['CURR_PRICE_MODFD_TS'] = pd.to_datetime(df['CURR_PRICE_MODFD_TS'].replace('NULL','01-01-1900 00:00:00')).fillna('01-01-1900 00:00:00')
    df['AMT_ITEM_COST'] = df['AMT_ITEM_COST'].replace('NULL',0).astype(float).fillna(0)  
    df['AMT_BASE_ITEM_PRICE'] = df['AMT_BASE_ITEM_PRICE'].replace('NULL',0).astype(float).fillna(0)  
    df['AMT_BASE_SUGG_PRICE'] = df['AMT_BASE_SUGG_PRICE'].replace('NULL',0).astype(float).fillna(0)   
    df['AMT_SUGG_PRICE'] = df['AMT_SUGG_PRICE'].replace('NULL',0).astype(float).fillna(0)   
    df['MIN_ITEM_COST'] = df['MIN_ITEM_COST'].replace('NULL',0).astype(float).fillna(0)   
    df['ORIG_PRICE'] = df['ORIG_PRICE'].replace('NULL',0).astype(float).fillna(0)   
    df['ORIG_ITEM_PRICE'] = df['ORIG_ITEM_PRICE'].replace('NULL',0).astype(float).fillna(0)   
    df['PROD_NM'] = df['PROD_NM'].str.strip().replace('NULL','N/A').astype('str').fillna('N/A')
    df['PROD_HT'] = df['PROD_HT'].apply(pd.to_numeric,errors='coerce').replace('NULL',0).astype(float).fillna(0)  
    df['PROD_WT'] = df['PROD_WT'].replace('NULL',0).astype(float).fillna(0)   
    df['PROD_LEN'] = df['PROD_LEN'].replace('NULL',0).astype(float).fillna(0)    
    df['PROD_WDTH'] = df['PROD_WDTH'].replace('NULL',0).astype(float).fillna(0)    
    df['CRE_DT'] = pd.to_datetime(df['CRE_DT'].replace('NULL','01-01-1900')).fillna('01-01-1900')
    df['CRE_USER'] = df['CRE_USER'].replace('NULL','N/A').astype('str').fillna('N/A')
    df['UPD_TS'] = pd.to_datetime(df['UPD_TS'].apply(pd.to_datetime,errors='coerce')).replace('NULL','01-01-1900 00:00:00').fillna('01-01-1900 00:00:00')
    df['UPD_USER'] = df['UPD_USER'].str.strip().replace('NULL','N/A').astype('str').fillna('N/A')

    


    

    cursor.fast_executemany = True
    
    insert_to_tmp_tbl_stmt='''insert into  stg_dim_prod_python_IN1542
    values (?,?,?,?,?,?,?,?,?,?,
            ?,?,?,?,?,?,?,?,?,?,
            ?,?,?,?)'''
    collist=[
'CATLG_ITEM_ID',
'PRMRY_DSTRBTR_NM',
'PRMRY_VEND_NUM',
'SRC_IMS_CRE_TS',
'SRC_IMS_MODFD_TS',
'VEND_PACK_QTY',
'WHSE_PACK_QTY',
'CURR_PRICE_MODFD_TS',
'AMT_ITEM_COST',
'AMT_BASE_ITEM_PRICE',
'AMT_BASE_SUGG_PRICE',
'AMT_SUGG_PRICE',
'MIN_ITEM_COST',
'ORIG_PRICE',
'ORIG_ITEM_PRICE',
'PROD_NM',
'PROD_HT',
'PROD_WT',
'PROD_LEN',
'PROD_WDTH',
'CRE_DT',
'CRE_USER',
'UPD_TS',
'UPD_USER'



         ]
    cursor.executemany(insert_to_tmp_tbl_stmt, df[collist].values.tolist())
 
    conn.commit()

   
    target_insert='''insert into  dim_prod_python_IN1542
    select  
CATLG_ITEM_ID,
PRMRY_DSTRBTR_NM,
PRMRY_VEND_NUM,
SRC_IMS_CRE_TS,
SRC_IMS_MODFD_TS,
VEND_PACK_QTY,
WHSE_PACK_QTY,
CURR_PRICE_MODFD_TS,
AMT_ITEM_COST,
AMT_BASE_ITEM_PRICE,
AMT_BASE_SUGG_PRICE,
AMT_SUGG_PRICE,
MIN_ITEM_COST,
ORIG_PRICE,
ORIG_ITEM_PRICE,
PROD_NM,
PROD_HT,
PROD_WT,
PROD_LEN,
PROD_WDTH,
CRE_DT,
CRE_USER,
UPD_TS,
UPD_USER




    from stg_dim_prod_python_IN1542'''
    
    cursor.execute(target_insert)
    conn.commit()







    
    
    
    
if __name__=='__main__':
    main()


           
           
      
            























cursor = conn.cursor()

sql_query_title = '''select * from BCMPPBS.titles'''

sql_query_authors = '''select * from BCMPPBS.authors'''

df1 = pd.read_sql(sql_query_title,conn)

df2 = pd.read_sql(sql_query_authors,conn)

df2.columns

def price(a):    
    if a < 2:
        return a+a*0.3   
    else:       
        return a+a*0.1    
def abb(a):##abbrevations    a=a.title()    a=re.sub("[-?:\s.,'a-z]",'',a)    return a

def second(a):    a=a.split()    return a[1]

df1['Notes3'] = df1['notes'].apply(lambda x:x.replace(' ',','))


def addr1(a):    a=a.split(',')    return a[0]

def addr2(a):    a=a.split(',')    return a[1]

def addr3(a):    a=a.split(',')    return a[2]


def f2tol2(a):    return a[0:2]+a[-2:]    
x = re.sub("\s", "9", txt)    

df1['street']=df1['Notes3'].apply(lambda x:addr1(x)).fillna('NA')

df1['city']=df1['Notes3'].apply(lambda x:addr2(x))

df1['county']=df1['Notes3'].apply(lambda x:addr3(x))


df1['Notes'] = df1['notes'].fillna('N A').apply(lambda x:abb(x))

df1['Notes1'] = df1['notes'].fillna('N A').apply(lambda x:second(x))

df1['Notes2'] = df1['notes'].fillna('N A').apply(lambda x:f2tol2(x))


df1['Title_ID']='T-'+df1['title_id']+'-001'
df1['Title_Desc']=(df1['type'].str.upper()+'-'+df1['title'].str.upper()).fillna('Title Not Found')
df1['Title_Desc']='TT-'+df1['type'].str.capitalize().fillna('Type Not Found')
df1['Pub_ID'] = df1['pub_id'].str.strip().str.upper().fillna('No Publisher ID Found')
df1['Price'] = df1['price'].apply(lambda x : price(x)).fillna(0)
df1['Notes'] = (df1['notes'].str[0:3]+df1['notes'].str[-2:]).fillna('Notes Not Found')
df1['Publish_Date'] = df1['pubdate'].dt.strftime('%Y-%b-%d').fillna('1900-JAN-01')

df2['Author_Name']=(df2['au_lname'].str[0:1]+df2['au_fname']).fillna('NA')
df2['Author_Phone'] = ('+91-('+df2['phone'].str[0:3]+')-('+df2['phone'].str[4:7]+')'+df2['phone'].str[7:]).fillna('+91-(999)-(999)-9999')
df2['Author_Address']=


txt='Haritha123abc'

##b = re.sub('[0-9]','',txt)

c = re.sub('[a-zA-Z]','',txt)

print(c)


txt = 'haritha'
print(txt.find('a',2))




# -*- coding: utf-8 -*-
"""
Created on Mon Sep 12 17:26:20 2022

@author: HAnduri
"""


import utils
import pandas as pd
from datetime import datetime
import logging
import re

logger=utils.setlogger(logfile='DIM_CHARGE_CATEG_PY.log')

def main():
    conn,cursor= utils.create_conn()
    logger.info('connect created')
    
    

    src_q='''select * from [BCMPWMT].[PROD]'''

    df=pd.read_sql(src_q,conn)
    logger.info('Query executed and src data extracted')
    df['CATLG_ITEM_ID'] = df['CATLG_ITEM_ID'] .replace('NULL',101).astype(int).fillna(101)
    df['PRMRY_DSTRBTR_NM'] = df['PRMRY_DSTRBTR_NM'].str.strip().replace('NULL','N/A').astype('str').fillna('N/A')
    df['PRMRY_VEND_NUM'] = df['PRMRY_VEND_NUM'].replace('NULL',101).astype(int).fillna(101)
    df['SRC_IMS_CRE_TS'] = df['SRC_IMS_CRE_TS'].str.strip().replace('NULL','N/A').astype('str').fillna('N/A')
    df['SRC_IMS_MODFD_TS'] = df['SRC_IMS_MODFD_TS'].str.strip().replace('NULL','N/A').astype('str').fillna('N/A')
    df['VEND_PACK_QTY'] = df['VEND_PACK_QTY'].replace('NULL',0).astype(int).fillna(0) 
    df['WHSE_PACK_QTY'] = df['WHSE_PACK_QTY'].replace('NULL',0).astype(int).fillna(0)  
    df['CURR_PRICE_MODFD_TS'] = pd.to_datetime(df['CURR_PRICE_MODFD_TS'].replace('NULL','01-01-1900 00:00:00')).fillna('01-01-1900 00:00:00')
    df['AMT_ITEM_COST'] = df['AMT_ITEM_COST'].replace('NULL',0).astype(float).fillna(0)  
    df['AMT_BASE_ITEM_PRICE'] = df['AMT_BASE_ITEM_PRICE'].replace('NULL',0).astype(float).fillna(0)  
    df['AMT_BASE_SUGG_PRICE'] = df['AMT_BASE_SUGG_PRICE'].replace('NULL',0).astype(float).fillna(0)   
    df['AMT_SUGG_PRICE'] = df['AMT_SUGG_PRICE'].replace('NULL',0).astype(float).fillna(0)   
    df['MIN_ITEM_COST'] = df['MIN_ITEM_COST'].replace('NULL',0).astype(float).fillna(0)   
    df['ORIG_PRICE'] = df['ORIG_PRICE'].replace('NULL',0).astype(float).fillna(0)   
    df['ORIG_ITEM_PRICE'] = df['ORIG_ITEM_PRICE'].replace('NULL',0).astype(float).fillna(0)   
    df['PROD_NM'] = df['PROD_NM'].str.strip().replace('NULL','N/A').astype('str').fillna('N/A')
    df['PROD_HT'] = df['PROD_HT'].apply(pd.to_numeric,errors='coerce').replace('NULL',0).astype(float).fillna(0)  
    df['PROD_WT'] = df['PROD_WT'].replace('NULL',0).astype(float).fillna(0)   
    df['PROD_LEN'] = df['PROD_LEN'].replace('NULL',0).astype(float).fillna(0)    
    df['PROD_WDTH'] = df['PROD_WDTH'].replace('NULL',0).astype(float).fillna(0)    
    df['CRE_DT'] = pd.to_datetime(df['CRE_DT'].replace('NULL','01-01-1900')).fillna('01-01-1900')
    df['CRE_USER'] = df['CRE_USER'].replace('NULL','N/A').astype('str').fillna('N/A')
    df['UPD_TS'] = pd.to_datetime(df['UPD_TS'].apply(pd.to_datetime,errors='coerce')).replace('NULL','01-01-1900 00:00:00').fillna('01-01-1900 00:00:00')
    df['UPD_USER'] = df['UPD_USER'].str.strip().replace('NULL','N/A').astype('str').fillna('N/A')

    
    cleaned_df=utils.nullhandler(df)
    logger.info('Null values handled')
    

    cursor.fast_executemany = True
    
    insert_to_tmp_tbl_stmt='''insert into  stg_dim_prod_python_IN1542
    values (?,?,?,?,?,?,?,?,?,?,
            ?,?,?,?,?,?,?,?,?,?,
            ?,?,?,?)'''
    collist=[
'CATLG_ITEM_ID',
'PRMRY_DSTRBTR_NM',
'PRMRY_VEND_NUM',
'SRC_IMS_CRE_TS',
'SRC_IMS_MODFD_TS',
'VEND_PACK_QTY',
'WHSE_PACK_QTY',
'CURR_PRICE_MODFD_TS',
'AMT_ITEM_COST',
'AMT_BASE_ITEM_PRICE',
'AMT_BASE_SUGG_PRICE',
'AMT_SUGG_PRICE',
'MIN_ITEM_COST',
'ORIG_PRICE',
'ORIG_ITEM_PRICE',
'PROD_NM',
'PROD_HT',
'PROD_WT',
'PROD_LEN',
'PROD_WDTH',
'CRE_DT',
'CRE_USER',
'UPD_TS',
'UPD_USER'



         ]
    cursor.executemany(insert_to_tmp_tbl_stmt, cleaned_df[collist].values.tolist())
 
    conn.commit()

   
    target_insert='''insert into  dim_prod_python_IN1542
    select  
CATLG_ITEM_ID,
PRMRY_DSTRBTR_NM,
PRMRY_VEND_NUM,
SRC_IMS_CRE_TS,
SRC_IMS_MODFD_TS,
VEND_PACK_QTY,
WHSE_PACK_QTY,
CURR_PRICE_MODFD_TS,
AMT_ITEM_COST,
AMT_BASE_ITEM_PRICE,
AMT_BASE_SUGG_PRICE,
AMT_SUGG_PRICE,
MIN_ITEM_COST,
ORIG_PRICE,
ORIG_ITEM_PRICE,
PROD_NM,
PROD_HT,
PROD_WT,
PROD_LEN,
PROD_WDTH,
CRE_DT,
CRE_USER,
UPD_TS,
UPD_USER




    from stg_dim_prod_python_IN1542'''
    
    cursor.execute(target_insert)
    conn.commit()







    
    
    
    
if __name__=='__main__':
    main()


