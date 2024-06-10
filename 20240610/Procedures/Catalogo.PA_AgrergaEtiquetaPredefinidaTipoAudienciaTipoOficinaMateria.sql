SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Versión:					<1.0>
-- Creado por:				<Andrew Allen Dawson>
-- Fecha de creación:		<28/1/2020>
-- Descripción:				<Permite asosiar la etiqueta predefinida con materia, tipo oficina y tipo de audiencia>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgrergaEtiquetaPredefinidaTipoAudienciaTipoOficinaMateria]
	@CodTipoAudiencia smallint = NULL,
	@CodTipoOficina smallint = NULL,
	@CodMateria varchar(5) = NULL,
	@CodEtiquetaPredefinida smallint = NULL,
	@Inicio_Vigencia datetime2(3) = NULL
AS
BEGIN
	INSERT INTO [Catalogo].[EtiquetaPredefinidaTipoAudienciaTipoOficina]
           ([TN_CodTipoAudiencia]
           ,[TN_CodTipoOficina]
           ,[TC_CodMateria]
           ,[TN_CodEtiquetaPredefinida]
           ,[TF_Inicio_Vigencia])
     VALUES
           (@CodTipoAudiencia
           ,@CodTipoOficina
           ,@CodMateria
           ,@CodEtiquetaPredefinida
           ,@Inicio_Vigencia)
END
GO
