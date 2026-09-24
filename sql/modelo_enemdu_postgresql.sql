-- Modelo analítico ENEMDU 2025 para PostgreSQL
-- Reproducción técnica del flujo documentado en el informe.

CREATE SCHEMA IF NOT EXISTS staging;
CREATE SCHEMA IF NOT EXISTS analytics;

DROP TABLE IF EXISTS staging.personas_limpio CASCADE;
CREATE TABLE staging.personas_limpio (
    id_persona TEXT,
    id_hogar TEXT,
    id_vivienda TEXT,
    periodo TEXT,
    mes TEXT,
    area TEXT,
    ciudad TEXT,
    prov TEXT,
    conglomerado TEXT,
    upm TEXT,
    p01 TEXT, p02 TEXT, p03 TEXT, p04 TEXT, p05a TEXT, p05b TEXT,
    p06 TEXT, p07 TEXT, p08 TEXT, p09 TEXT, p10a TEXT, p10b TEXT,
    p11 TEXT, p12a TEXT, p12b TEXT, p13 TEXT, p14 TEXT, p15 TEXT,
    p15aa TEXT, p15ab TEXT, p16 TEXT, p17 TEXT, p18 TEXT, p19 TEXT,
    p20 TEXT, p21 TEXT, p22 TEXT, p23 TEXT, p24 TEXT, p25 TEXT,
    p26 TEXT, p27 TEXT, p28 TEXT, p29 TEXT, p30 TEXT, p31 TEXT,
    p32 TEXT, p33 TEXT, p34 TEXT, p35 TEXT, p36 TEXT, p37 TEXT,
    p38 TEXT, p39 TEXT, p40 TEXT, p41 TEXT, p42 TEXT, p43 TEXT,
    p44 TEXT, p45 TEXT, p46 TEXT, p47a TEXT, p47b TEXT, p48 TEXT,
    p49 TEXT, p50 TEXT, p51a TEXT, p51b TEXT, p51c TEXT, p52 TEXT,
    p53 TEXT, p54 TEXT, p55 TEXT, p56a TEXT, p56b TEXT, p57 TEXT,
    p58 TEXT, p59 TEXT, p60 TEXT, p61 TEXT, p62 TEXT, p63 TEXT,
    p64a TEXT, p64b TEXT, p65 TEXT, p66 TEXT, p67 TEXT, p68a TEXT,
    p68b TEXT, p69 TEXT, p70a TEXT, p70b TEXT, p71a TEXT, p71b TEXT,
    p72a TEXT, p72b TEXT, p73a TEXT, p73b TEXT, p74a TEXT, p74b TEXT,
    p75 TEXT, p76 TEXT, p77 TEXT, p78 TEXT,
    condact TEXT,
    empleo TEXT,
    desempleo TEXT,
    secemp TEXT,
    grupo1 TEXT,
    rama1 TEXT,
    pobreza TEXT,
    epobreza TEXT,
    nnivins TEXT,
    ingrl TEXT,
    ingpc TEXT,
    fexp TEXT
);

DROP TABLE IF EXISTS staging.vivienda_limpio CASCADE;
CREATE TABLE staging.vivienda_limpio (
    id_hogar TEXT,
    id_vivienda TEXT,
    periodo TEXT,
    mes TEXT,
    area TEXT,
    ciudad TEXT,
    prov TEXT,
    conglomerado TEXT,
    upm TEXT,
    vi01 TEXT,
    vi02 TEXT,
    vi03a TEXT,
    vi03b TEXT,
    vi04a TEXT,
    vi04b TEXT,
    vi05a TEXT,
    vi05b TEXT,
    vi06 TEXT,
    vi07 TEXT,
    vi07a TEXT,
    vi07b TEXT,
    vi08 TEXT,
    vi09 TEXT,
    vi10 TEXT,
    vi101 TEXT,
    vi102 TEXT,
    vi10a TEXT,
    vi11 TEXT,
    vi12 TEXT,
    vi13 TEXT,
    vi14 TEXT,
    estrato TEXT,
    fexp TEXT
);

CREATE TABLE IF NOT EXISTS analytics.dim_tiempo (
    id_tiempo INTEGER PRIMARY KEY,
    periodo CHAR(6) NOT NULL,
    anio SMALLINT NOT NULL,
    mes SMALLINT NOT NULL
);

CREATE TABLE IF NOT EXISTS analytics.dim_ubicacion (
    id_ubicacion SERIAL PRIMARY KEY,
    area TEXT,
    ciudad TEXT,
    prov TEXT,
    dominio TEXT
);

CREATE TABLE IF NOT EXISTS analytics.dim_hogar_vivienda (
    id_hogar VARCHAR(30) PRIMARY KEY,
    id_vivienda VARCHAR(30),
    tipo_vivienda TEXT,
    numero_cuartos INTEGER,
    numero_dormitorios INTEGER,
    tenencia_vivienda TEXT,
    factor_expansion NUMERIC
);

CREATE TABLE IF NOT EXISTS analytics.dim_persona (
    id_persona VARCHAR(30) PRIMARY KEY,
    id_hogar VARCHAR(30),
    sexo TEXT,
    edad INTEGER,
    parentesco TEXT,
    nivel_instruccion TEXT,
    estado_civil TEXT
);

CREATE TABLE IF NOT EXISTS analytics.fact_persona_enemdu (
    id_persona VARCHAR(30) PRIMARY KEY,
    id_hogar VARCHAR(30),
    id_tiempo INTEGER NOT NULL,
    id_ubicacion INTEGER NOT NULL,
    condicion_actividad TEXT,
    empleo TEXT,
    desempleo TEXT,
    ingreso_laboral NUMERIC,
    ingreso_per_capita NUMERIC,
    pobreza TEXT,
    pobreza_extrema TEXT,
    factor_expansion NUMERIC,
    CONSTRAINT fk_fact_tiempo
        FOREIGN KEY (id_tiempo)
        REFERENCES analytics.dim_tiempo(id_tiempo),
    CONSTRAINT fk_fact_ubicacion
        FOREIGN KEY (id_ubicacion)
        REFERENCES analytics.dim_ubicacion(id_ubicacion),
    CONSTRAINT fk_fact_hogar
        FOREIGN KEY (id_hogar)
        REFERENCES analytics.dim_hogar_vivienda(id_hogar),
    CONSTRAINT fk_fact_persona
        FOREIGN KEY (id_persona)
        REFERENCES analytics.dim_persona(id_persona)
);

CREATE INDEX IF NOT EXISTS idx_fact_hogar
    ON analytics.fact_persona_enemdu(id_hogar);

CREATE INDEX IF NOT EXISTS idx_fact_tiempo
    ON analytics.fact_persona_enemdu(id_tiempo);

CREATE INDEX IF NOT EXISTS idx_fact_ubicacion
    ON analytics.fact_persona_enemdu(id_ubicacion);

CREATE INDEX IF NOT EXISTS idx_fact_empleo
    ON analytics.fact_persona_enemdu(empleo);
