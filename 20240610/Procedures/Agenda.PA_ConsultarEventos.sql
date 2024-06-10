SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jefry Hernandez>
-- Fecha de creación:		<21/12/2016>
-- Descripción:				<Obtiene la información sobre eventos y sus participantes> 
--======================================================================================================================================================================================
-- Modificación:			<21/12/2016><Jefry Hernandez><Se cambia el nombre del metodo> 
-- Modificación:            <21/12/2016><Jefry Hernandez><Se agrega los datos codigotipo evento, codigo puestotrabajo>
-- Modificación:            <02/05/2016><Diego Navarrete><Se agrega un LEFT JOIN con la tabla legajo y debido al filtro>
--														 <de numero de expediente>
-- Modificación:            <02/05/2018><Diego Navarrete><Se agregan los parámetros @Estado y @NumeroDeExpediente>
-- Modificación:            <03/05/2018><Jefry Hernandez><Se agregan los parámetros  @fechaFin y @ConsultaDesdeAgenda. Se cambia el nombre del parametro @fecha por @fechaInicio>
-- =====================================================================================================================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <30/05/2018> <Se cambia los datos de oficina por contexto> 
-- Modificación				<Tatiana Flores> <10/09/2018> <Se ignoran las horas de las fechas> 
-- =======================================================================================================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<13/08/2019>
-- Descripción:				<Se modifica para cambiar parámetro código de legajo por número de expediente >
-- =======================================================================================================================================================================================
-- Modificación				<AIDA ELENA SILES R> <25/06/2021> <Se agrega el parámetro @ListaTiposEvento para enviar la lista de tipos de evento. Ya que el parámetro actual tiposEvento
--							presenta una excepción cuando se envia un string extenso. Se mantiene el parámetro para no afectar GL y otros sistemas que hagan uso de esta consulta> 
-- Modificación				<AIDA ELENA SILES R> <14/07/2021> <Corrección incidente ID 202403. Se agrega parámetro @ListaPuestosTrabajo y se sustituye por @tiposPuesto VARCHAR(1000), ya que
--							este parámetro presenta una excepción cuando se enviaba una string extenso. Se permite consultar los eventos con puestos de trabajo activos e inactivos.> 
-- =======================================================================================================================================================================================

CREATE PROCEDURE [Agenda].[PA_ConsultarEventos] 
  @tiposEvento			VARCHAR(1000),
  @Contexto				VARCHAR(4),
  @fechaInicio			DATETIME2	= NULL,
  @fechaFin				DATETIME2,
  @vIstaDia				BIT,
  @vIstAsemana			BIT,
  @vIstaMes				BIT,
  @vIstaEventos			BIT,
  @NumeroDeExpediente	CHAR(14)	= NULL,
  @Estado				SMALLINT	= NULL,
  @ConsultaDesdeAgenda	BIT,
  @ListaPuestosTrabajo  PuestosTrabajoConsultaType      READONLY,
  @ListaTiposEvento		TiposEventoConsultaType			READONLY
