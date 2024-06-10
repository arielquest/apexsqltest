SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =====================================================================================================================================
-- Autor:		   <Isaac Dobles Mata>
-- Fecha Creación: <04/04/2019>
-- Descripcion:	   <Modifica los datos básicos de un Legajo.>
-- =====================================================================================================================================
-- Modificación:	<18/11/2020> <Aida Elena Siles Rojas> <Se agrega el parámetro del contexto para actualizar el código cuando se
--					recibe un legajo por itineración.>
-- Modificación:	<04/05/2023> <Luis Alonso Leiva Tames> <Se realiza cambio, si la descripcion viene en null no actualiza.>
-- Modificación:	<04/10/2023><Karol Jiménez Sánchez> <Se agrega el campo TB_EmbargosFisicos. PBI 347798.>
-- =====================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_ModificarLegajo] 
	@CodLegajo			UNIQUEIDENTIFIER, 
	@Descripcion		VARCHAR(255),
	@Prioridad			SMALLINT,
	@CodContexto		VARCHAR(4)	= NULL,
	@EmbargosFisicos	BIT			= NULL
AS
BEGIN
--Varaibles
	DECLARE	@L_CodLegajo			UNIQUEIDENTIFIER = @CodLegajo,
			@L_Descripcion			VARCHAR(255)	 = @Descripcion,
			@L_Prioridad			SMALLINT		 = @Prioridad,
			@L_Contexto				VARCHAR(4)		 = @CodContexto,
			@L_EmbargosFisicos		BIT				 = @EmbargosFisicos;

	UPDATE  Expediente.Legajo		WITH(ROWLOCK)
	SET		TC_Descripcion			=	COALESCE(@L_Descripcion, TC_Descripcion),
			TN_CodPrioridad			=	COALESCE(@L_Prioridad,TN_CodPrioridad),
			TF_Actualizacion		=	GETDATE(),
			TC_CodContexto			=	COALESCE(@L_Contexto, TC_CodContexto),
			TB_EmbargosFisicos		=	COALESCE(@L_EmbargosFisicos, TB_EmbargosFisicos)
	WHERE	TU_CodLegajo			=	@L_CodLegajo
END

GO
