-- =========================================================
-- HACKBASE - STEP 8: Query Optimization Demo
-- Leaderboard query: unoptimized vs optimized version.
-- =========================================================

USE hackbase;

-- ---------------------------------------------------------
-- 8.1  UNOPTIMIZED leaderboard query (no index on join/filter columns)
-- ---------------------------------------------------------
EXPLAIN ANALYZE
SELECT t.team_name, s.project_title, SUM(sc.total_score) AS total
FROM Teams t
JOIN Submissions s ON s.team_id = t.team_id
JOIN Scores sc ON sc.submission_id = s.submission_id
GROUP BY t.team_id, s.submission_id
ORDER BY total DESC;
-- 👉 Screenshot the EXPLAIN ANALYZE output (note execution time + "full scan" mentions)

-- ---------------------------------------------------------
-- 8.2  ADD INDEXES on the join/filter columns used above
-- ---------------------------------------------------------
CREATE INDEX idx_sub_team ON Submissions(team_id);
CREATE INDEX idx_score_submission ON Scores(submission_id);

-- ---------------------------------------------------------
-- 8.3  SAME QUERY AFTER OPTIMIZATION
-- ---------------------------------------------------------
EXPLAIN ANALYZE
SELECT t.team_name, s.project_title, SUM(sc.total_score) AS total
FROM Teams t
JOIN Submissions s ON s.team_id = t.team_id
JOIN Scores sc ON sc.submission_id = s.submission_id
GROUP BY t.team_id, s.submission_id
ORDER BY total DESC;
-- 👉 Screenshot: compare execution time + plan vs step 8.1 (should be faster,
-- uses index lookups instead of full scans on the join columns)

-- ---------------------------------------------------------
-- 8.4 BONUS: query rewriting example (subquery vs JOIN)
-- ---------------------------------------------------------
-- Slower style (correlated subquery):
EXPLAIN SELECT full_name FROM Participants p
WHERE p.participant_id IN (SELECT participant_id FROM Team_Members WHERE team_id = 1);

-- Faster/rewritten style (JOIN):
EXPLAIN SELECT p.full_name FROM Participants p
JOIN Team_Members tm ON tm.participant_id = p.participant_id
WHERE tm.team_id = 1;
-- 👉 Screenshot both EXPLAIN plans to show the rewrite reduces cost.
