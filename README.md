# ENEMDU BI / Data Analytics - Prácticas Preprofesionales

Repositorio de reproducción técnica del trabajo desarrollado durante las prácticas preprofesionales:
**“Desarrollo de herramientas de Inteligencia Empresarial y Data Analytics para fortalecer el ecosistema empresarial MIPYMES: caso Riobamba y Ambato”**.

Este repositorio organiza los artefactos técnicos solicitados en el dictamen de subsanación:
- Script Python para perfilado y limpieza de datos ENEMDU.
- Script SQL DDL para PostgreSQL.
- Script SQL de carga y validación.
- Archivo `docker-compose.yml` para reproducción técnica.
- Configuración de usuario de solo lectura para Looker Studio.
- Documentación de conectividad PostgreSQL local → ngrok TCP → Looker Studio.
- Carpeta para evidencias técnicas.

> Importante: no se incluyen contraseñas reales ni datos sensibles. Use `.env.example` como referencia y cree su propio archivo `.env`.

## Estructura

```text
enemdu_bi_repo/
├── README.md
├── .gitignore
├── .env.example
├── requirements.txt
├── docker-compose.yml
├── scripts/
│   └── limpieza_enemdu.py
├── sql/
│   ├── modelo_enemdu_postgresql.sql
│   ├── carga_enemdu_psql.sql
│   ├── validacion_enemdu.sql
│   └── seguridad_looker.sql
├── docs/
│   └── conectividad_looker_ngrok.md
├── datos_enemdu/
│   └── README.md
├── salida_enemdu/
│   └── .gitkeep
└── evidencias/
    └── README.md
```

## 1. Requisitos

- Python 3.10 o superior
- PostgreSQL 15
- Docker Desktop / Docker Engine
- ngrok
- Cuenta de Looker Studio

Instale dependencias de Python:

```bash
pip install -r requirements.txt
```

## 2. Archivos ENEMDU esperados

Coloque en `datos_enemdu/`:

```text
BDDenemdu_personas_2025_anual.csv
BDDenemdu_vivienda_2025_anual.csv
```

Los diccionarios y metadatos pueden conservarse en la misma carpeta de trabajo, pero se recomienda no subir archivos muy pesados al repositorio.

## 3. Perfilado y limpieza

Ejecute:

```bash
python scripts/limpieza_enemdu.py
```

La salida se genera en `salida_enemdu/`.

## 4. Crear la base y el modelo PostgreSQL

Ejemplo:

```bash
createdb enemdu_2025
psql -d enemdu_2025 -f sql/modelo_enemdu_postgresql.sql
```

## 5. Cargar datos

Antes de ejecutar `sql/carga_enemdu_psql.sql`, ajuste las rutas locales de los CSV exportados.

```bash
psql -d enemdu_2025 -f sql/carga_enemdu_psql.sql
```

Luego valide:

```bash
psql -d enemdu_2025 -f sql/validacion_enemdu.sql
```

## 6. Usuario de solo lectura para Looker Studio

Edite temporalmente la contraseña de ejemplo en `sql/seguridad_looker.sql` y ejecútelo como un usuario administrador:

```bash
psql -d enemdu_2025 -f sql/seguridad_looker.sql
```

No publique contraseñas reales en Git.

## 7. Reproducción técnica con Docker

Copie `.env.example` a `.env`:

```bash
cp .env.example .env
```

En Windows PowerShell:

```powershell
Copy-Item .env.example .env
```

Después:

```bash
docker compose up -d
```

Odoo quedará expuesto por defecto en:

```text
http://localhost:8069
```

## 8. Conectividad Looker Studio ↔ PostgreSQL local

Durante las prácticas se documentó el siguiente flujo:

```text
Looker Studio
   ↓
Dirección pública TCP de ngrok
   ↓
Agente ngrok en el portátil
   ↓
PostgreSQL local (localhost:5432)
```

Consulte `docs/conectividad_looker_ngrok.md`.

## 9. Evidencias

La carpeta `evidencias/` está destinada a capturas propias del entorno y documentación técnica.
No publique:
- contraseñas;
- tokens;
- archivos `.env`;
- credenciales;
- datos personales innecesarios.

## 10. Dashboard

En el informe se documentó un enlace público de Looker Studio. Si se mantiene publicado, agréguelo aquí:

```text
https://datastudio.google.com/s/s5HGyQignV4
```

## Autor

Dennis Israel Uquillas Carrillo  
Carrera de Ingeniería de Software - ESPOCH
