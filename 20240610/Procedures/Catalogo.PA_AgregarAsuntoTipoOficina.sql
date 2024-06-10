SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<15/02/2019>
-- Descripcion:			<Agregar un tipo de oficina a un asunto>
-- =============================================
CREATE PROCEDURE [Catalogo].[PA_AgregarAsuntoTipoOficina] 
	@CodigoTipoOficina		smallint,
	@CodigoAsunto			int,
	@FechaAsociacion		datetime2,
	@CodigoMateria			varchar(5)
AS
BEGIN
	INSERT INTO [Catalogo].[AsuntoTipoOficina]
	(
		TN_CodTipoOficina,		TN_CodAsunto,		TF_Inicio_Vigencia,		TC_CodMateria
	) 
	VALUES
	(
		@CodigoTipoOficina,		@CodigoAsunto,		@FechaAsociacion,		@CodigoMateria
	)
END
GO
