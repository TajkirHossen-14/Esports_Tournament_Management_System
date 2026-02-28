-- ============================================================
--   ESPORTS TOURNAMENT MANAGEMENT SYSTEM
-- ============================================================

-- ============================================================
-- DDL - TABLE CREATION
-- ============================================================

-- 1. Games
CREATE TABLE Games 
(
    GameID          INT AUTO_INCREMENT PRIMARY KEY,
    GameName        VARCHAR(100) NOT NULL,
    Genre           VARCHAR(50),
    Platform        VARCHAR(50),
    Publisher       VARCHAR(100),
    ReleaseYear     YEAR
);

-- 2. Teams 
--    CaptainID   → FK to Players (set via UPDATE after Players insert)
--    TotalWins   → cumulative tournament wins
--    TotalPrize  → total prize money earned
CREATE TABLE Teams 
(
    TeamID          INT AUTO_INCREMENT PRIMARY KEY,
    TeamName        VARCHAR(100) NOT NULL UNIQUE,
    Tag             VARCHAR(10),
    Country         VARCHAR(50),
    FoundedYear     YEAR,
    CaptainID       INT,
    TotalWins       INT DEFAULT 0,
    TotalPrize      DECIMAL(14, 2) DEFAULT 0.00
);

-- 3. Players
--    TeamID  → which team this player belongs to
--    Role    → role in the team (IGL, Sniper, Support, etc.)
CREATE TABLE Players 
(
    PlayerID        INT AUTO_INCREMENT PRIMARY KEY,
    Username        VARCHAR(50)  NOT NULL UNIQUE,
    FullName        VARCHAR(100) NOT NULL,
    Email           VARCHAR(100) UNIQUE,
    Country         VARCHAR(50),
    DateOfBirth     DATE,
    RankPoints      INT DEFAULT 0,
    JoinedDate      DATE DEFAULT (CURRENT_DATE),
    TeamID          INT,
    Role            VARCHAR(50),
    FOREIGN KEY (TeamID) REFERENCES Teams(TeamID) ON DELETE SET NULL
);

-- 4. Tournaments
--    GameID        → which game is being played
--    WinnerTeamID  → FK to Teams (set after tournament ends)
--    TotalTeams    → number of teams that participated
CREATE TABLE Tournaments 
(
    TournamentID    INT AUTO_INCREMENT PRIMARY KEY,
    TournamentName  VARCHAR(150) NOT NULL,
    GameID          INT,
    StartDate       DATE,
    EndDate         DATE,
    Location        VARCHAR(100),
    PrizePool       DECIMAL(12, 2) DEFAULT 0.00,
    Format          ENUM('Single Elimination', 'Double Elimination', 'Round Robin', 'Swiss') NOT NULL,
    Status          ENUM('Upcoming', 'Ongoing', 'Completed') DEFAULT 'Upcoming',
    WinnerTeamID    INT,
    TotalTeams      INT DEFAULT 0,
    FOREIGN KEY (GameID)       REFERENCES Games(GameID)  ON DELETE SET NULL,
    FOREIGN KEY (WinnerTeamID) REFERENCES Teams(TeamID)  ON DELETE SET NULL
);

