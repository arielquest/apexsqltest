SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jefry Hernández>
-- Fecha de creación:		<22/05/2017>
-- Descripción:				<Obtiene los archivos asociados a una comunicación.> 
-- ===========================================================================================
-- Modificacion:	<21/09/2018><Isaac Dobles Mata> <Se modifico la consulta para que consulte la tabla Archivo.Archivo>
--=============================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ConsultarArchivosComunicacion]
	@CodigoComunicacion uniqueidentifier

AS
BEGIN
			 
	SELECT		AC.TU_CodComunicacion				AS 		CodComunicacion,
				AC.TB_EsActa						AS 		EsActa, 
				AC.TF_FechaAsociacion				AS 		FechaAsociacion,
				AC.TB_EsPrincipal       			AS 		EsPrincipal,
				'SplitLegajoArchivo'				AS 		SplitLegajoArchivo,
				AC.TU_CodArchivo					AS 		Codigo, 
				A.TC_Descripcion					AS 		Descripcion,
				A.TF_FechaCrea						AS 		FechaCrea,
				'SplitEstadoArchivo'				AS 		SplitEstadoArchivo,
				A.TN_CodEstado						AS 		Estado

	FROM		Comunicacion.ArchivoComunicacion AC
	INNER JOIN	Archivo.Archivo A 
	ON			A.TU_CodArchivo = AC.TU_CodArchivo

	WHERE		AC.TU_CodComunicacion = @CodigoComunicacion


END
GO
