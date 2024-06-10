SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=======================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Fabian Sequeira Gamboa>
-- Fecha de creación:		<18/05/2021>
-- Descripción:				<Obtiene las comunicaciones temporales para una comunicacion automatica y los actualiza.> 
-- =======================================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<21/05/2021>
-- Descripción:				<Se modifica para agregar datos adicionales del Interviniente, Contexto, Número de Expediente, 
--							Código de Legajo y Código de archivo>
-- =======================================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<25/05/2021>
-- Descripción:				<Se modifica solo incluir en el resultado el código de la entidad y el código de la 
--							asignación de firmado>
-- =======================================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<26/05/2021>
-- Descripción:				<Se agrega el la columna TN_Intento a la consulta y se reajusta el split>
-- =======================================================================================================================
-- =======================================================================================================================
-- Modificado por:			<Olger Gamboa Castillo>
-- Fecha:					<27/05/2021>
-- Descripción:				<Se agrega el la columna ContextoEnvia a la consulta y se reajusta el split>
-- =======================================================================================================================
-- =======================================================================================================================
-- Modificado por:			<Daniel Ruiz Hernández>
-- Fecha:					<17/06/2021>
-- Descripción:				<Se agrega filtro de documento firmado>
-- =======================================================================================================================


CREATE PROCEDURE [Biztalk].[PA_ConsultarComunicacionTemporalAProcesar]
(
@ActualizaEstado BIT = 0,
@Top INT=1000
)
AS
DECLARE @L_Top AS INT=@Top;
DECLARE @L_ActualizaEstado AS BIT=@ActualizaEstado; 
 
BEGIN
	IF @L_ActualizaEstado= 0
	BEGIN
			SELECT Top (@L_Top)
			   C.TU_CodComunicacionAut			AS CodigoComunicacionAutomatica
			  ,C.TU_CodAsignacionFirmado		AS CodigoAsignacionFirmado
			  ,AE.TC_NumeroExpediente			AS NumeroExpediente
			  ,C.TN_Intento						AS Intento
			  ,A.TC_CodContextoCrea				AS ContextoEnvia
			  , 'Split' 						AS Split
			  ,LA.TU_CodLegajo					AS CodigoLegajo

			FROM		Comunicacion.ComunicacionRegistroAutomatico		C	WITH(NOLOCK)
			INNER JOIN	Archivo.AsignacionFirmado						AF	WITH(NOLOCK)
			ON			AF.TU_CodAsignacionFirmado						=	C.TU_CodAsignacionFirmado
			
			INNER JOIN	Archivo.Archivo									A	WITH(NOLOCK)
			ON			A.TU_CodArchivo									=	AF.TU_CodArchivo  
			LEFT JOIN	Expediente.ArchivoExpediente					AE	WITH(NOLOCK)
			ON			AE.TU_CodArchivo								=	A.TU_CodArchivo
			LEFT JOIN	Expediente.LegajoArchivo						LA	WITH(NOLOCK)
			ON			LA.TU_CodArchivo								=	A.TU_CodArchivo
			WHERE	C.TC_EstadoEnvio = 'P' 
			AND		AF.TC_Estado =	'F'
	END
  ELSE
  BEGIN
		  DECLARE @RegistrosActualizado TABLE(TU_CodComunicacionAut UNIQUEIDENTIFIER)

		  UPDATE top(@L_Top) REGISTROSA_PROCESAR
		  SET REGISTROSA_PROCESAR.TC_EstadoEnvio='E'
		  OUTPUT REGISTROSPENDIENTES.TU_CodComunicacionAut
		  INTO @RegistrosActualizado
		  FROM Comunicacion.ComunicacionRegistroAutomatico			REGISTROSA_PROCESAR	WITH(NOLOCK)
		  INNER JOIN Comunicacion.ComunicacionRegistroAutomatico	REGISTROSPENDIENTES	WITH(NOLOCK)
		  ON REGISTROSA_PROCESAR.TU_CodComunicacionAut=REGISTROSPENDIENTES.TU_CodComunicacionAut
		  INNER JOIN Archivo.AsignacionFirmado						AF					WITH(NOLOCK)
		  ON REGISTROSA_PROCESAR.TU_CodAsignacionFirmado = AF.TU_CodAsignacionFirmado
		  AND AF.TC_Estado= 'F'
		  WHERE		REGISTROSA_PROCESAR.TC_EstadoEnvio='P' 	

		  SELECT	 C.TU_CodComunicacionAut		AS CodigoComunicacionAutomatica
					,C.TU_CodAsignacionFirmado		AS CodigoAsignacionFirmado
					,AE.TC_NumeroExpediente			AS NumeroExpediente
					,C.TN_Intento					AS Intento
					,A.TC_CodContextoCrea			AS ContextoEnvia

					, 'Split' 						AS Split

					,LA.TU_CodLegajo				AS CodigoLegajo

		FROM		Comunicacion.ComunicacionRegistroAutomatico		C	WITH(NOLOCK)
		INNER JOIN	@RegistrosActualizado							B 
		ON			C.TU_CodComunicacionAut							=	B.TU_CodComunicacionAut
		INNER JOIN	Archivo.AsignacionFirmado						AF	WITH(NOLOCK)
		ON			AF.TU_CodAsignacionFirmado						=	C.TU_CodAsignacionFirmado
		INNER JOIN	Archivo.Archivo									A	WITH(NOLOCK)
		ON			A.TU_CodArchivo									=	AF.TU_CodArchivo  
		LEFT JOIN	Expediente.ArchivoExpediente					AE	WITH(NOLOCK)
		ON			AE.TU_CodArchivo								=	A.TU_CodArchivo
		LEFT JOIN	Expediente.LegajoArchivo						LA	WITH(NOLOCK)
		ON			LA.TU_CodArchivo								=	A.TU_CodArchivo
		WHERE		C.TC_EstadoEnvio								= 'E'
		AND			AF.TC_Estado =	'F'
  END
END
GO
