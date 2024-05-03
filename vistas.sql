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

