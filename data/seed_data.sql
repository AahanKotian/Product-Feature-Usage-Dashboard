-- =============================================================
-- seed_data.sql
-- Creates and populates: users, features, feature_events
-- Run this FIRST before any queries in /sql
-- =============================================================

DROP TABLE IF EXISTS feature_events;
DROP TABLE IF EXISTS features;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id      INTEGER PRIMARY KEY,
    plan_type    TEXT,    -- free | pro | enterprise
    device_type  TEXT,    -- mobile | desktop | tablet
    signed_up_at TEXT,
    country      TEXT
);

CREATE TABLE features (
    feature_id   INTEGER PRIMARY KEY,
    feature_name TEXT,
    category     TEXT,    -- core | productivity | advanced
    launched_at  TEXT
);

CREATE TABLE feature_events (
    event_id     INTEGER PRIMARY KEY,
    user_id      INTEGER,
    feature_id   INTEGER,
    occurred_at  TEXT,
    FOREIGN KEY (user_id)    REFERENCES users(user_id),
    FOREIGN KEY (feature_id) REFERENCES features(feature_id)
);

-- Features
INSERT INTO features (feature_id, feature_name, category, launched_at) VALUES
(1,'Dashboard','core','2022-01-01'),
(2,'Search','core','2022-01-01'),
(3,'Export','productivity','2022-03-15'),
(4,'Reports','productivity','2022-06-01'),
(5,'Notifications','core','2022-02-01'),
(6,'API Access','advanced','2023-01-01'),
(7,'Integrations','advanced','2023-04-01'),
(8,'Advanced Filters','advanced','2023-07-01');

-- Users (50 users across plan types and devices)
INSERT INTO users (user_id, plan_type, device_type, signed_up_at, country) VALUES
(1,'free','mobile','2023-11-01','US'),(2,'free','desktop','2023-11-03','CA'),
(3,'free','mobile','2023-11-05','US'),(4,'free','tablet','2023-11-07','UK'),
(5,'free','desktop','2023-11-09','US'),(6,'free','mobile','2023-11-11','AU'),
(7,'free','desktop','2023-11-13','US'),(8,'free','mobile','2023-11-15','CA'),
(9,'free','desktop','2023-11-17','US'),(10,'free','tablet','2023-11-19','UK'),
(11,'free','mobile','2023-11-21','US'),(12,'free','desktop','2023-11-23','DE'),
(13,'free','mobile','2023-11-25','US'),(14,'free','desktop','2023-11-27','FR'),
(15,'free','mobile','2023-11-29','US'),
(16,'pro','desktop','2023-10-01','US'),(17,'pro','desktop','2023-10-05','CA'),
(18,'pro','mobile','2023-10-10','US'),(19,'pro','desktop','2023-10-15','UK'),
(20,'pro','tablet','2023-10-20','US'),(21,'pro','desktop','2023-10-25','AU'),
(22,'pro','mobile','2023-10-30','US'),(23,'pro','desktop','2023-11-02','CA'),
(24,'pro','mobile','2023-11-06','US'),(25,'pro','desktop','2023-11-10','DE'),
(26,'pro','tablet','2023-11-14','US'),(27,'pro','desktop','2023-11-18','UK'),
(28,'pro','mobile','2023-11-22','US'),(29,'pro','desktop','2023-11-26','FR'),
(30,'pro','mobile','2023-11-28','US'),
(31,'enterprise','desktop','2023-09-01','US'),(32,'enterprise','desktop','2023-09-10','CA'),
(33,'enterprise','mobile','2023-09-15','US'),(34,'enterprise','desktop','2023-09-20','UK'),
(35,'enterprise','tablet','2023-09-25','US'),(36,'enterprise','desktop','2023-10-01','AU'),
(37,'enterprise','mobile','2023-10-05','US'),(38,'enterprise','desktop','2023-10-10','DE'),
(39,'enterprise','desktop','2023-10-15','US'),(40,'enterprise','mobile','2023-10-20','CA'),
(41,'free','mobile','2023-12-01','US'),(42,'free','desktop','2023-12-02','US'),
(43,'free','mobile','2023-12-03','UK'),(44,'pro','desktop','2023-12-04','US'),
(45,'pro','mobile','2023-12-05','CA'),(46,'enterprise','desktop','2023-12-06','US'),
(47,'enterprise','tablet','2023-12-07','AU'),(48,'free','mobile','2023-12-08','US'),
(49,'pro','desktop','2023-12-09','DE'),(50,'enterprise','desktop','2023-12-10','US');

