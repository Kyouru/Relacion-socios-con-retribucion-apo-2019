--NOMBRE FICHERO: 20111065013002201900.01
--09:30
/*SELECT  '20111065013'||'|'||
        TIPODOCUMENTO||'|'||
        RPAD(NVL(NUMERODOCUMENTO, ' '), 15, ' ')||'|'||
        RPAD(NVL(APELLIDOPATERNO, ' '), 50, ' ')||'|'||
        RPAD(NVL(APELLIDOMATERNO, ' '), 50, ' ')||'|'||
        RPAD(NVL(NOMBRESOCIO, ' '), 80, ' ')||'|'||
        RPAD(NVL(RAZONSOCIAL, ' '), 100, ' ')||'|'||
        RPAD(TIPOINGRESO, 25, ' ')||'|'||
        TO_CHAR(FECHAMOVIMIENTO, 'DD/MM/YYYY')||'|'||
        RPAD(FORMADEPAGO, 15, ' ')||'|'||
        LPAD(TO_CHAR(IMPORTE, '999999990.99'), 15, ' ')||'|'||
        MONEDA||'|'||
        '2019' AS CONCATENADO
FROM
(*/
    SELECT  CAMPO,
            NUMEROCUENTA AS NUMEROCUENTA_SISGO,
            NUMERODOCUMENTO AS NUMERODOCUMENTO_SISGO,
            PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')) AS CODPERSONA,
            PKG_PERSONA.F_OBT_TIPOPERSONA(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0'))) AS TIPOPERSONA,
            CASE PKG_PERSONA.F_OBT_TIPOPERSONA(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')))
                WHEN 1 THEN --NATURAL
                    CASE PKG_PERSONANATURAL.F_OBT_TIPODOCUMENTOID(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')))
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

            CASE PKG_PERSONA.F_OBT_TIPOPERSONA(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')))
                WHEN 1 THEN --NATURAL
                    PKG_PERSONANATURAL.F_OBT_NUMERODOCUMENTOID(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')))
                WHEN 2 THEN --JURIDICA
                    TO_CHAR(PKG_PERSONA.F_OBT_NUMERORUC(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0'))))
            END AS NUMERODOCUMENTO,     --NUMERODOCUMENTO
            CASE PKG_PERSONA.F_OBT_TIPOPERSONA(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')))
                WHEN 1 THEN --NATURAL
                    PKG_PERSONANATURAL.F_OBT_APELLIDOPATERNO(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')))
                WHEN 2 THEN --JURIDICA
                    ''--LPAD(' ', 50, ' ')
            END AS APELLIDOPATERNO,     --APELLIDOPATERNO
            CASE PKG_PERSONA.F_OBT_TIPOPERSONA(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')))
                WHEN 1 THEN --NATURAL
                    PKG_PERSONANATURAL.F_OBT_APELLIDOMATERNO(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')))
                WHEN 2 THEN --JURIDICA
                    ''--LPAD(' ', 50, ' ')
            END AS APELLIDOMATERNO,     --APELLIDOMATERNO
            CASE PKG_PERSONA.F_OBT_TIPOPERSONA(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')))
                WHEN 1 THEN --NATURAL
                    PKG_PERSONANATURAL.F_OBT_NOMBRES(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')))
                WHEN 2 THEN --JURIDICA
                    ''--LPAD(' ', 80, ' ')
            END AS NOMBRESOCIO,         --NOMBRESOCIO
            CASE PKG_PERSONA.F_OBT_TIPOPERSONA(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0')))
                WHEN 1 THEN --NATURAL
                    ''--LPAD(' ', 100, ' ')
                WHEN 2 THEN --JURIDICA
                    REPLACE(REPLACE(REPLACE(PKG_PERSONA.F_OBT_NOMBRECOMPLETO(PKG_PERSONA.F_OBT_CODIGOPERSONA(LPAD(SUBSTR(NUMEROCUENTA, 0, LENGTH(NUMEROCUENTA) - 5), 7, '0'))), '''',''),' & ', ' Y '),'&', ' Y ')
            END AS RAZONSOCIAL,         --RAZONSOCIAL
            CASE 
                WHEN PKG_APORTES.F_OBT_FORMAPAGO(NUMEROCUENTA, NUMERODOCUMENTO) = 5 AND NUMEROCUENTA LIKE '%1___' THEN       --APO
                    '04'          --REMANENTE TIPO '04'
                WHEN PKG_APORTES.F_OBT_TIPOMOVIMIENTO(NUMEROCUENTA, NUMERODOCUMENTO) = 5 AND PKG_APORTES.F_OBT_FORMAPAGO(NUMEROCUENTA, NUMERODOCUMENTO) = 3 THEN       --INTERES
                    '02'          --INTERESES TIPO '02'
                ELSE
                    '05'              --OTRO TIPO '05'
            END AS TIPOINGRESO,         --TIPOINGRESO
            --TO_CHAR(FECHAMOVIMIENTO, 'DD/MM/YYYY') AS FECHAMOVIMIENTO,            --FECHAPERCEPCION
            CASE 
                WHEN PKG_APORTES.F_OBT_FORMAPAGO(NUMEROCUENTA, NUMERODOCUMENTO) = 5 AND NUMEROCUENTA LIKE '%1___' THEN       --APO
                    '04'         --APORTACIÓN TIPO '04'
                WHEN PKG_APORTES.F_OBT_TIPOMOVIMIENTO(NUMEROCUENTA, NUMERODOCUMENTO) = 5 AND PKG_APORTES.F_OBT_FORMAPAGO(NUMEROCUENTA, NUMERODOCUMENTO) = 3 THEN       --INTERES
                    '03'          --TRANSFERENCIA TIPO '03'
                ELSE
                    '09'              --OTRO TIPO '09'
            END AS FORMADEPAGO,         --FORMADEPAGO
            PKG_SYST902.F_OBT_TBLDESCRI(PKG_CUENTACORRIENTE.F_OBT_TABLASERVICIO(NUMEROCUENTA), PKG_CUENTACORRIENTE.F_OBT_ARGUMENTOSERVICIO(NUMEROCUENTA)) AS NOMPRODUCTO,
            SUBSTR(NUMEROCUENTA, -5, 1) AS MONEDA,
            PKG_SYST900.F_OBT_TBLDESCRI(32, CODIGOAGENCIA) AS AGENCIA,
            FECHAMOVIMIENTO,
            TO_CHAR(FECHAMOVIMIENTO, 'MMYYYY') AS PERIODO,
            PKG_SYST900.F_OBT_TBLDESCRI(15, TIPOMOVIMIENTO) AS TIPOMOVIMIENTO,
            IMPORTE,
            OBSERVACION,
            CODIGOUSUARIO
    FROM 
    (
        SELECT 'INTERESES' AS CAMPO, NUMEROCUENTA, NUMERODOCUMENTO, CODIGOAGENCIA, TRUNC(FECHAMOVIMIENTO) AS FECHAMOVIMIENTO, CONDICION, TIPOMOVIMIENTO, FORMAPAGO, IMPORTE1 AS IMPORTE, UPPER(OBSERVACION) AS OBSERVACION, CODIGOUSUARIO FROM APORTES
            WHERE ESTADO = 1
                AND TIPOMOVIMIENTO = 5
        
        UNION ALL

        SELECT 'REGULARIZACION INTERES' AS CAMPO, NUMEROCUENTA, NUMERODOCUMENTO, CODIGOAGENCIA, TRUNC(FECHAMOVIMIENTO) AS FECHAMOVIMIENTO, CONDICION, TIPOMOVIMIENTO, FORMAPAGO, IMPORTE1 AS IMPORTE, UPPER(OBSERVACION) AS OBSERVACION, CODIGOUSUARIO FROM APORTES
            WHERE ESTADO = 1
                AND NUMEROCUENTA LIKE '%2___'
                AND TIPOMOVIMIENTO = 3
                AND UPPER(OBSERVACION) LIKE '%REGULARIZ%INT%'
        
        UNION ALL
        
        SELECT 'RECONOCIMIENTO INTERESES' AS CAMPO, NUMEROCUENTA, NUMERODOCUMENTO, CODIGOAGENCIA, TRUNC(FECHAMOVIMIENTO) AS FECHAMOVIMIENTO, CONDICION, TIPOMOVIMIENTO, FORMAPAGO, IMPORTE1 AS IMPORTE, UPPER(OBSERVACION) AS OBSERVACION, CODIGOUSUARIO FROM APORTES
            WHERE ESTADO = 1
                AND TIPOMOVIMIENTO = 3
                AND (UPPER(OBSERVACION) LIKE 'REC %'
                    OR UPPER(OBSERVACION) LIKE 'REC.%'
                    OR UPPER(OBSERVACION) LIKE 'RECON.%'
                    OR UPPER(OBSERVACION) LIKE 'RECON %'
                    OR UPPER(OBSERVACION) LIKE 'RECONOC%'
                    OR UPPER(OBSERVACION) LIKE '%RECONOCIM%')
        
        UNION ALL
        
        SELECT 'REMANENTES' AS CAMPO, NUMEROCUENTA, NUMERODOCUMENTO, CODIGOAGENCIA, TRUNC(FECHAMOVIMIENTO) AS FECHAMOVIMIENTO, CONDICION, TIPOMOVIMIENTO, FORMAPAGO, IMPORTE1 AS IMPORTE, UPPER(OBSERVACION) AS OBSERVACION, CODIGOUSUARIO FROM APORTES
            WHERE ESTADO = 1
            AND NUMEROCUENTA LIKE '%1___'
            AND UPPER(OBSERVACION) LIKE 'REMANENTE APORTES 20__'
        
        UNION ALL
        
        SELECT 'INTERES X CANCELACION' AS CAMPO, NUMEROCUENTA, NUMERODOCUMENTO, CODIGOAGENCIA, TRUNC(FECHAMOVIMIENTO) AS FECHAMOVIMIENTO, CONDICION, TIPOMOVIMIENTO, FORMAPAGO, CASE WHEN TIPOMOVIMIENTO = 3 THEN IMPORTE1 ELSE IMPORTE1 * (-1) END AS IMPORTE, UPPER(OBSERVACION) AS OBSERVACION, CODIGOUSUARIO FROM APORTES
            WHERE ESTADO = 1
                AND (NUMEROCUENTA LIKE '%3___' OR NUMEROCUENTA LIKE '%2___' OR NUMEROCUENTA LIKE '%4___')
                AND UPPER(OBSERVACION) LIKE 'INTERES%X CANCELACION DE %'

        UNION ALL
        
        --Manual
        SELECT 'HANDPICK' AS CAMPO, NUMEROCUENTA, NUMERODOCUMENTO, CODIGOAGENCIA, TRUNC(FECHAMOVIMIENTO) AS FECHAMOVIMIENTO, CONDICION, TIPOMOVIMIENTO, FORMAPAGO, CASE WHEN MOD(TIPOMOVIMIENTO, 2) = 1 THEN IMPORTE1 ELSE IMPORTE1 * (-1) END AS IMPORTE, UPPER(OBSERVACION) AS OBSERVACION, CODIGOUSUARIO FROM APORTES
            WHERE ESTADO = 1
                AND (
                        (NUMEROCUENTA||'-'||NUMERODOCUMENTO) IN (   '60012811001-14',
                                                                    '3357312002-43',
                                                                    '170003512001-11',
                                                                    '4765813001-38',
                                                                    '15127612001-48',
                                                                    '2859012001-312',
                                                                    '2859012001-313',
                                                                    '2859012001-314',
                                                                    '2859012001-315',
                                                                    '314712002-517',
                                                                    '70011912001-34',
                                                                    '170023512001-5',
                                                                    '170027012001-6',
                                                                    '179013003-11',
                                                                    '3526513001-9',
                                                                    '15069112001-59',
                                                                    '3288812002-187',
                                                                    '70012713003-14',
                                                                    '150001512001-42',
                                                                    '150001513001-23',
                                                                    '401412003-424',
                                                                    '814613007-24',
                                                                    '814612001-9530',
                                                                    '814612001-9531',
                                                                    '3143112001-1',
                                                                    '2896712001-265',
                                                                    '2896712001-266',
                                                                    '170034612001-3',
                                                                    '15170212001-38',
                                                                    '3930512001-180',
                                                                    '15057312001-16',
                                                                    '15057312001-17',
                                                                    '15057312001-18',
                                                                    '15057312001-19',
                                                                    '15158012001-50',
                                                                    '15049914001-3',
                                                                    '2899212001-193',
                                                                    '3769612001-80',
                                                                    '5000712002-354',
                                                                    '408312001-96',
                                                                    '1086612001-356',
                                                                    '613814001-2',
                                                                    '314722002-117',
                                                                    '314722002-118',
                                                                    '3598322001-14',
                                                                    '15020322001-156',
                                                                    '1076722001-328',
                                                                    '408322001-165',
                                                                    '408322001-166',
                                                                    '15170622001-64',
                                                                    '1184123024-131',
                                                                    '1184123025-125',
                                                                    '1184123026-125',
                                                                    '1184123027-125',
                                                                    '1184123028-125',
                                                                    '1184123029-125',
                                                                    '1184123030-125',
                                                                    '1184123031-125',
                                                                    '1184123032-125',
                                                                    '1184123033-125',
                                                                    '1184123034-125',
                                                                    '1184123035-125',
                                                                    '1184123036-125',
                                                                    '1184123037-125',
                                                                    '1184123038-125',
                                                                    '1184123039-124',
                                                                    '1184123041-124',
                                                                    '1184123042-124',
                                                                    '1184123043-124',
                                                                    '1184123044-124',
                                                                    '11222001-2018',
                                                                    '2272222001-176',
                                                                    '4898122002-68',
                                                                    '15170622001-82',
                                                                    '321422001-1760',
                                                                    '570222002-1',
                                                                    '11222008-296',
                                                                    '4898122002-85',
                                                                    '3139222001-27',
                                                                    '804022001-92',
                                                                    '1194423001-55',
                                                                    '1907722001-1',
                                                                    '321422001-1734',
                                                                    '1194423002-53',
                                                                    '15094722001-16',
                                                                    '1194423003-52',
                                                                    '3495422001-24',
                                                                    '1321322001-48',
                                                                    '804022001-94',
                                                                    '747121001-4',
                                                                    '804022001-93',
                                                                    '844422001-353',
                                                                    '1398324001-2',
                                                                    '1261423007-134',
                                                                    '209022001-299',
                                                                    '3894724001-2',
                                                                    '15069122001-37',
                                                                    '15069122001-38',
                                                                    '408312001-165'
                                                                )
                    )
    )
    WHERE IMPORTE <> 0
        AND TO_CHAR(FECHAMOVIMIENTO, 'YYYY') = 2019

        --EXCEPCIONES
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '4574512002-23')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '3848313002-2')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '1355312001-3')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '60012812001-1')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '4203412001-137')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '1110212001-1669')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '15158012001-43')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '1346513004-161')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '221212001-20')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '4439412001-49')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '150001513001-23')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '150001512001-42')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '20061822002-17')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '428522003-28')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '912122002-402')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '1355322002-21')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '50009022001-34')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '1404022001-119')
        AND (NUMEROCUENTA||'-'||NUMERODOCUMENTO <> '3944922001-100')

    ORDER BY PERIODO, CAMPO, NUMEROCUENTA, FECHAMOVIMIENTO
    --)
;