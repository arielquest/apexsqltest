SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jeffry Hernandez>
-- Fecha de creación:		<02/07/2017>
-- Descripción:				<Consultar el registo de Solicitud Sala Juicio>
-- =======================================================================================================================================
-- Modificación:			<Tatiana Flores> <17/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- Modificación:			<Andrés Díaz><31/08/2018><Se agrega filtros para consultar solicitudes con sala, sin sala y todas.>
-- Modificación:			<Tatiana Flores> <11/09/2018> <Se verifica si la hora es '12:00:00 AM' para asiganarle la hora '11:59:59 PM'>
-- Modificación:			<Ailyn López> <02/10/2018> <Se crea FechasEvento_CTE para almacenar los códigos de eventos>
-- =======================================================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas - Prueba>
-- Fecha:					<20/08/2019>
-- Descripción:				<Se modifica para cambiar parámetro código de legajo por número de expediente>
-- =======================================================================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarSolicitudSalaJuicio]
	@CodEvento				Uniqueidentifier	= Null,
	@FechaInicio			Datetime2			= Null,
	@FechaFin				Datetime2			= Null,
	@NumeroExpediente		Char(14)			= Null,
	@ResultadoSolicitud		Char(1)				= Null,
	@CodContexto			varchar(4)			= Null,
	@TipoSolicitud			Char(1)				= Null,
	@TipoSolicitudTodas		Char(1)				= Null,
	@TipoSolicitudSinSala	Char(1)				= Null,
	@TipoSolicitudConSala	Char(1)				= Null
