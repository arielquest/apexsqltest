SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvare Espinoza>
-- Fecha de creación:		<4/09/2015>
-- Descripción :			<Permite Consultar las TipoViabilidad de una TipoOficina
--
-- Modificación:			<11/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
--
-- Modificación:			<04/01/2018> <Andrés Díaz> <Se simplifica el PA a una sola consulta. Se tabula el PA.>
-- =================================================================================================================================================
 
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoOficinaTipoViabilidad]
    @CodTipoOficina		smallint	= Null,
	@CodTipoViabilidad	smallint	= Null,
	@FechaAsociacion	Datetime2	= Null
As
Begin

		SELECT		A.TF_Inicio_Vigencia					AS	FechaAsociacion, 				
	   				B.TN_CodTipoViabilidad					AS	Codigo, 
					B.TC_Descripcion						AS	Descripcion, 
					B.TF_Inicio_Vigencia					AS	FechaActivacion, 
					B.TF_Fin_Vigencia						AS	FechaDesactivacion,
					'Split_TipoOficina'						AS	Split_TipoOficina, 
					C.TN_CodTipoOficina						AS	Codigo, 
					C.TC_Descripcion						AS	Descripcion, 
					C.TF_Inicio_Vigencia					AS	FechaActivacion, 
					C.TF_Fin_Vigencia						AS	FechaDesactivacion
		FROM		Catalogo.TipoOficinaTipoViabilidad		AS	A WITH (Nolock) 
		INNER JOIN	Catalogo.TipoViabilidad					AS	B WITH (Nolock)
		ON			B.TN_CodTipoViabilidad					=	A.TN_CodTipoViabilidad 
		INNER JOIN	Catalogo.TipoOficina					AS	C WITH (Nolock)
		ON			C.TN_CodTipoOficina						=	A.TN_CodTipoOficina
		WHERE		(A.TN_CodTipoOficina					=	@CodTipoOficina
		Or			A.TN_CodTipoViabilidad					=	@CodTipoViabilidad) 
		And			A.TF_Inicio_Vigencia					<=	CASE WHEN @FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
		Order By	B.TC_Descripcion, C.TC_Descripcion;

End
GO
