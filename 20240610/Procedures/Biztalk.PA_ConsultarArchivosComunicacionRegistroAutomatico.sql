SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=======================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<31/05/2021>
-- Descripción:				<Obtiene la lista de códigos de archivo relacionados al registro de comunicación automático
--							solicitado por su código>
-- =======================================================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarArchivosComunicacionRegistroAutomatico]
(
	@CodigoComunicacionAutomatica  Uniqueidentifier
)
AS
DECLARE @L_CodigoComunicacionAutomatica AS Uniqueidentifier	=	@CodigoComunicacionAutomatica;
 
BEGIN
	SELECT 	CAST(A.TU_CodArchivo AS VARCHAR(50))	AS CodigoEntregaDocumento,
			A.TB_EsPrincipal						AS Principal			

		FROM		Comunicacion.ArchivoComunicacionRegistroAutomatico		A	WITH(NOLOCK)
		WHERE		A.TU_CodComunicacionAut									=	@L_CodigoComunicacionAutomatica
		ORDER BY	A.TB_EsPrincipal DESC
END
GO
