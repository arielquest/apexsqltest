SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<17/1/2020>
-- Descripción:				<Permite asosiar la etiqueta predefinida con materia, tipo oficina y tipo de audiencia>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgrergaTipoAudienciaTipoOficinaMateriaEtiquetaPredefinida]
	@CodTipoAudiencia smallint = null,
	@CodTipoOficina smallint = null,
	@CodMateria varchar(5) = null,
	@CodEtiquetaPredefinida smallint = null,
	@Fin_Vigencia datetime2(2) = null
AS
BEGIN
	INSERT INTO [Catalogo].[TipoAudienciaTipoOficinaMateriaEtiquetaPredefinida]
           ([TN_CodTipoAudiencia]
           ,[TN_CodTipoOficina]
           ,[TC_CodMateria]
           ,[TC_CodEtiquetaPredefinida]
           ,[TF_Fin_Vigencia])
     VALUES
           (@CodTipoAudiencia
           ,@CodTipoOficina
           ,@CodMateria
           ,@CodEtiquetaPredefinida
           ,@Fin_Vigencia)
END
GO
