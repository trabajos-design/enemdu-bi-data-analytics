# Conectividad PostgreSQL local → ngrok → Looker Studio

Durante las prácticas, PostgreSQL 15 se ejecutó localmente en el portátil:

```text
localhost:5432
```

Looker Studio es un servicio en la nube y no puede acceder directamente a `localhost`.
El flujo documentado fue:

```text
Looker Studio
    ↓
Host/puerto público del túnel TCP ngrok
    ↓
Agente ngrok ejecutándose en el portátil
    ↓
PostgreSQL local (localhost:5432)
```

## 1. Iniciar PostgreSQL

Verifique que PostgreSQL escuche en el puerto 5432.

## 2. Iniciar ngrok

Ejecute:

```bash
ngrok tcp 5432
```

ngrok mostrará una dirección pública TCP parecida a:

```text
tcp://x.tcp.ngrok.io:12345
```

Use:
- **Host:** `x.tcp.ngrok.io`
- **Puerto:** `12345`

No use `localhost` en el conector de Looker Studio.

## 3. Configurar Looker Studio

Conector: PostgreSQL

Valores:
- Host: host público de ngrok
- Puerto: puerto TCP asignado por ngrok
- Base: `enemdu_2025`
- Usuario: `looker_ro`
- Contraseña: definida localmente, no almacenada en Git

## 4. Seguridad

El usuario `looker_ro` debe tener solamente:
- CONNECT a la base;
- USAGE sobre el esquema `analytics`;
- SELECT sobre las tablas de `analytics`.

No exponga:
- contraseña;
- tokens;
- URL persistente privada;
- archivos `.env`.

El túnel debe mantenerse activo solo mientras se utilice.

## 5. Producción

Para un entorno real se recomienda:
- instancia administrada de PostgreSQL;
- SSL;
- restricción de IP;
- secretos gestionados fuera del repositorio.
