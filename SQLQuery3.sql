/* les dimensions */
/* annee */
create table d_annee(
annee nvarchar(50) ,
constraint pk_dannee primary key (annee) on delete cascade,
)
/* temps */
create table d_temps(
mois_annee nvarchar(50) , 
annee nvarchar(50) ,
constraint pk_dtemps primary key (mois_annee),
constraint fk_dtemps foreign key (annee) references d_annee (annee))
/* country */
create table d_country(
country nvarchar(50) ,
constraint pk_dcountry primary key (country),
)
/* city */
create table d_city(
city nvarchar(50) ,
country nvarchar(50) ,
constraint pk_dcity primary key (city),
)

/* customers */
create table d_customers(
CustomerID nchar(8) , 
CompanyName nvarchar(50) ,
city nvarchar(50),
constraint pk_dcustomers primary key (CustomerID ),
constraint fk_dcustomers  foreign key (city ) references d_city (city))

/*suppliers */

create table d_suppliers(
SupplierID int,
CompanyName nvarchar(50) ,
city nvarchar(50),
constraint pk_dsuppliers primary key (SupplierID ),
constraint fk_dsuppliers  foreign key (city ) references d_city (city))

/* employee  */
create table d_employees(
EmployeeID int,
FirstName nvarchar(50),
LastName nvarchar(50) ,
city nvarchar(50),
constraint pk_demployees primary key (EmployeeID ),
constraint fk_demployees foreign key (city ) references d_city (city))

/*  categories */
create table d_categories(
CategoryID int,
CategoryName nvarchar(50),
constraint pk_dcategories primary key (CategoryID ))

/*  stock level  */
create table d_stocklevel(
stocklevel nvarchar(50),
constraint pk_dstocklevel primary key ( stocklevel  ))

/*  price level  */
create table d_pricelevel(
pricelevel nvarchar(50),
constraint pk_dpricelevel primary key ( pricelevel  ))

/*  order level  */
create table d_orderlevel(
orderlevel nvarchar(50),
constraint pk_dorderlevel primary key ( orderlevel  ))

/*  sales level  */
create table d_saleslevel(
saleslevel nvarchar(50),
constraint pk_dsaleslevel primary key ( saleslevel  ))

/*  tauxdiscounts  */
create table d_tauxdiscounts(
tauxdiscounts real,
constraint pk_dtauxdiscounts primary key ( tauxdiscounts  ))
/* produit */
create table d_produit(
ProductID int,
ProductName nvarchar(50),
constraint pk_dproduit primary key (ProductID ))

/* les faits */ 
/* commandes */
create table f_commandes(
mois_annee nvarchar(50) , 
CustomerID nchar(8) ,
EmployeeID int,
com_livrees int,
com_non_livrees int,
constraint pk_fcommandes primary key (mois_annee,CustomerID,EmployeeID),
constraint fk_com_mois foreign key (mois_annee) references d_temps (mois_annee),
constraint fk_com_customer foreign key (CustomerID) references d_customers (CustomerID),
constraint fk_com_employee foreign key (EmployeeID) references d_employees (EmployeeID))


/* produit */
create table f_produit(
mois_annee nvarchar(50) , 
SupplierID int,
CategoryID int,
pricelevel nvarchar(50),
stocklevel nvarchar(50),
nbr_produit int,
constraint pk_fproduit primary key (mois_annee,SupplierID,CategoryID,pricelevel,stocklevel),
constraint fk_produit_mois foreign key (mois_annee) references d_temps (mois_annee),
constraint fk_produit_supplier foreign key (SupplierID) references d_suppliers (SupplierID),
constraint fk_produit_category foreign key (CategoryID) references d_categories (CategoryID),
constraint fk_produit_pricelevel foreign key (pricelevel) references d_pricelevel (pricelevel),
constraint fk_produit_stocklevel foreign key (stocklevel) references d_stocklevel (stocklevel))

