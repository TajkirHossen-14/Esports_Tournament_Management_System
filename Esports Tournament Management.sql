-- ============================================================
--   ESPORTS TOURNAMENT MANAGEMENT SYSTEM
-- ============================================================

-- ============================================================
-- DDL - TABLE CREATION
-- ============================================================

-- 1. Games
CREATE TABLE Games (
    GameID          INT AUTO_INCREMENT PRIMARY KEY,
    GameName        VARCHAR(100) NOT NULL,
    Genre           VARCHAR(50),
    Platform        VARCHAR(50),
    Publisher       VARCHAR(100),
    ReleaseYear     YEAR
);

-- 2. Players
CREATE TABLE Players (
    PlayerID        INT AUTO_INCREMENT PRIMARY KEY,
    Username        VARCHAR(50)  NOT NULL UNIQUE,
    FullName        VARCHAR(100) NOT NULL,
    Email           VARCHAR(100) UNIQUE,
    Country         VARCHAR(50),
    DateOfBirth     DATE,
    RankPoints      INT DEFAULT 0,
    JoinedDate      DATE DEFAULT (CURRENT_DATE)
);

-- 3. Teams
CREATE TABLE Teams (
    TeamID          INT AUTO_INCREMENT PRIMARY KEY,
    TeamName        VARCHAR(100) NOT NULL UNIQUE,
    Tag             VARCHAR(10),
    Country         VARCHAR(50),
    FoundedYear     YEAR,
    CaptainID       INT,
    FOREIGN KEY (CaptainID) REFERENCES Players(PlayerID) ON DELETE SET NULL
);

-- 4. Team_Members
CREATE TABLE Team_Members (
    TeamID          INT,
    PlayerID        INT,
    Role            VARCHAR(50),
    JoinedDate      DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (TeamID, PlayerID),
    FOREIGN KEY (TeamID)   REFERENCES Teams(TeamID)     ON DELETE CASCADE,
    FOREIGN KEY (PlayerID) REFERENCES Players(PlayerID) ON DELETE CASCADE
);

-- 5. Tournaments
CREATE TABLE Tournaments (
    TournamentID    INT AUTO_INCREMENT PRIMARY KEY,
    TournamentName  VARCHAR(150) NOT NULL,
    GameID          INT,
    StartDate       DATE,
    EndDate         DATE,
    Location        VARCHAR(100),
    PrizePool       DECIMAL(12, 2) DEFAULT 0.00,
    Format          ENUM('Single Elimination', 'Double Elimination', 'Round Robin', 'Swiss') NOT NULL,
    Status          ENUM('Upcoming', 'Ongoing', 'Completed') DEFAULT 'Upcoming',
    FOREIGN KEY (GameID) REFERENCES Games(GameID) ON DELETE SET NULL
);

-- 6. Tournament_Registrations
CREATE TABLE Tournament_Registrations (
    RegistrationID  INT AUTO_INCREMENT PRIMARY KEY,
    TournamentID    INT,
    TeamID          INT,
    RegisteredOn    DATETIME DEFAULT CURRENT_TIMESTAMP,
    SeedNumber      INT,
    UNIQUE (TournamentID, TeamID),
    FOREIGN KEY (TournamentID) REFERENCES Tournaments(TournamentID) ON DELETE CASCADE,
    FOREIGN KEY (TeamID)       REFERENCES Teams(TeamID)             ON DELETE CASCADE
);

-- 7. Matches
CREATE TABLE Matches (
    MatchID         INT AUTO_INCREMENT PRIMARY KEY,
    TournamentID    INT,
    Team1ID         INT,
    Team2ID         INT,
    MatchDate       DATETIME,
    Stage           VARCHAR(50),
    BestOf          INT DEFAULT 1,
    Status          ENUM('Scheduled', 'Live', 'Completed', 'Cancelled') DEFAULT 'Scheduled',
    FOREIGN KEY (TournamentID) REFERENCES Tournaments(TournamentID) ON DELETE CASCADE,
    FOREIGN KEY (Team1ID)      REFERENCES Teams(TeamID)             ON DELETE CASCADE,
    FOREIGN KEY (Team2ID)      REFERENCES Teams(TeamID)             ON DELETE CASCADE,
    CHECK (Team1ID <> Team2ID)
);

-- 8. Results
CREATE TABLE Results (
    ResultID        INT AUTO_INCREMENT PRIMARY KEY,
    MatchID         INT UNIQUE,
    WinnerTeamID    INT,
    LoserTeamID     INT,
    Team1Score      INT DEFAULT 0,
    Team2Score      INT DEFAULT 0,
    DurationMins    INT,
    MVPPlayerID     INT,
    FOREIGN KEY (MatchID)      REFERENCES Matches(MatchID)          ON DELETE CASCADE,
    FOREIGN KEY (WinnerTeamID) REFERENCES Teams(TeamID)             ON DELETE SET NULL,
    FOREIGN KEY (LoserTeamID)  REFERENCES Teams(TeamID)             ON DELETE SET NULL,
    FOREIGN KEY (MVPPlayerID)  REFERENCES Players(PlayerID)         ON DELETE SET NULL
);

