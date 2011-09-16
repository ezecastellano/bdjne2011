CREATE TABLE auditoria (
  idauditoria int(11) NOT NULL AUTO_INCREMENT,
  usuario varchar(30) NOT NULL,
  descripcion varchar(20) DEFAULT NULL,
  fecha_alteracion timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  idmedida_nueva int(11) DEFAULT NULL,
  idmedida_vieja int(11) DEFAULT NULL,
  idnorma_nueva int(11) DEFAULT NULL,
  idnorma_vieja int(11) DEFAULT NULL,
  idtipo_nueva int(11) DEFAULT NULL,
  idtipo_vieja int(11) DEFAULT NULL,
  tipo_nuevo enum('P','PP') DEFAULT NULL,
  tipo_viejo enum('P','PP') DEFAULT NULL,
  desde_nuevo timestamp NULL DEFAULT NULL,
  desde_viejo timestamp NULL DEFAULT NULL,
  hasta_nuevo timestamp NULL DEFAULT NULL,
  hasta_viejo timestamp NULL DEFAULT NULL,
  PRIMARY KEY (idauditoria)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1;

CREATE TABLE `extranjero_pais-medpp` (
  idproducto int(11) NOT NULL,
  idmedida int(11) NOT NULL,
  idpais int(11) NOT NULL,
  PRIMARY KEY (idproducto,idmedida,idpais),
  KEY fk_ext_pais_medpp_1 (idproducto),
  KEY fk_ext_pais_medpp_2 (idmedida),
  KEY fk_ext_pais_medpp_3 (idpais)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE fabrica (
  idfabrica int(11) NOT NULL AUTO_INCREMENT,
  cantempleados int(11) DEFAULT NULL,
  idlocalidad int(11) DEFAULT NULL,
  PRIMARY KEY (idfabrica),
  KEY fk_fabrica_1 (idlocalidad)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE localidad (
  idlocalidad int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(45) DEFAULT NULL,
  idprovincia int(11) DEFAULT NULL,
  PRIMARY KEY (idlocalidad),
  KEY fk_localidad_1 (idprovincia)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE medida (
  idmedida int(11) NOT NULL AUTO_INCREMENT,
  idnorma int(11) DEFAULT NULL,
  idtipo int(11) DEFAULT NULL,
  tipo enum('P','PP') DEFAULT NULL,
  desde timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  hasta timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (idmedida),
  KEY fk_medida_1 (idnorma),
  KEY fk_medida_2 (idtipo)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;
DROP TRIGGER IF EXISTS `medidaInsert`;
DELIMITER //
CREATE TRIGGER `medidaInsert` AFTER INSERT ON `medida`
 FOR EACH ROW BEGIN
	INSERT INTO auditoria (usuario, descripcion, fecha_alteracion, idmedida_nueva, idnorma_nueva, idtipo_nueva, tipo_nuevo, desde_nuevo, hasta_nuevo) VALUES (CURRENT_USER(), 'INSERT', NOW(), NEW.idmedida, NEW.idnorma, NEW.idtipo, NEW.tipo, NEW.desde, NEW.hasta);
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `medidaUpdate`;
DELIMITER //
CREATE TRIGGER `medidaUpdate` AFTER UPDATE ON `medida`
 FOR EACH ROW BEGIN
	INSERT INTO auditoria (usuario, descripcion, fecha_alteracion, idmedida_nueva, idmedida_vieja, idnorma_nueva, idnorma_vieja, idtipo_nueva, idtipo_vieja, tipo_nuevo, tipo_viejo, desde_nuevo, desde_viejo, hasta_nuevo, hasta_viejo) VALUES (CURRENT_USER(), 'UPDATE', NOW(), NEW.idmedida, OLD.idmedida, NEW.idnorma, OLD.idnorma, NEW.idtipo, OLD.idtipo, NEW.tipo, OLD.tipo, NEW.desde, OLD.desde, NEW.hasta, OLD.hasta);
END
//
DELIMITER ;
DROP TRIGGER IF EXISTS `medidaDelete`;
DELIMITER //
CREATE TRIGGER `medidaDelete` AFTER DELETE ON `medida`
 FOR EACH ROW BEGIN
	INSERT INTO auditoria (usuario, descripcion, fecha_alteracion, idmedida_vieja, idnorma_vieja, idtipo_vieja, tipo_viejo, desde_viejo, hasta_viejo) VALUES (CURRENT_USER(), 'DELETE', NOW(), OLD.idmedida, OLD.idnorma, OLD.idtipo, OLD.tipo, OLD.desde, OLD.hasta);
END
//
DELIMITER ;

CREATE TABLE `medida-producto` (
  idproducto int(11) NOT NULL,
  idmedida int(11) NOT NULL,
  PRIMARY KEY (idproducto,idmedida),
  KEY fk_medida_producto_1 (idproducto),
  KEY fk_medida_producto_2 (idmedida)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE medida_por_producto (
  idmedida int(11) NOT NULL,
  PRIMARY KEY (idmedida),
  KEY fk_medida_por_producto_1 (idmedida)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE medida_por_prod_pais (
  idmedida int(11) NOT NULL,
  PRIMARY KEY (idmedida),
  KEY fk_medida_por_prod_pais_1 (idmedida)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE norma (
  idnorma int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (idnorma)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE organismo (
  idorganismo int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(45) DEFAULT NULL,
  PRIMARY KEY (idorganismo)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE pais (
  idpais int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(45) DEFAULT NULL,
  PRIMARY KEY (idpais)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE producto (
  idproducto int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(45) DEFAULT NULL,
  descripcion varchar(45) DEFAULT NULL,
  umedida varchar(8) NOT NULL,
  tipo enum('N','E') NOT NULL,
  rubro_idrubro int(11) NOT NULL,
  PRIMARY KEY (idproducto),
  KEY fk_producto_rubro (rubro_idrubro),
  KEY fk_producto_udemedida (umedida)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE producto_extranjero (
  productid int(11) NOT NULL,
  PRIMARY KEY (productid),
  KEY fk_producto_extranjero_1 (productid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE producto_nacional (
  idproducto int(11) NOT NULL,
  cantpuestos float DEFAULT NULL,
  PRIMARY KEY (idproducto),
  KEY `fk_producto nacional_1` (idproducto)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `prod_extranjero-pais` (
  idproducto int(11) NOT NULL,
  idpais int(11) NOT NULL,
  cantanual float DEFAULT NULL,
  PRIMARY KEY (idproducto,idpais),
  KEY fk_prod_extranjero_pais_1 (idproducto),
  KEY fk_prod_extranjero_pais_2 (idpais)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE prod_nacional_fabrica (
  idproducto int(11) NOT NULL,
  idfabrica int(11) NOT NULL,
  PRIMARY KEY (idproducto,idfabrica),
  KEY fk_prod_nacional_fabrica_1 (idproducto),
  KEY fk_prod_nacional_fabrica_2 (idfabrica)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE provincia (
  idprovincia int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(45) DEFAULT NULL,
  PRIMARY KEY (idprovincia)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE rubro (
  idrubro int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(45) DEFAULT NULL,
  PRIMARY KEY (idrubro)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE tipo (
  idtipo int(11) NOT NULL AUTO_INCREMENT,
  nombre varchar(45) DEFAULT NULL,
  idorganismo int(11) DEFAULT NULL,
  PRIMARY KEY (idtipo),
  KEY fk_tipo_1 (idorganismo)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

CREATE TABLE udemedida (
  udemedida varchar(8) NOT NULL,
  PRIMARY KEY (udemedida)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE usuario (
  nombreusuario char(30) NOT NULL,
  PRIMARY KEY (nombreusuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


ALTER TABLE `extranjero_pais-medpp`
  ADD CONSTRAINT fk_ext_pais_medpp_1 FOREIGN KEY (idproducto) REFERENCES producto_extranjero (productid) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT fk_ext_pais_medpp_2 FOREIGN KEY (idmedida) REFERENCES medida_por_prod_pais (idmedida) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT fk_ext_pais_medpp_3 FOREIGN KEY (idpais) REFERENCES pais (idpais) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `fabrica`
  ADD CONSTRAINT fk_fabrica_1 FOREIGN KEY (idlocalidad) REFERENCES localidad (idlocalidad) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `localidad`
  ADD CONSTRAINT fk_localidad_1 FOREIGN KEY (idprovincia) REFERENCES provincia (idprovincia) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `medida`
  ADD CONSTRAINT fk_medida_1 FOREIGN KEY (idnorma) REFERENCES norma (idnorma) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT fk_medida_2 FOREIGN KEY (idtipo) REFERENCES tipo (idtipo) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `medida-producto`
  ADD CONSTRAINT fk_medida_producto_1 FOREIGN KEY (idproducto) REFERENCES producto (idproducto) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT fk_medida_producto_2 FOREIGN KEY (idmedida) REFERENCES medida_por_producto (idmedida) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `medida_por_producto`
  ADD CONSTRAINT fk_medida_por_producto_1 FOREIGN KEY (idmedida) REFERENCES medida (idmedida) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `medida_por_prod_pais`
  ADD CONSTRAINT fk_medida_por_prod_pais_1 FOREIGN KEY (idmedida) REFERENCES medida (idmedida) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `producto`
  ADD CONSTRAINT fk_producto_rubro FOREIGN KEY (rubro_idrubro) REFERENCES rubro (idrubro) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT fk_producto_udemedida FOREIGN KEY (umedida) REFERENCES udemedida (udemedida) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `producto_extranjero`
  ADD CONSTRAINT fk_producto_extranjero_1 FOREIGN KEY (productid) REFERENCES producto (idproducto) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `producto_nacional`
  ADD CONSTRAINT `fk_producto nacional_1` FOREIGN KEY (idproducto) REFERENCES producto (idproducto) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `prod_extranjero-pais`
  ADD CONSTRAINT fk_prod_extranjero_pais_1 FOREIGN KEY (idproducto) REFERENCES producto_extranjero (productid) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT fk_prod_extranjero_pais_2 FOREIGN KEY (idpais) REFERENCES pais (idpais) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `prod_nacional_fabrica`
  ADD CONSTRAINT fk_prod_nacional_fabrica_1 FOREIGN KEY (idproducto) REFERENCES producto_nacional (idproducto) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT fk_prod_nacional_fabrica_2 FOREIGN KEY (idfabrica) REFERENCES fabrica (idfabrica) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE `tipo`
  ADD CONSTRAINT fk_tipo_1 FOREIGN KEY (idorganismo) REFERENCES organismo (idorganismo) ON DELETE NO ACTION ON UPDATE NO ACTION;
SET FOREIGN_KEY_CHECKS=1;
