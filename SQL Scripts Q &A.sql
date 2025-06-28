--1. Products with associated supplier names 
--We’d like to show, for each product, the associated Supplier. Show the ProductID, ProductName, and the CompanyName of the Supplier.
--Sort the result by ProductID. This question will introduce what may be a new concept—the Join clause in SQL. The Join clause is used to join two or more relational database tables together in a logical way. 
--In this case, you will join the Suppliers table to the Products table by SupplierID.

--SELECT p.ProductID, p.ProductName, s.CompanyName
--FROM Products p INNER JOIN Suppliers s
--ON p.SupplierID = s.SupplierID
--Order By ProductID

--2. Orders and the Shipper that was used
--We’d like to show a list of the Orders that were made, including the Shipper that was used. Show the OrderID, OrderDate (date only), 
--and CompanyName of the Shipper, and sort by OrderID.
--In order to not show all the orders (there’s more than 800), show only those rows with an OrderID of less than 10270.

--SELECT o.OrderID, CONVERT(date, o.OrderDate) AS OrderDate, s.CompanyName
--FROM Orders o INNER JOIN Shippers s
--ON o.ShipVia = s.ShipperID
--WHERE o.OrderID < 10270
--ORDER BY OrderID

--3. Categories, and the total products in each category
--For this problem, we’d like to see the total number of products in each category. Sort the results by the total number of products, 
--in descending order.

--SELECT c.CategoryName, COUNT(p.ProductID) AS TotalProducts
--FROM Categories c INNER JOIN Products p
--ON c.CategoryID = p.CategoryID
--GROUP BY c.CategoryName
--ORDER BY TotalProducts DESC

--4. Total customers per country/city
--In the Customers table, show the total number of customers per Country and City.

--SELECT Country, City, COUNT(*) AS TotalCustomers
--FROM Customers
--GROUP BY Country, City

--5. Products that need reordering
--What products do we have in our inventory that should be reordered? For now, just use the fields UnitsInStock and ReorderLevel, 
--where UnitsInStock is less than or equal to the ReorderLevel, Ignore the fields UnitsOnOrder and Discontinued.
--Sort the results by ProductID.

--SELECT ProductID, ProductName
--FROM Products
--WHERE UnitsInStock <= ReorderLevel
--ORDER BY ProductID

--SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
--FROM Products
--WHERE UnitsInStock <= ReorderLevel
--ORDER BY ProductID

--6. Products that need reordering, continued
--Now we need to incorporate these fields—UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued—into our calculation. 
--We’ll define “products that need reordering” with the following: .UnitsInStock plus UnitsOnOrder are less than or equal to ReorderLevel.
--The Discontinued flag is false (0).

--SELECT ProductID, ProductName
--FROM Products
--WHERE (UnitsInStock + UnitsOnOrder) <= ReorderLevel AND Discontinued = 0
--ORDER BY ProductID

--7. Customer list by region
--A salesperson for Northwind is going on a business trip to visit customers, and would like to see a list of all customers, 
--sorted by region, alphabetically.
--However, he wants the customers with no region (null in the Region field) to be at the end, instead of at the top, 
--where you’d normally find the null values. 
--Within the same region, companies should be sorted by CustomerID.

--SELECT CustomerID, CompanyName, Region
--FROM Customers
--ORDER BY CASE WHEN Region IS NULL THEN 1 ELSE 0 END, Region, CustomerID

--8. High freight charges
--Some of the countries we ship to have very high freight charges. We'd like to investigate some more shipping options for our customers, 
--to be able to offer them lower freight charges. 
--Return the three ship countries with the highest average freight overall, in descending order by average freight.

--SELECT TOP (3) ShipCountry, AVG(Freight) AS AverageFreight
--FROM Orders
--GROUP BY ShipCountry
--ORDER BY AverageFreight DESC

--9. High freight charges—2015
--We're continuing on the question above on high freight charges. Now, instead of using all the orders we have, 
--we only want to see orders from the year 2015.

--SELECT ShipCountry, AVG(Freight) AS AverageFreight
--FROM Orders
--WHERE YEAR(OrderDate) = 2015
--GROUP BY ShipCountry
--ORDER BY AverageFreight DESC

