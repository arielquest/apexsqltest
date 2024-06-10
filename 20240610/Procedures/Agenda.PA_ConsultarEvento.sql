SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Tatiana Flores>
-- Fecha de creación:		<18/01/2017>
-- Descripción:				<Obtiene un evento> 
-- =========================================================================================================
-- Modificado               <Stefany Quesada><Se agrega el campo @CodLegajo para filtrar por Expediente>
-- Fecha de modificaci{on:	<14/08/2017>
-- Modificado por:		    <Ailyn López> 
-- Descripción:             <Se agrega el order by TF_FechaInicio Asc>
-- Modificado por:		    <Jeffry Hernández> 
-- Fecha de modificación:	<20/04/2018>
-- Descripción:             <Se separa sp en dos consultas>
-- Modificado por:		    <Ailyn López> 
-- Fecha de modificación:	<28/05/2018>
-- Descripción:             <Se pasa la segunda consulta a un sp nuevo>
-- Modificación				<Jonatan Aguilar Navarro> <30/05/2018> <Se cambio el campo TC_CodOficina por TC_CodContexto> 
-- =========================================================================================================
-- Modificado por:			<13/08/2019> <Ronny Ramírez Rojas> <Se modifica para cambiar parámetro código de legajo por número de expediente>
-- Modificación:			<28/06/2021> <Aida Elena Siles R> <Se agrega a la consulta el dato TB_EsRemate>
-- Modificación:			<14/06/2022> <Ricardo Alfonso Jiménez Arroyo> <Se agrega a la consulta el dato FinalizaEvento>
-- =========================================================================================================
CREATE PROCEDURE  [Agenda].[PA_ConsultarEvento] 
 @codEvento UNIQUEIDENTIFIER = NULL
AS
BEGIN
--VARIABLES LOCALES
DECLARE @L_codEvento	UNIQUEIDENTIFIER = @codEvento;
--LÓGICA
		;WITH
		PrimerasFechas
		AS
		(
			SELECT MIN	(TF_FechaInicio)	AS FechaInicio,	TU_CodEvento
			FROM		Agenda.FechaEvento	WITH(NOLOCK)					
			GROUP BY	TU_CodEvento 
		)

		SELECT 
				Eve.TU_CodEvento					AS Codigo,
				Eve.TC_CodContexto	            	AS CodContexto,		
				Eve.TC_Descripcion					AS Descripcion ,
				Eve.TC_Titulo		                AS Titulo,			
				Eve.TB_RequiereSala					AS RequiereSala,
				PF.FechaInicio						AS FechaInicio,					
				'SplitTipoEvento'	                AS SplitTipoEvento,	
				Tipo.TN_CodTipoEvento				AS Codigo, 
				Tipo.TC_DescripciOn					AS Descripcion,	
				Tipo.TB_EsRemate					AS EsRemate,
				'SplitPriOridadEvento'				AS SplitPriOridadEvento,
				priOridad.TN_CodPriOridadEvento		AS Codigo,		    
				priOridad.TC_DescripciOn			AS DescripciOn,
				'SplitExpediente'					AS SplitExpediente,	
				Expediente.TC_NumeroExpediente		AS Numero,
				'SplitEstadoEvento'					AS SplitEstadoEvento,	
				estadoEvento.TN_CodEstadoEvento 	AS Codigo,
				estadoEvento.TC_DescripciOn		    AS DescripciOn,    	
				estadoEvento.TB_FinalizaEvento		AS FinalizaEvento,
				'SplitMotivoEvento'             	AS SplitMotivoEvento,		 
				MEE.TN_CodMotivoEstado				AS Codigo, 			
				MEE.TC_Descripcion			    	AS  DescripciOn, 
				'SplitFuncionario'				    AS SplitFuncionario,  
				Funcionario.TC_UsuarioRed			AS UsuarioRed, 		
				Funcionario.TC_Nombre				AS Nombre,			
				Funcionario.TC_PrimerApellido		AS PrimerApellido,
				Funcionario.TC_SegundoApellido		AS SegundoApellido,
				'SplitContexto'						AS SplitContexto,
				Eve.TC_CodContexto                  AS Codigo														
	  
		FROM		Agenda.Evento							  AS Eve WITH(NOLOCK)	 
		INNER JOIN  Catalogo.TipoEvento						  AS Tipo WITH(NOLOCK)
		ON          Tipo.TN_CodTipoEvento                     =  Eve.TN_CodTipoEvento
		INNER JOIN  Catalogo.PriOridadEvento				  AS priOridad  WITH(NOLOCK)
		ON          priOridad.TN_CodPriOridadEvento           =  Eve.TN_CodPriOridadEvento
		LEFT JOIN   Expediente.Expediente                     AS Expediente  WITH(NOLOCK)
		ON          Expediente.TC_NumeroExpediente            =  Eve.TC_NumeroExpediente
		INNER JOIN  Catalogo.EstadoEvento                     AS estadoEvento  WITH(NOLOCK)
		ON          estadoEvento.TN_CodEstadoEvento           =  Eve.TN_CodEstadoEvento
		LEFT JOIN   Catalogo.MotivoEstadoEvento               AS MEE  WITH(NOLOCK)
		ON          MEE.TN_CodMotivoEstado					  =  Eve.TN_CodMotivoEstado
		INNER JOIN  Catalogo.Funcionario                      AS Funcionario WITH(NOLOCK)
		ON          Eve.TC_UsuarioCrea                        =  Funcionario.TC_UsuarioRed
		INNER JOIN  PrimerasFechas							  AS PF
		ON			PF.TU_CodEvento							  =  Eve.TU_CodEvento
															  
		WHERE		Eve.TU_CodEvento						  =	@L_codEvento
      
END









GO
