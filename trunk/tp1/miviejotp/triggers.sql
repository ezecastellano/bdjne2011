DROP TABLE IF EXISTS `mydb`.`auditoria`;

CREATE TABLE  `mydb`.`auditoria` (
  `idauditoria` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) NOT NULL,
  `descripcion` varchar(20) DEFAULT NULL,
  `fecha_alteracion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `idmedida_nueva` int(11) DEFAULT NULL,
  `idmedida_vieja` int(11) DEFAULT NULL,
  `idnorma_nueva` int(11) DEFAULT NULL,
  `idnorma_vieja` int(11) DEFAULT NULL,
  `idtipo_nueva` int(11) DEFAULT NULL,
  `idtipo_vieja` int(11) DEFAULT NULL,
  `tipo_nuevo` enum('P','PP') DEFAULT NULL,
  `tipo_viejo` enum('P','PP') DEFAULT NULL,
  `desde_nuevo` timestamp NULL DEFAULT NULL,
  `desde_viejo` timestamp NULL DEFAULT NULL,
  `hasta_nuevo` timestamp NULL DEFAULT NULL,
  `hasta_viejo` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`idauditoria`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;


DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER  `mydb`.`medidaInsert` AFTER INSERT ON `medida` FOR EACH ROW BEGIN
	INSERT INTO auditoria (usuario, descripcion, fecha_alteracion, idmedida_nueva, idnorma_nueva, idtipo_nueva, tipo_nuevo, desde_nuevo, hasta_nuevo) VALUES (CURRENT_USER(), 'INSERT', NOW(), NEW.idmedida, NEW.idnorma, NEW.idtipo, NEW.tipo, NEW.desde, NEW.hasta);
END $$

DELIMITER ;

DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER  `mydb`.`medidaUpdate` AFTER UPDATE ON `medida` FOR EACH ROW BEGIN
	INSERT INTO auditoria (usuario, descripcion, fecha_alteracion, idmedida_nueva, idmedida_vieja, idnorma_nueva, idnorma_vieja, idtipo_nueva, idtipo_vieja, tipo_nuevo, tipo_viejo, desde_nuevo, desde_viejo, hasta_nuevo, hasta_viejo) VALUES (CURRENT_USER(), 'UPDATE', NOW(), NEW.idmedida, OLD.idmedida, NEW.idnorma, OLD.idnorma, NEW.idtipo, OLD.idtipo, NEW.tipo, OLD.tipo, NEW.desde, OLD.desde, NEW.hasta, OLD.hasta);
END $$

DELIMITER ;

DELIMITER $$

CREATE DEFINER = `root`@`localhost` TRIGGER  `mydb`.`medidaDelete` AFTER DELETE ON `medida` FOR EACH ROW BEGIN
	INSERT INTO auditoria (usuario, descripcion, fecha_alteracion, idmedida_vieja, idnorma_vieja, idtipo_vieja, tipo_viejo, desde_viejo, hasta_viejo) VALUES (CURRENT_USER(), 'DELETE', NOW(), OLD.idmedida, OLD.idnorma, OLD.idtipo, OLD.tipo, OLD.desde, OLD.hasta);
END $$

DELIMITER ;
