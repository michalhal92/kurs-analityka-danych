#Z1 Wyświetl zamówienia z ostatnich 180 dni wraz z nazwiskami klientów.#
SELECT ORDERS.*,
        LastName,
        TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), OrderDate, DAY) AS `WIEK ZAMÓWIENIA W DNIACH`
FROM `sklep.Orders` AS ORDERS
LEFT JOIN `sklep.Customers` AS CUSTOMERS
ON ORDERS.CustomerID = CUSTOMERS.CustomerID
WHERE TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), OrderDate, DAY)>180

#Z2 Wyświetl listę 10  najdroższych zamówień z nazwą produktu, jego kategorią oraz całkowitą kwotą zamówienia.
SELECT orders.OrderID,
        products.ProductName,
        products.Category,
        orders.TotalAmount
FROM `sklep.Orders` as orders
LEFT JOIN `sklep.Products` as products
ON orders.ProductID = products.ProductID
where TotalAmount is not null
order by orders.TotalAmount desc
limit 10;

#uwzględnia zamówienie 5324 które nie ma kategorii ani nazwy produktu, w moim rozumieniu polecenia - poprawnie

#dla sprawdzenia podgląd tego zamówienia - 5324
select OrderID, TotalAmount, ProductID, Quantity, WarehouseID, CustomerID, OrderDate, ShippingAddress, ShippedDate
from `sklep.Orders`
where OrderID=5324

#Z3 Połącz dane z tabel Orders, Products, Inventory oraz Warehouses, aby wyświetlić szczegółowy raport dla każdego zamówienia, zawierający nazwę produktu, magazyn, w którym produkt się znajduje, oraz ilość stanu magazynowego.
select orders.OrderID,
        products.ProductName,
        warehouses.WarehouseName,
        inventory.StockLevel
from `sklep.Orders` as orders
left join `sklep.Products` as products
on orders.ProductID = products.ProductID
left join `sklep.Inventory` as inventory
on products.ProductID = inventory.ProductID
left join `sklep.Warehouses` as warehouses
on inventory.WarehouseID = warehouses.WarehouseID;

#Z4 Połącz dane z tabel Warehouses, Inventory, i Products, aby wyświetlić wszystkie magazyny i produkty w nich przechowywane oraz datę kiedy został zarejestrowany inwentarz.
select  warehouses.WarehouseName as `Nazwa magazynu`,
        products.ProductName as `Nazwa produktu`,
        inventory.Date as `Data zarejestrowania inwantarza`
from `sklep.Inventory` as inventory
left join `sklep.Warehouses` as warehouses
on inventory.WarehouseID = warehouses.WarehouseID
left join `sklep.Products` as products
on inventory.ProductID = products.ProductID
order by WarehouseName;

#Z5  Wyświetl szczegóły wszystkich zamówień i powiązanych do nich rabatów.
select orders.*,
        discounts.*
from `sklep.Orders` as orders
left join `sklep.Discounts` as discounts
on orders.ProductID = discounts.ProductID
  and cast(orders.OrderDate as date) between discounts.StartDate and discounts.EndDate;

# zawarłem warunek złożenia zamówienia w okresie trwania rabatu, jeżeli dobrze zrozumiałem zadanie i dane w tabeli discounts

#Z6 Połącz dane z tabel Orders i Payments, aby wyświetlić pełną listę zamówień i płatności, nawet jeśli zamówienia nie mają płatności lub płatności nie są powiązane z zamówieniami.
select orders.*,
        payments.*
from `sklep.Orders` as orders
full join `sklep.Payments` as payments
on orders.OrderID = payments.OrderID;

#Z7 Wyświetl wszystkie zamówienia z ostatnich 180 dni, wraz z nazwą produktu i kategorią, do której należy produkt.
select orders.*,
        products.ProductName,
        categories.CategoryName
from `sklep.Orders` as orders
left join `sklep.Products` as products
on orders.ProductID=products.ProductID
left join `sklep.Categories` as categories
on products.CategoryID = categories.CategoryID
where timestamp_diff(current_timestamp(), orders.OrderDate, day)>180;

#Z8*  Zadanie z * (dodatkowe) Wyświetl listę klientów, którzy otrzymali rabat na swoje zamówienia. Pokaż nazwisko klienta, rodzaj rabatu i całkowitą wartość zamówienia.
select  customers.LastName,
        discounts.DiscountType,
        orders.TotalAmount
from `sklep.Orders` as orders
left join `sklep.Customers` as customers
on orders.CustomerID = customers.CustomerID
left join `sklep.Discounts` as discounts
on orders.ProductID = discounts.ProductID
  and cast(orders.OrderDate as date) between discounts.StartDate and discounts.EndDate
where discounts.DiscountID is not null
#DiscountID jest zawsze not null - sprawdzone


