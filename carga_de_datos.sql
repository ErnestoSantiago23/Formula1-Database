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



