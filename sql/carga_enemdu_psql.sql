-- Carga de archivos preparados en staging.
-- IMPORTANTE: ajustar las rutas a la carpeta local de salida_enemdu.

\copy staging.personas_limpio FROM 'C:/ENEMDU/personas_limpio.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8', NULL '');

\copy staging.vivienda_limpio FROM 'C:/ENEMDU/vivienda_limpio.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ';', ENCODING 'UTF8', NULL '');

-- Validaciones mínimas posteriores a la carga.
SELECT COUNT(*) AS personas_staging
FROM staging.personas_limpio;

SELECT COUNT(*) AS vivienda_staging
FROM staging.vivienda_limpio;
