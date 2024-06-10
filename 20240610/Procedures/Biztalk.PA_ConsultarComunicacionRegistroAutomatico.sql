SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--=======================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Ronny Ramírez Rojas>
-- Fecha de creación:		<25/05/2021>
-- Descripción:				<Obtiene el registro de comunicación automátivo solicitado por su código> 
-- =======================================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<26/05/2021>
-- Descripción:				<Se agrega el la columna TN_Intento a la consulta y se reajusta el split>
-- =======================================================================================================================
-- Modificado por:			<Ronny Ramírez Rojas>
-- Fecha:					<31/05/2021>
-- Descripción:				<Se modifica para eliminar el código de archivo de asignación de firma pues se incluirá en un 
--							BE para consulta de documentos separado>
-- =======================================================================================================================
-- Modificado por:			<Daniel Ruiz Hernández>
-- Fecha:					<17/06/2021>
-- Descripción:				<Se modifica para obtener la fecha de resolucion del documento del registro de resolucion.>
-- =======================================================================================================================
-- Modificado por:			<Daniel Ruiz Hernández>
-- Fecha:					<18/06/2021>
-- Descripción:				<Se modifica para utilizar la fecha de creacion del documento en lugar de la fecha de resolucion del registro de resolucion.>
-- =======================================================================================================================
CREATE PROCEDURE [Biztalk].[PA_ConsultarComunicacionRegistroAutomatico]
(
	@CodigoComunicacionAutomatica  Uniqueidentifier
)
AS
DECLARE @L_CodigoComunicacionAutomatica AS Uniqueidentifier	=	@CodigoComunicacionAutomatica;
 
BEGIN
	SELECT 	 C.TU_CodComunicacionAut						AS CodigoComunicacionAutomatica
			,C.TU_CodAsignacionFirmado						AS CodigoAsignacionFirmado 
			,C.TC_CodContextoOCJ							AS CodigoContextoOCJ
			,A.TC_CodContextoCrea							AS ContextoEnvia
			,CO.TC_Descripcion								AS DescripcionContexto
			,C.TC_CodMedio									AS CodigoTipoMedioComunicacion
			,C.TC_Valor										AS Valor
			,C.TN_CodBarrio									AS CodigoBarrio
			,C.TN_CodDistrito								AS CodigoDistrito
			,C.TN_CodCanton									AS CodigoCanton
			,C.TN_CodProvincia								AS CodigoProvincia
			,C.TN_CodSector									AS CodigoSector
			,C.TC_Rotulado									AS Rotulado
			,C.TB_TienePrioridad							AS TienePrioridad
			,A.TF_FechaCrea									AS FechaResolucion
			,C.TN_CodHorarioMedio							AS CodigoHorarioMedioComunicacion
			,C.TB_RequiereCopias							AS RequiereCopias
			,C.TC_Observaciones								AS Observaciones
			,C.TU_CodPuestoFuncionarioRegistro				AS CodigoPuestoTrabajoFuncionario
			,P.TC_UsuarioRed								AS UsuarioRedPuestoTrabajoFuncionario
			,C.TF_FechaPreRegistro							AS FechaPreRegistro
			,C.TU_CodInterviniente							AS CodigoInterviniente
			,AE.TC_NumeroExpediente							AS NumeroExpediente
			,C.TN_Intento									AS Intento
			
			, 'Split' 										AS Split 
			
			,TM.TC_TipoMedio								AS TipoMedio			
			,C.TN_PrioridadMedio							AS PrioridadMedio
			,C.TC_TipoComunicacion							AS TipoComunicacion
			,C.TC_EstadoEnvio								AS EstadoEnvioComunicacion
			,LA.TU_CodLegajo								AS CodigoLegajo						

		FROM		Comunicacion.ComunicacionRegistroAutomatico		C	WITH(NOLOCK)
		INNER JOIN	Catalogo.TipoMedioComunicacion					TM	WITH(NOLOCK)
		ON			TM.TN_CodMedio									=	C.TC_CodMedio
		INNER JOIN	Catalogo.PuestoTrabajoFuncionario				P	WITH(NOLOCK)
		ON			P.TU_CodPuestoFuncionario						=	C.TU_CodPuestoFuncionarioRegistro
		INNER JOIN	Archivo.AsignacionFirmado						AF	WITH(NOLOCK)
		ON			AF.TU_CodAsignacionFirmado						=	C.TU_CodAsignacionFirmado
		INNER JOIN	Archivo.Archivo									A	WITH(NOLOCK)
		ON			A.TU_CodArchivo									=	AF.TU_CodArchivo 
		LEFT JOIN	Expediente.ArchivoExpediente					AE	WITH(NOLOCK)
		ON			AE.TU_CodArchivo								=	A.TU_CodArchivo
		LEFT JOIN	Expediente.LegajoArchivo						LA	WITH(NOLOCK)
		ON			LA.TU_CodArchivo								=	A.TU_CodArchivo
		INNER JOIN	Catalogo.Contexto								CO	WITH(NOLOCK)
		ON			CO.TC_CodContexto								=	A.TC_CodContextoCrea
		WHERE		C.TU_CodComunicacionAut							=	@L_CodigoComunicacionAutomatica
END
GO