/*    clients */
create table f_clients(
mois_annee nvarchar(50) ,
orderlevel nvarchar(50),
saleslevel nvarchar(50),
nbr_clients int,
city nvarchar(50) ,
constraint pk_fclients primary key (mois_annee,orderlevel,saleslevel,city),
constraint fk_clients_mois foreign key (mois_annee) references d_temps (mois_annee),
constraint fk_clients_orderlevel foreign key (orderlevel) references d_orderlevel (orderlevel),
constraint fk_clients_saleslevel foreign key (saleslevel) references d_saleslevel (saleslevel),
constraint fk_clients_city foreign key (city) references d_city(city))


/*  chiffre d'affaire */

create table f_ca(
mois_annee nvarchar(50) , 
CustomerID nchar(8) , 
ProductID int,
CategoryID int,
ca_commande int,
ca_realise int,
constraint pk_fca primary key (mois_annee,CustomerID,ProductID,CategoryID),
constraint fk_ca_mois foreign key (mois_annee) references d_temps (mois_annee),
constraint fk_ca_CustomerID  foreign key (CategoryID ) references d_categories(CategoryID),
constraint fk_ca_ProductID  foreign key (ProductID ) references d_produit (ProductID ),
constraint fk_ca_CategoryID foreign key (CategoryID) references d_categories(CategoryID))

/*   remise */

create table f_remise(
mois_annee nvarchar(50) , 
CustomerID nchar(8) ,
tauxdiscounts  real,
sumdiscount real,
constraint pk_fremise primary key (mois_annee,CustomerID,tauxdiscounts),
constraint fk_remise_mois foreign key (mois_annee) references d_temps (mois_annee),
constraint fk_remise_customer foreign key (CustomerID) references d_customers (CustomerID),
constraint fk_remise_tauxdiscount foreign key (tauxdiscounts) references d_tauxdiscounts (tauxdiscounts))


insert into d_annee(annee)select distinct CONVERT(VARCHAR(50), year(OrderDate), 120) AS annee from northwind.dbo.Orders 

insert into d_temps(mois_annee,annee) select distinct FORMAT(OrderDate, 'MM-yyyy')  as mois_annee ,CONVERT(VARCHAR(50), year(ShippedDate), 120) AS annee from northwind.dbo.Orders


insert into d_country(country) select distinct country from northwind.dbo.Customers 

INSERT INTO d_country (country)
SELECT DISTINCT country
FROM northwind.dbo.Suppliers
WHERE country COLLATE DATABASE_DEFAULT NOT IN (SELECT country COLLATE DATABASE_DEFAULT FROM d_country);

INSERT INTO d_country (country)
SELECT DISTINCT country
FROM northwind.dbo.Employees
WHERE country COLLATE DATABASE_DEFAULT NOT IN (SELECT country COLLATE DATABASE_DEFAULT FROM d_country);

INSERT INTO d_city (city , country) select distinct city , country from northwind.dbo.Customers

INSERT INTO d_city (city , country) select distinct city , country from northwind.dbo.Employees where city
COLLATE DATABASE_DEFAULT NOT IN (SELECT city COLLATE DATABASE_DEFAULT FROM d_city)

INSERT INTO d_city (city , country) select distinct city , country from northwind.dbo.Suppliers where city
COLLATE DATABASE_DEFAULT NOT IN (SELECT city COLLATE DATABASE_DEFAULT FROM d_city)

INSERT INTO d_customers (CustomerID,CompanyName,city) select distinct CustomerID,CompanyName,city from northwind.dbo.Customers

INSERT INTO d_suppliers (SupplierID,CompanyName,city) select distinct SupplierID,CompanyName,city from northwind.dbo.Suppliers

INSERT INTO d_employees (EmployeeID,FirstName,LastName,city) select distinct EmployeeID,FirstName,LastName,city from northwind.dbo.Employees
insert into d_categories(CategoryID,CategoryName)select distinct CategoryID,CategoryName from northwind.dbo.categories

INSERT INTO f_commandes (mois_annee,CustomerID ,EmployeeID,com_livrees,com_non_livrees ) 
select format(OrderDate,'MM-yyyy') as mois_annee,c.CustomerID,e.EmployeeID,
count(case when ShippedDate is not null then orderID end ) as Commandes_livrees ,
count(case when ShippedDate is null then orderID end) as Commandes_non_livrees 
from northwind.dbo.Orders o,northwind.dbo.Employees e, northwind.dbo.customers c 
where o.CustomerID=c.CustomerID and o.EmployeeID=e.EmployeeID
group by c.CustomerID,e.EmployeeID,format(OrderDate,'MM-yyyy')

