-- =========================================================
-- HACKBASE - STEP 4: Transactions & ACID
-- Run each block ONE AT A TIME (select the block, Ctrl+Enter)
-- so you can screenshot between steps.
-- =========================================================

USE hackbase;

-- ---------------------------------------------------------
-- 4.1  SUCCESSFUL TRANSACTION (register a new team = 2 steps
-- that must BOTH happen together -> Atomicity)
-- ---------------------------------------------------------
START TRANSACTION;

INSERT INTO Teams (team_name, hackathon_id) VALUES ('QuantumQuad', 1);
-- get the new team_id (note it down, e.g. it prints as LAST_INSERT_ID)
SELECT LAST_INSERT_ID() AS new_team_id;

INSERT INTO Submissions (team_id, project_title, description)
VALUES (LAST_INSERT_ID(), 'EcoTrack', 'IoT based waste management tracker');

COMMIT;
-- 👉 Screenshot: SELECT * FROM Teams; SELECT * FROM Submissions;
SELECT * FROM Teams ORDER BY team_id DESC LIMIT 3;
SELECT * FROM Submissions ORDER BY submission_id DESC LIMIT 3;

-- ---------------------------------------------------------
-- 4.2  FAILED TRANSACTION -> ROLLBACK (Atomicity proof)
-- Simulate: team registers but hackathon is already full,
-- so we manually decide to cancel everything.
-- ---------------------------------------------------------
START TRANSACTION;

INSERT INTO Teams (team_name, hackathon_id) VALUES ('GhostTeam', 2);
SELECT LAST_INSERT_ID() AS ghost_team_id;
-- 👉 Screenshot: run this in the SAME transaction window before rollback
SELECT * FROM Teams WHERE team_name = 'GhostTeam';

-- Now we decide to cancel (e.g. duplicate team / payment failed)
ROLLBACK;

-- 👉 Screenshot: prove GhostTeam does NOT exist after rollback
SELECT * FROM Teams WHERE team_name = 'GhostTeam';   -- should return EMPTYS

-- ---------------------------------------------------------
-- 4.3  CONSISTENCY CHECK: max_teams constraint via application logic
-- ---------------------------------------------------------
SELECT h.name, h.max_teams, COUNT(t.team_id) AS current_teams
FROM Hackathons h LEFT JOIN Teams t ON h.hackathon_id = t.hackathon_id
GROUP BY h.hackathon_id;
-- 👉 Screenshot this: shows current registration count vs the limit
-- (this count is what Step 5 - concurrency - will stress-test)
