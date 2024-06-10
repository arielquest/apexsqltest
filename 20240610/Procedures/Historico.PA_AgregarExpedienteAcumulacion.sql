SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<22/10/2018>
-- Descripción :			<Permite agregar un registro al historico de acumulación de expediente> 
-- Modificación:			<Jonathan Aguilar Navarro> <05/08/2019> <Se elimina el parametros ExpedienteEstado, se agrega el campo y
--							<parametro fecha para alamecenar la llave foranea del movimiento en el cinrculante del expediente.
--							<Se modifica le campo TC_Usurio por TU_CodPuestoTrabajoFuncionario>
-- Modificación:			<Roger Lara Hernandez> <05/01/2021> < Se agre logica para incluir en el historico de acumulacion una relacion con el 
--							<historico del movimiento del circulante del expediente>
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_AgregarExpedienteAcumulacion]
	@CodAcumulacion				uniqueidentifier,
	@NumeroExpediente			Varchar(14),
	@NumeroExpedienteAcumula	varchar(14),
	@CodContexto				varchar(4),
	@FechaInicioAcumulacion		datetime2(7),
	@FechaFinAcumulacion		datetime2(7),
	@FechaActualizacion			datetime2(7),
	@CodPuestoTrabajoFuncionario uniqueidentifier,
	@CodArchivo					uniqueidentifier
AS  
BEGIN  
	DECLARE @L_TU_CodAcumulacion			  uniqueidentifier = @CodAcumulacion
	DECLARE @L_TC_NumeroExpediente			  varchar(14)      = @NumeroExpediente
	DECLARE @L_TC_NumeroExpedienteAcumula	  varchar(14)      = @NumeroExpedienteAcumula
	DECLARE @L_TC_CodContexto			   	  varchar(4)       = @CodContexto
	DECLARE @L_TF_InicioAcumulacion		      datetime2(7)     = @FechaInicioAcumulacion
	DECLARE @L_TF_FinAcumulacion		      datetime2(7)     = @FechaFinAcumulacion
	DECLARE @L_TF_Actualizacion			      datetime2(7)     = @FechaActualizacion
	DECLARE @L_TU_CodPuestoTrabajoFuncionario uniqueidentifier = @CodPuestoTrabajoFuncionario
	DECLARE @L_TU_CodArchivo				  uniqueidentifier = @CodArchivo
	--Variable para consultar el ultimo movimiento en el circulante del expediente
	DECLARE	@L_TN_CodExpedienteMovimientoCirculante		bigint			    

	SELECT TOP 1 @L_TN_CodExpedienteMovimientoCirculante=TN_CodExpedienteMovimientoCirculante 
	FROM		Historico.ExpedienteMovimientoCirculante WITH(NOLOCK)
	WHERE		TC_NumeroExpediente = @L_TC_NumeroExpediente 
	        	and			TC_CodContexto = @L_TC_CodContexto 
	ORDER BY	TF_Fecha desc 

	IF (@L_TN_CodExpedienteMovimientoCirculante IS NOT NULL)
	BEGIN
		INSERT INTO	Historico.ExpedienteAcumulacion
		(
			TU_CodAcumulacion,		
			TC_NumeroExpediente,		
			TC_NumeroExpedienteAcumula,
			TN_CodExpedienteMovimientoCirculante,
			TC_CodContexto,		
			TF_InicioAcumulacion,
			TF_FinAcumulacion,
			TF_Actualizacion,
			TU_CodPuestoTrabajoFuncionario,
			TU_CodArchivo
		)
		VALUES
		(
			@L_TU_CodAcumulacion,			
			@L_TC_NumeroExpediente,			
			@L_TC_NumeroExpedienteAcumula,	
			@L_TN_CodExpedienteMovimientoCirculante,
			@L_TC_CodContexto,				
			@L_TF_InicioAcumulacion,			
			@L_TF_FinAcumulacion,				
			@L_TF_Actualizacion,				
			@L_TU_CodPuestoTrabajoFuncionario,					
			@L_TU_CodArchivo					
		)
	END
END
GO
