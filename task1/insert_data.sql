-- Insert into Customers
INSERT INTO Customers VALUES
(1, 'Alice Johnson', 'alice@example.com', 'New York'),
(2, 'Bob Smith', 'bob@example.com', 'Chicago'),
(3, 'Carol White', 'carol@example.com', 'San Francisco'),
(4, 'David Brown', 'david@example.com', 'Los Angeles'),
(5, 'Eva Green', 'eva@example.com', 'New York');

-- Insert into Books
INSERT INTO Books VALUES
(101, 'SQL Mastery', 'John Doe', 29.99, 'Technology'),
(102, 'Learn Python', 'Jane Smith', 35.50, 'Technology'),
(103, 'Mystery Night', 'Agatha Christie', 19.99, 'Fiction'),
(104, 'World History', 'Tom Hanks', 25.00, 'History'),
(105, 'Modern Cooking', 'Gordon Ramsay', 27.75, 'Cooking');

-- Insert into Orders
INSERT INTO Orders VALUES
(201, 1, '2024-12-01', 59.98),
(202, 2, '2024-12-05', 35.50),
(203, 1, '2024-12-10', 45.00),
(204, 3, '2024-12-15', 27.75),
(205, 5, '2024-12-20', 54.99);

-- Insert into OrderItems
INSERT INTO OrderItems VALUES
(301, 201, 101, 1),
(302, 201, 103, 1),
(303, 202, 102, 1),
(304, 203, 104, 1),
(305, 204, 105, 1),
(306, 205, 101, 1),
(307, 205, 103, 1);

-- Insert into Reviews
INSERT INTO Reviews VALUES
(401, 1, 101, 5, 'Great book!'),
(402, 1, 103, 4, 'Very suspenseful.'),
(403, 2, 102, 3, 'Good but basic.'),
(404, 3, 105, 5, 'Delicious recipes!'),
(405, 5, 103, 4, 'Nice plot.');
