-- =========================================================
-- HACKBASE - STEP 2: Insert Sample Data
-- This adds a FEW real hackathons/teams by hand,
-- then BULK-GENERATES 3,000 participants using a stored
-- procedure loop (enough to show a real indexing speed
-- difference, while still looking like realistic project
-- data rather than an artificially huge dataset).
-- Run this WHOLE file in one go (takes a few seconds).
-- =========================================================

USE hackbase;

-- ---------- Hand-entered realistic data ----------
INSERT INTO Hackathons (name, start_date, end_date, max_teams, location) VALUES
('CodeStorm 2026', '2026-08-01', '2026-08-02', 50, 'Karachi'),
('AI Builders Cup', '2026-09-10', '2026-09-11', 30, 'Lahore'),
('Fintech Hack', '2026-10-05', '2026-10-06', 40, 'Islamabad'),
('GreenTech Sprint', '2026-11-12', '2026-11-13', 25, 'Karachi');

INSERT INTO Teams (team_name, hackathon_id) VALUES
('ByteForce', 1), ('NullPointers', 1), ('DataDrivers', 1), ('CodeCrafters', 1),
('AlphaCoders', 2), ('NeuralNinjas', 2), ('VisionX', 2),
('CryptoKings', 3), ('FinHackers', 3), ('LedgerLogic', 3),
('EcoBuilders', 4), ('SolarMinds', 4);

INSERT INTO Judges (full_name, expertise) VALUES
('Dr. Ayesha Khan', 'AI/ML'),
('Eng. Bilal Ahmed', 'Web Development'),
('Dr. Sana Tariq', 'Cybersecurity'),
('Mr. Hamza Raza', 'Cloud Computing');

INSERT INTO Submissions (team_id, project_title, description) VALUES
(1, 'Smart Traffic Predictor', 'AI based traffic congestion predictor'),
(2, 'SecurePay', 'Blockchain based payment gateway'),
(5, 'StudyBuddy', 'AI study assistant chatbot'),
(11, 'SolarTrack', 'IoT based solar panel efficiency monitor');

INSERT INTO Scores (submission_id, judge_id, innovation_score, technical_score, presentation_score, total_score) VALUES
(1, 1, 9, 8, 7, 24),
(1, 2, 8, 8, 8, 24),
(2, 3, 7, 9, 8, 24),
(3, 1, 8, 7, 9, 24);

-- ---------- BULK generate 3,000 Participants ----------
DELIMITER $$
CREATE PROCEDURE generate_participants()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 3000 DO
        INSERT INTO Participants (full_name, email, phone, skill)
        VALUES (
            CONCAT('Participant_', i),
            CONCAT('user', i, '@hackbase.com'),
            CONCAT('03', LPAD(FLOOR(RAND()*999999999), 9, '0')),
            ELT(1 + FLOOR(RAND()*5), 'Frontend', 'Backend', 'AI/ML', 'UI/UX', 'DevOps')
        );
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

CALL generate_participants();
DROP PROCEDURE generate_participants;

-- Quick verification counts
SELECT (SELECT COUNT(*) FROM Participants) AS total_participants,
       (SELECT COUNT(*) FROM Teams) AS total_teams,
       (SELECT COUNT(*) FROM Hackathons) AS total_hackathons;
