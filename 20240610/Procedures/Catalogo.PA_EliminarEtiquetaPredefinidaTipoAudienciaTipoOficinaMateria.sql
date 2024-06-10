SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<28/1/2020>
-- Descripción:				<Permite desasosiar la etiqueta predefinida con materia, tipo oficina y tipo de audiencia>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_EliminarEtiquetaPredefinidaTipoAudienciaTipoOficinaMateria]
	@CodTipoAudiencia smallint = NULL,
	@CodTipoOficina smallint = NULL,
	@CodMateria varchar(5) = NULL,
	@CodEtiquetaPredefinida smallint = NULL,
	@Inicio_Vigencia datetime2(3) = NULL
AS
BEGIN

DELETE FROM [Catalogo].[EtiquetaPredefinidaTipoAudienciaTipoOficina]
      WHERE		[TN_CodTipoAudiencia] = @CodTipoAudiencia	
           AND	[TN_CodTipoOficina] = @CodTipoOficina		
           AND	[TC_CodMateria] = @CodMateria			
           AND	[TN_CodEtiquetaPredefinida] = @CodEtiquetaPredefinida
END


GO
