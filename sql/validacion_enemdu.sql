-- Validaciones básicas del flujo ENEMDU.

SELECT COUNT(*) AS personas_staging
FROM staging.personas_limpio;

SELECT COUNT(*) AS vivienda_staging
FROM staging.vivienda_limpio;

SELECT COUNT(*) AS personas_modelo
FROM analytics.fact_persona_enemdu;

SELECT COUNT(*) AS hogares_modelo
FROM analytics.dim_hogar_vivienda;

-- Revisar duplicados si existen identificadores.
SELECT id_persona, COUNT(*)
FROM staging.personas_limpio
WHERE id_persona IS NOT NULL
GROUP BY id_persona
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC
LIMIT 20;

SELECT id_hogar, COUNT(*)
FROM staging.vivienda_limpio
WHERE id_hogar IS NOT NULL
GROUP BY id_hogar
HAVING COUNT(*) > 1
ORDER BY COUNT(*) DESC
LIMIT 20;
