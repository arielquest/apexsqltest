SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ===================================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<05/03/2020>
-- Descripción :			<Permite modificar los valores de una auduiencia> 
-- ====================================================================================================================================================================
-- Modificación:			<27/03/2020> <Aida E Siles> <Se corrige el parámetro asignado a la variable @L_UsuarioRedCrea>
-- Modificación:			<20/04/2020> <Isaac Dobles Mata> <Se agrega actualización a columna TF_Actualizacion>
-- Modificación:			<20/04/2020> <Isaac Dobles Mata> <Se agrega actualización a columna TF_Actualizacion>
-- Modificación:			<22/08/2020> <Andrew Allen Dawson> <Se Agrega la funcion COALESCE sobre los campos a ser actualizados>
-- Modificación:			<15/10/2020> <Aida Elena Siles R> <Se agrega parámetro de consecutivo para actualizar al momento de desacumular expediente-Mover audiencia>
-- =====================================================================================================================================================================

CREATE PROCEDURE [Expediente].[PA_ModificarAudiencia]
	@NumeroExpediente					CHAR(14)		= NULL,
	@Descripcion						VARCHAR(255)	= NULL,
	@NombreArchivo						VARCHAR(255)	= NULL,
	@CodTipoAudiencia					SMALLINT		= NULL,
	@CodContextoCrea					VARCHAR(4)		= NULL,
	@UsuarioRedCrea						VARCHAR(30)		= NULL,
	@Duracion							VARCHAR(11)		= NULL,
	@FechaCrea							DATETIME2(2)	= NULL,
	@CodAudiencia						BIGINT,
	@ConsecutivoHistorialProcesal		SMALLINT		= NULL

AS
BEGIN
	
	DECLARE @L_NumeroExpediente				CHAR(14)		= @NumeroExpediente
	DECLARE @L_Descripcion					VARCHAR(255)	= @Descripcion
	DECLARE @L_NombreArchivo				VARCHAR(255)	= @NombreArchivo
	DECLARE @L_CodTipoAudiencia				SMALLINT		= @CodTipoAudiencia
	DECLARE @L_CodContextoCrea				VARCHAR(4)		= @CodContextoCrea
	DECLARE @L_UsuarioRedCrea				VARCHAR(30)		= @UsuarioRedCrea
	DECLARE @L_Duracion						VARCHAR(11)		= @Duracion
	DECLARE @L_FechaCrea					DATETIME2(2)	= @FechaCrea
	DECLARE @L_CodAudiencia					BIGINT			= @CodAudiencia
	DECLARE @L_ConsecutivoHistorialProcesal	SMALLINT		= @ConsecutivoHistorialProcesal

	UPDATE [Expediente].[Audiencia] WITH(ROWLOCK)
	  SET [TC_NumeroExpediente]		= COALESCE(@L_NumeroExpediente,TC_NumeroExpediente)
	     ,[TC_Descripcion]			= COALESCE(@L_Descripcion,TC_Descripcion)
	     ,[TC_NombreArchivo]		= COALESCE(@L_NombreArchivo, TC_NombreArchivo)
	     ,[TN_CodTipoAudiencia]		= COALESCE(@L_CodTipoAudiencia, TN_CodTipoAudiencia)
	     ,[TC_CodContextoCrea]		= COALESCE(@L_CodContextoCrea, TC_CodContextoCrea)
	     ,[TC_UsuarioRedCrea]		= COALESCE(@L_UsuarioRedCrea, TC_UsuarioRedCrea)
	     ,[TC_Duracion]				= COALESCE(@L_Duracion, TC_Duracion)
	     ,[TF_FechaCrea]			= COALESCE(@L_FechaCrea, TF_FechaCrea)
		 ,[TF_Actualizacion]		= GETDATE()
		 ,[TN_Consecutivo]			= COALESCE(@L_ConsecutivoHistorialProcesal, TN_Consecutivo)
	WHERE [TN_CodAudiencia]			= @L_CodAudiencia

END
GO
