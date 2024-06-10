SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- ===================================================================================================================================================
-- Autor:		   <Juan Ramirez V.>
-- Fecha Creación: <13/10/2017>
-- Descripcion:	   <Consulta la lista de Firmantes (Tabla Detalle) de una asignación>
-- Devuelve lista de asignantes(firmantes) de una asignación
-- ===================================================================================================================================================
-- Modificación		<Jonathan Aguilar Navarro> <20/0/2018> <Se agregan a la consutla los campos TB_Nota, TB_Voto y
--					TC_JustificacionSalvaNotaVoto>
-- Modificación		<Jonathan Aguilar Navarro> <17/09/2018> <Se crea el esquema Archivo y se renombre respectivamente en los sp y tablas> 
-- Modificación		<Daniel Ruiz Hernández> <04/03/2021> <Se consulta si firmo digital y si la firma esta bloqueada>
-- Modificación:	<Jonathan Aguilar Navarro><27/09/2021><Se corrige el sp ya que se estaba enviando en "FirmadoPor" el primer apeliido dos veces> 
-- Modificación:	<Aarón Ríos Retana><20-01-2022><Bug 234210 - Se añade A.TC_CodBarras para obtener el código de barras de la asignación de firmado> 
-- Modificación		<Ronny Ramírez R.> <13/07/2023> <Se aplica ajuste para eliminar el comando WITH RECOMPILE, para optimizar la consulta>
-- Modificación		<Ronny Ramírez R.> <14/07/2023> <Se aplica ajuste que optimiza la consulta, incluyendo OPTION(RECOMPILE) para evitar  
--													problema de no uso de índices por el mal uso de COALESCE en el WHERE>
-- ===================================================================================================================================================
CREATE PROCEDURE [Archivo].[PA_ConsultarAsignacionFirmantes]
	@Codigo uniqueidentifier,
	@CodPuestoTrabajo varchar(14)
AS
DECLARE @L_Codigo uniqueidentifier = @Codigo,
		@L_CodPuestoTrabajo varchar(14) = @CodPuestoTrabajo
BEGIN
	SELECT 
		A.TN_Orden							AS Orden,
		A.TF_FechaAplicado					AS FechaAplicado,
		A.TF_FechaRevisado					AS FechaRevisado,
		A.TB_Nota							AS IndicaSiEsNotas,
		A.TB_Salva							AS IndicaSiEsVoto,
		A.TC_JustificacionSalvaVotoNota		AS ObservacionNotaVoto,
		A.TB_EsFirmaDigital					AS EsFirmaDigital,
		A.TB_BloqueaArchivo					AS BloqueaFirma,
		A.TC_CodBarras						AS CodigoBarras,
		--Asignación Firma
		'Split'								AS Split,		
		A.TU_CodAsignacionFirmado			AS Codigo,
		--Puesto de trabajo asignado
		'Split'								AS Split,		
		A.TC_CodPuestoTrabajo				AS Codigo,
		F.TC_Descripcion					AS Descripcion,		 
		 --Firmado por
		'Split'								AS Split,
		A.TU_FirmadoPor						AS CodigoFirmadoPor,			
		C.UsuarioRed						AS UsuarioRed,
		C.Nombre							AS Nombre,
		C.PrimerApellido					AS PrimerApellido,
		C.SegundoApellido					AS SegundoApellido
	FROM [Archivo].[AsignacionFirmante] A		
		INNER JOIN  [Archivo].[AsignacionFirmado] B WITH(NOLOCK) 
		ON	A.TU_CodAsignacionFirmado		= B.TU_CodAsignacionFirmado	
		--Firmado por
		CROSS APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) C
		LEFT JOIN  Catalogo.PuestoTrabajo F WITH(NOLOCK) 
		ON	F.TC_CodPuestoTrabajo			= A.TC_CodPuestoTrabajo			
	 WHERE 
		A.TU_CodAsignacionFirmado			= ISNULL(@L_Codigo, A.TU_CodAsignacionFirmado) AND
		A.TC_CodPuestoTrabajo				= ISNULL(@L_CodPuestoTrabajo, A.TC_CodPuestoTrabajo) 
	 ORDER BY TN_Orden
	 OPTION(RECOMPILE);
END

GO
