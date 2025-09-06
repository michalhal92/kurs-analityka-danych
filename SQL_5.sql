#Ćwiczenie 1  Liczba zamówień dla każdego klienta W tabeli Orders, policz liczbę zamówień dla każdego klienta.
select CustomerID,
       count(TotalAmount) as `Ilość zamówień`
from `sklep.Orders`
group by CustomerID
having CustomerID is not null
order by CustomerID;

#Ćwiczenie 2:  Całkowita wartość zamówień dla magazynów W tabeli Orders, policz łączną wartość zamówień obsługiwanych przez każdy magazyn.
select orders.WarehouseID,
        warehouses.WarehouseName,
        round(sum(orders.TotalAmount), 2) AS `Wartość zamówień obsłużonych przez magazyn`
from `sklep.Orders` as orders
left join `sklep.Warehouses` as warehouses
on orders.WarehouseID = warehouses.WarehouseID
group by WarehouseID, WarehouseName
order by WarehouseID;

#Ćwiczenie 3:  Średnia wartość zamówienia dla kategorii produktów W tabelach Orders i Products, oblicz średnią wartość zamówień dla każdej kategorii produktów.
select PRODUCTS.Category,
        avg(ORDERS.TotalAmount) AS `Średnia wartość zamówienia w kategorii`
from `sklep.Orders` AS ORDERS
LEFT JOIN `sklep.Products` AS PRODUCTS
ON ORDERS.ProductID=PRODUCTS.ProductID
GROUP BY PRODUCTS.Category;

#Ćwiczenie 4:  Liczba produktów w magazynach W tabeli Inventory, policz liczbę różnych produktów przechowywanych w każdym magazynie.
SELECT WAREHOUSES.WarehouseName,
        COUNT(DISTINCT INVENTORY.ProductID) AS `Ilość różnych produktów w magazynie`
FROM `sklep.Inventory` AS INVENTORY
LEFT JOIN `sklep.Warehouses` AS WAREHOUSES
ON INVENTORY.WarehouseID=WAREHOUSES.WarehouseID
GROUP BY WAREHOUSES.WarehouseName;

#Ćwiczenie 5: Filtracja grup z HAVING W tabeli Orders, znajdź klientów, którzy złożyli co najmniej 5 zamówień o łącznej wartości przekraczającej 2000.
select CustomerID,
        sum(TotalAmount) as `Łączna wartość zamówień`
from `sklep.Orders`
group by CustomerID
having sum(TotalAmount)>2000 and count(OrderID)>5;

#Ćwiczenie 6:  Produkty o dużej sprzedaży W tabelach Products i Orders, znajdź produkty, które wygenerowały łącznie więcej niż 3000 w sprzedaży.
SELECT PRODUCTS.ProductName,
        SUM(TotalAmount) AS `Suma wartosci sprzedaży`
FROM `sklep.Products` AS PRODUCTS
LEFT JOIN `sklep.Orders` AS ORDERS
ON PRODUCTS.ProductID=ORDERS.ProductID
GROUP BY PRODUCTS.ProductName
HAVING SUM(TotalAmount)>3000;

#Ćwiczenie 7:  Najlepsze magazyny W tabelach Inventory i Warehouses, znajdź magazyny z największym poziomem zapasów w pierwszej połowie roku 2024, posortowane malejąco według sumarycznej liczby #produktów.

#POSORTOWANE WG SUMY POZIOMU ZAPASÓW
SELECT WAREHOUSES. WarehouseName,
        SUM(INVENTORY.StockLevel) AS `Suma poziomu zapasów`
FROM `sklep.Warehouses` AS WAREHOUSES
LEFT JOIN `sklep.Inventory` AS INVENTORY
ON WAREHOUSES.WarehouseID=INVENTORY.WarehouseID
WHERE INVENTORY.Date BETWEEN "2024-01-01" AND "2024-05-30"
GROUP BY WAREHOUSES.WarehouseName
ORDER BY SUM(INVENTORY.StockLevel) DESC;

#POSORTOWANE WG LICZBY UNIKALNYCH PRODUKTÓW
SELECT WAREHOUSES. WarehouseName,
        SUM(INVENTORY.StockLevel) AS `Suma poziomu zapasów`,
        COUNT(DISTINCT INVENTORY.ProductID) `Liczba unikalnych produktów`
FROM `sklep.Warehouses` AS WAREHOUSES
LEFT JOIN `sklep.Inventory` AS INVENTORY
ON WAREHOUSES.WarehouseID=INVENTORY.WarehouseID
WHERE INVENTORY.Date BETWEEN "2024-01-01" AND "2024-05-30"
GROUP BY WAREHOUSES.WarehouseName
ORDER BY COUNT(DISTINCT INVENTORY.ProductID) DESC;

#Ćwiczenie 8:  Rabaty w zamówieniach W tabelach Orders i Discounts, znajdź zamówienia, w których zastosowano rabaty powyżej 10 USD..
SELECT O.OrderID,
        D.DiscountValue,
FROM `sklep.Discounts` AS D
LEFT JOIN `sklep.Orders` AS O
ON D.ProductID=O.ProductID
WHERE D.DiscountValue>10 and CAST(O.OrderDate AS DATE) BETWEEN D.StartDate and D.EndDate;

#Ćwiczenie 9: Sprzedaż według regionu i kategorii klientów W tabelach Orders i Customers, znajdź łączną wartość zamówień według kraju.

#KOD JEŻELI ROZUMIEĆ REGION JAKO KRAJ
SELECT C.Country,
        ROUND(SUM(O.TotalAmount), 2) AS `Suma sprzedaży`,
FROM `sklep.Orders` AS O
LEFT JOIN `sklep.Customers` AS C
ON C.CustomerID=O.CustomerID
GROUP BY C.Country;