-- 9. Tournament_Standings
CREATE TABLE Tournament_Standings (
    StandingID      INT AUTO_INCREMENT PRIMARY KEY,
    TournamentID    INT,
    TeamID          INT,
    FinalPosition   INT,
    PrizeWon        DECIMAL(12, 2) DEFAULT 0.00,
    UNIQUE (TournamentID, TeamID),
    FOREIGN KEY (TournamentID) REFERENCES Tournaments(TournamentID) ON DELETE CASCADE,
    FOREIGN KEY (TeamID)       REFERENCES Teams(TeamID)             ON DELETE CASCADE
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
-- Players 
-- -------------------------------------------------------
INSERT INTO Players (Username, FullName, Email, Country, DateOfBirth, RankPoints) VALUES
('NightWolf',    'Arif Hossain',        'arif@mail.com',        'Bangladesh',   '2001-03-15', 1500),
('ShadowByte',   'Tanvir Ahmed',        'tanvir@mail.com',      'Bangladesh',   '2000-07-22', 1800),
('PhoenixRush',  'Rafi Islam',          'rafi@mail.com',        'Bangladesh',   '2002-01-10', 1200),
('CyberKnight',  'Sabbir Rahman',       'sabbir@mail.com',      'Bangladesh',   '1999-11-05', 2100),
('StormEdge',    'Mehdi Hasan',         'mehdi@mail.com',       'Bangladesh',   '2001-09-30', 1650),
('BladeRunner',  'Sumaiya Akter',       'sumaiya@mail.com',     'Bangladesh',   '2003-04-18', 1400),
('ThunderX',     'Nabil Chowdhury',     'nabil@mail.com',       'Bangladesh',   '2000-12-01', 1950),
('IronFist',     'Rakib Uddin',         'rakib@mail.com',       'Bangladesh',   '2002-06-25', 1300),
('FlameCore',    'Jisan Molla',         'jisan@mail.com',       'Bangladesh',   '2001-08-14', 1750),
('VoidSlayer',   'Priya Das',           'priya@mail.com',       'India',        '2000-02-28', 2000),
('PixelKing',    'Aditya Kumar',        'aditya@mail.com',      'India',        '2001-05-11', 1850),
('GhostAim',     'Siddharth Roy',       'sid@mail.com',         'India',        '2002-08-20', 1600),
('NeonBlade',    'Hamza Malik',         'hamza@mail.com',       'Pakistan',     '2003-02-14', 1100),
('DarkPulse',    'Ali Hassan',          'ali@mail.com',         'Pakistan',     '2000-10-07', 1450),
('ArcLight',     'Sanjay Karki',        'sanjay@mail.com',      'Nepal',        '2002-03-29', 1550),
('QuickDraw',    'Birat Thapa',         'birat@mail.com',       'Nepal',        '2001-11-18', 1700),
('MegaForce',    'Arjun Sharma',        'arjun@mail.com',       'India',        '1999-07-04', 2200),
('SkyBreaker',   'Kasun Perera',        'kasun@mail.com',       'Sri Lanka',    '2003-06-23', 1050),
('EchoStrike',   'Danushka Silva',      'danushka@mail.com',    'Sri Lanka',    '2001-12-30', 1620),
('LunarWolf',    'Ahmad Faiz',          'faiz@mail.com',        'Malaysia',     '2002-04-15', 1380),
('HyperX99',     'Rizky Pratama',       'rizky@mail.com',       'Indonesia',    '2000-09-09', 1900),
('ZeroGrav',     'Juan dela Cruz',      'juan@mail.com',        'Philippines',  '2003-01-27', 980),
('FrostBite',    'Somchai Wongsak',     'somchai@mail.com',     'Thailand',     '2001-07-08', 1250),
('RazorWind',    'Kim Jae-won',         'jaewon@mail.com',      'South Korea',  '2000-05-19', 2350),
('NovaSurge',    'Park Sung-min',       'sungmin@mail.com',     'South Korea',  '2002-11-03', 2480),
('CrimsonAce',   'Tariq Aziz',          'tariq@mail.com',       'Pakistan',     '2001-06-10', 1720),
('WarpSpeed',    'Suresh Tamang',       'suresh@mail.com',      'Nepal',        '2002-09-17', 1430),
('OmegaBurst',   'Nurul Haq',           'nurul@mail.com',       'Malaysia',     '2000-03-22', 1680),
('QuantumX',     'Carlo Reyes',         'carlo@mail.com',       'Philippines',  '2001-08-05', 1160),
('TurboShot',    'Naing Htun',          'naing@mail.com',       'Myanmar',      '2003-04-01', 1090);

-- -------------------------------------------------------
-- Teams 
-- -------------------------------------------------------
INSERT INTO Teams (TeamName, Tag, Country, FoundedYear, CaptainID) VALUES
('Team Nexus',       'NXS', 'Bangladesh',  2021,  1),
('Shadow Wolves',    'SHW', 'Bangladesh',  2020,  4),
('Cyber Dragons',    'CDR', 'Bangladesh',  2022,  7),
('Storm Riders',     'STR', 'India',       2021, 10),
('Phantom Force',    'PHF', 'Pakistan',    2023, 13),
('Iron Legion',      'IRL', 'India',       2020, 11),
('Neon Assassins',   'NEO', 'Nepal',       2022, 15),
('Blaze Squad',      'BLZ', 'Sri Lanka',   2021, 18),
('Titan Rush',       'TTR', 'Malaysia',    2022, 20),
('Void Hunters',     'VHT', 'Indonesia',   2023, 21),
('Arctic Wolves',    'ARW', 'Philippines', 2021, 22),
('Delta Force BD',   'DFB', 'Bangladesh',  2020, 14),
('Omega Strike',     'OMS', 'Thailand',    2022, 23),
('Galaxy Gamers',    'GXG', 'South Korea', 2023, 25),
('Rebel Alliance',   'RBA', 'Bangladesh',  2021,  6),
('Stealth Mode',     'STM', 'India',       2022, 12),
('Dark Matter',      'DKM', 'Pakistan',    2020, 26),
('Hyper Clash',      'HPC', 'South Korea', 2023, 24),
('Code Breakers',    'CBR', 'Nepal',       2021, 27),
('Echo Battalion',   'ECB', 'Bangladesh',  2022,  9);

-- -------------------------------------------------------
-- Team_Members 
-- -------------------------------------------------------
INSERT INTO Team_Members (TeamID, PlayerID, Role, JoinedDate) VALUES
(1,  1,  'IGL',           '2021-03-01'),
(1,  2,  'Entry Fragger', '2021-03-01'),
(1,  3,  'Support',       '2021-04-15'),
(2,  4,  'IGL',           '2020-06-01'),
(2,  5,  'Rifler',        '2020-06-01'),
(2,  6,  'Sniper',        '2020-08-10'),
(3,  7,  'IGL',           '2022-01-10'),
(3,  8,  'Support',       '2022-01-10'),
(3,  9,  'Entry Fragger', '2022-02-20'),
(4,  10, 'IGL',           '2021-05-15'),
(4,  12, 'Support',       '2021-06-01'),
(4,  17, 'Rifler',        '2021-07-01'),
(5,  13, 'IGL',           '2023-01-01'),
(5,  14, 'Sniper',        '2023-01-01'),
(5,  26, 'Entry Fragger', '2023-02-10'),
(6,  11, 'IGL',           '2020-09-01'),
(6,  17, 'Rifler',        '2021-01-01'),
(7,  15, 'IGL',           '2022-03-15'),
(7,  16, 'Support',       '2022-03-15'),
(7,  27, 'Entry Fragger', '2022-05-01'),
(8,  18, 'IGL',           '2021-07-20'),
(8,  19, 'Support',       '2021-07-20'),
(9,  20, 'IGL',           '2022-04-01'),
(9,  28, 'Rifler',        '2022-04-01'),
(10, 21, 'IGL',           '2023-02-01'),
(11, 22, 'IGL',           '2021-08-01'),
(11, 29, 'Support',       '2021-08-01'),
(13, 23, 'IGL',           '2022-06-01'),
(14, 25, 'IGL',           '2023-03-01'),
(14, 24, 'Entry Fragger', '2023-03-01');

-- -------------------------------------------------------
-- Tournaments 
-- -------------------------------------------------------
INSERT INTO Tournaments (TournamentName, GameID, StartDate, EndDate, Location, PrizePool, Format, Status) VALUES
('BD Valorant Open 2024',             1, '2024-03-01', '2024-03-15', 'Dhaka',        500000.00, 'Single Elimination', 'Completed'),
('South Asia CS2 Championship',       2, '2024-06-10', '2024-06-20', 'Online',        300000.00, 'Double Elimination', 'Completed'),
('MOBA Mayhem Dota 2 Cup',            3, '2024-09-05', '2024-09-10', 'Dhaka',        200000.00, 'Round Robin',        'Completed'),
('Winter Clash Valorant 2025',        1, '2025-01-15', '2025-01-30', 'Dhaka',        750000.00, 'Single Elimination', 'Ongoing'),
('Free Fire National Series 2024',    6, '2024-04-20', '2024-04-28', 'Chittagong',   150000.00, 'Single Elimination', 'Completed'),
('PUBG Mobile Grand Prix 2024',       5, '2024-05-12', '2024-05-20', 'Online',        400000.00, 'Swiss',              'Completed'),
('LoL Bangladesh Invitational 2024',  4, '2024-07-01', '2024-07-14', 'Dhaka',        350000.00, 'Round Robin',        'Completed'),
('CS2 Rising Stars Cup 2024',         2, '2024-08-15', '2024-08-22', 'Online',        180000.00, 'Single Elimination', 'Completed'),
('Valorant Challengers BD 2024',      1, '2024-10-10', '2024-10-25', 'Dhaka',        600000.00, 'Double Elimination', 'Completed'),
('Dota 2 South Asia League 2024',     3, '2024-11-01', '2024-11-15', 'Online',        250000.00, 'Round Robin',        'Completed'),
('Mobile Legends BD Open 2024',      19, '2024-12-01', '2024-12-10', 'Sylhet',       100000.00, 'Single Elimination', 'Completed'),
('Free Fire Masters 2025',            6, '2025-02-01', '2025-02-10', 'Dhaka',        200000.00, 'Single Elimination', 'Upcoming'),
('PUBG Mobile Clash Series 2025',     5, '2025-03-01', '2025-03-10', 'Online',        300000.00, 'Swiss',              'Upcoming'),
('BD Esports Annual Championship',    1, '2025-04-01', '2025-04-20', 'Dhaka',       1000000.00, 'Double Elimination', 'Upcoming'),
('Rocket League BD Open 2024',        9, '2024-05-25', '2024-05-30', 'Online',         80000.00, 'Single Elimination', 'Completed'),
('Overwatch 2 BD Showdown',          10, '2024-06-28', '2024-07-05', 'Online',        120000.00, 'Swiss',              'Completed'),
('Street Fighter Invitational BD',   14, '2024-08-01', '2024-08-03', 'Dhaka',         50000.00, 'Single Elimination', 'Completed'),
('CS2 Winter League 2025',            2, '2025-02-15', '2025-02-28', 'Online',        250000.00, 'Round Robin',        'Upcoming'),
('Valorant Pro League Season 2',      1, '2025-03-15', '2025-04-10', 'Dhaka',        850000.00, 'Double Elimination', 'Upcoming'),
('Dota 2 Winter Cup 2025',            3, '2025-01-20', '2025-02-05', 'Online',        180000.00, 'Single Elimination', 'Completed');

-- -------------------------------------------------------
-- Tournament_Registrations 
-- -------------------------------------------------------
INSERT INTO Tournament_Registrations (TournamentID, TeamID, SeedNumber) VALUES
-- T1: BD Valorant Open (8 teams)
(1,  1,  1), (1,  2,  2), (1,  3,  3), (1,  4,  4),
(1,  6,  5), (1, 15,  6), (1, 16,  7), (1, 20,  8),
-- T2: South Asia CS2 (8 teams)
(2,  1,  2), (2,  2,  1), (2,  3,  4), (2,  4,  3),
(2,  5,  5), (2,  6,  6), (2,  7,  7), (2, 17,  8),
-- T3: Dota 2 Cup (6 teams)
(3,  1,  3), (3,  2,  1), (3,  3,  2), (3,  4,  4),
(3,  7,  5), (3,  9,  6),
-- T4: Winter Clash (8 teams)
(4,  1,  1), (4,  2,  2), (4,  3,  3), (4,  4,  4),
(4,  8,  5), (4, 10,  6), (4, 13,  7), (4, 14,  8),
-- T5: Free Fire National (6 teams)
(5,  2,  1), (5,  5,  2), (5,  7,  3), (5,  8,  4),
(5, 11,  5), (5, 13,  6),
-- T9: Valorant Challengers (8 teams)
(9,  1,  1), (9,  2,  2), (9,  3,  3), (9,  4,  4),
(9,  6,  5), (9,  7,  6), (9, 10,  7), (9, 14,  8);

-- -------------------------------------------------------
-- Matches 
-- -------------------------------------------------------
INSERT INTO Matches (TournamentID, Team1ID, Team2ID, MatchDate, Stage, BestOf, Status) VALUES

-- Tournament 1: BD Valorant Open (Quarter + Semi + Final = 7 matches)
(1,  1,  15, '2024-03-01 11:00:00', 'Quarter Final', 3, 'Completed'),
(1,  3,  20, '2024-03-01 14:00:00', 'Quarter Final', 3, 'Completed'),
(1,  6,  16, '2024-03-02 11:00:00', 'Quarter Final', 3, 'Completed'),
(1,  2,   4, '2024-03-02 14:00:00', 'Quarter Final', 3, 'Completed'),
(1,  1,   3, '2024-03-08 14:00:00', 'Semi Final',    3, 'Completed'),
(1,  2,   6, '2024-03-08 17:00:00', 'Semi Final',    3, 'Completed'),
(1,  1,   2, '2024-03-15 18:00:00', 'Final',         5, 'Completed'),

-- Tournament 2: CS2 Championship (7 matches)
(2,  2,  17, '2024-06-10 12:00:00', 'Quarter Final', 1, 'Completed'),
(2,  3,   7, '2024-06-10 15:00:00', 'Quarter Final', 1, 'Completed'),
(2,  1,   5, '2024-06-11 12:00:00', 'Quarter Final', 1, 'Completed'),
(2,  4,   6, '2024-06-11 15:00:00', 'Quarter Final', 1, 'Completed'),
(2,  2,   3, '2024-06-17 15:00:00', 'Semi Final',    3, 'Completed'),
(2,  1,   4, '2024-06-17 18:00:00', 'Semi Final',    3, 'Completed'),
(2,  2,   1, '2024-06-20 18:00:00', 'Final',         3, 'Completed'),

-- Tournament 3: Dota 2 Cup Round Robin (6 matches)
(3,  1,   2, '2024-09-05 11:00:00', 'Group Stage',   1, 'Completed'),
(3,  3,   4, '2024-09-05 14:00:00', 'Group Stage',   1, 'Completed'),
(3,  7,   9, '2024-09-05 17:00:00', 'Group Stage',   1, 'Completed'),
(3,  1,   4, '2024-09-06 11:00:00', 'Group Stage',   1, 'Completed'),
(3,  2,   7, '2024-09-06 14:00:00', 'Group Stage',   1, 'Completed'),
(3,  3,   9, '2024-09-06 17:00:00', 'Group Stage',   1, 'Completed'),

-- Tournament 4: Winter Clash 2025 (ongoing - 5 matches)
(4,  1,   8, '2025-01-15 12:00:00', 'Quarter Final', 3, 'Completed'),
(4,  3,  13, '2025-01-15 15:00:00', 'Quarter Final', 3, 'Completed'),
(4,  2,  10, '2025-01-16 12:00:00', 'Quarter Final', 3, 'Completed'),
(4,  4,  14, '2025-01-16 15:00:00', 'Quarter Final', 3, 'Live'),
(4,  1,   3, '2025-01-22 17:00:00', 'Semi Final',    3, 'Scheduled'),

-- Tournament 5: Free Fire National (5 matches)
(5,  2,  11, '2024-04-20 11:00:00', 'Quarter Final', 1, 'Completed'),
(5,  5,  13, '2024-04-20 14:00:00', 'Quarter Final', 1, 'Completed'),
(5,  7,   8, '2024-04-20 17:00:00', 'Quarter Final', 1, 'Completed'),
(5,  2,   5, '2024-04-26 15:00:00', 'Semi Final',    3, 'Completed'),
(5,  7,   2, '2024-04-28 18:00:00', 'Final',         3, 'Completed'),

-- Tournament 9: Valorant Challengers BD (7 matches)
(9,  1,   7, '2024-10-10 11:00:00', 'Quarter Final', 3, 'Completed'),
(9,  3,  10, '2024-10-10 14:00:00', 'Quarter Final', 3, 'Completed'),
(9,  2,  14, '2024-10-11 11:00:00', 'Quarter Final', 3, 'Completed'),
(9,  4,   6, '2024-10-11 14:00:00', 'Quarter Final', 3, 'Completed'),
(9,  1,   3, '2024-10-18 15:00:00', 'Semi Final',    3, 'Completed'),
(9,  2,   4, '2024-10-18 18:00:00', 'Semi Final',    3, 'Completed'),
(9,  1,   2, '2024-10-25 19:00:00', 'Final',         5, 'Completed'),

-- Tournament 20: Dota 2 Winter Cup (3 matches)
(20, 1,   3, '2025-01-21 14:00:00', 'Semi Final',    3, 'Completed'),
(20, 2,   4, '2025-01-21 17:00:00', 'Semi Final',    3, 'Completed'),
(20, 1,   2, '2025-02-05 18:00:00', 'Final',         5, 'Completed');

-- -------------------------------------------------------
-- Results 
-- -------------------------------------------------------
INSERT INTO Results (MatchID, WinnerTeamID, LoserTeamID, Team1Score, Team2Score, DurationMins, MVPPlayerID) VALUES
-- T1 Matches 1-7
(1,   1, 15,  2,  0,  55,  1),
(2,   3, 20,  2,  1,  70,  9),
(3,   6, 16,  2,  0,  50,  5),
(4,   2,  4,  2,  1,  80,  4),
(5,   1,  3,  2,  1,  85,  1),
(6,   2,  6,  2,  0,  65,  4),
(7,   2,  1,  3,  2, 140,  5),
-- T2 Matches 8-14
(8,   2, 17,  1,  0,  38,  4),
(9,   3,  7,  1,  0,  42,  9),
(10,  1,  5,  1,  0,  45,  1),
(11,  4,  6,  1,  0,  37,  12),
(12,  2,  3,  2,  1,  95,  4),
(13,  1,  4,  2,  0,  75,  1),
(14,  2,  1,  2,  1,  90,  5),
-- T3 Matches 15-20
(15,  2,  1,  1,  0,  48,  4),
(16,  3,  4,  1,  0,  40,  9),
(17,  9,  7,  1,  0,  43,  20),
(18,  1,  4,  1,  0,  45,  1),
(19,  2,  7,  1,  0,  50,  4),
(20,  3,  9,  1,  0,  38,  9),
-- T4 Matches 21-23 (Completed)
(21,  1,  8,  2,  0,  70,  1),
(22,  3, 13,  2,  1,  88,  9),
(23,  2, 10,  2,  0,  65,  4),
-- T5 Matches 26-30
(26,  2, 11,  1,  0,  35,  4),
(27,  5, 13,  1,  0,  40,  13),
(28,  7,  8,  1,  0,  32,  15),
(29,  2,  5,  2,  1,  85,  4),
(30,  7,  2,  2,  1,  95,  15),
-- T9 Matches 31-37
(31,  1,  7,  2,  0,  75,  1),
(32,  3, 10,  2,  1,  88,  9),
(33,  2, 14,  2,  0,  62,  4),
(34,  4,  6,  2,  1,  78,  12),
(35,  1,  3,  2,  1,  92,  1),
(36,  2,  4,  2,  0,  68,  5),
(37,  1,  2,  3,  2, 125,  1),
-- T20 Matches 38-40
(38,  1,  3,  2,  0,  80,  1),
(39,  2,  4,  2,  1,  90,  4),
(40,  1,  2,  3,  1, 110,  2);

-- -------------------------------------------------------
-- Tournament_Standings 
-- -------------------------------------------------------
INSERT INTO Tournament_Standings (TournamentID, TeamID, FinalPosition, PrizeWon) VALUES
-- T1: BD Valorant Open
(1,  2,  1, 250000.00),
(1,  1,  2, 125000.00),
(1,  3,  3,  75000.00),
(1,  6,  4,  50000.00),
(1,  4,  5,  25000.00),
(1, 15,  6,  15000.00),
(1, 16,  7,  10000.00),
(1, 20,  8,  10000.00),
-- T2: CS2 Championship
(2,  2,  1, 150000.00),
(2,  1,  2,  75000.00),
(2,  3,  3,  40000.00),
(2,  4,  4,  30000.00),
(2,  5,  5,  12000.00),
(2,  6,  6,  12000.00),
(2,  7,  7,   6000.00),
(2, 17,  8,   6000.00),
-- T3: Dota 2 Cup
(3,  2,  1, 100000.00),
(3,  3,  2,  50000.00),
(3,  1,  3,  30000.00),
(3,  4,  4,  20000.00),
-- T5: Free Fire National
(5,  7,  1,  75000.00),
(5,  2,  2,  45000.00),
(5,  5,  3,  20000.00),
(5,  8,  4,  10000.00),
-- T9: Valorant Challengers
(9,  1,  1, 300000.00),
(9,  2,  2, 150000.00),
(9,  3,  3,  80000.00),
(9,  4,  4,  50000.00),
(9,  6,  5,  25000.00),
(9,  7,  6,  25000.00),
(9, 10,  7,  10000.00),
(9, 14,  8,  10000.00),
-- T20: Dota 2 Winter Cup
(20, 1,  1,  90000.00),
(20, 2,  2,  50000.00),
(20, 3,  3,  25000.00),
(20, 4,  4,  15000.00);

-- Additional standings for Tournaments 6, 7, 8, 10, 11 (partial)
INSERT INTO Tournament_Standings (TournamentID, TeamID, FinalPosition, PrizeWon) VALUES
(6,  2,  1, 200000.00),
(6,  9,  2, 100000.00),
(6,  4,  3,  60000.00),
(7,  3,  1, 175000.00);


-- ============================================================
-- QUERIES
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
    COALESCE(t.TeamName, 'Free Agent') AS TeamName,
    tm.Role
FROM Players p
LEFT JOIN Team_Members tm ON p.PlayerID = tm.PlayerID
LEFT JOIN Teams t          ON tm.TeamID  = t.TeamID
ORDER BY t.TeamName, p.RankPoints DESC;

-- ----------------------------------------------------------
-- Q2: Total prize money won by each team
-- ----------------------------------------------------------
SELECT
    t.TeamName,
    t.Country,
    COUNT(ts.TournamentID)  AS TournamentsPlayed,
    SUM(ts.PrizeWon)        AS TotalPrizeWon,
    MIN(ts.FinalPosition)   AS BestFinish
FROM Teams t
JOIN Tournament_Standings ts ON t.TeamID = ts.TeamID
GROUP BY t.TeamID, t.TeamName, t.Country
ORDER BY TotalPrizeWon DESC;

-- ----------------------------------------------------------
-- Q3: Win / Loss record and win rate per team
-- ----------------------------------------------------------
SELECT
    t.TeamName,
    COUNT(CASE WHEN r.WinnerTeamID = t.TeamID THEN 1 END) AS Wins,
    COUNT(CASE WHEN r.LoserTeamID  = t.TeamID THEN 1 END) AS Losses,
    COUNT(*) AS TotalMatches,
    ROUND(
        COUNT(CASE WHEN r.WinnerTeamID = t.TeamID THEN 1 END) * 100.0 / COUNT(*), 2
    ) AS WinRatePct
FROM Teams t
JOIN Matches m  ON t.TeamID = m.Team1ID OR t.TeamID = m.Team2ID
JOIN Results r  ON m.MatchID = r.MatchID
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
    COALESCE(t.TeamName, 'Free Agent') AS TeamName,
    tm.Role
FROM Players p
LEFT JOIN Team_Members tm ON p.PlayerID = tm.PlayerID
LEFT JOIN Teams t          ON tm.TeamID  = t.TeamID
ORDER BY p.RankPoints DESC
LIMIT 10;

-- ----------------------------------------------------------
-- Q5: Tournaments summary — game, teams registered, prize pool
-- ----------------------------------------------------------
SELECT
    tn.TournamentName,
    g.GameName,
    tn.Format,
    tn.Status,
    tn.Location,
    COUNT(tr.TeamID) AS TeamsRegistered,
    tn.PrizePool,
    tn.StartDate,
    tn.EndDate
FROM Tournaments tn
JOIN Games g ON tn.GameID = g.GameID
LEFT JOIN Tournament_Registrations tr ON tn.TournamentID = tr.TournamentID
GROUP BY tn.TournamentID, tn.TournamentName, g.GameName, tn.Format, tn.Status, tn.Location, tn.PrizePool, tn.StartDate, tn.EndDate
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
LEFT JOIN Team_Members tm ON p.PlayerID = tm.PlayerID
LEFT JOIN Teams t          ON tm.TeamID  = t.TeamID
GROUP BY p.PlayerID, p.Username, p.FullName, p.Country, t.TeamName
ORDER BY MVPCount DESC;

-- ----------------------------------------------------------
-- Q7: Full match results for a specific tournament (T1)
-- ----------------------------------------------------------
SELECT
    m.MatchID,
    t1.TeamName      AS Team1,
    t2.TeamName      AS Team2,
    r.Team1Score,
    r.Team2Score,
    tw.TeamName      AS Winner,
    m.Stage,
    m.BestOf,
    m.MatchDate,
    r.DurationMins,
    p.Username       AS MVP
FROM Matches m
JOIN Teams t1        ON m.Team1ID       = t1.TeamID
JOIN Teams t2        ON m.Team2ID       = t2.TeamID
LEFT JOIN Results r  ON m.MatchID       = r.MatchID
LEFT JOIN Teams tw   ON r.WinnerTeamID  = tw.TeamID
LEFT JOIN Players p  ON r.MVPPlayerID   = p.PlayerID
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
    p.RankPoints
FROM Players p
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
    COUNT(m.MatchID)       AS TotalMatches,
    ROUND(AVG(r.DurationMins), 1) AS AvgDurationMins,
    MAX(r.DurationMins)    AS LongestMatchMins
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
    t.TeamName,
    t.Country,
    COUNT(*) AS TournamentWins,
    SUM(ts.PrizeWon) AS TotalEarnings
FROM Teams t
JOIN Tournament_Standings ts ON t.TeamID = ts.TeamID
WHERE ts.FinalPosition = 1
GROUP BY t.TeamID, t.TeamName, t.Country
ORDER BY TournamentWins DESC;

-- ----------------------------------------------------------
-- Q11: Player count and avg rank points per country
-- ----------------------------------------------------------
SELECT
    Country,
    COUNT(*)              AS TotalPlayers,
    ROUND(AVG(RankPoints), 0) AS AvgRankPoints,
    MAX(RankPoints)       AS TopRankPoints,
    MIN(RankPoints)       AS LowestRankPoints
FROM Players
GROUP BY Country
ORDER BY TotalPlayers DESC;

-- ----------------------------------------------------------
-- Q12: Complete bracket view — all tournaments, all matches
-- ----------------------------------------------------------
SELECT
    tn.TournamentName,
    g.GameName,
    m.Stage,
    t1.TeamName          AS Team1,
    t2.TeamName          AS Team2,
    CONCAT(r.Team1Score, ' - ', r.Team2Score) AS Score,
    tw.TeamName          AS Winner,
    p.Username           AS MVP,
    r.DurationMins
FROM Matches m
JOIN Tournaments tn  ON m.TournamentID  = tn.TournamentID
JOIN Games g         ON tn.GameID       = g.GameID
JOIN Teams t1        ON m.Team1ID       = t1.TeamID
JOIN Teams t2        ON m.Team2ID       = t2.TeamID
LEFT JOIN Results r  ON m.MatchID       = r.MatchID
LEFT JOIN Teams tw   ON r.WinnerTeamID  = tw.TeamID
LEFT JOIN Players p  ON r.MVPPlayerID   = p.PlayerID
ORDER BY tn.TournamentID, m.MatchDate;

-- ----------------------------------------------------------
-- Q13 [WHERE]: Players from South Korea or South East Asia
--              with RankPoints above 1200
-- ----------------------------------------------------------
SELECT
    PlayerID,
    Username,
    FullName,
    Country,
    RankPoints
FROM Players
WHERE Country IN ('South Korea', 'Malaysia', 'Indonesia', 'Philippines', 'Thailand', 'Myanmar')
  AND RankPoints > 1200
ORDER BY RankPoints DESC;

-- ----------------------------------------------------------
-- Q14 [WHERE + JOIN]: Completed matches played in 'Final' stage
--                     with duration more than 100 minutes
-- ----------------------------------------------------------
SELECT
    m.MatchID,
    tn.TournamentName,
    t1.TeamName     AS Team1,
    t2.TeamName     AS Team2,
    r.Team1Score,
    r.Team2Score,
    r.DurationMins
FROM Matches m
JOIN Tournaments tn ON m.TournamentID = tn.TournamentID
JOIN Teams t1       ON m.Team1ID      = t1.TeamID
JOIN Teams t2       ON m.Team2ID      = t2.TeamID
JOIN Results r      ON m.MatchID      = r.MatchID
WHERE m.Stage       = 'Final'
  AND r.DurationMins > 100
  AND m.Status      = 'Completed'
ORDER BY r.DurationMins DESC;

-- ----------------------------------------------------------
-- Q15 [WHERE + JOIN]: Upcoming tournaments with prize pool
--                     greater than 200,000
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
WHERE tn.Status   = 'Upcoming'
  AND tn.PrizePool > 200000.00
ORDER BY tn.PrizePool DESC;

-- ----------------------------------------------------------
-- Q16 [GROUP BY]: Total matches played per Stage type
--                 across all tournaments
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
-- Q17 [GROUP BY + JOIN]: Number of tournaments each game
--                        has been featured in
-- ----------------------------------------------------------
SELECT
    g.GameID,
    g.GameName,
    g.Genre,
    COUNT(tn.TournamentID)   AS TotalTournaments,
    SUM(tn.PrizePool)        AS TotalPrizeMoney
FROM Games g
LEFT JOIN Tournaments tn ON g.GameID = tn.GameID
GROUP BY g.GameID, g.GameName, g.Genre
ORDER BY TotalTournaments DESC;

-- ----------------------------------------------------------
-- Q18 [ORDER BY]: All teams ranked by total prize money earned,
--                 then alphabetically by TeamName
-- ----------------------------------------------------------
SELECT
    t.TeamName,
    t.Country,
    t.FoundedYear,
    COALESCE(SUM(ts.PrizeWon), 0) AS TotalEarned
FROM Teams t
LEFT JOIN Tournament_Standings ts ON t.TeamID = ts.TeamID
GROUP BY t.TeamID, t.TeamName, t.Country, t.FoundedYear
ORDER BY TotalEarned DESC, t.TeamName ASC;

-- ----------------------------------------------------------
-- Q19 [ORDER BY + LIMIT]: Top 5 highest prize pool tournaments
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
-- Q20 [LIMIT + OFFSET]: Paginate players — page 2,
--                        10 players per page (rows 11-20)
-- ----------------------------------------------------------
SELECT
    PlayerID,
    Username,
    FullName,
    Country,
    RankPoints
FROM Players
ORDER BY RankPoints DESC
LIMIT 10 OFFSET 10;

-- ----------------------------------------------------------
-- Q21 [HAVING]: Countries that have more than 2 players
--               registered in the system
-- ----------------------------------------------------------
SELECT
    Country,
    COUNT(PlayerID)              AS TotalPlayers,
    ROUND(AVG(RankPoints), 0)    AS AvgRankPoints
FROM Players
GROUP BY Country
HAVING COUNT(PlayerID) > 2
ORDER BY TotalPlayers DESC;

-- ----------------------------------------------------------
-- Q22 [HAVING]: Teams that have participated in more than
--               2 tournaments AND total prize won > 100,000
-- ----------------------------------------------------------
SELECT
    t.TeamName,
    t.Country,
    COUNT(ts.TournamentID)   AS TournamentsPlayed,
    SUM(ts.PrizeWon)         AS TotalPrizeWon
FROM Teams t
JOIN Tournament_Standings ts ON t.TeamID = ts.TeamID
GROUP BY t.TeamID, t.TeamName, t.Country
HAVING COUNT(ts.TournamentID) > 2
   AND SUM(ts.PrizeWon) > 100000
ORDER BY TotalPrizeWon DESC;

-- ----------------------------------------------------------
-- Q23 [HAVING]: Games that have hosted more than 1 tournament
--               with combined prize pool over 500,000
-- ----------------------------------------------------------
SELECT
    g.GameName,
    g.Genre,
    COUNT(tn.TournamentID)   AS TotalTournaments,
    SUM(tn.PrizePool)        AS CombinedPrizePool
FROM Games g
JOIN Tournaments tn ON g.GameID = tn.GameID
GROUP BY g.GameID, g.GameName, g.Genre
HAVING COUNT(tn.TournamentID) > 1
   AND SUM(tn.PrizePool) > 500000
ORDER BY CombinedPrizePool DESC;

-- ----------------------------------------------------------
-- Q24 [WHERE + GROUP BY + HAVING + ORDER BY + LIMIT]:
--     Top 3 players (from Asia, excluding Korea) who have
--     played in Completed matches and have above-average RankPoints
-- ----------------------------------------------------------
SELECT
    p.Username,
    p.FullName,
    p.Country,
    p.RankPoints,
    COUNT(DISTINCT m.MatchID) AS MatchesPlayed
FROM Players p
JOIN Team_Members tm ON p.PlayerID = tm.PlayerID
JOIN Matches m       ON tm.TeamID = m.Team1ID OR tm.TeamID = m.Team2ID
WHERE p.Country NOT IN ('South Korea')
  AND m.Status = 'Completed'
  AND p.RankPoints > (SELECT AVG(RankPoints) FROM Players)
GROUP BY p.PlayerID, p.Username, p.FullName, p.Country, p.RankPoints
HAVING COUNT(DISTINCT m.MatchID) >= 2
ORDER BY p.RankPoints DESC
LIMIT 3;

-- ============================================================
-- END OF SCRIPT
-- ============================================================
