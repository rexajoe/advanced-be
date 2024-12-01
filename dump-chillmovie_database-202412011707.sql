-- MySQL dump 10.13  Distrib 9.0.1, for macos15.1 (arm64)
--
-- Host: localhost    Database: chillmovie_database
-- ------------------------------------------------------
-- Server version	9.0.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Daftar_Saya`
--

DROP TABLE IF EXISTS `Daftar_Saya`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Daftar_Saya` (
  `list_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `movie_id` int DEFAULT NULL,
  `episode_id` int DEFAULT NULL,
  `added_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`list_id`),
  KEY `user_id` (`user_id`),
  KEY `movie_id` (`movie_id`),
  KEY `episode_id` (`episode_id`),
  CONSTRAINT `daftar_saya_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`),
  CONSTRAINT `daftar_saya_ibfk_2` FOREIGN KEY (`movie_id`) REFERENCES `Movie` (`movie_id`),
  CONSTRAINT `daftar_saya_ibfk_3` FOREIGN KEY (`episode_id`) REFERENCES `Episode` (`episode_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Daftar_Saya`
--

LOCK TABLES `Daftar_Saya` WRITE;
/*!40000 ALTER TABLE `Daftar_Saya` DISABLE KEYS */;
/*!40000 ALTER TABLE `Daftar_Saya` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Episode`
--

DROP TABLE IF EXISTS `Episode`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Episode` (
  `episode_id` int NOT NULL AUTO_INCREMENT,
  `series_id` int DEFAULT NULL,
  `episode_title` varchar(100) NOT NULL,
  `episode_number` int NOT NULL,
  `duration` int DEFAULT NULL,
  `release_date` date DEFAULT NULL,
  PRIMARY KEY (`episode_id`),
  KEY `series_id` (`series_id`),
  CONSTRAINT `episode_ibfk_1` FOREIGN KEY (`series_id`) REFERENCES `Movie` (`movie_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Episode`
--

LOCK TABLES `Episode` WRITE;
/*!40000 ALTER TABLE `Episode` DISABLE KEYS */;
/*!40000 ALTER TABLE `Episode` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Genre`
--

DROP TABLE IF EXISTS `Genre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Genre` (
  `genre_id` int NOT NULL AUTO_INCREMENT,
  `genre_name` varchar(50) NOT NULL,
  PRIMARY KEY (`genre_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Genre`
--

LOCK TABLES `Genre` WRITE;
/*!40000 ALTER TABLE `Genre` DISABLE KEYS */;
INSERT INTO `Genre` VALUES (1,'Sci-Fi'),(2,'Drama'),(3,'Comedy'),(4,'Action');
/*!40000 ALTER TABLE `Genre` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Movie`
--

DROP TABLE IF EXISTS `Movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Movie` (
  `movie_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `release_date` date DEFAULT NULL,
  `duration` int DEFAULT NULL,
  `type` varchar(10) DEFAULT NULL,
  `genre_id` int DEFAULT NULL,
  PRIMARY KEY (`movie_id`),
  KEY `genre_id` (`genre_id`),
  CONSTRAINT `movie_ibfk_1` FOREIGN KEY (`genre_id`) REFERENCES `Genre` (`genre_id`),
  CONSTRAINT `movie_chk_1` CHECK ((`type` in (_utf8mb4'Film',_utf8mb4'Series')))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Movie`
--

LOCK TABLES `Movie` WRITE;
/*!40000 ALTER TABLE `Movie` DISABLE KEYS */;
INSERT INTO `Movie` VALUES (4,'The Dark Knight','2008-07-18',152,'Film',4),(5,'The Godfather','1972-03-24',175,'Film',2),(6,'Forrest Gump','1994-07-06',142,'Film',2);
/*!40000 ALTER TABLE `Movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Order_Table`
--

DROP TABLE IF EXISTS `Order_Table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Order_Table` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `package_id` int DEFAULT NULL,
  `order_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `expiry_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`order_id`),
  KEY `user_id` (`user_id`),
  KEY `package_id` (`package_id`),
  CONSTRAINT `order_table_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `User` (`user_id`),
  CONSTRAINT `order_table_ibfk_2` FOREIGN KEY (`package_id`) REFERENCES `Paket` (`package_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Order_Table`
--

LOCK TABLES `Order_Table` WRITE;
/*!40000 ALTER TABLE `Order_Table` DISABLE KEYS */;
/*!40000 ALTER TABLE `Order_Table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Paket`
--

DROP TABLE IF EXISTS `Paket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Paket` (
  `package_id` int NOT NULL AUTO_INCREMENT,
  `package_name` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `duration` int NOT NULL,
  PRIMARY KEY (`package_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Paket`
--

LOCK TABLES `Paket` WRITE;
/*!40000 ALTER TABLE `Paket` DISABLE KEYS */;
/*!40000 ALTER TABLE `Paket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Pembayaran`
--

DROP TABLE IF EXISTS `Pembayaran`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Pembayaran` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `payment_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `amount` decimal(10,2) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `Order_Table` (`order_id`),
  CONSTRAINT `pembayaran_chk_1` CHECK ((`status` in (_utf8mb4'Completed',_utf8mb4'Pending')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Pembayaran`
--

LOCK TABLES `Pembayaran` WRITE;
/*!40000 ALTER TABLE `Pembayaran` DISABLE KEYS */;
/*!40000 ALTER TABLE `Pembayaran` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `fullname` varchar(100) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `token` varchar(100) NOT NULL,
  `is_verified` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (1,'Akbar Mahendra','Akbar','$2b$10$s57ogSVIcsU2g40CiF7pyu3UgoX9rvzBt2QGN0r2mm6hyLOTER4Hy','akbar@dummyemail.co.id','2024-11-24 09:44:16','2024-11-30 15:51:23','',0),(2,'Yani Putri','Yani','$2b$10$ZLCEUbkafk3jFo6f69YuR.tGQQetsfXVABRJ5gGVF0ks8hwBZ0Kt6','yani@dummyemail.co.id','2024-11-24 10:31:29','2024-11-30 17:08:00','',0),(3,'Setiawan Wawan','Setiawan','$2b$10$jsMgnmcfCvscOtdBgmaa9O3oipajbA91w/Z66arwodwLB0JpFeI5K','setiawan@dummyemail.co.id','2024-11-24 14:44:29','2024-11-30 17:08:24','',0),(7,'Rahmat Wijaya','Rahmat','$2b$10$Nbt4pgjmhrCbS20gSDi9OO5MPnWR4sft3Op389upjVf/h2.q7Mg/m','rahmat@dummyemail.co.id','2024-11-24 18:30:51','2024-11-30 17:09:02','',0),(10,'John Michael','John','$2b$10$WHW6w.vO8WzJIfyOxvMQl.LWKeBI5cV8ZZkLACkA.kQQKHCOqODXi','john@dummyemail.co.id','2024-11-24 19:06:58','2024-11-30 17:09:24','',0),(12,'Jaya Wijaya','Jaya','$2b$10$nOI6ymIe2O78xHNaCwobguj4n4X9JMrX.GEEMvRJe2FECPiTufC.m','jaya@dummyemail.co.id','2024-11-24 19:29:55','2024-11-30 17:09:41','',0),(13,'Andi Sanjaya','Andi','$2b$10$094435Cp0Yqg.pS0cBN0j.6.iOpm0vbCGGfyh4/VQMmEybLP9d0GW','andi@dummyemail.co.id','2024-11-30 17:32:18','2024-11-30 17:32:18','',0),(14,'Vivi Candra','Vivi','$2b$10$7fopwqr7C6rKomEUuxIW2udPcJcGfSwbY8owUMbVlrzSNhq.54XeW','vicadi9944@kindomd.com','2024-12-01 09:18:34','2024-12-01 09:18:34','e784939c-c004-4071-bb2a-4ce49a1626f4',0),(15,'Vivi Candra','Vivi','$2b$10$u63//A6rytDk.kD3D/DV9OkXjX1mhgJ7XgqrJY6j0Zu77miLJVxfm','vicadi9944@kindomd.com','2024-12-01 09:18:44','2024-12-01 09:18:44','8f3dfa3e-5987-47f0-bc20-714985a08f5d',0),(16,'Hadi Sonic','Hadi','$2b$10$w12mPJLbwG4SZhqAao3k/emHe194zslZZGZm9vnYmoQEJlqH6A8WS','hdnsicoynphzubqkcl@nbmbb.com','2024-12-01 09:20:43','2024-12-01 09:20:43','0d33d0d1-bad4-4835-9d9c-d278855fae1b',0),(17,'Seros Hunter','Seros','$2b$10$LPr107q60O0gfoOG70LdJOEpUHsxibyOsJPLZhdzFb.oF9rEm54Xe','seros75573@tignee.com','2024-12-01 09:24:09','2024-12-01 09:24:09','17d23411-e236-4fe9-8b16-8508ae40c788',0);
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'chillmovie_database'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-01 17:07:40
