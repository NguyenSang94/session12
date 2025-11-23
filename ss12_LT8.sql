CREATE TABLE accounts(
                         account_id SERIAL PRIMARY KEY,
                         balance INT
);
INSERT INTO accounts(balance) VALUES (1000);
BEGIN;       -- Transaction bắt đầu

SELECT balance FROM accounts WHERE account_id = 1;

-- lúc này chờ Session B cập nhật

SELECT balance FROM accounts WHERE account_id = 1;

COMMIT;
UPDATE accounts
SET balance = 2000
WHERE account_id = 1;

COMMIT;
SET SESSION CHARACTERISTICS AS TRANSACTION ISOLATION LEVEL REPEATABLE READ;

BEGIN;
SELECT balance FROM accounts WHERE account_id = 1;    -- = 1000

-- Đợi Session B update

SELECT balance FROM accounts WHERE account_id = 1;    -- vẫn = 1000 !!

COMMIT;
UPDATE accounts
SET balance = 2000
WHERE account_id = 1;

COMMIT;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;

SELECT balance
FROM accounts
WHERE account_id = 1
    FOR UPDATE;

-- Session B sẽ bị block không update được

COMMIT;
