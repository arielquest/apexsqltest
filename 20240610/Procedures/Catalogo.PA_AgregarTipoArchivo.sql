SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ========================================================================================================
-- Autor:				<Esteban Cordero Benavides.>
-- Fecha Creación:		<15 de abril de 2016.>
-- Descripcion:			<Permite agregar un tipo de archivo al catálogo.>
-- ========================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE Procedure [Catalogo].[PA_AgregarTipoArchivo]
	@TC_Descripcion		VarChar(100),
	@TC_CodMateria		VarChar(5),
	@TC_CodPrioridad	SmallInt,
	@TF_Inicio_Vigencia	DateTime2(3),
	@TF_Fin_Vigencia	DateTime2(3)
As
Begin
	Insert Into	Catalogo.TipoArchivo
	(
		TC_Descripcion,		TC_CodMateria,	TN_CodPrioridad,	TF_Inicio_Vigencia,
		TF_Fin_Vigencia
	)
	Values
	(
		@TC_Descripcion,	@TC_CodMateria,	@TC_CodPrioridad,	@TF_Inicio_Vigencia,
		@TF_Fin_Vigencia
	);
End;
GO
