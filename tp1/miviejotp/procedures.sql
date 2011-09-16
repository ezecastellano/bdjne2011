CREATE PROCEDURE `mydb`.`prodMasMC`()
BEGIN
SELECT  p.nombre
	FROM
	producto p,
	(SELECT idproducto, count(*) as cantidad
		FROM
		((SELECT idproducto,idmedida FROM `medida-producto`) UNION ALL (SELECT idproducto,idmedida FROM `extranjero_pais-medpp`)) a, medida c
			WHERE  a.idmedida = c.idmedida AND CURRENT_TIMESTAMP between c.desde and c.hasta
			GROUP BY idproducto) b,
	(SELECT MAX(cantidad) maximo FROM 
		(SELECT idproducto, count(*) as cantidad
			FROM
			((SELECT idproducto,idmedida FROM `medida-producto`) UNION ALL (SELECT idproducto,idmedida FROM `extranjero_pais-medpp`)) a, medida c
				WHERE  a.idmedida = c.idmedida AND CURRENT_TIMESTAMP between c.desde and c.hasta
				GROUP BY idproducto) b) n
		WHERE p.idproducto = b.idproducto and n.maximo=b.cantidad;
END

CREATE PROCEDURE `mydb`.`prodTodasMC`()
BEGIN
	SELECT  p.nombre FROM
		producto p,
		(SELECT DISTINCT idproducto, idtipo 
		 FROM
		 ((SELECT idproducto,idmedida FROM `medida-producto`) UNION ALL (SELECT idproducto,idmedida FROM `extranjero_pais-medpp`)) a, medida c 
		 WHERE  a.idmedida = c.idmedida AND CURRENT_TIMESTAMP between c.desde and c.hasta
		)  b
	WHERE p.idproducto = b.idproducto
	GROUP BY b.idproducto
	HAVING COUNT(*) = (select COUNT(idtipo) from tipo);
END

CREATE PROCEDURE `mydb`.`medidasPorRubro`()
BEGIN
	SELECT r.idrubro, r.nombre, medidasxrubro.cant_medidas
	FROM rubro r
	LEFT JOIN (
		SELECT p.rubro_idrubro, count(*) cant_medidas
		FROM producto p
		JOIN `medida-producto` m
		ON m.idproducto = p.idproducto
		GROUP BY p.rubro_idrubro
	) AS medidasxrubro
	ON r.idrubro = medidasxrubro.rubro_idrubro;
END
