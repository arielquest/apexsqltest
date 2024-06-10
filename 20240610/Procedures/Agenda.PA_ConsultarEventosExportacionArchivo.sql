SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Gómez>
-- Fecha de creación:		<09/12/2016>
-- Descripción:				<Consulta los eventos para la exportación de archivos pdf y excel>
-- Modificado por:		    <Tatiana Flores>
-- Fecha de modificación:   <25/08/2017>
-- Descripción:				<Se agrega un espacio después de la coma en participantes e intervinientes, y se tilda Físicos y Jurídicos>
-- Modificado por:		    <Ailyn López>
-- Fecha de modificación:   <20/06/2018>
-- Descripción:				<Se elimina convert del order by, para que tome tanto la fecha como a la hora>
-- ===========================================================================================
-- Modificación				<Jonathan Aguilar Navarro> <13/05/2018> <Se cambio el paremtro Oficina por Contexto>
-- Modificación				<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>
-- Modificación				<Jeffry Hernández> <03/10/2018> <Se reestructura todo el PA>
-- ========================================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<16/08/2019>
-- Descripción:				<Se modifica para formatear consulta como tabla en lugar de como JSON y con estandar de dapper>
-- ========================================================================================================================

CREATE PROCEDURE [Agenda].[PA_ConsultarEventosExportacionArchivo]
@Contexto Varchar(4),
@fecha Datetime2,
@usuarioRed Varchar(30), 
@vistaDia Bit,
@vistaSemana Bit,
@vistaMes Bit,
@vistaEventos Bit,
@TipoPersonaJuridica Char(1),
@TipoPersonaFisica Char(1)

As
Begin
	Declare  @FechaInicioBusqueda	Date; 
	Declare  @FechaFinBusqueda		Datetime

	--Se calcula la fecha de inicio de búsqueda de eventos
	SET @FechaInicioBusqueda = 
	Case 
		When				@vIstaDia		= 1					Then Cast(@fecha As Date) 
		When				@vIstAsemana	= 1					Then Agenda.FN_ObtenerInicioSemana(Convert(Date, @fecha, 102))
		When				@vIstaMes		= 1 
		Or					@vIstaEventos	= 1					Then Dateadd(Month, Datediff(Month, 0, @fecha), 0) 

	End

	SET @FechaFinBusqueda = 
	Case 
		When				@vIstaDia		= 1					Then Cast(@fecha As Date) 
		When				@vIstAsemana	= 1					Then Dateadd(Day, 6 , @FechaInicioBusqueda)
		When				@vIstaMes		= 1 
		Or					@vIstaEventos	= 1					Then Dateadd(s,-1,Dateadd(mm, Datediff(m,0,@fecha)+1,0))

	End	
	
	--Se le establece la hora 23:59:59 para poder evitar el casteo de fechas en el where, ya que implica un alto costo.
	SET @FechaFinBusqueda = DATETIMEFROMPARTS(DATEPART(YEAR,@FechaFinBusqueda),DATEPART(MONTH,@FechaFinBusqueda),DATEPART(DAY,@FechaFinBusqueda),23,59,59,59)

	IF (object_id('tempdb..Eventos_CTE')) > 0
	BEGIN
		  TRUNCATE TABLE #Eventos_CTE
	END
	ELSE
	BEGIN
		CREATE TABLE #Eventos_CTE(TU_CodEvento VARCHAR(100))
	END
	
	INSERT INTO #Eventos_CTE
		SELECT DISTINCT	FE.TU_CodEvento 
			 
		FROM		Agenda.FechaEvento			AS	FE
		Inner Join	Agenda.ParticipanteEvento	AS  PE
		ON          PE.TU_CodEvento				=	FE.TU_CodEvento
		Outer Apply Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(PE.TC_CodPuestoTrabajo) As F	

		WHERE	TF_FechaInicio  Between @FechaInicioBusqueda AND @FechaFinBusqueda 	
		And		(Nullif(@usuarioRed,'') Is Null  Or F.UsuarioRed = @usuarioRed)

	SELECT	
			E.TU_CodEvento						As Codigo,
			E.TC_CodContexto	            	As CodContexto,		
			E.TC_Descripcion					As Descripcion ,
			E.TC_Titulo							As Titulo,			
			E.TB_RequiereSala					As RequiereSala,				
			E.TF_FechaCreacion					As FechaCreacion,
			'SplitTipoEvento'	                As SplitTipoEvento,	
			tipo.TN_CodTipoEvento				As Codigo, 
			tipo.TC_Descripcion					As Descripcion,				
			'SplitPriOridadEvento'				As SplitPrioridadEvento,
			priOridad.TN_CodPriOridadEvento		As Codigo,		    
			priOridad.TC_Descripcion			As DescripciOn,
			'SplitExpediente'					AS SplitExpediente,	
			Expediente.TC_NumeroExpediente		As Numero,
			'SplitEstadoEvento'					As SplitEstadoEvento,	
			estadoEvento.TN_CodEstadoEvento 	As Codigo,
			estadoEvento.TC_DescripciOn		    As DescripciOn,    	
			'SplitMotivoEvento'             	As SplitMotivoEvento,		 
			MEE.TN_CodMotivoEstado				As Codigo, 			
			MEE.TC_Descripcion			    	As DescripciOn, 
			'SplitFuncionario'				    As SplitFuncionario,  
			Funcionario.TC_UsuarioRed			As UsuarioRed, 		
			Funcionario.TC_Nombre				As Nombre,			
			Funcionario.TC_PrimerApellido		As PrimerApellido,
			Funcionario.TC_SegundoApellido		As SegundoApellido,
			'SplitContexto'						As SplitContexto,
			E.TC_CodContexto					As Codigo,
			C.TC_Descripcion					AS Descripcion			
	FROM		#Eventos_CTE						AS ECTE
	INNER JOIN  Agenda.Evento						AS E	WITH(NOLOCK)
	ON			E.TU_CodEvento						=	ECTE.TU_CodEvento
	INNER JOIN  Catalogo.TipoEvento					As Tipo WITH(NOLOCK)
	ON          Tipo.TN_CodTipoEvento               =  E.TN_CodTipoEvento
	INNER JOIN  Catalogo.PriOridadEvento			As priOridad  WITH(NOLOCK)
	ON          priOridad.TN_CodPriOridadEvento     =  E.TN_CodPriOridadEvento
	LEFT JOIN   Expediente.Expediente               As Expediente  WITH(NOLOCK)
	ON          Expediente.TC_NumeroExpediente      =  E.TC_NumeroExpediente
	INNER JOIN  Catalogo.EstadoEvento               As estadoEvento  WITH(NOLOCK)
	ON          estadoEvento.TN_CodEstadoEvento     =  E.TN_CodEstadoEvento
	LEFT JOIN   Catalogo.MotivoEstadoEvento         As MEE  WITH(NOLOCK)
	ON          MEE.TN_CodMotivoEstado				=  E.TN_CodMotivoEstado
	INNER JOIN  Catalogo.Funcionario                As Funcionario WITH(NOLOCK)
	ON          E.TC_UsuarioCrea                    =  Funcionario.TC_UsuarioRed
	INNER JOIN	Catalogo.Contexto					AS	C
	On			E.TC_CodContexto					=	C.TC_CodContexto		
	WHERE 		E.TC_CodContexto					= @Contexto	
End
GO
