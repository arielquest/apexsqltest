SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<13/04/2021>
-- Descripción:			<Permite actualizar un registro en la tabla: PropuestaDocumento.>
-- ==================================================================================================================================================================================
-- Modificación:		<23/04/2021> <Aida Elena Siles R> <Se permiten algunos parámetros NULL para utilizar SP al momento de rechazar propuesta>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[DefensaPublica].[PA_ModificarPropuestaDocumento]
	@CodPropuesta				UNIQUEIDENTIFIER,
	@CodArchivo					UNIQUEIDENTIFIER	= NULL,
	@CodRepresentacion			UNIQUEIDENTIFIER	= NULL,
	@CodPuestoTrabajo			VARCHAR(14)			= NULL,
	@EstadoPropuesta			CHAR(1),
	@FechaPropuesta				DATETIME2(7)		= NULL
	
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodPropuesta			UNIQUEIDENTIFIER		= @CodPropuesta,
			@L_TU_CodArchivo			UNIQUEIDENTIFIER		= @CodArchivo,
			@L_TU_CodRepresentacion		UNIQUEIDENTIFIER		= @CodRepresentacion,
			@L_TC_CodPuestoTrabajo		VARCHAR(14)				= @CodPuestoTrabajo,
			@L_TC_EstadoPropuesta		CHAR(1)					= @EstadoPropuesta,
			@L_TF_FechaPropuesta		DATETIME2(7)			= @FechaPropuesta			
			
	--Lógica
	UPDATE	DefensaPublica.PropuestaDocumento	WITH (ROWLOCK)
	SET  	TU_CodArchivo				= COALESCE(@L_TU_CodArchivo, TU_CodArchivo),
			TU_CodRepresentacion		= COALESCE(@L_TU_CodRepresentacion, TU_CodRepresentacion),
			TC_CodPuestoTrabajo			= COALESCE(@L_TC_CodPuestoTrabajo, TC_CodPuestoTrabajo),
			TC_EstadoPropuesta			= @L_TC_EstadoPropuesta,
			TF_FechaPropuesta			= COALESCE(@L_TF_FechaPropuesta, TF_FechaPropuesta),
			TF_FechaActualizacion		= SYSDATETIME()					
	WHERE	TU_CodPropuesta				= @L_TU_CodPropuesta
END
GO