AS
Begin 

	DECLARE @Fecha Date

	IF ((SELECT CONVERT(Time, @FechaFin)) = '12:00:00 AM')
	BEGIN
		SET @fecha = CONVERT(Date, @FechaFin)
		SET @FechaFin =  CONVERT(Datetime2, Convert(Varchar, @fecha) + ' ' + '11:59:59 PM')
	END

	if(@CodEvento IS NULL)
	BEGIN

		WITH 
		FechasEvento_CTE
		AS
		(
			SELECT DISTINCT TU_CodEvento 
			FROM	Agenda.FechaEvento		With(Nolock) 
			WHERE	TF_FechaInicio			BETWEEN @FechaInicio AND  @FechaFin
			AND		TF_FechaFin				BETWEEN @FechaInicio AND  @FechaFin
			AND		TB_Cancelada			=	0
			AND		TB_Lista				=	0
			AND		1						= Case	When @TipoSolicitud = @TipoSolicitudTodas OR @TipoSolicitud IS NULL Then  1
													When @TipoSolicitud = @TipoSolicitudSinSala AND TN_CodSala IS NULL Then 1
													When @TipoSolicitud = @TipoSolicitudConSala AND TN_CodSala IS NOT NULL Then 1 End
		)

		SELECT 
		SSJ.TU_CodSolicitud			As	Codigo,				SSJ.TN_CantidadPersonas	As	CantidadPersonas,
		SSJ.TF_FechaSolicitud		As	FechaSolicitud,		SSJ.TF_FechaResultado	As	FechaResultado,
		SSJ.TC_Observaciones		As	Observaciones,		'Split'					As	Split,
		E.TU_CodEvento				As	Codigo,				E.TC_Titulo				As	Titulo,
		E.TC_Descripcion			As	Descripcion,		E.TB_RequiereSala		As	RequiereSala,
		E.TF_FechaCreacion			As	FechaCreacion,		E.TC_NumeroExpediente	As	NumeroExpediente,	
		Agenda.FN_ConsultarCantidadParticipantesEvento(E.TU_CodEvento)				As	CantidadParticipantes,
		'Split'						As	Split,				E.TC_NumeroExpediente	As	Numero,
		'Split'						As	Split,				TE.TC_Descripcion		As	Descripcion,	
		TE.TN_CodTipoEvento			As	Codigo,				'Split'					As	Split,			
		CO.TC_CodContexto			As	Codigo,				CO.TC_Descripcion		As	Descripcion,
		'Split'						As	Split,				C.TN_CodCircuito		As	Codigo,			
		C.TC_Descripcion			As	Descripcion,		'Split'					As	Split,
		PE.TN_CodPrioridadEvento	As	Codigo,				PE.TC_Descripcion		As	Descripcion,
		'Split'						As	Split,				E.TN_CodEstadoEvento	As	Codigo,
		'Split'						As	Split,				E.TN_CodMotivoEstado	As	Codigo
		FROM		
		FechasEvento_CTE			AS  Fecha
		
		INNER JOIN  Agenda.SolicitudSalaJuicio	As	SSJ With(Nolock) 
		ON			Fecha.TU_CodEvento			=	SSJ.TU_CodEvento

		INNER JOIN	Agenda.Evento				As	E	With(Nolock) 
		On			SSJ.TU_CodEvento			=	E.TU_CodEvento		

		INNER JOIN	Catalogo.TipoEvento			As	TE	With(Nolock) 
		On			E.TN_CodTipoEvento			=	TE.TN_CodTipoEvento

		INNER JOIN	Catalogo.Contexto			As	CO With(Nolock)
		On			E.TC_CodContexto			=	CO.TC_CodContexto	

		INNER JOIN	Catalogo.Oficina			As	O  With(Nolock)     
		On			O.TC_CodOficina				=	CO.TC_CodOficina

		INNER JOIN	Catalogo.Circuito			As	C	With(Nolock)     
		On			C.TN_CodCircuito			=	O.TN_CodCircuito

		INNER JOIN  Catalogo.PrioridadEvento	As	PE	With(Nolock) 
		On			PE.TN_CodPrioridadEvento	=	E.TN_CodPrioridadEvento		

		WHERE		E.TB_RequiereSala			=	1		
		AND			(@CodContexto				IS  NULL		
		OR 			E.TC_CodContexto			=   @CodContexto)				
		AND			(@NumeroExpediente			IS	NULL 
		OR			E.TC_NumeroExpediente		=	@NumeroExpediente) 
		And			((@ResultadoSolicitud		IS	NULL 
		And			SSJ.TC_ResultadoSolicitud	IS	NULL)
		OR			SSJ.TC_ResultadoSolicitud   =	@ResultadoSolicitud)

		ORDER BY	SSJ.TF_FechaSolicitud, PE.TN_CodPrioridadEvento, E.TC_Titulo;

	END
	ELSE
	BEGIN

		SELECT DISTINCT 
		SSJ.TU_CodSolicitud			As	Codigo,				SSJ.TN_CantidadPersonas	As	CantidadPersonas,
		SSJ.TF_FechaSolicitud		As	FechaSolicitud,		SSJ.TF_FechaResultado	As	FechaResultado,
		SSJ.TC_Observaciones		As	Observaciones,		'Split'					As	Split,
		E.TU_CodEvento				As	Codigo,				E.TC_Titulo				As	Titulo,
		E.TC_Descripcion			As	Descripcion,		E.TB_RequiereSala		As	RequiereSala,
		E.TF_FechaCreacion			As	FechaCreacion,		E.TC_NumeroExpediente	As	NumeroExpediente,	
		Agenda.FN_ConsultarCantidadParticipantesEvento(E.TU_CodEvento)				As	CantidadParticipantes,
		'Split'						As	Split,				E.TC_NumeroExpediente	As	Numero,
		'Split'						As	Split,				TE.TC_Descripcion		As	Descripcion,	
		TE.TN_CodTipoEvento			As	Codigo,				'Split'					As	Split,			
		CO.TC_CodContexto			As	Codigo,				CO.TC_Descripcion		As	Descripcion,
		'Split'						As	Split,				C.TN_CodCircuito		As	Codigo,			
		C.TC_Descripcion			As	Descripcion,		'Split'					As	Split,
		PE.TN_CodPrioridadEvento	As	Codigo,				PE.TC_Descripcion		As	Descripcion,
		'Split'						As	Split,				E.TN_CodEstadoEvento	As	Codigo,
		'Split'						As	Split,				E.TN_CodMotivoEstado	As	Codigo

		FROM		
					Agenda.SolicitudSalaJuicio	As	SSJ With(Nolock) 
		INNER JOIN	Agenda.Evento				As	E	With(Nolock) 
		On			SSJ.TU_CodEvento			=	E.TU_CodEvento

		INNER JOIN	Catalogo.TipoEvento			As	TE	With(Nolock) 
		On			E.TN_CodTipoEvento			=	TE.TN_CodTipoEvento

		INNER JOIN	Catalogo.Contexto			As CO With(Nolock)
		On			E.TC_CodContexto			= CO.TC_CodContexto	

		INNER JOIN	Catalogo.Oficina			As	O  With(Nolock)     
		On			O.TC_CodOficina				=	CO.TC_CodOficina

		INNER JOIN	Catalogo.Circuito			As	C	With(Nolock)     
		On			C.TN_CodCircuito			=	O.TN_CodCircuito

		INNER JOIN  Catalogo.PrioridadEvento	As	PE	With(Nolock) 
		On			PE.TN_CodPrioridadEvento	=	E.TN_CodPrioridadEvento

		WHERE		SSJ.TU_CodEvento			=	@CodEvento

		Order by	SSJ.TF_FechaSolicitud, PE.TN_CodPrioridadEvento, E.TC_Titulo;

	END
End

GO
