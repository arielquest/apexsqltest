SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<05/11/2019>
-- Descripción:			<Permite modificar un registro en la tabla: TipoArma.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_ModificarTipoArma]
	@TN_CodTipoArma		SmallInt,
	@TC_Descripcion		VarChar(100),
	@TC_Observacion 	Varchar(255),
	@TF_Fin_Vigencia	DateTime2(3)	= Null
As
Begin
	--Variables.
	Declare	@L_TN_CodTipoArma	SmallInt			= @TN_CodTipoArma,
			@L_TC_Descripcion		VarChar(100)	= @TC_Descripcion,
			@L_TC_Observacion		VarChar(255)	= @TC_Observacion,
			@L_TF_Fin_Vigencia		DateTime2(3)	= @TF_Fin_Vigencia
	--Lógica.
	Update	Catalogo.TipoArma		With(RowLock)
	Set		TC_Descripcion			= @L_TC_Descripcion,
			TC_Observacion			= @L_TC_Observacion,
			TF_Fin_Vigencia			= @L_TF_Fin_Vigencia
	Where	TN_CodTipoArma			= @L_TN_CodTipoArma
End
GO
