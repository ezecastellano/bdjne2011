DELIMITER $$
CREATE TRIGGER evitarPlanificarConCochesEnReparacion BEFORE INSERT ON viaje
  FOR EACH ROW BEGIN
    DECLARE enUso BOOLEAN;
    SELECT (fecha_ingreso_taller is null) INTO enUso FROM vehiculo v WHERE v.patente=NEW.vehiculo;
    IF NOT enUso THEN
      SET NEW.vehiculo=null;
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER evitarRealizarViajesConCochesEnReparacion BEFORE INSERT ON realizacion_viaje
  FOR EACH ROW BEGIN
    DECLARE enUso BOOLEAN;
    SELECT (fecha_ingreso_taller is null) INTO enUso FROM vehiculo v WHERE v.patente=NEW.vehiculo;
    IF NOT enUso THEN
      SET NEW.vehiculo=null;
    END IF;
END $$
DELIMITER ;
