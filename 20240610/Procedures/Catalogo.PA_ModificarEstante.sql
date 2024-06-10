SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<13/11/2019>
-- Descripción:			<Permite modificar un registro en la tabla: Estante.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_ModificarEstante]
	@Codigo				SmallInt,
	@Descripcion		VarChar(100),
	@CodSeccion			Smallint,
	@Observacion 		Varchar(255),
	@FechaDesactivacion	DateTime2(3)	= Null
As
Begin
	--Variables.
	Declare	@L_TN_CodEstante		SmallInt		= @Codigo,
			@L_TC_Descripcion		VarChar(100)	= @Descripcion,
			@L_TN_CodSeccion		Smallint		= @CodSeccion,
			@L_TC_Observacion		VarChar(255)	= @Observacion,
			@L_TF_Fin_Vigencia		DateTime2(3)	= @FechaDesactivacion
	--Lógica.
	Update	Catalogo.Estante		With(RowLock)
	Set		TC_Descripcion			= @L_TC_Descripcion,
			TN_CodSeccion			= @L_TN_CodSeccion,
			TC_Observacion			= @L_TC_Observacion,
			TF_Fin_Vigencia			= @L_TF_Fin_Vigencia
	Where	TN_CodEstante			= @L_TN_CodEstante
End
GO
