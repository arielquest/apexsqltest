SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

	-- ======================================================================================================================================================
	-- Autor:				<Mario Camacho Flores>
	-- Fecha Creación:		<04/01/2022>
	-- Descripcion:			<Modifica una institucion>
	-- ======================================================================================================================================================
	
	CREATE   PROCEDURE [Catalogo].[PA_ModificarInstitucion]
		@CedulaJuridica				Varchar(20),
		@Descripcion				Varchar(255),
		@Siglas						Varchar(10), 
		@FechaVencimiento			Datetime2(7) = Null	
	AS
	BEGIN

		DECLARE
		@L_CedulaJuridica			Varchar(20) = @CedulaJuridica,
		@L_Descripcion				Varchar(255) = @Descripcion,
		@L_Siglas					Varchar(10) = @Siglas,
		@L_FechaVencimiento			Datetime2(7) = @FechaVencimiento

		UPDATE	Catalogo.Institucion
		Set		TC_Descripcion		= @L_Descripcion,
				TC_Siglas			= @L_Siglas,
				TF_Fin_Vigencia		= @L_FechaVencimiento
		Where	TC_Cedula_Juridica	= @L_CedulaJuridica
	END
GO
