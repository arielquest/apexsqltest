SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================
-- Autor:		   <Johan Manuel Acosta Ibañez>
-- Fecha Creación: <21/07/2021>
-- Descripcion:    <Eliminar un permiso especifico de un puesto de trabajo
-- ==========================================================================
CREATE PROCEDURE [Catalogo].[PA_EliminarMiembrosPorConjuntoReparto]
	@CodConjutoReparto	UNIQUEIDENTIFIER,
	@CodMiembroReparto	UNIQUEIDENTIFIER = NULL
 AS
 BEGIN
	DECLARE	@L_CodConjutoReparto	UNIQUEIDENTIFIER	= @CodConjutoReparto,
			@L_CodMiembroReparto	UNIQUEIDENTIFIER	= @CodMiembroReparto

	DELETE	[Catalogo].[MiembrosPorConjuntoReparto]
	WHERE	TU_CodConjutoReparto = @L_CodConjutoReparto
	AND		TU_CodMiembroReparto = COALESCE(@L_CodMiembroReparto, TU_CodMiembroReparto)
 END


GO
