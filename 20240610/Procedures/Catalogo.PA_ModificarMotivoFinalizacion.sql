SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<22/02/2019>
-- Descripción :			<Permite Modificar un motivo de finalización en la tabla Catalogo.MotivoFinalizacion> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarMotivoFinalizacion] 
	@Codigo				smallint, 
	@Descripcion		varchar(255),
	@FechaDesactivacion datetime2
AS
BEGIN
	UPDATE	Catalogo.MotivoFinalizacion
	SET		TC_Descripcion				= @Descripcion,
			TF_Fin_Vigencia				= @FechaDesactivacion
	WHERE	TN_CodMotivoFinalizacion	= @Codigo
END


GO
