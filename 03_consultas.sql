-- Cada ejercicio: enunciado y solución. "-- Ej N" marca el inicio. Ejecutar con run.py

-- Ej 1 | Básico: clientes de Bogotá ordenados alfabéticamente
SELECT nombre FROM clientes WHERE ciudad = 'Bogotá' ORDER BY nombre;

-- Ej 2 | JOIN: solicitudes con nombre de cliente y asesor
SELECT s.solicitud_id, c.nombre AS cliente, a.nombre AS asesor, s.tipo_visa, s.estado
FROM solicitudes s
JOIN clientes c USING (cliente_id)
JOIN asesores a USING (asesor_id)
ORDER BY s.solicitud_id;

-- Ej 3 | GROUP BY: solicitudes por tipo de visa
SELECT tipo_visa, COUNT(*) AS total FROM solicitudes GROUP BY tipo_visa ORDER BY total DESC;

-- Ej 4 | Tasa de aprobación por asesor (solo solicitudes resueltas)
SELECT a.nombre AS asesor,
       ROUND(100.0 * SUM(s.estado = 'aprobada') / COUNT(*), 1) AS aprobacion_pct
FROM solicitudes s JOIN asesores a USING (asesor_id)
WHERE s.estado <> 'en_proceso'
GROUP BY a.asesor_id ORDER BY aprobacion_pct DESC;

-- Ej 5 | HAVING: ciudades con 3 o más clientes
SELECT ciudad, COUNT(*) AS clientes FROM clientes GROUP BY ciudad HAVING COUNT(*) >= 3;

-- Ej 6 | LEFT JOIN: clientes que NUNCA han tenido un contrato
SELECT c.nombre
FROM clientes c LEFT JOIN contratos k USING (cliente_id)
WHERE k.contrato_id IS NULL;

-- Ej 7 | Subconsulta: clientes con más solicitudes que el promedio
SELECT c.nombre, COUNT(*) AS solicitudes
FROM solicitudes s JOIN clientes c USING (cliente_id)
GROUP BY c.cliente_id
HAVING COUNT(*) > (SELECT AVG(n) FROM (SELECT COUNT(*) AS n FROM solicitudes GROUP BY cliente_id));

-- Ej 8 | Cartera vencida al 2026-11-01: cuotas sin pagar con fecha de vencimiento pasada
SELECT c.nombre, SUM(p.valor) AS vencido
FROM pagos p
JOIN contratos k USING (contrato_id)
JOIN clientes c USING (cliente_id)
WHERE p.pagado IS NULL AND p.vence < '2026-11-01'
GROUP BY c.cliente_id ORDER BY vencido DESC;

-- Ej 9 | CTE: saldo pendiente por contrato (valor total - lo pagado)
WITH pagado AS (
    SELECT contrato_id, SUM(valor) AS total_pagado FROM pagos WHERE pagado IS NOT NULL GROUP BY contrato_id
)
SELECT k.contrato_id, k.valor_total, COALESCE(p.total_pagado, 0) AS pagado,
       k.valor_total - COALESCE(p.total_pagado, 0) AS saldo
FROM contratos k LEFT JOIN pagado p USING (contrato_id)
ORDER BY saldo DESC;

-- Ej 10 | Ventana: ranking de asesores por solicitudes aprobadas
SELECT asesor, aprobadas, RANK() OVER (ORDER BY aprobadas DESC) AS posicion
FROM (SELECT a.nombre AS asesor, SUM(s.estado = 'aprobada') AS aprobadas
      FROM solicitudes s JOIN asesores a USING (asesor_id) GROUP BY a.asesor_id);

-- Ej 11 | Ventana: acumulado mensual de solicitudes
SELECT mes, solicitudes, SUM(solicitudes) OVER (ORDER BY mes) AS acumulado
FROM (SELECT strftime('%Y-%m', fecha) AS mes, COUNT(*) AS solicitudes FROM solicitudes GROUP BY mes);

-- Ej 12 | Días promedio de retraso en cuotas pagadas tarde
SELECT ROUND(AVG(julianday(pagado) - julianday(vence)), 1) AS dias_retraso_promedio
FROM pagos WHERE pagado > vence;
