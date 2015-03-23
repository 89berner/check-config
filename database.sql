UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';
FLUSH PRIVILEGES;

CREATE DATABASE  IF NOT EXISTS `check_config` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `check_config`;

DROP TABLE IF EXISTS `check_config`;

CREATE TABLE `check_config` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `datetime` datetime DEFAULT NULL,
  `setting` varchar(50) DEFAULT NULL,
  `file` varchar(50) DEFAULT NULL,
  `value` text,
  `host` varchar(50) DEFAULT NULL,
  `ip` varchar(20) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `updatedate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `date` (`date`),
  KEY `file` (`file`),
  KEY `ip` (`ip`)
) ENGINE=InnoDB AUTO_INCREMENT=5785988 DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `check_packages`;
CREATE TABLE `check_packages` (
  `ip` varchar(30) NOT NULL DEFAULT '',
  `package` varchar(100) NOT NULL DEFAULT '',
  `parch` varchar(50) NOT NULL DEFAULT '',
  `date` datetime DEFAULT NULL,
  `hostname` varchar(50) NOT NULL DEFAULT '',
  `datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`ip`,`package`,`parch`,`hostname`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
