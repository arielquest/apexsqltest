SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jose Gabriel Cordero Soto>
-- Fecha de creación:	<18/03/2020>
-- Descripción:			<Permite listar los documentos por asociar a una solicitud, donde no tenga relacionado el mismo.>
-- ==================================================================================================================================================================================
-- Modificado por:      <25/03/2020><Se ajusta resultado del procedimiento almacenado>
-- Modificación			<20/02/2021> <Aida Elena Siles R> <Se agrega el contexto para que no muestre documentos creados en otro contexto>
-- Modificación			<01/06/2022> <Aida Elena Siles R> <Se excluyen los archivos de tipo multimedia. PBI 252289>
-- Modificación			<02/10/2023> <Josué Quirós Batista> <En caso de tramitar una solicitud desde un legajo se listan los documentos asociados al legajo>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Expediente].[PA_ConsultarDocumentosAsociarSolicitudes]
	@CodSolicitudExpediente							UNIQUEIDENTIFIER,
	@NumeroExpediente								VARCHAR(14),
	@CodigoLegajo									UNIQUEIDENTIFIER,
	@CodContexto									VARCHAR(4)
AS
BEGIN
	--Variables
	DECLARE	@L_CodSolicitudExpediente	   			UNIQUEIDENTIFIER		= @CodSolicitudExpediente
	DECLARE @L_NumeroExpediente						VARCHAR(14)				= @NumeroExpediente
	DECLARE @L_CodContexto							VARCHAR(4)				= @CodContexto
	DECLARE	@L_CodigoLegajo	   					UNIQUEIDENTIFIER		    = CASE @CodigoLegajo
																			  WHEN '00000000-0000-0000-0000-000000000000' THEN NULL
																			  ELSE @CodigoLegajo
																		      END
	
	--Lógica

IF @L_CodigoLegajo IS NULL

	SELECT			A.TU_CodArchivo					        AS Codigo,
					A.TC_Descripcion				        AS Descripcion,					
					'splitFuncionario'				        AS splitFuncionario,
					A.TF_FechaCrea					        AS FechaCreacion,
					F.TC_UsuarioRed					        AS UsuarioRed,
					F.TC_Nombre						        AS Nombre,
					F.TC_PrimerApellido				        AS PrimerApellido,
					F.TC_SegundoApellido			        AS SegundoApellido
													        
	FROM			Expediente.ArchivoExpediente	        AS AE WITH(NOLOCK) 
	INNER JOIN		Archivo.Archivo					        AS A  WITH(NOLOCK)
	ON				A.TU_CodArchivo					        = AE.TU_CodArchivo
	AND				A.TB_Multimedia					        = 0
	INNER JOIN		Catalogo.Funcionario			        AS F  WITH(NOLOCK)
	ON				A.TC_UsuarioCrea				        = F.TC_UsuarioRed
	INNER JOIN		
	(
				SELECT		AE.TU_CodArchivo
				FROM		Expediente.ArchivoExpediente	AE WITH(NOLOCK)
				WHERE		AE.TC_NumeroExpediente			= @L_NumeroExpediente
				EXCEPT
				SELECT		S.TU_CodArchivo
				FROM		Expediente.SolicitudExpediente	S WITH(NOLOCK)
				WHERE		S.TC_NumeroExpediente			 = @L_NumeroExpediente 
				AND S.TU_CodSolicitudExpediente				 = @L_CodSolicitudExpediente
				EXCEPT
				SELECT		LA.TU_CodArchivo
				FROM		Expediente.LegajoArchivo		LA WITH(NOLOCK)
				WHERE		LA.TC_NumeroExpediente			= @L_NumeroExpediente
	) AS X
	ON			X.TU_CodArchivo								 = AE.TU_CodArchivo 		
	
	WHERE AE.TC_NumeroExpediente							 = @L_NumeroExpediente
	AND A.TN_CodEstado										 = 4	
	AND AE.TB_Eliminado										 = 0
	AND	A.TC_CodContextoCrea								 =	@L_CodContexto

ELSE

	SELECT			A.TU_CodArchivo							AS Codigo,
					A.TC_Descripcion						AS Descripcion,					
					'splitFuncionario'						AS splitFuncionario,
					A.TF_FechaCrea							AS FechaCreacion,
					F.TC_UsuarioRed							AS UsuarioRed,
					F.TC_Nombre								AS Nombre,
					F.TC_PrimerApellido						AS PrimerApellido,
					F.TC_SegundoApellido					AS SegundoApellido

	FROM			Expediente.LegajoArchivo				AS AE WITH(NOLOCK) 
	INNER JOIN		Archivo.Archivo							AS A  WITH(NOLOCK)
	ON				A.TU_CodArchivo							= AE.TU_CodArchivo
	AND				A.TB_Multimedia							= 0
	INNER JOIN		Expediente.ArchivoExpediente	        AS EX WITH(NOLOCK) 
	ON				EX.TU_CodArchivo						= AE.TU_CodArchivo
	INNER JOIN		Catalogo.Funcionario					AS F  WITH(NOLOCK)
	ON				A.TC_UsuarioCrea						= F.TC_UsuarioRed
	INNER JOIN		
	(
				SELECT		AE.TU_CodArchivo
				FROM		Expediente.LegajoArchivo		AE WITH(NOLOCK)
				WHERE		AE.TU_CodLegajo					= @L_CodigoLegajo
				EXCEPT
				SELECT		S.TU_CodArchivo
				FROM		Expediente.SolicitudExpediente	S WITH(NOLOCK)
				WHERE		S.TU_CodLegajo					= @L_CodigoLegajo 
				AND			S.TU_CodSolicitudExpediente		= @L_CodSolicitudExpediente
	) AS X
	ON			X.TU_CodArchivo								= AE.TU_CodArchivo 		
	
	WHERE       AE.TU_CodLegajo								= @L_CodigoLegajo
	AND         A.TN_CodEstado								= 4	
	AND         EX.TB_Eliminado								= 0
	AND	        A.TC_CodContextoCrea						=	@L_CodContexto

END
GO
