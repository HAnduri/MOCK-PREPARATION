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