AS
BEGIN
DECLARE--VARIABLES
	@L_tiposEvento			VARCHAR(1000)	= @tiposEvento,
	@L_Contexto				VARCHAR(4)		= @Contexto,
	@L_fechaInicio			DATETIME2		= @fechaInicio,
	@L_fechaFin				DATETIME2		= @fechaFin,
	@L_vIstaDia				BIT				= @vIstaDia,
	@L_vIstAsemana			BIT				= @vIstAsemana,
	@L_vIstaMes				BIT				= @vIstaMes,
	@L_vIstaEventos			BIT				= @vIstaEventos,
	@L_NumeroDeExpediente	CHAR(14)		= @NumeroDeExpediente,
	@L_Estado				SMALLINT		= @Estado,
	@L_ConsultaDesdeAgenda	BIT				= @ConsultaDesdeAgenda,
	@L_Inicio				DATE, 
	@L_Fin					DATE,
	--Se usan solo si el usuario está en la vIsta semanal
	@L_FechaInicioSemana	DATE, --Domingo
	@L_FechaFinSemana		DATE, --Sábado
	-- Se usan solo si el usuario está en la vIsta Mensual
	@L_FechaInicioMes		DATE, --Último día del mes
	@L_FechaFinMes			DATE  --Primer día del mes

	SET @L_Inicio = Cast(@L_fechaInicio AS DATE);
	SET @L_Fin	= Cast(@L_fechaFin AS DATE);

	IF(@L_ConsultaDesdeAgenda = 1)
	BEGIN
		
		IF (@L_tiposEvento IS NOT NULL)
		BEGIN
			SET NOCOUNT ON;	
			-- Se calcula el fin del mes
			SET @L_FechaFinMes = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@L_fechaInicio)+1,0))

			-- Se calcula el inicio del mes
			SET @L_FechaInicioMes = DATEADD(MONTH, DATEDIFF(MONTH, 0, @L_fechaInicio), 0) 

			-- Se calcula el día inicial de la semana (Domingo)
			SET @L_FechaInicioSemana = Agenda.FN_ObtenerInicioSemana(CONVERT(DATE, @L_fechaInicio, 102));

			-- Se calcula el día final de la semana (Sábado)
			SET @L_FechaFinSemana = DATEADD(DAY, 6 , @L_FechaInicioSemana);

			-- Se cOnvierte el parámetro @tiposEvento y se guarda en una tabla (LIstaTiposEvento)
			WITH LIstaTiposEvento 
			AS
			(
				SELECT S  AS TN_CodTipoEvento
				FROM dbo.SplitString (@L_tiposEvento, ',')
			)

			--SelecciOne de:
			SELECT DISTINCT
								--Expediente
								E.TC_NumeroExpediente			    AS NumeroExpediente,

								--Funcionario
								F.Nombre+' '+
								F.PrimerApellido+' '+
								F.SegundoApellido		            AS NombreFunciOnario,

								--PuestoTrabajo *
								PT.TC_DescripciOn				    AS DescripciOnPuestoParticipante,
								PT.TC_CodPuestoTrabajo				AS CodigoPuestoTrabajoParticipante,

								--FechaParticipanteParcial *
								FPP.TF_FechaInicioParticipaciOn	    AS FechaInicioParcial,
								FPP.TF_FechaFinParticipaciOn		AS FechaFinParcial,

								--ParticipanteFechaEvento *
								PFE.TB_ParticipaciOnParcial		    AS EsParcial,

								--TipoEvento 
								TE.TN_CodTipoEvento				    AS CodigoTipoEvento, 
								TE.TC_Descripcion				    AS DescripcionTipoEvento, 
								TE.TC_ColorEvento				    AS ColorEvento, 
								TE.TB_EsRemate					    AS EsRemate,	

								--FechaEvento 
								FE.TB_Cancelada						AS Cancelada, 
								FE.TU_CodFechaEvento				AS CodigoFechaEvento,
								FE.TC_ObservaciOnes					AS ObservaciOnes,		
								FE.TF_FechaInicio					AS FechaInicio,
								FE.TF_FechaFin						AS FechaFin, 

								--Evento 	
								E.TU_CodEvento						AS CodigoEvento,
								E.TC_DescripciOn					AS DescripciOnEvento,
								E.TC_Titulo							AS Titulo,
								E.TN_CodEstadoEvento				AS Estado,
								--SalaJuicio
								SJ.TC_Descripcion                   AS DescripcionSala		
		
			FROM 	   

			--Se filtra Por puesto	
			--ListaTiposPuesto: Almacena los Tipos Puesto seleccionados por el coordinador	
								@ListaPuestosTrabajo				AS LP
		  
			--ParticipanteEvento		
			INNER JOIN          Agenda.ParticipanteEvento			AS PE
			ON                  PE.TC_CodPuestoTrabajo              =  LP.TC_CodPuestoTrabajo 

			--Evento
			INNER JOIN			Agenda.Evento						AS E               
			ON					PE.TU_CodEvento						=  E.TU_CodEvento  
		  		  
			--TipoEvento
			INNER JOIN			Catalogo.TipoEvento					AS TE
			ON					E.TN_CodTipoEvento					=  TE.TN_CodTipoEvento

			-- Se filtra Por Tipo Evento 		
			-- Tipos Evento seleccionados por el coordinador
			INNER JOIN			ListaTiposEvento					AS LTE 		    
			ON					E.TN_CodTipoEvento					=  LTE.TN_CodTipoEvento  	  
		  
			-- FechaEvento
			INNER JOIN			Agenda.FechaEvento					AS FE 
			ON					FE.TU_CodEvento						=  E.TU_CodEvento 

			--PuestoTrabajo
			INNER JOIN			Catalogo.PuestoTrabajo				AS PT 
			ON					PT.TC_CodPuestoTrabajo				= LP.TC_CodPuestoTrabajo	
		
			OUTER APPLY         Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(PT.TC_CodPuestoTrabajo) AS F

			-- ParticipanteFechaEvento
			LEFT JOIN			Agenda.ParticipanteFechaEvento		AS PFE
			ON					PFE.TU_CodFechaEvento				=  FE.TU_CodFechaEvento AND
								PFE.TU_CodParticipaciOn				=  PE.TU_CodParticipaciOn

			-- FechaParticipanteParcial
			LEFT JOIN			Agenda.FechaParticipanteParcial		AS FPP
			ON					FPP.TU_CodFechaEvento				= PFE.TU_CodFechaEvento
			AND					FPP.TU_CodParticipaciOn				= PFE.TU_CodParticipaciOn
			
			-- Sala Juicio
			LEFT JOIN			Catalogo.SalaJuicio					AS SJ 
			ON					SJ.TN_CodSala						= FE.TN_CodSala  


			---- En dOnde Fecha Inicio del evento esté entre
			WHERE CAST(FE.TF_FechaInicio AS DATE)
	 
			Between

			--Esta fecha
			CASE 
			--SI LA VIsTA ES DÍA 
			WHEN				@L_vIstaDia = 1						THEN @L_Inicio 

			--SI LA VIsTA ES SEMANA 
			WHEN				@L_vIstAsemana = 1					THEN @L_FechaInicioSemana 

			--SI LA VIsTA ES MES O EVENTOS 
			WHEN				@L_vIstaMes = 1 
			Or					@L_vIstaEventos = 1					THEN @L_FechaInicioMes

			END

			AND

			-- Y esta otra

			CASE 
			--SI LA VIsTA ES DÍA
			WHEN				@L_vIstaDia = 1						THEN @L_Inicio 

			--SI LA VIsTA ES SEMANA 
			WHEN				@L_vIstAsemana = 1					THEN @L_FechaFinSemana 

			--SI LA VIsTA ES MES O EVENTOS 
			WHEN				@L_vIstaMes = 1 
			Or					@L_vIstaEventos = 1					THEN @L_FechaFinMes

			END

			AND
								E.TC_CodContexto					= @L_Contexto

			AND					FE.TB_Cancelada						= 0 
		
			AND	
				(
				(@L_NumeroDeExpediente  IS NOT NULL AND  	E.TC_NumeroExpediente		=  @L_NumeroDeExpediente )
				OR
				 @L_NumeroDeExpediente  IS NULL
				)
			AND				E.TN_CodEstadoEvento = COALESCE (@L_Estado,E.TN_CodEstadoEvento)

 		
			ORDER BY			FE.TU_CodFechaEvento,
								TF_FechaInicio ASC	 

			--Nota: Solo se evalúa la fecha de Inicio del evento, ya que siempre terminará el mismo día
		END
		ELSE --En este caso se utiliza la lista de tipos de eventos que viene en el parámetro @ListaTiposEvento
		BEGIN
		SET NOCOUNT ON;	
			-- Se calcula el fin del mes
			SET @L_FechaFinMes = DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,@L_fechaInicio)+1,0))

			-- Se calcula el inicio del mes
			SET @L_FechaInicioMes = DATEADD(MONTH, DATEDIFF(MONTH, 0, @L_fechaInicio), 0) 

			-- Se calcula el día inicial de la semana (Domingo)
			SET @L_FechaInicioSemana = Agenda.FN_ObtenerInicioSemana(CONVERT(DATE, @L_fechaInicio, 102));

			-- Se calcula el día final de la semana (Sábado)
			SET @L_FechaFinSemana = DATEADD(DAY, 6 , @L_FechaInicioSemana);

			--SelecciOne de:
			SELECT DISTINCT
								--Expediente
								E.TC_NumeroExpediente			    AS NumeroExpediente,

								--Funcionario
								F.Nombre+' '+
								F.PrimerApellido+' '+
								F.SegundoApellido		            AS NombreFunciOnario,

								--PuestoTrabajo *
								PT.TC_DescripciOn				    AS DescripciOnPuestoParticipante,
								PT.TC_CodPuestoTrabajo				AS CodigoPuestoTrabajoParticipante,

								--FechaParticipanteParcial *
								FPP.TF_FechaInicioParticipaciOn	    AS FechaInicioParcial,
								FPP.TF_FechaFinParticipaciOn		AS FechaFinParcial,

								--ParticipanteFechaEvento *
								PFE.TB_ParticipaciOnParcial		    AS EsParcial,

								--TipoEvento 
								TE.TN_CodTipoEvento				    AS CodigoTipoEvento, 
								TE.TC_Descripcion				    AS DescripcionTipoEvento, 
								TE.TC_ColorEvento				    AS ColorEvento, 
								TE.TB_EsRemate					    AS EsRemate,	

								--FechaEvento 
								FE.TB_Cancelada						AS Cancelada, 
								FE.TU_CodFechaEvento				AS CodigoFechaEvento,
								FE.TC_ObservaciOnes					AS ObservaciOnes,		
								FE.TF_FechaInicio					AS FechaInicio,
								FE.TF_FechaFin						AS FechaFin, 

								--Evento 	
								E.TU_CodEvento						AS CodigoEvento,
								E.TC_DescripciOn					AS DescripciOnEvento,
								E.TC_Titulo							AS Titulo,
								E.TN_CodEstadoEvento				AS Estado,
								--SalaJuicio
								SJ.TC_Descripcion                   AS DescripcionSala		
		
			FROM 	   

			--Se filtra Por puesto	
			--ListaTiposPuesto: Almacena los Tipos Puesto seleccionados por el coordinador	
								@ListaPuestosTrabajo				AS LP
		  
			--ParticipanteEvento		
			INNER JOIN          Agenda.ParticipanteEvento			AS PE
			ON                  PE.TC_CodPuestoTrabajo              =  LP.TC_CodPuestoTrabajo

			--Evento
			INNER JOIN			Agenda.Evento						AS E               
			ON					PE.TU_CodEvento						=  E.TU_CodEvento  
		  		  
			--TipoEvento
			INNER JOIN			Catalogo.TipoEvento					AS TE
			ON					E.TN_CodTipoEvento					=  TE.TN_CodTipoEvento

			-- Se filtra Por Tipo Evento 		
			-- Tipos Evento seleccionados por el coordinador
			INNER JOIN			@ListaTiposEvento					AS LTE 		    
			ON					E.TN_CodTipoEvento					=  LTE.TN_CodTipoEvento  	  
		  
			-- FechaEvento
			INNER JOIN			Agenda.FechaEvento					AS FE 
			ON					FE.TU_CodEvento						=  E.TU_CodEvento 

			--PuestoTrabajo
			INNER JOIN			Catalogo.PuestoTrabajo				AS PT 
			ON					PT.TC_CodPuestoTrabajo				= LP.TC_CodPuestoTrabajo
		
			OUTER APPLY         Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(PT.TC_CodPuestoTrabajo) AS F

			-- ParticipanteFechaEvento
			LEFT JOIN			Agenda.ParticipanteFechaEvento		AS PFE
			ON					PFE.TU_CodFechaEvento				=  FE.TU_CodFechaEvento AND
								PFE.TU_CodParticipaciOn				=  PE.TU_CodParticipaciOn

			-- FechaParticipanteParcial
			LEFT JOIN			Agenda.FechaParticipanteParcial		AS FPP
			ON					FPP.TU_CodFechaEvento				= PFE.TU_CodFechaEvento
			AND					FPP.TU_CodParticipaciOn				= PFE.TU_CodParticipaciOn
			
			-- Sala Juicio
			LEFT JOIN			Catalogo.SalaJuicio					AS SJ 
			ON					SJ.TN_CodSala						= FE.TN_CodSala  


			---- En dOnde Fecha Inicio del evento esté entre
			WHERE CAST(FE.TF_FechaInicio AS DATE)
	 
			Between

			--Esta fecha
			CASE 
			--SI LA VIsTA ES DÍA 
			WHEN				@L_vIstaDia = 1						THEN @L_Inicio 

			--SI LA VIsTA ES SEMANA 
			WHEN				@L_vIstAsemana = 1					THEN @L_FechaInicioSemana 

			--SI LA VIsTA ES MES O EVENTOS 
			WHEN				@L_vIstaMes = 1 
			Or					@L_vIstaEventos = 1					THEN @L_FechaInicioMes

			END

			AND

			-- Y esta otra

			CASE 
			--SI LA VIsTA ES DÍA
			WHEN				@L_vIstaDia = 1						THEN @L_Inicio 

			--SI LA VIsTA ES SEMANA 
			WHEN				@L_vIstAsemana = 1					THEN @L_FechaFinSemana 

			--SI LA VIsTA ES MES O EVENTOS 
			WHEN				@L_vIstaMes = 1 
			Or					@L_vIstaEventos = 1					THEN @L_FechaFinMes

			END

			AND
								E.TC_CodContexto					= @L_Contexto

			AND					FE.TB_Cancelada						= 0 
		
			AND	
				(
				(@L_NumeroDeExpediente  IS NOT NULL AND  	E.TC_NumeroExpediente		=  @L_NumeroDeExpediente )
				OR
				 @L_NumeroDeExpediente  IS NULL
				)
			AND				E.TN_CodEstadoEvento = COALESCE (@L_Estado,E.TN_CodEstadoEvento)

 		
			ORDER BY			FE.TU_CodFechaEvento,
								TF_FechaInicio ASC	 

			--Nota: Solo se evalúa la fecha de Inicio del evento, ya que siempre terminará el mismo día
		END
		
	END
	ELSE
	BEGIN

		SELECT	DISTINCT
					E.TC_NumeroExpediente			    AS NumeroExpediente,
					E.TU_CodEvento						AS CodigoEvento,
					E.TC_Descripcion					AS DescripcionEvento,
					E.TC_Titulo							AS Titulo,
					E.TN_CodEstadoEvento				AS Estado,
					EE.TC_Descripcion					AS DescripcionEstadoEvento,
					TE.TC_Descripcion					AS DescripcionTipoEvento

		FROM		Agenda.FechaEvento			AS	FE	
		INNER JOIN	Agenda.Evento				AS	E
		ON			E.TU_CodEvento				=	FE.TU_CodEvento		
		INNER JOIN	Catalogo.EstadoEvento		AS  EE
		ON			E.TN_CodEstadoEvento		=	EE.TN_CodEstadoEvento
		INNER JOIN	Catalogo.TipoEvento			AS  TE
		ON			E.TN_CodTipoEvento			=	TE.TN_CodTipoEvento		

		WHERE	(@L_NumeroDeExpediente			IS NULL 
		OR		E.TC_NumeroExpediente			= @L_NumeroDeExpediente)
		AND		CAST(FE.TF_FechaInicio AS DATE)	BETWEEN   @L_Inicio  AND @L_Fin	
		AND		CAST(FE.TF_FechaFin	AS DATE)	BETWEEN   @L_Inicio  AND @L_Fin
		AND		EE.TB_FinalizaEvento			=	0
		AND		E.TC_CodContexto				=	@L_Contexto		
		AND		FE.TB_Cancelada					=	0
		AND		FE.TB_Lista						=	0
		AND		E.TB_RequiereSala				=	1		
				
	END	
END









GO
