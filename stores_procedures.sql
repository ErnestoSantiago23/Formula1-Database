-- Inserción o actualización de resultados de pilotos --
DELIMITER //
CREATE PROCEDURE SP_RegistrarResultadoCarrera(
    IN p_raceId INT,
    IN p_driverId INT,
    IN p_constructorId INT,
    IN p_grid INT,
    IN p_position INT,
    IN p_points FLOAT,
    IN p_laps INT,
    IN p_timeR VARCHAR(255),
    IN p_milliseconds INT,
    IN p_statusId INT
)
BEGIN
    DECLARE v_exists INT;

    SELECT COUNT(*) INTO v_exists
    FROM Resultados
    WHERE raceId = p_raceId AND driverId = p_driverId;

    IF v_exists = 0 THEN
        -- Inserta un nuevo registro si no existe
        INSERT INTO Resultados(raceId, driverId, constructorId, grid, position, points, laps, timeR, milliseconds, statusId)
        VALUES (p_raceId, p_driverId, p_constructorId, p_grid, p_position, p_points, p_laps, p_timeR, p_milliseconds, p_statusId);
    ELSE
        -- Actualiza el registro existente
        UPDATE Resultados
        SET constructorId = p_constructorId,
            grid = p_grid,
            position = p_position,
            points = p_points,
            laps = p_laps,
            timeR = p_timeR,
            milliseconds = p_milliseconds,
            statusId = p_statusId
        WHERE raceId = p_raceId AND driverId = p_driverId;
    END IF;
END //
DELIMITER ;


-- Actualiza Estatus de piloto --
DELIMITER //
CREATE PROCEDURE SP_ActualizarEstatusPiloto(
    IN p_driverId INT,
    IN p_raceId INT,
    IN p_newStatus VARCHAR(255)
)
BEGIN
    UPDATE Status
    JOIN Resultados ON Status.statusId = Resultados.statusId
    SET Status.status = p_newStatus
    WHERE Resultados.driverId = p_driverId AND Resultados.raceId = p_raceId;
END //
DELIMITER ;
