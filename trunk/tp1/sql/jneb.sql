-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.5.11


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


--
-- Create schema test
--

CREATE DATABASE IF NOT EXISTS test;
USE test;

DROP TABLE IF EXISTS `chofer`;
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
INSERT INTO `chofer` (`numero_dni`,`nombre`,`telefono`,`domicilio`,`fecha_nacimiento`,`licencia_numero`) VALUES 
 (19023489,'Juan Edi','NO TIENE','Av. Olazabal 2330','1940-01-22',2319),
 (22222222,'Mariano Semelman','2222-2222','Av. Lomas de Zamora 123','1989-08-25',34234),
 (33333333,'Carolina Hadad','5555-5555','Av. Barracas','1988-12-26',879519),
 (34496723,'Ezequiel Castellano','3641-5555','Av. Cabildo 262','1989-04-22',675689);

DROP TABLE IF EXISTS `ciudad`;
CREATE TABLE `ciudad` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `direccion` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_direccion` (`nombre`,`direccion`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;
INSERT INTO `ciudad` (`id`,`nombre`,`direccion`) VALUES 
 (1,'Buenos Aires','Ciudad Universitaria,Pabellon I, Of. 234'),
 (3,'Cancún','Playa JNE'),
 (2,'Córdoba','Ciudad Universitaria,Pabellon IV, Of. 10'),
 (4,'La pedrera','Camping 2'),
 (5,'Ushuaia','Cabo del fin del mundo');

DROP TABLE IF EXISTS `contingencia`;
CREATE TABLE `contingencia` (
  `codigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `detalle` varchar(45) NOT NULL,
  `viaje` int(10) unsigned NOT NULL,
  `tipo` int(10) unsigned NOT NULL,
  PRIMARY KEY (`codigo`),
  KEY `contingencia_tipo_fk` (`tipo`),
  KEY `contingencia_viaje_fk` (`viaje`),
  CONSTRAINT `contingencia_tipo_fk` FOREIGN KEY (`tipo`) REFERENCES `tipo_contingencia` (`id`),
  CONSTRAINT `contingencia_viaje_fk` FOREIGN KEY (`viaje`) REFERENCES `viaje` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `control`;
CREATE TABLE `control` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo` int(10) unsigned NOT NULL,
  `resultado` varchar(45) NOT NULL,
  `fecha` date NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `control_tipo_control_fk` (`tipo`),
  CONSTRAINT `control_tipo_control_fk` FOREIGN KEY (`tipo`) REFERENCES `tipo_control` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
INSERT INTO `control` (`id`,`tipo`,`resultado`,`fecha`) VALUES 
 (1,1,'NEGATIVO','2008-11-05'),
 (2,2,'POSITIVO','2011-10-10'),
 (3,3,'NEGATIVO','2011-01-01');

DROP TABLE IF EXISTS `control_asignacion_chofer`;
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
INSERT INTO `control_asignacion_chofer` (`control`,`chofer`,`realizacion_viaje`) VALUES 
 (3,33333333,4),
 (1,34496723,6),
 (2,34496723,6);

DROP TABLE IF EXISTS `licencia`;
CREATE TABLE `licencia` (
  `numero` int(10) unsigned NOT NULL,
  `fecha_obtencion` date NOT NULL,
  `fecha_renovacion` date NOT NULL,
  PRIMARY KEY (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO `licencia` (`numero`,`fecha_obtencion`,`fecha_renovacion`) VALUES 
 (2319,'1970-03-13','2011-03-13'),
 (34234,'2008-01-13','2014-01-13'),
 (675689,'2001-11-10','2012-11-10'),
 (879519,'2004-01-13','2013-01-13');

DROP TABLE IF EXISTS `observacion`;
CREATE TABLE `observacion` (
  `codigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
INSERT INTO `observacion` (`codigo`,`descripcion`) VALUES 
 (1,'USA ANTEOJOS'),
 (2,'MENOR DE EDAD');

