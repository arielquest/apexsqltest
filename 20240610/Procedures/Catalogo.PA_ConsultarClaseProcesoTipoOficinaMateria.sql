SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jose Miguel Avendaño Rosales>
-- Fecha de creación:		<19/04/2021>
-- Descripción :			<Permite consultar los procesos asociados a clase, tipo oficina y materia> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarClaseProcesoTipoOficinaMateria]
	@Codigo				smallint	=	Null,
	@CodClase			int			=	Null,
	@CodTipoOficina		int			=	Null,
	@CodMateria			varchar(5)	=	Null
 As
 Begin
	Select		A.TN_CodProceso							As	Codigo,
				B.TC_Descripcion						As	Descripcion,
				B.TF_Inicio_Vigencia					As	FechaActivacion,
				B.TF_Fin_Vigencia						As	FechaDesactivacion,
				A.TF_Inicio_Vigencia					As  FechaAsociacion,
				'Split'									As	SplitClaseTipoOficina,							
				E.TN_CodClase							As  Codigo,
				E.TC_Descripcion						As	Descripcion,
				'Split'									As	SplitTipoOficinaMateria,							
				D.TN_CodTipoOficina						As  Codigo,
				D.TC_Descripcion						As	Descripcion,
				'Split'									As	SplitMateria,							
				F.TC_CodMateria							As  Codigo,
				F.TC_Descripcion						As	Descripcion,
				'Split'									As	SplitFase,
				G.TN_CodFase							As	Codigo,
				G.TC_Descripcion						As	Descripcion
	From		Catalogo.ClaseProcesoTipoOficinaMateria	As	A	With(Nolock) 	
	Inner Join	Catalogo.Proceso						As	B	With(Nolock) 	
	On			B.TN_CodProceso							=	A.TN_CodProceso
	Inner Join	Catalogo.ClaseTipoOficina				As	C	With(Nolock) 	
	On			C.TN_CodClase							=	A.TN_CodClase	
	And			C.TN_CodTipoOficina						=	A.TN_CodTipoOficina	
	And			C.TC_CodMateria							=	A.TC_CodMateria
	Inner Join	Catalogo.TipoOficina					As	D	With(Nolock) 	
	On			D.TN_CodTipoOficina						= 	A.TN_CodTipoOficina	
	And			D.TN_CodTipoOficina						=	C.TN_CodTipoOficina
	Inner Join	Catalogo.Clase							As	E	With(Nolock) 	
	On			E.TN_CodClase							= 	A.TN_CodClase	
	And			E.TN_CodClase							=	C.TN_CodClase
	Inner Join	Catalogo.Materia						As	F	With(Nolock) 	
	On			F.TC_CodMateria							= 	A.TC_CodMateria		
	And			F.TC_CodMateria							=	C.TC_CodMateria
	Inner Join	Catalogo.Fase							As	G	With(Nolock)
	On			G.TN_CodFase							=	A.TN_CodFase
	Where		A.TN_CodProceso							=	Coalesce(@Codigo, A.TN_CodProceso) 
	And			A.TN_CodClase							=	Coalesce(@CodClase, A.TN_CodClase) 
	And			A.TC_CodMateria							=	Coalesce(@CodMateria, A.TC_CodMateria) 
	And			A.TN_CodTipoOficina						=	Coalesce(@CodTipoOficina, A.TN_CodTipoOficina) 
	Order By	B.TC_Descripcion
 End
GO
