-- HACKBASE: Hackathon Management Database
-- STEP 1: Database + Tables

DROP DATABASE IF EXISTS hackbase;
CREATE DATABASE hackbase;
USE hackbase;

-- 1 Hackathons (the events)
CREATE TABLE Hackathons (
    hackathon_id   INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    start_date     DATE NOT NULL,
    end_date       DATE NOT NULL,
    max_teams      INT NOT NULL,
    location       VARCHAR(100)
);

-- 2 Teams that registered for a hackathon & limited slots-> max_teams
CREATE TABLE Teams (
    team_id        INT AUTO_INCREMENT PRIMARY KEY,
    team_name      VARCHAR(100) NOT NULL,
    hackathon_id   INT NOT NULL,
    created_at     DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_team_hackathon FOREIGN KEY (hackathon_id)
        REFERENCES Hackathons(hackathon_id)
);

-- 3 Participant
CREATE TABLE Participants (
    participant_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(100) NOT NULL,
    email          VARCHAR(100) NOT NULL,
    phone          VARCHAR(20),
    skill          VARCHAR(50)
);

-- 4 Team Members 
CREATE TABLE Team_Members (
    team_id        INT NOT NULL,
    participant_id INT NOT NULL,
    role           VARCHAR(30) DEFAULT 'Member',
    PRIMARY KEY (team_id, participant_id),
    CONSTRAINT fk_tm_team FOREIGN KEY (team_id) REFERENCES Teams(team_id),
    CONSTRAINT fk_tm_participant FOREIGN KEY (participant_id) REFERENCES Participants(participant_id)
);

-- 5 Judges
CREATE TABLE Judges (
    judge_id       INT AUTO_INCREMENT PRIMARY KEY,
    full_name      VARCHAR(100) NOT NULL,
    expertise      VARCHAR(50)
);

-- 6. Submissions (each team submits one project)
CREATE TABLE Submissions (
    submission_id  INT AUTO_INCREMENT PRIMARY KEY,
    team_id        INT NOT NULL,
    project_title  VARCHAR(150) NOT NULL,
    description    VARCHAR(500),
    submitted_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_sub_team FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- 7 Scores given by judges on submissions 
CREATE TABLE Scores (
    score_id          INT AUTO_INCREMENT PRIMARY KEY,
    submission_id     INT NOT NULL,
    judge_id          INT NOT NULL,
    innovation_score  INT CHECK (innovation_score BETWEEN 0 AND 10),
    technical_score   INT CHECK (technical_score BETWEEN 0 AND 10),
    presentation_score INT CHECK (presentation_score BETWEEN 0 AND 10),
    total_score       INT,
    scored_at         DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_score_submission FOREIGN KEY (submission_id) REFERENCES Submissions(submission_id),
    CONSTRAINT fk_score_judge FOREIGN KEY (judge_id) REFERENCES Judges(judge_id)
);

SHOW TABLES;
