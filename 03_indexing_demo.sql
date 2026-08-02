-- =========================================================
-- HACKBASE - STEP 3: Indexing Demo
-- Goal: search a participant by full_name, WITHOUT an index,
-- then WITH an index, and compare time + EXPLAIN output.
-- TAKE A SCREENSHOT after each numbered block below.
-- =========================================================

USE hackbase;

-- ---------------------------------------------------------
-- 3.1  SEARCH WITHOUT INDEX  (screenshot this block + result)
-- ---------------------------------------------------------
EXPLAIN SELECT * FROM Participants WHERE full_name = 'Participant_2417';

-- Run it for real and note the time shown bottom-right in Workbench
SELECT * FROM Participants WHERE full_name = 'Participant_2417';
-- 👉 Screenshot: EXPLAIN output (note "type: ALL" = full table scan)
--    and the query result with execution time.

-- ---------------------------------------------------------
-- 3.2  CREATE THE INDEX
-- ---------------------------------------------------------
CREATE INDEX idx_participant_name ON Participants(full_name);

-- ---------------------------------------------------------
-- 3.3  SAME SEARCH WITH INDEX  (screenshot this block + result)
-- ---------------------------------------------------------
EXPLAIN SELECT * FROM Participants WHERE full_name = 'Participant_2417';

SELECT * FROM Participants WHERE full_name = 'Participant_2417';
-- 👉 Screenshot: EXPLAIN now shows "type: ref" / "key: idx_participant_name"
--    (index used) and a much smaller execution time.

-- ---------------------------------------------------------
-- 3.4  COMPOSITE / COVERING INDEX DEMO
-- (search by skill AND full_name together — common query pattern)
-- ---------------------------------------------------------
EXPLAIN SELECT full_name, skill FROM Participants WHERE skill = 'AI/ML' AND full_name LIKE 'Participant_4%';

CREATE INDEX idx_skill_name ON Participants(skill, full_name);

EXPLAIN SELECT full_name, skill FROM Participants WHERE skill = 'AI/ML' AND full_name LIKE 'Participant_4%';
-- 👉 Screenshot before/after this composite index too.
-- This is a COVERING index because both selected columns (full_name, skill)
-- are inside the index itself, so MySQL doesn't even need to touch the table rows.

-- ---------------------------------------------------------
-- 3.5  (Optional but recommended) Index on a foreign-key style search
-- e.g. find all teams for a hackathon -> very common query
-- ---------------------------------------------------------
EXPLAIN SELECT * FROM Teams WHERE hackathon_id = 1;
CREATE INDEX idx_teams_hackathon ON Teams(hackathon_id);
EXPLAIN SELECT * FROM Teams WHERE hackathon_id = 1;
