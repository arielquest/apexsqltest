SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		   <Juan Ramirez V.>
-- Fecha Creación: <13/10/2017>
-- Descripcion:	   <Consulta la lista de Firmantes (Tabla Detalle) de una asignación>
-- Devuelve lista de asignantes(firmantes) de una asignación
-- =================================================================================================================================================
-- Modificación		<Jonathan Aguilar Navarro> <20/0/2018> <Se agregan a la consutla los campos TB_Nota, TB_Voto y
--					TC_JustificacionSalvaNotaVoto>
CREATE PROCEDURE [Expediente].[PA_ConsultarAsignacionFirmantes]
	@Codigo uniqueidentifier,
	@CodPuestoTrabajo varchar(14)	
WITH RECOMPILE
AS
BEGIN
	SELECT 
		A.TN_Orden AS Orden,
		A.TF_FechaAplicado AS FechaAplicado,
		A.TF_FechaRevisado AS FechaRevisado,
		A.TB_Nota		   AS IndicaSiEsNotas,
		A.TB_Salva		   AS IndicaSiEsVoto,
		A.TC_JustificacionSalvaVotoNota	AS ObservacionNotaVoto,
		--Asignación Firma
		'Split' AS Split,		
		A.TU_CodAsignacionFirmado AS Codigo,
		--Puesto de trabajo asignado
		'Split' AS Split,		
		A.TC_CodPuestoTrabajo AS Codigo,
		F.TC_Descripcion AS Descripcion,		 
		 --Firmado por
		'Split' AS Split,
		A.TU_FirmadoPor AS CodigoFirmadoPor,			
		C.UsuarioRed AS UsuarioRed,
		C.Nombre AS Nombre,
		C.PrimerApellido AS PrimerApellido,
		C.PrimerApellido AS SegundoApellido
	FROM [Expediente].[AsignacionFirmante] A		
		INNER JOIN  [Expediente].[AsignacionFirmado] B WITH(NOLOCK) 
		ON	A.TU_CodAsignacionFirmado = B.TU_CodAsignacionFirmado	
		--Firmado por
		CROSS APPLY Catalogo.FN_ConsultarFuncionarioPorPuestoTrabajo(A.TC_CodPuestoTrabajo) C
		LEFT JOIN  Catalogo.PuestoTrabajo F WITH(NOLOCK) 
		ON	F.TC_CodPuestoTrabajo = A.TC_CodPuestoTrabajo			
	 WHERE 
		A.TU_CodAsignacionFirmado = ISNULL(@Codigo, A.TU_CodAsignacionFirmado) AND
		A.TC_CodPuestoTrabajo = ISNULL(@CodPuestoTrabajo, A.TC_CodPuestoTrabajo) 
	 ORDER BY TN_Orden		
END

GO
