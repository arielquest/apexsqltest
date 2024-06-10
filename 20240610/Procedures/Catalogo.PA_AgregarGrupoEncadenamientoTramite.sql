SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Daniel Ruiz Hernández>
-- Fecha Creación:	<20/06/2022>
-- Descripcion:		<Crear un nuevo registro de grupo de encadenamiento de trámite.>
-- =============================================
CREATE    PROCEDURE [Catalogo].[PA_AgregarGrupoEncadenamientoTramite] 
	@CodigoPadre						UNIQUEIDENTIFIER = null,
	@Descripcion						VARCHAR(255),
	@Nombre							    VARCHAR(255),
	@FechaActivacion					DATETIME2,
	@FechaVencimiento					DATETIME2
AS
BEGIN
	INSERT INTO Catalogo.GrupoEncadenamientoTramite
	(
		TU_CodGrupoEncadenamientoTramite,		TC_Nombre,				TC_Descripcion,			
		TU_CodGrupoEncadenamientoTramitePadre,	TF_Inicio_Vigencia,		TF_Fin_Vigencia,
		TF_Actualizacion 
	)
	VALUES
	(
		NEWID(),			@Nombre,			@Descripcion,		
		@CodigoPadre,		@FechaActivacion,	@FechaVencimiento,
		GETDATE()
	)
END
GO
