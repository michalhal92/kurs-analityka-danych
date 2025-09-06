#Zadanie 1: Ostatnie zamówienie klienta. Dla każdego zamówienia znajdź wartość poprzedniego zamówienia tego samego klienta.
select CustomerID,
        row_number() over (partition by CustomerID order by OrderDate) as `Numer zamówienie klienta`,
        OrderID,
        TotalAmount,
        lag(TotalAmount) over (partition by CustomerID order by OrderDate) as `Poprzednia wartosc zamowienia`,
from `sklep.Orders`
where CustomerID is not null
order by CustomerID;

#Zadanie 2: Ranking zamówień według wartości z uwzględnieniem remisów. Utwórz ranking zamówień według wartości (TotalAmount) z uwzględnieniem #remisów, używając funkcji DENSE_RANK.
select OrderID,
        TotalAmount,
        dense_rank() over (order by TotalAmount desc) as `Ranking wartości sprzedaży zamówień`
from `sklep.Orders`
where OrderID is not null
order by `Ranking wartości sprzedaży zamówień`;

#Zadanie 3: Numerowanie zamówień z kolejnością dat. Dla każdego klienta przypisz unikalny numer każdemu zamówieniu, sortując je według daty.
select OrderID,
        CustomerID,
        OrderDate,
        row_number() over (partition by CustomerID order by OrderDate) as `Numer zamówienia klienta`
from `sklep.Orders`
where OrderID is not null
order by CustomerID;

#Zadanie 4: Następna data zamówienia klienta. Znajdź datę następnego zamówienia dla każdego zamówienia klienta, używając funkcji LEAD.
select CustomerID,
        OrderDate,
        lead(OrderDate) over (partition by CustomerID order by OrderDate) as `Data kolejnego zamówienia klienta`
from `sklep.Orders`
where OrderID is not null
order by CustomerID;

#Zadanie 5: Uzupełnianie brakujących cen w tabeli Orders. Zastąp brakujące wartości w kolumnie ShippedDate dzisiejszą datą.

#wyświetla wszystkie zamówienia
select OrderID,
        ShippedDate,
        case
          when ShippedDate is null then current_timestamp()
        end as `Uzupełnione ShippedDate`,
from `sklep.Orders`;

#wyświetla poprawione zamówienia w ShippedDate
select OrderID,
        ShippedDate,
        case
          when ShippedDate is null then current_timestamp()
        end as `Uzupełnione ShippedDate`,
from `sklep.Orders`
where ShippedDate is null;

#wyświetla poprawione zamówienia w ShippedDate -> bieżąca data i TotalAmount -> 0
select OrderID,
        ShippedDate,
        case
          when ShippedDate is null then current_timestamp()
        end as `Uzupełnione ShippedDate`,
        case
          when Totalamount is null then 0
        end as `Uzupełnione wartosci zamówień`
from `sklep.Orders`
where ShippedDate is null or TotalAmount is null;

#Zadanie 6: Kategoria klientów. Kategoryzuj klientów w tabeli Customers na podstawie ich całkowitej wartości zamówień:
#„Premium”, jeśli wydali więcej niż 2000.
#„Standard”, jeśli wydali między 1000 a 2000.
#„Nowi”, jeśli wydali mniej niż 1000.
select CustomerID,
        sum(TotalAmount) as `Suma wartości zamówień klienta`,
        case
          when sum(TotalAmount)>2000 then 'Premium'
          when sum(TotalAmount) between 1000 and 2000 then 'Standard'
          when sum(TotalAmount)<1000 then 'Nowi'
        end as `Kategoria klienta`
from `sklep.Orders`
group by CustomerID
having CustomerID is not null
order by CustomerID;

#Zadanie 7: Złożona logika z CASE. W tabeli Orders, oznacz zamówienia jako
#„Bardzo duże”, jeśli wartość zamówienia jest większa niż 500.
#„Średnie”, jeśli wartość zamówienia wynosi od 100 do 500.
#„Małe”, jeśli wartość zamówienia wynosi mniej niż 100.
select OrderID,
        TotalAmount,
        case
          when TotalAmount>500 then 'Bardzo duże'
          when TotalAmount between 100 and 500 then 'Średnie'
          when TotalAmount <100 then 'Małe'
        end as `Wielkość zamówienia`
from `sklep.Orders`;

#Zadanie 8: Kategoria regionalna klientów
#„North America”, jeśli kraj to Kanada lub USA.
#„Europę”, jeśli kraj to Germany lub UK
#„Inne” dla pozostałych regionów.
select CustomerID,
        CONCAT(FirstName, ' ', LastName),
        Country,
        case
          when Country='USA' then 'North America'
          when Country='Canada' then 'North America'
          when Country='Germany' or Country='UK' then 'Europe'
          else 'Inne'
        end as `Region`
from `sklep.Customers`;

#Zadanie 9: Znajdź największą różnicę między kolejnymi zamówieniami tego samego klienta. zestawienie zamówień z datą kolejnego zamówienia klienta
with ZamowieniaZKolejnym as
(
select CustomerID,
        OrderID,
        TotalAmount,
        OrderDate,
        lead(OrderDate) over (partition by CustomerID order by OrderDate) as DataKolejnegoZamowieniaKlienta,
from `sklep.Orders`
order by CustomerID
),
RozniceCzasowe as
(
select CustomerID,
        TIMESTAMP_DIFF(DataKolejnegoZamowieniaKlienta, ZamowieniaZKolejnym.OrderDate, day) as RoznicaWDniach
from ZamowieniaZKolejnym
)
select CustomerID,
        max(RoznicaWDniach) as `Największa różnica czasowa między zamówieniami tego klienta w dniach`
from RozniceCzasowe
group by CustomerID
having `Największa różnica czasowa między zamówieniami tego klienta w dniach` is not null
order by `Największa różnica czasowa między zamówieniami tego klienta w dniach` desclimit 1

