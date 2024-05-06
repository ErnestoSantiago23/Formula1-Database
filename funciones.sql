-- Función para Obtener ID de Piloto --
DELIMITER //
CREATE FUNCTION ObtenerIdPiloto(nombrePiloto VARCHAR(255))
RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE idPiloto INT;
    -- Buscar el ID del piloto por su nombre completo (forename + ' ' + surname)
    SELECT driverId INTO idPiloto
    FROM Pilotos
    WHERE CONCAT(forename, ' ', surname) = nombrePiloto
    LIMIT 1;    
    -- Devolver el ID del piloto
    RETURN idPiloto;
END //
DELIMITER ;


-- Obtención de total de puntos desde el ID del Piloto --
DELIMITER //
CREATE FUNCTION f_TotalPuntos(p_driverId INT) RETURNS FLOAT
READS SQL DATA
BEGIN
    DECLARE totalPoints FLOAT;
    SELECT SUM(points) INTO totalPoints FROM DriverStandings WHERE driverId = p_driverId;
    RETURN IFNULL(totalPoints, 0);
END //
DELIMITER ;




