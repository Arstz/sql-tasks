SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

SELECT stock FROM products WHERE id = 1;
-- run session 2 after

SELECT SLEEP(10);

SELECT stock FROM products WHERE id = 1;
-- should have different result

COMMIT;
