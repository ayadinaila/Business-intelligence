use northwind;


select OrderID, e.EmployeeID,LastName,FirstName,c.CustomerID,CompanyName,c.City,c.Country,month(ShippedDate) as mois,YEAR(ShippedDate) as année,
count(case when ShippedDate is not null then orderID end ) as Commandes_livrées ,
count(case when ShippedDate is null then orderID end) as Commandes_non_livrées 
from Orders o,Employees e, customers c 
where o.CustomerID=c.CustomerID and o.EmployeeID=e.EmployeeID
group by OrderID,c.CustomerID,CompanyName,c.City,c.Country,e.EmployeeID,LastName,FirstName,e.City,e.Country ,month(ShippedDate) ,YEAR(ShippedDate)





/*  1   */
select  r1.EmployeeID,r1.lastname,r1.firstname,ecity,ecountry,r1.CustomerID,company,ccity,ccountry,isnull(r2.Commandes_livrées,0) as Commandes_livrées,isnull(r3.Commandes_non_livrées,0) as Commandes_non_livrées,r1.mois,r1.année from
(select distinct OrderID, e.EmployeeID ,LastName as lastname,FirstName as firstname,e.City as ecity,e.Country as ecountry,
c.CustomerID,CompanyName as company,c.City as ccity,c.Country as ccountry ,isnull(month(ShippedDate),0) as mois,isnull(YEAR(ShippedDate),0) as année
from Orders o,Employees e, customers c where o.CustomerID=c.CustomerID and o.EmployeeID=e.EmployeeID) r1

left join 

(select OrderID, e.EmployeeID,LastName,FirstName,c.CustomerID,CompanyName,c.City,c.Country,count(OrderID) as Commandes_livrées ,month(ShippedDate) as mois,YEAR(ShippedDate) as année
from Orders o,Employees e, customers c 
where o.CustomerID=c.CustomerID and o.EmployeeID=e.EmployeeID and ShippedDate is not null
group by OrderID,c.CustomerID,CompanyName,c.City,c.Country,e.EmployeeID,LastName,FirstName,e.City,e.Country ,month(ShippedDate) ,YEAR(ShippedDate)) r2

on r1.OrderID=r2.OrderID and r1.mois=r2.mois and r1.année=r2.année

left join 
(select OrderID, e.EmployeeID,LastName,FirstName,c.CustomerID,CompanyName,c.City,c.Country,count(OrderID) as Commandes_non_livrées ,month(ShippedDate) as mois,YEAR(ShippedDate) as année
from Orders o,Employees e, customers c 
where o.CustomerID=c.CustomerID and o.EmployeeID=e.EmployeeID and ShippedDate is null
group by OrderID,c.CustomerID,CompanyName,c.City,c.Country,e.EmployeeID,LastName,FirstName,e.City,e.Country ,month(ShippedDate) ,YEAR(ShippedDate)) r3

on r1.OrderID=r3.OrderID and r1.mois=r3.mois and r1.année=r3.année

group by r1.EmployeeID,r1.mois,r1.année,r1.lastname,r1.firstname,ecity,ecountry,r1.CustomerID,company,ccity,ccountry,  Commandes_livrées, Commandes_non_livrées


/*  2   */

select p.SupplierID,CompanyName,City,Country,c.CategoryID,CategoryName,

CASE
    WHEN UnitPrice <= 50 THEN 'P1'
    WHEN UnitPrice >= 51 and  UnitPrice <=100 THEN 'P2'
    ELSE 'P3'
END AS PriceLevel,

CASE
    WHEN UnitsInStock =0 THEN 'S0'
    WHEN UnitsInStock <=30 THEN 'S1'
    ELSE 'S2'
END AS StockLevel,
count(ProductID) as nbr_produit from Products p,Suppliers s ,Categories c
where p.SupplierID=s.SupplierID and p.CategoryID=c.CategoryID
group by p.SupplierID,CompanyName,City,Country,c.CategoryID,CategoryName,UnitPrice,UnitsInStock
order by p.SupplierID;

/*  3   */

select r1.city , r1.country ,r1.OrderLevel,r1.SalesLevel from 
(select
CASE
	WHEN UnitsOnOrder<=10 then 'low'
	WHEN UnitsOnOrder >= 11 and UnitsOnOrder<=20 then 'Medium'
	else  'High'
END AS OrderLevel,

CASE
	WHEN sum(Quantity * od.UnitPrice)<=10000 then 'low'
	WHEN sum(Quantity * od.UnitPrice)>= 10001 and sum(Quantity * od.UnitPrice)<=80000 then 'Medium'
	else  'High'
END AS SalesLevel , city , country ,count(o.CustomerID) as nbr_clients
from Orders o,[Order Details] od,Products p,Customers c
where p.ProductID=od.ProductID and od.OrderID=o.OrderID and o.CustomerID=c.CustomerID
GROUP BY city, country, UnitsOnOrder) r1
group by r1.city , r1.country,r1.OrderLevel,r1.SalesLevel;



/*  4   */

select 
CompanyName,c.city,c.country,
sum(case when ShippedDate is not null then Quantity * od.UnitPrice-Quantity * od.UnitPrice *od.Discount end) as CAR ,
isnull(sum(case when ShippedDate is  null then Quantity * od.UnitPrice-Quantity * od.UnitPrice *od.Discount end) ,0) as CAC,
month(ShippedDate) as mois ,YEAR(ShippedDate) as année,
p.ProductID,p.ProductName,cat.CategoryID,cat.CategoryName
from  Orders o,[Order Details] od,Products p,Customers c,Categories cat
where p.ProductID=od.ProductID and od.OrderID=o.OrderID and o.CustomerID=c.CustomerID and cat.CategoryID=p.CategoryID
group by CompanyName,c.city,c.country,p.ProductID,p.ProductName,cat.CategoryID,cat.CategoryName,YEAR(ShippedDate),month(ShippedDate);



/*  5   */
select CompanyName,c.city,c.country,   cast(sum(discount*od.UnitPrice*Quantity)  as decimal(10,2))  as VRA ,cast(sum(discount)  as decimal(10,2))  as discount from Orders o,[Order Details] od,Products p,Customers c 
where p.ProductID=od.ProductID and od.OrderID=o.OrderID and o.CustomerID=c.CustomerID
group by CompanyName,c.city,c.country;

