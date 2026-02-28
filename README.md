# 🎮 Esports Tournament Management System

A relational database project built with **MySQL** to manage all aspects of competitive esports  
tournaments – from player rosters and team management to match scheduling, results tracking, and prize distribution.

---

## 📌 Project Overview

This project was developed as a **Database Management Systems (DBMS)** course project.  
It models a fully functional esports tournament platform covering players, teams, games, tournaments, matches, and results.

The database is designed to reflect real-world esports operations – supporting multiple games, international teams from across Asia, bracket-style tournaments, and detailed match statistics.

---

## 🗂️ Database Schema

The system contains **6 tables**:

| Table | Description |
|---|---|
| `Games` | Stores all supported esports titles (Valorant, CS2, Dota 2, etc.) |
| `Players` | Player profiles with rank points, country, team assignment, and in-game role |
| `Teams` | Team info with captain reference, total wins, and cumulative prize earned |
| `Tournaments` | Tournament details including format, prize pool, status, and winner team |
| `Matches` | Match records with stage, Best-of format, and winner/loser references |
| `Results` | Match outcomes — scores, duration, MVP, and prize awarded per team |


---

## 🌏 Coverage

- **20** unique games across genres (Tactical Shooter, MOBA, Battle Royale, Fighting, Sports, RTS)
- **30** players from **10 Asian countries** — Bangladesh, India, Pakistan, Nepal, Sri Lanka, Malaysia, Indonesia, Philippines, Thailand, South Korea
- **20** teams representing diverse Asian nations
- **20** tournaments with various formats: Single/Double Elimination, Round Robin, Swiss
- **40** matches with full bracket stages (Quarter Final → Semi Final → Final)
- **37** completed match results with MVP records

---

## 🔑 Key Features

- **PascalCase column naming** — `PlayerID`, `GameName`, `WinnerTeamID`, `DurationMins`
- **Referential integrity** enforced via `FOREIGN KEY` constraints with `ON DELETE CASCADE` / `ON DELETE SET NULL`
- **ENUM types** for structured fields (`Format`, `Status`)
- **`CHECK` constraint** to prevent a team from playing against itself
- **`UPDATE` statements** used to set `CaptainID` after both Teams and Players are inserted
- **Role & TeamID in Players** — eliminates the need for a separate junction table
- **WinnerTeamID in Matches & Tournaments** — standings tracked without a separate standings table

---

## 📋 SQL Clauses & Features Demonstrated

| Category | Keywords Used |
|---|---|
| DDL | `CREATE TABLE`, `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `AUTO_INCREMENT`, `DEFAULT`, `ENUM` |
| DML | `INSERT INTO`, `UPDATE` |
| Filtering | `WHERE`, `IN`, `AND`, `NOT IN` |
| Aggregation | `GROUP BY`, `HAVING`, `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`, `ROUND` |
| Sorting & Limiting | `ORDER BY ASC/DESC`, `LIMIT`, `LIMIT ... OFFSET` |
| Joins | `JOIN`, `LEFT JOIN` (up to 5 joins in a single query) |
| Other | `COALESCE`, `CONCAT`, `CASE WHEN`, `Subquery`, `DISTINCT` |

---

## 📂 File Structure

```
esports-tournament-db/
│
├── esports_tournament_management.sql   # Main SQL file
│   ├── DDL  — CREATE TABLE statements (6 tables)
│   ├── DML  — INSERT + UPDATE sample data (20–30 rows per table)
│   └── DQL  — 24 SELECT queries
│
└── README.md
```

---

## 🚀 How to Run

**Requirements:** MySQL 8.0 or later

```bash
# Option 1 — MySQL CLI
mysql -u root -p < esports_tournament_management.sql

# Option 2 — MySQL Workbench
# File → Open SQL Script → esports_tournament_management.sql → Execute (⚡)

# Option 3 — Cursor IDE (Terminal)
# Open terminal with Ctrl+` then run Option 1 above

# Option 4 — phpMyAdmin
# Import → Choose file → Go
```

The script will automatically:
1. Create the `esports_db` database
2. Create all 6 tables with constraints
3. Insert all sample data and set captain references
4. Run all 24 demonstration queries

---

## 🧪 Sample Queries Included

| # | Query | Clauses Highlighted |
|---|---|---|
| Q1 | All players with team and role | `LEFT JOIN`, `COALESCE`, `ORDER BY` |
| Q2 | Total prize money and wins per team | `ORDER BY` |
| Q3 | Win/Loss rate per team | `JOIN`, `WHERE`, `CASE WHEN`, `ROUND`, `GROUP BY` |
| Q4 | Top 10 players by rank | `LEFT JOIN`, `ORDER BY`, `LIMIT` |
| Q5 | Tournament summary with winner | `JOIN`, `LEFT JOIN`, `COALESCE`, `ORDER BY` |
| Q6 | MVP leaderboard | `JOIN`, `GROUP BY`, `COUNT`, `ORDER BY` |
| Q7 | Full bracket for a tournament | Multi-`JOIN`, `WHERE`, `ORDER BY` |
| Q8 | Players with no MVP award | `WHERE NOT IN`, Subquery |
| Q9 | Avg match duration per tournament | 3-table `JOIN`, `AVG`, `MAX`, `GROUP BY` |
| Q10 | Tournament-winning teams | `WHERE`, `ORDER BY` |
| Q11 | Player count per country | `GROUP BY`, `AVG`, `MAX`, `MIN` |
| Q12 | Complete bracket view | 5× `JOIN`, 3× `LEFT JOIN`, `CONCAT` |
| Q13 | SE/East Asian players above 1200 pts | `WHERE`, `IN`, `AND` |
| Q14 | Final matches over 100 mins | `WHERE` multi-condition, `JOIN` |
| Q15 | Upcoming high-prize tournaments | `WHERE`, `JOIN` |
| Q16 | Matches grouped by stage | `GROUP BY`, `COUNT`, `AVG` |
| Q17 | Games by tournament count | `LEFT JOIN`, `GROUP BY`, `SUM` |
| Q18 | Teams ranked by total earnings | `ORDER BY` multi-column |
| Q19 | Top 5 prize pool tournaments | `ORDER BY`, `LIMIT` |
| Q20 | Player list with pagination | `LIMIT`, `OFFSET` |
| Q21 | Countries with 2+ players | `GROUP BY`, `HAVING` |
| Q22 | Teams with 1+ wins and prize > 100k | `GROUP BY`, `HAVING` multi-condition |
| Q23 | Games with 2+ tournaments and prize > 500k | `HAVING`, `SUM` |
| Q24 | Top 3 Asian players — all clauses combined | `WHERE` + `GROUP BY` + `HAVING` + `ORDER BY` + `LIMIT` |
