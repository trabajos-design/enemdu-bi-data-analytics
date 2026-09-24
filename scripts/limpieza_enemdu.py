"""
ETL reproducible para ENEMDU Anual 2025.

Consolida las operaciones reportadas:
- lectura;
- perfilado;
- limpieza sintáctica;
- normalización básica de decimales;
- exportación de archivos listos para PostgreSQL.
"""

from pathlib import Path
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "datos_enemdu"
SALIDA = ROOT / "salida_enemdu"
SALIDA.mkdir(exist_ok=True)

ARCHIVOS = {
    "personas": BASE / "BDDenemdu_personas_2025_anual.csv",
    "vivienda": BASE / "BDDenemdu_vivienda_2025_anual.csv",
}


def perfil(df: pd.DataFrame) -> pd.DataFrame:
    """Genera un perfil básico de columnas, nulos, tipos y valores únicos."""
    registros = len(df)
    return pd.DataFrame(
        {
            "campo": df.columns,
            "registros": registros,
            "nulos": [df[c].isna().sum() for c in df.columns],
            "valores_unicos": [df[c].nunique(dropna=True) for c in df.columns],
            "tipo": [str(df[c].dtype) for c in df.columns],
        }
    ).assign(
        porcentaje_nulos=lambda x: (
            (x["nulos"] / x["registros"] * 100).round(2)
            if registros > 0
            else 0
        )
    )


def limpiar(path: Path, nombre: str) -> pd.DataFrame:
    """Lee, limpia sintácticamente y exporta un CSV preparado para PostgreSQL."""
    if not path.exists():
        raise FileNotFoundError(f"No se encontró el archivo: {path}")

    df = pd.read_csv(
        path,
        sep=";",
        dtype=str,
        keep_default_na=False,
        low_memory=False,
    )

    # Normalización sintáctica sin alterar códigos ni identificadores.
    for c in df.columns:
        df[c] = df[c].astype("string").str.strip()

    df = df.replace(
        {
            "": pd.NA,
            "NA": pd.NA,
            "N/A": pd.NA,
            "NULL": pd.NA,
        }
    )

    # ENEMDU utiliza coma decimal en algunos campos.
    for c in ["fexp", "ingrl", "ingpc"]:
        if c in df.columns:
            df[c] = df[c].str.replace(",", ".", regex=False)
            df[c] = pd.to_numeric(df[c], errors="coerce")

    perfil(df).to_csv(
        SALIDA / f"perfil_{nombre}.csv",
        sep=";",
        index=False,
        encoding="utf-8",
    )
    df.to_csv(
        SALIDA / f"{nombre}_limpio.csv",
        sep=";",
        index=False,
        encoding="utf-8",
    )
    return df


def revisar_duplicados(df: pd.DataFrame, campo: str, etiqueta: str) -> None:
    if campo in df.columns:
        print(f"Duplicados {etiqueta}: {df[campo].duplicated().sum()}")
    else:
        print(f"Aviso: no se encontró la columna '{campo}' para revisar duplicados.")


if __name__ == "__main__":
    personas = limpiar(ARCHIVOS["personas"], "personas")
    vivienda = limpiar(ARCHIVOS["vivienda"], "vivienda")

    print("Personas:", personas.shape)
    print("Vivienda/hogar:", vivienda.shape)

    revisar_duplicados(personas, "id_persona", "id_persona")
    revisar_duplicados(vivienda, "id_hogar", "id_hogar")

    print(f"Archivos generados en: {SALIDA}")
