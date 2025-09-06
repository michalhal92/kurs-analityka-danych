#Dodaj 20 do ceny każdego produktu i wyświetl wynik jako Cena z Transportem.
select Price+20 as `Cena z transportem`,
from `sklep.Products`;

#Wyświetl nazwy produktów i ich ceny po rabacie 12.5%.
select ProductName,
        Price*0.875 as `Cena po rabacie`
from `sklep.Products`;

#Znajdź zamówienia starsze niż 180 dni, wyświetlając ich OrderID, OrderDate i wiek zamówienia w miesiącach.
select OrderID,
        OrderDate,
        date_diff(current_date(), date(OrderDate), month) AS `Wiek zamówienia w miesiacach`,
from `sklep.Orders`
where timestamp_diff(current_timestamp(), OrderDate, day)>180;

#Wyciągnij zamówienia złożone w maju 2024 roku.
select *
from `sklep.Orders`
where OrderDate between '2024-05-01' and '2024-05-31';

#Dodaj 7 dni do daty zamówienia i wyświetl jako Data Wysyłki.
select date(date_add(OrderDate, INTERVAL 7 day)) as `Data wysyłki`,
        date(OrderDate) as `Data zamówienia`
from `sklep.Orders`;

#Wyświetl zamówienia z datą w formacie DD-MM-YYYY.
select format_date('%d-%m-%Y', TIMESTAMP(OrderDate)) as `Data w formacie DD-MM-YYYY`
from `sklep.Orders`;

#Dla każdego zamówienia wyświetl, OrderID, OrderDate, Wiek zamówienia w dniach, Całkowitą wartość zamówienia zaokrągloną do 2 miejsc po #przecinku, cenę jednostkową (TotalAmount podzielone przez Quantity).
select OrderID,
        OrderDate,
        timestamp_diff(current_timestamp(), OrderDate, day) as `Wiek zamówienia w dniach`,
        round(TotalAmount, 2) as `Całkowita wartość zamówienia zaokrągloną do 2 miejsc po przecinku`,
        TotalAmount/Quantity as `Cena jednostkowa`
from `sklep.Orders`;

#Konwertuj kolumnę Quantity na typ FLOAT64 i pomnóż przez 1.1
select cast(Quantity as float64)*1.1
from `sklep.Orders`;

#Wyświetl OrderID, datę zamówienia w formacie YYYY-MM-DD, oraz cenę po dodaniu 10% podatku.
select OrderID,
        format_date('%Y-%m-%d', TIMESTAMP(OrderDate)) as `Data w formacie YYYY-MM-DD`,
        TotalAmount*1.1 as `Cena z podatkiem 10%`
from `sklep.Orders`;

#Wyświetl OrderID, cenę po rabacie 15%, oraz wiek zamówienia w dniach.
select OrderID,
        TotalAmount*0.85,
        timestamp_diff(current_timestamp(), OrderDate, day) as `Wiek zamówienia w dniach`
        from `sklep.Orders`;

#Oblicz liczbę dni od daty zamówienia do dzisiaj.
select timestamp_diff(current_timestamp(), OrderDate, day) as `Liczba dni od daty zamówienia`,
from `sklep.Orders`