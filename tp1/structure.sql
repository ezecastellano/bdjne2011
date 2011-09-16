CREATE DATABASE IF NOT EXISTS test;
USE test;
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

CREATE TABLE `ciudad` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(45) NOT NULL,
  `direccion` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_direccion` (`nombre`,`direccion`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

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

CREATE TABLE `control` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tipo` int(10) unsigned NOT NULL,
  `resultado` varchar(45) NOT NULL,
  `fecha` date NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `control_tipo_control_fk` (`tipo`),
  CONSTRAINT `control_tipo_control_fk` FOREIGN KEY (`tipo`) REFERENCES `tipo_control` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

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

CREATE TABLE `licencia` (
  `numero` int(10) unsigned NOT NULL,
  `fecha_obtencion` date NOT NULL,
  `fecha_renovacion` date NOT NULL,
  PRIMARY KEY (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `observacion` (
  `codigo` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `observacion_licencia` (
  `observaciones_codigo` int(10) unsigned NOT NULL,
  `licencia_numero` int(10) unsigned NOT NULL,
  PRIMARY KEY (`observaciones_codigo`,`licencia_numero`) USING BTREE,
  KEY `observaciones_licencia_numero` (`licencia_numero`),
  CONSTRAINT `observaciones_licencia_codigo` FOREIGN KEY (`observaciones_codigo`) REFERENCES `observacion` (`codigo`),
  CONSTRAINT `observaciones_licencia_numero` FOREIGN KEY (`licencia_numero`) REFERENCES `licencia` (`numero`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `realizacion_viaje_chofer` (
  `chofer` int(8) unsigned NOT NULL,
  `realizacion_viaje` int(10) unsigned NOT NULL,
  PRIMARY KEY (`chofer`,`realizacion_viaje`),
  KEY `realizacion_viaje_chofer_chofer_fk` (`chofer`),
  KEY `realizacion_viaje_chofer_viaje` (`realizacion_viaje`),
  CONSTRAINT `realizacion_viaje_chofer_chofer_fk` FOREIGN KEY (`chofer`) REFERENCES `chofer` (`numero_dni`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `realizacion_viaje_chofer_realizacion_viaje_fk` FOREIGN KEY (`realizacion_viaje`) REFERENCES `realizacion_viaje` (`viaje`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `tipo_contingencia` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;

CREATE TABLE `tipo_control` (
  `id` int(10) unsigned NOT NULL,
  `descripcion` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `vehiculo` (
  `patente` varchar(6) NOT NULL,
  `capacidad` int(10) unsigned NOT NULL,
  `modelo` varchar(45) NOT NULL,
  `marca` varchar(45) NOT NULL,
  `fecha_compra` date NOT NULL,
  `fecha_ingreso_taller` date DEFAULT NULL,
  PRIMARY KEY (`patente`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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

CREATE TABLE `viaje_chofer` (
  `viaje` int(10) unsigned NOT NULL,
  `chofer` int(8) unsigned NOT NULL,
  PRIMARY KEY (`viaje`,`chofer`),
  KEY `viaje_chofer_viaje_fk` (`viaje`),
  KEY `viaje_chofer_chofer_fk` (`chofer`),
  CONSTRAINT `viaje_chofer_chofer_fk` FOREIGN KEY (`chofer`) REFERENCES `chofer` (`numero_dni`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `viaje_chofer_viaje_fk` FOREIGN KEY (`viaje`) REFERENCES `viaje` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
