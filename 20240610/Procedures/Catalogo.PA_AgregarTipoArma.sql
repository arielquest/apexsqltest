SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<05/11/2019>
-- Descripción:			<Permite agregar un registro en la tabla: TipoArma.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_AgregarTipoArma]
	@TC_Descripcion		VarChar(100),
	@TC_Observacion 	Varchar(255),
	@TF_Inicio_Vigencia	DateTime2(3),
	@TF_Fin_Vigencia	DateTime2(3)	= Null
As
Begin
	--Variables.
Declare 
		@L_TC_Descripcion		VarChar(100)	= @TC_Descripcion,
		@L_TC_Observacion		VarChar(255)	= @TC_Observacion,
		@L_TF_Inicio_Vigencia	DateTime2(3)	= @TF_Inicio_Vigencia,
		@L_TF_Fin_Vigencia		DateTime2(3)	= @TF_Fin_Vigencia
	--Lógica.
	Insert Into	Catalogo.TipoArma With(RowLock)
	(
		TC_Descripcion,			TC_Observacion,		TF_Inicio_Vigencia,			TF_Fin_Vigencia
	)
	Values
	(
		@L_TC_Descripcion,		@L_TC_Observacion,		@L_TF_Inicio_Vigencia,		@L_TF_Fin_Vigencia
	)
End
GO
