CREATE TABLE bank_accounts (
    id INT PRIMARY KEY,
    owner VARCHAR(50),
    balance INT
);

INSERT INTO bank_accounts VALUES (1, 'Alice', 1000), (2, 'Bob', 1500);
