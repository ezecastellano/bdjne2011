DELIMITER $$

DROP PROCEDURE IF EXISTS `recorridosConTodasRutasUsadas` $$
CREATE PROCEDURE `recorridosConTodasRutasUsadas`()
BEGIN

SELECT re.* FROM recorrido re
LEFT JOIN ruta ru
          LEFT JOIN realizacion_viaje rv
          ON ru.id = rv.ruta
ON ru.recorrido=re.id
WHERE DATE_SUB(CURDATE(),INTERVAL 1 YEAR) < rv.fecha_partida
GROUP BY re.id
HAVING count(ru.id)>1 and count(ru.id) = count(DISTINCT rv.ruta);

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `choferesQueManejaronTodosLosNuevos` $$
CREATE PROCEDURE `choferesQueManejaronTodosLosNuevos`()
BEGIN

DECLARE cantidad INT(8) DEFAULT 0;
SELECT count(*) INTO cantidad FROM vehiculo WHERE fecha_compra > DATE_SUB(CURDATE(),INTERVAL 2 YEAR);
SELECT c.* FROM chofer c
LEFT JOIN realizacion_viaje_chofer rvc
          LEFT JOIN realizacion_viaje rv
          ON rv.viaje = rvc.realizacion_viaje
          LEFT JOIN vehiculo v ON
                v.patente = rv.vehiculo
ON rvc.chofer=c.numero_dni
WHERE v.fecha_compra > DATE_SUB(CURDATE(),INTERVAL 2 YEAR)
GROUP BY c.numero_dni
HAVING count(distinct rv.vehiculo) = cantidad;

END $$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS `viajesRealizadosYEstadoPorVehiculo` $$
CREATE PROCEDURE `viajesRealizadosYEstadoPorVehiculo`()
BEGIN

SELECT v.patente patente,
       count(r.viaje) /  (1 + YEAR(CURRENT_DATE()) - YEAR(fecha_compra)) viajesPromedio,
       IF(fecha_ingreso_taller is null,false, true) enReparacion
FROM vehiculo v
LEFT JOIN realizacion_viaje r
     ON r.vehiculo = v.patente
GROUP BY v.patente;

END $$

DELIMITER ;
