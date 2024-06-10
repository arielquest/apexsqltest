SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO




-- =================================================================================================================================================
-- Versión:                       <1.4>
-- Creado por:                    <Fabian Sequeira Gamboa>
-- Fecha de creación:             <11/03/2021>
-- Descripción :                  <Permite Consultar procesos nuevos >
-- =================================================================================================================================================
-- Modificado por :               <Jose Gabriel Cordero Soto><06/05/2021><Se acomoda envio de datos del contexto para conservarlos en la consulta>
-- Modificado por :               <Fabian Sequeira Gamboa><24/06/2021><Se cambia el parametro de oficina por contexto>
-- =================================================================================================================================================
-- Modificado por :               <Josué Quirós Batista><09/07/2021><Se agrega la relación con BD Entregas para mostrar en el detalle.>
-- =================================================================================================================================================
-- Modificado por :               <Fabian Sequeira Gamboa><20/07/2021><Se optimiza el SP y se verifica que los legajos itinerados se consulten.>
-- =================================================================================================================================================
-- Modificado por :               <Xinia Soto Valerio><03/09/2021><Se modifica para que retorne el proceso y fase para poder hacer reparto.>
-- =================================================================================================================================================
-- Modificado por :				  <Jose Gabriel Cordero Soto><29/08/2022><Se modifica consulta para mejora en rendimiento y mejora en tiempo de respuesta de consulta> 
-- =================================================================================================================================================
-- Modificado por :				  <Jose Gabriel Cordero Soto><02/09/2022><Se modifica consulta, para validar que si las fechas desde y hasta vienen nulas se les establezca un rango por defecto. 
--																		  Esto con el objetivo de que los indeces se activen de forma correcta y se obtenga una optimización de tiempo efectiva>
-- =================================================================================================================================================
-- Modificado por :				  <Luis Alonso Leiva Tames><28/02/2023><Se modifica consulta, el campo de codigo de proceso, devuelva bien el nombre>
-- =================================================================================================================================================
-- Modificado por :				  <Luis Alonso Leiva Tames><01/03/2023><Se modifica consulta, mejorar el rendimiento de la consulta>
-- =================================================================================================================================================

CREATE     PROCEDURE [Expediente].[PA_ConsultarProcesosNuevos] 
	@NumeroPagina		INT,
	@CantidadRegistros	INT,
	@FechaDesde			DATETIME2(7)	= NULL,
	@FechaHasta			DATETIME2(7)	= NULL,
	@CodClase			INT				= NULL,
	@Estado				CHAR(1)			= NULL,
	@Contexto			VARCHAR(4)		= NULL,
	@CodAsunto			INT				= NULL,
	@Numero				CHAR(14)		= NULL
AS
BEGIN
	--****************************************************************************************************************************************************************
	--DECLARACION DE VARIABLES Y TABLA TEMPORAL 

	--Variables.
	DECLARE	@L_TC_NumeroExpediente	CHAR(14)		= @Numero,
			@L_Contexto				VARCHAR(4)		= @Contexto,
			@L_NumeroPagina			INT				= ISNULL(@NumeroPagina, 1),
			@L_Estado				CHAR(1)			= IIF(UPPER(@Estado) = 'A', NULL, UPPER(@Estado)),
			@L_FechaDesde			DATETIME2(7)	= ISNULL(@FechaDesde, DATEADD(YEAR, -1, GETDATE())), -- ESTO ES PARA MEJORAR LOS INDICES DE FECHA, SE ESTA PENDIENTE LA MEJORA EN CODIGO PARA VALIDAR LAS FECHAS
			@L_FechaHasta			DATETIME2(7)	= ISNULL(@FechaHasta, GETDATE()), 
			@L_TN_CodClase			INT				= @CodClase,
			@L_TN_CodAsunto			INT				= @CodAsunto,
			@L_CantidadRegistros	INT				= @CantidadRegistros,
			@L_TotalRegistros		INT				= 0;
	   DECLARE             @ProcesosNuevos          TABLE
               (
                              Numero                                            CHAR(14),
                              CodigoLegajo    UNIQUEIDENTIFIER,
                              CodEstado                         CHAR(1),
                              Estado                                CHAR(1),
                              FechaEntrada     DATETIME2(7),
                              IDEntrega                          BIGINT,
                              FechaEnvio                        DATETIME2(7),
                              CodClase                           INT,
                              Clase                                   VARCHAR(200),
                              CodProceso                      SMALLINT,
                              Proceso                                            VARCHAR(100),
                              CodFase         SMALLINT,
                              DecripcionFase  VARCHAR(100),
                              CodAsunto                        INT,
                              Asunto                                VARCHAR(200),
                              CodContexto                    VARCHAR(4),
                              Contexto                           VARCHAR(255)
               );

