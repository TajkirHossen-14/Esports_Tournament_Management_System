# 🎮 Esports Tournament Management System

A relational database project built with **MySQL** to manage all aspects of competitive esports tournaments — from player registrations and team rosters to match scheduling, results tracking, and prize standings.

---

## 📌 Project Overview

This project was developed as a **Database Management Systems (DBMS)** course project. It models a fully functional esports tournament platform covering players, teams, games, tournaments, matches, and results.

The database is designed to reflect real-world esports operations — supporting multiple games, international teams from across Asia, bracket-style tournaments, and detailed match statistics.

---

## 🗂️ Database Schema

The system contains **9 tables**:

| Table | Description |
|---|---|
| `Games` | Stores all supported esports titles (Valorant, CS2, Dota 2, etc.) |
| `Players` | Individual player profiles with rank points and country info |
| `Teams` | Team registrations with captain reference |
| `Team_Members` | Player–team relationship with roles (IGL, Sniper, Support, etc.) |
| `Tournaments` | Tournament details including format, prize pool, and status |
| `Tournament_Registrations` | Tracks which teams are registered for which tournament |
| `Matches` | Individual match records with stage and Best-of format |
| `Results` | Match outcomes — scores, duration, winner, and MVP |
| `Tournament_Standings` | Final positions and prize money awarded per tournament |

---

## 🌏 Coverage

- **20** unique games across genres (Tactical Shooter, MOBA, Battle Royale, Fighting, Sports, RTS)
- **30** players from **10 Asian countries** — Bangladesh, India, Pakistan, Nepal, Sri Lanka, Malaysia, Indonesia, Philippines, Thailand, South Korea
- **20** teams representing diverse Asian nations
- **20** tournaments with various formats: Single/Double Elimination, Round Robin, Swiss
- **40** matches with full bracket stages (Quarter Final → Semi Final → Final)
- **37** completed match results with MVP records
- **40** tournament standings with prize distribution

---

## 🔑 Key Features

- **PascalCase column naming** — `PlayerID`, `GameName`, `WinnerTeamID`, `DurationMins`
- **Referential integrity** enforced via `FOREIGN KEY` constraints with `ON DELETE CASCADE` / `ON DELETE SET NULL`
- **ENUM types** for structured fields (`Format`, `Status`, `BestOf`)
- **Composite primary keys** in associative tables (`Team_Members`, `Tournament_Registrations`)
- **`CHECK` constraint** to prevent a team from playing against itself

---

## 📋 SQL Clauses & Features Demonstrated

| Category | Keywords Used |
|---|---|
| DDL | `CREATE TABLE`, `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `CHECK`, `AUTO_INCREMENT`, `DEFAULT`, `ENUM` |
| DML | `INSERT INTO` |
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
│   ├── DDL  — CREATE TABLE statements
│   ├── DML  — INSERT sample data (30+ rows per table)
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

# Option 3 — phpMyAdmin
# Import → Choose file → Go
```

The script will automatically:
1. Create the `esports_db` database
2. Create all 9 tables with constraints
3. Insert all sample data
4. Run all 24 demonstration queries

---

## 🧪 Sample Queries Included

| # | Query | Clauses Highlighted |
|---|---|---|
| Q1 | All players with team and role | `LEFT JOIN`, `COALESCE`, `ORDER BY` |
| Q2 | Total prize money per team | `JOIN`, `GROUP BY`, `SUM`, `COUNT` |
| Q3 | Win/Loss rate per team | `CASE WHEN`, `ROUND`, `GROUP BY` |
| Q4 | Top 10 players by rank | `LEFT JOIN`, `ORDER BY`, `LIMIT` |
| Q5 | Tournament summary | `JOIN`, `LEFT JOIN`, `GROUP BY`, `COUNT` |
| Q6 | MVP leaderboard | `JOIN`, `GROUP BY`, `COUNT`, `ORDER BY` |
| Q7 | Full bracket for a tournament | Multi-`JOIN`, `WHERE` |
| Q8 | Players with no MVP award | `WHERE NOT IN`, Subquery |
| Q9 | Avg match duration per tournament | 3-table `JOIN`, `AVG`, `MAX`, `GROUP BY` |
| Q10 | Tournament-winning teams | `WHERE`, `COUNT`, `SUM`, `GROUP BY` |
| Q11 | Player count per country | `GROUP BY`, `AVG`, `MAX`, `MIN` |
| Q12 | Complete bracket view | 5× `JOIN`, 3× `LEFT JOIN`, `CONCAT` |
| Q13 | SE Asia players above 1200 pts | `WHERE`, `IN`, `AND` |
| Q14 | Final matches over 100 mins | `WHERE` multi-condition, `JOIN` |
| Q15 | Upcoming high-prize tournaments | `WHERE`, `JOIN` |
| Q16 | Matches grouped by stage | `GROUP BY`, `COUNT`, `AVG` |
| Q17 | Games by tournament count | `LEFT JOIN`, `GROUP BY`, `SUM` |
| Q18 | Teams ranked by total earnings | `ORDER BY` multi-column |
| Q19 | Top 5 prize pool tournaments | `ORDER BY`, `LIMIT` |
| Q20 | Player list with pagination | `LIMIT`, `OFFSET` |
| Q21 | Countries with 2+ players | `GROUP BY`, `HAVING` |
| Q22 | Teams with 2+ tournaments & 100k+ prize | `HAVING` multi-condition |
| Q23 | Games hosting 1+ tournaments with 500k+ prize | `HAVING`, `SUM` |
| Q24 | Top 3 Asian players (all clauses combined) | `WHERE` + `GROUP BY` + `HAVING` + `ORDER BY` + `LIMIT` |

