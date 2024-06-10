SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================================================================================================
-- Autor:				<Jefferson Parker Cortes>
-- Fecha Creación:		<20/06/2022>
-- Descripcion:			<Elimina las materias y oficinas ligadas a un tramite>
-- =========================================================================================================================================

CREATE   PROCEDURE [Catalogo].[PA_EliminarEncadenamientoTramiteMateriaOficina] 
	@CodEncadenamientoTramite	UNIQUEIDENTIFIER
AS
BEGIN

	--Variables locales
	DECLARE @L_CodEncadenamientoTramite 	UNIQUEIDENTIFIER			= @CodEncadenamientoTramite

	IF EXISTS (SELECT COUNT(TU_CodEncadenamientoTramite) FROM Catalogo.EncadenamientoTramiteMateriaOficina WHERE TU_CodEncadenamientoTramite = @L_CodEncadenamientoTramite)
	BEGIN
		DELETE FROM Catalogo.EncadenamientoTramiteMateriaOficina
		WHERE	    TU_CodEncadenamientoTramite = @L_CodEncadenamientoTramite
	END

	--Aplicación de eliminación
	DELETE	FROM Catalogo.EncadenamientoTramiteMateriaOficina
	WHERE		 TU_CodEncadenamientoTramite = @L_CodEncadenamientoTramite


END
GO
