SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Aida E Siles R>
-- Fecha de creación:	<17/01/2020>
-- Descripción:			<Permite agregar un registro en la tabla: TipoRechazoSolicitudDefensor.>
-- Modificación:		<13/03/2020> <AIDA E SILES> <No se realiza ninguna modificación en el SP simplemente se cambia a alter para que lo vuelvan a correr, corregir BUG 115588>
-- ==================================================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_AgregarTipoRechazoSolicitudDefensor]
	@Descripcion		VARCHAR(150),
	@InicioVigencia		DATETIME2(7),
	@FinVigencia		DATETIME2(7)	= NULL
AS
BEGIN
	--Variables.
DECLARE @L_TC_Descripcion		VARCHAR(150)	= @Descripcion,
		@L_TF_Inicio_Vigencia	DATETIME2(7)	= @InicioVigencia,
		@L_TF_Fin_Vigencia		DATETIME2(7)	= @FinVigencia
	--Lógica.
	INSERT INTO	Catalogo.TipoRechazoSolicitudDefensor WITH(ROWLOCK)
	(
		TC_Descripcion,		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	VALUES
	(
		@L_TC_Descripcion,	@L_TF_Inicio_Vigencia,	@L_TF_Fin_Vigencia
	)
END
GO
