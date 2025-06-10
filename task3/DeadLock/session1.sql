START TRANSACTION;
UPDATE bank_accounts SET balance = balance - 100 WHERE id = 1;

DO SLEEP(5);

UPDATE bank_accounts SET balance = balance + 100 WHERE id = 2;
COMMIT;
