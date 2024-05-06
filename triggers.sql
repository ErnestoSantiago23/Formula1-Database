-- Actualiza los puntos de Pilotos --
DELIMITER //
CREATE TRIGGER trg_UpdateDriverPoints
AFTER INSERT ON Resultados
FOR EACH ROW
BEGIN
    -- Comprobar si el piloto ya tiene registro en esa carrera
    IF EXISTS (SELECT * FROM DriverStandings WHERE driverId = NEW.driverId AND raceId = NEW.raceId) THEN
        -- Actualizar puntos existentes
        UPDATE DriverStandings
        SET points = points + NEW.points
        WHERE driverId = NEW.driverId AND raceId = NEW.raceId;
    ELSE
        -- Insertar nuevo registro de puntos si no existe
        INSERT INTO DriverStandings (raceId, driverId, points, position, wins)
        VALUES (NEW.raceId, NEW.driverId, NEW.points, 0, 0);
    END IF;
END //
DELIMITER ;


-- Registra tiempos de Paradas en Boxes --
DELIMITER //
CREATE TRIGGER trg_CalculatePitStopMilliseconds
BEFORE INSERT ON PitStops
FOR EACH ROW
BEGIN
    SET NEW.milliseconds = TIME_TO_SEC(NEW.duration) * 1000 + (SUBSTRING_INDEX(NEW.duration, '.', -1) + 0);
END //
DELIMITER ;