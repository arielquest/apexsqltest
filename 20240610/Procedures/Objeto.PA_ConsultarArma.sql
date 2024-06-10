SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<09/01/2020>
-- Descripción:			<Permite consultar un registro en la tabla: Arma.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ConsultarArma]
	@Codigo					UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto				UNIQUEIDENTIFIER		= @Codigo
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
			AR.TC_Calibre			Calibre,
			AR.TC_Dif				Dif,
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
			'SplitTipoArma'			SplitTipoArma,
			AR.TN_CodTipoArma		Codigo,
			W.TC_Descripcion		Descripcion,	
			'SplitEnumTipoObjeto'	SplitEnumTipoObjeto,
			A.TC_TipoObjeto			TipoObjeto
	FROM	Objeto.Objeto				A WITH (NOLOCK)				INNER JOIN
			Catalogo.Oficina			B WITH (NOLOCK) 
			ON B.TC_CodOficina 			= A.TC_CodOficina			INNER JOIN
			Catalogo.Circuito			C WITH (NOLOCK)		
			ON C.TN_CodCircuito			= B.TN_CodCircuito			INNER JOIN
			Expediente.Expediente		D WITH (NOLOCK)
			ON D.TC_NumeroExpediente	= A.TC_NumeroExpediente		LEFT JOIN
			Catalogo.Moneda				E WITH (NOLOCK)
			ON E.TN_CodMoneda			= A.TN_CodMoneda			LEFT JOIN
			Objeto.Objeto				F WITH (NOLOCK)
			ON F.TU_CodObjeto			= A.TU_CodigoObjetoPadre	INNER JOIN	
			-- Datos del Arma
			Objeto.Arma					AR WITH (NOLOCK)				
			ON AR.TU_CodObjeto 			= A.TU_CodObjeto			INNER JOIN
			Catalogo.TipoArma			W WITH (NOLOCK) 
			ON W.TN_CodTipoArma			= AR.TN_CodTipoArma
	WHERE	A.TU_CodObjeto				= @L_TU_CodObjeto
END
GO
