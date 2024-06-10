SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Jiménez Alvarado>
-- Fecha de creación:		<21/03/2017>
-- Descripción :			<Obtiene el próximo evento de un interviniente> 

-- Creado por:				<Jeffry Hernández>
-- Fecha de creación:		<04/11/2017>
-- Descripción :			<Se cambia fechafin por fecha inicio en el where> 
-- Modificación:            <31/01/2018> <Ailyn López> <Se cambia el INNER por LEFT en la condición de MotivoEstadoEvento,
--							ya que este campo permite NULL>
-- =================================================================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<13/08/2019>
-- Descripción:				<Se modifica para cambiar parámetro código de legajo por número de expediente>
-- =================================================================================================================================================
CREATE PROCEDURE [Agenda].[PA_ConsultarProximoEvento]
	@CodInterviniente	UNIQUEIDENTIFIER
AS
BEGIN
	DECLARE @FechaActual AS DATETIME = GETDATE()

	--Obtiene el próximo evento del interviniente indicado
	SELECT TOP 1 
					Eve.TC_NumeroExpediente					  AS NumeroExpediente,			Eve.TU_CodEvento				AS Codigo,
					Eve.TC_Descripcion						  AS Descripcion,				Eve.TF_FechaCreacion			AS FechaCreacion,
					Eve.TC_Titulo		                      AS Titulo,					Eve.TB_RequiereSala				AS RequiereSala,
					'SplitTipoEvento'	                      AS SplitTipoEvento,			tipo.TN_CodTipoEvento			AS Codigo, 
					tipo.TC_Descripcion					      AS Descripcion,				'SplitPrioridadEvento'			AS SplitPrioridadEvento,
					prioridad.TN_CodPrioridadEvento		      AS Codigo,					prioridad.TC_DescripciOn		AS Descripcion,
					'SplitEstadoEvento'					      AS SplitEstadoEvento,			estadoEvento.TN_CodEstadoEvento AS Codigo,
					estadoEvento.TC_Descripcion		          AS Descripcion,    			'SplitMotivoEvento'             AS SplitMotivoEvento,		 
					MEE.TN_CodMotivoEstado					  AS Codigo, 					MEE.TC_Descripcion			    AS Descripcion, 
					'SplitFuncionario'				          AS SplitFuncionario,			Funcionario.TC_UsuarioRed		AS UsuarioRed, 		
					Funcionario.TC_Nombre					  AS Nombre,					Funcionario.TC_PrimerApellido	AS PrimerApellido,
					Funcionario.TC_SegundoApellido			  AS SegundoApellido,
					'SplitFechasEvento'				          AS SplitFechasEvento,
					Fechas.TF_FechaInicio					  AS FechaInicio,
					Fechas.TF_FechaFin						  AS FechaFin,
					Fechas.TU_CodFechaEvento				  AS Codigo

	FROM		  Agenda.Evento Eve
	INNER JOIN	  [Agenda].[FechaEvento]					  AS Fechas WITH(NOLOCK)
	ON			  Eve.TU_CodEvento							  =  Fechas.TU_CodEvento
	INNER JOIN	  [Agenda].[IntervinienteEvento]			  AS Interviniente WITH(NOLOCK)
	ON			  Eve.TU_CodEvento							  =  Interviniente.TU_CodEvento
	INNER JOIN    [Catalogo].[TipoEvento]                     AS tipo WITH(NOLOCK)
	ON            tipo.TN_CodTipoEvento                       =  Eve.TN_CodTipoEvento
	INNER JOIN    [Catalogo].[PrioridadEvento]                AS prioridad  WITH(NOLOCK)
	ON            priOridad.TN_CodPrioridadEvento             =  Eve.TN_CodPriOridadEvento
	INNER JOIN    [Catalogo].[EstadoEvento]                   AS estadoEvento WITH(NOLOCK)
	ON            estadoEvento.TN_CodEstadoEvento             =  Eve.TN_CodEstadoEvento
	LEFT JOIN	  [Catalogo].[MotivoEstadoEvento]             AS MEE WITH(NOLOCK)
	ON            MEE.TN_CodMotivoEstado					  =  Eve.TN_CodMotivoEstado
	INNER JOIN    [Catalogo].[Funcionario]                    AS Funcionario WITH(NOLOCK)
	ON            Eve.TC_UsuarioCrea                          =  Funcionario.TC_UsuarioRed
	WHERE		  Interviniente.TU_CodInterviniente			  =	 @CodInterviniente
	AND			  Fechas.TF_FechaInicio >= @FechaActual 
	AND			  Fechas.TB_Cancelada = 0
	ORDER BY	  Fechas.TF_FechaInicio ASC
		  
END


GO
