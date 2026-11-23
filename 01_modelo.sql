-- Modelo normalizado (3FN) para una agencia de asesoría de visas. Datos ficticios.
PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS pagos;      DROP TABLE IF EXISTS contratos;
DROP TABLE IF EXISTS solicitudes; DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS asesores;

CREATE TABLE asesores (
    asesor_id INTEGER PRIMARY KEY,
    nombre    TEXT NOT NULL UNIQUE
);
CREATE TABLE clientes (
    cliente_id INTEGER PRIMARY KEY,
    nombre     TEXT NOT NULL,
    ciudad     TEXT NOT NULL
);
CREATE TABLE solicitudes (
    solicitud_id INTEGER PRIMARY KEY,
    cliente_id   INTEGER NOT NULL REFERENCES clientes(cliente_id),
    asesor_id    INTEGER NOT NULL REFERENCES asesores(asesor_id),
    tipo_visa    TEXT NOT NULL,
    estado       TEXT NOT NULL CHECK (estado IN ('aprobada','negada','en_proceso')),
    fecha        DATE NOT NULL
);
CREATE TABLE contratos (
    contrato_id INTEGER PRIMARY KEY,
    cliente_id  INTEGER NOT NULL REFERENCES clientes(cliente_id),
    valor_total REAL NOT NULL CHECK (valor_total > 0)
);
CREATE TABLE pagos (
    pago_id     INTEGER PRIMARY KEY,
    contrato_id INTEGER NOT NULL REFERENCES contratos(contrato_id),
    valor       REAL NOT NULL,
    vence       DATE NOT NULL,
    pagado      DATE
);
CREATE INDEX idx_solicitudes_cliente ON solicitudes(cliente_id);
CREATE INDEX idx_pagos_contrato ON pagos(contrato_id);
