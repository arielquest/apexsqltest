SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aída E Siles>
-- Fecha de creación:		<28/01/2019>
-- Descripción :			<Permite consultar las materias asociadas a un tipo de caso.
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoCasoMateria]
	@CodTipoCaso		smallint		= NULL,
	@CodMateria			varchar(5)		= NULL,
	@InicioVigencia		datetime2(7)	= NULL
 As
 Begin
	Select		C.TC_CodMateria				As	Codigo,
				C.TC_Descripcion			As	Descripcion,
				C.TB_EjecutaRemate			As	EjecutaRemate,
				C.TF_Inicio_Vigencia		As	FechaActivacion,	
				C.TF_Fin_Vigencia			As	FechaDesactivacion,
				A.TF_Inicio_Vigencia		As	FechaAsociacion,
				'Split'						As	Split,
				B.TN_CodTipoCaso			As	Codigo,
				B.TC_Descripcion			As	Descripcion,
				B.TF_Inicio_Vigencia		As	FechaActivacion,
				B.TF_Fin_Vigencia			As	FechaDesactivacion


	From		Catalogo.TipoCasoMateria	As	A WITH (Nolock)
	Inner Join	Catalogo.TipoCaso			As	B WITH (Nolock)
	On			A.TN_CodTipoCaso			=	B.TN_CodTipoCaso
	Inner Join	Catalogo.Materia			As	C WITH (Nolock)
	On			A.TC_CodMateria				=	C.TC_CodMateria

	Where		A.TN_CodTipoCaso			=	COALESCE(@CodTipoCaso, A.TN_CodTipoCaso)
	And			A.TC_CodMateria				=	COALESCE(@CodMateria, A.TC_CodMateria)
	And			A.TF_Inicio_Vigencia		<=	CASE WHEN @InicioVigencia IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
	Order By	B.TC_Descripcion, C.TC_Descripcion;
	
End
GO
