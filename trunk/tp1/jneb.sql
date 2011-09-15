-- MySQL dump 10.13  Distrib 5.5.13, for osx10.6 (i386)
--
-- Host: localhost    Database: jnedb
-- ------------------------------------------------------
-- Server version	5.5.13

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
-- Table structure for table `chofer`
--

DROP TABLE IF EXISTS `chofer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chofer` (
  `numero_dni` int(8) unsigned NOT NULL,
  `nombre` varchar(45) NOT NULL,
  `telefono` varchar(45) NOT NULL,
  `domicilio` varchar(45) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `licencia_numero` int(10) unsigned NOT NULL,
  PRIMARY KEY (`numero_dni`) USING BTREE,
  UNIQUE KEY `chofer_licencia_numero` (`licencia_numero`) USING BTREE,
  CONSTRAINT `chofer_licencia_numero` FOREIGN KEY (`licencia_numero`) REFERENCES `licencia` (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chofer`
--

LOCK TABLES `chofer` WRITE;
/*!40000 ALTER TABLE `chofer` DISABLE KEYS */;
INSERT INTO `chofer` VALUES (19023489,'Juan Edi','NO TIENE','Av. Olazabal 2330','1940-01-22',2319),(22222222,'Mariano Semelman','2222-2222','Av. Lomas de Zamora 123','1989-08-25',34234),(33333333,'Carolina Hadad','5555-5555','Av. Barracas','1988-12-26',879519),(34496723,'Ezequiel Castellano','3641-5555','Av. Cabildo 262','1989-04-22',675689);
/*!40000 ALTER TABLE `chofer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ciudad`
--

DROP TABLE IF EXISTS `ciudad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ciudad` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `direccion` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_direccion` (`nombre`,`direccion`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ciudad`
--

LOCK TABLES `ciudad` WRITE;
/*!40000 ALTER TABLE `ciudad` DISABLE KEYS */;
INSERT INTO `ciudad` VALUES (1,'Buenos Aires','Ciudad Universitaria,Pabellon I, Of. 234'),(2,'Córdoba','Ciudad Universitaria,Pabellon IV, Of. 10');
/*!40000 ALTER TABLE `ciudad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contingencia`
--

DROP TABLE IF EXISTS `contingencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contingencia` (
  `codigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `detalle` varchar(45) NOT NULL,
  `viaje` int(10) unsigned NOT NULL,
  `tipo` int(10) unsigned NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `contingencia_tipo_fk` (`tipo`),
  KEY `contingencia_viaje_fk` (`viaje`),
  CONSTRAINT `contingencia_viaje_fk` FOREIGN KEY (`viaje`) REFERENCES `viaje` (`id`),
  CONSTRAINT `contingencia_tipo_fk` FOREIGN KEY (`tipo`) REFERENCES `tipo_contingencia` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contingencia`
--

LOCK TABLES `contingencia` WRITE;
/*!40000 ALTER TABLE `contingencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `contingencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `control`
--

DROP TABLE IF EXISTS `control`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `control` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `chofer` int(8) unsigned NOT NULL,
  `viaje` int(10) unsigned NOT NULL,
  `tipo` int(10) unsigned NOT NULL,
  `resultado` varchar(45) NOT NULL,
  `fecha` date NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `contro_chofer_viaje` (`viaje`,`chofer`) USING BTREE,
  KEY `control_chofer_numero_dni` (`chofer`) USING BTREE,
  KEY `control_viaje_fk` (`viaje`),
  KEY `control_tipo_control_fk` (`tipo`),
  CONSTRAINT `control_tipo_control_fk` FOREIGN KEY (`tipo`) REFERENCES `tipo_control` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `control_chofer_fk` FOREIGN KEY (`chofer`) REFERENCES `chofer` (`numero_dni`),
  CONSTRAINT `control_viaje_fk` FOREIGN KEY (`viaje`) REFERENCES `viaje` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `control`
--

LOCK TABLES `control` WRITE;
/*!40000 ALTER TABLE `control` DISABLE KEYS */;
/*!40000 ALTER TABLE `control` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `control_asignacion_chofer`
--

DROP TABLE IF EXISTS `control_asignacion_chofer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `control_asignacion_chofer` (
  `control` int(10) unsigned NOT NULL,
  `chofer` int(8) unsigned NOT NULL,
  `realizacion_viaje` int(10) unsigned NOT NULL,
  PRIMARY KEY (`chofer`,`control`,`realizacion_viaje`),
  KEY `control_asignacion_chofer_chofer_fk` (`chofer`),
  KEY `control_asignacion_chofer_chofer_realizacion_viaje_fk` (`chofer`,`realizacion_viaje`),
  KEY `control_asignacion_chofer_control_fk` (`control`),
  CONSTRAINT `control_asignacion_chofer_chofer_realizacion_viaje_fk` FOREIGN KEY (`chofer`, `realizacion_viaje`) REFERENCES `realizacion_viaje_chofer` (`chofer`, `realizacion_viaje`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `control_asignacion_chofer_control_fk` FOREIGN KEY (`control`) REFERENCES `control` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `control_asignacion_chofer`
--

LOCK TABLES `control_asignacion_chofer` WRITE;
/*!40000 ALTER TABLE `control_asignacion_chofer` DISABLE KEYS */;
/*!40000 ALTER TABLE `control_asignacion_chofer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `licencia`
--

DROP TABLE IF EXISTS `licencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `licencia` (
  `numero` int(10) unsigned NOT NULL,
  `fecha_obtencion` date NOT NULL,
  `fecha_renovacion` date NOT NULL,
  PRIMARY KEY (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `licencia`
--

LOCK TABLES `licencia` WRITE;
/*!40000 ALTER TABLE `licencia` DISABLE KEYS */;
INSERT INTO `licencia` VALUES (2319,'1970-03-13','2011-03-13'),(34234,'2008-01-13','2014-01-13'),(675689,'2001-11-10','2012-11-10'),(879519,'2004-01-13','2013-01-13');
/*!40000 ALTER TABLE `licencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `observacion`
--

DROP TABLE IF EXISTS `observacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `observacion` (
  `codigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `observacion`
--

LOCK TABLES `observacion` WRITE;
/*!40000 ALTER TABLE `observacion` DISABLE KEYS */;
INSERT INTO `observacion` VALUES (1,'USA ANTEOJOS'),(2,'MENOR DE EDAD');
/*!40000 ALTER TABLE `observacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `observacion_licencia`
--

DROP TABLE IF EXISTS `observacion_licencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `observacion_licencia` (
  `observaciones_codigo` int(10) unsigned NOT NULL,
  `licencia_numero` int(10) unsigned NOT NULL,
  PRIMARY KEY (`observaciones_codigo`,`licencia_numero`) USING BTREE,
  KEY `observaciones_licencia_numero` (`licencia_numero`),
  CONSTRAINT `observaciones_licencia_codigo` FOREIGN KEY (`observaciones_codigo`) REFERENCES `observacion` (`codigo`),
  CONSTRAINT `observaciones_licencia_numero` FOREIGN KEY (`licencia_numero`) REFERENCES `licencia` (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `observacion_licencia`
--

LOCK TABLES `observacion_licencia` WRITE;
/*!40000 ALTER TABLE `observacion_licencia` DISABLE KEYS */;
INSERT INTO `observacion_licencia` VALUES (1,2319),(1,879519),(2,879519);
/*!40000 ALTER TABLE `observacion_licencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `realizacion_viaje`
--

DROP TABLE IF EXISTS `realizacion_viaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `realizacion_viaje` (
  `viaje` int(10) unsigned NOT NULL,
  `vehiculo` varchar(6) NOT NULL,
  `ruta` int(10) unsigned NOT NULL,
  `fecha_llegada` date NOT NULL,
  `fecha_partida` date NOT NULL,
  KEY `realizacion_viaje_viaje_fk` (`viaje`),
  KEY `realizacion_viaje_vehiculo_fk` (`vehiculo`),
  KEY `realizacion_viaje_ruta_fk` (`ruta`),
  CONSTRAINT `realizacion_viaje_ruta_fk` FOREIGN KEY (`ruta`) REFERENCES `ruta` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `realizacion_viaje_vehiculo_fk` FOREIGN KEY (`vehiculo`) REFERENCES `vehiculo` (`patente`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `realizacion_viaje_viaje_fk` FOREIGN KEY (`viaje`) REFERENCES `viaje` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `realizacion_viaje`
--

LOCK TABLES `realizacion_viaje` WRITE;
/*!40000 ALTER TABLE `realizacion_viaje` DISABLE KEYS */;
/*!40000 ALTER TABLE `realizacion_viaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `realizacion_viaje_chofer`
--

DROP TABLE IF EXISTS `realizacion_viaje_chofer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `realizacion_viaje_chofer` (
  `chofer` int(8) unsigned NOT NULL,
  `realizacion_viaje` int(10) unsigned NOT NULL,
  PRIMARY KEY (`chofer`,`realizacion_viaje`),
  KEY `realizacion_viaje_chofer_chofer_fk` (`chofer`),
  KEY `realizacion_viaje_chofer_viaje` (`realizacion_viaje`),
  CONSTRAINT `realizacion_viaje_chofer_chofer_fk` FOREIGN KEY (`chofer`) REFERENCES `chofer` (`numero_dni`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `realizacion_viaje_chofer_realizacion_viaje_fk` FOREIGN KEY (`realizacion_viaje`) REFERENCES `realizacion_viaje` (`viaje`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `realizacion_viaje_chofer`
--

LOCK TABLES `realizacion_viaje_chofer` WRITE;
/*!40000 ALTER TABLE `realizacion_viaje_chofer` DISABLE KEYS */;
/*!40000 ALTER TABLE `realizacion_viaje_chofer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `recorrido`
--

DROP TABLE IF EXISTS `recorrido`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `recorrido` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ciudad_hasta_id` int(10) unsigned NOT NULL,
  `ciudad_desde_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `recorridos_unicos` (`ciudad_hasta_id`,`ciudad_desde_id`),
  KEY `recorrido_ciudad_desde_fk` (`ciudad_desde_id`),
  KEY `recorrido_ciudad_hasta_fk` (`ciudad_hasta_id`),
  CONSTRAINT `recorrido_ciudad_hasta_fk` FOREIGN KEY (`ciudad_hasta_id`) REFERENCES `ciudad` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `recorrido_ciudad_desde_fk` FOREIGN KEY (`ciudad_desde_id`) REFERENCES `ciudad` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `recorrido`
--

LOCK TABLES `recorrido` WRITE;
/*!40000 ALTER TABLE `recorrido` DISABLE KEYS */;
INSERT INTO `recorrido` VALUES (1,1,2),(3,2,1);
/*!40000 ALTER TABLE `recorrido` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ruta`
--

DROP TABLE IF EXISTS `ruta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ruta` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cantidad_km` double NOT NULL,
  `cantidad_peajes` int(10) unsigned NOT NULL,
  `condiciones_camino` varchar(45) DEFAULT NULL,
  `condiciones_climaticas_periodo` varchar(150) DEFAULT NULL,
  `tiempo_estimado` time NOT NULL,
  `recorrido` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `ruta_recorrido_fk` (`recorrido`),
  CONSTRAINT `ruta_recorrido_fk` FOREIGN KEY (`recorrido`) REFERENCES `recorrido` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ruta`
--

LOCK TABLES `ruta` WRITE;
/*!40000 ALTER TABLE `ruta` DISABLE KEYS */;
INSERT INTO `ruta` VALUES (1,345.6,2,'Muy Buena.',NULL,'04:15:00',1);
/*!40000 ALTER TABLE `ruta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_contingencia`
--

DROP TABLE IF EXISTS `tipo_contingencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipo_contingencia` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_contingencia`
--

LOCK TABLES `tipo_contingencia` WRITE;
/*!40000 ALTER TABLE `tipo_contingencia` DISABLE KEYS */;
INSERT INTO `tipo_contingencia` VALUES (1,'ACCIDENTE'),(2,'RETRASO'),(3,'FALTA DE COMBUSTIBLE');
/*!40000 ALTER TABLE `tipo_contingencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_control`
--

DROP TABLE IF EXISTS `tipo_control`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipo_control` (
  `id` int(10) unsigned NOT NULL,
  `descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_control`
--

LOCK TABLES `tipo_control` WRITE;
/*!40000 ALTER TABLE `tipo_control` DISABLE KEYS */;
/*!40000 ALTER TABLE `tipo_control` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vehiculo`
--

DROP TABLE IF EXISTS `vehiculo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `vehiculo` (
  `patente` varchar(6) NOT NULL,
  `capacidad` int(10) unsigned NOT NULL,
  `modelo` varchar(45) NOT NULL,
  `marca` varchar(45) NOT NULL,
  `fecha_compra` date NOT NULL,
  `fecha_ingreso_taller` date DEFAULT NULL,
  PRIMARY KEY (`patente`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vehiculo`
--

LOCK TABLES `vehiculo` WRITE;
/*!40000 ALTER TABLE `vehiculo` DISABLE KEYS */;
INSERT INTO `vehiculo` VALUES ('BJH089',5,'FOCUS','FORD','2006-03-01',NULL),('DLT098',5,'GOL DUBLIN 3P','VOLSKWAGEN','2008-08-01',NULL);
/*!40000 ALTER TABLE `vehiculo` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `viaje`
--

DROP TABLE IF EXISTS `viaje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viaje` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `recorrido` int(10) unsigned NOT NULL,
  `vehiculo` varchar(6) NOT NULL,
  `fecha_partida_planificada` date NOT NULL,
  `fecha_llegada_planificada` date NOT NULL,
  PRIMARY KEY (`id`),
  KEY `viaje_recorrido_id` (`recorrido`),
  KEY `viaje_recorrido_fk` (`recorrido`),
  KEY `viaje_vehiculo_fk` (`vehiculo`),
  CONSTRAINT `viaje_recorrido_fk` FOREIGN KEY (`recorrido`) REFERENCES `viaje` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `viaje_vehiculo_fk` FOREIGN KEY (`vehiculo`) REFERENCES `vehiculo` (`patente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viaje`
--

LOCK TABLES `viaje` WRITE;
/*!40000 ALTER TABLE `viaje` DISABLE KEYS */;
/*!40000 ALTER TABLE `viaje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `viaje_chofer`
--

DROP TABLE IF EXISTS `viaje_chofer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `viaje_chofer` (
  `viaje` int(10) unsigned NOT NULL,
  `chofer` int(8) unsigned NOT NULL,
  PRIMARY KEY (`viaje`,`chofer`),
  KEY `viaje_chofer_viaje_fk` (`viaje`),
  KEY `viaje_chofer_chofer_fk` (`chofer`),
  CONSTRAINT `viaje_chofer_chofer_fk` FOREIGN KEY (`chofer`) REFERENCES `chofer` (`numero_dni`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `viaje_chofer_viaje_fk` FOREIGN KEY (`viaje`) REFERENCES `viaje` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `viaje_chofer`
--

LOCK TABLES `viaje_chofer` WRITE;
/*!40000 ALTER TABLE `viaje_chofer` DISABLE KEYS */;
/*!40000 ALTER TABLE `viaje_chofer` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2011-09-15  4:02:30
