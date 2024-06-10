SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Manuel Acosta Ibañez>
-- Fecha de creación:	<29/07/2021>
-- Descripción:			<Permite eliminar un registro en la tabla: ConjuntosReparto.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarConjuntoReparto]
	@CodEquipo					UNIQUEIDENTIFIER,
	@CodConjunto				UNIQUEIDENTIFIER = NULL
AS
BEGIN
	--Variables.
	DECLARE	@L_CodEquipo				UNIQUEIDENTIFIER  = @CodEquipo,
			@L_CodConjunto				UNIQUEIDENTIFIER  = @CodConjunto
	--Lógica.
	DELETE
	FROM	Catalogo.ConjuntosReparto	With(RowLock)
	WHERE	TU_CodEquipo				=	@L_CodEquipo
	AND		TU_CodConjutoReparto		=	COALESCE(@L_CodConjunto, TU_CodConjutoReparto)
End
GO