use dw_northwind



INSERT INTO f_produit (mois_annee , SupplierID,CategoryID,pricelevel,stocklevel,nbr_produit ) 
select  r1. mois_annee, r1.SupplierID ,r1.CategoryID,r1.PriceLevel,r1.StockLevel,count(r1.ProductID) as nbr_produit from 
(select format(OrderDate,'MM-yyyy') as mois_annee,s.SupplierID,c.CategoryID,
CASE
    WHEN p.UnitPrice <= 50 THEN 'P1'
    WHEN p.UnitPrice >= 51 and  p.UnitPrice <=100 THEN 'P2'
    ELSE 'P3'
END AS PriceLevel,

CASE
    WHEN p.UnitsInStock =0 THEN 'S0'
    WHEN p.UnitsInStock <=30 THEN 'S1'
    ELSE 'S2'
END AS StockLevel, p.ProductID
from northwind.dbo.Products p,northwind.dbo.Suppliers s ,northwind.dbo.Categories c,northwind.dbo.Orders o,
northwind.dbo.[Order Details] od
where p.SupplierID=s.SupplierID and p.CategoryID=c.CategoryID and p.ProductID=od.ProductID and od.OrderID=o.OrderID
)r1
group by r1.SupplierID ,r1.CategoryID,r1.PriceLevel,r1.StockLevel,r1.mois_annee
order by r1.mois_annee,r1.SupplierID;

INSERT INTO f_clients(mois_annee,orderlevel,saleslevel,city,nbr_clients)
select r1.mois_annee , r1.OrderLevel ,r1.SalesLevel,r1.city,count(r1.CustomerID) as nbr_clients from 
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
END AS SalesLevel , city , format(OrderDate,'MM-yyyy') as mois_annee,c.CustomerID
from northwind.dbo.Orders o,northwind.dbo.[Order Details] od,northwind.dbo.Products p,northwind.dbo.Customers c
where p.ProductID=od.ProductID and od.OrderID=o.OrderID and o.CustomerID=c.CustomerID
group by UnitsOnOrder,city , c.CustomerID ,format(OrderDate,'MM-yyyy') ) r1
group by r1.mois_annee ,r1.city ,r1.OrderLevel,r1.SalesLevel
order by r1.mois_annee ;

INSERT INTO f_ca(mois_annee,CustomerID ,ProductID,CategoryID,ca_commande,ca_realise)
select format(OrderDate,'MM-yyyy') as mois_annee ,c.CustomerID ,p.ProductID,cat.CategoryID,
sum(case when ShippedDate is not null then Quantity * od.UnitPrice-Quantity * od.UnitPrice *od.Discount end) as ca_commande,
isnull(sum(case when ShippedDate is  null then Quantity * od.UnitPrice-Quantity * od.UnitPrice *od.Discount end) ,0) as ca_realise
from  northwind.dbo.Orders o,northwind.dbo.[Order Details] od,northwind.dbo.Products p,northwind.dbo.Customers c,northwind.dbo.Categories cat
where p.ProductID=od.ProductID and od.OrderID=o.OrderID and o.CustomerID=c.CustomerID and cat.CategoryID=p.CategoryID
group by p.ProductID,cat.CategoryID,format(OrderDate,'MM-yyyy'),c.CustomerID;

insert into f_remise (mois_annee , CustomerID,tauxdiscounts,sumdiscount)
select format(OrderDate,'MM-yyyy') as mois_annee ,c.CustomerID, Discount,cast(sum(discount*od.UnitPrice*Quantity)  as decimal(10,2))  as sumdiscount 
from northwind.dbo.Orders o, northwind.dbo.[Order Details] od,northwind.dbo.Products p,northwind.dbo.Customers c 
where p.ProductID=od.ProductID and od.OrderID=o.OrderID and o.CustomerID=c.CustomerID
group by format(OrderDate,'MM-yyyy') ,c.CustomerID,Discount;