CREATE TABLE IF NOT EXISTS `players` (
  `identifier`  VARCHAR(64) NOT NULL,
  `citizenid`   VARCHAR(64) NOT NULL,
  `name`        VARCHAR(64) NOT NULL DEFAULT 'Kodanik',
  `job_name`    VARCHAR(50) NOT NULL DEFAULT 'unemployed',
  `job_grade`   INT NOT NULL DEFAULT 0,
  `gang_name`   VARCHAR(50) DEFAULT NULL,
  `gang_grade`  INT NOT NULL DEFAULT 0,
  `money_cash`  INT NOT NULL DEFAULT 500,
  `money_bank`  INT NOT NULL DEFAULT 2500,
  `position`    LONGTEXT DEFAULT NULL,
  `metadata`    LONGTEXT DEFAULT NULL,
  PRIMARY KEY (`identifier`),
  UNIQUE KEY `citizenid_unique` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
