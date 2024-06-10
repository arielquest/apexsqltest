SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<18/11/2019>
-- Descripción:			<Permite agregar un registro en la tabla: Compartimiento.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_AgregarCompartimiento]
	@Descripcion		VarChar(100),
	@CodEstante			Smallint,
	@Observacion 		Varchar(255),
	@FechaActivacion	DateTime2(3),
	@FechaDesactivacion	DateTime2(3)	= Null
As
Begin
	--Variables.
Declare @L_TC_Descripcion		VarChar(100)	= @Descripcion,
		@L_TN_CodEstante		Smallint		= @CodEstante,
		@L_TC_Observacion		VarChar(255)	= @Observacion,
		@L_TF_Inicio_Vigencia	DateTime2(3)	= @FechaActivacion,
		@L_TF_Fin_Vigencia		DateTime2(3)	= @FechaDesactivacion
	--Lógica.
	Insert Into	Catalogo.Compartimiento With(RowLock)
	(
		TC_Descripcion,			TN_CodEstante, 		TC_Observacion,		TF_Inicio_Vigencia,		
		TF_Fin_Vigencia
	)
	Values
	(
		@L_TC_Descripcion,		@L_TN_CodEstante,	@L_TC_Observacion,	@L_TF_Inicio_Vigencia,	
		@L_TF_Fin_Vigencia
	)
End
GO
