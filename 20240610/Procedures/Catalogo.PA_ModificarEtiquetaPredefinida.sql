SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Jonathan Aguilar Navarro>
-- Fecha de creación:	<17/12/2019>
-- Descripción:			<Permite modificar un registro en la tabla: EtiquetaPredefinida.>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarEtiquetaPredefinida]
	@CodEtiquetaPredefinida						SMALLINT,
	@Descripcion								VARCHAR(150),
	@FinVigencia								DATETIME2(3)	= NULL
AS
BEGIN
	--Variables.
	DECLARE	@L_TN_CodEtiquetaPredefinida		SMALLINT		= @CodEtiquetaPredefinida,
			@L_TC_Descripcion					VARCHAR(150)	= @Descripcion,
			@L_TF_Fin_Vigencia					DATETIME2(3)	= @FinVigencia
	--Lógica.
	UPDATE	Catalogo.EtiquetaPredefinida		WITH(ROWLOCK)
	SET		TC_Descripcion						= @L_TC_Descripcion,
			TF_Fin_Vigencia						= @L_TF_Fin_Vigencia
	WHERE	TN_CodEtiquetaPredefinida			= @L_TN_CodEtiquetaPredefinida
END
GO
