SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ======================================================================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creación:		<17/08/2021>
-- Descripcion:			<Modifica una entidad jurídica>
-- ======================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarEntidadJuridica]
	@Identificacion				Varchar(255),
	@Siglas						Varchar(255), 
	@FechaVencimiento			Datetime2(7) = Null	
AS
BEGIN

	DECLARE
	@L_Identificacion			Varchar(255) = @Identificacion,
	@L_Siglas					Varchar(255) = @Siglas,
	@L_FechaVencimiento			Datetime2(7) = @FechaVencimiento

	UPDATE	Catalogo.EntidadJuridica
	Set		TC_Siglas			= @L_Siglas,
			TF_Fin_Vigencia		= @L_FechaVencimiento
	Where	TC_Identificacion	= @L_Identificacion
END
GO
