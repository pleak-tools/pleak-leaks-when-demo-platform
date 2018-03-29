-- MySQL dump 10.13  Distrib 5.7.21, for Linux (x86_64)
--
-- Host: localhost    Database: pleak
-- ------------------------------------------------------
-- Server version	5.7.21-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `actions`
--

DROP TABLE IF EXISTS `actions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `actions`
--

LOCK TABLES `actions` WRITE;
/*!40000 ALTER TABLE `actions` DISABLE KEYS */;
INSERT INTO `actions` VALUES (2,'edit'),(1,'view');
/*!40000 ALTER TABLE `actions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pobject_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `file_id` (`pobject_id`,`user_id`),
  KEY `fk_permissions_users` (`user_id`),
  KEY `fk_permissions_actions` (`action_id`),
  CONSTRAINT `fk_permissions_actions` FOREIGN KEY (`action_id`) REFERENCES `actions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_permissions_pobjects` FOREIGN KEY (`pobject_id`) REFERENCES `pobjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_permissions_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pobject_types`
--

DROP TABLE IF EXISTS `pobject_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pobject_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `title` (`title`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pobject_types`
--

LOCK TABLES `pobject_types` WRITE;
/*!40000 ALTER TABLE `pobject_types` DISABLE KEYS */;
INSERT INTO `pobject_types` VALUES (2,'directory'),(1,'file');
/*!40000 ALTER TABLE `pobject_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pobjects`
--

DROP TABLE IF EXISTS `pobjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pobjects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `published` tinyint(1) NOT NULL DEFAULT '0',
  `uri` varchar(255) DEFAULT NULL,
  `type_id` int(11) NOT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `last_modified` datetime DEFAULT NULL,
  `modified_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pobjects_pobject_types` (`type_id`),
  KEY `fk_pobjects_pobjects` (`parent_id`),
  KEY `fk_pobjects_users` (`user_id`),
  KEY `fk_pobjects_users2` (`modified_by`),
  CONSTRAINT `fk_pobjects_pobject_types` FOREIGN KEY (`type_id`) REFERENCES `pobject_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pobjects_pobjects` FOREIGN KEY (`parent_id`) REFERENCES `pobjects` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pobjects_users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_pobjects_users2` FOREIGN KEY (`modified_by`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pobjects`
--

LOCK TABLES `pobjects` WRITE;
/*!40000 ALTER TABLE `pobjects` DISABLE KEYS */;
INSERT INTO `pobjects` VALUES (1,'root',1,0,NULL,2,NULL,NULL,NULL),(2,'root',2,0,NULL,2,NULL,NULL,NULL),(3,'root',3,0,NULL,2,NULL,NULL,NULL),(4,'root',4,0,NULL,2,NULL,NULL,NULL),(5,'root',5,0,NULL,2,NULL,NULL,NULL),(6,'root',6,0,NULL,2,NULL,NULL,NULL),(7,'root',7,0,NULL,2,NULL,NULL,NULL),(8,'root',8,0,NULL,2,NULL,NULL,NULL),(11,'ShipAllocationStep1.bpmn',1,0,NULL,1,1,'2018-03-26 17:56:28',1);
/*!40000 ALTER TABLE `pobjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_version`
--

DROP TABLE IF EXISTS `schema_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_version` (
  `installed_rank` int(11) NOT NULL,
  `version` varchar(50) DEFAULT NULL,
  `description` varchar(200) NOT NULL,
  `type` varchar(20) NOT NULL,
  `script` varchar(1000) NOT NULL,
  `checksum` int(11) DEFAULT NULL,
  `installed_by` varchar(100) NOT NULL,
  `installed_on` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `execution_time` int(11) NOT NULL,
  `success` tinyint(1) NOT NULL,
  PRIMARY KEY (`installed_rank`),
  KEY `schema_version_s_idx` (`success`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_version`
--

LOCK TABLES `schema_version` WRITE;
/*!40000 ALTER TABLE `schema_version` DISABLE KEYS */;
INSERT INTO `schema_version` VALUES (1,'1','Create initial tables','SQL','V1__Create_initial_tables.sql',-474359475,'pleak','2018-02-17 11:55:54',23,1),(2,'2','Sharing files','SQL','V2__Sharing_files.sql',199811260,'pleak','2018-02-17 11:55:54',21,1),(3,'2.1','Publishing files','SQL','V2_1__Publishing_files.sql',548310274,'pleak','2018-02-17 11:55:54',17,1),(4,'3','Directories','SQL','V3__Directories.sql',-1825506244,'pleak','2018-02-17 11:55:55',255,1),(5,'4','Last modified','SQL','V4__Last_modified.sql',-941854420,'pleak','2018-02-17 11:55:55',20,1),(6,'4.1','Last modified user','SQL','V4_1__Last_modified_user.sql',356906517,'pleak','2018-02-17 11:55:55',34,1),(7,'5','Blocking users','SQL','V5__Blocking_users.sql',1513143106,'pleak','2018-02-17 11:55:55',14,1);
/*!40000 ALTER TABLE `schema_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `blocked` tinyint(4) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'user1@example.com','$2a$12$I0HXmm4nKy7VL0VmKzHG6u/nFwUl8U0tAYji/hl41fvc8XJAVm5LS',0),(2,'user2@example.com','$2a$12$fObC5ctlHISJyk2.A8G3yusBffnqS4cOx2s3hRaHIoHrHHQnni5qi',0),(3,'user3@example.com','$2a$12$jH/QaHlebWNomVv9w7qeLu1eEcg1kgjiCJXa.spKQEAVDKHyv74QG',0),(4,'test1@example.com','$2a$12$vJinkCwkzykPDDYRtJIWyeWABrlXckVsBTda.IU8A1NzMfjVjIeZG',0),(5,'test2@example.com','$2a$12$WapGwCGThBY9UDDgTj.tMOJzkbfOae0wqlFv5GDxWScNC/3E5ltN.',0),(6,'test3@example.com','$2a$12$Q/CNyytuuCmX3YC.oS2d/un42zs.STRa7Zqwbm1MryleA/6lEwqBy',0),(7,'blocked@example.com','$2a$12$Up3lOd/PRSLq649QbPr75O7aK/o1m4eaZP.Jx73tjh4iBhoco2KI2',1),(8,'changepassword1@example.com','$2a$12$scdd8isaDYDZ6u3pvZKUeO7h5EJ5bmgxrlFHwEEoMYDh/ln.O4cVu',0);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-03-28 15:45:18
