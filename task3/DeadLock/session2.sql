START TRANSACTION;
UPDATE bank_accounts SET balance = balance - 200 WHERE id = 2;

DO SLEEP(5);

UPDATE bank_accounts SET balance = balance + 200 WHERE id = 1;
COMMIT;
