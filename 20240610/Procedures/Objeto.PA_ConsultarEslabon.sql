SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<27/01/2020>
-- Descripción:			<Permite consultar un registro en la tabla: Eslabon.>
-- ==================================================================================================================================================================================
-- Modificación:		<09/02/2021> <Ronny Ramírez R.> <Se aplica corrección en consulta para que los resultados se ordenen por fecha descendentemente como lo indica la HU.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ConsultarEslabon]

	@Codigo						UNIQUEIDENTIFIER = NULL,
	@CodigoObjeto				UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodEslabon	UNIQUEIDENTIFIER	= @Codigo,
			@L_TU_CodigoObjeto	UNIQUEIDENTIFIER	= @CodigoObjeto
	--Lógica
	SELECT	A.TU_CodEslabon							Codigo,
			A.TC_IdentificacionEntrega				IdentificacionEntrega,
			A.TC_NombreCompletoEntrega				NombreCompletoEntrega,
			A.TC_UsuarioRedEntrega					UsuarioRedEntrega,
			A.TC_IdentificacionRecibe				IdentificacionRecibe,
			A.TC_NombreCompletoRecibe				NombreCompletoRecibe,
			A.TC_UsuarioRedRecibe					UsuarioRedRecibe,
			A.TC_Tomo								Tomo,
			A.TC_Folio								Folio,
			A.TF_Fecha								Fecha,
			A.TC_Observaciones						Observaciones,
			A.TF_Actualizacion						Actualizacion,
			'SplitObjeto'		   					SplitObjeto, 
			B.TU_CodObjeto							Codigo, 
			B.TC_Descripcion						Descripcion,
			B.TC_NumeroObjeto						NumeroObjeto,
			'SplitOficinaEntrega'		   			SplitOficinaEntrega, 
			C.TC_CodOficina							Codigo, 
			C.TC_Nombre								Descripcion,
			'SplitTipoIdentificacionEntrega'		SplitTipoIdentificacionEntrega, 
			D.TN_CodTipoIdentificacion				Codigo, 
			D.TC_Descripcion						Descripcion,
			'SplitOficinaRecibe'		   			SplitOficinaRecibe, 
			E.TC_CodOficina							Codigo, 
			E.TC_Nombre								Descripcion,
			'SplitTipoIdentificacionRecibe'			SplitTipoIdentificacionRecibe, 
			F.TN_CodTipoIdentificacion				Codigo, 
			F.TC_Descripcion						Descripcion
	FROM	Objeto.Eslabon							A WITH (NOLOCK)								INNER JOIN
			Objeto.Objeto							B WITH (NOLOCK)
			ON B.TU_CodObjeto						= A.TU_CodObjeto							LEFT JOIN
			Catalogo.Oficina						C WITH (NOLOCK) 
			ON C.TC_CodOficina 						= A.TC_CodOficina_Entrega					INNER JOIN
			Catalogo.TipoIdentificacion				D WITH (NOLOCK) 
			ON D.TN_CodTipoIdentificacion			= A.TN_CodTipoIdentificacionEntrega			INNER JOIN
			Catalogo.Oficina						E WITH (NOLOCK) 
			ON E.TC_CodOficina 						= A.TC_CodOficina_Recibe					INNER JOIN
			Catalogo.TipoIdentificacion				F WITH (NOLOCK) 
			ON F.TN_CodTipoIdentificacion			= A.TN_CodTipoIdentificacionRecibe 
	WHERE	A.TU_CodObjeto							= @L_TU_CodigoObjeto
	AND 	A.TU_CodEslabon							= Coalesce(@L_TU_CodEslabon, A.TU_CodEslabon)
	ORDER BY A.TF_Fecha DESC
END
GO
