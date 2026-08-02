-- =========================================================
-- HACKBASE - STEP 5: Concurrency Control / Locking
-- THIS REQUIRES 2 SEPARATE WORKBENCH CONNECTIONS (2 windows)
-- open to the SAME hackbase database. Call them SESSION A and SESSION B.
--
-- How to open a 2nd connection in Workbench:
-- Database menu -> "New Query Tab" is NOT enough (same session).
-- Instead: Home screen -> click your connection tile AGAIN
-- (or the "+" next to the connection) to open a second, separate session.
-- =========================================================

USE hackbase;

-- ===========  RUN IN SESSION A  ===========
START TRANSACTION;
-- Lock the row for team_id = 1 (simulate updating its score / status)
SELECT * FROM Teams WHERE team_id = 1 FOR UPDATE;
-- 👉 Screenshot: this runs fine, row is now locked by Session A
-- DO NOT COMMIT YET -- leave this transaction open and switch to Session B

-- ===========  RUN IN SESSION B (while A is still open) ===========
START TRANSACTION;
SELECT * FROM Teams WHERE team_id = 1 FOR UPDATE;
-- 👉 Screenshot: Session B will HANG / spin (waiting for the lock).
-- This proves locking + blocking is working.
-- Wait ~10-15 seconds so the wait is visible in your screenshot/recording.

-- ===========  BACK IN SESSION A  ===========
COMMIT;
-- The moment A commits, B's query above will immediately complete.
-- 👉 Screenshot: Session B's query finally returns the row.

-- ===========  RUN IN SESSION B  ===========
COMMIT;

-- ---------------------------------------------------------
-- ISOLATION LEVEL DEMO (run in Session A only)
-- ---------------------------------------------------------
SELECT @@transaction_isolation;          -- check current default (REPEATABLE-READ in MySQL)

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT @@transaction_isolation;
-- 👉 Screenshot both: shows you can change isolation levels per session

-- ---------------------------------------------------------
-- LIMITED SLOTS / RACE CONDITION DEMO (the "50 students, 30 seats" scenario)
-- Run this SAME block in Session A and Session B at almost the same time
-- (open both, select the block in both, then click Execute in A then B quickly)
-- ---------------------------------------------------------
START TRANSACTION;
SELECT COUNT(*) AS current_teams, (SELECT max_teams FROM Hackathons WHERE hackathon_id = 2) AS max_allowed
FROM Teams WHERE hackathon_id = 2
FOR UPDATE;
INSERT INTO Teams (team_name, hackathon_id) VALUES ('RaceTeamA', 2);
COMMIT;



START TRANSACTION;
SELECT COUNT(*) AS current_teams, (SELECT max_teams FROM Hackathons WHERE hackathon_id = 2) AS max_allowed
FROM Teams WHERE hackathon_id = 2
FOR UPDATE;
-- if current_teams < max_allowed, only then insert:
INSERT INTO Teams (team_name, hackathon_id) VALUES ('RaceTeamA', 2); -- change name in Session B to 'RaceTeamB'
COMMIT;
-- 👉 Screenshot: because of FOR UPDATE locking, Session B waits until A commits,
-- so the seat count can NEVER be over-booked (this is the concurrency control proof).
