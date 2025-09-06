#1. Podstawowe zapytania: SELECT
#Zadanie 1.3: Wyświetl nazwę (ProductName) i cenę (Price) wszystkich produktów z tabeli Products.
SELECT ProductName, Price,
FROM `sklep.Products`;
#2. Filtrowanie danych: WHERE
#Zadanie 2.2: Znajdź produkty z tabeli Products, które kosztują więcej niż 100.
select ProductName, Price
from `sklep.Products`
where Price > 100;
#Zadanie 2.3: Pobierz dane klientów (FirstName, LastName) z tabeli Customers, którzy mieszkają w Kanadzie.
select FirstName, LastName,
from `sklep.Customers`
where Country = 'Canada';
#Zadanie 2.4: Wyświetl zamówienia z tabeli Orders, których TotalAmount wynosi pomiędzy 500 a 1000.
select *
from `sklep.Orders`
where TotalAmount between 500 and 1000;
#3. Sortowanie danych: ORDER BY
#Zadanie 3.2: Pobierz dane klientów (FirstName, LastName, Country) z tabeli Customers, posortowane alfabetycznie według kraju (Country).
select FirstName, LastName, Country
from `sklep.Customers`
order by Country;
#Zadanie 3.3: Wyświetl wszystkie zamówienia (OrderID, OrderDate, TotalAmount) z tabeli Orders, posortowane według daty (OrderDate) w porządku #rosnącym.
select OrderID, OrderDate, TotalAmount
from `sklep.Orders`
order by OrderDate;
#4. Kombinacja filtrowania i sortowania
#Zadanie 4.2: Wyświetl klientów (FirstName, LastName, Country) z tabeli Customers, którzy mieszkają w „USA” lub „Canada”. Posortuj wyniki według #nazwiska w porządku alfabetycznym.
select FirstName, LastName, Country
from `sklep.Customers`
where Country = 'USA' or
      Country = 'Canada'
order by LastName;
#Zadanie 4.3: Znajdź zamówienia (OrderID, CustomerID, TotalAmount) z tabeli Orders, które mają TotalAmount większe niż 1000. Posortuj wyniki #według TotalAmount w kolejności malejącej.
select OrderID, CustomerID, TotalAmount
from `sklep.Orders`
where TotalAmount > 1000
order by TotalAmount desc;
#Sekcja 1: Filtrowanie danych
#Wyświetl szczegóły zamówień (OrderID, OrderDate, TotalAmount) z tabeli Orders, które:
#Zostały złożone po 1 stycznia 2023 roku i mają wartość powyżej 500, lub
#Nie mają przypisanej daty wysyłki (ShippedDate IS NULL).
select OrderID, OrderDate, TotalAmount, ShippedDate
from `sklep.Orders`
where OrderDate > '2023-01-01' and TotalAmount > 500
  or ShippedDate is null;
#2. Pobierz dane klientów (FirstName, LastName, Email) z Kanady, którzy mają adres e-mail.
select FirstName, LastName, Email
from `sklep.Customers`
where Country = 'Canada'
    and Email is not null
#Sekcja 2: Obsługa wartości NULL
#Filtrowanie z IS NOT NULL
#Wyświetl wszystkie zamówienia (OrderID, CustomerID, ShippedDate), które mają przypisaną datę wysyłki.
select OrderID, CustomerID, ShippedDate
from `sklep.Orders`
where ShippedDate is not null;