-- Feature events (Jan 1-30 2024)
-- Dashboard (feature 1) - heavy, all plans
INSERT INTO feature_events (event_id, user_id, feature_id, occurred_at) VALUES
(1001,1,1,'2024-01-02'),(1002,2,1,'2024-01-02'),(1003,3,1,'2024-01-03'),
(1004,4,1,'2024-01-03'),(1005,5,1,'2024-01-04'),(1006,6,1,'2024-01-04'),
(1007,7,1,'2024-01-05'),(1008,8,1,'2024-01-05'),(1009,9,1,'2024-01-06'),
(1010,10,1,'2024-01-06'),(1011,11,1,'2024-01-07'),(1012,12,1,'2024-01-08'),
(1013,13,1,'2024-01-09'),(1014,14,1,'2024-01-10'),(1015,15,1,'2024-01-11'),
(1016,16,1,'2024-01-02'),(1017,17,1,'2024-01-03'),(1018,18,1,'2024-01-04'),
(1019,19,1,'2024-01-05'),(1020,20,1,'2024-01-06'),(1021,21,1,'2024-01-07'),
(1022,22,1,'2024-01-08'),(1023,23,1,'2024-01-09'),(1024,24,1,'2024-01-10'),
(1025,25,1,'2024-01-11'),(1026,26,1,'2024-01-12'),(1027,27,1,'2024-01-13'),
(1028,28,1,'2024-01-14'),(1029,29,1,'2024-01-15'),(1030,30,1,'2024-01-16'),
(1031,31,1,'2024-01-02'),(1032,32,1,'2024-01-03'),(1033,33,1,'2024-01-04'),
(1034,34,1,'2024-01-05'),(1035,35,1,'2024-01-06'),(1036,36,1,'2024-01-07'),
(1037,37,1,'2024-01-08'),(1038,38,1,'2024-01-09'),(1039,39,1,'2024-01-10'),
(1040,40,1,'2024-01-11'),(1041,1,1,'2024-01-08'),(1042,2,1,'2024-01-09'),
(1043,16,1,'2024-01-10'),(1044,17,1,'2024-01-11'),(1045,31,1,'2024-01-12'),
(1046,32,1,'2024-01-13'),(1047,5,1,'2024-01-14'),(1048,20,1,'2024-01-15'),
(1049,35,1,'2024-01-16'),(1050,1,1,'2024-01-16'),(1051,2,1,'2024-01-17'),
(1052,16,1,'2024-01-18'),(1053,31,1,'2024-01-19'),(1054,17,1,'2024-01-20'),
(1055,32,1,'2024-01-21');

-- Search (feature 2) - high usage
INSERT INTO feature_events (event_id, user_id, feature_id, occurred_at) VALUES
(2001,1,2,'2024-01-02'),(2002,3,2,'2024-01-03'),(2003,5,2,'2024-01-04'),
(2004,7,2,'2024-01-05'),(2005,9,2,'2024-01-06'),(2006,11,2,'2024-01-07'),
(2007,13,2,'2024-01-08'),(2008,16,2,'2024-01-09'),(2009,18,2,'2024-01-10'),
(2010,20,2,'2024-01-11'),(2011,22,2,'2024-01-12'),(2012,24,2,'2024-01-13'),
(2013,26,2,'2024-01-14'),(2014,28,2,'2024-01-15'),(2015,30,2,'2024-01-16'),
(2016,31,2,'2024-01-02'),(2017,33,2,'2024-01-03'),(2018,35,2,'2024-01-04'),
(2019,37,2,'2024-01-05'),(2020,39,2,'2024-01-06'),(2021,1,2,'2024-01-10'),
(2022,16,2,'2024-01-12'),(2023,31,2,'2024-01-14'),(2024,3,2,'2024-01-16'),
(2025,18,2,'2024-01-18'),(2026,33,2,'2024-01-20'),(2027,5,2,'2024-01-22'),
(2028,20,2,'2024-01-24'),(2029,35,2,'2024-01-26');

