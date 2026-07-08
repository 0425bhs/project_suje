-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: suje
-- ------------------------------------------------------
-- Server version	9.7.0

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `address_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `address_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `recipient_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `zipcode` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `detail_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_default` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`address_id`),
  KEY `fk_addresses_user` (`user_id`),
  CONSTRAINT `fk_addresses_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,1,'기본 배송지','홍길동','010-1234-5678','12345','서울시 강남구','101동 1001호','1'),(2,13,'우리집','이상훈','01023950851','11921','우리집','우리집','true'),(3,9,'친구집','오길동','01012345555','13524','경기 성남시 분당구 대왕판교로606번길 45','5층','false'),(4,9,'회사','배송지','01020345877','34603','대전 동구 계족로 285','22호','true');
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_action_logs`
--

DROP TABLE IF EXISTS `admin_action_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_action_logs` (
  `log_id` bigint NOT NULL AUTO_INCREMENT,
  `admin_id` bigint DEFAULT NULL,
  `target_type` varchar(30) NOT NULL,
  `target_id` bigint NOT NULL,
  `action_type` varchar(50) NOT NULL,
  `before_status` varchar(50) DEFAULT NULL,
  `after_status` varchar(50) DEFAULT NULL,
  `memo` varchar(500) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `idx_admin_action_logs_target` (`target_type`,`target_id`),
  KEY `idx_admin_action_logs_created_at` (`created_at`),
  KEY `idx_admin_action_logs_admin` (`admin_id`),
  CONSTRAINT `fk_admin_action_logs_admin` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_action_logs`
--

