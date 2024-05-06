-- Carga datos de circuitos  --
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\circuits.csv'
INTO TABLE circuitos
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(circuitId, circuitRef, name, location, country, lat, lng, alt, url);


-- Carga datos de constructores --
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\constructors.csv'
INTO TABLE constructores
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(constructorId, constructorRef, name, nationality, url);


-- Carga datos de pilotos --
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\drivers.csv'
INTO TABLE pilotos
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(driverId, driverRef, number, code, forename, surname, dob, nationality, url);


-- Carga datos de carreras --
/* agregar columnas de fecha y tiempos de (Practicas, quali y sprint) */
ALTER TABLE carreras
ADD fp1_date DATE,
ADD fp1_time TIME, 
ADD fp2_date DATE,
ADD fp2_time TIME,
ADD fp3_date DATE,
ADD fp3_time TIME,
ADD quali_date DATE,
ADD quali_time TIME,
ADD sprint_date DATE,
ADD sprint_time TIME;

/* carga de datos */
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\races.csv'
INTO TABLE carreras
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(raceId, year, round, circuitId, name, date, time, url, 
fp1_date, fp1_time, fp2_date, fp2_time, fp3_date, fp3_time, quali_date, 
quali_time, sprint_date, sprint_time);


-- Carga datos de status --
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\status.csv'
INTO TABLE status
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(statusId, status);


-- Carga datos de resultados --
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\results.csv'
INTO TABLE resultados
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(resultId, raceId, driverId, constructorId, numberR, 
grid, position, positionText, positionOrder, points, laps, timeR, 
milliseconds, fastestLap, rank1, fastestLapTime, fastestLapSpeed, statusId);


-- Cargar datos de laptimes --
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\lap_times.csv'
INTO TABLE laptimes
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(raceId, driverId, lap, position, time, milliseconds);


-- Cargar datos de pitstops
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\pit_stops.csv'
INTO TABLE pitstops
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(raceId, driverId, stop, lap, time, duration, milliseconds);


-- Cargar datos de Qualifying
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\qualifying.csv'
INTO TABLE qualifying
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(qualifyId, raceId, driverId, constructorId, number, position, q1, q2, q3);


-- Cargar datos de Sprint 
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\sprint_results.csv'
INTO TABLE sprintresults 
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(resultId, raceId, driverId, constructorId, number, grid, 
position, positionText, positionOrder, points, laps, time, 
milliseconds, fastestLap, fastestLapTime, statusId);


-- Cargar datos de DriverStandings  
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\driver_standings.csv'
INTO TABLE driverstandings  
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(driverStandingsId, raceId, driverId, points, position, positionText, wins);


-- Cargar datos de ConstructorResults   
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\constructor_results.csv'
INTO TABLE constructor_results   
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(constructorResultsId, raceId, constructorId, points, status);


-- Cargar datos de ConstructorStandings    
LOAD DATA INFILE 'D:\\MySQL\\Uploads\\data\\constructor_standings.csv'
INTO TABLE constructorstandings    
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(constructorStandingsId, raceId, constructorId, points, position, positionText, wins);



/*  CREACION DE VISTAS   */
-- Vista de Resultados de Carreras --
CREATE VIEW V_ResultadosCarrera AS
SELECT c.year, c.round, p.forename, p.surname, r.positionOrder, r.points
FROM Carreras c
JOIN Resultados r ON c.raceId = r.raceId
JOIN Pilotos p ON r.driverId = p.driverId;


-- Vista Detalles de Pilotos
CREATE VIEW V_DetallePilotos AS
SELECT p.driverId, p.forename, p.surname, p.dob, p.nationality,
       SUM(ds.points) AS TotalPoints, SUM(ds.wins) AS TotalWins
FROM Pilotos p
LEFT JOIN DriverStandings ds ON p.driverId = ds.driverId
GROUP BY p.driverId;


-- Vista Resultados Constructores --
CREATE VIEW V_ResultadosConstructores AS
SELECT c.name AS Carrera, con.name AS Constructor, cr.points
FROM Constructor_results cr
JOIN Constructores con ON cr.constructorId = con.constructorId
JOIN Carreras c ON cr.raceId = c.raceId;


-- Vista Historial de Carreras por Piloto --
CREATE VIEW V_HistorialCarrerasPiloto AS
SELECT p.forename, p.surname, c.year, c.name AS NombreCarrera, r.positionOrder, r.points
FROM Resultados r
JOIN Pilotos p ON r.driverId = p.driverId
JOIN Carreras c ON r.raceId = c.raceId;


-- Vista Paradas en Boxes por Carrera --
CREATE VIEW V_ParadasBoxes AS
SELECT c.name AS Carrera, p.forename, p.surname, ps.lap, ps.time, ps.duration
FROM PitStops ps
JOIN Pilotos p ON ps.driverId = p.driverId
JOIN Carreras c ON ps.raceId = c.raceId;



/* CRACION DE FUNCIONES  */
-- Función para Obtener ID de Piloto --
DELIMITER //
CREATE FUNCTION f_ObtenerIdPiloto(nombrePiloto VARCHAR(255))
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




/* CREACION STORES PROCEDURES  */
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



/* CREACION TRIGGERS  */
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
