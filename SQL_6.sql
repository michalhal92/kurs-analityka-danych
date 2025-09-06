#Zadanie 1: Podzapytanie w klauzuli SELECT. Znajdź OrderID i wartość zamówienia TotalAmount dla każdego zamówienia, a obok wyświetl średnią #wartość zamówień.
select OrderID,
        TotalAmount,
        (SELECT AVG(TotalAmount) FROM `sklep.Orders`) as SredniaWartoscZamowieniaTotal
from `sklep.Orders`;

#Zadanie 2: Podzapytanie w klauzuli WHERE. Znajdź wszystkie zamówienia, których wartość jest nie większa niż średnia wartość zamówień dla wszystkich klientów.
select OrderID, TotalAmount,  
from `sklep.Orders`
where TotalAmount <= (select avg(TotalAmount) from `sklep.Orders`);

#Zadanie 3: Podzapytanie w klauzuli FROM. Znajdź łączną wartość zamówień z uwzględnieniem 10% rabatu dla wszystkich zamówień dla każdego klienta, #używając podzapytania w FROM.
select CustomerID,
        LacznaWartoscZamowienPoRabacie
from (select CustomerID, sum(TotalAmount)*0.90 as LacznaWartoscZamowienPoRabacie from `sklep.Orders` group by CustomerID)
group by CustomerID, LacznaWartoscZamowienPoRabacie
select CustomerID,
        LacznaWartoscZamowienPoRabacie
from (select CustomerID, sum(TotalAmount)*0.90 as LacznaWartoscZamowienPoRabacie from `sklep.Orders` group by CustomerID)
group by CustomerID, LacznaWartoscZamowienPoRabacie

#Zadanie 4: Skorelowane Podzapytanie. Znajdź zamówienia, które mają wartość niewiększą niż średnia wartość zamówień dla danego klienta.
select OrderID,
        TotalAmount,
from `sklep.Orders` as o
where TotalAmount <= (
  select avg(TotalAmount)
  from `sklep.Orders` as o1
  where o.CustomerID=o1.CustomerID);

#Zadanie 5: Podzapytanie z Produktem o Maksymalnej Sprzedaży. Znajdź szczegóły zamówienia (OrderID i TotalAmount) dla produktu, który osiągnął #najwyższą wartość sprzedaży.
SELECT o.OrderID, o.TotalAmount
FROM `sklep.Orders` as o
WHERE ProductID =
(
SELECT ProductID
FROM `sklep.Orders` as o1
WHERE o1.ProductID IS NOT NULL
GROUP BY o1.ProductID
ORDER BY SUM(o1.TotalAmount) DESC
LIMIT 1
);

#Zadanie 6: Podstawowe CTE Stwórz CTE, które obliczy sumaryczną wartość zamówień dla każdego klienta. Wyświetl tylko tych klientów, którzy wydali #więcej niż 2000.
WITH Klienci2000 AS
(
  SELECT CustomerID, SUM(TotalAmount) AS SumaWartosciZamowien
  FROM `sklep.Orders`
  GROUP BY CustomerID
  ORDER BY CustomerID
)
SELECT *
FROM Klienci2000
WHERE SumaWartosciZamowien>2000

#Zadanie 7: CTE z Grupowaniem Znajdź średnią wartość zapasów w magazynach dla produktów z tabeli Inventory. Użyj CTE do stworzenia tymczasowego #zestawu danych.
WITH SredniePoziomyZapasowProduktow AS
(
  SELECT ProductID, ROUND(AVG(StockLevel), 2) AS `SredniPoziomZapasow`
  FROM `sklep.Inventory`
  GROUP BY ProductID
  ORDER BY ProductID
)
SELECT *
FROM SredniePoziomyZapasowProduktow;

#Zadanie 8: CTE z Połączonymi Tabelami Stwórz CTE, które połączy informacje o zamówieniach i produktach. Znajdź łączną wartość zamówień dla #każdej kategorii produktu.
WITH TotalAmountXCategory AS
(
  SELECT P.Category, SUM(O.TotalAmount) AS `Suma sprzedaży w kategorii`
  FROM `sklep.Orders` AS O
  LEFT JOIN `sklep.Products` AS P
  ON O.ProductID=P.ProductID
  GROUP BY P.Category
)
SELECT *
FROM TotalAmountXCategory;

#Zadanie 9: Zagnieżdżone CTE Znajdź klientów, którzy mają najwięcej zamówień, używając dwóch poziomów CTE.
WITH OrdersWithMax AS (
  WITH OrdersPerCustomer AS (
    SELECT
      CustomerID,
      COUNT(DISTINCT OrderID) AS OrderCount
    FROM
      `sklep.Orders`
    GROUP BY
      CustomerID
  )
  SELECT
    *,
    (SELECT MAX(OrderCount) FROM OrdersPerCustomer) AS MaxCount
  FROM
    OrdersPerCustomer
)
SELECT
  CustomerID,
  OrderCount
FROM
  OrdersWithMax
WHERE
  OrderCount = MaxCount;

#Zadanie 10: Zastosowanie CTE do Usunięcia Duplikatów Utwórz CTE, aby znaleźć unikalne kombinacje klientów i produktów, dla których złożono #zamówienia.
WITH UniqueOrders AS
  (
  SELECT CustomerID, ProductID
  FROM `sklep.Orders`
  )
SELECT DISTINCT CustomerID, ProductID
FROM UniqueOrders;