--****************************************************************************************************************************************************************
--CARGA DE INFORMACION PARA BUZÓN

               --Se hace en dos if separados para que cuando el estado sea null pase por los dos if.
               IF(@L_Estado = 'P' or @L_Estado is null) --is null o el estado que le pongan cuando es todos
               BEGIN
                              IF(@L_TN_CodClase IS NOT NULL AND @L_TN_CodAsunto IS NOT NULL)
                              BEGIN
                                            INSERT INTO @ProcesosNuevos 
                                            ( Numero, 
                                              CodigoLegajo, 
                                              FechaEntrada, 
                                              CodEstado, 
                                              CodClase, 
                                              CodAsunto, 
                                              CodProceso, 
                                              CodFase, 
                                              CodContexto, 
                                              IDEntrega, 
                                              FechaEnvio, 
                                              Clase, 
                                              Proceso, 
                                              DecripcionFase, 
                                              Asunto, 
                                              Contexto
                                            )
                                            SELECT DISTINCT A.TC_NumeroExpediente, 
                                                                                                       NULL, 
                                                                                                       C.TF_Entrada, 
                                                                                                       'P', 
                                                                                                       C.TN_CodClase, 
                                                                                                       NUll, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       C.TN_CodFase, 
                                                                                                       B.TC_CodContexto, 
                                                                                                       D.TN_IDEntrega, 
                                                                                                       D.TF_FechaEnvio, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion, 
                                                                                                       G.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       H.TC_Descripcion

                                            FROM                      (                                                                                                                                                                                                         --OBTIENE LOS EXPEDIENTE QUE NO CUENTEN CON ASIGNADO EN EXPEDIENTEASIGNADO
                                                                                                                      SELECT  Z.TC_NumeroExpediente
                                                                                                                      FROM               EXPEDIENTE.EXPEDIENTE                           Z WITH(NOLOCK)
                                                                                                                      WHERE Z.TC_CodContexto                                            = @L_Contexto
                                                                                                                      EXCEPT
                                                                                                                      SELECT  Y.TC_NumeroExpediente
                                                                                                                      FROM    Historico.ExpedienteAsignado Y WITH(NOLOCK)               
                                                                                                                      WHERE Y.TC_CodContexto                                            = @L_Contexto
                                                                                                                      AND                      Y.TB_EsResponsable                                    = 1
                                                                                                       ) A 
                                            INNER JOIN                       EXPEDIENTE.EXPEDIENTE                                                         B WITH(NOLOCK)
                                            ON                                                     B.TC_NumeroExpediente                                                         = A.TC_NumeroExpediente
                                            INNER JOIN                       EXPEDIENTE.EXPEDIENTEDETALLE                          C WITH(NOLOCK)
                                            ON                                                     C.TC_NumeroExpediente                                                         = B.TC_NumeroExpediente
                                            AND                                                   C.TC_CodContexto                                                                    = B.TC_CodContexto
                                            INNER JOIN                       Catalogo.Clase                                                                            E WITH(NOLOCK)
                                            ON                                                     E.TN_CodClase                                                                           = C.TN_CodClase
                                            INNER JOIN                       Catalogo.Proceso                                                                       F WITH(NOLOCK)
                                            ON                                                     F.TN_CodProceso                                                                                     = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Fase                                                                              G WITH(NOLOCK)
                                            ON                                                     G.TN_CodFase                                                                             = C.TN_CodFase
                                            INNER JOIN                       Catalogo.contexto                                                                     H WITH(NOLOCK)
                                            ON                                                     H.TC_CodContexto                                                                    = @L_Contexto
                                            LEFT JOIN                          SIAGPJ_ENTREGAS.ENTREGAS.TRACKING               D WITH(NOLOCK)
                                            ON                                                     D.TC_NumeroEXPEDIENTE                                                      = A.TC_NumeroEXPEDIENTE COLLATE DATABASE_DEFAULT
                                            AND                                                   D.TC_TipoEntrega                                                                      = 'D' COLLATE DATABASE_DEFAULT
                                            OUTER APPLY (
                                                                          SELECT * FROM (SELECT Z.TC_NumeroExpediente, Y.TN_CodClase
                                                                          FROM    HISTORICO.ExpedienteAsignado Z WITH(NOLOCK)
                                                                          INNER JOIN Expediente.ExpedienteDetalle Y WITH(NOLOCK)
                                                                          ON                        Z.TC_NumeroExpediente              = Y.TC_NumeroExpediente
                                                                          WHERE Z.TC_CodContexto              = B.TC_CodContexto    
                                                                          AND                     Z.TC_NumeroExpediente   = B.TC_NumeroExpediente) W
																		  WHERE  (W.TC_NumeroExpediente IS NULL AND W.TN_CodClase=@L_TN_CodClase)
) X
                                            WHERE                               C.TN_CodClase                                                                            = @L_TN_CodClase
                                            AND                                                   B.TC_NumeroEXPEDIENTE                                                       = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))             >= 0
                                            OR                                (X.TC_NumeroExpediente IS NULL AND X.TN_CodClase=@L_TN_CodClase)
                                            
											UNION

											SELECT DISTINCT B.TC_NumeroEXPEDIENTE, 
                                                                                                        B.TU_CodLegajo, 
                                                                                                       C.TF_Entrada, 
                                                                                                       'P', 
                                                                                                       NULL, 
                                                                                                       C.TN_CodAsunto, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       NULL, 
                                                                                                       B.TC_CodContexto, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       D.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion             
                                            From                                   (                                                                                                                                                                                                              --OBTIENE LOS LEGAJOS QUE NO CUENTEN CON ASIGNADO EN EXPEDIENTEASIGNADO
                                                                                                                      SELECT  Z.TU_CodLegajo
                                                                                                                      FROM    EXPEDIENTE.Legajo                                            Z WITH(NOLOCK)
                                                                                                                      WHERE Z.TC_CodContexto                                            = @L_Contexto
                                                                                                                      EXCEPT
                                                                                                                      SELECT  Y.TU_CodLegajo
                                                                                                                      FROM    Historico.LegajoAsignado            Y WITH(NOLOCK)             
                                                                                                                      WHERE Y.TC_CodContexto                                            = @L_Contexto
                                                                                                                      AND                      Y.TB_EsResponsable                                    = 1
                                                                                                       )              A 
                                            INNER JOIN                       EXPEDIENTE.Legajo                                                     B WITH(NOLOCK)            
                                            ON                                                     B.TU_CodLegajo                                                                        = A.TU_CodLegajo          
                                            INNER JOIN                       EXPEDIENTE.LegajoDetalle                         C WITH(NOLOCK)
                                            On                                                      C.TU_CodLegajo                                                                        = B.TU_CodLegajo
                                            AND                                                   C.TC_CodContexto                                                      = B.TC_CodContexto      
                                            INNER JOIN                       Catalogo.Proceso                                                        D WITH(NOLOCK)
                                            ON                                                     D.TN_CodProceso                                                                      = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Asunto                                                                         E WITH(NOLOCK)
                                            ON                                                     E.TN_CodAsunto                                                                        = C.TN_CodAsunto          
                                            INNER JOIN                       Catalogo.Contexto                                                      F WITH(NOLOCK)             
                                            ON                                                     F.TC_CodContexto                                                       = B.TC_CodContexto
                                            OUTER APPLY (
                                                        SELECT * FROM (SELECT  Z.TU_CodLegajo,Y.TN_CodAsunto
                                                        FROM               HISTORICO.LegajoAsignado Z WITH(NOLOCK)
                                                        INNER JOIN Expediente.LegajoDetalle Y WITH(NOLOCK)
                                                        ON                        Z.TU_CodLegajo                                            = Y.TU_CodLegajo
                                                        WHERE Z.TC_CodContexto                   = B.TC_CodContexto    
                                                        AND                      Z.TU_CodLegajo                                 = B.TU_CodLegajo) W
														WHERE   (W.TU_CodLegajo IS NULL AND W.TN_CodAsunto=@L_TN_CodAsunto)
                                                    ) X
                                            WHERE                               C.TN_CodAsunto                                                                         =  @L_TN_CodAsunto
                                            AND                                                   B.TC_NumeroEXPEDIENTE                                                       = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))             >= 0
                                            
                                            SET        @L_TotalRegistros          = @@ROWCOUNT;
                              END
                              ELSE IF(@L_TN_CodClase IS NULL AND @L_TN_CodAsunto IS NULL)
                              BEGIN
                                            INSERT INTO @ProcesosNuevos 
                                            ( Numero, 
                                              CodigoLegajo, 
                                              FechaEntrada, 
                                              CodEstado, 
                                              CodClase, 
                                              CodAsunto, 
                                              CodProceso, 
                                              CodFase, 
                                              CodContexto, 
                                              IDEntrega, 
                                              FechaEnvio, 
                                              Clase, 
                                              Proceso, 
                                              DecripcionFase, 
                                              Asunto, 
                                              Contexto
                                            )
                                            SELECT DISTINCT A.TC_NumeroExpediente, 
                                                                                                       NULL, 
                                                                                                       C.TF_Entrada, 
                                                                                                       'P', 
                                                                                                       C.TN_CodClase, 
                                                                                                       NUll, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       C.TN_CodFase, 
                                                                                                       B.TC_CodContexto, 
                                                                                                       D.TN_IDEntrega, 
                                                                                                       D.TF_FechaEnvio, 
                                                                                                        E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion, 
                                                                                                       G.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       H.TC_Descripcion

                                            FROM                      (                                                                                                                                                                                                         --OBTIENE LOS EXPEDIENTE QUE NO CUENTEN CON ASIGNADO EN EXPEDIENTEASIGNADO
                                                                                                                      SELECT  Z.TC_NumeroExpediente
                                                                                                                      FROM               EXPEDIENTE.EXPEDIENTE                           Z WITH(NOLOCK)
                                                                                                                      WHERE Z.TC_CodContexto                                            = @L_Contexto
                                                                                                                      EXCEPT
                                                                                                                      SELECT  Y.TC_NumeroExpediente
                                                                                                                      FROM    Historico.ExpedienteAsignado Y WITH(NOLOCK)               
                                                                                                                      WHERE Y.TC_CodContexto                                            = @L_Contexto
                                                                                                                      AND                      Y.TB_EsResponsable                                    = 1
                                                                                                       ) A 
                                            INNER JOIN                       EXPEDIENTE.EXPEDIENTE                                                         B WITH(NOLOCK)
                                            ON                                                     B.TC_NumeroExpediente                                                         = A.TC_NumeroExpediente