LOCK TABLES `admin_action_logs` WRITE;
/*!40000 ALTER TABLE `admin_action_logs` DISABLE KEYS */;
INSERT INTO `admin_action_logs` VALUES (1,75,'SELLER',27,'STATUS_CHANGE','APPROVED','PENDING','판매자 상태 변경','2026-07-06 07:19:47'),(2,75,'SELLER',27,'STATUS_CHANGE','PENDING','APPROVED','판매자 상태 변경','2026-07-06 07:19:56'),(3,75,'MEMBER',40,'STATUS_CHANGE','active','suspended','회원 상태 변경','2026-07-06 07:34:32'),(4,75,'MEMBER',40,'STATUS_CHANGE','suspended','active','회원 상태 변경','2026-07-06 07:34:57'),(5,75,'MEMBER',40,'STATUS_CHANGE','active','suspended','회원 상태 변경','2026-07-06 07:37:02'),(6,75,'MEMBER',40,'STATUS_CHANGE','suspended','withdrawn','회원 상태 변경','2026-07-06 07:37:09'),(7,75,'MEMBER',40,'STATUS_CHANGE','withdrawn','active','회원 상태 변경','2026-07-06 07:37:16'),(8,75,'PRODUCT',798,'STATUS_CHANGE','APPROVED','PENDING','상품 상태 변경','2026-07-06 07:37:31'),(9,75,'PRODUCT',798,'STATUS_CHANGE','PENDING','APPROVED','상품 상태 변경','2026-07-06 07:37:37');
/*!40000 ALTER TABLE `admin_action_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_memos`
--

DROP TABLE IF EXISTS `admin_memos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_memos` (
  `memo_id` bigint NOT NULL AUTO_INCREMENT,
  `target_type` varchar(30) NOT NULL,
  `target_id` bigint NOT NULL,
  `admin_id` bigint DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`memo_id`),
  UNIQUE KEY `uq_admin_memo_target` (`target_type`,`target_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_memos`
--

LOCK TABLES `admin_memos` WRITE;
/*!40000 ALTER TABLE `admin_memos` DISABLE KEYS */;
/*!40000 ALTER TABLE `admin_memos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `cart_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `option_id` bigint DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`cart_id`),
  UNIQUE KEY `uq_cart_user_product_option` (`user_id`,`product_id`,`option_id`),
  KEY `fk_cart_items_product` (`product_id`),
  KEY `idx_cart_items_user_id` (`user_id`),
  KEY `idx_cart_items_product_id` (`product_id`),
  KEY `idx_cart_items_option_id` (`option_id`),
  CONSTRAINT `fk_cart_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cart_items_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `parent_id` bigint DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  KEY `fk_categories_parent` (`parent_id`),
  CONSTRAINT `fk_categories_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'패션/주얼리',NULL),(2,'홈리빙',NULL),(3,'뷰티',NULL),(4,'식품',NULL),(5,'공예',NULL),(6,'반려동물',NULL),(7,'주얼리',1),(8,'모자/스카프',1),(9,'아이웨어',1),(10,'기타',1),(11,'조명',2),(12,'생활용품',2),(13,'인테리어 소품',2),(14,'가구',2),(15,'틴트/립스틱',3),(16,'베이스 메이크업',3),(17,'아이 메이크업',3),(18,'기타',3),(19,'식단관리',4),(20,'초콜릿/젤리/캔디',4),(21,'간편식',4),(22,'베이커리',4),(23,'비누',5),(24,'향수',5),(25,'도자기',5),(26,'키링',5),(27,'의류/악세사리',6),(28,'사료/간식',6),(29,'산책용품',6),(30,'장난감',6),(31,'캔들',5),(32,'차/티',4),(33,'식물/화분',2),(34,'꽃/플라워',2),(35,'선물세트',5),(36,'문구',5),(37,'스티커',5),(38,'패브릭/가방',1);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupons`
--

DROP TABLE IF EXISTS `coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupons` (
  `coupon_id` bigint NOT NULL AUTO_INCREMENT,
  `coupon_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `discount_amount` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`coupon_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupons`
--

LOCK TABLES `coupons` WRITE;
/*!40000 ALTER TABLE `coupons` DISABLE KEYS */;
INSERT INTO `coupons` VALUES (1,'작가샵 첫 찜 쿠폰',500,'2026-06-29 03:05:57');
/*!40000 ALTER TABLE `coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites`
--

DROP TABLE IF EXISTS `favorites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites` (
  `favorite_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`favorite_id`),
  UNIQUE KEY `uq_favorites_user_product` (`user_id`,`product_id`),
  KEY `fk_favorites_product` (`product_id`),
  CONSTRAINT `fk_favorites_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_favorites_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites`
--

LOCK TABLES `favorites` WRITE;
/*!40000 ALTER TABLE `favorites` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favorites_seller`
--

DROP TABLE IF EXISTS `favorites_seller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favorites_seller` (
  `seller_favorite_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `seller_id` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`seller_favorite_id`),
  UNIQUE KEY `uk_seller_favorite` (`user_id`,`seller_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favorites_seller`
--

LOCK TABLES `favorites_seller` WRITE;
/*!40000 ALTER TABLE `favorites_seller` DISABLE KEYS */;
/*!40000 ALTER TABLE `favorites_seller` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `images`
--

DROP TABLE IF EXISTS `images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `images` (
  `image_id` int NOT NULL AUTO_INCREMENT,
  `target_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `target_id` int NOT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `sort_order` int DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`image_id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `images`
--

LOCK TABLES `images` WRITE;
/*!40000 ALTER TABLE `images` DISABLE KEYS */;
/*!40000 ALTER TABLE `images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inquiries`
--

DROP TABLE IF EXISTS `inquiries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inquiries` (
  `inquiry_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `inquiry_type` enum('SERVICE','ACCOUNT','PAYMENT','SELLER','POLICY','ETC') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ETC',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `status` enum('WAITING','ANSWERED') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'WAITING',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `answered_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`inquiry_id`),
  KEY `fk_inquiries_user` (`user_id`),
  CONSTRAINT `fk_inquiries_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inquiries`
--

LOCK TABLES `inquiries` WRITE;
/*!40000 ALTER TABLE `inquiries` DISABLE KEYS */;
/*!40000 ALTER TABLE `inquiries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notices`
--

DROP TABLE IF EXISTS `notices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notices` (
  `notice_id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`notice_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notices`
--

LOCK TABLES `notices` WRITE;
/*!40000 ALTER TABLE `notices` DISABLE KEYS */;
/*!40000 ALTER TABLE `notices` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item_claims`
--

DROP TABLE IF EXISTS `order_item_claims`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item_claims` (
  `claim_id` bigint NOT NULL AUTO_INCREMENT,
  `order_item_id` bigint NOT NULL,
  `status` varchar(30) NOT NULL,
  `reason` varchar(500) NOT NULL,
  `seller_answer` varchar(500) DEFAULT NULL,
  `requested_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `completed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `detail_reason` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`claim_id`),
  KEY `fk_order_item_claims_order_item` (`order_item_id`),
  CONSTRAINT `fk_order_item_claims_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`order_item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item_claims`
--

LOCK TABLES `order_item_claims` WRITE;
/*!40000 ALTER TABLE `order_item_claims` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_item_claims` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `order_item_id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `price` int NOT NULL,
  `quantity` int NOT NULL,
  `option_id` int DEFAULT NULL,
  `option_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `option_price` int NOT NULL DEFAULT '0',
  `confirmed_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_item_id`),
  KEY `fk_order_items_order` (`order_id`),
  KEY `fk_order_items_product` (`product_id`),
  CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
INSERT INTO `order_items` VALUES (74,67,808,12000,1,NULL,NULL,0,NULL,'2026-07-08 11:12:49'),(75,68,807,23000,10,NULL,NULL,0,NULL,'2026-07-08 11:13:45'),(76,1001,799,15000,2,NULL,NULL,0,'2026-06-10 10:00:00','2026-06-10 10:00:00'),(77,1001,808,12000,1,NULL,NULL,0,'2026-06-10 10:00:00','2026-06-10 10:00:00'),(78,1002,803,24000,1,NULL,NULL,0,'2026-06-12 10:00:00','2026-06-12 10:00:00'),(79,1003,804,21000,2,NULL,NULL,0,'2026-06-15 10:00:00','2026-06-15 10:00:00'),(80,1004,806,14500,2,NULL,NULL,0,'2026-06-17 10:00:00','2026-06-17 10:00:00'),(81,1004,808,12000,1,NULL,NULL,0,'2026-06-17 10:00:00','2026-06-17 10:00:00'),(82,1005,802,18000,2,NULL,NULL,0,'2026-06-20 10:00:00','2026-06-20 10:00:00'),(83,1005,804,21000,1,NULL,NULL,0,'2026-06-20 10:00:00','2026-06-20 10:00:00'),(84,1006,802,18000,1,NULL,NULL,0,'2026-06-23 10:00:00','2026-06-23 10:00:00'),(85,1007,807,23000,1,NULL,NULL,0,'2026-06-26 10:00:00','2026-06-26 10:00:00'),(86,1007,803,24000,1,NULL,NULL,0,'2026-06-26 10:00:00','2026-06-26 10:00:00'),(87,1008,799,15000,2,NULL,NULL,0,'2026-06-29 10:00:00','2026-06-29 10:00:00'),(88,1009,808,12000,1,NULL,NULL,0,'2026-07-03 10:00:00','2026-07-03 10:00:00'),(89,1009,806,14500,1,NULL,NULL,0,'2026-07-03 10:00:00','2026-07-03 10:00:00'),(90,1009,799,15000,1,NULL,NULL,0,'2026-07-03 10:00:00','2026-07-03 10:00:00'),(91,1010,804,21000,1,NULL,NULL,0,'2026-07-06 10:00:00','2026-07-06 10:00:00'),(92,1010,807,23000,1,NULL,NULL,0,'2026-07-06 10:00:00','2026-07-06 10:00:00'),(93,1010,802,18000,1,NULL,NULL,0,'2026-07-06 10:00:00','2026-07-06 10:00:00'),(94,6001,807,98000,1,NULL,NULL,0,'2026-06-01 09:41:00','2026-06-01 09:41:00'),(95,6002,802,124000,1,NULL,NULL,0,'2026-06-02 10:05:00','2026-06-02 10:05:00'),(96,6003,804,87000,1,NULL,NULL,0,'2026-06-03 19:12:00','2026-06-03 19:12:00'),(97,6004,808,156000,1,NULL,NULL,0,'2026-06-04 20:18:00','2026-06-04 20:18:00'),(98,6005,799,211000,1,NULL,NULL,0,'2026-06-05 11:34:00','2026-06-05 11:34:00'),(99,6006,803,278000,1,NULL,NULL,0,'2026-06-06 14:27:00','2026-06-06 14:27:00'),(100,6007,806,241000,1,NULL,NULL,0,'2026-06-07 21:05:00','2026-06-07 21:05:00'),(101,6008,805,133000,1,NULL,NULL,0,'2026-06-08 13:34:00','2026-06-08 13:34:00'),(102,6009,800,118000,1,NULL,NULL,0,'2026-06-09 20:18:00','2026-06-09 20:18:00'),(103,6010,807,174000,1,NULL,NULL,0,'2026-06-10 18:41:00','2026-06-10 18:41:00'),(104,6011,804,205000,1,NULL,NULL,0,'2026-06-11 10:12:00','2026-06-11 10:12:00'),(105,6012,801,182000,1,NULL,NULL,0,'2026-06-12 11:12:00','2026-06-12 11:12:00'),(106,6013,807,315000,1,NULL,NULL,0,'2026-06-13 14:18:00','2026-06-13 14:18:00'),(107,6014,803,289000,1,NULL,NULL,0,'2026-06-14 13:05:00','2026-06-14 13:05:00'),(108,6015,806,142000,1,NULL,NULL,0,'2026-06-15 13:41:00','2026-06-15 13:41:00'),(109,6016,802,168000,1,NULL,NULL,0,'2026-06-16 17:41:00','2026-06-16 17:41:00'),(110,6017,808,127000,1,NULL,NULL,0,'2026-06-17 13:18:00','2026-06-17 13:18:00'),(111,6018,799,196000,1,NULL,NULL,0,'2026-06-18 17:41:00','2026-06-18 17:41:00'),(112,6019,804,248000,1,NULL,NULL,0,'2026-06-19 21:34:00','2026-06-19 21:34:00'),(113,6020,807,332000,1,NULL,NULL,0,'2026-06-20 19:34:00','2026-06-20 19:34:00'),(114,6021,803,301000,1,NULL,NULL,0,'2026-06-21 16:27:00','2026-06-21 16:27:00'),(115,6022,805,154000,1,NULL,NULL,0,'2026-06-22 09:27:00','2026-06-22 09:27:00'),(116,6023,800,139000,1,NULL,NULL,0,'2026-06-23 11:18:00','2026-06-23 11:18:00'),(117,6024,802,183000,1,NULL,NULL,0,'2026-06-24 10:27:00','2026-06-24 10:27:00'),(118,6025,804,221000,1,NULL,NULL,0,'2026-06-25 12:05:00','2026-06-25 12:05:00'),(119,6026,806,205000,1,NULL,NULL,0,'2026-06-26 15:41:00','2026-06-26 15:41:00'),(120,6027,807,348000,1,NULL,NULL,0,'2026-06-27 20:18:00','2026-06-27 20:18:00'),(121,6028,803,286000,1,NULL,NULL,0,'2026-06-28 21:34:00','2026-06-28 21:34:00'),(122,6029,799,171000,1,NULL,NULL,0,'2026-06-29 17:18:00','2026-06-29 17:18:00'),(123,6030,804,234000,1,NULL,NULL,0,'2026-06-30 09:41:00','2026-06-30 09:41:00'),(125,6031,809,20000,1,NULL,NULL,0,'2026-07-04 22:19:23','2026-07-04 22:19:23'),(126,6032,819,28000,1,NULL,NULL,0,'2026-07-02 03:25:02','2026-07-02 03:25:02'),(127,6033,829,22000,1,NULL,NULL,0,'2026-07-03 22:05:53','2026-07-03 22:05:53'),(128,6034,841,12000,1,NULL,NULL,0,'2026-07-05 19:32:29','2026-07-05 19:32:29'),(129,6035,849,24000,1,NULL,NULL,0,'2026-07-04 12:21:17','2026-07-04 12:21:17'),(130,6036,860,8000,1,NULL,NULL,0,'2026-07-07 22:22:31','2026-07-07 22:22:31'),(131,6037,869,15000,1,NULL,NULL,0,'2026-07-07 20:23:03','2026-07-07 20:23:03'),(132,6038,879,19000,1,NULL,NULL,0,'2026-07-04 19:30:07','2026-07-04 19:30:07'),(133,6039,889,12000,1,NULL,NULL,0,'2026-07-01 23:50:31','2026-07-01 23:50:31'),(134,6040,899,12000,1,NULL,NULL,0,'2026-07-07 05:06:40','2026-07-07 05:06:40'),(135,6041,909,15000,1,NULL,NULL,0,'2026-07-05 03:04:04','2026-07-05 03:04:04'),(136,6042,929,24000,1,NULL,NULL,0,'2026-07-04 06:37:31','2026-07-04 06:37:31'),(137,6043,939,15000,1,NULL,NULL,0,'2026-07-04 18:10:46','2026-07-04 18:10:46'),(138,6044,949,12000,1,NULL,NULL,0,'2026-07-06 14:28:42','2026-07-06 14:28:42'),(139,6045,959,28000,1,NULL,NULL,0,'2026-07-04 00:07:22','2026-07-04 00:07:22'),(140,6046,969,3000,1,NULL,NULL,0,'2026-07-02 15:52:57','2026-07-02 15:52:57'),(141,6047,979,2500,1,NULL,NULL,0,'2026-07-05 14:48:41','2026-07-05 14:48:41'),(142,6048,989,13000,1,NULL,NULL,0,'2026-07-06 21:15:20','2026-07-06 21:15:20'),(143,6049,815,28000,1,NULL,NULL,0,'2026-07-07 20:57:31','2026-07-07 20:57:31'),(144,6050,834,31000,1,NULL,NULL,0,'2026-07-07 18:53:58','2026-07-07 18:53:58');
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `total_amount` int NOT NULL,
  `used_point` int DEFAULT '0',
  `address_id` bigint DEFAULT NULL,
  `status` enum('PENDING','PAID','PREPARING','SHIPPING','DELIVERED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cancel_reason` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `user_coupon_id` int DEFAULT '0',
  PRIMARY KEY (`order_id`),
  KEY `fk_orders_user` (`user_id`),
  KEY `fk_orders_address` (`address_id`),
  CONSTRAINT `fk_orders_address` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`address_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6051 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (67,13,15000,0,2,'PAID','2026-07-08 02:12:49','2026-07-08 02:13:24',NULL,NULL,0),(68,13,233000,0,2,'PAID','2026-07-08 02:13:45','2026-07-08 02:14:18',NULL,NULL,0),(1001,40,36000,0,NULL,'DELIVERED','2026-06-08 01:12:00','2026-06-08 01:12:00',NULL,NULL,0),(1002,41,24000,0,NULL,'DELIVERED','2026-06-10 05:30:00','2026-06-10 05:30:00',NULL,NULL,0),(1003,42,42000,0,NULL,'DELIVERED','2026-06-13 00:20:00','2026-06-13 00:20:00',NULL,NULL,0),(1004,43,33000,0,NULL,'DELIVERED','2026-06-15 09:45:00','2026-06-15 09:45:00',NULL,NULL,0),(1005,44,57000,0,NULL,'DELIVERED','2026-06-18 02:05:00','2026-06-18 02:05:00',NULL,NULL,0),(1006,45,18000,0,NULL,'DELIVERED','2026-06-21 07:10:00','2026-06-21 07:10:00',NULL,NULL,0),(1007,46,47000,0,NULL,'DELIVERED','2026-06-24 04:25:00','2026-06-24 04:25:00',NULL,NULL,0),(1008,47,30000,0,NULL,'DELIVERED','2026-06-27 11:15:00','2026-06-27 11:15:00',NULL,NULL,0),(1009,48,39000,0,NULL,'DELIVERED','2026-07-01 03:40:00','2026-07-01 03:40:00',NULL,NULL,0),(1010,49,65000,0,NULL,'DELIVERED','2026-07-04 06:55:00','2026-07-04 06:55:00',NULL,NULL,0),(6001,40,98000,0,NULL,'DELIVERED','2026-06-01 00:41:00','2026-06-01 00:41:00',NULL,NULL,0),(6002,41,124000,0,NULL,'DELIVERED','2026-06-02 01:05:00','2026-06-02 01:05:00',NULL,NULL,0),(6003,42,87000,0,NULL,'DELIVERED','2026-06-03 10:12:00','2026-06-03 10:12:00',NULL,NULL,0),(6004,43,156000,0,NULL,'DELIVERED','2026-06-04 11:18:00','2026-06-04 11:18:00',NULL,NULL,0),(6005,44,211000,0,NULL,'DELIVERED','2026-06-05 02:34:00','2026-06-05 02:34:00',NULL,NULL,0),(6006,45,278000,0,NULL,'DELIVERED','2026-06-06 05:27:00','2026-06-06 05:27:00',NULL,NULL,0),(6007,46,241000,0,NULL,'DELIVERED','2026-06-07 12:05:00','2026-06-07 12:05:00',NULL,NULL,0),(6008,47,133000,0,NULL,'DELIVERED','2026-06-08 04:34:00','2026-06-08 04:34:00',NULL,NULL,0),(6009,48,118000,0,NULL,'DELIVERED','2026-06-09 11:18:00','2026-06-09 11:18:00',NULL,NULL,0),(6010,49,174000,0,NULL,'DELIVERED','2026-06-10 09:41:00','2026-06-10 09:41:00',NULL,NULL,0),(6011,50,205000,0,NULL,'DELIVERED','2026-06-11 01:12:00','2026-06-11 01:12:00',NULL,NULL,0),(6012,51,182000,0,NULL,'DELIVERED','2026-06-12 02:12:00','2026-06-12 02:12:00',NULL,NULL,0),(6013,52,315000,0,NULL,'DELIVERED','2026-06-13 05:18:00','2026-06-13 05:18:00',NULL,NULL,0),(6014,53,289000,0,NULL,'DELIVERED','2026-06-14 04:05:00','2026-06-14 04:05:00',NULL,NULL,0),(6015,54,142000,0,NULL,'DELIVERED','2026-06-15 04:41:00','2026-06-15 04:41:00',NULL,NULL,0),(6016,55,168000,0,NULL,'DELIVERED','2026-06-16 08:41:00','2026-06-16 08:41:00',NULL,NULL,0),(6017,56,127000,0,NULL,'DELIVERED','2026-06-17 04:18:00','2026-06-17 04:18:00',NULL,NULL,0),(6018,57,196000,0,NULL,'DELIVERED','2026-06-18 08:41:00','2026-06-18 08:41:00',NULL,NULL,0),(6019,58,248000,0,NULL,'DELIVERED','2026-06-19 12:34:00','2026-06-19 12:34:00',NULL,NULL,0),(6020,59,332000,0,NULL,'DELIVERED','2026-06-20 10:34:00','2026-06-20 10:34:00',NULL,NULL,0),(6021,60,301000,0,NULL,'DELIVERED','2026-06-21 07:27:00','2026-06-21 07:27:00',NULL,NULL,0),(6022,61,154000,0,NULL,'DELIVERED','2026-06-22 00:27:00','2026-06-22 00:27:00',NULL,NULL,0),(6023,62,139000,0,NULL,'DELIVERED','2026-06-23 02:18:00','2026-06-23 02:18:00',NULL,NULL,0),(6024,63,183000,0,NULL,'DELIVERED','2026-06-24 01:27:00','2026-06-24 01:27:00',NULL,NULL,0),(6025,64,221000,0,NULL,'DELIVERED','2026-06-25 03:05:00','2026-06-25 03:05:00',NULL,NULL,0),(6026,65,205000,0,NULL,'DELIVERED','2026-06-26 06:41:00','2026-06-26 06:41:00',NULL,NULL,0),(6027,66,348000,0,NULL,'DELIVERED','2026-06-27 11:18:00','2026-06-27 11:18:00',NULL,NULL,0),(6028,67,286000,0,NULL,'DELIVERED','2026-06-28 12:34:00','2026-06-28 12:34:00',NULL,NULL,0),(6029,68,171000,0,NULL,'DELIVERED','2026-06-29 08:18:00','2026-06-29 08:18:00',NULL,NULL,0),(6030,69,234000,0,NULL,'DELIVERED','2026-06-30 00:41:00','2026-06-30 00:41:00',NULL,NULL,0),(6031,70,20000,0,NULL,'DELIVERED','2026-07-04 13:19:23','2026-07-04 13:19:23',NULL,NULL,0),(6032,71,28000,0,NULL,'DELIVERED','2026-07-01 18:25:02','2026-07-01 18:25:02',NULL,NULL,0),(6033,72,22000,0,NULL,'DELIVERED','2026-07-03 13:05:53','2026-07-03 13:05:53',NULL,NULL,0),(6034,73,12000,0,NULL,'DELIVERED','2026-07-05 10:32:29','2026-07-05 10:32:29',NULL,NULL,0),(6035,74,24000,0,NULL,'DELIVERED','2026-07-04 03:21:17','2026-07-04 03:21:17',NULL,NULL,0),(6036,2,8000,0,NULL,'DELIVERED','2026-07-07 13:22:31','2026-07-07 13:22:31',NULL,NULL,0),(6037,4,15000,0,NULL,'DELIVERED','2026-07-07 11:23:03','2026-07-07 11:23:03',NULL,NULL,0),(6038,6,19000,0,NULL,'DELIVERED','2026-07-04 10:30:07','2026-07-04 10:30:07',NULL,NULL,0),(6039,7,12000,0,NULL,'DELIVERED','2026-07-01 14:50:31','2026-07-01 14:50:31',NULL,NULL,0),(6040,8,12000,0,NULL,'DELIVERED','2026-07-06 20:06:40','2026-07-06 20:06:40',NULL,NULL,0),(6041,9,15000,0,NULL,'DELIVERED','2026-07-04 18:04:04','2026-07-04 18:04:04',NULL,NULL,0),(6042,10,24000,0,NULL,'DELIVERED','2026-07-03 21:37:31','2026-07-03 21:37:31',NULL,NULL,0),(6043,11,15000,0,NULL,'DELIVERED','2026-07-04 09:10:46','2026-07-04 09:10:46',NULL,NULL,0),(6044,13,12000,0,NULL,'DELIVERED','2026-07-06 05:28:42','2026-07-06 05:28:42',NULL,NULL,0),(6045,40,28000,0,NULL,'DELIVERED','2026-07-03 15:07:22','2026-07-03 15:07:22',NULL,NULL,0),(6046,55,3000,0,NULL,'DELIVERED','2026-07-02 06:52:57','2026-07-02 06:52:57',NULL,NULL,0),(6047,62,2500,0,NULL,'DELIVERED','2026-07-05 05:48:41','2026-07-05 05:48:41',NULL,NULL,0),(6048,48,13000,0,NULL,'DELIVERED','2026-07-06 12:15:20','2026-07-06 12:15:20',NULL,NULL,0),(6049,51,28000,0,NULL,'DELIVERED','2026-07-07 11:57:31','2026-07-07 11:57:31',NULL,NULL,0),(6050,66,31000,0,NULL,'DELIVERED','2026-07-07 09:53:58','2026-07-07 09:53:58',NULL,NULL,0);
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `payment_method` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `amount` int NOT NULL,
  `status` enum('READY','SUCCESS','FAIL','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'READY',
  `transaction_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `fk_payments_order` (`order_id`),
  CONSTRAINT `fk_payments_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=67 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (24,67,'TOSS',15000,'SUCCESS','tviva20260708111251KEi51','2026-07-08 02:12:49'),(25,68,'TOSS',233000,'SUCCESS','tviva20260708111346NLxJ9','2026-07-08 02:13:45'),(26,1001,'CARD',36000,'SUCCESS','TEST-DALBIT-1001','2026-06-08 01:12:00'),(27,1002,'CARD',24000,'SUCCESS','TEST-DALBIT-1002','2026-06-10 05:30:00'),(28,1003,'KAKAO_PAY',42000,'SUCCESS','TEST-DALBIT-1003','2026-06-13 00:20:00'),(29,1004,'CARD',33000,'SUCCESS','TEST-DALBIT-1004','2026-06-15 09:45:00'),(30,1005,'KAKAO_PAY',57000,'SUCCESS','TEST-DALBIT-1005','2026-06-18 02:05:00'),(31,1006,'CARD',18000,'SUCCESS','TEST-DALBIT-1006','2026-06-21 07:10:00'),(32,1007,'CARD',47000,'SUCCESS','TEST-DALBIT-1007','2026-06-24 04:25:00'),(33,1008,'KAKAO_PAY',30000,'SUCCESS','TEST-DALBIT-1008','2026-06-27 11:15:00'),(34,1009,'CARD',39000,'SUCCESS','TEST-DALBIT-1009','2026-07-01 03:40:00'),(35,1010,'KAKAO_PAY',65000,'SUCCESS','TEST-DALBIT-1010','2026-07-04 06:55:00'),(36,6001,'CARD',98000,'SUCCESS','TEST-DALBIT-JUN-6001','2026-06-01 00:41:00'),(37,6002,'CARD',124000,'SUCCESS','TEST-DALBIT-JUN-6002','2026-06-02 01:05:00'),(38,6003,'CARD',87000,'SUCCESS','TEST-DALBIT-JUN-6003','2026-06-03 10:12:00'),(39,6004,'CARD',156000,'SUCCESS','TEST-DALBIT-JUN-6004','2026-06-04 11:18:00'),(40,6005,'CARD',211000,'SUCCESS','TEST-DALBIT-JUN-6005','2026-06-05 02:34:00'),(41,6006,'CARD',278000,'SUCCESS','TEST-DALBIT-JUN-6006','2026-06-06 05:27:00'),(42,6007,'CARD',241000,'SUCCESS','TEST-DALBIT-JUN-6007','2026-06-07 12:05:00'),(43,6008,'CARD',133000,'SUCCESS','TEST-DALBIT-JUN-6008','2026-06-08 04:34:00'),(44,6009,'CARD',118000,'SUCCESS','TEST-DALBIT-JUN-6009','2026-06-09 11:18:00'),(45,6010,'CARD',174000,'SUCCESS','TEST-DALBIT-JUN-6010','2026-06-10 09:41:00'),(46,6011,'CARD',205000,'SUCCESS','TEST-DALBIT-JUN-6011','2026-06-11 01:12:00'),(47,6012,'CARD',182000,'SUCCESS','TEST-DALBIT-JUN-6012','2026-06-12 02:12:00'),(48,6013,'CARD',315000,'SUCCESS','TEST-DALBIT-JUN-6013','2026-06-13 05:18:00'),(49,6014,'CARD',289000,'SUCCESS','TEST-DALBIT-JUN-6014','2026-06-14 04:05:00'),(50,6015,'CARD',142000,'SUCCESS','TEST-DALBIT-JUN-6015','2026-06-15 04:41:00'),(51,6016,'CARD',168000,'SUCCESS','TEST-DALBIT-JUN-6016','2026-06-16 08:41:00'),(52,6017,'CARD',127000,'SUCCESS','TEST-DALBIT-JUN-6017','2026-06-17 04:18:00'),(53,6018,'CARD',196000,'SUCCESS','TEST-DALBIT-JUN-6018','2026-06-18 08:41:00'),(54,6019,'CARD',248000,'SUCCESS','TEST-DALBIT-JUN-6019','2026-06-19 12:34:00'),(55,6020,'CARD',332000,'SUCCESS','TEST-DALBIT-JUN-6020','2026-06-20 10:34:00'),(56,6021,'CARD',301000,'SUCCESS','TEST-DALBIT-JUN-6021','2026-06-21 07:27:00'),(57,6022,'CARD',154000,'SUCCESS','TEST-DALBIT-JUN-6022','2026-06-22 00:27:00'),(58,6023,'CARD',139000,'SUCCESS','TEST-DALBIT-JUN-6023','2026-06-23 02:18:00'),(59,6024,'CARD',183000,'SUCCESS','TEST-DALBIT-JUN-6024','2026-06-24 01:27:00'),(60,6025,'CARD',221000,'SUCCESS','TEST-DALBIT-JUN-6025','2026-06-25 03:05:00'),(61,6026,'CARD',205000,'SUCCESS','TEST-DALBIT-JUN-6026','2026-06-26 06:41:00'),(62,6027,'CARD',348000,'SUCCESS','TEST-DALBIT-JUN-6027','2026-06-27 11:18:00'),(63,6028,'CARD',286000,'SUCCESS','TEST-DALBIT-JUN-6028','2026-06-28 12:34:00'),(64,6029,'CARD',171000,'SUCCESS','TEST-DALBIT-JUN-6029','2026-06-29 08:18:00'),(65,6030,'CARD',234000,'SUCCESS','TEST-DALBIT-JUN-6030','2026-06-30 00:41:00');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `point_history`
--

DROP TABLE IF EXISTS `point_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `point_history` (
  `point_history_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `order_id` bigint DEFAULT NULL,
  `order_item_id` bigint NOT NULL,
  `point_amount` int NOT NULL,
  `type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`point_history_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `point_history`
--

LOCK TABLES `point_history` WRITE;
/*!40000 ALTER TABLE `point_history` DISABLE KEYS */;
INSERT INTO `point_history` VALUES (1,13,NULL,24,37036,'EARN','2026-06-29 07:21:27'),(2,13,18,0,3000,'USE','2026-06-29 07:28:09'),(3,13,19,0,1000,'USE','2026-06-29 07:30:45');
/*!40000 ALTER TABLE `point_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_options`
--

DROP TABLE IF EXISTS `product_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_options` (
  `option_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `option_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `option_price` int NOT NULL DEFAULT '0',
  `option_stock` int NOT NULL DEFAULT '0',
  `sort_order` int NOT NULL DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`option_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_options`
--

LOCK TABLES `product_options` WRITE;
/*!40000 ALTER TABLE `product_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_options` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_view_log`
--

DROP TABLE IF EXISTS `product_view_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_view_log` (
  `view_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `category_id` int NOT NULL,
  `viewed_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`view_id`)
) ENGINE=InnoDB AUTO_INCREMENT=172 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_view_log`
--

LOCK TABLES `product_view_log` WRITE;
/*!40000 ALTER TABLE `product_view_log` DISABLE KEYS */;
INSERT INTO `product_view_log` VALUES (169,13,808,7,'2026-07-08 11:12:40'),(170,13,807,7,'2026-07-08 11:13:40'),(171,9,916,33,'2026-07-08 13:03:47');
/*!40000 ALTER TABLE `product_view_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` bigint NOT NULL AUTO_INCREMENT,
  `seller_id` bigint NOT NULL,
  `category_id` bigint DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `price` int NOT NULL,
  `sale_price` int NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `delivery_fee` int NOT NULL DEFAULT '0',
  `status` enum('PENDING','APPROVED','REJECTED','HIDDEN') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDING',
  `image_l` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `free_shipping` int NOT NULL DEFAULT '0',
  `sale_price_updated_at` datetime DEFAULT NULL,
  `sale_start_at` datetime DEFAULT NULL,
  `sale_end_at` datetime DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  KEY `fk_products_seller` (`seller_id`),
  KEY `fk_products_category` (`category_id`),
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_products_seller` FOREIGN KEY (`seller_id`) REFERENCES `sellers` (`seller_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=999 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (799,28,7,'담수 진주 귀걸이','은은한 광택의 담수 진주로 제작한 핸드메이드 귀걸이입니다.',18000,15000,30,3000,'APPROVED','jewelry_01.jpg','2026-07-06 02:28:42','2026-07-06 02:28:42',0,'2026-07-06 11:28:42',NULL,NULL),(800,28,7,'미니 하트 귀걸이','작은 하트 포인트가 돋보이는 데일리 귀걸이입니다.',16000,0,35,3000,'APPROVED','jewelry_02.jpg','2026-07-06 02:28:42','2026-07-06 02:28:42',0,NULL,NULL,NULL),(801,28,7,'실버 링 귀걸이','깔끔한 실버 컬러의 링 디자인 귀걸이입니다.',19000,0,28,3000,'APPROVED','jewelry_03.jpg','2026-07-06 02:28:42','2026-07-06 02:28:42',0,NULL,NULL,NULL),(802,28,7,'플라워 드롭 귀걸이','꽃 장식이 포인트인 여성스러운 드롭 귀걸이입니다.',22000,18000,22,3000,'APPROVED','jewelry_04.jpg','2026-07-06 02:28:42','2026-07-06 02:28:42',0,'2026-07-06 11:28:42',NULL,NULL),(803,28,7,'실버 하트 목걸이','실버 체인에 하트 팬던트를 더한 목걸이입니다.',24000,0,25,3000,'APPROVED','jewelry_05.jpg','2026-07-06 02:28:42','2026-07-06 02:47:39',0,NULL,NULL,NULL),(804,28,7,'미니 진주 목걸이','작은 진주 장식으로 부담 없이 착용하기 좋은 목걸이입니다.',26000,21000,20,3000,'APPROVED','jewelry_06.jpg','2026-07-06 02:28:42','2026-07-06 02:47:39',0,'2026-07-06 11:28:42',NULL,NULL),(805,28,7,'실버 오픈링','사이즈 조절이 쉬운 심플한 실버 오픈링입니다.',17000,0,40,3000,'APPROVED','jewelry_07.jpg','2026-07-06 02:28:42','2026-07-06 02:47:44',0,NULL,NULL,NULL),(806,28,7,'하트 반지','하트 포인트가 들어간 귀여운 핸드메이드 반지입니다.',18000,14500,32,3000,'APPROVED','jewelry_08.jpg','2026-07-06 02:28:42','2026-07-06 02:47:49',0,'2026-07-06 11:28:42',NULL,NULL),(807,28,7,'원석 팔찌','자연스러운 원석 색감이 매력적인 수제 팔찌입니다.',23000,0,14,3000,'APPROVED','jewelry_09.jpg','2026-07-06 02:28:42','2026-07-08 02:14:18',0,NULL,NULL,NULL),(808,28,7,'진주 헤어핀','진주 장식으로 포인트를 준 고급스러운 헤어핀입니다.',15000,12000,29,3000,'APPROVED','jewelry_10.jpg','2026-07-06 02:28:42','2026-07-08 02:13:24',0,'2026-07-06 11:28:42',NULL,NULL),(809,29,8,'핸드메이드 니트 모자','포근한 실로 직접 짠 데일리 니트 모자입니다.',24000,20000,28,3000,'APPROVED','hat_01.jpg','2026-07-06 02:31:59','2026-07-06 02:31:59',0,'2026-07-06 11:31:59',NULL,NULL),(810,29,8,'울 버킷햇','따뜻한 울 소재로 제작한 감성 버킷햇입니다.',28000,0,20,3000,'APPROVED','hat_02.jpg','2026-07-06 02:31:59','2026-07-06 02:31:59',0,NULL,NULL,NULL),(811,29,8,'코튼 버킷햇','가볍게 착용하기 좋은 코튼 소재 버킷햇입니다.',22000,0,35,3000,'APPROVED','hat_03.jpg','2026-07-06 02:31:59','2026-07-06 02:31:59',0,NULL,NULL,NULL),(812,29,8,'체크 머플러','클래식한 체크 패턴이 돋보이는 머플러입니다.',26000,21000,24,3000,'APPROVED','hat_04.jpg','2026-07-06 02:31:59','2026-07-06 02:31:59',0,'2026-07-06 11:31:59',NULL,NULL),(813,29,8,'울 머플러','부드러운 촉감의 따뜻한 울 머플러입니다.',30000,0,18,3000,'APPROVED','hat_05.jpg','2026-07-06 02:31:59','2026-07-06 02:31:59',0,NULL,NULL,NULL),(814,29,8,'코튼 스카프','사계절 가볍게 활용하기 좋은 코튼 스카프입니다.',19000,0,32,3000,'APPROVED','hat_06.jpg','2026-07-06 02:31:59','2026-07-06 02:31:59',0,NULL,NULL,NULL),(815,29,8,'실크 스카프','은은한 광택감이 있는 고급스러운 실크 스카프입니다.',34000,28000,15,3000,'APPROVED','hat_07.jpg','2026-07-06 02:31:59','2026-07-06 02:31:59',0,'2026-07-06 11:31:59',NULL,NULL),(816,29,8,'니트 바라클라바','겨울철 따뜻하게 착용하기 좋은 니트 바라클라바입니다.',32000,0,16,3000,'APPROVED','hat_08.jpg','2026-07-06 02:31:59','2026-07-06 02:31:59',0,NULL,NULL,NULL),(817,29,8,'리본 헤어스카프','머리나 가방에 포인트로 활용하기 좋은 리본 스카프입니다.',15000,12000,40,3000,'APPROVED','hat_09.jpg','2026-07-06 02:31:59','2026-07-06 02:31:59',0,'2026-07-06 11:31:59',NULL,NULL),(818,29,8,'린넨 스카프','내추럴한 분위기의 린넨 소재 스카프입니다.',21000,0,26,3000,'APPROVED','hat_10.jpg','2026-07-06 02:31:59','2026-07-06 02:31:59',0,NULL,NULL,NULL),(819,30,12,'월넛 트레이','고급 월넛 원목으로 제작한 감성 트레이입니다.',32000,28000,15,3000,'APPROVED','wood_01.jpg','2026-07-06 02:51:35','2026-07-06 02:51:35',0,'2026-07-06 11:51:35',NULL,NULL),(820,30,12,'오크 도마','튼튼한 오크 원목으로 만든 수제 도마입니다.',39000,0,18,3000,'APPROVED','wood_02.jpg','2026-07-06 02:51:35','2026-07-06 02:51:35',0,NULL,NULL,NULL),(821,30,12,'원목 컵받침','내추럴한 원목 질감이 살아있는 컵받침입니다.',12000,10000,35,3000,'APPROVED','wood_03.jpg','2026-07-06 02:51:35','2026-07-06 02:51:35',0,'2026-07-06 11:51:35',NULL,NULL),(822,30,12,'우드 수저받침','심플한 디자인의 원목 수저받침입니다.',9000,0,40,3000,'APPROVED','wood_04.jpg','2026-07-06 02:51:35','2026-07-06 02:51:35',0,NULL,NULL,NULL),(823,30,12,'원목 비누받침','통풍이 잘 되는 수제 원목 비누받침입니다.',15000,0,28,3000,'APPROVED','wood_05.jpg','2026-07-06 02:51:35','2026-07-06 02:51:35',0,NULL,NULL,NULL),(824,30,12,'우드 펜꽂이','책상 위를 깔끔하게 정리할 수 있는 원목 펜꽂이입니다.',18000,15000,20,3000,'APPROVED','wood_06.jpg','2026-07-06 02:51:35','2026-07-06 02:51:35',0,'2026-07-06 11:51:35',NULL,NULL),(825,30,12,'원목 냄비받침','뜨거운 냄비를 안전하게 올려둘 수 있는 원목 받침입니다.',17000,0,22,3000,'APPROVED','wood_07.jpg','2026-07-06 02:51:35','2026-07-06 02:51:35',0,NULL,NULL,NULL),(826,30,12,'우드 액자','감성적인 인테리어를 완성하는 수제 원목 액자입니다.',24000,21000,16,3000,'APPROVED','wood_08.jpg','2026-07-06 02:51:35','2026-07-06 02:51:35',0,'2026-07-06 11:51:35',NULL,NULL),(827,30,12,'우드 미니 선반','소품을 올려두기 좋은 미니 원목 선반입니다.',34000,0,12,3000,'APPROVED','wood_09.jpg','2026-07-06 02:51:35','2026-07-06 02:51:35',0,NULL,NULL,NULL),(828,30,12,'원목 보관함','소품을 깔끔하게 보관할 수 있는 핸드메이드 원목 보관함입니다.',42000,36000,10,3000,'APPROVED','wood_10.jpg','2026-07-06 02:51:35','2026-07-06 02:51:35',0,'2026-07-06 11:51:35',NULL,NULL),(829,31,25,'머그컵','손으로 빚어 만든 따뜻한 감성의 도자기 머그컵입니다.',26000,22000,20,3000,'APPROVED','ceramic_01.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,'2026-07-06 12:22:40',NULL,NULL),(830,31,25,'라떼컵','라떼와 차를 담기 좋은 넓은 형태의 수제 도자기 컵입니다.',24000,0,24,3000,'APPROVED','ceramic_02.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,NULL,NULL,NULL),(831,31,28,'밥그릇','매일 식탁에서 사용하기 좋은 담백한 도자기 밥그릇입니다.',22000,0,30,3000,'APPROVED','ceramic_03.jpg','2026-07-06 03:22:40','2026-07-08 02:32:38',0,NULL,NULL,NULL),(832,31,25,'국그릇','깊이감 있는 형태로 국과 찌개를 담기 좋은 그릇입니다.',24000,20000,22,3000,'APPROVED','ceramic_04.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,'2026-07-06 12:22:40',NULL,NULL),(833,31,25,'디저트 접시','케이크와 과일을 담기 좋은 작은 도자기 접시입니다.',18000,0,35,3000,'APPROVED','ceramic_05.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,NULL,NULL,NULL),(834,31,25,'찻잔 세트','차를 즐기기 좋은 수제 찻잔 세트입니다.',36000,31000,14,3000,'APPROVED','ceramic_06.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,'2026-07-06 12:22:40',NULL,NULL),(835,31,25,'화병','꽃 한 송이만 꽂아도 분위기가 살아나는 도자기 화병입니다.',32000,0,16,3000,'APPROVED','ceramic_07.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,NULL,NULL,NULL),(836,31,25,'인센스 홀더','인센스를 안정적으로 꽂아둘 수 있는 도자기 홀더입니다.',15000,12000,28,3000,'APPROVED','ceramic_08.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,'2026-07-06 12:22:40',NULL,NULL),(837,31,25,'수저받침','식탁 위 작은 포인트가 되는 도자기 수저받침입니다.',9000,0,45,3000,'APPROVED','ceramic_09.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,NULL,NULL,NULL),(838,31,25,'소스볼','소스나 반찬을 담기 좋은 아담한 도자기 볼입니다.',12000,10000,32,3000,'APPROVED','ceramic_10.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,'2026-07-06 12:22:40',NULL,NULL),(839,32,12,'데이지 코스터','데이지 꽃 모양으로 손뜨개한 감성 코스터입니다.',9000,0,45,3000,'APPROVED','knit_01.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,NULL,NULL,NULL),(840,32,12,'꽃 티코스터','차 한 잔과 잘 어울리는 꽃 모양 뜨개 티코스터입니다.',9500,8000,38,3000,'APPROVED','knit_02.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,'2026-07-06 12:22:40',NULL,NULL),(841,32,26,'곰돌이 키링','부드러운 실로 만든 귀여운 곰돌이 키링입니다.',12000,0,30,3000,'APPROVED','knit_03.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,NULL,NULL,NULL),(842,32,26,'토끼 키링','토끼 모양으로 제작한 손뜨개 키링입니다.',12000,10000,32,3000,'APPROVED','knit_04.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,'2026-07-06 12:22:40',NULL,NULL),(843,32,26,'고양이 키링','고양이 얼굴 포인트가 들어간 귀여운 뜨개 키링입니다.',13000,0,28,3000,'APPROVED','knit_05.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,NULL,NULL,NULL),(844,32,12,'니트 파우치','작은 소지품을 담기 좋은 손뜨개 파우치입니다.',18000,15000,20,3000,'APPROVED','knit_06.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,'2026-07-06 12:22:40',NULL,NULL),(845,32,12,'미니 동전지갑','동전과 작은 소품을 보관하기 좋은 미니 지갑입니다.',16000,0,24,3000,'APPROVED','knit_07.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,NULL,NULL,NULL),(846,32,12,'텀블러 슬리브','텀블러를 감싸기 좋은 포근한 뜨개 슬리브입니다.',15000,12000,26,3000,'APPROVED','knit_08.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,'2026-07-06 12:22:40',NULL,NULL),(847,32,12,'뜨개 북마크','책 사이에 끼워 쓰기 좋은 귀여운 손뜨개 북마크입니다.',8000,0,40,3000,'APPROVED','knit_09.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,NULL,NULL,NULL),(848,32,12,'손뜨개 가방','가볍게 들기 좋은 핸드메이드 니트 가방입니다.',34000,29000,14,3000,'APPROVED','knit_10.jpg','2026-07-06 03:22:40','2026-07-06 03:22:40',0,'2026-07-06 12:22:40',NULL,NULL),(849,33,38,'카드지갑','천연 가죽으로 제작한 심플한 카드지갑입니다.',28000,24000,20,3000,'APPROVED','leather_01.jpg','2026-07-06 03:22:40','2026-07-08 02:25:33',0,'2026-07-06 12:22:40',NULL,NULL),(850,33,38,'반지갑','손에 잘 잡히는 크기의 수제 가죽 반지갑입니다.',48000,0,12,3000,'APPROVED','leather_02.jpg','2026-07-06 03:22:40','2026-07-08 02:25:33',0,NULL,NULL,NULL),(851,33,38,'키홀더','열쇠를 깔끔하게 보관할 수 있는 가죽 키홀더입니다.',19000,0,30,3000,'APPROVED','leather_03.jpg','2026-07-06 03:22:40','2026-07-08 02:25:33',0,NULL,NULL,NULL),(852,33,38,'에어팟 케이스','가죽 질감이 살아있는 무선이어폰 케이스입니다.',26000,22000,24,3000,'APPROVED','leather_04.jpg','2026-07-06 03:22:40','2026-07-08 02:25:33',0,'2026-07-06 12:22:40',NULL,NULL),(853,33,38,'여권지갑','여행할 때 사용하기 좋은 수제 가죽 여권지갑입니다.',42000,0,15,3000,'APPROVED','leather_05.jpg','2026-07-06 03:22:40','2026-07-08 02:25:33',0,NULL,NULL,NULL),(854,33,38,'노트커버','노트를 감싸는 고급스러운 가죽 커버입니다.',39000,33000,16,3000,'APPROVED','leather_06.jpg','2026-07-06 03:22:40','2026-07-08 02:25:33',0,'2026-07-06 12:22:40',NULL,NULL),(855,33,38,'가죽 북마크','독서 시간을 더 감성적으로 만들어주는 가죽 북마크입니다.',9000,0,40,3000,'APPROVED','leather_07.jpg','2026-07-06 03:22:40','2026-07-08 02:25:33',0,NULL,NULL,NULL),(856,33,38,'명함지갑','명함을 깔끔하게 보관할 수 있는 수제 가죽 명함지갑입니다.',30000,26000,22,3000,'APPROVED','leather_08.jpg','2026-07-06 03:22:40','2026-07-08 02:25:33',0,'2026-07-06 12:22:40',NULL,NULL),(857,33,38,'가죽 벨트','기본 스타일에 잘 어울리는 수제 가죽 벨트입니다.',52000,0,10,3000,'APPROVED','leather_09.jpg','2026-07-06 03:22:40','2026-07-08 02:25:33',0,NULL,NULL,NULL),(858,33,38,'가죽 파우치','화장품이나 소품을 담기 좋은 가죽 파우치입니다.',36000,31000,18,3000,'APPROVED','leather_10.jpg','2026-07-06 03:22:40','2026-07-08 02:25:33',0,'2026-07-06 12:22:40',NULL,NULL),(859,34,23,'라벤더 비누','은은한 라벤더 향이 나는 핸드메이드 천연비누입니다.',9000,0,45,3000,'APPROVED','soap_01.jpg','2026-07-06 03:25:57','2026-07-06 06:22:33',0,NULL,NULL,NULL),(860,34,23,'숯 비누','깔끔한 세정을 돕는 숯 성분의 수제 비누입니다.',9500,8000,40,3000,'APPROVED','soap_02.jpg','2026-07-06 03:25:57','2026-07-06 06:22:33',0,'2026-07-06 12:25:57',NULL,NULL),(861,34,23,'꿀 비누','꿀을 더해 촉촉한 사용감을 느낄 수 있는 비누입니다.',10000,0,38,3000,'APPROVED','soap_03.jpg','2026-07-06 03:25:57','2026-07-06 06:22:33',0,NULL,NULL,NULL),(862,34,23,'오트밀 비누','부드러운 오트밀 가루를 담은 순한 수제 비누입니다.',10000,8500,35,3000,'APPROVED','soap_04.jpg','2026-07-06 03:25:57','2026-07-06 06:22:33',0,'2026-07-06 12:25:57',NULL,NULL),(863,34,23,'레몬 비누','상큼한 레몬 향이 기분 좋은 천연비누입니다.',9000,0,42,3000,'APPROVED','soap_05.jpg','2026-07-06 03:25:57','2026-07-06 06:22:33',0,NULL,NULL,NULL),(864,34,23,'로즈 비누','장미 향과 부드러운 거품이 매력적인 비누입니다.',11000,0,32,3000,'APPROVED','soap_06.jpg','2026-07-06 03:25:57','2026-07-06 06:22:33',0,NULL,NULL,NULL),(865,34,23,'카모마일 비누','카모마일 향을 담아 편안한 느낌을 주는 수제 비누입니다.',10000,8500,34,3000,'APPROVED','soap_07.jpg','2026-07-06 03:25:57','2026-07-06 06:22:33',0,'2026-07-06 12:25:57',NULL,NULL),(866,34,23,'녹차 비누','녹차의 산뜻한 향이 은은하게 퍼지는 비누입니다.',9500,0,37,3000,'APPROVED','soap_08.jpg','2026-07-06 03:25:57','2026-07-06 06:22:33',0,NULL,NULL,NULL),(867,34,23,'허브 비누','여러 허브 향을 조합한 내추럴 수제 비누입니다.',12000,10000,28,3000,'APPROVED','soap_09.jpg','2026-07-06 03:25:57','2026-07-06 06:22:33',0,'2026-07-06 12:25:57',NULL,NULL),(868,34,23,'시어버터 비누','시어버터를 담아 부드럽고 촉촉한 비누입니다.',13000,0,25,3000,'APPROVED','soap_10.jpg','2026-07-06 03:25:57','2026-07-06 06:22:33',0,NULL,NULL,NULL),(869,35,31,'소이 캔들','식물성 소이왁스로 만든 은은한 향의 핸드메이드 캔들입니다.',18000,15000,28,3000,'APPROVED','candle_01.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,'2026-07-06 12:25:57',NULL,NULL),(870,35,31,'라벤더 캔들','라벤더 향이 편안하게 퍼지는 수제 캔들입니다.',19000,0,25,3000,'APPROVED','candle_02.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,NULL,NULL,NULL),(871,35,31,'바닐라 캔들','부드러운 바닐라 향이 공간을 따뜻하게 채우는 캔들입니다.',19000,0,24,3000,'APPROVED','candle_03.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,NULL,NULL,NULL),(872,35,31,'시트러스 캔들','상큼한 시트러스 향으로 기분 전환에 좋은 캔들입니다.',20000,17000,22,3000,'APPROVED','candle_04.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,'2026-07-06 12:25:57',NULL,NULL),(873,35,31,'우드윅 캔들','나무 심지가 타는 소리가 매력적인 우드윅 캔들입니다.',24000,0,18,3000,'APPROVED','candle_05.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,NULL,NULL,NULL),(874,35,31,'플라워 캔들','꽃 장식이 들어간 선물용 핸드메이드 캔들입니다.',22000,19000,20,3000,'APPROVED','candle_06.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,'2026-07-06 12:25:57',NULL,NULL),(875,35,31,'티라이트 세트','작은 티라이트 캔들을 여러 개 담은 세트입니다.',15000,0,35,3000,'APPROVED','candle_07.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,NULL,NULL,NULL),(876,35,31,'필라 캔들','깔끔한 원통형 디자인의 인테리어 캔들입니다.',21000,0,21,3000,'APPROVED','candle_08.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,NULL,NULL,NULL),(877,35,31,'아로마 캔들','공간에 은은한 향을 더하는 아로마 수제 캔들입니다.',23000,19000,19,3000,'APPROVED','candle_09.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,'2026-07-06 12:25:57',NULL,NULL),(878,35,31,'캔들 선물세트','다양한 향의 캔들을 담은 핸드메이드 선물세트입니다.',36000,31000,12,3000,'APPROVED','candle_10.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,'2026-07-06 12:25:57',NULL,NULL),(879,36,24,'라벤더 디퓨저','라벤더 향이 은은하게 퍼지는 수제 디퓨저입니다.',23000,19000,22,3000,'APPROVED','perfume_01.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,'2026-07-06 12:25:57',NULL,NULL),(880,36,24,'플라워 디퓨저','꽃 향을 담아 공간을 산뜻하게 만드는 디퓨저입니다.',24000,0,20,3000,'APPROVED','perfume_02.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,NULL,NULL,NULL),(881,36,24,'시트러스 디퓨저','상큼한 시트러스 향의 핸드메이드 디퓨저입니다.',22000,0,24,3000,'APPROVED','perfume_03.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,NULL,NULL,NULL),(882,36,24,'우드 디퓨저','차분한 우드 계열 향이 매력적인 디퓨저입니다.',26000,22000,18,3000,'APPROVED','perfume_04.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,'2026-07-06 12:25:57',NULL,NULL),(883,36,24,'화이트머스크 향수','깨끗하고 포근한 화이트머스크 향의 수제 향수입니다.',32000,0,16,3000,'APPROVED','perfume_05.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,NULL,NULL,NULL),(884,36,24,'플로럴 향수','은은한 꽃향이 오래 남는 핸드메이드 향수입니다.',33000,28000,14,3000,'APPROVED','perfume_06.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,'2026-07-06 12:25:57',NULL,NULL),(885,36,24,'코튼 향수','깨끗한 섬유 향을 담은 데일리 향수입니다.',31000,0,17,3000,'APPROVED','perfume_07.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,NULL,NULL,NULL),(886,36,24,'룸스프레이','공간에 가볍게 뿌려 향을 더하는 룸스프레이입니다.',18000,15000,26,3000,'APPROVED','perfume_08.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,'2026-07-06 12:25:57',NULL,NULL),(887,36,24,'차량용 디퓨저','차 안을 은은한 향으로 채워주는 차량용 디퓨저입니다.',16000,0,30,3000,'APPROVED','perfume_09.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,NULL,NULL,NULL),(888,36,24,'디퓨저 선물세트','인기 향 디퓨저를 담은 감성 선물세트입니다.',42000,36000,10,3000,'APPROVED','perfume_10.jpg','2026-07-06 03:25:57','2026-07-08 02:25:33',0,'2026-07-06 12:25:57',NULL,NULL),(889,37,32,'캐모마일차','은은한 향과 부드러운 맛이 특징인 캐모마일 허브티입니다.',14000,12000,40,3000,'APPROVED','tea_01.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(890,37,32,'히비스커스차','상큼한 풍미를 즐길 수 있는 히비스커스 티입니다.',15000,0,35,3000,'APPROVED','tea_02.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(891,37,32,'페퍼민트차','시원한 향이 매력적인 페퍼민트 허브티입니다.',14000,0,38,3000,'APPROVED','tea_03.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(892,37,32,'얼그레이','베르가못 향이 은은한 클래식 홍차입니다.',16000,14000,32,3000,'APPROVED','tea_04.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(893,37,32,'녹차','깔끔한 맛의 수제 블렌딩 녹차입니다.',13000,0,40,3000,'APPROVED','tea_05.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(894,37,32,'루이보스차','카페인 없이 즐길 수 있는 루이보스 티입니다.',17000,0,28,3000,'APPROVED','tea_06.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(895,37,32,'과일차','건조 과일을 담아 만든 향긋한 과일차입니다.',18000,15000,24,3000,'APPROVED','tea_07.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(896,37,32,'허브티 세트','다양한 허브티를 함께 즐길 수 있는 세트입니다.',28000,0,20,3000,'APPROVED','tea_08.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(897,37,32,'티백 선물세트','선물하기 좋은 허브티 티백 세트입니다.',32000,28000,18,3000,'APPROVED','tea_09.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(898,37,32,'수제 블렌딩 티','직접 블렌딩한 프리미엄 허브티입니다.',22000,0,22,3000,'APPROVED','tea_10.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(899,38,30,'강아지 장난감','부드러운 소재로 만든 반려견 장난감입니다.',15000,12000,30,3000,'APPROVED','pet_01.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(900,38,30,'고양이 장난감','고양이가 좋아하는 낚싯대 장난감입니다.',14000,0,34,3000,'APPROVED','pet_02.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(901,38,29,'반려동물 목걸이','사이즈 조절이 가능한 수제 목걸이입니다.',18000,0,24,3000,'APPROVED','pet_03.jpg','2026-07-06 03:26:58','2026-07-08 02:32:38',0,NULL,NULL,NULL),(902,38,28,'간식 보관통','반려동물 간식을 보관하기 좋은 용기입니다.',16000,14000,22,3000,'APPROVED','pet_04.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(903,38,27,'배변매트','흡수력이 좋은 반려동물 배변매트입니다.',12000,0,40,3000,'APPROVED','pet_05.jpg','2026-07-06 03:26:58','2026-07-08 02:32:38',0,NULL,NULL,NULL),(904,38,27,'이동가방','외출 시 편리한 반려동물 이동가방입니다.',48000,42000,12,3000,'APPROVED','pet_06.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(905,38,28,'밥그릇','도자기 소재의 반려동물 식기입니다.',17000,0,20,3000,'APPROVED','pet_07.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(906,38,28,'급수기','깨끗한 물을 공급하는 급수기입니다.',25000,0,18,3000,'APPROVED','pet_08.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(907,38,30,'스크래쳐','고양이를 위한 골판지 스크래쳐입니다.',22000,18000,16,3000,'APPROVED','pet_09.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(908,38,29,'산책 리드줄','튼튼한 소재의 반려동물 리드줄입니다.',26000,0,18,3000,'APPROVED','pet_10.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(909,39,33,'스투키','공기정화에 좋은 인기 식물 스투키입니다.',18000,15000,20,3000,'APPROVED','plant_01.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(910,39,33,'몬스테라','싱그러운 잎이 매력적인 몬스테라입니다.',24000,0,16,3000,'APPROVED','plant_02.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(911,39,33,'선인장','관리하기 쉬운 미니 선인장입니다.',12000,0,35,3000,'APPROVED','plant_03.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(912,39,33,'다육식물','아기자기한 다육식물 화분입니다.',13000,11000,30,3000,'APPROVED','plant_04.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(913,39,33,'테이블야자','실내 인테리어에 잘 어울리는 식물입니다.',22000,0,18,3000,'APPROVED','plant_05.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(914,39,33,'스킨답서스','초보자도 키우기 쉬운 공기정화 식물입니다.',17000,0,22,3000,'APPROVED','plant_06.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(915,39,33,'행잉플랜트','공중에 걸어 연출하는 행잉 식물입니다.',26000,22000,14,3000,'APPROVED','plant_07.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(916,39,33,'미니 화분','작은 공간을 꾸미기 좋은 화분입니다.',14000,0,28,3000,'APPROVED','plant_08.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,NULL,NULL,NULL),(917,39,33,'허브 화분','요리에 활용 가능한 허브 화분입니다.',19000,16000,18,3000,'APPROVED','plant_09.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(918,39,33,'식물 선물세트','인기 식물을 담은 선물세트입니다.',38000,33000,10,3000,'APPROVED','plant_10.jpg','2026-07-06 03:26:58','2026-07-08 02:25:33',0,'2026-07-06 12:26:58',NULL,NULL),(919,40,26,'아크릴 키링','투명 아크릴 소재로 제작한 감성 키링입니다.',9000,0,45,3000,'APPROVED','keyring_01.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(920,40,26,'고양이 키링','고양이 캐릭터가 들어간 귀여운 키링입니다.',10000,8500,38,3000,'APPROVED','keyring_02.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(921,40,26,'강아지 키링','강아지 모양으로 제작한 핸드메이드 키링입니다.',10000,0,36,3000,'APPROVED','keyring_03.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(922,40,26,'토끼 키링','토끼 포인트가 들어간 아기자기한 키링입니다.',10000,8500,34,3000,'APPROVED','keyring_04.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(923,40,26,'곰돌이 키링','폭신한 곰돌이 디자인의 키링입니다.',11000,0,32,3000,'APPROVED','keyring_05.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(924,40,26,'하트 키링','하트 장식이 포인트인 데일리 키링입니다.',9000,0,40,3000,'APPROVED','keyring_06.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(925,40,26,'별 키링','별 모양 참이 달린 귀여운 키링입니다.',9500,8000,35,3000,'APPROVED','keyring_07.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(926,40,26,'꽃 키링','꽃 장식이 들어간 화사한 키링입니다.',11000,0,30,3000,'APPROVED','keyring_08.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(927,40,26,'이니셜 키링','원하는 이니셜 느낌을 담은 심플 키링입니다.',12000,10000,28,3000,'APPROVED','keyring_09.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(928,40,26,'가죽 키링','천연 가죽으로 제작한 고급스러운 키링입니다.',15000,0,24,3000,'APPROVED','keyring_10.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(929,41,12,'린넨 앞치마','내추럴한 린넨 원단으로 만든 주방 앞치마입니다.',28000,24000,20,3000,'APPROVED','living_01.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(930,41,12,'린넨 티슈커버','공간 분위기를 부드럽게 만드는 린넨 티슈커버입니다.',16000,0,28,3000,'APPROVED','living_02.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(931,41,12,'패브릭 바구니','작은 소품을 정리하기 좋은 패브릭 바구니입니다.',18000,15000,24,3000,'APPROVED','living_03.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(932,41,12,'테이블 매트','식탁에 포인트를 주는 핸드메이드 테이블 매트입니다.',12000,0,36,3000,'APPROVED','living_04.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(933,41,12,'쿠션 커버','따뜻한 색감의 패브릭 쿠션 커버입니다.',19000,0,26,3000,'APPROVED','living_05.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(934,41,12,'주방 장갑','뜨거운 조리도구를 잡기 좋은 패브릭 주방 장갑입니다.',15000,12000,30,3000,'APPROVED','living_06.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(935,41,12,'행주 세트','흡수력이 좋은 면 소재 행주 세트입니다.',10000,0,40,3000,'APPROVED','living_07.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(936,41,12,'냄비 받침','주방에서 사용하기 좋은 패브릭 냄비 받침입니다.',11000,9000,34,3000,'APPROVED','living_08.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(937,41,12,'수납 파우치','소품을 담기 좋은 린넨 수납 파우치입니다.',17000,0,24,3000,'APPROVED','living_09.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(938,41,12,'생활용품 세트','린넨 생활소품을 모아 담은 세트입니다.',42000,36000,12,3000,'APPROVED','living_10.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(939,42,34,'드라이플라워','은은한 색감의 드라이플라워 장식입니다.',18000,15000,24,3000,'APPROVED','flower_01.jpg','2026-07-06 03:29:22','2026-07-08 02:25:33',0,'2026-07-06 12:29:22',NULL,NULL),(940,42,34,'미니 꽃다발','작은 선물로 좋은 미니 꽃다발입니다.',20000,0,22,3000,'APPROVED','flower_02.jpg','2026-07-06 03:29:22','2026-07-08 02:25:33',0,NULL,NULL,NULL),(941,42,34,'리스','문이나 벽에 걸기 좋은 플라워 리스입니다.',28000,24000,16,3000,'APPROVED','flower_03.jpg','2026-07-06 03:29:22','2026-07-08 02:25:33',0,'2026-07-06 12:29:22',NULL,NULL),(942,42,34,'플라워 박스','선물용으로 구성한 감성 플라워 박스입니다.',35000,0,12,3000,'APPROVED','flower_04.jpg','2026-07-06 03:29:22','2026-07-08 02:25:33',0,NULL,NULL,NULL),(943,42,34,'꽃병 장식','화병과 잘 어울리는 플라워 장식입니다.',22000,0,20,3000,'APPROVED','flower_05.jpg','2026-07-06 03:29:22','2026-07-08 02:25:33',0,NULL,NULL,NULL),(944,42,34,'조화 화분','오래 두고 감상할 수 있는 조화 화분입니다.',24000,20000,18,3000,'APPROVED','flower_06.jpg','2026-07-06 03:29:22','2026-07-08 02:25:33',0,'2026-07-06 12:29:22',NULL,NULL),(945,42,34,'벽걸이 플라워','벽면을 꾸미기 좋은 플라워 소품입니다.',26000,0,15,3000,'APPROVED','flower_07.jpg','2026-07-06 03:29:22','2026-07-08 02:25:33',0,NULL,NULL,NULL),(946,42,34,'플라워 캔들홀더','꽃 장식이 들어간 감성 캔들홀더입니다.',19000,16000,20,3000,'APPROVED','flower_08.jpg','2026-07-06 03:29:22','2026-07-08 02:25:33',0,'2026-07-06 12:29:22',NULL,NULL),(947,42,34,'프리저브드 플라워','생화의 느낌을 오래 간직하는 프리저브드 플라워입니다.',32000,0,14,3000,'APPROVED','flower_09.jpg','2026-07-06 03:29:22','2026-07-08 02:25:33',0,NULL,NULL,NULL),(948,42,34,'플라워 선물세트','꽃 소품을 함께 담은 핸드메이드 선물세트입니다.',45000,39000,10,3000,'APPROVED','flower_10.jpg','2026-07-06 03:29:22','2026-07-08 02:25:33',0,'2026-07-06 12:29:22',NULL,NULL),(949,43,15,'로즈 틴트','장미빛 컬러가 자연스럽게 올라오는 틴트입니다.',14000,12000,35,3000,'APPROVED','beauty_01.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(950,43,15,'코랄 틴트','화사한 코랄 컬러의 데일리 틴트입니다.',14000,0,32,3000,'APPROVED','beauty_02.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(951,43,15,'벨벳 립스틱','보송한 마무리감의 벨벳 립스틱입니다.',18000,15000,28,3000,'APPROVED','beauty_03.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(952,43,15,'글로우 립틴트','촉촉한 광택감이 있는 립틴트입니다.',16000,0,30,3000,'APPROVED','beauty_04.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(953,43,17,'아이섀도우 팔레트','데일리 컬러를 담은 아이섀도우 팔레트입니다.',26000,22000,20,3000,'APPROVED','beauty_05.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(954,43,17,'브라운 아이섀도우','부드러운 음영 메이크업에 좋은 브라운 섀도우입니다.',18000,0,24,3000,'APPROVED','beauty_06.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(955,43,17,'마스카라','속눈썹을 또렷하게 연출해주는 마스카라입니다.',17000,0,26,3000,'APPROVED','beauty_07.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(956,43,17,'아이라이너','선명한 라인을 그리기 좋은 아이라이너입니다.',15000,12000,30,3000,'APPROVED','beauty_08.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(957,43,17,'아이브로우 펜슬','자연스러운 눈썹 표현이 가능한 펜슬입니다.',12000,0,35,3000,'APPROVED','beauty_09.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,NULL,NULL,NULL),(958,43,17,'메이크업 세트','립과 아이 제품을 함께 구성한 메이크업 세트입니다.',42000,36000,12,3000,'APPROVED','beauty_10.jpg','2026-07-06 03:29:22','2026-07-06 03:29:22',0,'2026-07-06 12:29:22',NULL,NULL),(959,44,35,'티 선물세트','다양한 허브티를 담은 감성 선물세트입니다.',32000,28000,18,3000,'APPROVED','gift_01.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(960,44,35,'캔들 선물세트','인기 향 캔들을 함께 담은 선물세트입니다.',36000,0,15,3000,'APPROVED','gift_02.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(961,44,35,'비누 선물세트','천연비누를 깔끔하게 구성한 선물세트입니다.',28000,24000,20,3000,'APPROVED','gift_03.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(962,44,35,'디퓨저 선물세트','공간에 향을 더하는 디퓨저 선물세트입니다.',42000,0,12,3000,'APPROVED','gift_04.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(963,44,35,'주얼리 선물세트','데일리 주얼리를 담은 핸드메이드 선물세트입니다.',45000,39000,10,3000,'APPROVED','gift_05.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(964,44,35,'머그컵 선물세트','도자기 머그컵과 소품을 담은 선물세트입니다.',38000,0,14,3000,'APPROVED','gift_06.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(965,44,35,'키링 선물세트','귀여운 키링을 모아 담은 선물세트입니다.',26000,22000,22,3000,'APPROVED','gift_07.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(966,44,35,'생활용품 선물세트','실용적인 핸드메이드 생활소품 세트입니다.',40000,0,13,3000,'APPROVED','gift_08.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(967,44,35,'플라워 선물세트','플라워 소품을 담은 감성 선물세트입니다.',43000,36000,10,3000,'APPROVED','gift_09.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(968,44,35,'핸드메이드 기프트박스','여러 수공예 소품을 담은 기프트박스입니다.',52000,45000,8,3000,'APPROVED','gift_10.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(969,45,36,'감성 엽서','따뜻한 일러스트가 담긴 감성 엽서입니다.',3000,0,80,3000,'APPROVED','paper_01.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(970,45,36,'일러스트 엽서','작가의 그림이 들어간 일러스트 엽서입니다.',3500,3000,70,3000,'APPROVED','paper_02.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(971,45,36,'감사 카드','마음을 전하기 좋은 감사 카드입니다.',4000,0,65,3000,'APPROVED','paper_03.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(972,45,36,'메모패드','데일리 기록에 좋은 메모패드입니다.',6000,5000,50,3000,'APPROVED','paper_04.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(973,45,36,'노트','손글씨 기록에 어울리는 감성 노트입니다.',9000,0,45,3000,'APPROVED','paper_05.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(974,45,36,'다이어리','일상을 정리하기 좋은 수제 다이어리입니다.',18000,15000,28,3000,'APPROVED','paper_06.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(975,45,36,'북마크','책 읽는 시간을 더해주는 종이 북마크입니다.',3500,0,70,3000,'APPROVED','paper_07.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(976,45,36,'편지지 세트','편지지와 봉투를 함께 구성한 세트입니다.',8000,0,40,3000,'APPROVED','paper_08.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(977,45,36,'캘린더','계절감 있는 일러스트 캘린더입니다.',16000,13000,24,3000,'APPROVED','paper_09.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(978,45,36,'문구 세트','엽서와 노트, 메모지를 담은 문구 세트입니다.',24000,20000,18,3000,'APPROVED','paper_10.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(979,46,37,'고양이 스티커','고양이 일러스트가 들어간 귀여운 스티커입니다.',2500,0,100,3000,'APPROVED','sticker_01.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(980,46,37,'강아지 스티커','강아지 캐릭터를 담은 스티커입니다.',2500,0,100,3000,'APPROVED','sticker_02.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(981,46,37,'플라워 스티커','꽃 그림이 들어간 감성 스티커입니다.',3000,2500,90,3000,'APPROVED','sticker_03.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(982,46,37,'캐릭터 스티커','다이어리 꾸미기에 좋은 캐릭터 스티커입니다.',3000,0,85,3000,'APPROVED','sticker_04.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(983,46,37,'감성 스티커','은은한 색감의 감성 스티커입니다.',3500,3000,80,3000,'APPROVED','sticker_05.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(984,46,37,'다꾸 스티커','다이어리 꾸미기에 활용하기 좋은 스티커입니다.',3500,0,75,3000,'APPROVED','sticker_06.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(985,46,37,'투명 스티커','깔끔하게 붙일 수 있는 투명 스티커입니다.',4000,0,70,3000,'APPROVED','sticker_07.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(986,46,37,'방수 스티커','물에 강한 재질의 방수 스티커입니다.',4500,4000,60,3000,'APPROVED','sticker_08.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(987,46,37,'라벨 스티커','소품 정리에 좋은 라벨 스티커입니다.',4000,0,65,3000,'APPROVED','sticker_09.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(988,46,37,'스티커팩','여러 종류의 스티커를 담은 패키지입니다.',12000,10000,40,3000,'APPROVED','sticker_10.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(989,47,38,'패브릭 파우치','소품을 담기 좋은 핸드메이드 패브릭 파우치입니다.',16000,13000,30,3000,'APPROVED','fabric_01.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(990,47,38,'미니 에코백','가볍게 들기 좋은 작은 에코백입니다.',22000,0,24,3000,'APPROVED','fabric_02.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(991,47,38,'자수 손수건','작은 자수 포인트가 들어간 손수건입니다.',9000,0,45,3000,'APPROVED','fabric_03.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(992,47,38,'패브릭 북커버','책을 보호하고 감성을 더하는 북커버입니다.',18000,15000,26,3000,'APPROVED','fabric_04.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(993,47,38,'천 필통','필기구를 담기 좋은 패브릭 필통입니다.',14000,0,32,3000,'APPROVED','fabric_05.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(994,47,38,'토트백','데일리로 사용하기 좋은 패브릭 토트백입니다.',28000,24000,18,3000,'APPROVED','fabric_06.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(995,47,38,'복조리 가방','귀여운 형태의 패브릭 복조리 가방입니다.',26000,0,20,3000,'APPROVED','fabric_07.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(996,47,38,'자수 파우치','자수 포인트가 들어간 수제 파우치입니다.',19000,16000,24,3000,'APPROVED','fabric_08.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL),(997,47,38,'패브릭 키링','천 조각을 활용한 가벼운 패브릭 키링입니다.',10000,0,36,3000,'APPROVED','fabric_09.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,NULL,NULL,NULL),(998,47,38,'패브릭 선물세트','패브릭 소품을 모아 담은 선물세트입니다.',42000,36000,12,3000,'APPROVED','fabric_10.jpg','2026-07-06 03:32:13','2026-07-08 02:25:33',0,'2026-07-06 12:32:13',NULL,NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `qnas`
--

DROP TABLE IF EXISTS `qnas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `qnas` (
  `qna_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `product_id` bigint DEFAULT NULL,
  `qna_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'PRODUCT',
  `is_private` tinyint NOT NULL DEFAULT '0',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `answer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `status` enum('WAITING','ANSWERED') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'WAITING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `answered_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`qna_id`),
  KEY `fk_qnas_user` (`user_id`),
  KEY `fk_qnas_product` (`product_id`),
  CONSTRAINT `fk_qnas_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_qnas_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `qnas`
--

LOCK TABLES `qnas` WRITE;
/*!40000 ALTER TABLE `qnas` DISABLE KEYS */;
/*!40000 ALTER TABLE `qnas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `report_id` bigint NOT NULL AUTO_INCREMENT,
  `reporter_id` bigint NOT NULL,
  `target_type` enum('PRODUCT','REVIEW','QNA') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `target_id` bigint NOT NULL,
  `report_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('PENDING','PROCESSED','REJECTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`report_id`),
  KEY `fk_reports_reporter` (`reporter_id`),
  CONSTRAINT `fk_reports_reporter` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `product_id` bigint NOT NULL,
  `order_item_id` bigint NOT NULL,
  `rating` int NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reply_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `reply_created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  UNIQUE KEY `uq_reviews_order_item` (`order_item_id`),
  KEY `fk_reviews_user` (`user_id`),
  KEY `fk_reviews_product` (`product_id`),
  CONSTRAINT `fk_reviews_order_item` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`order_item_id`),
  CONSTRAINT `fk_reviews_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `reviews_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,40,799,76,4,'담수 진주 귀걸이 전체적으로 만족스러운데 배송이 생각보다 조금 늦었어요. 그래도 제품은 예뻐요.','ACTIVE','2026-06-16 19:18:00','소중한 리뷰 남겨주셔서 감사합니다 :) 앞으로도 좋은 제품으로 보답하겠습니다!','2026-06-17 15:18:00'),(2,40,808,77,4,'진주 헤어핀 전체적으로 만족스러운데 배송이 생각보다 조금 늦었어요. 그래도 제품은 예뻐요.','ACTIVE','2026-06-18 11:24:00','구매해주셔서 감사드려요! 말씀해주신 부분 참고해서 더 신경쓰겠습니다.','2026-06-19 04:24:00'),(3,41,803,78,5,'선물로 구매했는데 받으시는 분이 너무 좋아하셨어요! 실버 하트 목걸이 완전 강추합니다.','ACTIVE','2026-06-16 03:44:00',NULL,NULL),(4,42,804,79,4,'가격 대비 괜찮은 것 같아요. 미니 진주 목걸이 포장도 예뻤고 만족합니다.','ACTIVE','2026-06-21 03:31:00','소중한 리뷰 남겨주셔서 감사합니다 :) 앞으로도 좋은 제품으로 보답하겠습니다!','2026-06-22 08:31:00'),(5,43,806,80,4,'디자인은 마음에 드는데 하트 반지 생각보다 사이즈가 작은 느낌이에요. 그래도 데일리로 착용하기 좋아요.','ACTIVE','2026-06-25 20:09:00','구매해주셔서 감사드려요! 말씀해주신 부분 참고해서 더 신경쓰겠습니다.','2026-06-26 17:09:00'),(6,43,808,81,3,'진주 헤어핀 배송이 예상보다 오래 걸렸고, 마감이 조금 아쉬운 부분이 있었어요.','ACTIVE','2026-06-22 04:39:00','따뜻한 후기 감사합니다! 예쁘게 착용해주세요 :)','2026-06-22 22:39:00'),(7,44,802,82,4,'플라워 드롭 귀걸이 이쁘고 착용감도 나쁘지 않은데, 세척 방법 안내가 좀 더 자세했으면 좋겠어요.','ACTIVE','2026-06-24 04:56:00',NULL,NULL),(8,44,804,83,5,'핸드메이드 느낌이 물씬 나서 좋아요. 미니 진주 목걸이 착용감도 편하고 무겁지 않아서 마음에 들어요.','ACTIVE','2026-06-24 14:36:00',NULL,NULL),(9,45,802,84,4,'플라워 드롭 귀걸이 이쁘고 착용감도 나쁘지 않은데, 세척 방법 안내가 좀 더 자세했으면 좋겠어요.','ACTIVE','2026-06-29 02:40:00',NULL,NULL),(10,46,807,85,5,'디자인이 너무 예뻐서 매일 착용하고 있어요. 원석 팔찌 가격 대비 퀄리티가 정말 좋습니다.','ACTIVE','2026-07-03 02:26:00',NULL,NULL),(11,46,803,86,3,'실버 하트 목걸이 사진이랑 실물 색감이 살짝 다른 것 같아요. 나쁘진 않지만 기대했던 것보다는 평범했어요.','ACTIVE','2026-07-04 03:12:00','따뜻한 후기 감사합니다! 예쁘게 착용해주세요 :)','2026-07-06 07:12:00'),(12,47,799,87,5,'포장도 깔끔하고 담수 진주 귀걸이 색감이 화면으로 본 것보다 더 고급스러워요. 재구매 의사 100%입니다.','ACTIVE','2026-07-05 11:27:00',NULL,NULL),(13,48,808,88,4,'진주 헤어핀 전체적으로 만족스러운데 배송이 생각보다 조금 늦었어요. 그래도 제품은 예뻐요.','ACTIVE','2026-07-08 17:23:00',NULL,NULL),(14,48,806,89,5,'핸드메이드 느낌이 물씬 나서 좋아요. 하트 반지 착용감도 편하고 무겁지 않아서 마음에 들어요.','ACTIVE','2026-07-11 02:16:00','구매해주셔서 감사드려요! 말씀해주신 부분 참고해서 더 신경쓰겠습니다.','2026-07-13 06:16:00'),(15,48,799,90,4,'담수 진주 귀걸이 전체적으로 만족스러운데 배송이 생각보다 조금 늦었어요. 그래도 제품은 예뻐요.','ACTIVE','2026-07-09 09:12:00',NULL,NULL),(16,49,804,91,4,'가격 대비 괜찮은 것 같아요. 미니 진주 목걸이 포장도 예뻤고 만족합니다.','ACTIVE','2026-07-12 23:01:00','따뜻한 후기 감사합니다! 예쁘게 착용해주세요 :)','2026-07-14 23:01:00'),(17,49,807,92,5,'핸드메이드 느낌이 물씬 나서 좋아요. 원석 팔찌 착용감도 편하고 무겁지 않아서 마음에 들어요.','ACTIVE','2026-07-14 09:57:00',NULL,NULL),(18,49,802,93,4,'디자인은 마음에 드는데 플라워 드롭 귀걸이 생각보다 사이즈가 작은 느낌이에요. 그래도 데일리로 착용하기 좋아요.','ACTIVE','2026-07-12 22:14:00','따뜻한 후기 감사합니다! 예쁘게 착용해주세요 :)','2026-07-14 21:14:00'),(19,40,807,94,4,'가격 대비 괜찮은 것 같아요. 원석 팔찌 포장도 예뻤고 만족합니다.','ACTIVE','2026-06-11 04:44:00','소중한 의견 감사합니다. 다음 제작 시 꼭 반영하도록 하겠습니다.','2026-06-12 00:44:00'),(20,41,802,95,5,'플라워 드롭 귀걸이 정말 만족스러워요! 사진이랑 실물이 똑같고 마감도 꼼꼼해서 선물용으로도 손색없을 것 같아요.','ACTIVE','2026-06-08 22:01:00','소중한 의견 감사합니다. 다음 제작 시 꼭 반영하도록 하겠습니다.','2026-06-09 20:01:00'),(21,42,804,96,4,'가격 대비 괜찮은 것 같아요. 미니 진주 목걸이 포장도 예뻤고 만족합니다.','ACTIVE','2026-06-13 09:24:00',NULL,NULL),(22,43,808,97,5,'포장도 깔끔하고 진주 헤어핀 색감이 화면으로 본 것보다 더 고급스러워요. 재구매 의사 100%입니다.','ACTIVE','2026-06-10 05:26:00',NULL,NULL),(23,44,799,98,5,'선물로 구매했는데 받으시는 분이 너무 좋아하셨어요! 담수 진주 귀걸이 완전 강추합니다.','ACTIVE','2026-06-13 18:25:00',NULL,NULL),(24,45,803,99,5,'포장도 깔끔하고 실버 하트 목걸이 색감이 화면으로 본 것보다 더 고급스러워요. 재구매 의사 100%입니다.','ACTIVE','2026-06-16 19:10:00','따뜻한 후기 감사합니다! 예쁘게 착용해주세요 :)','2026-06-17 07:10:00'),(25,46,806,100,3,'하트 반지 사진이랑 실물 색감이 살짝 다른 것 같아요. 나쁘진 않지만 기대했던 것보다는 평범했어요.','ACTIVE','2026-06-18 21:42:00',NULL,NULL),(26,47,805,101,3,'실버 오픈링 배송이 예상보다 오래 걸렸고, 마감이 조금 아쉬운 부분이 있었어요.','ACTIVE','2026-06-19 14:11:00',NULL,NULL),(27,48,800,102,5,'디자인이 너무 예뻐서 매일 착용하고 있어요. 미니 하트 귀걸이 가격 대비 퀄리티가 정말 좋습니다.','ACTIVE','2026-06-15 02:27:00',NULL,NULL),(28,49,807,103,5,'원석 팔찌 정말 만족스러워요! 사진이랑 실물이 똑같고 마감도 꼼꼼해서 선물용으로도 손색없을 것 같아요.','ACTIVE','2026-06-20 03:48:00',NULL,NULL),(29,50,804,104,4,'미니 진주 목걸이 이쁘고 착용감도 나쁘지 않은데, 세척 방법 안내가 좀 더 자세했으면 좋겠어요.','ACTIVE','2026-06-19 09:35:00','소중한 리뷰 남겨주셔서 감사합니다 :) 앞으로도 좋은 제품으로 보답하겠습니다!','2026-06-21 09:35:00'),(30,51,801,105,5,'핸드메이드 느낌이 물씬 나서 좋아요. 실버 링 귀걸이 착용감도 편하고 무겁지 않아서 마음에 들어요.','ACTIVE','2026-06-18 12:05:00',NULL,NULL),(31,52,807,106,5,'디자인이 너무 예뻐서 매일 착용하고 있어요. 원석 팔찌 가격 대비 퀄리티가 정말 좋습니다.','ACTIVE','2026-06-20 07:21:00',NULL,NULL),(32,53,803,107,3,'실버 하트 목걸이 사진이랑 실물 색감이 살짝 다른 것 같아요. 나쁘진 않지만 기대했던 것보다는 평범했어요.','ACTIVE','2026-06-22 19:27:00',NULL,NULL),(33,54,806,108,4,'디자인은 마음에 드는데 하트 반지 생각보다 사이즈가 작은 느낌이에요. 그래도 데일리로 착용하기 좋아요.','ACTIVE','2026-06-23 02:36:00',NULL,NULL),(34,55,802,109,5,'배송도 빠르고 플라워 드롭 귀걸이 퀄리티가 기대 이상이에요. 다른 색상도 구매하려고요.','ACTIVE','2026-06-26 05:39:00','소중한 의견 감사합니다. 다음 제작 시 꼭 반영하도록 하겠습니다.','2026-06-28 02:39:00'),(35,56,808,110,5,'디자인이 너무 예뻐서 매일 착용하고 있어요. 진주 헤어핀 가격 대비 퀄리티가 정말 좋습니다.','ACTIVE','2026-06-23 12:47:00','구매해주셔서 감사드려요! 말씀해주신 부분 참고해서 더 신경쓰겠습니다.','2026-06-25 13:47:00'),(36,57,799,111,4,'담수 진주 귀걸이 전체적으로 만족스러운데 배송이 생각보다 조금 늦었어요. 그래도 제품은 예뻐요.','ACTIVE','2026-06-24 19:04:00',NULL,NULL),(37,58,804,112,5,'미니 진주 목걸이 정말 만족스러워요! 사진이랑 실물이 똑같고 마감도 꼼꼼해서 선물용으로도 손색없을 것 같아요.','ACTIVE','2026-06-25 12:08:00',NULL,NULL),(38,59,807,113,5,'디자인이 너무 예뻐서 매일 착용하고 있어요. 원석 팔찌 가격 대비 퀄리티가 정말 좋습니다.','ACTIVE','2026-06-29 05:36:00',NULL,NULL),(39,60,803,114,5,'디자인이 너무 예뻐서 매일 착용하고 있어요. 실버 하트 목걸이 가격 대비 퀄리티가 정말 좋습니다.','ACTIVE','2026-07-02 07:31:00','소중한 의견 감사합니다. 다음 제작 시 꼭 반영하도록 하겠습니다.','2026-07-04 01:31:00'),(40,61,805,115,5,'실버 오픈링 정말 만족스러워요! 사진이랑 실물이 똑같고 마감도 꼼꼼해서 선물용으로도 손색없을 것 같아요.','ACTIVE','2026-07-02 13:09:00','소중한 의견 감사합니다. 다음 제작 시 꼭 반영하도록 하겠습니다.','2026-07-04 03:09:00'),(41,62,800,116,3,'미니 하트 귀걸이 사진이랑 실물 색감이 살짝 다른 것 같아요. 나쁘진 않지만 기대했던 것보다는 평범했어요.','ACTIVE','2026-06-29 20:10:00','소중한 리뷰 남겨주셔서 감사합니다 :) 앞으로도 좋은 제품으로 보답하겠습니다!','2026-07-01 05:10:00'),(42,63,802,117,5,'디자인이 너무 예뻐서 매일 착용하고 있어요. 플라워 드롭 귀걸이 가격 대비 퀄리티가 정말 좋습니다.','ACTIVE','2026-07-04 18:57:00','따뜻한 후기 감사합니다! 예쁘게 착용해주세요 :)','2026-07-05 17:57:00'),(43,64,804,118,5,'미니 진주 목걸이 정말 만족스러워요! 사진이랑 실물이 똑같고 마감도 꼼꼼해서 선물용으로도 손색없을 것 같아요.','ACTIVE','2026-07-05 19:05:00',NULL,NULL),(44,65,806,119,3,'하트 반지 사진이랑 실물 색감이 살짝 다른 것 같아요. 나쁘진 않지만 기대했던 것보다는 평범했어요.','ACTIVE','2026-07-02 11:29:00',NULL,NULL),(45,66,807,120,5,'원석 팔찌 정말 만족스러워요! 사진이랑 실물이 똑같고 마감도 꼼꼼해서 선물용으로도 손색없을 것 같아요.','ACTIVE','2026-07-04 03:46:00',NULL,NULL),(46,67,803,121,4,'디자인은 마음에 드는데 실버 하트 목걸이 생각보다 사이즈가 작은 느낌이에요. 그래도 데일리로 착용하기 좋아요.','ACTIVE','2026-07-08 18:32:00',NULL,NULL),(47,68,799,122,5,'핸드메이드 느낌이 물씬 나서 좋아요. 담수 진주 귀걸이 착용감도 편하고 무겁지 않아서 마음에 들어요.','ACTIVE','2026-07-05 15:18:00','소중한 의견 감사합니다. 다음 제작 시 꼭 반영하도록 하겠습니다.','2026-07-06 03:18:00'),(48,69,804,123,5,'핸드메이드 느낌이 물씬 나서 좋아요. 미니 진주 목걸이 착용감도 편하고 무겁지 않아서 마음에 들어요.','ACTIVE','2026-07-08 21:34:00','소중한 의견 감사합니다. 다음 제작 시 꼭 반영하도록 하겠습니다.','2026-07-10 20:34:00'),(49,70,809,125,3,'핸드메이드 니트 모자 배송이 예상보다 오래 걸려서 조금 아쉬웠어요. 제품 자체는 무난해요.','ACTIVE','2026-07-06 15:19:23',NULL,NULL),(50,71,819,126,5,'월넛 트레이 실물이 사진보다 훨씬 예뻐요! 마감도 꼼꼼하고 정성이 느껴져서 만족스럽습니다.','ACTIVE','2026-07-04 19:25:02','소중한 후기 남겨주셔서 감사합니다! 더 좋은 제품으로 보답할게요 :)','2026-07-06 09:25:02'),(51,72,829,127,5,'품질이 기대 이상이에요. 머그컵 이 가격에 이 퀄리티면 완전 이득인 것 같아요.','ACTIVE','2026-07-06 07:05:53','소중한 후기 남겨주셔서 감사합니다! 더 좋은 제품으로 보답할게요 :)','2026-07-07 09:05:53'),(52,73,841,128,5,'오랜만에 마음에 쏙 드는 곰돌이 키링 만난 것 같아요. 다음에 또 구매하고 싶어요.','ACTIVE','2026-07-08 03:32:29',NULL,NULL),(53,74,849,129,5,'핸드메이드 특유의 정성이 느껴지는 카드지갑이에요. 사용할 때마다 기분이 좋아져요.','ACTIVE','2026-07-06 21:21:17','소중한 후기 남겨주셔서 감사합니다! 더 좋은 제품으로 보답할게요 :)','2026-07-07 20:21:17'),(54,2,860,130,4,'가격 대비 괜찮은 숯 비누이에요. 포장 상태도 좋았고 무난하게 만족합니다.','ACTIVE','2026-07-10 06:22:31',NULL,NULL),(55,4,869,131,5,'오랜만에 마음에 쏙 드는 소이 캔들 만난 것 같아요. 다음에 또 구매하고 싶어요.','ACTIVE','2026-07-13 08:23:03',NULL,NULL),(56,6,879,132,5,'품질이 기대 이상이에요. 라벤더 디퓨저 이 가격에 이 퀄리티면 완전 이득인 것 같아요.','ACTIVE','2026-07-08 19:30:07','구매해주셔서 감사드려요. 말씀 주신 부분 꼭 참고하겠습니다!','2026-07-09 18:30:07'),(57,7,889,133,4,'캐모마일차 색감이나 디자인은 마음에 드는데, 향이 조금 진한 편이었어요.','ACTIVE','2026-07-06 13:50:31','소중한 후기 남겨주셔서 감사합니다! 더 좋은 제품으로 보답할게요 :)','2026-07-07 05:50:31'),(58,8,899,134,5,'강아지 장난감 선물로 드렸는데 반응이 정말 좋았어요! 포장까지 신경 써주셔서 감사했습니다.','ACTIVE','2026-07-10 11:06:40','따뜻한 리뷰 감사합니다 :) 오래오래 예쁘게 사용해주세요!','2026-07-11 03:06:40'),(59,9,909,135,4,'스투키 색감이나 디자인은 마음에 드는데, 향이 조금 진한 편이었어요.','ACTIVE','2026-07-09 20:04:04',NULL,NULL),(60,10,929,136,5,'배송도 생각보다 빨랐고 린넨 앞치마 상태도 완벽했어요. 강력 추천합니다!','ACTIVE','2026-07-05 22:37:31',NULL,NULL),(61,11,939,137,4,'드라이플라워 색감이나 디자인은 마음에 드는데, 향이 조금 진한 편이었어요.','ACTIVE','2026-07-09 07:10:46','소중한 후기 남겨주셔서 감사합니다! 더 좋은 제품으로 보답할게요 :)','2026-07-10 17:10:46'),(62,13,949,138,5,'핸드메이드 특유의 정성이 느껴지는 로즈 틴트이에요. 사용할 때마다 기분이 좋아져요.','ACTIVE','2026-07-08 20:28:42','구매해주셔서 감사드려요. 말씀 주신 부분 꼭 참고하겠습니다!','2026-07-10 02:28:42'),(63,40,959,139,5,'품질이 기대 이상이에요. 티 선물세트 이 가격에 이 퀄리티면 완전 이득인 것 같아요.','ACTIVE','2026-07-05 20:07:22','따뜻한 리뷰 감사합니다 :) 오래오래 예쁘게 사용해주세요!','2026-07-07 19:07:22'),(64,55,969,140,4,'가격 대비 괜찮은 감성 엽서이에요. 포장 상태도 좋았고 무난하게 만족합니다.','ACTIVE','2026-07-07 17:52:57',NULL,NULL),(65,62,979,141,3,'고양이 스티커 나쁘진 않은데 사진에서 본 것과 실물 느낌이 조금 달랐어요.','ACTIVE','2026-07-07 10:48:41','소중한 후기 남겨주셔서 감사합니다! 더 좋은 제품으로 보답할게요 :)','2026-07-08 12:48:41'),(66,48,989,142,4,'패브릭 파우치 예쁘게 잘 왔어요. 다만 생각했던 것보다 사이즈가 조금 작게 느껴졌어요.','ACTIVE','2026-07-10 21:15:20','따뜻한 리뷰 감사합니다 :) 오래오래 예쁘게 사용해주세요!','2026-07-12 11:15:20'),(67,51,815,143,5,'오랜만에 마음에 쏙 드는 실크 스카프 만난 것 같아요. 다음에 또 구매하고 싶어요.','ACTIVE','2026-07-10 01:57:31',NULL,NULL),(68,66,834,144,5,'품질이 기대 이상이에요. 찻잔 세트 이 가격에 이 퀄리티면 완전 이득인 것 같아요.','ACTIVE','2026-07-12 12:53:58',NULL,NULL);
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sellers`
--

DROP TABLE IF EXISTS `sellers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sellers` (
  `seller_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `company_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `business_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `seller_status` enum('PENDING','APPROVED','REJECTED') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'PENDING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `representative_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `opening_date` date NOT NULL,
  `business_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`seller_id`),
  UNIQUE KEY `business_number` (`business_number`),
  KEY `fk_sellers_user` (`user_id`),
  CONSTRAINT `fk_sellers_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sellers`
--

LOCK TABLES `sellers` WRITE;
/*!40000 ALTER TABLE `sellers` DISABLE KEYS */;
INSERT INTO `sellers` VALUES (28,135,'달빛공방','100-00-00135','APPROVED','2026-07-06 01:50:45','달빛공방','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(29,136,'실버스튜디오','100-00-00136','APPROVED','2026-07-06 01:50:45','실버스튜디오','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(30,137,'링메이커','100-00-00137','APPROVED','2026-07-06 01:50:45','링메이커','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(31,138,'브레이슬릿랩','100-00-00138','APPROVED','2026-07-06 01:50:45','브레이슬릿랩','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(32,139,'헤어무드','100-00-00139','APPROVED','2026-07-06 01:50:45','헤어무드','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(33,140,'뜨개공방','100-00-00140','APPROVED','2026-07-06 01:50:45','뜨개공방','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(34,141,'린넨하우스','100-00-00141','APPROVED','2026-07-06 01:50:45','린넨하우스','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(35,142,'코튼백','100-00-00142','APPROVED','2026-07-06 01:50:45','코튼백','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(36,143,'우드아틀리에','100-00-00143','APPROVED','2026-07-06 01:50:45','우드아틀리에','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(37,144,'도예공방','100-00-00144','APPROVED','2026-07-06 01:50:45','도예공방','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(38,145,'캔들공방','100-00-00145','APPROVED','2026-07-06 01:50:45','캔들공방','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(39,146,'솝스토리','100-00-00146','APPROVED','2026-07-06 01:50:45','솝스토리','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(40,147,'레더웍스','100-00-00147','APPROVED','2026-07-06 01:50:45','레더웍스','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(41,148,'페이퍼룸','100-00-00148','APPROVED','2026-07-06 01:50:45','페이퍼룸','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(42,149,'스티커팩토리','100-00-00149','APPROVED','2026-07-06 01:50:45','스티커팩토리','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(43,150,'플라워아틀리에','100-00-00150','APPROVED','2026-07-06 01:50:45','플라워아틀리에','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(44,151,'그린홈','100-00-00151','APPROVED','2026-07-06 01:50:45','그린홈','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(45,152,'키링팩토리','100-00-00152','APPROVED','2026-07-06 01:50:45','키링팩토리','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(46,153,'기프트샵','100-00-00153','APPROVED','2026-07-06 01:50:45','기프트샵','2024-01-01','서울특별시 마포구 핸드메이드로 10'),(47,154,'모자공방','100-00-00154','APPROVED','2026-07-06 01:50:45','모자공방','2024-01-01','서울특별시 마포구 핸드메이드로 10');
/*!40000 ALTER TABLE `sellers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_coupons`
--

DROP TABLE IF EXISTS `user_coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_coupons` (
  `user_coupon_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `coupon_id` bigint NOT NULL,
  `seller_id` bigint NOT NULL,
  `used_yn` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'N',
  `issued_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `used_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_coupon_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_coupons`
--

LOCK TABLES `user_coupons` WRITE;
/*!40000 ALTER TABLE `user_coupons` DISABLE KEYS */;
INSERT INTO `user_coupons` VALUES (1,1,1,1,'N','2026-06-29 05:19:17',NULL),(5,13,1,1,'Y','2026-06-29 08:21:01','2026-06-30 05:35:49');
/*!40000 ALTER TABLE `user_coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_points`
--

DROP TABLE IF EXISTS `user_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_points` (
  `user_id` int NOT NULL,
  `point_balance` int NOT NULL DEFAULT '0',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_points`
--

LOCK TABLES `user_points` WRITE;
/*!40000 ALTER TABLE `user_points` DISABLE KEYS */;
INSERT INTO `user_points` VALUES (1,22222,'2026-06-29 03:09:01'),(2,0,'2026-06-29 05:41:15'),(4,0,'2026-06-29 05:41:15'),(6,0,'2026-06-29 05:41:15'),(7,0,'2026-06-29 05:41:15'),(8,0,'2026-06-29 05:41:15'),(9,0,'2026-06-29 05:41:15'),(10,0,'2026-06-29 05:41:15'),(11,0,'2026-06-29 05:41:15'),(13,33036,'2026-06-29 07:30:45'),(14,0,'2026-07-01 00:34:34'),(15,0,'2026-07-01 00:34:34'),(16,0,'2026-07-01 00:34:34'),(17,0,'2026-07-01 00:34:34'),(18,0,'2026-07-01 00:34:34'),(19,0,'2026-07-01 00:34:34'),(20,0,'2026-07-01 00:34:34'),(21,0,'2026-07-01 00:34:34'),(22,0,'2026-07-01 00:34:34'),(23,0,'2026-07-01 00:34:34'),(24,0,'2026-07-01 00:34:34'),(25,0,'2026-07-01 00:34:34'),(26,0,'2026-07-01 00:34:34'),(27,0,'2026-07-01 00:34:34'),(28,0,'2026-07-01 00:34:34'),(29,0,'2026-07-01 00:34:34'),(30,0,'2026-07-01 00:34:34'),(31,0,'2026-07-01 00:34:34'),(32,0,'2026-07-01 00:34:34'),(33,0,'2026-07-01 00:34:34'),(34,0,'2026-07-01 00:34:34'),(35,0,'2026-07-01 00:34:34'),(36,0,'2026-07-01 00:34:34'),(37,0,'2026-07-01 00:34:34'),(38,0,'2026-07-01 00:34:34'),(39,0,'2026-07-01 00:34:34');
/*!40000 ALTER TABLE `user_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `gender` enum('male','female') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `role` enum('USER','SELLER','ADMIN') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'USER',
  `status` enum('active','suspended','withdrawn') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `nick_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `photo_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'no_file',
  `login_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `kakao_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `naver_id` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `withdrawn_at` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `login_id` (`login_id`),
  UNIQUE KEY `login_id_2` (`login_id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'seller@test.com','$2a$12$lWi2niP7XGUrbyurlLEkkukp5/wx9KzXzcQqE0CArqKE1YgdQN2o6','테스트판매자','010-1111-1111','male','SELLER','active','2026-05-28 00:22:45','2026-06-24 06:05:20','','no_file','user_1',NULL,NULL,NULL),(2,'saki','$2a$10$Zjdve/M4loiGiPuvgtMmxuHbd09CsoaVNFwPj.fpxCNrKKSXHYcYe','saki','123','male','USER','active','2026-06-09 01:47:31','2026-07-01 00:20:43','saki','no_file','user_2',NULL,NULL,NULL),(4,'123','$2a$10$fge2qMhs2ZBfRo089oWtuO59R.n3bdCXIrf5WBOP7wx.w7QkSr3um','123','123','male','USER','active','2026-06-09 01:50:43','2026-06-12 07:42:53','123','no_file','user_4',NULL,NULL,NULL),(6,'1111','$2a$10$4h4bOTVmcTl9QL8JbuJ77OZqRArjngXGJQ8jvTwk.KlyIZapmF6/e','1111','11','male','USER','active','2026-06-09 02:20:13','2026-06-12 07:42:53','1111','no_file','user_6',NULL,NULL,NULL),(7,'123123','$2a$10$ikBqDbCCzSRGc15SfaJ.FeD7uTfYJ1iKYaD523rX0aOhf4f4h/ZOO','123123','123123','male','USER','active','2026-06-09 03:36:16','2026-06-12 07:42:53','123123','no_file','user_7',NULL,NULL,NULL),(8,'123123123','$2a$10$UQ0pOSZYLhZhENCFD3iPxu1OkrjQvQ9s3mBy/3wlsl2RAwGJN.pHm','123123123','123','male','USER','active','2026-06-09 03:36:59','2026-06-12 07:42:53','123123123','no_file','user_8',NULL,NULL,NULL),(9,'0000','$2a$10$TMyMXL5X2fIkKXjg9jPfAO3GAANwbefHycw5ZxwOsfvsIVXRqy23u','0000','0000','male','USER','active','2026-06-09 05:17:37','2026-06-15 05:20:46','0000','no_file','0000',NULL,NULL,NULL),(10,'ktkim0209@daum.net','$2a$10$zJ1ack7VjLkclyuzIVh/xeMEAqoTB/SYN9dwrzsRj.JVyhGVWWg8i','김경태','01047397752','male','USER','active','2026-06-11 08:16:48','2026-06-12 07:42:53','ktkim0209','no_file','user_10',NULL,NULL,NULL),(11,'bhs425@naver.com','$2a$10$L.KtyHUUJrWjCfIAkGMUl.ReojOnyrX36r0HDbJ/H/zX0..OmU90a','1111','1111','male','USER','active','2026-06-17 00:45:49','2026-06-17 00:45:49','11111111','no_file','1111',NULL,NULL,NULL),(13,'lyw314074t@gmail.com','$2a$10$Zjdve/M4loiGiPuvgtMmxuHbd09CsoaVNFwPj.fpxCNrKKSXHYcYe','이상훈','01023950851','male','USER','active','2026-06-29 05:37:39','2026-06-29 05:37:39','lyw3140','하나미사키.webp','saki',NULL,NULL,NULL),(40,'user40@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','김민지','010-3001-0001','female','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','민지네','no_file','user01',NULL,NULL,NULL),(41,'user41@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','이준호','010-3001-0002','male','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','준호킴','no_file','user02',NULL,NULL,NULL),(42,'user42@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','박서연','010-3001-0003','female','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','서연둥이','no_file','user03',NULL,NULL,NULL),(43,'user43@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','최도윤','010-3001-0004','male','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','도윤이','no_file','user04',NULL,NULL,NULL),(44,'user44@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','정하은','010-3001-0005','female','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','하은하은','no_file','user05',NULL,NULL,NULL),(45,'user45@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','강지후','010-3001-0006','male','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','지후로그','no_file','user06',NULL,NULL,NULL),(46,'user46@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','한소율','010-3001-0007','female','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','소율소율','no_file','user07',NULL,NULL,NULL),(47,'user47@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','오시우','010-3001-0008','male','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','시우다','no_file','user08',NULL,NULL,NULL),(48,'user48@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','윤아린','010-3001-0009','female','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','아린아린','no_file','user09',NULL,NULL,NULL),(49,'user49@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','장은우','010-3001-0010','male','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','은우생활','no_file','user10',NULL,NULL,NULL),(50,'user50@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','조유나','010-3001-0011','female','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','유나노트','no_file','user11',NULL,NULL,NULL),(51,'user51@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','신도현','010-3001-0012','male','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','도현일상','no_file','user12',NULL,NULL,NULL),(52,'user52@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','임채원','010-3001-0013','female','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','채원채원','no_file','user13',NULL,NULL,NULL),(53,'user53@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','백주원','010-3001-0014','male','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','주원공방','no_file','user14',NULL,NULL,NULL),(54,'user54@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','문시은','010-3001-0015','female','USER','active','2026-07-03 08:25:56','2026-07-08 02:28:35','시은날다','no_file','user15',NULL,NULL,NULL),(55,'user55@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','서지안','010-3002-0055','female','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','서지안의공간','no_file','user16',NULL,NULL,NULL),(56,'user56@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','노태윤','010-3002-0056','male','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','노태윤의공간','no_file','user17',NULL,NULL,NULL),(57,'user57@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','배수아','010-3002-0057','female','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','배수아의공간','no_file','user18',NULL,NULL,NULL),(58,'user58@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','허준서','010-3002-0058','male','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','허준서의공간','no_file','user19',NULL,NULL,NULL),(59,'user59@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','남예은','010-3002-0059','female','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','남예은의공간','no_file','user20',NULL,NULL,NULL),(60,'user60@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','류시윤','010-3002-0060','male','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','류시윤의공간','no_file','user21',NULL,NULL,NULL),(61,'user61@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','차하윤','010-3002-0061','female','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','차하윤의공간','no_file','user22',NULL,NULL,NULL),(62,'user62@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','우준영','010-3002-0062','male','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','우준영의공간','no_file','user23',NULL,NULL,NULL),(63,'user63@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','석다은','010-3002-0063','female','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','석다은의공간','no_file','user24',NULL,NULL,NULL),(64,'user64@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','탁민재','010-3002-0064','male','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','탁민재의공간','no_file','user25',NULL,NULL,NULL),(65,'user65@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','표서율','010-3002-0065','female','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','표서율의공간','no_file','user26',NULL,NULL,NULL),(66,'user66@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','공유준','010-3002-0066','male','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','공유준의공간','no_file','user27',NULL,NULL,NULL),(67,'user67@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','길나윤','010-3002-0067','female','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','길나윤의공간','no_file','user28',NULL,NULL,NULL),(68,'user68@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','사지호','010-3002-0068','male','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','사지호의공간','no_file','user29',NULL,NULL,NULL),(69,'user69@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','설연우','010-3002-0069','female','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','설연우의공간','no_file','user30',NULL,NULL,NULL),(70,'user70@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','추건우','010-3002-0070','male','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','추건우의공간','no_file','user31',NULL,NULL,NULL),(71,'user71@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','범아윤','010-3002-0071','female','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','범아윤의공간','no_file','user32',NULL,NULL,NULL),(72,'user72@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','함태민','010-3002-0072','male','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','함태민의공간','no_file','user33',NULL,NULL,NULL),(73,'user73@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','갈서현','010-3002-0073','female','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','갈서현의공간','no_file','user34',NULL,NULL,NULL),(74,'user74@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','맹준우','010-3002-0074','male','USER','active','2026-07-03 08:30:25','2026-07-08 02:28:35','맹준우의공간','no_file','user35',NULL,NULL,NULL),(135,'seller01@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','달빛공방','01011110001','female','SELLER','active','2026-07-06 01:45:50','2026-07-08 02:28:35','달빛공방','no_file','seller01',NULL,NULL,NULL),(136,'seller02@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','실버스튜디오','01011110002','female','SELLER','active','2026-07-06 01:45:50','2026-07-08 02:28:35','실버스튜디오','no_file','seller02',NULL,NULL,NULL),(137,'seller03@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','링메이커','01011110003','female','SELLER','active','2026-07-06 01:45:50','2026-07-08 02:28:35','링메이커','no_file','seller03',NULL,NULL,NULL),(138,'seller04@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','브레이슬릿랩','01011110004','female','SELLER','active','2026-07-06 01:45:50','2026-07-08 02:28:35','브레이슬릿랩','no_file','seller04',NULL,NULL,NULL),(139,'seller05@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','헤어무드','01011110005','female','SELLER','active','2026-07-06 01:45:50','2026-07-08 02:28:35','헤어무드','no_file','seller05',NULL,NULL,NULL),(140,'seller06@test.com','$2a$12$N0DQzZ/v84eE3STIUzaNNe5k/aR666OZPLRsDtATptCQs207u8apS','뜨개공방','01011110006','female','SELLER','active','2026-07-06 01:45:50','2026-07-08 02:28:35','뜨개공방','no_file','seller06',NULL,NULL,NULL),(141,'seller07@test.com','1234','린넨하우스','01011110007','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','린넨하우스','no_file','seller07',NULL,NULL,NULL),(142,'seller08@test.com','1234','코튼백','01011110008','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','코튼백','no_file','seller08',NULL,NULL,NULL),(143,'seller09@test.com','1234','우드아틀리에','01011110009','male','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','우드아틀리에','no_file','seller09',NULL,NULL,NULL),(144,'seller10@test.com','1234','도예공방','01011110010','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','도예공방','no_file','seller10',NULL,NULL,NULL),(145,'seller11@test.com','1234','캔들공방','01011110011','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','캔들공방','no_file','seller11',NULL,NULL,NULL),(146,'seller12@test.com','1234','솝스토리','01011110012','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','솝스토리','no_file','seller12',NULL,NULL,NULL),(147,'seller13@test.com','1234','레더웍스','01011110013','male','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','레더웍스','no_file','seller13',NULL,NULL,NULL),(148,'seller14@test.com','1234','페이퍼룸','01011110014','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','페이퍼룸','no_file','seller14',NULL,NULL,NULL),(149,'seller15@test.com','1234','스티커팩토리','01011110015','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','스티커팩토리','no_file','seller15',NULL,NULL,NULL),(150,'seller16@test.com','1234','플라워아틀리에','01011110016','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','플라워아틀리에','no_file','seller16',NULL,NULL,NULL),(151,'seller17@test.com','1234','그린홈','01011110017','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','그린홈','no_file','seller17',NULL,NULL,NULL),(152,'seller18@test.com','1234','키링팩토리','01011110018','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','키링팩토리','no_file','seller18',NULL,NULL,NULL),(153,'seller19@test.com','1234','기프트샵','01011110019','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','기프트샵','no_file','seller19',NULL,NULL,NULL),(154,'seller20@test.com','1234','모자공방','01011110020','female','SELLER','active','2026-07-06 01:45:50','2026-07-06 01:45:50','모자공방','no_file','seller20',NULL,NULL,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'suje'
--
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-08 13:05:16
