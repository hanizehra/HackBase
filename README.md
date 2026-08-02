# HackBase — Hackathon Management Database (Advanced DBMS Project)

HackBase is a MySQL project built to demonstrate core **Advanced Database Management Systems** concepts — schema design, indexing, transactions & ACID properties, concurrency control, deadlocks, crash recovery, and query optimization — using a realistic hackathon-management scenario (hackathons, teams, participants, judges, submissions, and scores).

## 📌 Domain

The database models a hackathon platform:
- Multiple **Hackathons**, each with a team limit and a location
- **Teams** that register for a hackathon and have **Participants** as members
- **Judges** who score team **Submissions** on innovation, technical quality, and presentation

## 🗂️ Schema Overview

| Table | Purpose |
|---|---|
| `Hackathons` | Event details (dates, location, max teams) |
| `Teams` | Teams registered per hackathon |
| `Participants` | Individual participants (~3,000 sample rows) |
| `Team_Members` | Many-to-many link between teams and participants |
| `Judges` | Judges and their expertise |
| `Submissions` | One project submission per team |
| `Scores` | Judge scores per submission |

## 📁 Project Structure

```
hackbase-dbms/
├── README.md
└── sql/
    ├── 01_create_database_and_tables.sql   # Schema: database + 7 tables, PKs/FKs
    ├── 02_insert_sample_data.sql           # Sample data + bulk-generates 3,000 participants
    ├── 03_indexing_demo.sql                # Single-column, composite & covering indexes
    ├── 04_transactions_acid.sql            # COMMIT / ROLLBACK, atomicity & consistency
    ├── 05_concurrency_locks.sql            # Row locking, blocking, isolation levels
    ├── 06_deadlock_demo.sql                # Deadlock creation + MySQL's detection/recovery
    ├── 07_recovery_demo.sql                # Crash simulation & durability proof
    └── 08_query_optimization.sql           # EXPLAIN ANALYZE, index tuning, query rewriting
```

## 🚀 How to Run

**Requirements:** MySQL 8.0+ (MySQL Workbench recommended, since several demos use `EXPLAIN ANALYZE` and need two separate connections).

1. Clone the repo:
   ```bash
   git clone https://github.com/<your-username>/hackbase-dbms.git
   cd hackbase-dbms/sql
   ```
2. Run the scripts **in order**, `01` through `08`, in MySQL Workbench (or the `mysql` CLI):
   ```bash
   mysql -u root -p < 01_create_database_and_tables.sql
   mysql -u root -p < 02_insert_sample_data.sql
   ```
   *(Step 02 takes a few seconds — it bulk-generates 3,000 participants via a stored procedure loop.)*
3. Steps `05` and `06` (concurrency & deadlocks) need **two separate MySQL Workbench connections** open at once to the same database, simulating two concurrent sessions.
4. Step `07`'s durability test involves actually restarting the MySQL service mid-demo.

## 🧠 Concepts Demonstrated

- **Indexing** — single-column, composite, and covering indexes with `EXPLAIN` before/after comparisons
- **ACID Transactions** — atomic multi-step inserts, explicit rollback proofs
- **Concurrency Control** — `SELECT ... FOR UPDATE` row locking, blocking behavior, isolation level switching, a seat-limit race-condition test
- **Deadlocks** — two sessions locking rows in reverse order, MySQL's automatic deadlock detection and victim selection, `SHOW ENGINE INNODB STATUS` inspection
- **Recovery** — simulated mid-transaction crash via rollback, and durability verification via service restart
- **Query Optimization** — `EXPLAIN ANALYZE` on a multi-join leaderboard query, index tuning on join columns, subquery-to-JOIN rewriting

## 📸 Notes

Several scripts include `👉 Screenshot:` comments marking the exact points to capture output for a lab report or presentation (e.g., before/after `EXPLAIN` plans, deadlock error messages, lock-wait behavior).

## 🛠️ Tech Stack

- MySQL 8.0
- MySQL Workbench

## 📄 License

MIT — feel free to use this for learning or coursework reference.
