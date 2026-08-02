-- =========================================================
-- HACKBASE - STEP 7: Recovery Demo (crash / undo-redo style)
-- We simulate a "judge submits score, app crashes mid-way" scenario,
-- and prove the DB stays consistent (nothing half-saved).
-- =========================================================

USE hackbase;

-- ---------------------------------------------------------
-- 7.1  BEFORE STATE (screenshot)
-- ---------------------------------------------------------
SELECT * FROM Scores ORDER BY score_id DESC LIMIT 5;
SELECT * FROM Submissions WHERE submission_id = 3;

-- ---------------------------------------------------------
-- 7.2  SIMULATE A MULTI-STEP OPERATION THAT "CRASHES"
-- (judge scores a project, then a 2nd related update happens,
--  but the session disconnects before COMMIT)
-- ---------------------------------------------------------
START TRANSACTION;

INSERT INTO Scores (submission_id, judge_id, innovation_score, technical_score, presentation_score, total_score)
VALUES (3, 1, 9, 9, 8, 26);

UPDATE Submissions SET description = 'FINAL ROUND - reviewed' WHERE submission_id = 3;

-- 👉 Screenshot: run this INSIDE the same open transaction (before crash)
--    to prove the change exists in this session
SELECT * FROM Scores WHERE submission_id = 3;

-- ---------------------------------------------------------
-- 7.3  SIMULATE THE CRASH
-- In Workbench: instead of typing COMMIT, click the "X" / disconnect
-- button on this connection tab (or just close the query tab),
-- OR simply run ROLLBACK manually to represent the crash recovery
-- behavior (MySQL automatically rolls back any uncommitted transaction
-- when a connection drops - this IS the real recovery mechanism).
-- ---------------------------------------------------------
ROLLBACK;   -- stand-in for "connection dropped before COMMIT"

-- ---------------------------------------------------------
-- 7.4  AFTER "RECOVERY" (open a fresh query / reconnect, then screenshot)
-- Prove the uncommitted score was undone -> Durability/Atomicity preserved
-- ---------------------------------------------------------
SELECT * FROM Scores WHERE submission_id = 3;            -- the crashed insert is GONE
SELECT * FROM Submissions WHERE submission_id = 3;        -- description is back to original

-- ---------------------------------------------------------
-- 7.5  PROVE COMMITTED DATA SURVIVES (Durability)
-- Do a normal successful transaction, COMMIT it, then literally
-- restart the MySQL service (Workbench: Administration tab ->
-- or `net stop MySQL80` / `net start MySQL80` in cmd, Windows),
-- then reconnect and re-run this SELECT.
-- ---------------------------------------------------------
START TRANSACTION;
UPDATE Submissions SET description = 'FINAL ROUND - confirmed' WHERE submission_id = 3;
COMMIT;

-- After restarting MySQL service and reconnecting:
SELECT * FROM Submissions WHERE submission_id = 3;
-- 👉 Screenshot: data is still 'FINAL ROUND - confirmed' even after restart
-- = proof of Durability (WAL/redo log already wrote it to disk on COMMIT).