-- Export (feature 3) - moderate, pro/enterprise skew
INSERT INTO feature_events (event_id, user_id, feature_id, occurred_at) VALUES
(3001,16,3,'2024-01-05'),(3002,17,3,'2024-01-06'),(3003,18,3,'2024-01-07'),
(3004,19,3,'2024-01-08'),(3005,20,3,'2024-01-09'),(3006,21,3,'2024-01-10'),
(3007,22,3,'2024-01-11'),(3008,23,3,'2024-01-12'),(3009,31,3,'2024-01-05'),
(3010,32,3,'2024-01-06'),(3011,33,3,'2024-01-07'),(3012,34,3,'2024-01-08'),
(3013,35,3,'2024-01-09'),(3014,36,3,'2024-01-10'),(3015,37,3,'2024-01-11'),
(3016,16,3,'2024-01-20'),(3017,31,3,'2024-01-22'),(3018,32,3,'2024-01-24'),
(3019,2,3,'2024-01-15'),(3020,5,3,'2024-01-18');

-- Reports (feature 4) - moderate, pro/enterprise
INSERT INTO feature_events (event_id, user_id, feature_id, occurred_at) VALUES
(4001,16,4,'2024-01-08'),(4002,19,4,'2024-01-09'),(4003,22,4,'2024-01-10'),
(4004,25,4,'2024-01-11'),(4005,28,4,'2024-01-12'),(4006,31,4,'2024-01-08'),
(4007,34,4,'2024-01-09'),(4008,37,4,'2024-01-10'),(4009,40,4,'2024-01-11'),
(4010,17,4,'2024-01-15'),(4011,20,4,'2024-01-16'),(4012,32,4,'2024-01-17'),
(4013,35,4,'2024-01-18'),(4014,38,4,'2024-01-19');

-- Notifications (feature 5) - light, all plans
INSERT INTO feature_events (event_id, user_id, feature_id, occurred_at) VALUES
(5001,1,5,'2024-01-03'),(5002,6,5,'2024-01-05'),(5003,11,5,'2024-01-07'),
(5004,16,5,'2024-01-09'),(5005,21,5,'2024-01-11'),(5006,26,5,'2024-01-13'),
(5007,31,5,'2024-01-15'),(5008,36,5,'2024-01-17'),(5009,41,5,'2024-01-19'),
(5010,3,5,'2024-01-21'),(5011,8,5,'2024-01-23'),(5012,13,5,'2024-01-25');

-- API Access (feature 6) - low, enterprise heavy
INSERT INTO feature_events (event_id, user_id, feature_id, occurred_at) VALUES
(6001,31,6,'2024-01-10'),(6002,32,6,'2024-01-11'),(6003,33,6,'2024-01-12'),
(6004,34,6,'2024-01-13'),(6005,35,6,'2024-01-14'),(6006,36,6,'2024-01-15'),
(6007,16,6,'2024-01-16'),(6008,17,6,'2024-01-17'),(6009,31,6,'2024-01-20');

-- Integrations (feature 7) - very low
INSERT INTO feature_events (event_id, user_id, feature_id, occurred_at) VALUES
(7001,31,7,'2024-01-12'),(7002,34,7,'2024-01-15'),(7003,37,7,'2024-01-18'),
(7004,40,7,'2024-01-21'),(7005,16,7,'2024-01-24'),(7006,19,7,'2024-01-27');

-- Advanced Filters (feature 8) - barely used (the buried feature!)
INSERT INTO feature_events (event_id, user_id, feature_id, occurred_at) VALUES
(8001,31,8,'2024-01-15'),(8002,32,8,'2024-01-20'),
(8003,16,8,'2024-01-25'),(8004,34,8,'2024-01-28');

-- Sanity check
SELECT 'users' AS tbl, COUNT(*) AS rows FROM users
UNION ALL SELECT 'features', COUNT(*) FROM features
UNION ALL SELECT 'feature_events', COUNT(*) FROM feature_events;
