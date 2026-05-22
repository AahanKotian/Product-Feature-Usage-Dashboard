# 📊 Product Feature Usage Dashboard

> **Resume line:** *"Queried feature engagement logs to surface top 3 underutilized features, informing a product roadmap decision. Segmented usage by user plan, device type, and activity tier."*

---

## 📌 Project Overview

This project answers the core product analytics question:

> *"Which features are being used, by whom, and how often — and which ones are being ignored?"*

You'll analyze a simulated SaaS app with 8 features, 500 users across 3 plan tiers, and 30 days of event data. The output is a feature usage dashboard that a product team could use to prioritize roadmap decisions.

**Business Questions Answered:**
- Which features are most and least used overall?
- Which user segments (plan type, device) use which features?
- Are power users driving all the usage, or is it spread evenly?
- Which features are "sticky" (used repeatedly) vs. tried once and abandoned?

---

## 🗂️ Project Structure

```
product-feature-usage/
│
├── README.md
├── data/
│   └── seed_data.sql                     # Creates + populates all tables
│
├── sql/
│   ├── 01_overall_feature_usage.sql      # Total usage ranked by feature
│   ├── 02_usage_by_segment.sql           # Usage broken down by plan & device
│   ├── 03_underutilized_features.sql     # Surface the bottom features
│   ├── 04_feature_stickiness.sql         # Repeat usage vs. one-time tries
│   └── 05_power_users.sql                # Who are the top feature users?
│
└── docs/
    └── findings.md                       # Sample product team write-up
```

---

## 🛠️ Skills Demonstrated

| SQL Concept | Where Used |
|---|---|
| `GROUP BY` + `COUNT` / `SUM` | Aggregating events per feature |
| `ORDER BY` + `LIMIT` | Ranking top/bottom features |
| `WHERE` with date filters | Scoping to a 30-day window |
| `CASE WHEN` | Segmenting users into activity tiers |
| `HAVING` | Filtering aggregated results |
| `LEFT JOIN` | Catching features with zero usage |
| `COUNT(DISTINCT ...)` | Unique user counts vs. raw event counts |
| CTEs (`WITH`) | Chaining logic cleanly across queries |

---

## 🗃️ Schema

**`users`** — one row per registered user
```
user_id | plan_type | device_type | signed_up_at | country
```
`plan_type`: free | pro | enterprise
`device_type`: mobile | desktop | tablet

**`features`** — the app's 8 features
```
feature_id | feature_name | category | launched_at
```

**`feature_events`** — one row per feature interaction
```
event_id | user_id | feature_id | occurred_at
```

---

## 📊 Sample Output

### Overall Feature Usage (30 days)

| Rank | Feature | Total Uses | Unique Users | Avg Uses/User |
|---|---|---|---|---|
| 1 | Dashboard | 4,821 | 498 | 9.7 |
| 2 | Search | 3,204 | 401 | 8.0 |
| 3 | Export | 2,190 | 310 | 7.1 |
| ... | ... | ... | ... | ... |
| 6 | API Access | 312 | 89 | 3.5 |
| 7 | Integrations | 187 | 64 | 2.9 |
| 8 | **Advanced Filters** | **98** | **41** | **2.4** |

**Key Finding:** Advanced Filters, Integrations, and API Access are the bottom 3 features — used by fewer than 10% of users despite being Pro/Enterprise-tier features.

---

## 🚀 How to Run

### Option A — SQLiteOnline (No Setup)
1. Go to [sqliteonline.com](https://sqliteonline.com/)
2. Paste and run `data/seed_data.sql` first
3. Run each file in `sql/` in order (01 → 05)

### Option B — Local SQLite
```bash
sqlite3 feature_usage.db < data/seed_data.sql
sqlite3 feature_usage.db < sql/01_overall_feature_usage.sql
sqlite3 feature_usage.db < sql/02_usage_by_segment.sql
sqlite3 feature_usage.db < sql/03_underutilized_features.sql
sqlite3 feature_usage.db < sql/04_feature_stickiness.sql
sqlite3 feature_usage.db < sql/05_power_users.sql
```

### Option C — BigQuery / Snowflake / Postgres
Standard SQL throughout. Only `JULIANDAY()` (file 04) is SQLite-specific — swap for `DATEDIFF()` or `DATE_DIFF()` in other dialects.

---

## 💡 Extensions (Stretch Goals)

- [ ] Add a `session_id` column to group events into sessions
- [ ] Calculate feature adoption rate by plan_type over time (weekly)
- [ ] Find "feature pairs" — which two features are most often used together?
- [ ] Build a DAU/WAU/MAU ratio per feature to measure engagement quality
- [ ] Export to CSV and visualize in Google Sheets, Tableau Public, or Metabase

---

## 📝 Findings

See [`docs/findings.md`](docs/findings.md) for a sample write-up framed as a product roadmap recommendation.

---

*Part of a SQL portfolio series focused on product analytics for tech companies.*
