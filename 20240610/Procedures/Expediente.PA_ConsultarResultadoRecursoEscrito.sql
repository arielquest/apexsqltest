SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==================================================================================================================================================================================
-- Versión:				<1.1>
-- Creado por:			<Oscar Sánchez Hernández.>
-- Fecha de creación:	<18/08/2022>
-- Descripción:			<Permite listar los escritos asociados al resultado del recurso del expediente>
-- ==================================================================================================================================================================================
-- Modificado:			<Aaron Rios Retana>< 19-08-2022 -> HU 270202 - Se modifica para traer los datos del funcionario relacionado al puesto de trabajo, y obtener el ID del archivo >
-- ==================================================================================================================================================================================
CREATE   PROCEDURE [Expediente].[PA_ConsultarResultadoRecursoEscrito]
	@CodResultadoRecurso						UNIQUEIDENTIFIER		
AS
BEGIN
	--Variables
	DECLARE	@L_CodResultadoRecurso	   	    UNIQUEIDENTIFIER		=    @CodResultadoRecurso

	--Selección
	SELECT      RSE.TU_CodEscrito																									AS  Codigo,
				AE.TC_Descripcion																									AS	Descripcion,				
				AE.TF_FechaRegistro																									AS  FechaRegistro,
				'splitFuncionario'																									AS  splitFuncionario,
				AE.TC_CodPuestoTrabajo																								AS	CodPuestoTrabajo,
				PT.TC_UsuarioRed																									AS  UsuarioRed,
				REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(PT.TC_Nombre)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')						AS	Nombre,
				REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(PT.TC_PrimerApellido)), CHAR(9), ''), CHAR(10),''), CHAR(13), '')				AS	PrimerApellido,
				REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(ISNULL(PT.TC_SegundoApellido, ''))), CHAR(9), ''), CHAR(10),''), CHAR(13), '')	AS	SegundoApellido,
				'splitOtros'																										AS  splitOtros,
				AE.TC_IDARCHIVO																										AS	CodigoArchivo,
				AE.TC_NumeroExpediente																								AS	NumeroExpediente,
				AE.TC_EstadoEscrito																									AS	EstadoEscrito

	FROM	    Expediente.ResultadoRecursoEscrito	AS	RSE WITH(NOLOCK) 

	INNER JOIN  Expediente.EscritoExpediente			AS  AE	WITH(NOLOCK)
	ON			RSE.TU_CodEscrito						=   AE.TU_CodEscrito

	INNER JOIN  Expediente.ResultadoRecurso				AS  A   WITH(NOLOCK)
	ON			A.TU_CodResultadoRecurso				=   RSE.TU_CodResultadoRecurso

	INNER JOIN	Catalogo.PuestoTrabajo						C WITH(NOLOCK)
	ON			AE.TC_CodPuestoTrabajo						=C.TC_CodPuestoTrabajo

	OUTER APPLY (	
	             Select F.* 
				 from Catalogo.PuestoTrabajoFuncionario P WITH(NOLOCK)
				 INNER JOIN	Catalogo.Funcionario		F WITH(NOLOCK)
                 ON          P.TC_UsuarioRed            =F.TC_UsuarioRed
				 where 
				 P.TF_Inicio_Vigencia <= GETDATE() 
				 and (P.TF_Fin_Vigencia >= GETDATE() or P.TF_Fin_Vigencia is null)
				 and C.TC_CodPuestoTrabajo = P.TC_CodPuestoTrabajo
				 ) PT

	WHERE		RSE.TU_CodResultadoRecurso			=	@L_CodResultadoRecurso
END
GO
