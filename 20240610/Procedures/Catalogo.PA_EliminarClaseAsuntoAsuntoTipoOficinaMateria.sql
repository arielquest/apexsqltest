SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<07/05/2021>
-- Descripción :			<Permite eliminar una asociación entre clase asunto -asunto- tipo oficina y materia.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarClaseAsuntoAsuntoTipoOficinaMateria]
	@CodigoClaseAsunto			int				= Null,
	@CodigoTipoOficina			smallint		= Null,
	@CodigoAsunto				int				= Null,
	@CodigoMateria				varchar(5)		= Null
AS 
BEGIN
--VARIABLES
	Declare     @L_TN_CodClaseAsunto  int		   = @CodigoClaseAsunto
	Declare     @L_TN_CodTipoOficina  smallint	   = @CodigoTipoOficina
	Declare     @L_TN_CodAsunto       int		   = @CodigoAsunto
	Declare     @L_TC_CodMateria      varchar(5)   = @CodigoMateria
--LÓGICA
	DELETE FROM		Catalogo.ClaseAsuntoAsuntoTipoOficinaMateria WITH(ROWLOCK)
	WHERE			TN_CodClaseAsunto	= @L_TN_CodClaseAsunto
	AND				TN_CodTipoOficina	= @L_TN_CodTipoOficina
	AND				TN_CodAsunto		= @L_TN_CodAsunto
	AND				TC_CodMateria		= @L_TC_CodMateria
END

GO
