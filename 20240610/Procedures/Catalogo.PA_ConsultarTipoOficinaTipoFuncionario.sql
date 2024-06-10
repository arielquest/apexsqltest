SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvare Espinoza>
-- Fecha de creación:		<21/12/2015>
-- Descripción :			<Permite Consultar las TipoFuncionarios de un TipoOficina
--
-- Modificación:			<04/01/2018> <Andrés Díaz> <Se simplifica el PA a una sola consulta. Se tabula el PA.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoOficinaTipoFuncionario]
    @CodTipoOficina	    smallint= Null,
	@CodTipoFuncionario smallint= Null,
	@FechaAsociacion	Datetime2= Null 
As
Begin

		SELECT		B.TN_CodTipoFuncionario					AS	Codigo, 
					B.TC_Descripcion						AS	Descripcion, 
					B.TF_Inicio_Vigencia					AS	FechaActivacion, 
					B.TF_Fin_Vigencia						AS	FechaDesactivacion,
					A.TF_Inicio_Vigencia					AS	FechaAsociacion,
					'Split'									AS	Split,
					C.TN_CodTipoOficina						AS	Codigo, 
					C.TC_Descripcion						AS	Descripcion, 
					C.TF_Inicio_Vigencia					AS	FechaActivacion, 
					C.TF_Fin_Vigencia						AS	FechaDesactivacion

		FROM		Catalogo.TipoOficinaTipoFuncionario		AS	A WITH (Nolock) 
		INNER JOIN	Catalogo.TipoFuncionario				AS	B WITH (Nolock)
		ON			B.TN_CodTipoFuncionario					=	A.TN_CodTipoFuncionario
		INNER JOIN	Catalogo.TipoOficina					AS	C WITH (Nolock)
		ON			C.TN_CodTipoOficina						=	A.TN_CodTipoOficina

		WHERE		(A.TN_CodTipoOficina					=	@CodTipoOficina
		Or			A.TN_CodTipoFuncionario					=	@CodTipoFuncionario)
		And			A.TF_Inicio_Vigencia					<=	CASE WHEN @FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
		Order By	B.TC_Descripcion, C.TC_Descripcion;

End
GO
