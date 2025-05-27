-- Retrieves customer names, book titles, quantity purchased, and any review left for that book.
-- Joins across Customers, Orders, OrderItems, Books, and Reviews.
SELECT c.name AS customer_name, b.title AS book_title, oi.quantity, r.rating, r.review_text
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN Books b ON oi.book_id = b.book_id
LEFT JOIN Reviews r ON c.customer_id = r.customer_id AND b.book_id = r.book_id;

-- Retrieves all books in the Technology genre priced below $30.
SELECT *
FROM Books
WHERE genre = 'Technology' AND price < 30;

-- Groups books by genre, counts how many books are in each genre, and calculates the average price.
-- Filters to only include genres where the average book price is greater than $25.
SELECT b.genre, COUNT(*) AS total_books, AVG(price) AS avg_price
FROM Books b
GROUP BY b.genre
HAVING AVG(price) > 25;

-- Lists customers ordered by city (A-Z) and, within each city, by name in reverse alphabetical order.
SELECT name, city
FROM Customers
ORDER BY city ASC, name DESC;

-- Retrieves the top 3 most expensive books.
SELECT *
FROM Books
ORDER BY price DESC
LIMIT 3;

-- CTE to get customers from New York.
-- Combines New York customers with customers from Chicago using UNION ALL.
WITH NY_Customers AS (
    SELECT customer_id, name, city FROM Customers WHERE city = 'New York'
)
SELECT * FROM NY_Customers
UNION ALL
SELECT customer_id, name, city FROM Customers WHERE city = 'Chicago';