-- 5. Matches
--    WinnerTeamID / LoserTeamID → filled after match completes
CREATE TABLE Matches 
(
    MatchID         INT AUTO_INCREMENT PRIMARY KEY,
    TournamentID    INT,
    Team1ID         INT,
    Team2ID         INT,
    MatchDate       DATETIME,
    Stage           VARCHAR(50),
    BestOf          INT DEFAULT 1,
    Status          ENUM('Scheduled', 'Live', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    WinnerTeamID    INT,
    LoserTeamID     INT,
    FOREIGN KEY (TournamentID) REFERENCES Tournaments(TournamentID) ON DELETE CASCADE,
    FOREIGN KEY (Team1ID)      REFERENCES Teams(TeamID)             ON DELETE CASCADE,
    FOREIGN KEY (Team2ID)      REFERENCES Teams(TeamID)             ON DELETE CASCADE,
    FOREIGN KEY (WinnerTeamID) REFERENCES Teams(TeamID)             ON DELETE SET NULL,
    FOREIGN KEY (LoserTeamID)  REFERENCES Teams(TeamID)             ON DELETE SET NULL,
    CHECK (Team1ID <> Team2ID)
);

-- 6. Results
--    FinalPos1/Prize1 → Team1's tournament position & prize from this match
--    FinalPos2/Prize2 → Team2's tournament position & prize from this match
--    MVPPlayerID      → best player of the match
CREATE TABLE Results 
(
    ResultID        INT AUTO_INCREMENT PRIMARY KEY,
    MatchID         INT UNIQUE,
    Team1Score      INT DEFAULT 0,
    Team2Score      INT DEFAULT 0,
    DurationMins    INT,
    MVPPlayerID     INT,
    FinalPos1       INT,
    FinalPos2       INT,
    Prize1          DECIMAL(12, 2) DEFAULT 0.00,
    Prize2          DECIMAL(12, 2) DEFAULT 0.00,
    FOREIGN KEY (MatchID)     REFERENCES Matches(MatchID)   ON DELETE CASCADE,
    FOREIGN KEY (MVPPlayerID) REFERENCES Players(PlayerID)  ON DELETE SET NULL
);


-- ============================================================
-- DML - SAMPLE DATA
-- ============================================================

-- -------------------------------------------------------
-- Games 
-- -------------------------------------------------------
INSERT INTO Games (GameName, Genre, Platform, Publisher, ReleaseYear) VALUES
('Valorant',            'Tactical Shooter', 'PC',           'Riot Games',    2020),
('CS2',                 'Tactical Shooter', 'PC',           'Valve',         2023),
('Dota 2',              'MOBA',             'PC',           'Valve',         2013),
('League of Legends',   'MOBA',             'PC',           'Riot Games',    2009),
('PUBG Mobile',         'Battle Royale',    'Mobile',       'Krafton',       2018),
('Free Fire',           'Battle Royale',    'Mobile',       'Garena',        2017),
('Apex Legends',        'Battle Royale',    'PC/Console',   'EA Respawn',    2019),
('Fortnite',            'Battle Royale',    'PC/Console',   'Epic Games',    2017),
('Rocket League',       'Sports',           'PC/Console',   'Psyonix',       2015),
('Overwatch 2',         'Team Shooter',     'PC/Console',   'Blizzard',      2022),
('Rainbow Six Siege',   'Tactical Shooter', 'PC/Console',   'Ubisoft',       2015),
('Warzone',             'Battle Royale',    'PC/Console',   'Activision',    2020),
('FIFA 24',             'Sports',           'PC/Console',   'EA Sports',     2023),
('Street Fighter 6',    'Fighting',         'PC/Console',   'Capcom',        2023),
('Tekken 8',            'Fighting',         'PC/Console',   'Bandai Namco',  2024),
('Hearthstone',         'Card Game',        'PC/Mobile',    'Blizzard',      2014),
('StarCraft II',        'RTS',              'PC',           'Blizzard',      2010),
('PUBG PC',             'Battle Royale',    'PC',           'Krafton',       2017),
('Mobile Legends',      'MOBA',             'Mobile',       'Moonton',       2016),
('Clash Royale',        'Strategy',         'Mobile',       'Supercell',     2016);

-- -------------------------------------------------------
-- Teams — inserted BEFORE Players
-- CaptainID set via UPDATE after Players insert
-- -------------------------------------------------------
INSERT INTO Teams (TeamName, Tag, Country, FoundedYear, TotalWins, TotalPrize) VALUES
('Team Nexus',       'NXS', 'Bangladesh',  2021, 2, 390000.00),
('Shadow Wolves',    'SHW', 'Bangladesh',  2020, 3, 650000.00),
('Cyber Dragons',    'CDR', 'Bangladesh',  2022, 1, 205000.00),
('Storm Riders',     'STR', 'India',       2021, 0, 110000.00),
('Phantom Force',    'PHF', 'Pakistan',    2023, 0,  30000.00),
('Iron Legion',      'IRL', 'India',       2020, 0,  12000.00),
('Neon Assassins',   'NEO', 'Nepal',       2022, 1,  75000.00),
('Blaze Squad',      'BLZ', 'Sri Lanka',   2021, 0,  10000.00),
('Titan Rush',       'TTR', 'Malaysia',    2022, 1, 100000.00),
('Void Hunters',     'VHT', 'Indonesia',   2023, 0,   0.00),
('Arctic Wolves',    'ARW', 'Philippines', 2021, 0,   0.00),
('Delta Force BD',   'DFB', 'Bangladesh',  2020, 0,   0.00),
('Omega Strike',     'OMS', 'Thailand',    2022, 0,   0.00),
('Galaxy Gamers',    'GXG', 'South Korea', 2023, 0,   0.00),
('Rebel Alliance',   'RBA', 'Bangladesh',  2021, 0,  50000.00),
('Stealth Mode',     'STM', 'India',       2022, 0,  12000.00),
('Dark Matter',      'DKM', 'Pakistan',    2020, 0,   0.00),
('Hyper Clash',      'HPC', 'South Korea', 2023, 0,   0.00),
('Code Breakers',    'CBR', 'Nepal',       2021, 0,   0.00),
('Echo Battalion',   'ECB', 'Bangladesh',  2022, 0,   0.00);

-- -------------------------------------------------------
-- Players 
-- TeamID and Role embedded directly
-- -------------------------------------------------------
INSERT INTO Players (Username, FullName, Email, Country, DateOfBirth, RankPoints, TeamID, Role) VALUES
('NightWolf',    'Arif Hossain',        'arif@mail.com',        'Bangladesh',  '2001-03-15', 1500,  1, 'IGL'),
('ShadowByte',   'Tanvir Ahmed',        'tanvir@mail.com',      'Bangladesh',  '2000-07-22', 1800,  1, 'Entry Fragger'),
('PhoenixRush',  'Rafi Islam',          'rafi@mail.com',        'Bangladesh',  '2002-01-10', 1200,  1, 'Support'),
('CyberKnight',  'Sabbir Rahman',       'sabbir@mail.com',      'Bangladesh',  '1999-11-05', 2100,  2, 'IGL'),
('StormEdge',    'Mehdi Hasan',         'mehdi@mail.com',       'Bangladesh',  '2001-09-30', 1650,  2, 'Rifler'),
('BladeRunner',  'Sumaiya Akter',       'sumaiya@mail.com',     'Bangladesh',  '2003-04-18', 1400,  2, 'Sniper'),
('ThunderX',     'Nabil Chowdhury',     'nabil@mail.com',       'Bangladesh',  '2000-12-01', 1950,  3, 'IGL'),
('IronFist',     'Rakib Uddin',         'rakib@mail.com',       'Bangladesh',  '2002-06-25', 1300,  3, 'Support'),
('FlameCore',    'Jisan Molla',         'jisan@mail.com',       'Bangladesh',  '2001-08-14', 1750,  3, 'Entry Fragger'),
('VoidSlayer',   'Priya Das',           'priya@mail.com',       'India',       '2000-02-28', 2000,  4, 'IGL'),
('PixelKing',    'Aditya Kumar',        'aditya@mail.com',      'India',       '2001-05-11', 1850,  6, 'IGL'),
('GhostAim',     'Siddharth Roy',       'sid@mail.com',         'India',       '2002-08-20', 1600, 16, 'Support'),
('NeonBlade',    'Hamza Malik',         'hamza@mail.com',       'Pakistan',    '2003-02-14', 1100,  5, 'IGL'),
('DarkPulse',    'Ali Hassan',          'ali@mail.com',         'Pakistan',    '2000-10-07', 1450,  5, 'Sniper'),
('ArcLight',     'Sanjay Karki',        'sanjay@mail.com',      'Nepal',       '2002-03-29', 1550,  7, 'IGL'),
('QuickDraw',    'Birat Thapa',         'birat@mail.com',       'Nepal',       '2001-11-18', 1700,  7, 'Support'),
('MegaForce',    'Arjun Sharma',        'arjun@mail.com',       'India',       '1999-07-04', 2200,  4, 'Rifler'),
('SkyBreaker',   'Kasun Perera',        'kasun@mail.com',       'Sri Lanka',   '2003-06-23', 1050,  8, 'IGL'),
('EchoStrike',   'Danushka Silva',      'danushka@mail.com',    'Sri Lanka',   '2001-12-30', 1620,  8, 'Support'),
('LunarWolf',    'Ahmad Faiz',          'faiz@mail.com',        'Malaysia',    '2002-04-15', 1380,  9, 'IGL'),
('HyperX99',     'Rizky Pratama',       'rizky@mail.com',       'Indonesia',   '2000-09-09', 1900, 10, 'IGL'),
('ZeroGrav',     'Juan dela Cruz',      'juan@mail.com',        'Philippines', '2003-01-27',  980, 11, 'IGL'),
('FrostBite',    'Somchai Wongsak',     'somchai@mail.com',     'Thailand',    '2001-07-08', 1250, 13, 'IGL'),
('RazorWind',    'Kim Jae-won',         'jaewon@mail.com',      'South Korea', '2000-05-19', 2350, 18, 'Entry Fragger'),
('NovaSurge',    'Park Sung-min',       'sungmin@mail.com',     'South Korea', '2002-11-03', 2480, 14, 'IGL'),
('CrimsonAce',   'Tariq Aziz',          'tariq@mail.com',       'Pakistan',    '2001-06-10', 1720, 17, 'IGL'),
('WarpSpeed',    'Suresh Tamang',       'suresh@mail.com',      'Nepal',       '2002-09-17', 1430, 19, 'IGL'),
('OmegaBurst',   'Nurul Haq',           'nurul@mail.com',       'Malaysia',    '2000-03-22', 1680,  9, 'Rifler'),
('QuantumX',     'Carlo Reyes',         'carlo@mail.com',       'Philippines', '2001-08-05', 1160, 11, 'Support'),
('TurboShot',    'Naing Htun',          'naing@mail.com',       'Myanmar',     '2003-04-01', 1090, 20, 'IGL');

-- Set CaptainIDs now that Players exist
UPDATE Teams SET CaptainID =  1 WHERE TeamID =  1;
UPDATE Teams SET CaptainID =  4 WHERE TeamID =  2;
UPDATE Teams SET CaptainID =  7 WHERE TeamID =  3;
UPDATE Teams SET CaptainID = 10 WHERE TeamID =  4;
UPDATE Teams SET CaptainID = 13 WHERE TeamID =  5;
UPDATE Teams SET CaptainID = 11 WHERE TeamID =  6;
UPDATE Teams SET CaptainID = 15 WHERE TeamID =  7;
UPDATE Teams SET CaptainID = 18 WHERE TeamID =  8;
UPDATE Teams SET CaptainID = 20 WHERE TeamID =  9;
UPDATE Teams SET CaptainID = 21 WHERE TeamID = 10;
UPDATE Teams SET CaptainID = 22 WHERE TeamID = 11;
UPDATE Teams SET CaptainID = 14 WHERE TeamID = 12;
UPDATE Teams SET CaptainID = 23 WHERE TeamID = 13;
UPDATE Teams SET CaptainID = 25 WHERE TeamID = 14;
UPDATE Teams SET CaptainID =  6 WHERE TeamID = 15;
UPDATE Teams SET CaptainID = 12 WHERE TeamID = 16;
UPDATE Teams SET CaptainID = 26 WHERE TeamID = 17;
UPDATE Teams SET CaptainID = 24 WHERE TeamID = 18;
UPDATE Teams SET CaptainID = 27 WHERE TeamID = 19;
UPDATE Teams SET CaptainID = 30 WHERE TeamID = 20;

-- -------------------------------------------------------
-- Tournaments 
-- -------------------------------------------------------
INSERT INTO Tournaments (TournamentName, GameID, StartDate, EndDate, Location, PrizePool, Format, Status, WinnerTeamID, TotalTeams) VALUES
('BD Valorant Open 2024',             1, '2024-03-01', '2024-03-15', 'Dhaka',        500000.00, 'Single Elimination', 'Completed',  2, 8),
('South Asia CS2 Championship',       2, '2024-06-10', '2024-06-20', 'Online',        300000.00, 'Double Elimination', 'Completed',  2, 8),
('MOBA Mayhem Dota 2 Cup',            3, '2024-09-05', '2024-09-10', 'Dhaka',        200000.00, 'Round Robin',        'Completed',  2, 6),
('Winter Clash Valorant 2025',        1, '2025-01-15', '2025-01-30', 'Dhaka',        750000.00, 'Single Elimination', 'Ongoing',  NULL, 8),
('Free Fire National Series 2024',    6, '2024-04-20', '2024-04-28', 'Chittagong',   150000.00, 'Single Elimination', 'Completed',  7, 6),
('PUBG Mobile Grand Prix 2024',       5, '2024-05-12', '2024-05-20', 'Online',        400000.00, 'Swiss',              'Completed',  2, 6),
('LoL Bangladesh Invitational 2024',  4, '2024-07-01', '2024-07-14', 'Dhaka',        350000.00, 'Round Robin',        'Completed',  3, 4),
('CS2 Rising Stars Cup 2024',         2, '2024-08-15', '2024-08-22', 'Online',        180000.00, 'Single Elimination', 'Completed',  1, 8),
('Valorant Challengers BD 2024',      1, '2024-10-10', '2024-10-25', 'Dhaka',        600000.00, 'Double Elimination', 'Completed',  1, 8),
('Dota 2 South Asia League 2024',     3, '2024-11-01', '2024-11-15', 'Online',        250000.00, 'Round Robin',        'Completed',  2, 6),
('Mobile Legends BD Open 2024',      19, '2024-12-01', '2024-12-10', 'Sylhet',       100000.00, 'Single Elimination', 'Completed',  3, 6),
('Free Fire Masters 2025',            6, '2025-02-01', '2025-02-10', 'Dhaka',        200000.00, 'Single Elimination', 'Upcoming', NULL, 0),
('PUBG Mobile Clash Series 2025',     5, '2025-03-01', '2025-03-10', 'Online',        300000.00, 'Swiss',              'Upcoming', NULL, 0),
('BD Esports Annual Championship',    1, '2025-04-01', '2025-04-20', 'Dhaka',       1000000.00, 'Double Elimination', 'Upcoming', NULL, 0),
('Rocket League BD Open 2024',        9, '2024-05-25', '2024-05-30', 'Online',         80000.00, 'Single Elimination', 'Completed',  9, 4),
('Overwatch 2 BD Showdown',          10, '2024-06-28', '2024-07-05', 'Online',        120000.00, 'Swiss',              'Completed',  2, 4),
('Street Fighter Invitational BD',   14, '2024-08-01', '2024-08-03', 'Dhaka',         50000.00, 'Single Elimination', 'Completed',  4, 4),
('CS2 Winter League 2025',            2, '2025-02-15', '2025-02-28', 'Online',        250000.00, 'Round Robin',        'Upcoming', NULL, 0),
('Valorant Pro League Season 2',      1, '2025-03-15', '2025-04-10', 'Dhaka',        850000.00, 'Double Elimination', 'Upcoming', NULL, 0),
('Dota 2 Winter Cup 2025',            3, '2025-01-20', '2025-02-05', 'Online',        180000.00, 'Single Elimination', 'Completed',  1, 4);

-- -------------------------------------------------------
-- Matches 
-- -------------------------------------------------------
INSERT INTO Matches (TournamentID, Team1ID, Team2ID, MatchDate, Stage, BestOf, Status, WinnerTeamID, LoserTeamID) VALUES
-- T1: BD Valorant Open 2024 (7 matches)
(1,  1, 15, '2024-03-01 11:00:00', 'Quarter Final', 3, 'Completed',  1, 15),
(1,  3, 20, '2024-03-01 14:00:00', 'Quarter Final', 3, 'Completed',  3, 20),
(1,  6, 16, '2024-03-02 11:00:00', 'Quarter Final', 3, 'Completed',  6, 16),
(1,  2,  4, '2024-03-02 14:00:00', 'Quarter Final', 3, 'Completed',  2,  4),
(1,  1,  3, '2024-03-08 14:00:00', 'Semi Final',    3, 'Completed',  1,  3),
(1,  2,  6, '2024-03-08 17:00:00', 'Semi Final',    3, 'Completed',  2,  6),
(1,  1,  2, '2024-03-15 18:00:00', 'Final',         5, 'Completed',  2,  1),
-- T2: South Asia CS2 Championship (7 matches)
(2,  2, 17, '2024-06-10 12:00:00', 'Quarter Final', 1, 'Completed',  2, 17),
(2,  3,  7, '2024-06-10 15:00:00', 'Quarter Final', 1, 'Completed',  3,  7),
(2,  1,  5, '2024-06-11 12:00:00', 'Quarter Final', 1, 'Completed',  1,  5),
(2,  4,  6, '2024-06-11 15:00:00', 'Quarter Final', 1, 'Completed',  4,  6),
(2,  2,  3, '2024-06-17 15:00:00', 'Semi Final',    3, 'Completed',  2,  3),
(2,  1,  4, '2024-06-17 18:00:00', 'Semi Final',    3, 'Completed',  1,  4),
(2,  2,  1, '2024-06-20 18:00:00', 'Final',         3, 'Completed',  2,  1),
-- T3: MOBA Mayhem Dota 2 Cup (6 matches)
(3,  1,  2, '2024-09-05 11:00:00', 'Group Stage',   1, 'Completed',  2,  1),
(3,  3,  4, '2024-09-05 14:00:00', 'Group Stage',   1, 'Completed',  3,  4),
(3,  7,  9, '2024-09-05 17:00:00', 'Group Stage',   1, 'Completed',  9,  7),
(3,  1,  4, '2024-09-06 11:00:00', 'Group Stage',   1, 'Completed',  1,  4),
(3,  2,  7, '2024-09-06 14:00:00', 'Group Stage',   1, 'Completed',  2,  7),
(3,  3,  9, '2024-09-06 17:00:00', 'Group Stage',   1, 'Completed',  3,  9),
-- T4: Winter Clash Valorant 2025 (5 matches — Ongoing)
(4,  1,  8, '2025-01-15 12:00:00', 'Quarter Final', 3, 'Completed',  1,  8),
(4,  3, 13, '2025-01-15 15:00:00', 'Quarter Final', 3, 'Completed',  3, 13),
(4,  2, 10, '2025-01-16 12:00:00', 'Quarter Final', 3, 'Completed',  2, 10),
(4,  4, 14, '2025-01-16 15:00:00', 'Quarter Final', 3, 'Live',     NULL, NULL),
(4,  1,  3, '2025-01-22 17:00:00', 'Semi Final',    3, 'Scheduled',NULL, NULL),
-- T5: Free Fire National Series 2024 (5 matches)
(5,  2, 11, '2024-04-20 11:00:00', 'Quarter Final', 1, 'Completed',  2, 11),
(5,  5, 13, '2024-04-20 14:00:00', 'Quarter Final', 1, 'Completed',  5, 13),
(5,  7,  8, '2024-04-20 17:00:00', 'Quarter Final', 1, 'Completed',  7,  8),
(5,  2,  5, '2024-04-26 15:00:00', 'Semi Final',    3, 'Completed',  2,  5),
(5,  7,  2, '2024-04-28 18:00:00', 'Final',         3, 'Completed',  7,  2),
-- T9: Valorant Challengers BD 2024 (7 matches)
(9,  1,  7, '2024-10-10 11:00:00', 'Quarter Final', 3, 'Completed',  1,  7),
(9,  3, 10, '2024-10-10 14:00:00', 'Quarter Final', 3, 'Completed',  3, 10),
(9,  2, 14, '2024-10-11 11:00:00', 'Quarter Final', 3, 'Completed',  2, 14),
(9,  4,  6, '2024-10-11 14:00:00', 'Quarter Final', 3, 'Completed',  4,  6),
(9,  1,  3, '2024-10-18 15:00:00', 'Semi Final',    3, 'Completed',  1,  3),
(9,  2,  4, '2024-10-18 18:00:00', 'Semi Final',    3, 'Completed',  2,  4),
(9,  1,  2, '2024-10-25 19:00:00', 'Final',         5, 'Completed',  1,  2),
-- T20: Dota 2 Winter Cup 2025 (3 matches)
(20, 1,  3, '2025-01-21 14:00:00', 'Semi Final',    3, 'Completed',  1,  3),
(20, 2,  4, '2025-01-21 17:00:00', 'Semi Final',    3, 'Completed',  2,  4),
(20, 1,  2, '2025-02-05 18:00:00', 'Final',         5, 'Completed',  1,  2);

-- -------------------------------------------------------
-- Results 
-- FinalPos1/Prize1 = Team1 outcome | FinalPos2/Prize2 = Team2 outcome
-- -------------------------------------------------------
INSERT INTO Results (MatchID, Team1Score, Team2Score, DurationMins, MVPPlayerID, FinalPos1, FinalPos2, Prize1, Prize2) VALUES
(1,  2, 0,  55,  1, 1, 2,  15000.00,  10000.00),
(2,  2, 1,  70,  9, 1, 2,  15000.00,  10000.00),
(3,  2, 0,  50,  5, 1, 2,  15000.00,  10000.00),
(4,  2, 1,  80,  4, 1, 2,  15000.00,  10000.00),
(5,  2, 1,  85,  1, 1, 2,  75000.00,  25000.00),
(6,  2, 0,  65,  4, 1, 2,  75000.00,  25000.00),
(7,  2, 3, 140,  5, 2, 1, 125000.00, 250000.00),
(8,  1, 0,  38,  4, 1, 2,   6000.00,   6000.00),
(9,  1, 0,  42,  9, 1, 2,   6000.00,   6000.00),
(10, 1, 0,  45,  1, 1, 2,   6000.00,   6000.00),
(11, 1, 0,  37, 12, 1, 2,   6000.00,   6000.00),
(12, 2, 1,  95,  4, 1, 2,  40000.00,  30000.00),
(13, 2, 0,  75,  1, 1, 2,  40000.00,  30000.00),
(14, 2, 1,  90,  5, 1, 2, 150000.00,  75000.00),
(15, 0, 1,  48,  4, 2, 1,  30000.00, 100000.00),
(16, 1, 0,  40,  9, 1, 2,  30000.00,  20000.00),
(17, 0, 1,  43, 20, 2, 1,  20000.00,  30000.00),
(18, 1, 0,  45,  1, 1, 2,  30000.00,  20000.00),
(19, 0, 1,  50,  4, 2, 1,  30000.00,  50000.00),
(20, 1, 0,  38,  9, 1, 2,  30000.00,  20000.00),
(21, 2, 0,  70,  1, 1, 2,   0.00,      0.00),
(22, 2, 1,  88,  9, 1, 2,   0.00,      0.00),
(23, 2, 0,  65,  4, 1, 2,   0.00,      0.00),
(26, 1, 0,  35,  4, 1, 2,   0.00,      0.00),
(27, 1, 0,  40, 13, 1, 2,   0.00,      0.00),
(28, 1, 0,  32, 15, 1, 2,   0.00,      0.00),
(29, 2, 1,  85,  4, 1, 2,  20000.00,  10000.00),
(30, 2, 1,  95, 15, 1, 2,  75000.00,  45000.00),
(31, 2, 0,  75,  1, 1, 2,   0.00,      0.00),
(32, 2, 1,  88,  9, 1, 2,   0.00,      0.00),
(33, 2, 0,  62,  4, 1, 2,   0.00,      0.00),
(34, 2, 1,  78, 12, 1, 2,   0.00,      0.00),
(35, 2, 1,  92,  1, 1, 2,  80000.00,  50000.00),
(36, 2, 0,  68,  5, 1, 2,  80000.00,  50000.00),
(37, 3, 2, 125,  1, 1, 2, 300000.00, 150000.00),
(38, 2, 0,  80,  1, 1, 2,   0.00,      0.00),
(39, 2, 1,  90,  4, 1, 2,   0.00,      0.00),
(40, 3, 1, 110,  2, 1, 2,  90000.00,  50000.00);


-- ============================================================
-- QUERIES (Q1 to Q24)
-- ============================================================

-- ----------------------------------------------------------
-- Q1: All players with their team name and role
-- ----------------------------------------------------------
SELECT
    p.PlayerID,
    p.Username,
    p.FullName,
    p.Country,
    p.RankPoints,
    p.Role,
    COALESCE(t.TeamName, 'Free Agent') AS TeamName
FROM Players p
LEFT JOIN Teams t ON p.TeamID = t.TeamID
ORDER BY t.TeamName, p.RankPoints DESC;

-- ----------------------------------------------------------
-- Q2: Total prize money and wins per team
-- ----------------------------------------------------------
SELECT
    TeamID,
    TeamName,
    Country,
    TotalWins,
    TotalPrize
FROM Teams
ORDER BY TotalPrize DESC;

-- ----------------------------------------------------------
-- Q3: Win / Loss record and win rate per team
-- ----------------------------------------------------------
SELECT
    t.TeamName,
    COUNT(CASE WHEN m.WinnerTeamID = t.TeamID THEN 1 END) AS Wins,
    COUNT(CASE WHEN m.LoserTeamID  = t.TeamID THEN 1 END) AS Losses,
    COUNT(*) AS TotalMatches,
    ROUND(
        COUNT(CASE WHEN m.WinnerTeamID = t.TeamID THEN 1 END) * 100.0 / COUNT(*), 2
    ) AS WinRatePct
FROM Teams t
JOIN Matches m ON t.TeamID = m.Team1ID OR t.TeamID = m.Team2ID
WHERE m.Status = 'Completed'
GROUP BY t.TeamID, t.TeamName
ORDER BY Wins DESC;

-- ----------------------------------------------------------
-- Q4: Top 10 players by rank points with team info
-- ----------------------------------------------------------
SELECT
    p.Username,
    p.FullName,
    p.Country,
    p.RankPoints,
    p.Role,
    COALESCE(t.TeamName, 'Free Agent') AS TeamName
FROM Players p
LEFT JOIN Teams t ON p.TeamID = t.TeamID
ORDER BY p.RankPoints DESC
LIMIT 10;

-- ----------------------------------------------------------
-- Q5: Tournament summary with winner team
-- ----------------------------------------------------------
SELECT
    tn.TournamentName,
    g.GameName,
    tn.Format,
    tn.Status,
    tn.Location,
    tn.TotalTeams,
    tn.PrizePool,
    COALESCE(t.TeamName, 'TBD') AS Winner,
    tn.StartDate,
    tn.EndDate
FROM Tournaments tn
JOIN Games g ON tn.GameID = g.GameID
LEFT JOIN Teams t ON tn.WinnerTeamID = t.TeamID
ORDER BY tn.StartDate;

-- ----------------------------------------------------------
-- Q6: MVP leaderboard
-- ----------------------------------------------------------
SELECT
    p.Username,
    p.FullName,
    p.Country,
    COALESCE(t.TeamName, 'Free Agent') AS TeamName,
    COUNT(r.MVPPlayerID) AS MVPCount
FROM Results r
JOIN Players p ON r.MVPPlayerID = p.PlayerID
LEFT JOIN Teams t ON p.TeamID = t.TeamID
GROUP BY p.PlayerID, p.Username, p.FullName, p.Country, t.TeamName
ORDER BY MVPCount DESC;

-- ----------------------------------------------------------
-- Q7: Full match results for Tournament 1
-- ----------------------------------------------------------
SELECT
    m.MatchID,
    t1.TeamName     AS Team1,
    t2.TeamName     AS Team2,
    r.Team1Score,
    r.Team2Score,
    tw.TeamName     AS Winner,
    m.Stage,
    m.BestOf,
    m.MatchDate,
    r.DurationMins,
    p.Username      AS MVP
FROM Matches m
JOIN Teams t1        ON m.Team1ID      = t1.TeamID
JOIN Teams t2        ON m.Team2ID      = t2.TeamID
LEFT JOIN Results r  ON m.MatchID      = r.MatchID
LEFT JOIN Teams tw   ON m.WinnerTeamID = tw.TeamID
LEFT JOIN Players p  ON r.MVPPlayerID  = p.PlayerID
WHERE m.TournamentID = 1
ORDER BY m.MatchDate;

-- ----------------------------------------------------------
-- Q8: Players who have never won an MVP award
-- ----------------------------------------------------------
SELECT
    p.PlayerID,
    p.Username,
    p.FullName,
    p.Country,
    p.RankPoints,
    COALESCE(t.TeamName, 'Free Agent') AS TeamName
FROM Players p
LEFT JOIN Teams t ON p.TeamID = t.TeamID
WHERE p.PlayerID NOT IN (
    SELECT DISTINCT MVPPlayerID FROM Results WHERE MVPPlayerID IS NOT NULL
)
ORDER BY p.RankPoints DESC;

-- ----------------------------------------------------------
-- Q9: Average and max match duration per tournament
-- ----------------------------------------------------------
SELECT
    g.GameName,
    tn.TournamentName,
    COUNT(m.MatchID)              AS TotalMatches,
    ROUND(AVG(r.DurationMins), 1) AS AvgDurationMins,
    MAX(r.DurationMins)           AS LongestMatchMins
FROM Games g
JOIN Tournaments tn ON g.GameID        = tn.GameID
JOIN Matches m      ON tn.TournamentID = m.TournamentID
JOIN Results r      ON m.MatchID       = r.MatchID
GROUP BY g.GameID, g.GameName, tn.TournamentID, tn.TournamentName
ORDER BY AvgDurationMins DESC;

-- ----------------------------------------------------------
-- Q10: Teams that have won at least one tournament
-- ----------------------------------------------------------
SELECT
    TeamID,
    TeamName,
    Country,
    TotalWins,
    TotalPrize
FROM Teams
WHERE TotalWins > 0
ORDER BY TotalWins DESC, TotalPrize DESC;

-- ----------------------------------------------------------
-- Q11: Player count and avg rank points per country
-- ----------------------------------------------------------
SELECT
    Country,
    COUNT(*)                  AS TotalPlayers,
    ROUND(AVG(RankPoints), 0) AS AvgRankPoints,
    MAX(RankPoints)           AS TopRankPoints,
    MIN(RankPoints)           AS LowestRankPoints
FROM Players
GROUP BY Country
ORDER BY TotalPlayers DESC;

-- ----------------------------------------------------------
-- Q12: Complete bracket — all tournaments, all matches
-- ----------------------------------------------------------
SELECT
    tn.TournamentName,
    g.GameName,
    m.Stage,
    t1.TeamName                               AS Team1,
    t2.TeamName                               AS Team2,
    CONCAT(r.Team1Score, ' - ', r.Team2Score) AS Score,
    tw.TeamName                               AS Winner,
    p.Username                                AS MVP,
    r.DurationMins
FROM Matches m
JOIN Tournaments tn  ON m.TournamentID  = tn.TournamentID
JOIN Games g         ON tn.GameID       = g.GameID
JOIN Teams t1        ON m.Team1ID       = t1.TeamID
JOIN Teams t2        ON m.Team2ID       = t2.TeamID
LEFT JOIN Results r  ON m.MatchID       = r.MatchID
LEFT JOIN Teams tw   ON m.WinnerTeamID  = tw.TeamID
LEFT JOIN Players p  ON r.MVPPlayerID   = p.PlayerID
ORDER BY tn.TournamentID, m.MatchDate;

-- ============================================================
-- CLAUSE SHOWCASE QUERIES
-- ============================================================

-- ----------------------------------------------------------
-- Q13 [WHERE]: SE/East Asian players with RankPoints > 1200
-- ----------------------------------------------------------
SELECT
    PlayerID,
    Username,
    FullName,
    Country,
    RankPoints,
    Role
FROM Players
WHERE Country IN ('South Korea', 'Malaysia', 'Indonesia', 'Philippines', 'Thailand', 'Myanmar')
  AND RankPoints > 1200
ORDER BY RankPoints DESC;

-- ----------------------------------------------------------
-- Q14 [WHERE + JOIN]: Final stage matches longer than 100 mins
-- ----------------------------------------------------------
SELECT
    m.MatchID,
    tn.TournamentName,
    t1.TeamName    AS Team1,
    t2.TeamName    AS Team2,
    r.Team1Score,
    r.Team2Score,
    r.DurationMins,
    tw.TeamName    AS Winner
FROM Matches m
JOIN Tournaments tn ON m.TournamentID  = tn.TournamentID
JOIN Teams t1       ON m.Team1ID       = t1.TeamID
JOIN Teams t2       ON m.Team2ID       = t2.TeamID
JOIN Results r      ON m.MatchID       = r.MatchID
LEFT JOIN Teams tw  ON m.WinnerTeamID  = tw.TeamID
WHERE m.Stage       = 'Final'
  AND r.DurationMins > 100
  AND m.Status      = 'Completed'
ORDER BY r.DurationMins DESC;

-- ----------------------------------------------------------
-- Q15 [WHERE + JOIN]: Upcoming tournaments with prize > 200,000
-- ----------------------------------------------------------
SELECT
    tn.TournamentName,
    g.GameName,
    tn.StartDate,
    tn.Location,
    tn.PrizePool,
    tn.Format
FROM Tournaments tn
JOIN Games g ON tn.GameID = g.GameID
WHERE tn.Status    = 'Upcoming'
  AND tn.PrizePool > 200000.00
ORDER BY tn.PrizePool DESC;

-- ----------------------------------------------------------
-- Q16 [GROUP BY]: Total matches and avg duration per Stage
-- ----------------------------------------------------------
SELECT
    m.Stage,
    COUNT(m.MatchID)              AS TotalMatches,
    SUM(r.DurationMins)           AS TotalDurationMins,
    ROUND(AVG(r.DurationMins), 1) AS AvgDurationMins
FROM Matches m
JOIN Results r ON m.MatchID = r.MatchID
GROUP BY m.Stage
ORDER BY TotalMatches DESC;

-- ----------------------------------------------------------
-- Q17 [GROUP BY + JOIN]: Tournaments hosted per game
-- ----------------------------------------------------------
SELECT
    g.GameID,
    g.GameName,
    g.Genre,
    COUNT(tn.TournamentID)  AS TotalTournaments,
    SUM(tn.PrizePool)       AS TotalPrizeMoney
FROM Games g
LEFT JOIN Tournaments tn ON g.GameID = tn.GameID
GROUP BY g.GameID, g.GameName, g.Genre
ORDER BY TotalTournaments DESC;

-- ----------------------------------------------------------
-- Q18 [ORDER BY]: Teams ranked by prize earned, then name
-- ----------------------------------------------------------
SELECT
    TeamID,
    TeamName,
    Country,
    FoundedYear,
    TotalWins,
    TotalPrize
FROM Teams
ORDER BY TotalPrize DESC, TeamName ASC;

-- ----------------------------------------------------------
-- Q19 [ORDER BY + LIMIT]: Top 5 highest prize tournaments
-- ----------------------------------------------------------
SELECT
    TournamentName,
    GameID,
    Location,
    PrizePool,
    Status,
    StartDate
FROM Tournaments
ORDER BY PrizePool DESC
LIMIT 5;

-- ----------------------------------------------------------
-- Q20 [LIMIT + OFFSET]: Player list page 2 (rows 11–20)
-- ----------------------------------------------------------
SELECT
    PlayerID,
    Username,
    FullName,
    Country,
    RankPoints,
    Role
FROM Players
ORDER BY RankPoints DESC
LIMIT 10 OFFSET 10;

-- ----------------------------------------------------------
-- Q21 [HAVING]: Countries with more than 2 players
-- ----------------------------------------------------------
SELECT
    Country,
    COUNT(PlayerID)           AS TotalPlayers,
    ROUND(AVG(RankPoints), 0) AS AvgRankPoints
FROM Players
GROUP BY Country
HAVING COUNT(PlayerID) > 2
ORDER BY TotalPlayers DESC;

-- ----------------------------------------------------------
-- Q22 [HAVING]: Teams with 1+ wins AND total prize > 100,000
-- ----------------------------------------------------------
SELECT
    TeamID,
    TeamName,
    Country,
    TotalWins,
    TotalPrize
FROM Teams
GROUP BY TeamID, TeamName, Country, TotalWins, TotalPrize
HAVING TotalWins >= 1
   AND TotalPrize > 100000
ORDER BY TotalPrize DESC;

-- ----------------------------------------------------------
-- Q23 [HAVING]: Games with 2+ tournaments and prize > 500,000
-- ----------------------------------------------------------
SELECT
    g.GameName,
    g.Genre,
    COUNT(tn.TournamentID)  AS TotalTournaments,
    SUM(tn.PrizePool)       AS CombinedPrizePool
FROM Games g
JOIN Tournaments tn ON g.GameID = tn.GameID
GROUP BY g.GameID, g.GameName, g.Genre
HAVING COUNT(tn.TournamentID) >= 2
   AND SUM(tn.PrizePool) > 500000
ORDER BY CombinedPrizePool DESC;

-- ----------------------------------------------------------
-- Q24 [WHERE + GROUP BY + HAVING + ORDER BY + LIMIT]:
--     Top 3 non-Korean Asian players with above-average RankPoints
--     who played in 2+ completed matches
-- ----------------------------------------------------------
SELECT
    p.Username,
    p.FullName,
    p.Country,
    p.RankPoints,
    p.Role,
    COUNT(DISTINCT m.MatchID) AS MatchesPlayed
FROM Players p
JOIN Teams t   ON p.TeamID = t.TeamID
JOIN Matches m ON t.TeamID = m.Team1ID OR t.TeamID = m.Team2ID
WHERE p.Country NOT IN ('South Korea')
  AND m.Status = 'Completed'
  AND p.RankPoints > (SELECT AVG(RankPoints) FROM Players)
GROUP BY p.PlayerID, p.Username, p.FullName, p.Country, p.RankPoints, p.Role
HAVING COUNT(DISTINCT m.MatchID) >= 2
ORDER BY p.RankPoints DESC
LIMIT 3;

-- ============================================================
-- END OF SCRIPT
-- ============================================================
