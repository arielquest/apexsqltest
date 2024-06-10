SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<04/02/2020>
-- Descripción:			<Permite consultar un registro en la tabla: Ubicacion.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ConsultarUbicacion]
	@Codigo								UNIQUEIDENTIFIER		= NULL,
	@CodigoObjeto						UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodUbicacion			UNIQUEIDENTIFIER		= @Codigo,
			@L_TU_CodigoObjeto			UNIQUEIDENTIFIER		= @CodigoObjeto
	--Lógica
	SELECT	A.TU_CodUbicacion						Codigo,
			A.TC_Descripcion						Descripcion,
			A.TC_UsuarioRed							UsuarioRed,
			A.TF_Fecha								Fecha,
			'SplitObjeto'		   					SplitObjeto, 
			B.TU_CodObjeto							Codigo, 
			B.TC_Descripcion						Descripcion,
			B.TC_NumeroObjeto						NumeroObjeto,
			B.TB_Contenedor							Contenedor,
			'SplitBodega'		   					SplitBodega,
			C.TN_CodBodega							Codigo, 
			C.TC_Descripcion						Descripcion,					
			'SplitSeccion'		   					SplitSeccion,
			D.TN_CodSeccion							Codigo, 
			D.TC_Descripcion						Descripcion,
			'SplitEstante'		   					SplitEstante,
			E.TN_CodEstante							Codigo, 
			E.TC_Descripcion						Descripcion,
			'SplitCompartimiento'		   			SplitCompartimiento,
			F.TN_CodCompartimiento					Codigo,
			F.TC_Descripcion						Descripcion
	FROM	Objeto.Ubicacion						A WITH (NOLOCK)		INNER JOIN
			Objeto.Objeto							B WITH (NOLOCK)
			ON B.TU_CodObjeto						= A.TU_CodObjeto	LEFT JOIN		
			Catalogo.Bodega							C WITH (Nolock) 
			ON A.TN_CodBodega 						= C.TN_CodBodega	LEFT JOIN
			Catalogo.Seccion						D WITH (NoLock)		
			ON A.TN_CodSeccion						= D.TN_CodSeccion	LEFT JOIN
			Catalogo.Estante						E WITH (NoLock)		
			ON A.TN_CodEstante						= E.TN_CodEstante	LEFT JOIN
			Catalogo.Compartimiento					F With(NoLock)
			ON A.TN_CodCompartimiento				= F.TN_CodCompartimiento			
	WHERE	A.TU_CodObjeto							= @L_TU_CodigoObjeto
	AND 	A.TU_CodUbicacion						= Coalesce(@L_TU_CodUbicacion, A.TU_CodUbicacion)
END
GO
