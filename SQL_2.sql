#Znajdź magazyny (WarehouseName, Location), które:
#Znajdują się w “Chicago” lub “San Francisco”.
select WarehouseName, Location,
from `sklep.Warehouses`
where Location='Chicago' or Location='San Francisco';
#Ich nazwa zaczyna się na literę “C”.
select WarehouseName, Location,
from `sklep.Warehouses`
where WarehouseName like "C%";
#Znajdź produkty (ProductName, Category, Price) z tabeli Products, które:
#Należą do kategorii “Electronics” i mają cenę wyższą niż 400.
#Lub należą do kategorii “Accessories” i mają cenę w zakresie od 20 do 100.
select ProductName, Category, Price,
from `sklep.Products`
where (Category='Electronics' and Price > 400)
   or (Category='Accessories' and Price between 20 and 100);
#Przygotuj raport produktów (ProductName, Category, Price), który:Zawiera pierwsze 5 znaków nazw produktów.Zmienia #kategorię “Electronics” na “Elektronika”.Wyświetla ceny z dodanym prefiksem “Cena: ”.
select substring(ProductName, 1, 5) as Nazwa_skrocona,
       replace(Category, "Electronics", "Elektronika"),
       concat('Cena: ', Price) as Cena,
from `sklep.Products`;
#Połącz dane klientów:Połącz imię i nazwisko klientów w jedną kolumnę „Pełne Imię”.Wyświetl tylko klientów, którzy #mają przypisany adres e-mail.
select concat(FirstName, ' ', LastName) as `Pełne Imię`,
from `sklep.Customers`
where Email is not null;
#Wyciągnij fragmenty tekstu: Wyciągnij pierwsze 3 znaki z nazw produktów i nadaj alias `Skrót Nazwy`.Wyświetl tylko #produkty z ceną powyżej 300.
select substring(ProductName, 1, 3) as Skrot_nazwy
from `sklep.Products`
where Price > 300;
#Zmiana wielkości liter: Wyświetl wszystkie nazwy produktów w wielkich literach. Wyświetl tylko produkty z kategorii ‘Accessories’.
select upper(ProductName) as Nazwa_produktu
from `sklep.Products`
where Category='Accessories';
#Zamiana fragmentów tekstu:
#Zamień w nazwach produktów słowo “Phone” na “Device”.Wyświetl produkty, które zawierają cenę większą niż 500.
select replace(ProductName, 'Phone', 'Device'),
from `sklep.Products`
where Price>500;
#Długość tekstu:
#Oblicz liczbę znaków w nazwach produktów.Wyświetl tylko produkty, których długość nazwy wynosi więcej niż 7 znaków.
select ProductName, length(ProductName) as Dlugosc_nazwy_produktu,
from `sklep.Products`
where length(ProductName)>7;
#Fragmenty z lewej i prawej strony:
#Wyciągnij pierwsze 2 znaki z nazw magazynów.Wyciągnij ostatnie 3 znaki z nazw produktów.
select WarehouseName, left(WarehouseName, 2) as Nazwa_skrocona
from `sklep.Warehouses`;

select ProductName, right(ProductName, 3)
from `sklep.Products`;
#Usuwanie białych znaków:
#Usuń białe znaki z początku i końca nazw magazynów.Wyświetl wszystkie oczyszczone nazwy magazynów.
select trim(WarehouseName) as Oczyszczone_nazwy_magazynow,
from `sklep.Warehouses`;
#Przygotuj raport dla produktów (ProductName, Category, Price), który:
#Wyciąga pierwsze 4 znaki z nazwy produktu.
#Zmienia kategorię “Accessories” na “Akcesoria”.
select left(ProductName,4) as Nazwa_produktu_skrocona, replace(Category, 'Accessories', 'Akcesoria') as Category_edytowane, Price
from `sklep.Products`;




