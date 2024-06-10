SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger>
-- Fecha de creación:		<10/05/2021>
-- Descripción :			<Permite asociar una clase asunto a un asunto tipo oficina y materia> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarClaseAsuntoAsuntoTipoOficinaMateria]

	@CodigoClaseAsunto			int				= Null,
	@CodigoTipoOficina			smallint		= Null,
	@CodigoAsunto				int				= Null,
	@CodigoMateria				varchar(5)		= Null,
	@Inicio_Vigencia    		datetime2
AS 
BEGIN
	INSERT INTO Catalogo.ClaseAsuntoAsuntoTipoOficinaMateria WITH(ROWLOCK)
	(
		TN_CodClaseAsunto,	TN_CodTipoOficina,	TN_CodAsunto,	TC_CodMateria,	TF_Inicio_Vigencia	
	)
	VALUES
	(
		@CodigoClaseAsunto,	@CodigoTipoOficina, @CodigoAsunto, @CodigoMateria, @Inicio_Vigencia
	)
END
GO
