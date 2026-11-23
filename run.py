"""Crea una base SQLite en memoria y ejecuta cada ejercicio mostrando su resultado."""
import re
import sqlite3
from pathlib import Path

AQUI = Path(__file__).parent


def main() -> None:
    con = sqlite3.connect(":memory:")
    for f in ("01_modelo.sql", "02_datos.sql"):
        con.executescript((AQUI / f).read_text(encoding="utf-8"))

    texto = (AQUI / "03_consultas.sql").read_text(encoding="utf-8")
    bloques = re.split(r"^-- (Ej \d+ \|.*)$", texto, flags=re.MULTILINE)
    for i in range(1, len(bloques), 2):
        titulo, sql = bloques[i], bloques[i + 1].strip()
        cur = con.execute(sql)
        cols = [d[0] for d in cur.description]
        filas = cur.fetchall()
        print(f"\n=== {titulo} ===")
        print(" | ".join(cols))
        for fila in filas:
            print(" | ".join(str(v) for v in fila))


if __name__ == "__main__":
    main()