#KOD JEŻELI ROZUMIEĆ REGION JAKO KOD POCZTOWY, NIE POKAZUJE WTEDY SUMY SPRZEDAŻY NA KRAJ
SELECT C.Country,
        C.PostalCode,
        ROUND(SUM(O.TotalAmount), 2) AS `Suma sprzedaży`,
FROM `sklep.Orders` AS O
LEFT JOIN `sklep.Customers` AS C
ON C.CustomerID=O.CustomerID
GROUP BY C.Country, C.PostalCode;
	

#Ćwiczenie 10: Średnia wartość zamówień dla najlepszych klientów W tabelach Orders i Customers, znajdź średnią wartość zamówienia dla klientów, którzy wydali więcej niż 1 000 w sumie.
SELECT O.CustomerID,
        AVG(O.TotalAmount) AS `Średnia wartość zamówienia klienta`
FROM `sklep.Orders` AS O
LEFT JOIN `sklep.Customers` AS C
ON O.CustomerID=C.CustomerID
GROUP BY O.CustomerID
HAVING SUM(O.TotalAmount) > 1000
ORDER BY O.CustomerID;

#Ćwiczenie 11: Wyodrębnianie i Grupowanie według Miesiąca. W tabeli Orders, policz łączną wartość zamówień dla każdego miesiąca.
SELECT FORMAT_DATE('%Y-%m', O.OrderDate) AS `Miesiąc zamówienia`,
        ROUND(SUM(O.TotalAmount), 2) as `Łączna wartość zamówień`
FROM `sklep.Orders` as O
GROUP BY `Miesiąc zamówienia`
HAVING `Miesiąc zamówienia` IS NOT NULL
ORDER BY `Miesiąc zamówienia`;

#Ćwiczenie 12: Grupowanie według Produktów i Magazynów. W tabelach Products i Inventory, znajdź maksymalny poziom zapasów dla każdego produktu w każdym magazynie.
#v1 - zwraca najwyższy StockLevel dla każdego z produktów
SELECT P.ProductName,
        MAX(I.StockLevel) AS `ZAPAS PRODUKTU W NAJBARDZIEJ ZATOWAROWANYM MAGAZYNIE`
FROM `sklep.Inventory` AS I
LEFT JOIN `sklep.Products` AS P
ON I.ProductID=P.ProductID
GROUP BY P.ProductName
ORDER BY P.ProductName;

#V2 ZWRACA STANY ZAPASÓW PRODUKTU POSORTOWANE OD NAJWYŻSZEGO
SELECT P.ProductName,
        MAX(I.StockLevel) AS `ZAPAS PRODUKTU W NAJBARDZIEJ ZATOWAROWANYM MAGAZYNIE`,
        W.WarehouseName
FROM `sklep.Inventory` AS I
LEFT JOIN `sklep.Products` AS P
ON I.ProductID=P.ProductID
LEFT JOIN `sklep.Warehouses` AS W
ON I.WarehouseID=W.WarehouseID
GROUP BY P.ProductName, W.WarehouseName
ORDER BY P.ProductName, `ZAPAS PRODUKTU W NAJBARDZIEJ ZATOWAROWANYM MAGAZYNIE` desc;

#V3 ZWRACA SUMĘ ZAPASÓW PRODUKTU ZE WSZYSTKICH MAGAZYNÓW
SELECT P.ProductName,
        SUM(I.StockLevel) AS `SUMA ZAPASÓW PRODUKTU WE WSZYSTKICH MAGAZYNACH`
FROM `sklep.Inventory` AS I
LEFT JOIN `sklep.Products` AS P
ON I.ProductID=P.ProductID
GROUP BY P.ProductName

#Ćwiczenie 13: Filtrowanie i Grupowanie według Produktów. W tabelach Products i Orders, znajdź średnią wartość zamówienia dla produktów, które zaczynają się na literę 'P'.

#Uwzględnia tylko produkty które były zamawiane
SELECT P.ProductName,
        ROUND(AVG(O.TotalAmount), 2) AS `Średnia wartość zamówienia dla produktu`
FROM `sklep.Orders` AS O
LEFT JOIN `sklep.Products` AS P
ON O.ProductID=P.ProductID
GROUP BY P.ProductName
HAVING P.ProductName LIKE 'P%';


#Uwzględnia produkty które nie miały zamówień
SELECT P.ProductName,
IFNULL((ROUND(AVG(O.TotalAmount), 2)), 0) AS `Średnia wartość zamówienia dla produktu`
FROM `sklep.Products` AS P
LEFT JOIN `sklep.Orders` AS O
ON O.ProductID=P.ProductID
GROUP BY P.ProductName
HAVING P.ProductName LIKE 'P%';

#Ćwiczenie 14: Funkcja ROUND w Grupowaniu. W tabeli Orders, policz średnią wartość zamówień zaokrągloną do dwóch miejsc po przecinku dla każdego klienta.
SELECT O.CustomerID,
        ROUND(AVG(O.TotalAmount), 2) AS `Średnia wartość zamówień klienta`
FROM `sklep.Orders` AS O
GROUP BY O.CustomerID
HAVING O.CustomerID IS NOT NULL
ORDER BY O.CustomerID

#Ćwiczenie 15: Wykorzystanie Funkcji LENGTH i Grupowanie. W tabeli Products, znajdź minimalną wartość zapasów w magazynie dla produktów, których nazwy mają więcej niż 10 znaków.
SELECT P.ProductName,
        MIN(I.StockLevel) `Minimalny poziom zapasów w magazynie`
FROM `sklep.Inventory` AS I
LEFT JOIN `sklep.Products` AS P
ON I.ProductID=P.ProductID
GROUP BY P.ProductName
HAVING LENGTH(P.ProductName)>10