--10. High freight charges with between
--Another (incorrect) answer to the problem above is this:
--Select Top 3
--ShipCountry, AverageFreight = avg(freight)
--From Orders
--Where
--OrderDate between '20150101' and '20151231'
--Group By ShipCountry
--Order By AverageFreight desc
--Notice when you run this, it shows Sweden as the ShipCountry with the third highest
--freight charges. However, this is wrong—it should be France.
--What is the OrderID of the order that the (incorrect) answer above is missing?

--SELECT OrderID--FROM Orders--WHERE OrderDate >= '2015-12-31' AND OrderDate < '2016-01-01'--ORDER BY OrderDate

--11. High freight charges—last year
--We're continuing to work on high freight charges. We now want to get the three ship countries with the highest average freight charges. 
--But instead of filtering for a particular year, we want to use the last 12 months of order data, 
--using as the end date the last OrderDate in Orders.

--SELECT TOP 3 ShipCountry, AVG(Freight) AS AverageFreight
--FROM Orders
--WHERE OrderDate > DATEADD(MONTH, -12, (SELECT MAX(OrderDate) FROM Orders))
--GROUP BY ShipCountry
--ORDER BY AverageFreight DESC

--12. Employee/Order Detail report
--We're doing inventory, and need to show Employee and Order Detail information like the below, for all orders. 
--Sort by OrderID and Product ID.

--SELECT o.OrderID, p.ProductID, p.ProductName, (e.FirstName + ' ' + e.LastName) AS EmployeeName
--FROM Orders o INNER JOIN Employees e ON o.EmployeeID = e.EmployeeID 
--INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
--INNER JOIN Products p ON od.ProductID = p.ProductID
--ORDER BY o.OrderID, p.ProductID

--13. Customers with no orders
--There are some customers who have never actually placed an order. Show these customers.

--SELECT c.CustomerID, c.CompanyName, OrderID
--FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
--WHERE o.OrderID IS NULL

--14. Customers with no orders for EmployeeID 4
--One employee (Margaret Peacock, EmployeeID 4) has placed the most orders. However, there are some customers 
--who've never placed an order with her. 
--Show only those customers who have never placed an order with her.

--SELECT c.CustomerID, c.CompanyName, o.OrderID
--FROM Customers c LEFT JOIN Orders o ON c.CustomerID = o.CustomerID AND o.EmployeeID = 4
--WHERE o.OrderID IS NULL

--15. High-value customers
--We want to send all of our high-value customers a special VIP gift. We're defining highvalue 
--customers as those who've made at least 1 order with a total value (not including the discount) equal to $10,000 or more. 
--We only want to consider orders made in the year 2016.

--SELECT c.CustomerID, c.CompanyName, SUM(od.UnitPrice * od.Quantity) AS OlamideTotalOrderValue
--FROM Customers c 
--INNER JOIN Orders o ON c.CustomerID = o.CustomerID 
--INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
--WHERE YEAR(o.OrderDate) = 2016
--GROUP BY c.CustomerID, c.CompanyName
--HAVING SUM(od.UnitPrice * od.Quantity) >= 10000
--ORDER BY OlamideTotalOrderValue ASC

--16. High-value customers—total orders
--The manager has changed his mind. Instead of requiring that customers have at least one individual order totaling $10,000 or more, 
--he wants to define high-value customers differently. Now, high value customers are customers who have orders totaling $15,000 or
--more in 2016. How would you change the answer to the problem above?

--SELECT c.CustomerID, c.CompanyName, SUM(od.UnitPrice * od.Quantity) AS OlamideTotalOrderValue
--FROM Customers c 
--INNER JOIN Orders o ON c.CustomerID = o.CustomerID 
--INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
--WHERE YEAR(o.OrderDate) = 2016
--GROUP BY c.CustomerID, c.CompanyName
--HAVING SUM(od.UnitPrice * od.Quantity) >= 15000
--ORDER BY OlamideTotalOrderValue ASC


--17. High-value customers—with discount
--Change the answer from the previous problem to use the discount when calculating highvalue customers. 
--Order by the total amount, taking into consideration the discount.

--SELECT c.CustomerID, c.CompanyName, od.UnitPrice, od.Quantity, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalOrderValue
--FROM Customers c 
--INNER JOIN Orders o ON c.CustomerID = o.CustomerID 
--INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
--WHERE YEAR(o.OrderDate) = 2016
--GROUP BY c.CustomerID, c.CompanyName, od.UnitPrice, od.Quantity
--HAVING SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) >= 15000
--ORDER BY TotalOrderValue ASC