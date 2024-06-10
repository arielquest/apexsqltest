SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:				<Jnathan Aguilar Navarro>
-- Fecha Creación:		<20/11/2019>
-- Descripcion:			<Asocia tipos de oficina a un tipo de audiencia>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoAudienciaTipoOficina]
	@CodigoTipoAudiencia	smallint,
	@CodigoTipoOficina		smallint,
	@CodigoMateria			varchar(5),
	@FechaAsociacion		datetime2(3)

AS
BEGIN
	INSERT INTO [Catalogo].[TipoAudienciaTipoOficina]
           (
				 [TN_CodTipoAudiencia]
				,[TN_CodTipoOficina]
				,[TC_CodMateria]
				,[TF_Inicio_Vigencia]
		   )
     VALUES
           (
			     @CodigoTipoAudiencia
				,@CodigoTipoOficina
				,@CodigoMateria
				,@FechaAsociacion
		   )
END
GO
