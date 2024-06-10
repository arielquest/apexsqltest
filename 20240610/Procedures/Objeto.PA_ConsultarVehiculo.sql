SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<17/12/2019>
-- Descripción:			<Permite consultar un registro en la tabla: Vehiculo.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ConsultarVehiculo]

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
			V.TC_Placa				Placa,			
			V.TC_Cilindraje			Cilindraje,
			V.TC_Anno				Anno,
			V.TC_Cubicaje			Cubicaje,
			V.TC_NumeroMotor		NumeroMotor,
			V.TC_NumeroChasis		NumeroChasis,
			V.TC_NumeroVin			NumeroVin,
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
			'SplitTipoVehiculo'		SplitTipoVehiculo,
			V.TN_CodTipoVehiculo	Codigo,
			W.TC_Descripcion		Descripcion,
			'SplitTipoPlaca'		SplitTipoPlaca,
			V.TN_CodTipoPlaca		Codigo,
			X.TC_Descripcion		Descripcion,
			'SplitEstiloVehiculo'	SplitEstiloVehiculo,
			V.TN_CodEstiloVehiculo	Codigo,
			Y.TC_Descripcion		Descripcion,
			'SplitMarcaVehiculo'	SplitMarcaVehiculo,
			V.TN_CodMarcaVehiculo	Codigo,
			Z.TC_Descripcion		Descripcion,
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
			-- Datos de Vehículo
			Objeto.Vehiculo				V WITH (NOLOCK)				
			ON V.TU_CodObjeto 			= A.TU_CodObjeto			INNER JOIN
			Catalogo.TipoVehiculo		W WITH (NOLOCK) 
			ON W.TN_CodTipoVehiculo		= V.TN_CodTipoVehiculo		INNER JOIN
			Catalogo.TipoPlaca			X WITH (NOLOCK) 
			ON X.TN_CodTipoPlaca		= V.TN_CodTipoPlaca			INNER JOIN
			Catalogo.EstiloVehiculo		Y WITH (NOLOCK) 
			ON Y.TN_CodEstiloVehiculo	= V.TN_CodEstiloVehiculo	INNER JOIN
			Catalogo.MarcaVehiculo		Z WITH (NOLOCK) 
			ON Z.TN_CodMarcaVehiculo	= V.TN_CodMarcaVehiculo
	WHERE	A.TU_CodObjeto				= @L_TU_CodObjeto
END
GO
