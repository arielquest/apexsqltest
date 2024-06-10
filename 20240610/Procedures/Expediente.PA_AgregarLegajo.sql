SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:				<Johan Acosta Ibañez>
-- Fecha Creación:		<03/09/2015>
-- Descripcion:			<Crear un nuevo Legajo.>
-- =================================================================================================================================================
-- Modificación:		<07/03/2019> <Isaac Dobles> <Se modifica para nueva estructura de expedientes y legajos>
-- Modificación:		<08/02/2021> <Karol Jiménez S.> <Se agrega parámetro carpeta>
-- Modificación:		<12/10/2023> <Karol Jiménez Sánchez><Se agrega el campo TB_EmbargosFisicos. PBI 347798.>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarLegajo] 
	@CodigoLegajo				uniqueidentifier,		
	@NumeroExpediente			char(14), 
	@FechaInicio				datetime2(7), 
	@ContextoCrea				varchar(4),
	@Contexto					varchar(4),
	@Descripcion				varchar(255),
	@Prioridad					smallint,
	@Carpeta					varchar(14),		
	@EmbargosFisicos			BIT				= NULL
AS
BEGIN
	INSERT INTO Expediente.Legajo
	(
		TU_CodLegajo,		
		TC_NumeroExpediente,	
		TF_Inicio,			
		TC_CodContextoCreacion, 
		TC_CodContexto,
		TC_Descripcion,	
		TN_CodPrioridad,
		CARPETA,
		TB_EmbargosFisicos
	)
	VALUES
	(
		@CodigoLegajo,  
		@NumeroExpediente, 
		@FechaInicio,
		@ContextoCrea,
		@Contexto,
		@Descripcion,
		@Prioridad,
		@Carpeta,
		ISNULL(@EmbargosFisicos, 0)
	)
END
GO
