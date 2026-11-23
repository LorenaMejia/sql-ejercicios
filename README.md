# 🗄️ SQL · Modelado y consultas

12 ejercicios progresivos de SQL sobre un modelo normalizado (3FN) de una agencia de asesoría de visas. Datos ficticios.

## Temas

| Nivel | Ejercicios | Conceptos |
|---|---|---|
| Básico | 1-3 | `SELECT`, `WHERE`, `ORDER BY`, `JOIN`, `GROUP BY` |
| Intermedio | 4-8 | `HAVING`, `LEFT JOIN`, subconsultas, agregaciones condicionales |
| Avanzado | 9-12 | CTE (`WITH`), funciones de ventana (`RANK`, `SUM OVER`), análisis de cartera |

## Archivos

- `01_modelo.sql`: tablas, llaves primarias/foráneas, `CHECK`, índices
- `02_datos.sql`: datos de ejemplo
- `03_consultas.sql`: enunciado y solución de cada ejercicio
- `run.py`: ejecuta todo en una base SQLite en memoria y muestra los resultados

## ▶️ Ejecutar

```bash
python run.py        # solo requiere Python 3, sin dependencias
```

## 🧠 Decisiones de diseño

- Separé `asesores`, `clientes`, `solicitudes`, `contratos` y `pagos` para evitar redundancia (3FN).
- Restricciones `CHECK` en estados y valores para garantizar integridad desde la base de datos.
- Índices en las llaves foráneas más consultadas.

**Autora:** Lorena Mejía · [LinkedIn](https://www.linkedin.com/in/lorena-mejia-60ab4728a/)
