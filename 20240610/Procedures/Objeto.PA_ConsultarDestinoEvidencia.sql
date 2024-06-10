SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<24/02/2020>
-- Descripción:			<Permite consultar un registro en la tabla: DestinoEvidencia.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE	[Objeto].[PA_ConsultarDestinoEvidencia]
	@Codigo					UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TU_CodObjeto				UNIQUEIDENTIFIER		= @Codigo
	--Lógica
	SELECT	
			A.TC_Fiscal					Fiscal,
			A.TF_Disposicion			FechaDisposicion,			
			A.TF_Entrega				FechaEntrega,
			A.TC_UsuarioRed				UsuarioRed,
			A.TF_Fecha					Fecha,
			'SplitObjeto'	   			SplitObjeto, 
			B.TU_CodObjeto				Codigo, 
			B.TC_Descripcion			Descripcion,
			B.TC_NumeroObjeto			NumeroObjeto,
			B.TB_Contenedor				Contenedor,
			'SplitDatos'				'SplitDatos',
			A.TC_Disposicion			Disposicion,
			A.TC_OrdenDe				OrdenDe,
			A.TC_Destino				Destino
	FROM	Objeto.DestinoEvidencia		A WITH (NOLOCK)			INNER JOIN
			Objeto.Objeto				B WITH (NOLOCK)
			ON B.TU_CodObjeto			= A.TU_CodObjeto
	WHERE	A.TU_CodObjeto				= @L_TU_CodObjeto
END
GO
