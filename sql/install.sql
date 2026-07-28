CREATE TABLE IF NOT EXISTS `players` (
  `identifier`      VARCHAR(64) NOT NULL,
  `citizenid`       VARCHAR(64) NOT NULL,

  `name`            VARCHAR(64) NOT NULL DEFAULT 'Kodanik',

  `job_name`        VARCHAR(50) NOT NULL DEFAULT 'unemployed',
  `job_grade`       INT NOT NULL DEFAULT 0,

  `gang_name`       VARCHAR(50) DEFAULT NULL,
  `gang_grade`      INT NOT NULL DEFAULT 0,

  `money_cash`      INT NOT NULL DEFAULT 500,
  `money_bank`      INT NOT NULL DEFAULT 2500,

  `group`           VARCHAR(50) NOT NULL DEFAULT '',
  `isAdmin`         BOOLEAN NOT NULL DEFAULT FALSE,

  `permissions`     JSON DEFAULT NULL,

  `position`        LONGTEXT DEFAULT NULL,
  `metadata`        LONGTEXT DEFAULT NULL,

  `created_at`      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (`identifier`),
  UNIQUE KEY `citizenid_unique` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
