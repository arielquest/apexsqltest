SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================================================================================================================= 
-- Versión:					<1.0>  
-- Creado por:				<Esteban Jimenez Alvarado>  
-- Fecha de creación:		<01/03/2017>  
-- Descripción:				<Obtiene las comunicaciones para la consulta de buzón seg£n los par metros establecidos.>   
-- =============================================================================================================================================================================================================  
-- Modificación:			<22/05/2017> <Diego Navarrete Alvarez> <se agrega resultado que funciona como filtro en comunicacionJudicial>  
-- Modificación:			<19/05/2017> <Stefany Quesada Cascante> <Se elimina join a tabla TipoComunicacionJudicial>  
-- Modificación:            <07/07/2017> <Se modifica el nombre, ya que se consulta las comunicaciones del buzón>  
-- Modificación:            <23/08/2017> <Ailyn López> <Se modifica filtro por horario y se sustituye el Coalesce por un or>  
-- Modificación:			<25/10/2017> <Ailyn López> <se agrega la columna nombre comercial a la consulta>  
-- Modificación:            <31/10/2017> <Ailyn López> <se modifica para que la condición sea por fecha de envio>  
-- Modificación:			<10/01/2018> <Andres Diaz> <Se optimiza y tabula todo el procedimiento almacenado.>  
-- Modificación:            <23/01/2018> <Ailyn López> <Se cambia TF_FechaFin por TF_FechaInicio en el where de TieneSenalamiento>  
-- Modificación:            <31/01/2018> <Ailyn López> <Se cambia TF_FechaFin por TF_FechaInicio en el where dentro del If de @PoseeSenalamientos>  
-- Modificación:            <16/03/2018> <Andres Diaz> <El par metro @CodigoOficinaComunicacion ahora es nulo por defecto.>  
-- Modificación:            <25/05/2018> <Jefry Hernandez> <Se agrega nuevo par metro (@CodigoEstadoExcluir)>  
-- Modificación:            <25/05/2018> <Jefry Hernandez> <Se agrega un caracter m s al Coalesce(@CodigoEstadoExcluir) para asegurar que nunca llegue a coincidir con un estado.>  
-- Modificación:            <26/10/2020> <Cristian Cerdas C.> <Se agrega las referencias de Provincia, Cantón, Distrito, Barrio, Sector, Tipo MedioComunicacion>
-- Modificación:            <05/01/2021> <Cristian Cerdas C.> <Se agrega como par metro de entrada @ComunicacionTablet, se modifica el where para buscar comunicaciones por este campo.>
-- Modificación:            <05/01/2021> <Cristian Cerdas C.> <Se agrega en el select los campos ComunicacionTablet y ComunicacionExcluidaTablet >
-- Modificación:            <09/06/2021> <Ronny Ramirez R.> <Cuando el campo NombreDestinatario no se llena se devuelve '' en lugar de null, para que no de error en la interfaz al tratar de hacer trim de null>
-- Modificación:            <17/06/2021> <Jose Miguel Avendaño Rosales> <Se modifica para que retorne el codigo de legajo para las notificaciones que pertenecen a un legajo>
-- Modificación:            <05/07/2021> <Ronny Ramirez R.> <Se aplica corrección en mapeo de tipo de medio de C.TC_CodMedio a TMC.TC_TipoMedio, pues se estaba enviando el código del cat logo y no el enum>
-- Modificación:            <08/07/2021> <Isaac Santiago Mendez Castillo> < - Se agrega la tabla Comunicacion.ComunicacionIntervencion en el FROM para obtener los datos correctos de la intervención de la comunicación
--																		    - Se modifica el CASE de NombreDestinatario, para que cuando un valor est‚ NULL, concatene lo que hay y no traiga NULL como resultado.>
-- Modificación:			<20/07/2021> <Josue Quirós Batista> <Se modifica la relación con la tabla de oficinas, ya que lo correcto es que consulte por contexto emisor && ajustes a la paginación.>
-- Modificación:			<25/08/2021> <Isaac Santiago Mendez Castillo> <Se modifica el SP para que se pueda tomar en cuenta el destinatario como filtro de b£squeda, se agregan campos en la	
--																		   tabla temporal @Comunicaciones y se agregan filtros WHERE en el SELECT principal. Incidente 202985>
-- Modificación:			<24/11/2021> <Aaron Rios Retana> <HU-223356 : Se modifica para que traiga los datos del legajo asociado y del asunto >
-- Modificación:			<08/09/2022> <Aaron Ríos Retana> <Incidente 276134: Se modifica para que ignore los acentos al filtrar por destinatario > 
-- Modificación:			<24/02/2023> <Jonathan Aguilar Navarro> <HU-212618 : Se modifica para incluir la fecha de la resolución, el proceso del expediente y legajo> 
-- Modificación:			<27/03/2023> <Jonathan Aguilar Navarro> <BUG-212618 : Error al marcar todos, se modifica el sp ya que estaba generando un cartesiano con ExpedienteDetalle y el proceso>  
-- Modificación:			<20/04/2023> <Fernando Mendez Diaz> <HU - 309262: Se agrega filtro para recuperar datos cuando el sector es nulo >  
-- Modificación:			<07/06/2023> <Elias Gonzalez Porras> <Se crea un OUTER APPLY para obtener el valor del campo TC_NombreRecibe de la tabla Comunicacion.IntentoComunicacion>
-- Modificación:            <04/12/2023> <Ronny Ramirez R.> <Se aplica corrección (LEFT JOIN) para traer registros de OCJs que son oficinas no presupuestarias (no son oficinas)>
-- ===============================================================================================================================================================================================================  
CREATE PROCEDURE [Comunicacion].[PA_ConsultarBuzon]   
(  
	@NumeroPagina					INT,  
	@CantidadRegistros				INT,  
	@LimiteMenorEdad				INT,  
	@CodigoOficinaComunicacion		VARCHAR(4)   = NULL,  
	@TipoComunicacion				CHAR(1)		 = NULL,  
	@CodigoEstado					CHAR(1)		 = NULL,  
	@CodigoEstadoExcluir			CHAR(1)		 = NULL,  
	@CodigoMedioComunicacion		SMALLINT	 = NULL,  
	@CodigoSector					SMALLINT	 = NULL,  
	@CodigoCircuito					SMALLINT	 = NULL,  
	@CodigoOficinaEmisora			VARCHAR(4)   = NULL,  
	@CodigoPuestoTrabajo			VARCHAR(14)  = NULL,  
	@RequiereCopias					BIT			 = NULL,  
	@CodigoHorario					SMALLINT     = NULL,  
	@PresentaVulnerabilidades		BIT			 = NULL,  
	@PresentaDiscapacidades			BIT			 = NULL,  
	@PoseeSenalamientos				BIT			 = NULL,  
	@FechaIngresoDesde				DATETIME	 = NULL,  
	@FechaIngresoHasta				DATETIME	 = NULL,  
	@NumeroExpediente				CHAR(14)	 = NULL,  
	@Destinatario					VARCHAR(500) = NULL,  
	@CodigoResultado				CHAR(1)		 = NULL,
	@ComunicacionTablet				BIT			 = NULL
)
AS
BEGIN
	Declare	@L_NumeroPagina			int					=	@NumeroPagina		,
			@L_CantidadRegistros	int					=	@CantidadRegistros	

	DECLARE @FechaActual			AS DATETIME			= GETDATE();  
  
	DECLARE @Comunicaciones			AS TABLE  
	(  
		TU_CodComunicacion				uniqueidentifier	NOT NULL,  
		TU_CodInterviniente				uniqueidentifier	NULL,  
		TU_CodIntPersona				uniqueidentifier	NULL,  
		TC_CodOficina					varchar(4)			NOT NULL,  
		TC_Estado						char(1)				NOT NULL,  
		TF_FechaEnvio					datetime2(7)		NULL,
		TC_Destinatario					varchar(150)		NULL,
		TC_DestinatarioNombreComercial	varchar(200)		NULL,
		TB_EsMenorEdad					BIT					NULL,
		TN_Sector						smallint			NULL
	);  
    
	DECLARE @Intervinientes AS TABLE  
	(  
		TU_CodInterviniente			uniqueidentifier NOT NULL  
	);  
 
	IF( @L_NumeroPagina is null)	SET @L_NumeroPagina=1;
   	 
	IF (@NumeroExpediente IS NOT NULL)  
		BEGIN  
			SET  @NumeroExpediente = (SELECT L.TC_NumeroExpediente 
									  FROM Expediente.Expediente		L WITH(NOLOCK)   
									  WHERE L.TC_NumeroExpediente	= @NumeroExpediente);  
		END  
   
	IF (@Destinatario IS NULL)  
		BEGIN  
 			INSERT INTO @Comunicaciones  
 			(  
 				TU_CodComunicacion,  
 				TU_CodInterviniente,  
 				TC_CodOficina,  
 				TC_Estado,  
 				TF_FechaEnvio,
				TN_Sector
 			)   
 			SELECT		TU_CodComunicacion,  
 						C.TU_CodInterviniente,  
 						C.TC_CodContexto,  
 						TC_Estado,  
 						C.TF_FechaEnvio ,
						C.TN_CodSector
 			FROM		Comunicacion.Comunicacion   AS C WITH(NOLOCK)  
 			WHERE		C.TC_CodContextoOCJ			= Coalesce(@CodigoOficinaComunicacion, C.TC_CodContextoOCJ)  
 			AND			C.TC_TipoComunicacion		= Coalesce(@TipoComunicacion, C.TC_TipoComunicacion)  
 			AND			C.TC_Estado					= Coalesce(@CodigoEstado, C.TC_Estado)  
 			AND			C.TC_Estado					<> Coalesce(@CodigoEstadoExcluir, 'ZX') -- Caracter no valido  
 			AND			(C.TC_Resultado				= @CodigoResultado OR @CodigoResultado IS NULL)  
 			AND			C.TC_CodMedio				= Coalesce(@CodigoMedioComunicacion, C.TC_CodMedio)   
 			AND			C.TC_CodContexto			= Coalesce(@CodigoOficinaEmisora, C.TC_CodContexto)  
 			AND			(C.TC_CodPuestoTrabajo		= @CodigoPuestoTrabajo OR @CodigoPuestoTrabajo IS NULL)  
 			AND			C.TB_RequiereCopias			= Coalesce(@RequiereCopias, C.TB_RequiereCopias)  
 			AND			(C.TN_CodHorarioMedio		= @CodigoHorario OR @CodigoHorario IS NULL)  
 			AND			(C.TF_FechaEnvio			>= @FechaIngresoDesde OR @FechaIngresoDesde IS NULL)  
 			AND			(C.TF_FechaEnvio			<= @FechaIngresoHasta OR @FechaIngresoHasta IS NULL)  
 			AND			(C.TC_NumeroExpediente      = @NumeroExpediente OR @NumeroExpediente IS NULL)
 			AND			C.TB_ComunicacionAppMovil	= Coalesce(@ComunicacionTablet, C.TB_ComunicacionAppMovil);  
		END
		
		ELSE 
		
		BEGIN  
 			INSERT INTO @Comunicaciones  
 			(  
 				TU_CodComunicacion,  
 				TU_CodInterviniente,  
 				TU_CodIntPersona,  
 				TC_CodOficina,  
 				TC_Estado,  
 				TF_FechaEnvio ,
				TN_Sector
 			)   
 			SELECT		C.TU_CodComunicacion,  
 						CI.TU_CodInterviniente,  
 						I.TU_CodPersona,  
 						C.TC_CodContexto,  
 						TC_Estado,  
 						C.TF_FechaEnvio,
						C.TN_CodSector
 			FROM		Comunicacion.Comunicacion				AS C WITH(NOLOCK)
			INNER JOIN	Comunicacion.ComunicacionIntervencion	AS CI WITH(NOLOCK)
			ON			C.TU_CodComunicacion					= CI.TU_CodComunicacion
 			INNER JOIN  Expediente.Intervencion					AS I WITH(NOLOCK)  
 			ON			I.TU_CodInterviniente					= CI.TU_CodInterviniente  
 			AND			I.TC_NumeroExpediente					= C.TC_NumeroExpediente 
 			WHERE		C.TC_CodContextoOCJ						= Coalesce(@CodigoOficinaComunicacion, C.TC_CodContextoOCJ)  
 			AND			C.TC_TipoComunicacion					= Coalesce(@TipoComunicacion, C.TC_TipoComunicacion)  
 			AND			C.TC_Estado								= Coalesce(@CodigoEstado, C.TC_Estado)  
 			AND			C.TC_Estado								<> Coalesce(@CodigoEstadoExcluir, 'ZX') -- Caracter no valido  
 			AND			(C.TC_Resultado							= @CodigoResultado OR @CodigoResultado IS NULL)  
 			AND			C.TC_CodMedio							= Coalesce(@CodigoMedioComunicacion, C.TC_CodMedio)  
 			
 			AND			C.TC_CodContexto						= Coalesce(@CodigoOficinaEmisora, C.TC_CodContexto)  
 			AND			(C.TC_CodPuestoTrabajo					= @CodigoPuestoTrabajo OR @CodigoPuestoTrabajo IS NULL)  
 			AND			C.TB_RequiereCopias						= Coalesce(@RequiereCopias, C.TB_RequiereCopias)  
 			AND			(C.TN_CodHorarioMedio					= @CodigoHorario OR @CodigoHorario IS NULL)  
 			AND			(C.TF_FechaEnvio						>= @FechaIngresoDesde OR @FechaIngresoDesde IS NULL)  
 			AND			(C.TF_FechaEnvio						<= @FechaIngresoHasta OR @FechaIngresoHasta IS NULL)  
 			AND			(C.TC_NumeroExpediente					= @NumeroExpediente OR @NumeroExpediente IS NULL)
 			AND			C.TB_ComunicacionAppMovil				= Coalesce(@ComunicacionTablet, C.TB_ComunicacionAppMovil);  
		END  
   
   if(@CodigoSector is not null)
   begin
      if(@CodigoSector =-99)
	    DELETE FROM @Comunicaciones  WHERE TN_Sector IS NOT NULL
	  ELSE   
        DELETE FROM @Comunicaciones  WHERE TN_Sector <> @CodigoSector or TN_Sector is null
   end


	IF (@CodigoCircuito IS NOT NULL)  
		BEGIN  
			DELETE FROM @Comunicaciones  
			WHERE  TC_CodOficina NOT IN (
 											Select		TC_CodContexto 
 											From		Catalogo.Contexto	A 
 											Inner Join	Catalogo.Oficina	B 
 											On			B.TC_CodOficina		= A.TC_CodOficina
 											Where		B.TN_CodCircuito	= @CodigoCircuito
 											);  
		END  
   
	IF (@PresentaVulnerabilidades IS NOT NULL)  
		BEGIN  
			DELETE FROM @Comunicaciones  
			WHERE  TU_CodInterviniente NOT IN (SELECT * FROM @Intervinientes);  
		END  
	ELSE  
		BEGIN  
			DELETE FROM @Comunicaciones  
			WHERE  TU_CodInterviniente IN (SELECT * FROM @Intervinientes);  
		END  
   
	IF (@PresentaDiscapacidades IS NOT NULL)  
		BEGIN  
    
			DELETE FROM @Intervinientes;  
			
			INSERT INTO @Intervinientes  
				SELECT  DISTINCT C.TU_CodInterviniente  
				FROM  @Comunicaciones        AS C  
				INNER JOIN Expediente.IntervinienteDiscapacidad  AS ID WITH(NOLOCK)  
				ON   ID.TU_CodInterviniente      = C.TU_CodInterviniente  
   
	IF (@PresentaDiscapacidades = 1)  
		BEGIN  
			DELETE FROM @Comunicaciones  
			WHERE  TU_CodInterviniente NOT IN (SELECT * FROM @Intervinientes);  
		END  
	ELSE  
		BEGIN  
			DELETE FROM @Comunicaciones  
			WHERE  TU_CodInterviniente IN (SELECT * FROM @Intervinientes);  
		END  
   
  END  
   
  IF (@PoseeSenalamientos IS NOT NULL)  
  BEGIN  
    
 	DELETE FROM @Intervinientes;  
   
 	  INSERT INTO		@Intervinientes  
 	  SELECT   DISTINCT C.TU_CodInterviniente  
 	  FROM				@Comunicaciones					AS C  
 	  INNER JOIN		Agenda.IntervinienteEvento		AS IE WITH(NOLOCK)  
 	  ON				IE.TU_CodInterviniente			= C.TU_CodInterviniente  
 	  INNER JOIN		Agenda.FechaEvento				AS FE WITH(NOLOCK)  
 	  ON				FE.TU_CodEvento					= IE.TU_CodEvento  
 	  WHERE				FE.TF_FechaInicio				>= @FechaActual  
 	  AND				FE.TB_Cancelada					= 0;  
   
   IF (@PoseeSenalamientos = 1)  
	   BEGIN  
 		   DELETE FROM @Comunicaciones  
 		   WHERE  TU_CodInterviniente NOT IN (SELECT * FROM @Intervinientes);  
	   END  
   ELSE  
	   BEGIN  
 		   DELETE FROM @Comunicaciones  
 		   WHERE TU_CodInterviniente IN (SELECT * FROM @Intervinientes);  
	   END  
   END  
   
	-- Actualiza el nombre de los destinatarios f¡sicos
	UPDATE		REGISTROSA_PROCESAR
	SET			REGISTROSA_PROCESAR.TC_Destinatario					= ISNULL(RTRIM(CONCAT(PF.TC_Nombre, ' ', PF.TC_PrimerApellido, ' ', PF.TC_SegundoApellido)), REGISTROSA_PROCESAR.TC_Destinatario),
				REGISTROSA_PROCESAR.TB_EsMenorEdad					= (CASE WHEN DATEADD(year, @LimiteMenorEdad, PF.TF_FechaNacimiento) > @FechaActual 
 																			THEN 1 
 																			ELSE 0 
 																		END)
	FROM		@Comunicaciones REGISTROSA_PROCESAR		
	INNER JOIN	Comunicacion.ComunicacionIntervencion				AS CI
	ON			REGISTROSA_PROCESAR.TU_CodComunicacion				= CI.TU_CodComunicacion
	INNER JOIN	Expediente.Intervencion								AS I
	ON			CI.TU_CodInterviniente								= I.TU_CodInterviniente
	INNER JOIN	Persona.Persona										AS P	WITH(NOLOCK)
	ON			I.TU_CodPersona										= P.TU_CodPersona
	INNER JOIN	Persona.PersonaFisica PF							WITH(NOLOCK)
	ON			P.TU_CodPersona										= PF.TU_CodPersona	

	-- Actualiza el nombre de los destinatarios f¡sicos
	UPDATE		REGISTROSA_PROCESAR
	SET			REGISTROSA_PROCESAR.TC_Destinatario					= ISNULL(PJ.TC_Nombre, REGISTROSA_PROCESAR.TC_Destinatario),
				REGISTROSA_PROCESAR.TC_DestinatarioNombreComercial	= ISNULL(PJ.TC_NombreComercial, REGISTROSA_PROCESAR.TC_DestinatarioNombreComercial)
	FROM		@Comunicaciones REGISTROSA_PROCESAR		
	INNER JOIN	Comunicacion.ComunicacionIntervencion				AS CI
	ON			REGISTROSA_PROCESAR.TU_CodComunicacion				= CI.TU_CodComunicacion
	INNER JOIN	Expediente.Intervencion								AS I
	ON			CI.TU_CodInterviniente								= I.TU_CodInterviniente
	INNER JOIN	Persona.Persona										AS P	WITH(NOLOCK)
	ON			I.TU_CodPersona										= P.TU_CodPersona
	INNER JOIN	Persona.PersonaJuridica PJ							WITH(NOLOCK)
	ON			P.TU_CodPersona										= PJ.TU_CodPersona	
   

  DECLARE @TotalRegistros AS INT = (SELECT	COUNT(*) 
									FROM	@Comunicaciones 
									WHERE	(TC_Destinatario	LIKE IIF(@Destinatario IS NULL, TC_Destinatario, '%' + @Destinatario + '%' COLLATE Latin1_general_CI_AI)
									OR		TC_Destinatario		IS NULL)
									);  
   
  SELECT	C.TU_CodComunicacion				AS CodigoComunicacion,  
 			C.TC_ConsecutivoComunicacion		AS ConsecutivoComunicacion,  
 			CI.TU_CodInterviniente				AS CodigoInterviniente,  
 			C.TC_CodMedio						AS CodigoMedioComunicacion,  
 			TMC.TC_Descripcion					AS DescripcionMedioComunicacion,  
 			TMC.TC_TipoMedio					AS TipoMedioComunicacion,
 			E.TC_NumeroExpediente				AS NumeroExpediente,  
 			C.TF_FechaEnvio						AS FechaRegistro,  
 			S.TN_CodSector						AS CodigoSector,  
 			S.TC_Descripcion					AS DescripcionSector,  
 			C.TC_Valor							AS Valor,
 			OO.TC_CodContexto					AS CodigoOficinaEmisora,  
 			OO.TC_Descripcion					AS NombreOficinaEmisora,  
 			OD.TC_CodOficina					AS CodigoOficinaOCJ,  
 			OD.TC_Nombre						AS NombreOficinaOCJ,  
 			C.TC_CodPuestoTrabajo				AS CodigoPuestoTrabajo,  
 			RTRIM(CONCAT(F.Nombre, ' ', F.PrimerApellido, ' ', F.SegundoApellido))  
 												AS NombrePersonaAsignada,  
  
 			TEMP.TC_Destinatario				AS NombreDestinatario, 
 			
 			C.TC_TipoComunicacion				AS CodigoTipoComunicacionJudicial,  
 			C.TB_TienePrioridad					AS TienePrioridad,
 			
 			TEMP.TB_EsMenorEdad					AS EsMenorEdad,  
  
 			C.TB_Cancelar						AS Cancelada,  
 			 CASE WHEN EXISTS( SELECT		TOP 1 IE.TU_CodEvento   
 								FROM		Agenda.IntervinienteEvento		IE  
 								INNER JOIN	Agenda.FechaEvento				FE  
 								ON			FE.TU_CodEvento					= IE.TU_CodEvento  
 								WHERE		IE.TU_CodInterviniente			= C.TU_CodInterviniente  
 								AND			FE.TF_FechaInicio				>= @FechaActual  
 								AND			FE.TB_Cancelada					= 0)  
 			   THEN 1 
 			   ELSE 0 
 			END					AS TieneSenalamiento,  
			CASE WHEN EXISTS (SELECT TOP   1 ID.TU_CodInterviniente 
 								FROM		 Expediente.IntervinienteDiscapacidad	ID 
 								WHERE		 ID.TU_CodInterviniente					= C.TU_CodInterviniente)  
			THEN 1 ELSE 0 END							AS TieneDiscapacidad,  
			CASE WHEN EXISTS (SELECT TOP 1	IV.TU_CodInterviniente 
 							   FROM			Expediente.IntervinienteVulnerabilidad	IV 
 							  WHERE			IV.TU_CodInterviniente					= C.TU_CodInterviniente)  
			THEN 1 ELSE 0 END							AS TieneVulnerabilidad,  
			C.TF_FechaEnvio							AS FechaIngreso,  
			C.TN_CodMotivoResultado					AS CodigoMotivoResultado,  
			C.TF_FechaResultado						AS FechaResultado,  
			HMC.TF_HoraInicio							AS HoraInicio,  
			HMC.TF_HoraFin							AS HoraFin,  
			TEMP.TC_DestinatarioNombreComercial		AS NombreComercialDestinatario,  
			OA.TC_Observaciones	                    AS ObservacionUltimoIntento,
			OA.TC_NombreRecibe						AS UltimaPersonaRecibe,
 			C.TB_ComunicacionAppMovil				AS ComunicacionTablet,
 			C.TB_ExcluidaAppMovil					AS ComunicacionExcluidaTablet,
 			C.TU_CodLegajo							AS CodigoLegajo,
			C.TF_FechaResolucion					AS FechaResolucion,
			'SplitPuestoTrabajoRegistro'			AS SplitPuestoTrabajoRegistro,  
			PFE.TC_CodPuestoTrabajo					AS Codigo, 

			'Split'									AS Split,  
			C.TC_Resultado							AS Resultado, 
			
			'SplitEstado'							AS SplitEstado,
			C.TC_Estado								AS Estado, 
			
			'SplitTipo'								AS SplitTipo,
			C.TC_TipoComunicacion					AS TipoComunicacion, 
			
			'SplitHorarioComunicacion'				AS SplitHorarioComunicacion,  
			HMC.TN_CodHorario						AS Codigo,  
			HMC.TF_Inicio_Vigencia					AS FechaActivacion,  
			HMC.TF_Fin_Vigencia						AS FechaDesactivacion,  
			HMC.TF_HoraInicio						AS HoraInicio,  
			HMC.TF_HoraFin							AS HoraFin,  

			'SplitTotalRegistros'					AS SplitTotalRegistros,  
			@TotalRegistros							AS TotalRegistros, 
			
 			'SplitTipoMedio'						AS SplitTipoMedio,  
			TMC.TC_TipoMedio						AS TipoMedio,  

 			'SplitSectorComunicacion'				AS SplitSectorComunicacion,
 			S.TC_CodOficinaOCJ						AS Codigo,
 			S.TC_Descripcion						AS Descripcion ,
 			S.TF_Fin_Vigencia						AS FechaDesactivacion,
 			S.TF_Inicio_Vigencia					AS FechaActivacion,
 			S.TN_CodSector							AS Codigo,

 			'SplitProvincia'						AS SplitProvincia,
 			PROV.TN_CodProvincia					AS Codigo,
 			PROV.TC_Descripcion						AS Descripcion,
 			PROV.TF_Inicio_Vigencia					AS FechaActivacion,
 			PROV.TF_Fin_Vigencia					AS FechaDesactivacion,

 			'SplitCanton'							AS SplitCanton,
 			CANT.TN_CodCanton						AS Codigo,
 			CANT.TC_Descripcion						AS Descripcion,
 			CANT.TF_Inicio_Vigencia					AS FechaActivacion,
 			CANT.TF_Fin_Vigencia					AS FechaDesactivacion,

 			'SplitDistrito'							AS SplitDistrito,
 			DIST.TN_CodDistrito						AS  Codigo,
 			DIST.TC_Descripcion						AS Descripcion,
 			DIST.TF_Inicio_Vigencia					AS FechaActivacion,
 			DIST.TF_Fin_Vigencia					AS FechaDesactivacion,
 			'SplitBarrio'							AS SplitBarrio,

 			BARR.TN_CodBarriO						AS Codigo,
 			BARR.TC_Descripcion						AS Descripcion,
 			BARR.TF_Inicio_Vigencia					AS FechaActivacion,
 			BARR.TF_Fin_Vigencia					AS FechaDesactivacion,

 			'SplitTipoMedioComunicacion'			AS SplitTipoMedioComunicacion,
 			TMC.TN_CodMedio							AS Codigo,
 			TMC.TC_Descripcion						AS Descripcion,
 			TMC.TC_TipoMedio						AS TipoMedio,

 			'SplitContextoEmisor'					AS SplitContextoEmisor,
 			OO.TC_CodContexto						AS Codigo,
 			OO.TC_Descripcion						AS Descripcion,

 			'SplitContextoOCJ'						AS SplitContextoOCJ,
 			OD.TC_CodOficina						AS Codigo,
 			OD.TC_Nombre							AS Descripcion,
			'SplitAsunto'							AS SplitAsunto,
			A.TN_CodAsunto							As Codigo,
			A.TC_Descripcion						As Descripcion,
			'SplitProcesoExpediente'				AS SplitProcesoExpediente,
			CP.TN_CodProceso						As Codigo,
			CP.TC_Descripcion						As Descripcion,
			'SplitProcesoLegajo'					AS SplitProcesoLegajo,
			CPL.TN_CodProceso						As Codigo,
			CPL.TC_Descripcion						As Descripcion
  FROM   (  
			SELECT		TU_CodComunicacion,  
						TC_Estado,  
						TF_FechaEnvio,
						TC_Destinatario,
						TB_EsMenorEdad,
						TC_DestinatarioNombreComercial
			FROM		@Comunicaciones  
			ORDER BY	TF_FechaEnvio		ASC 
 			OFFSET	(@L_NumeroPagina - 1) * @L_CantidadRegistros ROWS   
			FETCH NEXT @L_CantidadRegistros ROWS ONLY  
		)												AS TEMP  
  INNER JOIN	Comunicacion.Comunicacion				AS C  
  ON			C.TU_CodComunicacion					= TEMP.TU_CodComunicacion  
  
  INNER JOIN	Catalogo.TipoMedioComunicacion			AS TMC WITH(NOLOCK)  
  ON			TMC.TN_CodMedio							= C.TC_CodMedio
  
  INNER JOIN	Expediente.Expediente					AS E WITH(NOLOCK)  
  ON			E.TC_NumeroExpediente					= C.TC_NumeroExpediente  

 INNER JOIN		Expediente.ExpedienteDetalle			AS ED WITH(NOLOCK)  
  ON			ED.TC_NumeroExpediente					= E.TC_NumeroExpediente
 AND			ED.TC_CodContexto						= E.TC_CodContexto
  
  INNER JOIN	Catalogo.Contexto						AS OO WITH(NOLOCK)  
  ON			OO.TC_CodContexto						= C.TC_CodContexto  
  
  LEFT JOIN		Catalogo.Oficina						AS OD WITH(NOLOCK)  
  ON			OD.TC_CodOficina						= C.TC_CodContextoOCJ  

  LEFT JOIN		Comunicacion.Sector						AS S WITH(NOLOCK)  
  ON			S.TN_CodSector							= C.TN_CodSector 
  AND			S.TC_CodOficinaOCJ						= C.TC_CodContextoOCJ
  
  LEFT JOIN		Catalogo.HorarioMedioComunicacion		AS HMC WITH(NOLOCK)  
  ON			HMC.TN_CodHorario						= C.TN_CodHorarioMedio  

  LEFT JOIN		Comunicacion.ComunicacionIntervencion	AS CI WITH(NOLOCK)
  ON			CI.TU_CodComunicacion					= C.TU_CodComunicacion 
  AND			CI.TB_Principal							= 1  

  LEFT JOIN		Expediente.Intervencion					AS I WITH(NOLOCK)  
  ON			I.TU_CodInterviniente					= CI.TU_CodInterviniente  

  LEFT JOIN		Expediente.Representacion				AS R WITH(NOLOCK)  
  ON			R.TU_CodIntervinienteRepresentante     = C.TU_CodInterviniente 
  
  LEFT JOIN		Persona.Persona							AS RP WITH(NOLOCK)  
  ON			RP.TU_CodPersona						= I.TU_CodPersona 
  
  LEFT JOIN		Persona.PersonaFisica					AS RPF WITH(NOLOCK)  
  ON			RPF.TU_CodPersona						= RP.TU_CodPersona 
  
  LEFT JOIN		Catalogo.PuestoTrabajoFuncionario		AS PFE WITH(NOLOCK)  
  ON			PFE.TU_CodPuestoFuncionario				= C.TU_CodPuestoFuncionarioRegistro  

  OUTER APPLY	Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(C.TC_CodPuestoTrabajo) F 
   
  LEFT JOIN		Catalogo.Provincia						AS PROV WITH(NOLOCK)
  ON			PROV.TN_CodProvincia					= C.TN_CodProvincia  
  
  LEFT JOIN		Catalogo.Canton							AS CANT WITH(NOLOCK)
  ON			PROV.TN_CodProvincia					= CANT.TN_CodProvincia
  AND			C.TN_CodCanton							= CANT.TN_CodCanton
  
  LEFT JOIN		Catalogo.Distrito						AS DIST WITH(NOLOCK)
  ON			PROV.TN_CodProvincia					= DIST.TN_CodProvincia
  AND			CANT.TN_CodCanton						= DIST.TN_CodCanton
  AND			DIST.TN_CodDistrito						= C.TN_CodDistrito 
  
  LEFT JOIN		Catalogo.Barrio							AS BARR WITH(NOLOCK)
  ON			PROV.TN_CodProvincia					= BARR.TN_CodProvincia
  AND			CANT.TN_CodCanton						= BARR.TN_CodCanton
  AND			BARR.TN_CodDistrito						= BARR.TN_CodDistrito
  AND			BARR.TN_CodBarrio						= C.TN_CodBarrio 
  LEFT JOIN		Expediente.LegajoDetalle				AS L WITH(NOLOCK)
  ON			C.TU_CodLegajo							= L.TU_CodLegajo
  LEFT JOIN		Catalogo.Asunto							AS A WITH(NOLOCK)
  ON			L.TN_CodAsunto							= A.TN_CodAsunto
  LEFT JOIN		Catalogo.Proceso						AS CP WITH(NOLOCK)
  ON			CP.TN_CodProceso						= ED.TN_CodProceso

  LEFT JOIN		Catalogo.Proceso						AS CPL WITH(NOLOCK)
  ON			CPL.TN_CodProceso						= L.TN_CodProceso
  OUTER APPLY (
				SELECT TOP 1 TC_Observaciones, TC_NombreRecibe 
 				FROM		 Comunicacion.IntentoComunicacion IC WITH(NOLOCK)  
				WHERE		 IC.TU_CodComunicacion			 = C.TU_CodComunicacion 
 				ORDER BY	 IC.TF_FechaIntento	 DESC
			) OA
  WHERE			(TEMP.TC_Destinatario					LIKE IIF(@Destinatario IS NULL, TEMP.TC_Destinatario, '%' + @Destinatario + '%' COLLATE Latin1_general_CI_AI)
  OR			 TEMP.TC_Destinatario					IS NULL)
  
  
  
  ORDER BY												TEMP.TF_FechaEnvio ASC 

  
END  
GO
