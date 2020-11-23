--NOMBRE FICHERO: 20111065013002201900.01
--SELECT RUCCOOP||'|'||TIPODOCUMENTO||'|'||NUMERODOCUMENTO||'|'||APELLIDOPATERNO||'|'||APELLIDOMATERNO||'|'||NOMBRESOCIO||'|'||RAZONSOCIAL||'|'||TIPOINGRESO||'|'||FECHAMOVIMIENTO||'|'||FORMADEPAGO||'|'||IMPORTE||'|'||MONEDA||'|'||ANOINFORMADO AS CONCATENADO
--FROM
(
    SELECT 
        '20111065013' AS RUCCOOP,   --RUCCOOP
        CASE TIPOPERSONA
            WHEN 1 THEN --NATURAL
                CASE PKG_PERSONANATURAL.F_OBT_TIPODOCUMENTOID(CODIGOPERSONA)
                    WHEN 1 THEN --DNI
                        '01'
                    WHEN 4 THEN --CARNET EXTRANJERIA
                        '04'
                    WHEN 5 THEN --PERMISO PROVISIONAL
                        '08'
                    WHEN 7 THEN --PASAPORTE
                        '07'
                    WHEN 8 THEN --DNI
                        '01'
                    ELSE        --OTRO
                        '09'
                END
            WHEN 2 THEN --JURIDICA
                '06'
        END AS TIPODOCUMENTO,       --TIPODOCUMENTO

        CASE TIPOPERSONA
            WHEN 1 THEN --NATURAL
                RPAD(PKG_PERSONANATURAL.F_OBT_NUMERODOCUMENTOID(CODIGOPERSONA), 15, ' ')
            WHEN 2 THEN --JURIDICA
                RPAD(PKG_PERSONA.F_OBT_NUMERORUC(CODIGOPERSONA), 15, ' ')
        END AS NUMERODOCUMENTO,     --NUMERODOCUMENTO
        CASE TIPOPERSONA
            WHEN 1 THEN --NATURAL
                RPAD(PKG_PERSONANATURAL.F_OBT_APELLIDOPATERNO(CODIGOPERSONA), 50, ' ')
            WHEN 2 THEN --JURIDICA
                ''--LPAD(' ', 50, ' ')
        END AS APELLIDOPATERNO,     --APELLIDOPATERNO
        CASE TIPOPERSONA
            WHEN 1 THEN --NATURAL
                RPAD(PKG_PERSONANATURAL.F_OBT_APELLIDOMATERNO(CODIGOPERSONA), 50, ' ')
            WHEN 2 THEN --JURIDICA
                ''--LPAD(' ', 50, ' ')
        END AS APELLIDOMATERNO,     --APELLIDOMATERNO
        CASE TIPOPERSONA
            WHEN 1 THEN --NATURAL
                RPAD(PKG_PERSONANATURAL.F_OBT_NOMBRES(CODIGOPERSONA), 80, ' ')
            WHEN 2 THEN --JURIDICA
                ''--LPAD(' ', 80, ' ')
        END AS NOMBRESOCIO,         --NOMBRESOCIO
        CASE TIPOPERSONA
            WHEN 1 THEN --NATURAL
                ''--LPAD(' ', 100, ' ')
            WHEN 2 THEN --JURIDICA
                RPAD(REPLACE(REPLACE(REPLACE(PKG_PERSONA.F_OBT_NOMBRECOMPLETO(CODIGOPERSONA), '''',''),' & ', ' Y '),'&', ' Y ') , 100, ' ')
        END AS RAZONSOCIAL,         --RAZONSOCIAL
        CASE 
            WHEN FORMAPAGO = 5 AND NUMEROCUENTA LIKE '%1___' THEN       --APO
                RPAD('04', 25, ' ')          --REMANENTE TIPO '04'
            ELSE
                RPAD('05', 25, ' ')              --OTRO TIPO '05'
        END AS TIPOINGRESO,         --TIPOINGRESO
        TO_CHAR(FECHAMOVIMIENTO, 'DD/MM/YYYY') AS FECHAMOVIMIENTO,            --FECHAPERCEPCION
        CASE 
            WHEN FORMAPAGO = 5 AND NUMEROCUENTA LIKE '%1___' THEN       --APO
                RPAD('04', 15, ' ')         --APORTACIÓN TIPO '04'
            ELSE
                RPAD('05', 15, ' ')              --OTRO TIPO '09'
        END AS FORMADEPAGO,         --FORMADEPAGO
        CASE 
            WHEN NUMEROCUENTA LIKE '%1____' THEN
                '01'    --SOLES
            WHEN NUMEROCUENTA LIKE '%2____' THEN
                '02'    --DOLARES
            ELSE
                '04'    --OTROS
        END AS MONEDA,              --MONEDA
        LPAD(TO_CHAR(IMPORTE,'FM9999999.90'), 15, ' ') AS IMPORTE,                    --IMPORTE
        '2019' AS ANOINFORMADO      --ANOINFORMADO
    FROM
    (
        SELECT
            PKG_PERSONA.F_OBT_TIPOPERSONA(CODIGOPERSONA) AS TIPOPERSONA,
            CODIGOPERSONA,
            FORMAPAGO,
            APO.NUMEROCUENTA,
            APO.FECHAMOVIMIENTO AS FECHAMOVIMIENTO,
            IMPORTE1 AS IMPORTE
        FROM APORTES APO
        LEFT JOIN 
            (
                SELECT CODIGOPERSONA, NUMEROCUENTA
                FROM CUENTACORRIENTE
            ) CC
        ON CC.NUMEROCUENTA = APO.NUMEROCUENTA
        WHERE TO_CHAR(APO.FECHAMOVIMIENTO,'YYYY') = 2019
            AND ESTADO = 1
            AND APO.NUMEROCUENTA <> 0
            AND (FORMAPAGO = 5 AND APO.NUMEROCUENTA LIKE '%1___')
            AND CODIGOPERSONA <> 1
    )
);