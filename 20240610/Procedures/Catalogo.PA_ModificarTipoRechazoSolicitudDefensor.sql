SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles>
-- Fecha de creación:	<21/01/2020>
-- Descripción:			<Permite modificar un registro en la tabla: TipoRechazoSolicitudDefensor.>
-- Modificación:		<13/03/2020> <AIDA E SILES> <No se realiza ninguna modificación en el SP simplemente se cambia a alter para que lo vuelvan a correr, corregir BUG 115588>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarTipoRechazoSolicitudDefensor]
	@Codigo				SMALLINT,
	@Descripcion		VARCHAR(150),
	@FinVigencia		DATETIME2(7)	= NULL
AS
BEGIN
	--Variables.
	DECLARE	@L_TN_CodTipoRechazoSolicitudDefensor	SMALLINT		= @Codigo,
			@L_TC_Descripcion						VARCHAR(150)	= @Descripcion,
			@L_TF_Fin_Vigencia						DATETIME2(7)	= @FinVigencia
	--Lógica.
	UPDATE	Catalogo.TipoRechazoSolicitudDefensor		WITH(ROWLOCK)
	SET		TC_Descripcion								= @L_TC_Descripcion,
			TF_Fin_Vigencia								= @L_TF_Fin_Vigencia
	WHERE	TN_CodTipoRechazoSolicitudDefensor			= @L_TN_CodTipoRechazoSolicitudDefensor
END
GO
