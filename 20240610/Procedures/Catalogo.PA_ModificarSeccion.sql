SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<11/11/2019>
-- Descripción:			<Permite modificar un registro en la tabla: Seccion.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_ModificarSeccion]
	@Codigo				SmallInt,
	@Descripcion		VarChar(100),
	@CodOficina			Varchar(4),
	@CodBodega			Smallint,
	@Observacion 		Varchar(255),
	@FechaDesactivacion	DateTime2(3)	= Null
As
Begin
	--Variables.
	Declare	@L_TN_CodSeccion		SmallInt		= @Codigo,
			@L_TC_Descripcion		VarChar(100)	= @Descripcion,
			@L_TC_CodOficina		Varchar(4)		= @CodOficina,
			@L_TN_CodBodega			Smallint		= @CodBodega,
			@L_TC_Observacion		VarChar(255)	= @Observacion,
			@L_TF_Fin_Vigencia		DateTime2(3)	= @FechaDesactivacion
	--Lógica.
	Update	Catalogo.Seccion		With(RowLock)
	Set		TC_Descripcion			= @L_TC_Descripcion,
			TC_CodOficina			= @L_TC_CodOficina,		
			TN_CodBodega			= @L_TN_CodBodega,
			TC_Observacion			= @L_TC_Observacion,
			TF_Fin_Vigencia			= @L_TF_Fin_Vigencia
	Where	TN_CodSeccion			= @L_TN_CodSeccion
End
GO
