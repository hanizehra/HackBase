-- =========================================================
-- HACKBASE - STEP 6: Deadlock Demo
-- AGAIN needs 2 sessions (Session A and Session B), same as Step 5.
-- We make them lock TWO rows in OPPOSITE ORDER -> classic deadlock.
-- =========================================================

USE hackbase;

-- ===========  SESSION A  ===========
START TRANSACTION;
UPDATE Teams SET team_name = 'ByteForce_X' WHERE team_id = 1;   -- locks team_id 1
-- now pause here, switch to Session B, do NOT commit yet

-- ===========  SESSION B  ===========
START TRANSACTION;
UPDATE Teams SET team_name = 'NullPointers_X' WHERE team_id = 2;  -- locks team_id 2
-- now Session B tries to also touch team_id 1 (held by A):
UPDATE Teams SET team_name = 'NullPointers_Y' WHERE team_id = 1;  -- 👉 this will WAIT (blocked by A)

-- ===========  BACK IN SESSION A  ===========
-- Now Session A tries to touch team_id 2 (held by B) -> circular wait!
UPDATE Teams SET team_name = 'ByteForce_Y' WHERE team_id = 2;
-- 👉 MySQL's deadlock detector will almost instantly ABORT ONE of the two
-- sessions with an error like:
--   Error Code: 1213. Deadlock found when trying to get lock;
--   try restarting transaction
-- 👉 SCREENSHOT THIS ERROR MESSAGE — this is your main deadlock proof.

-- The surviving session can now commit normally:
COMMIT;     -- run this in whichever session did NOT get the deadlock error

-- ---------------------------------------------------------
-- View deadlock details from MySQL's own engine log
-- ---------------------------------------------------------
SHOW ENGINE INNODB STATUS;
-- 👉 Screenshot the "LATEST DETECTED DEADLOCK" section of the output
-- (scroll down in the result — it shows both transactions, the locks
-- each held/wanted, and which one MySQL chose as the victim).