INNER JOIN                       EXPEDIENTE.EXPEDIENTEDETALLE                          C WITH(NOLOCK)
                                            ON                                                     C.TC_NumeroExpediente                                                         = B.TC_NumeroExpediente
                                            AND                                                   C.TC_CodContexto                                                                    = B.TC_CodContexto
                                            INNER JOIN                       Catalogo.Clase                                                                            E WITH(NOLOCK)
                                            ON                                                     E.TN_CodClase                                                                           = C.TN_CodClase
                                            INNER JOIN                       Catalogo.Proceso                                                                       F WITH(NOLOCK)
                                            ON                                                     F.TN_CodProceso                                                                                     = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Fase                                                                              G WITH(NOLOCK)
                                            ON                                                     G.TN_CodFase                                                                            = C.TN_CodFase
                                            INNER JOIN                       Catalogo.contexto                                                                     H WITH(NOLOCK)
                                            ON                                                     H.TC_CodContexto                                                                    = @L_Contexto
                                            LEFT JOIN                          SIAGPJ_ENTREGAS.ENTREGAS.TRACKING               D WITH(NOLOCK)
                                            ON                                                     D.TC_NumeroEXPEDIENTE                                                      = A.TC_NumeroEXPEDIENTE COLLATE DATABASE_DEFAULT
                                            AND                                                   D.TC_TipoEntrega                                                                      = 'D' COLLATE DATABASE_DEFAULT
                                            OUTER APPLY (
                                                                          SELECT * FROM (SELECT  Z.TC_NumeroExpediente, Y.TN_CodClase
                                                                          FROM    HISTORICO.ExpedienteAsignado Z WITH(NOLOCK)
                                                                          INNER JOIN Expediente.ExpedienteDetalle Y WITH(NOLOCK)
                                                                          ON                        Z.TC_NumeroExpediente              = Y.TC_NumeroExpediente
                                                                          WHERE Z.TC_CodContexto              = B.TC_CodContexto    
                                                                          AND                     Z.TC_NumeroExpediente   = B.TC_NumeroExpediente) W
																		  WHERE	(W.TC_NumeroExpediente IS NULL AND W.TN_CodClase=@L_TN_CodClase)		  

                                                           ) X
                                            WHERE                               B.TC_NumeroEXPEDIENTE                                                       = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))             >= 0
                                                                           
                                            UNION

                                            SELECT DISTINCT B.TC_NumeroEXPEDIENTE, 
                                                                                                       B.TU_CodLegajo, 
                                                                                                       C.TF_Entrada, 
                                                                                                        'P', 
                                                                                                       NULL, 
                                                                                                       C.TN_CodAsunto, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       NULL, 
                                                                                                       B.TC_CodContexto, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       D.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion             
                                            From                                   (                                                                                                                                                                                                             --OBTIENE LOS LEGAJOS QUE NO CUENTEN CON ASIGNADO EN EXPEDIENTEASIGNADO
                                                                                                                      SELECT  Z.TU_CodLegajo
                                                                                                                      FROM    EXPEDIENTE.Legajo                                            Z WITH(NOLOCK)
                                                                                                                      WHERE Z.TC_CodContexto                                            = @L_Contexto
                                                                                                                      EXCEPT
                                                                                                                      SELECT  Y.TU_CodLegajo
                                                                                                                      FROM    Historico.LegajoAsignado            Y WITH(NOLOCK)             
                                                                                                                      WHERE Y.TC_CodContexto                                            = @L_Contexto
                                                                                                                      AND                      Y.TB_EsResponsable                                    = 1
                                                                                                       )              A 
                                            INNER JOIN                       EXPEDIENTE.Legajo                                                     B WITH(NOLOCK)            
                                            ON                                                     B.TU_CodLegajo                                                                        = A.TU_CodLegajo          
                                            INNER JOIN                       EXPEDIENTE.LegajoDetalle                         C WITH(NOLOCK)
                                            On                                                      C.TU_CodLegajo                                                                        = B.TU_CodLegajo
                                            AND                                                   C.TC_CodContexto                                                      = B.TC_CodContexto      
                                            INNER JOIN                       Catalogo.Proceso                                                        D WITH(NOLOCK)
                                            ON                                                     D.TN_CodProceso                                                                      = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Asunto                                                                         E WITH(NOLOCK)
                                            ON                                                     E.TN_CodAsunto                                                                        = C.TN_CodAsunto          
                                            INNER JOIN                       Catalogo.Contexto                                                      F WITH(NOLOCK)             
                                            ON                                                     F.TC_CodContexto                                                       = B.TC_CodContexto
                                            OUTER APPLY (
                                                                          SELECT * FROM (SELECT  Z.TU_CodLegajo,Y.TN_CodAsunto
                                                                          FROM    HISTORICO.LegajoAsignado Z WITH(NOLOCK)
                                                                          INNER JOIN Expediente.LegajoDetalle Y WITH(NOLOCK)
                                                                          ON                        Z.TU_CodLegajo                                            = Y.TU_CodLegajo
                                                                          WHERE Z.TC_CodContexto              = B.TC_CodContexto    
                                                                          AND                     Z.TU_CodLegajo                                 = B.TU_CodLegajo) W 
																		  WHERE (W.TU_CodLegajo IS NULL AND W.TN_CodAsunto=@L_TN_CodAsunto)
                                                           ) X
                                            WHERE                               B.TC_NumeroEXPEDIENTE                                        = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)                             
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))             >= 0
                                            SET        @L_TotalRegistros          = @@ROWCOUNT;
                              END
                              ELSE IF(@L_TN_CodClase IS NOT NULL AND @L_TN_CodAsunto IS NULL)
                              BEGIN
                                            INSERT INTO @ProcesosNuevos 
                                            ( Numero, 
                                              CodigoLegajo, 
                                              FechaEntrada, 
                                              CodEstado, 
                                              CodClase, 
                                              CodAsunto, 
                                              CodProceso, 
                                              CodFase, 
                                              CodContexto, 
                                              IDEntrega, 
                                              FechaEnvio, 
                                              Clase, 
                                              Proceso, 
                                              DecripcionFase, 
                                              Asunto, 
                                              Contexto
                                            )
                                            SELECT DISTINCT A.TC_NumeroExpediente, 
                                                                                                       NULL, 
                                                                                                       C.TF_Entrada, 
                                                                                                       'P', 
                                                                                                       C.TN_CodClase, 
                                                                                                       NUll, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       C.TN_CodFase, 
                                                                                                       B.TC_CodContexto, 
                                                                                                       D.TN_IDEntrega, 
                                                                                                       D.TF_FechaEnvio, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion, 
                                                                                                       G.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       H.TC_Descripcion

                                            FROM                      (                                                                                                                                                                                                         --OBTIENE LOS EXPEDIENTE QUE NO CUENTEN CON ASIGNADO EN EXPEDIENTEASIGNADO
                                                                                                                      SELECT  Z.TC_NumeroExpediente
                                                                                                                      FROM               EXPEDIENTE.EXPEDIENTE                           Z WITH(NOLOCK)
                                                                                                                      WHERE Z.TC_CodContexto                                            = @L_Contexto
                                                                                                                      EXCEPT
                                                                                                                      SELECT  Y.TC_NumeroExpediente
                                                                                                                      FROM    Historico.ExpedienteAsignado Y WITH(NOLOCK)               
                                                                                                                      WHERE Y.TC_CodContexto                                            = @L_Contexto
                                                                                                                      AND                      Y.TB_EsResponsable                                    = 1
                                                                                                       ) A 
                                            INNER JOIN                       EXPEDIENTE.EXPEDIENTE                                                         B WITH(NOLOCK)
                                            ON                                                     B.TC_NumeroExpediente                                                         = A.TC_NumeroExpediente
                                            INNER JOIN                       EXPEDIENTE.EXPEDIENTEDETALLE                          C WITH(NOLOCK)
                                            ON                                                     C.TC_NumeroExpediente                                                         = B.TC_NumeroExpediente
                                            AND                                                   C.TC_CodContexto                                                                    = B.TC_CodContexto
                                            INNER JOIN                       Catalogo.Clase                                                                            E WITH(NOLOCK)
                                            ON                                                     E.TN_CodClase                                                                           = C.TN_CodClase
                                            INNER JOIN                       Catalogo.Proceso                                                                       F WITH(NOLOCK)
                                            ON                                                     F.TN_CodProceso                                                                                     = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Fase                                                                              G WITH(NOLOCK)
                                            ON                                                     G.TN_CodFase                                                                            = C.TN_CodFase
                                            INNER JOIN                       Catalogo.contexto                                                                     H WITH(NOLOCK)
                                            ON                                                     H.TC_CodContexto                                                                    = @L_Contexto
                                            LEFT JOIN                          SIAGPJ_ENTREGAS.ENTREGAS.TRACKING               D WITH(NOLOCK)
                                            ON                                                     D.TC_NumeroEXPEDIENTE                                                      = A.TC_NumeroEXPEDIENTE COLLATE DATABASE_DEFAULT
                                            AND                                                   D.TC_TipoEntrega                                                                      = 'D' COLLATE DATABASE_DEFAULT
                                            OUTER APPLY (
                                                           SELECT * FROM (SELECT  Z.TC_NumeroExpediente, Y.TN_CodClase
                                                           FROM    HISTORICO.ExpedienteAsignado Z WITH(NOLOCK)
                                                           INNER JOIN Expediente.ExpedienteDetalle Y WITH(NOLOCK)
                                                           ON                        Z.TC_NumeroExpediente              = Y.TC_NumeroExpediente
                                                           WHERE Z.TC_CodContexto              = B.TC_CodContexto    
                                                           AND                     Z.TC_NumeroExpediente   = B.TC_NumeroExpediente) W
														   WHERE (W.TC_NumeroExpediente IS NULL AND W.TN_CodClase=@L_TN_CodClase)
                                            ) X
                                            WHERE                               C.TN_CodClase                                                                            = @L_TN_CodClase
                                            AND                                                   B.TC_NumeroEXPEDIENTE                                                       = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))             >= 0
                                            
                                            UNION

                                            SELECT DISTINCT B.TC_NumeroEXPEDIENTE, 
                                                                                                       B.TU_CodLegajo, 
                                                                                                       C.TF_Entrada, 
                                                                                                       'P', 
                                                                                                       NULL, 
                                                                                                       C.TN_CodAsunto, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       NULL, 
                                                                                                       B.TC_CodContexto, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       D.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion             
                                            From                                   (                                                                                                                                                                                                              --OBTIENE LOS LEGAJOS QUE NO CUENTEN CON ASIGNADO EN EXPEDIENTEASIGNADO
                                                                                                                      SELECT  Z.TU_CodLegajo
                                                                                                                      FROM    EXPEDIENTE.Legajo                                            Z WITH(NOLOCK)
                                                                                                                      WHERE Z.TC_CodContexto                                            = @L_Contexto
                                                                                                                      EXCEPT
                                                                                                                      SELECT  Y.TU_CodLegajo
                                                                                                                      FROM    Historico.LegajoAsignado            Y WITH(NOLOCK)             
                                                                                                                      WHERE Y.TC_CodContexto                                            = @L_Contexto
                                                                                                                      AND                      Y.TB_EsResponsable                                    = 1
                                                                                                       )              A 
                                            INNER JOIN                       EXPEDIENTE.Legajo                                                     B WITH(NOLOCK)            
                                            ON                                                     B.TU_CodLegajo                                                                        = A.TU_CodLegajo
                                            INNER JOIN                       EXPEDIENTE.LegajoDetalle                         C WITH(NOLOCK)
                                            On                                                      C.TU_CodLegajo                                                                        = B.TU_CodLegajo
                                            AND                                                   C.TC_CodContexto                                                      = B.TC_CodContexto      
                                            INNER JOIN                       Catalogo.Proceso                                                        D WITH(NOLOCK)
                                            ON                                                     D.TN_CodProceso                                                                      = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Asunto                                                                         E WITH(NOLOCK)
                                            ON                                                     E.TN_CodAsunto                                                                        = C.TN_CodAsunto          
                                            INNER JOIN                       Catalogo.Contexto                                                      F WITH(NOLOCK)             
                                             ON                                                     F.TC_CodContexto                                                       = B.TC_CodContexto
                                            OUTER APPLY (
                                                           SELECT * FROM (SELECT  Z.TU_CodLegajo,Y.TN_CodAsunto
                                                           FROM    HISTORICO.LegajoAsignado Z WITH(NOLOCK)
                                                           INNER JOIN Expediente.LegajoDetalle Y WITH(NOLOCK)
                                                           ON                        Z.TU_CodLegajo                                            = Y.TU_CodLegajo
                                                           WHERE Z.TC_CodContexto              = B.TC_CodContexto    
                                                           AND                     Z.TU_CodLegajo                                 = B.TU_CodLegajo) W
														   WHERE  (W.TU_CodLegajo IS NULL AND W.TN_CodAsunto=@L_TN_CodAsunto)
                                            ) X
                                            WHERE                                             B.TC_NumeroEXPEDIENTE                                         = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)                                            
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))             >= 0
                                            
                                            SET        @L_TotalRegistros          = @@ROWCOUNT;
                              END
                              ELSE IF(@L_TN_CodClase IS NULL AND @L_TN_CodAsunto IS NOT NULL)
                              BEGIN
                                            INSERT INTO @ProcesosNuevos 
                                            ( Numero, 
                                              CodigoLegajo, 
                                              FechaEntrada, 
                                              CodEstado, 
                                              CodClase, 
                                              CodAsunto, 
                                              CodProceso, 
                                              CodFase, 
                                              CodContexto, 
                                              IDEntrega, 
                                              FechaEnvio, 
                                              Clase, 
                                              Proceso, 
                                              DecripcionFase, 
                                              Asunto, 
                                              Contexto
                                            )
                                            SELECT DISTINCT A.TC_NumeroExpediente, 
                                                                                                       NULL, 
                                                                                                       C.TF_Entrada, 
                                                                                                       'P', 
                                                                                                       C.TN_CodClase, 
                                                                                                       NUll, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       C.TN_CodFase, 
                                                                                                       B.TC_CodContexto, 
                                                                                                       D.TN_IDEntrega, 
                                                                                                       D.TF_FechaEnvio, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion, 
                                                                                                       G.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       H.TC_Descripcion

                                            FROM                      (                                                                                                                                                                                                         --OBTIENE LOS EXPEDIENTE QUE NO CUENTEN CON ASIGNADO EN EXPEDIENTEASIGNADO
                                                                                                                      SELECT  Z.TC_NumeroExpediente
                                                                                                                      FROM               EXPEDIENTE.EXPEDIENTE                           Z WITH(NOLOCK)
                                                                                                                      WHERE Z.TC_CodContexto                                            = @L_Contexto
                                                                                                                      EXCEPT
                                                                                                                      SELECT  Y.TC_NumeroExpediente
                                                                                                                      FROM    Historico.ExpedienteAsignado Y WITH(NOLOCK)               
                                                                                                                      WHERE Y.TC_CodContexto                                            = @L_Contexto
                                                                                                                      AND                      Y.TB_EsResponsable                                    = 1
                                                                                                       ) A 
                                            INNER JOIN                       EXPEDIENTE.EXPEDIENTE                                                         B WITH(NOLOCK)
                                            ON                                                     B.TC_NumeroExpediente                                                         = A.TC_NumeroExpediente
                                            INNER JOIN                       EXPEDIENTE.EXPEDIENTEDETALLE                          C WITH(NOLOCK)
                                            ON                                                     C.TC_NumeroExpediente                                                         = B.TC_NumeroExpediente
                                            AND                                                   C.TC_CodContexto                                                                    = B.TC_CodContexto
                                            INNER JOIN                       Catalogo.Clase                                                                            E WITH(NOLOCK)
                                            ON                                                     E.TN_CodClase                                                                           = C.TN_CodClase
                                            INNER JOIN                       Catalogo.Proceso                                                                       F WITH(NOLOCK)
                                            ON                                                     F.TN_CodProceso                                                                                     = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Fase                                                                              G WITH(NOLOCK)
                                            ON                                                     G.TN_CodFase                                                                            = C.TN_CodFase
                                             INNER JOIN                       Catalogo.contexto                                                                     H WITH(NOLOCK)
                                            ON                                                     H.TC_CodContexto                                                                    = @L_Contexto
                                            LEFT JOIN                          SIAGPJ_ENTREGAS.ENTREGAS.TRACKING               D WITH(NOLOCK)
                                            ON                                                     D.TC_NumeroEXPEDIENTE                                                      = A.TC_NumeroEXPEDIENTE COLLATE DATABASE_DEFAULT
                                            AND                                                   D.TC_TipoEntrega                                                                      = 'D' COLLATE DATABASE_DEFAULT
                                            OUTER APPLY (
                                                                          SELECT * FROM (SELECT  Z.TC_NumeroExpediente, Y.TN_CodClase
                                                                          FROM    HISTORICO.ExpedienteAsignado Z WITH(NOLOCK)
                                                                          INNER JOIN Expediente.ExpedienteDetalle Y WITH(NOLOCK)
                                                                          ON                        Z.TC_NumeroExpediente              = Y.TC_NumeroExpediente
                                                                          WHERE Z.TC_CodContexto              = B.TC_CodContexto    
                                                                          AND                     Z.TC_NumeroExpediente   = B.TC_NumeroExpediente) W
																		  WHERE (W.TC_NumeroExpediente IS NULL AND W.TN_CodClase=@L_TN_CodClase)
                                                           ) X
                                            WHERE                               B.TC_NumeroEXPEDIENTE                                                       = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))             >= 0
                                            
                                            UNION

                                            SELECT DISTINCT B.TC_NumeroEXPEDIENTE, 
                                                                                                       B.TU_CodLegajo, 
                                                                                                       C.TF_Entrada, 
                                                                                                       'P', 
                                                                                                       NULL, 
                                                                                                       C.TN_CodAsunto, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       NULL, 
                                                                                                       B.TC_CodContexto, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       D.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion             
                                            From                                   (                                                                                                                                                                                                              --OBTIENE LOS LEGAJOS QUE NO CUENTEN CON ASIGNADO EN EXPEDIENTEASIGNADO
                                                                                                                      SELECT  Z.TU_CodLegajo
                                                                                                                      FROM    EXPEDIENTE.Legajo                                            Z WITH(NOLOCK)
                                                                                                                      WHERE Z.TC_CodContexto                                            = @L_Contexto
                                                                                                                      EXCEPT
                                                                                                                      SELECT  Y.TU_CodLegajo
                                                                                                                      FROM    Historico.LegajoAsignado            Y WITH(NOLOCK)             
                                                                                                                      WHERE Y.TC_CodContexto                                            = @L_Contexto
                                                                                                                      AND                      Y.TB_EsResponsable                                    = 1
                                                                                                       )              A 
                                            INNER JOIN                       EXPEDIENTE.Legajo                                                     B WITH(NOLOCK)            
                                            ON                                                     B.TU_CodLegajo                                                                        = A.TU_CodLegajo          
                                            INNER JOIN                       EXPEDIENTE.LegajoDetalle                         C WITH(NOLOCK)
                                            On                                                      C.TU_CodLegajo                                                                        = B.TU_CodLegajo
                                            AND                                                   C.TC_CodContexto                                                      = B.TC_CodContexto      
                                            INNER JOIN                       Catalogo.Proceso                                                        D WITH(NOLOCK)
                                            ON                                                     D.TN_CodProceso                                                                      = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Asunto                                                                         E WITH(NOLOCK)
                                            ON                                                     E.TN_CodAsunto                                                                        = C.TN_CodAsunto          
                                            INNER JOIN                       Catalogo.Contexto                                                      F WITH(NOLOCK)             
                                            ON                                                     F.TC_CodContexto                                                       = B.TC_CodContexto
                                            OUTER APPLY (
															SELECT * FROM (SELECT  Z.TU_CodLegajo,Y.TN_CodAsunto
															FROM    HISTORICO.LegajoAsignado Z WITH(NOLOCK)
															INNER JOIN Expediente.LegajoDetalle Y WITH(NOLOCK)
															ON                        Z.TU_CodLegajo                                            = Y.TU_CodLegajo
															WHERE Z.TC_CodContexto              = B.TC_CodContexto    
															AND                     Z.TU_CodLegajo                                 = B.TU_CodLegajo) W
															WHERE (W.TU_CodLegajo IS NULL AND W.TN_CodAsunto=@L_TN_CodAsunto)
                                                        ) X
                                            WHERE                               C.TN_CodAsunto                                                                         =  @L_TN_CodAsunto
                                            AND                                                   B.TC_NumeroEXPEDIENTE                                         = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))             >= 0
                                            
                                            SET        @L_TotalRegistros          = @@ROWCOUNT;
                              END
               END

               If (@L_Estado = 'D' or @L_Estado is null)
               Begin
                              IF(@L_TN_CodClase IS NOT NULL AND @L_TN_CodAsunto IS NOT NULL)
                              BEGIN
                                            Insert into @ProcesosNuevos 
                                            ( 
                                                           Numero, 
                                                           CodigoLegajo, 
                                                           FechaEntrada, 
                                                           CodEstado, 
                                                           CodClase, 
                                                           CodAsunto, 
                                                           CodProceso, 
                                                           CodFase, 
                                                           CodContexto, 
                                                           IDEntrega, 
                                                           FechaEnvio, 
                                                           Clase, 
                                                           Proceso, 
                                                           DecripcionFase, 
                                                           Asunto, 
                                                           Contexto
                                            )
                                            SELECT DISTINCT A.TC_NumeroEXPEDIENTE, 
                                                                                                       NULL, 
                                                                                                       B.TF_Entrada, 
                                                                                                        'D', 
                                                                                                       B.TN_CodClase, 
                                                                                                       NULL, 
                                                                                                       B.TN_CodProceso, 
                                                                                                       B.TN_CodFase, 
                                                                                                       A.TC_CodContexto, 
                                                                                                       D.TN_IDEntrega, 
                                                                                                       D.TF_FechaEnvio, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion, 
                                                                                                       G.TC_Descripcion, 
                                                                                                       NULL,
                                                                                                       H.TC_Descripcion
               
                                            FROM                                 EXPEDIENTE.EXPEDIENTE                                                         A WITH(NOLOCK)
                                            INNER JOIN                       EXPEDIENTE.EXPEDIENTEDETALLE                          B WITH(NOLOCK)
                                            ON                                                     B.TC_NumeroEXPEDIENTE                                                       = A.TC_NumeroEXPEDIENTE
                                            AND                                                   B.TC_CodContexto                                                                    = A.TC_CodContexto
                                            INNER JOIN                       Historico.EXPEDIENTEASIGNADO                             C WITH(NOLOCK)
                                            ON                                                     C.TC_NumeroEXPEDIENTE                                                       = A.TC_NumeroEXPEDIENTE
                                            AND                                                   C.TC_CodContexto                                                                    = A.TC_CodContexto
                                            AND                                                   C.TB_EsResponsable                                                                 = 1
                                            INNER JOIN                       Catalogo.Clase                                                                            E WITH(NOLOCK)
                                            ON                                                     E.TN_CodClase                                                                           = B.TN_CodClase
                                            INNER JOIN                       Catalogo.Proceso                                                                       F WITH(NOLOCK)
                                            ON                                                     F.TN_CodProceso                                                                                     = B.TN_CodProceso
                                            INNER JOIN                       Catalogo.Fase                                                                              G WITH(NOLOCK)
                                            ON                                                     G.TN_CodFase                                                                            = B.TN_CodFase
                                            INNER JOIN                       Catalogo.contexto                                                                     H WITH(NOLOCK)
                                            ON                                                     H.TC_CodContexto                                                                    = @L_Contexto
                                            LEFT JOIN                          SIAGPJ_ENTREGAS.ENTREGAS.TRACKING               D WITH(NOLOCK)
                                            ON                                                     D.TC_NumeroEXPEDIENTE                                                      = A.TC_NumeroEXPEDIENTE COLLATE DATABASE_DEFAULT
                                            AND                                                   D.TC_TipoEntrega                                                                      = 'D' COLLATE DATABASE_DEFAULT
                                            WHERE                               A.TC_CodContexto                                                                     = @L_Contexto
                                            AND                                                   B.TN_CodClase                                                                           = @L_TN_CodClase
                                            AND                                                   A.TC_NumeroEXPEDIENTE                                                       = ISNULL(@L_TC_NumeroExpediente, A.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(B.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(B.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(B.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(B.TF_Entrada, GETDATE())))  >= 0
                                            Union
                                            SELECT DISTINCT B.TC_NumeroExpediente, 
                                                                                                       B.TU_CodLegajo, 
                                                                                                       C.TF_Entrada, 
                                                                                                       'D', 
                                                                                                       NULL, 
                                                                                                       C.TN_CodAsunto, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       NULL, 
                                                                                                       A.TC_CodContexto, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       D.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion

                                            FROM                                 Historico.LegajoAsignado            A WITH(NOLOCK)
                                            INNER JOIN                       Expediente.Legajo                                        B WITH(NOLOCK)
                                            ON                                                     B.TU_CodLegajo                                                          = A.TU_CodLegajo
                                            AND                                                   B.TC_CodContexto                                       = A.TC_CodContexto      
                                            AND                                                   A.TB_EsResponsable                                    = 1
                                            INNER JOIN                       EXPEDIENTE.LegajoDetalle          C WITH(NOLOCK)
                                            ON                                                     C.TU_CodLegajo                                                          = A.TU_CodLegajo
                                            AND                                                   C.TC_CodContexto                                       = A.TC_CodContexto
                                            INNER JOIN                       Catalogo.Proceso                                         D WITH(NOLOCK)
                                            ON                                                     D.TN_CodProceso                                                        = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Asunto                                                          E WITH(NOLOCK)
                                            ON                                                     E.TN_CodAsunto                                                          = C.TN_CodAsunto 
                                            INNER JOIN                       Catalogo.Contexto                                       F WITH(NOLOCK)
                                            ON                                                     F.TC_CodContexto                                        = B.TC_CodContexto
               
                                            WHERE                               B.TC_CodContexto                                       = @L_Contexto
                                            AND                                                   C.TN_CodAsunto                                                          = @L_TN_CodAsunto
                                            AND                                                   B.TC_NumeroEXPEDIENTE                          = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))  >= 0

                                            SET        @L_TotalRegistros          = @L_TotalRegistros + @@ROWCOUNT; 
                              END
                              ELSE IF(@L_TN_CodClase IS NULL AND @L_TN_CodAsunto IS NULL)
                              BEGIN
                                            Insert into @ProcesosNuevos 
                                            ( 
                                                           Numero, 
                                                           CodigoLegajo, 
                                                           FechaEntrada, 
                                                           CodEstado, 
                                                           CodClase, 
                                                           CodAsunto, 
                                                            CodProceso, 
                                                           CodFase, 
                                                           CodContexto, 
                                                           IDEntrega, 
                                                           FechaEnvio, 
                                                           Clase, 
                                                           Proceso, 
                                                           DecripcionFase, 
                                                           Asunto, 
                                                           Contexto
                                            )
                                            SELECT DISTINCT A.TC_NumeroEXPEDIENTE, 
                                                                                                       NULL, 
                                                                                                       B.TF_Entrada, 
                                                                                                       'D', 
                                                                                                       B.TN_CodClase, 
                                                                                                       NULL, 
                                                                                                       B.TN_CodProceso, 
                                                                                                       B.TN_CodFase, 
                                                                                                       A.TC_CodContexto, 
                                                                                                       D.TN_IDEntrega, 
                                                                                                       D.TF_FechaEnvio, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion, 
                                                                                                       G.TC_Descripcion, 
                                                                                                       NULL,
                                                                                                       H.TC_Descripcion
               
                                            FROM                                 EXPEDIENTE.EXPEDIENTE                                                         A WITH(NOLOCK)
                                            INNER JOIN                       EXPEDIENTE.EXPEDIENTEDETALLE                          B WITH(NOLOCK)
                                            ON                                                     B.TC_NumeroEXPEDIENTE                                                       = A.TC_NumeroEXPEDIENTE
                                            AND                                                   B.TC_CodContexto                                                                    = A.TC_CodContexto
                                            INNER JOIN                       Historico.EXPEDIENTEASIGNADO                             C WITH(NOLOCK)
                                            ON                                                     C.TC_NumeroEXPEDIENTE                                                       = A.TC_NumeroEXPEDIENTE
                                            AND                                                   C.TC_CodContexto                                                                    = A.TC_CodContexto
                                            AND                                                   C.TB_EsResponsable                                                                 = 1
                                            INNER JOIN                       Catalogo.Clase                                                                            E WITH(NOLOCK)
                                            ON                                                     E.TN_CodClase                                                                           = B.TN_CodClase
                                            INNER JOIN                       Catalogo.Proceso                                                                       F WITH(NOLOCK)
                                            ON                                                     F.TN_CodProceso                                                                                     = B.TN_CodProceso
                                            INNER JOIN                       Catalogo.Fase                                                                              G WITH(NOLOCK)
                                            ON                                                     G.TN_CodFase                                                                            = B.TN_CodFase
                                            INNER JOIN                       Catalogo.contexto                                                                     H WITH(NOLOCK)
                                            ON                                                     H.TC_CodContexto                                                                    = @L_Contexto
                                            LEFT JOIN                          SIAGPJ_ENTREGAS.ENTREGAS.TRACKING               D WITH(NOLOCK)
                                            ON                                                     D.TC_NumeroEXPEDIENTE                                                       = A.TC_NumeroEXPEDIENTE COLLATE DATABASE_DEFAULT
                                            AND                                                   D.TC_TipoEntrega                                                                      = 'D' COLLATE DATABASE_DEFAULT
                                            WHERE                               A.TC_CodContexto                                                                     = @L_Contexto
                                            AND                                                   A.TC_NumeroEXPEDIENTE                                                       = ISNULL(@L_TC_NumeroExpediente, A.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(B.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(B.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(B.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(B.TF_Entrada, GETDATE())))  >= 0
                                            Union
                                            SELECT DISTINCT B.TC_NumeroExpediente, 
                                                                                                       B.TU_CodLegajo, 
                                                                                                       C.TF_Entrada, 
                                                                                                       'D', 
                                                                                                       NULL, 
                                                                                                       C.TN_CodAsunto, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       NULL, 
                                                                                                       A.TC_CodContexto, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       D.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion

                                            FROM                                 Historico.LegajoAsignado            A WITH(NOLOCK)
                                            INNER JOIN                       Expediente.Legajo                                        B WITH(NOLOCK)
                                            ON                                                     B.TU_CodLegajo                                                          = A.TU_CodLegajo
                                            AND                                                   B.TC_CodContexto                                       = A.TC_CodContexto      
                                            AND                                                   A.TB_EsResponsable                                    = 1
                                            INNER JOIN                       EXPEDIENTE.LegajoDetalle          C WITH(NOLOCK)
                                            ON                                                     C.TU_CodLegajo                                                          = A.TU_CodLegajo
                                            AND                                                   C.TC_CodContexto                                       = A.TC_CodContexto
                                            INNER JOIN                       Catalogo.Proceso                                         D WITH(NOLOCK)
                                            ON                                                     D.TN_CodProceso                                                        = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Asunto                                                          E WITH(NOLOCK)
                                            ON                                                     E.TN_CodAsunto                                                          = C.TN_CodAsunto 
                                            INNER JOIN                       Catalogo.Contexto                                       F WITH(NOLOCK)
                                            ON                                                     F.TC_CodContexto                                        = B.TC_CodContexto
               
                                            WHERE                               B.TC_CodContexto                                       = @L_Contexto    
                                            AND                                                   B.TC_NumeroEXPEDIENTE                          = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))  >= 0

                                            SET        @L_TotalRegistros          = @L_TotalRegistros + @@ROWCOUNT; 
                              END
                              ELSE IF(@L_TN_CodClase IS NOT NULL AND @L_TN_CodAsunto IS NULL)
                              BEGIN
                                            Insert into @ProcesosNuevos 
                                            ( 
                                                           Numero, 
                                                           CodigoLegajo, 
                                                           FechaEntrada, 
                                                           CodEstado, 
                                                           CodClase, 
                                                           CodAsunto, 
                                                           CodProceso, 
                                                           CodFase, 
                                                           CodContexto, 
                                                           IDEntrega, 
                                                           FechaEnvio, 
                                                           Clase, 
                                                           Proceso, 
                                                           DecripcionFase, 
                                                           Asunto, 
                                                           Contexto
                                            )
                                            SELECT DISTINCT A.TC_NumeroEXPEDIENTE, 
                                                                                                       NULL, 
                                                                                                       B.TF_Entrada, 
                                                                                                       'D', 
                                                                                                       B.TN_CodClase, 
                                                                                                       NULL, 
                                                                                                       B.TN_CodProceso, 
                                                                                                       B.TN_CodFase, 
                                                                                                       A.TC_CodContexto, 
                                                                                                       D.TN_IDEntrega, 
                                                                                                       D.TF_FechaEnvio, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion, 
                                                                                                       G.TC_Descripcion, 
                                                                                                       NULL,
                                                                                                       H.TC_Descripcion
               
                                            FROM                                 EXPEDIENTE.EXPEDIENTE                                                         A WITH(NOLOCK)
                                            INNER JOIN                       EXPEDIENTE.EXPEDIENTEDETALLE                          B WITH(NOLOCK)
                                            ON                                                     B.TC_NumeroEXPEDIENTE                                                       = A.TC_NumeroEXPEDIENTE
                                            AND                                                   B.TC_CodContexto                                                                    = A.TC_CodContexto
                                            INNER JOIN                       Historico.EXPEDIENTEASIGNADO                             C WITH(NOLOCK)
                                            ON                                                     C.TC_NumeroEXPEDIENTE                                                       = A.TC_NumeroEXPEDIENTE
                                            AND                                                   C.TC_CodContexto                                                                    = A.TC_CodContexto
                                            AND                                                   C.TB_EsResponsable                                                                 = 1
                                            INNER JOIN                       Catalogo.Clase                                                                            E WITH(NOLOCK)
                                            ON                                                     E.TN_CodClase                                                                           = B.TN_CodClase
                                            INNER JOIN                       Catalogo.Proceso                                                                       F WITH(NOLOCK)
                                            ON                                                     F.TN_CodProceso                                                                                     = B.TN_CodProceso
                                            INNER JOIN                       Catalogo.Fase                                                                              G WITH(NOLOCK)
                                            ON                                                     G.TN_CodFase                                                                            = B.TN_CodFase
                                            INNER JOIN                       Catalogo.contexto                                                                     H WITH(NOLOCK)
                                            ON                                                     H.TC_CodContexto                                                                    = @L_Contexto
                                            LEFT JOIN                          SIAGPJ_ENTREGAS.ENTREGAS.TRACKING               D WITH(NOLOCK)
                                            ON                                                     D.TC_NumeroEXPEDIENTE                                                      = A.TC_NumeroEXPEDIENTE COLLATE DATABASE_DEFAULT
                                            AND                                                   D.TC_TipoEntrega                                                                      = 'D' COLLATE DATABASE_DEFAULT
                                            WHERE                               A.TC_CodContexto                                                                     = @L_Contexto
                                            AND                                                   B.TN_CodClase                                                                           = @L_TN_CodClase
                                            AND                                                   A.TC_NumeroEXPEDIENTE                                                       = ISNULL(@L_TC_NumeroExpediente, A.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(B.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(B.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(B.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(B.TF_Entrada, GETDATE())))  >= 0
                                            Union
                                            SELECT DISTINCT B.TC_NumeroExpediente, 
                                                                                                       B.TU_CodLegajo, 
                                                                                                       C.TF_Entrada, 
                                                                                                       'D', 
                                                                                                       NULL, 
                                                                                                       C.TN_CodAsunto, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       NULL, 
                                                                                                       A.TC_CodContexto, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       D.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion

                                            FROM                                 Historico.LegajoAsignado            A WITH(NOLOCK)
                                            INNER JOIN                       Expediente.Legajo                                        B WITH(NOLOCK)
                                            ON                                                     B.TU_CodLegajo                                                          = A.TU_CodLegajo
                                            AND                                                   B.TC_CodContexto                                       = A.TC_CodContexto      
                                            AND                                                   A.TB_EsResponsable                                    = 1
                                            INNER JOIN                       EXPEDIENTE.LegajoDetalle          C WITH(NOLOCK)
                                            ON                                                     C.TU_CodLegajo                                                          = A.TU_CodLegajo
                                            AND                                                   C.TC_CodContexto                                       = A.TC_CodContexto
                                            INNER JOIN                       Catalogo.Proceso                                         D WITH(NOLOCK)
                                            ON                                                     D.TN_CodProceso                                                        = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Asunto                                                          E WITH(NOLOCK)
                                            ON                                                     E.TN_CodAsunto                                                          = C.TN_CodAsunto 
                                            INNER JOIN                       Catalogo.Contexto                                       F WITH(NOLOCK)
                                            ON                                                     F.TC_CodContexto                                        = B.TC_CodContexto
               
                                            WHERE                               B.TC_CodContexto                                       = @L_Contexto    
                                            AND                                                   B.TC_NumeroEXPEDIENTE                          = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))  >= 0

                                            SET        @L_TotalRegistros          = @L_TotalRegistros + @@ROWCOUNT; 
                              END
                              ELSE IF(@L_TN_CodClase IS NULL AND @L_TN_CodAsunto IS NOT NULL)
                              BEGIN
                                            Insert into @ProcesosNuevos 
                                            ( 
                                                           Numero, 
                                                           CodigoLegajo, 
                                                           FechaEntrada, 
                                                           CodEstado, 
                                                           CodClase, 
                                                           CodAsunto, 
                                                           CodProceso, 
                                                           CodFase, 
                                                           CodContexto, 
                                                           IDEntrega, 
                                                           FechaEnvio, 
                                                           Clase, 
                                                           Proceso, 
                                                           DecripcionFase, 
                                                           Asunto, 
                                                           Contexto
                                            )
                                            SELECT DISTINCT A.TC_NumeroEXPEDIENTE, 
                                                                                                       NULL, 
                                                                                                       B.TF_Entrada, 
                                                                                                       'D', 
                                                                                                       B.TN_CodClase, 
                                                                                                       NULL, 
                                                                                                       B.TN_CodProceso, 
                                                                                                       B.TN_CodFase, 
                                                                                                       A.TC_CodContexto, 
                                                                                                       D.TN_IDEntrega, 
                                                                                                       D.TF_FechaEnvio, 
                                                                                                        E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion, 
                                                                                                       G.TC_Descripcion, 
                                                                                                       NULL,
                                                                                                       H.TC_Descripcion
               
                                            FROM                                 EXPEDIENTE.EXPEDIENTE                                                         A WITH(NOLOCK)
                                            INNER JOIN                       EXPEDIENTE.EXPEDIENTEDETALLE                          B WITH(NOLOCK)
                                            ON                                                     B.TC_NumeroEXPEDIENTE                                                       = A.TC_NumeroEXPEDIENTE
                                            AND                                                   B.TC_CodContexto                                                                    = A.TC_CodContexto
                                            INNER JOIN                       Historico.EXPEDIENTEASIGNADO                             C WITH(NOLOCK)
                                            ON                                                     C.TC_NumeroEXPEDIENTE                                                       = A.TC_NumeroEXPEDIENTE
                                            AND                                                   C.TC_CodContexto                                                                    = A.TC_CodContexto
                                            AND                                                   C.TB_EsResponsable                                                                 = 1
                                            INNER JOIN                       Catalogo.Clase                                                                            E WITH(NOLOCK)
                                            ON                                                     E.TN_CodClase                                                                           = B.TN_CodClase
                                            INNER JOIN                       Catalogo.Proceso                                                                       F WITH(NOLOCK)
                                            ON                                                     F.TN_CodProceso                                                                                     = B.TN_CodProceso
                                            INNER JOIN                       Catalogo.Fase                                                                              G WITH(NOLOCK)
                                            ON                                                     G.TN_CodFase                                                                            = B.TN_CodFase
                                            INNER JOIN                       Catalogo.contexto                                                                     H WITH(NOLOCK)
                                            ON                                                     H.TC_CodContexto                                                                    = @L_Contexto
                                            LEFT JOIN                          SIAGPJ_ENTREGAS.ENTREGAS.TRACKING               D WITH(NOLOCK)
                                            ON                                                     D.TC_NumeroEXPEDIENTE                                                      = A.TC_NumeroEXPEDIENTE COLLATE DATABASE_DEFAULT
                                            AND                                                   D.TC_TipoEntrega                                                                      = 'D' COLLATE DATABASE_DEFAULT
                                            WHERE                               A.TC_CodContexto                                                                     = @L_Contexto 
                                            AND                                                   A.TC_NumeroEXPEDIENTE                                                       = ISNULL(@L_TC_NumeroExpediente, A.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(B.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(B.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(B.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(B.TF_Entrada, GETDATE())))  >= 0
                                            Union
                                            SELECT DISTINCT B.TC_NumeroExpediente, 
                                                                                                       B.TU_CodLegajo, 
                                                                                                       C.TF_Entrada, 
                                                                                                       'D', 
                                                                                                       NULL, 
                                                                                                       C.TN_CodAsunto, 
                                                                                                       C.TN_CodProceso, 
                                                                                                       NULL, 
                                                                                                       A.TC_CodContexto, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       NULL, 
                                                                                                       D.TC_Descripcion, 
                                                                                                       NULL, 
                                                                                                       E.TC_Descripcion, 
                                                                                                       F.TC_Descripcion

                                            FROM                                 Historico.LegajoAsignado            A WITH(NOLOCK)
                                            INNER JOIN                       Expediente.Legajo                                        B WITH(NOLOCK)
                                            ON                                                     B.TU_CodLegajo                                                          = A.TU_CodLegajo
                                            AND                                                   B.TC_CodContexto                                       = A.TC_CodContexto                     
                                            AND                                                   A.TB_EsResponsable                                    = 1
                                            INNER JOIN                       EXPEDIENTE.LegajoDetalle          C WITH(NOLOCK)
                                            ON                                                     C.TU_CodLegajo                                                          = A.TU_CodLegajo
                                            AND                                                   C.TC_CodContexto                                       = A.TC_CodContexto
                                            INNER JOIN                       Catalogo.Proceso                                         D WITH(NOLOCK)
                                            ON                                                     D.TN_CodProceso                                                        = C.TN_CodProceso
                                            INNER JOIN                       Catalogo.Asunto                                                          E WITH(NOLOCK)
                                            ON                                                     E.TN_CodAsunto                                                          = C.TN_CodAsunto 
                                            INNER JOIN                       Catalogo.Contexto                                       F WITH(NOLOCK)
                                            ON                                                     F.TC_CodContexto                                        = B.TC_CodContexto
               
                                            WHERE                               B.TC_CodContexto                                       = @L_Contexto    
                                            AND                                                   C.TN_CodAsunto                                                          = @L_TN_CodAsunto
                                            AND                                                   B.TC_NumeroEXPEDIENTE                          = ISNULL(@L_TC_NumeroExpediente, B.TC_NumeroExpediente)
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaDesde, ISNULL(C.TF_Entrada, GETDATE())))            <= 0
                                            AND                                                   DATEDIFF(DAY, ISNULL(C.TF_Entrada, GETDATE()), ISNULL(@L_FechaHasta, ISNULL(C.TF_Entrada, GETDATE())))  >= 0

                                            SET        @L_TotalRegistros          = @L_TotalRegistros + @@ROWCOUNT; 
                              END
               End

               --*******************************************************************************************************************************
               -- SELECT FINAL DE LA CONSULTA

               SELECT                                              A.Numero,                                                                                    A.CodigoLegajo,                                                          A.CodEstado,                                   A.Estado,
                                                                                         A.FechaEntrada,                                                                          A.IDEntrega,                                                   A.FechaEnvio,                                  @L_TotalRegistros TotalRegistros,
                                                                                         @L_NumeroPagina NumeroPagina,        'Split'               split,                                                  A.CodClase Codigo,                       A.Clase Descripcion,
                                                                                         'Split' split,                                                                     A.CodProceso Codigo,   A.Proceso Descripcion,  'Split' split,
                                                                                         A.CodFase Codigo,               A.DecripcionFase,          'Split' split,
                                                                                         A.CodAsunto Codigo,                                                 A.Asunto Descripcion,                   'Split' split,                                       A.CodContexto Codigo,
                                                                                         A.Contexto Descripcion
               FROM                                                @ProcesosNuevos          A            
               ORDER BY                                        A.FechaEntrada DESC
               OFFSET                                              (@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS
               FETCH NEXT                                    @L_CantidadRegistros ROWS ONLY
END

GO
