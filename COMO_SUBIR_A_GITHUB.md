# Cómo subir este proyecto a GitHub

## Opción A: usando la página web de GitHub

1. Entra a GitHub e inicia sesión.
2. Pulsa **New repository**.
3. Nombre sugerido:
   `enemdu-bi-data-analytics`
4. Selecciona **Public** o **Private** según lo que te soliciten.
5. No marques “Add a README”, porque el proyecto ya lo incluye.
6. Pulsa **Create repository**.
7. En el repositorio nuevo, pulsa **Add file → Upload files**.
8. Descomprime el ZIP de este paquete.
9. Arrastra **el contenido de la carpeta `enemdu_bi_repo`**, no el ZIP completo.
10. Escribe un mensaje de commit, por ejemplo:
    `Entrega de scripts y anexos técnicos de prácticas`
11. Pulsa **Commit changes**.

## Opción B: usando Git desde Windows

Abre PowerShell dentro de la carpeta `enemdu_bi_repo`:

```powershell
git init
git add .
git commit -m "Entrega de scripts y anexos técnicos de prácticas"
git branch -M main
git remote add origin https://github.com/TU_USUARIO/enemdu-bi-data-analytics.git
git push -u origin main
```

Si Git solicita autenticación, utiliza el método de inicio de sesión/token que GitHub te indique.

## Verificación final

En GitHub deben verse, como mínimo:

```text
README.md
docker-compose.yml
requirements.txt
scripts/limpieza_enemdu.py
sql/modelo_enemdu_postgresql.sql
sql/carga_enemdu_psql.sql
sql/validacion_enemdu.sql
sql/seguridad_looker.sql
docs/conectividad_looker_ngrok.md
```

No subas el archivo `.env` ni contraseñas reales.
