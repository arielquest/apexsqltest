SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==================================================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Ronny Ramírez Rojas>
-- Fecha de creación:	<08/11/2019>
-- Descripción:			<Permite agregar un registro en la tabla: Seccion.>
-- ==================================================================================================================================================================================
CREATE Procedure [Catalogo].[PA_AgregarSeccion]
	@Descripcion		VarChar(100),
	@CodOficina			Varchar(4),
	@CodBodega			Smallint,
	@Observacion 		Varchar(255),
	@FechaActivacion	DateTime2(3),
	@FechaDesactivacion	DateTime2(3)	= Null
As
Begin
	--Variables.
Declare @L_TC_Descripcion		VarChar(100)	= @Descripcion,
		@L_TC_CodOficina		Varchar(4)		= @CodOficina,
		@L_TN_CodBodega			Smallint		= @CodBodega,
		@L_TC_Observacion		VarChar(255)	= @Observacion,
		@L_TF_Inicio_Vigencia	DateTime2(3)	= @FechaActivacion,
		@L_TF_Fin_Vigencia		DateTime2(3)	= @FechaDesactivacion
	--Lógica.
	Insert Into	Catalogo.Seccion With(RowLock)
	(
		TC_Descripcion,			TC_CodOficina,		TN_CodBodega, 		TC_Observacion,		
		TF_Inicio_Vigencia,		TF_Fin_Vigencia
	)
	Values
	(
		@L_TC_Descripcion,		@L_TC_CodOficina,	@L_TN_CodBodega,	@L_TC_Observacion,	
		@L_TF_Inicio_Vigencia,	@L_TF_Fin_Vigencia
	)
End
GO
