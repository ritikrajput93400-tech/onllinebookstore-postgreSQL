drop database if exists OnlineBookstore;

CREATE DATABASE OnlineBookstore;

DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
Book_ID INT PRIMARY KEY,
Title VARCHAR(100),	
Author VARCHAR(100),	
Genre VARCHAR(50),	
Published_Year INT,	
Price NUMERIC(10,2),	
Stock INT	
);

DROP TABLE  customers cascade;
CREATE TABLE Customers(
Customer_ID SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR(100),
Country VARCHAR(150)
);

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Books(Book_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2)
);

COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:\SQL\Books.csv'
DELIMITER ','
CSV HEADER;

COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:\\SQL\\Customers.csv'
DELIMITER ','
CSV HEADER;

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:\\SQL\\Orders.csv'
DELIMITER ','
CSV HEADER;

1-- reterive all  books in the "fiction " genre :
SELECT *  from Books 
where genre ='Fiction';

2-- find thebooks published after the year 1950;
select title , genre, published_year from Books 
Where published_year>1950
ORDER BY published_year ASC;

3-- list all customers from the canada;
select * from Customers
where country =  'Canada';

4--  show order placed in the november 2023;
select * from orders 
where order_date between '2023-11-01' and '2023-11-30';


5-- reterive the total stock of books available
select suM(stock) as total_stock
from Books;

6-- find the details of most expensive book
select * from Books 
order by price desc
LImit 1;

8-- show all customers who orderd more than 1 quantity of a books ;
select * from Orders
where quantity  > 1;

9-- Reterive all orders where the total amount exceeds $20
select * from Orders
where total_amount > 20;

-- list all genres avilable int books table;
select distinct genre from Books;

10-- find the books with lowest stock
select  * from Books
order by stock asc 
limit 1;

11-- calculate the total revenue generated from all orders
select sum(total_amount) from Orders;

--  advance question ;

1-- REterive the total of books sold for each genre

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
select B.Genre ,sum( O.Quantity) as Total_sold
from Books B
join Orders O   on O.book_id = B.book_id
group by genre;


2-- find the avearage price of books in the "fantasy game "
select avg(price)from Books

where genre ='Fantasy'


3-- list customers who have placed  at least 2 orders 
select o.customer_id, c.name ,count(order_id) as order_count 
from Orders o
join customers c on o.Customer_id = c.Customer_id
group by o.customer_id , c.name
having Count(order_id)>=2;

4-- find the most frequently ordered book
select o.book_id,b.genre ,count(order_id) as order_count
from Orders o 
join Books b on o.book_id= b.book_id 
group by o.book_id,b.genre
order by order_count desc
limit 1;
5-- shoe the top 3 expensive books of fantasy
select* from books 
where genre = 'Fantasy'
order by price Desc
limit 3;

6-- reterive the the total quantity of books sold by each author
select b.author , sum(o.quantity) as author_books
from Books b
join orders o on b.book_id = o.book_id
group by b.author;

7--  list the cities  customer who spent overr$30 are located 
select  C.city, O.total_amount  
from Customers C
join Orders O on C.customer_id = O.customer_id
where O.total_amount >30;

8-- find the customer who spent the most on the order 
select  c.customer_id,c.name , sum(o.total_amount) as total_spent
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_id,c.name
order by total_spent desc;


-- 9 calculate the stock remaining after fullfilling all orders:
select b.book_id ,b.title,b.stock,coalesce(sum(o.quantity),0)as order_quantity,
b.stock - coalesce(sum(o.quantity),0) as remaining_quantity
from books b
left join orders o on b.book_id = o.book_id
group by b.book_id;


