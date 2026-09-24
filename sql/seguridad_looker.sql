-- Usuario de solo lectura para Looker Studio.
-- Ejecute como administrador de PostgreSQL.
-- CAMBIE la contraseña antes de ejecutar.
-- NO suba una contraseña real al repositorio.

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_roles WHERE rolname = 'looker_ro'
    ) THEN
        CREATE ROLE looker_ro LOGIN PASSWORD 'CAMBIAR_PASSWORD_LOCAL';
    END IF;
END
$$;

GRANT CONNECT ON DATABASE enemdu_2025 TO looker_ro;
GRANT USAGE ON SCHEMA analytics TO looker_ro;
GRANT SELECT ON ALL TABLES IN SCHEMA analytics TO looker_ro;

ALTER DEFAULT PRIVILEGES IN SCHEMA analytics
GRANT SELECT ON TABLES TO looker_ro;
