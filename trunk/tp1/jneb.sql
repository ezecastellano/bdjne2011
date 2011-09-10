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
-- Create schema jnedb
--

CREATE DATABASE IF NOT EXISTS jnedb;
USE jnedb;

--
-- Definition of table `chofer`
--

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

--
-- Dumping data for table `chofer`
--
INSERT INTO `chofer` (`numero_dni`,`nombre`,`telefono`,`domicilio`,`fecha_nacimiento`,`licencia_numero`) VALUES 
 (19023489,'Juan Edi','NO TIENE','Av. Olazabal 2330','1940-01-22',2319),
 (22222222,'Mariano Semelman','2222-2222','Av. Lomas de Zamora 123','1989-08-25',34234),
 (33333333,'Carolina Hadad','5555-5555','Av. Barracas','1988-12-26',879519),
 (34496723,'Ezequiel Castellano','3641-5555','Av. Cabildo 262','1989-04-22',675689);

--
-- Definition of table `ciudad`
--

DROP TABLE IF EXISTS `ciudad`;
CREATE TABLE `ciudad` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `direccion` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_direccion` (`nombre`,`direccion`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ciudad`
--
INSERT INTO `ciudad` (`id`,`nombre`,`direccion`) VALUES 
 (1,'Buenos Aires','Ciudad Universitaria,Pabellon I, Of. 234'),
 (2,'Córdoba','Ciudad Universitaria,Pabellon IV, Of. 10');

--
-- Definition of table `contingencia`
--

