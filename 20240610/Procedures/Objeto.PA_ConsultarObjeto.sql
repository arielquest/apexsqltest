SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<03/12/2019>
-- Descripción:			<Permite consultar un registro en la tabla: Objeto.>
-- ==================================================================================================================================================================================
-- Modificación:		<31/01/2020> <Ronny Ramírez R.> <Se agregan campo CodObjetoPadre para poder consultar los objetos que sean hijos del objeto contenedor indicado>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ConsultarObjeto]
	@Codigo					UNIQUEIDENTIFIER	= NULL,
	@NumeroExpediente		CHAR(14),
	@CodObjetoPadre			UNIQUEIDENTIFIER	= NULL
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto				UNIQUEIDENTIFIER		= 	@Codigo,
			@L_TC_NumeroExpediente		CHAR(14)				=	@NumeroExpediente,
			@L_TU_CodObjetoPadre		UNIQUEIDENTIFIER		= 	@CodObjetoPadre
	--Lógica
	SELECT	A.TU_CodObjeto			Codigo,
			A.TC_NumeroObjeto		NumeroObjeto,
			A.TC_Descripcion		Descripcion,
			A.TC_Observacion		Observacion,
			A.TC_Marca				Marca,
			A.TC_Modelo				Modelo,
			A.TC_Serie				Serie,
			A.TC_Color				Color,
			A.TB_Peritaje			Peritaje,
			A.TN_Valor				Valor,
			A.TF_FechaRegistro		FechaRegistro,
			A.TB_Contenedor			Contenedor,
			A.TC_UsuarioRed			UsuarioRed,
			A.TB_Ley				Ley,			
			'SplitCircuito'		   	SplitCircuito, 
			C.TN_CodCircuito		Codigo, 
			C.TC_Descripcion		Descripcion,
			'SplitOficina'		   	SplitOficina, 
			B.TC_CodOficina			Codigo, 
			B.TC_Nombre				Descripcion,
			'SplitExpediente'		SplitExpediente,
			D.TC_NumeroExpediente	Numero,
			D.TC_Descripcion		Descripcion,
			'SplitMoneda'			SplitMoneda,			
			E.TN_CodMoneda			Codigo,
			E.TC_Descripcion		Descripcion,
			'SplitObjetoPadre'		SplitObjetoPadre,	
			F.TU_CodObjeto			Codigo,
			'SplitDatos'			SplitDatos,
			A.TC_TipoObjeto			TipoObjeto
	FROM	Objeto.Objeto				A WITH (NOLOCK)			INNER JOIN
			Catalogo.Oficina			B WITH (NOLOCK) 
			ON B.TC_CodOficina 			= A.TC_CodOficina		INNER JOIN
			Catalogo.Circuito			C WITH (NOLOCK)		
			ON C.TN_CodCircuito			= B.TN_CodCircuito		INNER JOIN
			Expediente.Expediente		D WITH (NOLOCK)
			ON D.TC_NumeroExpediente	= A.TC_NumeroExpediente LEFT JOIN
			Catalogo.Moneda				E WITH (NOLOCK)
			ON E.TN_CodMoneda			= A.TN_CodMoneda		LEFT JOIN
			Objeto.Objeto				F WITH (NOLOCK)
			ON F.TU_CodObjeto			= A.TU_CodigoObjetoPadre	
	WHERE	A.TC_NumeroExpediente		= @L_TC_NumeroExpediente
	AND 	A.TU_CodObjeto				= Coalesce(@L_TU_CodObjeto, A.TU_CodObjeto)
	AND		(@L_TU_CodObjetoPadre		Is Null OR A.TU_CodigoObjetoPadre = @L_TU_CodObjetoPadre)
	ORDER BY CAST(SUBSTRING(A.TC_NumeroObjeto, 1, 2) AS INTEGER), CAST(SUBSTRING(A.TC_NumeroObjeto, 4, LEN(A.TC_NumeroObjeto)-3) AS INTEGER), A.TC_Descripcion
END
GO
