SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Daniel Ruiz Hernández>
-- Fecha Creación:	<23/06/2022>
-- Descripcion:		<Modificar un registro de grupo de encadenamiento de trámite.>
-- =============================================
CREATE    PROCEDURE [Catalogo].[PA_ModificarGrupoEncadenamientoTramite] 
	@Codigo								UNIQUEIDENTIFIER = null,
	@Descripcion						VARCHAR(255),
	@Nombre							    VARCHAR(255),
	@FechaActivacion					DATETIME2,
	@FechaVencimiento					DATETIME2
AS
BEGIN
	UPDATE	Catalogo.GrupoEncadenamientoTramite 
	SET		TC_Nombre			= @Nombre,				
			TC_Descripcion		= @Descripcion,	
			TF_Inicio_Vigencia	= @FechaActivacion,		
			TF_Fin_Vigencia		= @FechaVencimiento,
			TF_Actualizacion	= GETDATE()
	WHERE TU_CodGrupoEncadenamientoTramite = @Codigo
END
GO
