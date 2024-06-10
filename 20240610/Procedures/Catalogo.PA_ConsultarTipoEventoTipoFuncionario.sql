SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<23/12/2016>
-- Descripción :			<Permite consultar registros de Catalogo.TipoEventoTipoFuncionario.>
--
-- Modificación:			<04/01/2018> <Andrés Díaz> <Se simplifica el PA a una sola consulta. Se tabula el PA.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoEventoTipoFuncionario]
	@CodTipoEvento		smallint	= Null,
	@CodTipoFuncionario	smallint	= Null,
	@FechaAsociacion	datetime2	= Null
As
Begin

		Select		B.TN_CodTipoFuncionario  		   As	Codigo, 
					B.TC_Descripcion				   As	Descripcion, 
					B.TF_Inicio_Vigencia			   As	FechaActivacion, 
					B.TF_Fin_Vigencia				   As	FechaDesactivacion,
					A.TF_Inicio_Vigencia			   As	FechaAsociacion, 
					'Split'							   As	Split, 
					C.TN_CodTipoEvento				   As	Codigo, 
					C.TC_Descripcion				   As	Descripcion, 
					C.TF_Inicio_Vigencia			   As	FechaActivacion, 
					C.TF_Fin_Vigencia				   As	FechaDesactivacion
		From		Catalogo.TipoEventoTipoFuncionario As	A With(NoLock)
		Inner Join	Catalogo.TipoFuncionario           As	B With(NoLock)
		On			B.TN_CodTipoFuncionario		   	   =	A.TN_CodTipoFuncionario
		Inner Join	Catalogo.TipoEvento				   As	C With(NoLock)
		On			C.TN_CodTipoEvento				   =	A.TN_CodTipoEvento
		Where		(A.TN_CodTipoEvento				   =	@CodTipoEvento	
		Or			A.TN_CodTipoFuncionario		       =	@CodTipoFuncionario)
		And			A.TF_Inicio_Vigencia			   <=	CASE WHEN @FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
		Order By	B.TC_Descripcion, C.TC_Descripcion;

End
GO
