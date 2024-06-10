SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================
-- Versión:					<1.0>
-- Creado por:				<Esteban Cordero Benavides>
-- Fecha de creación:		<10 de octubre de 2019>
-- Descripción:				<Permite Modificar un catálogo de práctica en la tabla PracticaECB.>
-- =============================================================================================
CREATE Procedure [Catalogo].[PA_ModificarPracticaECB]
		@TN_CodPracticaECB	Int,
		@TC_Descripcion		VarChar(255),
		@TF_Inicio_Vigencia	DateTime2(2),
		@TF_Fin_Vigencia	DateTime2(2)	= Null
As
Begin
	--Variables.
	Declare @L_TN_CodPracticaECB	Int				= @TN_CodPracticaECB,
			@L_TC_Descripcion		VarChar(255)	= @TC_Descripcion,
			@L_TF_Inicio_Vigencia	DateTime2(2)	= @TF_Inicio_Vigencia,
			@L_TF_Fin_Vigencia		DateTime2(2)	= @TF_Fin_Vigencia
     --Lógica.
	Update	Catalogo.PracticaECB With(RowLock)
	Set		TC_Descripcion		= @L_TC_Descripcion,
			TF_Inicio_Vigencia	= @L_TF_Inicio_Vigencia,
			TF_Fin_Vigencia		= @L_TF_Fin_Vigencia
	Where	TN_CodPracticaECB	= @L_TN_CodPracticaECB
End
GO
