SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- ========================================================================================================================================================================================
-- Autor:		   <Juan Ramirez V>
-- Fecha Creación: <13/09/2017>
-- Descripcion:	   Modificar el detalle de los firmantes en la asignación de la firma de documentos en el expediente
-- ========================================================================================================================================================================================
-- Modificación	   <Jonathan Aguilar Navarro> <18/09/2018> <Se crea el esquema Archivo y se renombra respectivamente en los sp y tablas> 
-- ========================================================================================================================================================================================
-- Modificación	   <Xinia Soto Valerio> <15/07/2020> <Se agrega que modifique la fecha de revisado> 
-- ========================================================================================================================================================================================
-- Modificación:	<Daniel Ruiz Hernández> <05/03/2021> <Se agrega que modifique si firmo digital, si bloquea el firmado y la fecha de aplicado> 
-- Modificación:	<Fabian Sequerira Gamboa> <27/09/2021> <Se agrega parametro para codigo de Barras>
-- Modificación:	<Aida Elena Siles R> <31/01/2022> <Se modifica la asignación de la variable @L_FirmadoPor (cuando aplica firma) para que obtenga el puesto trabajo activo actualmente.>
-- =========================================================================================================================================================================================
CREATE PROCEDURE [Archivo].[PA_ModificarAsignacionFirmante] 
	   @CodAsignacionFirmado	UNIQUEIDENTIFIER,
       @CodPuestoTrabajo		VARCHAR(14),
       @Orden					TINYINT				= NULL,
	   @FirmadoPor				UNIQUEIDENTIFIER	= NULL,
	   @FechaRevisado			DATETIME2			= NULL,
	   @EsFirmaDigital			BIT					= NULL,
	   @BloqueaArchivo			BIT					= NULL,
	   @AplicaFirma				BIT					= 0,
	   @CodigoBarras			varchar(14)			= NULL 
AS

BEGIN
	DECLARE @FechaAplicaFirma		AS DATETIME2(7) = NULL

	--Variables
	DECLARE		@L_CodAsignacionFirmado		UNIQUEIDENTIFIER	= @CodAsignacionFirmado,
				@L_CodPuestoTrabajo			VARCHAR(14)			= @CodPuestoTrabajo,
				@L_Orden					TINYINT				= @Orden,
				@L_FirmadoPor				UNIQUEIDENTIFIER	= @FirmadoPor,
				@L_FechaRevisado			DATETIME2			= @FechaRevisado,
				@L_EsFirmaDigital			BIT					= @EsFirmaDigital,
				@L_BloqueaArchivo			BIT					= @BloqueaArchivo,
				@L_AplicaFirma				BIT					= @AplicaFirma,
				@L_CodigoBarras				VARCHAR(14)			= @CodigoBarras 		
	
	IF (@L_AplicaFirma = 1)
	BEGIN
		SET @L_FirmadoPor	  = (SELECT Codigo FROM Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(@L_CodPuestoTrabajo))
		SET @FechaAplicaFirma = GETDATE()
	END
	
	IF (NOT EXISTS(SELECT * FROM [Archivo].[AsignacionFirmante] WITH(NOLOCK) WHERE @L_CodAsignacionFirmado = TU_CodAsignacionFirmado AND @L_CodPuestoTrabajo = TC_CodPuestoTrabajo))
		INSERT INTO [Archivo].[AsignacionFirmante]
			   ([TU_CodAsignacionFirmado]
			   ,[TC_CodPuestoTrabajo]
			   ,[TN_Orden]
			   ,[TU_FirmadoPor])
		 VALUES
			  (@L_CodAsignacionFirmado,
			   @L_CodPuestoTrabajo,
			   @L_Orden,
			   @L_FirmadoPor)
	ELSE
		UPDATE [Archivo].[AsignacionFirmante] WITH(ROWLOCK)
		SET		TN_Orden				= COALESCE(@L_Orden,TN_Orden),
				TU_FirmadoPor			= COALESCE(@L_FirmadoPor,TU_FirmadoPor),
				TF_FechaRevisado		= COALESCE(@L_FechaRevisado,TF_FechaRevisado),
				TB_BloqueaArchivo		= COALESCE(@L_BloqueaArchivo,TB_BloqueaArchivo),
				TB_EsFirmaDigital		= COALESCE(@L_EsFirmaDigital,TB_EsFirmaDigital),
				TF_FechaAplicado		= COALESCE(@FechaAplicaFirma,TF_FechaAplicado),
				TC_CodBarras			= COALESCE(@L_CodigoBarras,TC_CodBarras)
		WHERE	@L_CodAsignacionFirmado	= TU_CodAsignacionFirmado 
		AND		@L_CodPuestoTrabajo		= TC_CodPuestoTrabajo
END
GO