DROP TABLE IF EXISTS `contingencia`;
CREATE TABLE `contingencia` (
  `codigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `contingencia`
--
INSERT INTO `contingencia` (`codigo`,`descripcion`) VALUES 
 (1,'PINCHO NEUMÁTICO'),
 (2,'FALLA MOTOR'),
 (3,'FALTA COMBUSTIBLE'),
 (4,'ROBO A MANO ARMADA'),
 (5,'MALAS CONDICIONES CLIMATICAS');

--
-- Definition of table `control`
--

DROP TABLE IF EXISTS `control`;
CREATE TABLE `control` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo` varchar(45) NOT NULL,
  `resultado` varchar(45) NOT NULL,
  `fecha` date NOT NULL,
  `chofer_numero_dni` int(8) unsigned NOT NULL,
  `viaje_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `contro_chofer_viaje` (`viaje_id`,`chofer_numero_dni`) USING BTREE,
  KEY `control_chofer_numero_dni` (`chofer_numero_dni`) USING BTREE,
  CONSTRAINT `control_chofer_numero_dni` FOREIGN KEY (`chofer_numero_dni`) REFERENCES `chofer` (`numero_dni`),
  CONSTRAINT `control_viaje_id` FOREIGN KEY (`viaje_id`) REFERENCES `viaje` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `control`
--

--
-- Definition of table `licencia`
--

DROP TABLE IF EXISTS `licencia`;
CREATE TABLE `licencia` (
  `numero` int(10) unsigned NOT NULL,
  `fecha_obtencion` date NOT NULL,
  `fecha_renovacion` date NOT NULL,
  PRIMARY KEY (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `licencia`
--
INSERT INTO `licencia` (`numero`,`fecha_obtencion`,`fecha_renovacion`) VALUES 
 (2319,'1970-03-13','2011-03-13'),
 (34234,'2008-01-13','2014-01-13'),
 (675689,'2001-11-10','2012-11-10'),
 (879519,'2004-01-13','2013-01-13');

--
-- Definition of table `observaciones`
--

DROP TABLE IF EXISTS `observaciones`;
CREATE TABLE `observaciones` (
  `codigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `observaciones`
--
INSERT INTO `observaciones` (`codigo`,`descripcion`) VALUES 
 (1,'USA ANTEOJOS'),
 (2,'MENOR DE EDAD');

--
-- Definition of table `observaciones_licencia`
--

DROP TABLE IF EXISTS `observaciones_licencia`;
CREATE TABLE `observaciones_licencia` (
  `observaciones_codigo` int(10) unsigned NOT NULL,
  `licencia_numero` int(10) unsigned NOT NULL,
  PRIMARY KEY (`observaciones_codigo`,`licencia_numero`) USING BTREE,
  KEY `observaciones_licencia_numero` (`licencia_numero`),
  CONSTRAINT `observaciones_licencia_numero` FOREIGN KEY (`licencia_numero`) REFERENCES `licencia` (`numero`),
  CONSTRAINT `observaciones_licencia_codigo` FOREIGN KEY (`observaciones_codigo`) REFERENCES `observaciones` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `observaciones_licencia`
--
INSERT INTO `observaciones_licencia` (`observaciones_codigo`,`licencia_numero`) VALUES 
 (1,2319),
 (1,879519),
 (2,879519);

--
-- Definition of table `periodoanio`
--

DROP TABLE IF EXISTS `periodoanio`;
CREATE TABLE `periodoanio` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `periodoanio`
--
INSERT INTO `periodoanio` (`id`,`nombre`) VALUES 
 (1,'OTOÑO'),
 (2,'PRIMAVERA'),
 (3,'VERANO'),
 (4,'INVIERNO');

--
-- Definition of table `recorrido`
--

DROP TABLE IF EXISTS `recorrido`;
CREATE TABLE `recorrido` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ciudad_hasta_id` int(10) unsigned NOT NULL,
  `ciudad_desde_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `recorridos_unicos` (`ciudad_hasta_id`,`ciudad_desde_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `recorrido`
--
INSERT INTO `recorrido` (`id`,`ciudad_hasta_id`,`ciudad_desde_id`) VALUES 
 (1,1,2);

--
-- Definition of table `recorrido_ruta`
--

DROP TABLE IF EXISTS `recorrido_ruta`;
CREATE TABLE `recorrido_ruta` (
  `recorrido_id` int(10) unsigned NOT NULL,
  `ruta_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`recorrido_id`,`ruta_id`),
  KEY `FK_recorrido_ruta_idruta` (`ruta_id`),
  CONSTRAINT `FK_recorrido_ruta_idruta` FOREIGN KEY (`ruta_id`) REFERENCES `ruta` (`id`),
  CONSTRAINT `FK_recorrido_ruta_recorridoid` FOREIGN KEY (`recorrido_id`) REFERENCES `recorrido` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `recorrido_ruta`
--
INSERT INTO `recorrido_ruta` (`recorrido_id`,`ruta_id`) VALUES 
 (1,1);

--
-- Definition of table `ruta`
--

DROP TABLE IF EXISTS `ruta`;
CREATE TABLE `ruta` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `cantidad_km` double NOT NULL,
  `cantidad_peajes` int(10) unsigned NOT NULL,
  `condiciones_camino` varchar(45) NOT NULL,
  `tiempo_estimado` time NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ruta`
--
INSERT INTO `ruta` (`id`,`cantidad_km`,`cantidad_peajes`,`condiciones_camino`,`tiempo_estimado`) VALUES 
 (1,345.6,2,'Muy Buena.','04:15:00');

--
-- Definition of table `ruta_periodoanio`
--

DROP TABLE IF EXISTS `ruta_periodoanio`;
CREATE TABLE `ruta_periodoanio` (
  `periodoanio_id` int(10) unsigned NOT NULL,
  `ruta_id` int(10) unsigned NOT NULL,
  `condiciones_climaticas` varchar(45) NOT NULL,
  PRIMARY KEY (`periodoanio_id`,`ruta_id`),
  KEY `FK_ruta_periodoanio_ruta_id` (`ruta_id`),
  CONSTRAINT `FK_ruta_periodoanio_ruta_id` FOREIGN KEY (`ruta_id`) REFERENCES `ruta` (`id`),
  CONSTRAINT `FK_ruta_periodoanio_periodoanio_id` FOREIGN KEY (`periodoanio_id`) REFERENCES `periodoanio` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ruta_periodoanio`
--
INSERT INTO `ruta_periodoanio` (`periodoanio_id`,`ruta_id`,`condiciones_climaticas`) VALUES 
 (2,1,'LLUVIAS FUERTES.'),
 (4,1,'NIEVE EN RUTA.');

--
-- Definition of table `vehiculo`
--

DROP TABLE IF EXISTS `vehiculo`;
CREATE TABLE `vehiculo` (
  `patente` varchar(6) NOT NULL,
  `capacidad` int(10) unsigned NOT NULL,
  `modelo` varchar(45) NOT NULL,
  `marca` varchar(45) NOT NULL,
  `estado` varchar(45) NOT NULL,
  `fecha_compra` date NOT NULL,
  PRIMARY KEY (`patente`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vehiculo`
--
INSERT INTO `vehiculo` (`patente`,`capacidad`,`modelo`,`marca`,`estado`,`fecha_compra`) VALUES 
 ('BJH089',5,'FOCUS','FORD','BUENO.','2006-03-01'),
 ('DLT098',5,'GOL DUBLIN 3P','VOLSKWAGEN','BUENO.','2008-08-01');

--
-- Definition of table `vehiculoenreparacion`
--

DROP TABLE IF EXISTS `vehiculoenreparacion`;
CREATE TABLE `vehiculoenreparacion` (
  `patente` varchar(6) NOT NULL,
  `fecha_ingres_taller` date NOT NULL,
  PRIMARY KEY (`patente`),
  CONSTRAINT `FK_VehiculoEnReparacion_vehiculo_patente` FOREIGN KEY (`patente`) REFERENCES `vehiculo` (`patente`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vehiculoenreparacion`
--
INSERT INTO `vehiculoenreparacion` (`patente`,`fecha_ingres_taller`) VALUES 
 ('DLT098','2011-08-01');

--
-- Definition of table `vehiculoenuso`
--

DROP TABLE IF EXISTS `vehiculoenuso`;
CREATE TABLE `vehiculoenuso` (
  `patente` varchar(6) NOT NULL,
  PRIMARY KEY (`patente`),
  CONSTRAINT `FK_VehiculoEnUso_vehiculo_id` FOREIGN KEY (`patente`) REFERENCES `vehiculo` (`patente`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `vehiculoenuso`
--

--
-- Definition of table `viaje`
--

DROP TABLE IF EXISTS `viaje`;
CREATE TABLE `viaje` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `recorrido_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `viaje_recorrido_id` (`recorrido_id`),
  CONSTRAINT `viaje_recorrido_id` FOREIGN KEY (`recorrido_id`) REFERENCES `viaje` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;

--
-- Dumping data for table `viaje`
--
INSERT INTO `viaje` (`id`,`recorrido_id`) VALUES 
 (1,1);

--
-- Definition of table `viaje_contingencia`
--

DROP TABLE IF EXISTS `viaje_contingencia`;
CREATE TABLE `viaje_contingencia` (
  `viaje_id` int(10) unsigned NOT NULL,
  `contingencia_codigo` int(10) unsigned NOT NULL,
  PRIMARY KEY (`viaje_id`,`contingencia_codigo`) USING BTREE,
  KEY `viaje_contingencia_codigo` (`contingencia_codigo`),
  CONSTRAINT `contingencia_viaje_id` FOREIGN KEY (`viaje_id`) REFERENCES `viaje` (`id`),
  CONSTRAINT `viaje_contingencia_codigo` FOREIGN KEY (`contingencia_codigo`) REFERENCES `contingencia` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `viaje_contingencia`
--
INSERT INTO `viaje_contingencia` (`viaje_id`,`contingencia_codigo`) VALUES 
 (1,3),
 (1,5);



/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
