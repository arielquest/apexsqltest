SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez R.>
-- Fecha de creación:	<11/02/2020>
-- Descripción:			<Permite consultar un registro en la tabla: Documento.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ConsultarDocumento]
	@Codigo								UNIQUEIDENTIFIER		= NULL,
	@CodigoObjeto						UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodArchivo				UNIQUEIDENTIFIER		= @Codigo,
			@L_TU_CodigoObjeto				UNIQUEIDENTIFIER		= @CodigoObjeto
	--Lógica
	SELECT	A.TU_CodArchivo					Codigo,			
			A.TC_Descripcion				Nombre,			
			A.TF_FechaCrea					FechaCrea,
			B.TC_Descripcion				Descripcion,
			
			'SplitObjeto'		   			SplitObjeto, 
			C.TU_CodObjeto					Codigo, 
			C.TC_Descripcion				Descripcion,
			C.TC_NumeroObjeto				NumeroObjeto,
			C.TB_Contenedor					Contenedor,
			
			'SplitContexto'					SplitContexto,			
			D.TC_CodContexto				Codigo,
			D.TC_Descripcion				Descripcion,
			D.TF_Inicio_Vigencia			FechaActivacion,
			D.TF_Fin_Vigencia				FechaDesactivacion,
			D.TC_Telefono					Telefono,
			D.TC_Fax						Fax,
			D.TC_Email						Email,
			
			'SplitFormatoArchivo'			SplitFormatoArchivo,
			E.TN_CodFormatoArchivo			Codigo,
			E.TC_Descripcion				Descripcion,
			E.TF_Inicio_Vigencia			FechaActivacion,
			E.TF_Fin_Vigencia				FechaDesactivacion,
			
			'SplitUsuarioCrea'				SplitUsuarioCrea,
			F.TC_UsuarioRed					UsuarioRed,
			F.TC_Nombre						Nombre,
			F.TC_PrimerApellido				PrimerApellido,
			F.TC_SegundoApellido			SegundoApellido,
			F.TC_CodPlaza					CodigoPlaza,
			F.TF_Inicio_Vigencia			FechaActivacion,
			F.TF_Fin_Vigencia				FechaDesactivacion
						
	FROM	Archivo.Archivo				A WITH (NOLOCK)				INNER JOIN
			Objeto.Documento			B WITH (NOLOCK)
			ON A.TU_CodArchivo			= B.TU_CodArchivo			INNER JOIN
			Objeto.Objeto				C WITH (NOLOCK)
			ON C.TU_CodObjeto			= B.TU_CodObjeto			INNER JOIN	
			Catalogo.Contexto			D WITH(NOLOCK)
			ON A.TC_CodContextoCrea		= D.TC_CodContexto			INNER JOIN	
			Catalogo.FormatoArchivo		E WITH(NOLOCK)
			ON A.TN_CodFormatoArchivo	= E.TN_CodFormatoArchivo	INNER JOIN	
			Catalogo.Funcionario		F WITH(NOLOCK)
			ON A.TC_UsuarioCrea			= F.TC_UsuarioRed
	
	WHERE	B.TU_CodObjeto				= @L_TU_CodigoObjeto
	AND		A.TU_CodArchivo				= Coalesce(@L_TU_CodArchivo, A.TU_CodArchivo)
END
GO
