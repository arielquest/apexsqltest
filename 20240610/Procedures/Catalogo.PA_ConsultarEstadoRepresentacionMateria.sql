SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aída E Siles>
-- Fecha de creación:		<11/02/2019>
-- Descripción :			<Permite consultar las materias asociadas a un estado de representación.
-- Modificación:			<Aida E Siles> <10/10/2019> <Se agrega parámetros circulante y circulante pasivo>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoRepresentacionMateria]
	@CodEstadoRepresentacion	smallint		= NULL,
	@CodMateria					varchar(5)		= NULL,	
	@InicioVigencia				datetime2(7)	= NULL,
	@IniciaTramitacion			bit				= NULL,
	@Circulante					char(1)			= NULL,
	@Pasivo						char(1)			= NULL
 As
 Begin
	Select		A.TB_IniciaTramitacion					As	IniciaTramitacion,
				A.TF_Inicio_Vigencia					As	FechaAsociacion,
				C.TC_CodMateria							As	Codigo,				
				C.TB_EjecutaRemate						As	EjecutaRemate,
				C.TF_Inicio_Vigencia					As	FechaActivacion,	
				C.TF_Fin_Vigencia						As	FechaDesactivacion,
				'Split'									As	Split,
				B.TN_CodEstadoRepresentacion			As	Codigo,
				B.TC_Descripcion						As	Descripcion,				
				B.TF_Inicio_Vigencia					As	FechaActivacion,
				B.TF_Fin_Vigencia						As	FechaDesactivacion,				
				'Split'									As	Split,
				B.TC_Circulante							As	Circulante,
				B.TC_Pasivo								As	CirculantePasivo,
				C.TC_Descripcion						As	MateriaDescrip	
	From		Catalogo.EstadoRepresentacionMateria	As	A WITH (Nolock)
	Inner Join	Catalogo.EstadoRepresentacion			As	B WITH (Nolock)
	On			A.TN_CodEstadoRepresentacion			=	B.TN_CodEstadoRepresentacion
	Inner Join	Catalogo.Materia						As	C WITH (Nolock)
	On			A.TC_CodMateria							=	C.TC_CodMateria
	Where		A.TN_CodEstadoRepresentacion			= COALESCE(@CodEstadoRepresentacion, A.TN_CodEstadoRepresentacion)
	And			A.TC_CodMateria							= COALESCE(@CodMateria, A.TC_CodMateria)
	And			A.TB_IniciaTramitacion					= COALESCE(@IniciaTramitacion, A.TB_IniciaTramitacion)
	And			A.TF_Inicio_Vigencia					<=	CASE WHEN @InicioVigencia IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END	
	And			B.TC_Circulante							= COALESCE(@Circulante, B.TC_Circulante)
	And			COALESCE(B.TC_Pasivo,'')				= COALESCE(@Pasivo, B.TC_Pasivo,'')
	Order By	B.TC_Descripcion, C.TC_Descripcion;
End
GO
