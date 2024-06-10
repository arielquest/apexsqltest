SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<19/11/2019>
-- Descripción:			<Permite modificar un registro en la tabla: Compartimiento.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_ModificarCompartimiento]
	@Codigo				SmallInt,
	@Descripcion		VarChar(100),
	@CodEstante			Smallint,
	@Observacion 		Varchar(255),
	@FechaDesactivacion	DateTime2(3)	= Null
As
Begin
	--Variables.
	Declare	@L_TN_CodCompartimiento	SmallInt		= @Codigo,
			@L_TC_Descripcion		VarChar(100)	= @Descripcion,
			@L_TN_CodEstante		Smallint		= @CodEstante,
			@L_TC_Observacion		VarChar(255)	= @Observacion,
			@L_TF_Fin_Vigencia		DateTime2(3)	= @FechaDesactivacion
	--Lógica.
	Update	Catalogo.Compartimiento		With(RowLock)
	Set		TC_Descripcion			= @L_TC_Descripcion,
			TN_CodEstante			= @L_TN_CodEstante,
			TC_Observacion			= @L_TC_Observacion,
			TF_Fin_Vigencia			= @L_TF_Fin_Vigencia
	Where	TN_CodCompartimiento	= @L_TN_CodCompartimiento
End
GO
