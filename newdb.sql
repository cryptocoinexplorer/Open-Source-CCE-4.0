-- MySQL dump 10.13  Distrib 5.6.24, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: opensource
-- ------------------------------------------------------
-- Server version	5.6.24-0ubuntu2

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
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `address` (
  `address` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT 'Not Available',
  `balance` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `n_tx` int(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`address`),
  KEY `balance` (`balance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `block`
--

DROP TABLE IF EXISTS `block`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `block` (
  `height` mediumint(9) NOT NULL DEFAULT '-1',
  `hash` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  `nonce` bigint(20) NOT NULL DEFAULT '0',
  `bits` varchar(9) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `difficulty` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `size` mediumint(9) NOT NULL DEFAULT '0',
  `version` int(11) NOT NULL DEFAULT '0',
  `merkleroot` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `pos` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `total_fee` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `n_tx` tinyint(4) NOT NULL DEFAULT '0',
  `total_sent` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `raw` text COLLATE utf8_bin,
  PRIMARY KEY (`height`),
  KEY `hash` (`hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `block`
--

LOCK TABLES `block` WRITE;
/*!40000 ALTER TABLE `block` DISABLE KEYS */;
/*!40000 ALTER TABLE `block` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `large_tx`
--

DROP TABLE IF EXISTS `large_tx`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `large_tx` (
  `tx` varchar(65) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `amount` decimal(30,12) NOT NULL DEFAULT '0.000000000000'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `large_tx`
--

LOCK TABLES `large_tx` WRITE;
/*!40000 ALTER TABLE `large_tx` DISABLE KEYS */;
/*!40000 ALTER TABLE `large_tx` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orph_block`
--

DROP TABLE IF EXISTS `orph_block`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orph_block` (
  `height` mediumint(9) NOT NULL DEFAULT '-1',
  `hash` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `time` int(10) NOT NULL DEFAULT '0',
  `nonce` bigint(20) NOT NULL DEFAULT '0',
  `bits` varchar(9) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `difficulty` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `size` mediumint(9) NOT NULL DEFAULT '0',
  `version` int(11) NOT NULL DEFAULT '0',
  `merkleroot` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `pos` tinyint(1) NOT NULL DEFAULT '0',
  `total_fee` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `n_tx` tinyint(4) NOT NULL DEFAULT '0',
  `total_sent` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `raw` text COLLATE utf8_bin,
  KEY `hash` (`hash`),
  KEY `height` (`height`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orph_block`
--

LOCK TABLES `orph_block` WRITE;
/*!40000 ALTER TABLE `orph_block` DISABLE KEYS */;
/*!40000 ALTER TABLE `orph_block` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orph_tx_in`
--

DROP TABLE IF EXISTS `orph_tx_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orph_tx_in` (
  `tx_hash` varchar(65) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `coinbase` varchar(256) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `prev_out_hash` varchar(65) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `vout` int(4) NOT NULL DEFAULT '0',
  `asm` varchar(256) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `hex` varchar(256) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `value_in` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `address` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `height` mediumint(9) NOT NULL DEFAULT '0',
  KEY `address` (`address`),
  KEY `height` (`height`),
  KEY `tx_hash` (`tx_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orph_tx_in`
--

LOCK TABLES `orph_tx_in` WRITE;
/*!40000 ALTER TABLE `orph_tx_in` DISABLE KEYS */;
/*!40000 ALTER TABLE `orph_tx_in` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orph_tx_out`
--

DROP TABLE IF EXISTS `orph_tx_out`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orph_tx_out` (
  `tx_hash` varchar(65) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `n` int(4) NOT NULL DEFAULT '0',
  `value` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `type` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `address` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `asm` varchar(256) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `height` mediumint(9) NOT NULL DEFAULT '0',
  KEY `address` (`address`),
  KEY `height` (`height`),
  KEY `tx_hash` (`tx_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orph_tx_out`
--

LOCK TABLES `orph_tx_out` WRITE;
/*!40000 ALTER TABLE `orph_tx_out` DISABLE KEYS */;
/*!40000 ALTER TABLE `orph_tx_out` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orph_tx_raw`
--

DROP TABLE IF EXISTS `orph_tx_raw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orph_tx_raw` (
  `tx_hash` varchar(65) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `raw` mediumtext COLLATE utf8_bin,
  `decoded` mediumtext COLLATE utf8_bin NOT NULL,
  `height` mediumint(9) NOT NULL DEFAULT '-1',
  UNIQUE KEY `tx_hash` (`tx_hash`),
  KEY `height` (`height`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orph_tx_raw`
--

LOCK TABLES `orph_tx_raw` WRITE;
/*!40000 ALTER TABLE `orph_tx_raw` DISABLE KEYS */;
/*!40000 ALTER TABLE `orph_tx_raw` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peers`
--

DROP TABLE IF EXISTS `peers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `peers` (
  `IP` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `version` int(10) NOT NULL DEFAULT '0',
  `sub` varchar(32) COLLATE utf8_bin NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peers`
--

LOCK TABLES `peers` WRITE;
/*!40000 ALTER TABLE `peers` DISABLE KEYS */;
/*!40000 ALTER TABLE `peers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stats`
--

DROP TABLE IF EXISTS `stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stats` (
  `curr_net_hash` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `curr_diff` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `total_mint` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `peers` int(4) NOT NULL DEFAULT '0',
  `peer_txt` text COLLATE utf8_bin NOT NULL,
  `m_index` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`m_index`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stats`
--

LOCK TABLES `stats` WRITE;
/*!40000 ALTER TABLE `stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `top_address`
--

DROP TABLE IF EXISTS `top_address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `top_address` (
  `rank` smallint(3) NOT NULL DEFAULT '0',
  `address` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT ' Not Available',
  `balance` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `n_tx` int(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`rank`),
  KEY `rank` (`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `top_address`
--

LOCK TABLES `top_address` WRITE;
/*!40000 ALTER TABLE `top_address` DISABLE KEYS */;
/*!40000 ALTER TABLE `top_address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tx_in`
--

DROP TABLE IF EXISTS `tx_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tx_in` (
  `tx_hash` varchar(65) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `coinbase` varchar(256) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `prev_out_hash` varchar(65) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `vout` int(4) NOT NULL DEFAULT '0',
  `asm` varchar(256) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `hex` varchar(256) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `value_in` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `address` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `height` mediumint(9) NOT NULL DEFAULT '0',
  KEY `address` (`address`),
  KEY `height` (`height`),
  KEY `tx_hash` (`tx_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tx_in`
--

LOCK TABLES `tx_in` WRITE;
/*!40000 ALTER TABLE `tx_in` DISABLE KEYS */;
/*!40000 ALTER TABLE `tx_in` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tx_out`
--

DROP TABLE IF EXISTS `tx_out`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tx_out` (
  `tx_hash` varchar(65) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `n` int(4) NOT NULL DEFAULT '0',
  `value` decimal(30,12) NOT NULL DEFAULT '0.000000000000',
  `type` varchar(50) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `address` varchar(64) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `asm` varchar(256) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `height` mediumint(9) NOT NULL DEFAULT '0',
  KEY `address` (`address`),
  KEY `height` (`height`),
  KEY `tx_hash` (`tx_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tx_out`
--

LOCK TABLES `tx_out` WRITE;
/*!40000 ALTER TABLE `tx_out` DISABLE KEYS */;
/*!40000 ALTER TABLE `tx_out` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tx_raw`
--

DROP TABLE IF EXISTS `tx_raw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tx_raw` (
  `tx_hash` varchar(65) COLLATE utf8_bin NOT NULL DEFAULT '0',
  `raw` mediumtext COLLATE utf8_bin,
  `decoded` mediumtext COLLATE utf8_bin NOT NULL,
  `height` mediumint(9) NOT NULL DEFAULT '-1',
  UNIQUE KEY `tx_hash` (`tx_hash`),
  KEY `height` (`height`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tx_raw`
--

LOCK TABLES `tx_raw` WRITE;
/*!40000 ALTER TABLE `tx_raw` DISABLE KEYS */;
/*!40000 ALTER TABLE `tx_raw` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-05-29 14:19:41