DROP TABLE IF EXISTS `observacion_licencia`;
CREATE TABLE `observacion_licencia` (
  `observaciones_codigo` int(10) unsigned NOT NULL,
  `licencia_numero` int(10) unsigned NOT NULL,
  PRIMARY KEY (`observaciones_codigo`,`licencia_numero`) USING BTREE,
  KEY `observaciones_licencia_numero` (`licencia_numero`),
  CONSTRAINT `observaciones_licencia_codigo` FOREIGN KEY (`observaciones_codigo`) REFERENCES `observacion` (`codigo`),
  CONSTRAINT `observaciones_licencia_numero` FOREIGN KEY (`licencia_numero`) REFERENCES `licencia` (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO `observacion_licencia` (`observaciones_codigo`,`licencia_numero`) VALUES 
 (1,2319),
 (1,879519),
 (2,879519);

DROP TABLE IF EXISTS `realizacion_viaje`;
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
INSERT INTO `realizacion_viaje` (`viaje`,`vehiculo`,`ruta`,`fecha_llegada`,`fecha_partida`) VALUES 
 (3,'CAS133',4,'2010-10-10','2010-10-09'),
 (6,'JNE011',5,'2011-11-10','2011-11-15'),
 (5,'JNE011',11,'2011-01-10','2011-01-15'),
 (4,'DLT098',3,'2011-01-10','2011-01-15');

DROP TABLE IF EXISTS `realizacion_viaje_chofer`;
CREATE TABLE `realizacion_viaje_chofer` (
  `chofer` int(8) unsigned NOT NULL,
  `realizacion_viaje` int(10) unsigned NOT NULL,
  PRIMARY KEY (`chofer`,`realizacion_viaje`),
  KEY `realizacion_viaje_chofer_chofer_fk` (`chofer`),
  KEY `realizacion_viaje_chofer_viaje` (`realizacion_viaje`),
  CONSTRAINT `realizacion_viaje_chofer_chofer_fk` FOREIGN KEY (`chofer`) REFERENCES `chofer` (`numero_dni`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `realizacion_viaje_chofer_realizacion_viaje_fk` FOREIGN KEY (`realizacion_viaje`) REFERENCES `realizacion_viaje` (`viaje`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO `realizacion_viaje_chofer` (`chofer`,`realizacion_viaje`) VALUES 
 (22222222,5),
 (33333333,4),
 (34496723,3),
 (34496723,6);

DROP TABLE IF EXISTS `recorrido`;
CREATE TABLE `recorrido` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ciudad_hasta_id` int(10) unsigned NOT NULL,
  `ciudad_desde_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `recorridos_unicos` (`ciudad_hasta_id`,`ciudad_desde_id`),
  KEY `recorrido_ciudad_desde_fk` (`ciudad_desde_id`),
  KEY `recorrido_ciudad_hasta_fk` (`ciudad_hasta_id`),
  CONSTRAINT `recorrido_ciudad_desde_fk` FOREIGN KEY (`ciudad_desde_id`) REFERENCES `ciudad` (`id`),
  CONSTRAINT `recorrido_ciudad_hasta_fk` FOREIGN KEY (`ciudad_hasta_id`) REFERENCES `ciudad` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
INSERT INTO `recorrido` (`id`,`ciudad_hasta_id`,`ciudad_desde_id`) VALUES 
 (1,1,2),
 (2,1,3),
 (4,1,4),
 (5,1,5),
 (3,2,1),
 (7,2,4),
 (6,5,3);

DROP TABLE IF EXISTS `ruta`;
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;
INSERT INTO `ruta` (`id`,`cantidad_km`,`cantidad_peajes`,`condiciones_camino`,`condiciones_climaticas_periodo`,`tiempo_estimado`,`recorrido`) VALUES 
 (1,345.6,2,'Muy Buena.','','04:15:00',1),
 (2,120.6,2,'Mala.','','02:15:00',1),
 (3,120.6,2,'Excelente.','','01:12:00',3),
 (4,1400.6,2,'Excelente.','','00:10:00',2),
 (5,1500.6,2,'Excelente.','','42:10:00',2),
 (6,1500.6,2,'Mala.','','12:10:00',4),
 (7,1100.6,2,'Mala.','','12:10:00',6),
 (8,1100.6,2,'Normal.','','11:10:00',6),
 (9,110.6,2,'Buena.','','01:10:00',7),
 (10,102.6,2,'Buena.','','05:10:00',6),
 (11,102.6,2,'Buena.','','05:10:00',5);

DROP TABLE IF EXISTS `tipo_contingencia`;
CREATE TABLE `tipo_contingencia` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
INSERT INTO `tipo_contingencia` (`id`,`descripcion`) VALUES 
 (1,'ACCIDENTE'),
 (2,'RETRASO'),
 (3,'FALTA DE COMBUSTIBLE');

DROP TABLE IF EXISTS `tipo_control`;
CREATE TABLE `tipo_control` (
  `id` int(10) unsigned NOT NULL,
  `descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO `tipo_control` (`id`,`descripcion`) VALUES 
 (1,'ALCHOLEMIA'),
 (2,'ESTADO FISICO'),
 (3,'DROGAS');

DROP TABLE IF EXISTS `vehiculo`;
CREATE TABLE `vehiculo` (
  `patente` varchar(6) NOT NULL,
  `capacidad` int(10) unsigned NOT NULL,
  `modelo` varchar(45) NOT NULL,
  `marca` varchar(45) NOT NULL,
  `fecha_compra` date NOT NULL,
  `fecha_ingreso_taller` date DEFAULT NULL,
  PRIMARY KEY (`patente`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO `vehiculo` (`patente`,`capacidad`,`modelo`,`marca`,`fecha_compra`,`fecha_ingreso_taller`) VALUES 
 ('BJH089',5,'FOCUS','FORD','2006-03-01','2011-08-15'),
 ('BLA123',5,'19','RENAULT','2009-04-01',NULL),
 ('CAS133',20,'Trafic','RENAULT','2011-01-01',NULL),
 ('DLT098',5,'GOL DUBLIN 3P','VOLSKWAGEN','2008-08-01',NULL),
 ('JNE011',8,'806','VOLSKWAGEN','2010-01-01',NULL);

DROP TABLE IF EXISTS `viaje`;
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
  CONSTRAINT `viaje_recorrido_fk` FOREIGN KEY (`recorrido`) REFERENCES `recorrido` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `viaje_vehiculo_fk` FOREIGN KEY (`vehiculo`) REFERENCES `vehiculo` (`patente`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;
INSERT INTO `viaje` (`id`,`recorrido`,`vehiculo`,`fecha_partida_planificada`,`fecha_llegada_planificada`) VALUES 
 (1,1,'DLT098','2011-10-09','2011-10-12'),
 (2,1,'BLA123','2012-11-01','2012-11-02'),
 (3,2,'BLA123','2008-11-01','2009-11-02'),
 (4,3,'DLT098','2010-11-01','2011-07-02'),
 (5,5,'JNE011','2011-09-01','2011-09-02'),
 (6,2,'JNE011','2011-09-01','2011-09-02');

DROP TABLE IF EXISTS `viaje_chofer`;
CREATE TABLE `viaje_chofer` (
  `viaje` int(10) unsigned NOT NULL,
  `chofer` int(8) unsigned NOT NULL,
  PRIMARY KEY (`viaje`,`chofer`),
  KEY `viaje_chofer_viaje_fk` (`viaje`),
  KEY `viaje_chofer_chofer_fk` (`chofer`),
  CONSTRAINT `viaje_chofer_chofer_fk` FOREIGN KEY (`chofer`) REFERENCES `chofer` (`numero_dni`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `viaje_chofer_viaje_fk` FOREIGN KEY (`viaje`) REFERENCES `viaje` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
INSERT INTO `viaje_chofer` (`viaje`,`chofer`) VALUES 
 (1,19023489),
 (2,19023489),
 (2,33333333),
 (3,33333333),
 (4,22222222),
 (4,34496723),
 (5,19023489),
 (5,34496723),
 (6,22222222);

DROP PROCEDURE IF EXISTS `choferesQueManejaronTodosLosNuevos`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `choferesQueManejaronTodosLosNuevos`()
BEGIN

DECLARE cantidad INT(8) DEFAULT 0;
SELECT count(*) INTO cantidad FROM vehiculo WHERE fecha_compra > DATE_SUB(CURDATE(),INTERVAL 2 YEAR);
SELECT c.* FROM chofer c
LEFT JOIN realizacion_viaje_chofer rvc
          LEFT JOIN realizacion_viaje rv
          ON rv.viaje = rvc.realizacion_viaje
ON rvc.chofer=c.numero_dni
GROUP BY c.numero_dni
HAVING count(distinct rv.vehiculo) = cantidad;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

DROP PROCEDURE IF EXISTS `recorridosConTodasRutasUsadas`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `recorridosConTodasRutasUsadas`()
BEGIN

SELECT re.* FROM recorrido re
LEFT JOIN ruta ru
          LEFT JOIN realizacion_viaje rv
          ON ru.id = rv.ruta
ON ru.recorrido=re.id
WHERE DATE_SUB(CURDATE(),INTERVAL 1 YEAR) < rv.fecha_partida
GROUP BY re.id
HAVING count(ru.id)>1 and count(ru.id) = count(rv.ruta);

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;

DROP PROCEDURE IF EXISTS `viajesRealizadosYEstadoPorVehiculo`;

DELIMITER $$

/*!50003 SET @TEMP_SQL_MODE=@@SQL_MODE, SQL_MODE='STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `viajesRealizadosYEstadoPorVehiculo`()
BEGIN

SELECT v.patente patente,
       count(r.viaje) /  (1 + YEAR(CURRENT_DATE()) - YEAR(fecha_compra)) viajesPromedio,
       IF(fecha_ingreso_taller is null,false, true) enReparacion
FROM vehiculo v
LEFT JOIN realizacion_viaje r
     ON r.vehiculo = v.patente
GROUP BY v.patente;

END $$
/*!50003 SET SESSION SQL_MODE=@TEMP_SQL_MODE */  $$

DELIMITER ;



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
