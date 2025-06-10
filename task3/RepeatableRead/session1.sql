SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
START TRANSACTION;

SELECT stock FROM products WHERE id = 1;
-- run session 2 after

SELECT stock FROM products WHERE id = 1;
-- should have different result

COMMIT;
