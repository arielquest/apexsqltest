SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:				<Andrew Allen Dawson>
-- Fecha Creación:		<23/09/2019>
-- Descripcion:			<Agregar un tipo de oficina a un tipo de escrito>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoEscritoTipoOficina] 
	@CodigoTipoOficina		smallint,
	@CodigoTipoEscrito		smallint,
	@FechaAsociacion		datetime2,
	@CodigoMateria			varchar(5),
	@EsUrgente				Bit
AS
BEGIN
	INSERT INTO [Catalogo].[TipoEscritoTipoOficina]
           ([TC_CodMateria]
           ,[TN_CodTipoEscrito]
           ,[TN_CodTipoOficina]
           ,[TF_Inicio_Vigencia]
           ,[TB_Urgente])
     VALUES
           (@CodigoMateria
           ,@CodigoTipoEscrito
           ,@CodigoTipoOficina
           ,@FechaAsociacion
           ,@EsUrgente)
END
GO
