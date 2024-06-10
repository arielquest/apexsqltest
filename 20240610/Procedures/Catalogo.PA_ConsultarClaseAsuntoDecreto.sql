SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<22/11/2018>
-- Descripción :			<Permite consultar las clases de asunto por decreto> 
-- =================================================================================================================================================
-- Modificacion:			<05/07/2019> <Isaac Dobles> <Se modifica para adaptar a la nueva estructura de expediente> 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarClaseAsuntoDecreto]
	@Codigo				varchar(15)	=	Null,
	@CodClase			int			=	Null,
	@CodTipoOficina		int			=	Null,
	@CodMateria			varchar(5)	=	Null
 As
 Begin
  
			Select		A.TC_CodigoDecreto				As	Codigo,
						A.TF_FechaAsociacion			As  FechaAsociacion,
						A.TN_MontoInicial				As	MontoInicial,
						A.TN_MontoFinal					As	MontoFinal,	
						A.TN_Porcentaje					As	Porcentaje,	
						'Split'							As	SplitClaseTipoOficina,							
						E.TN_CodClase					As  Codigo,
						E.TC_Descripcion				As	Descripcion,
						'Split'							As	SplitTipoOficinaMateria,							
						D.TN_CodTipoOficina				As  Codigo,
						D.TC_Descripcion				As	Descripcion,
						'Split'							As	SplitMateria,							
						F.TC_CodMateria					As  Codigo,
						F.TC_Descripcion				As	Descripcion,
						'Split'							As	SplitOtros,
						C.TB_CostasPersonales			As	CostasPersonales
			From		Catalogo.ClaseAsuntoDecreto		As	A	With(Nolock) 	
			Inner Join	Catalogo.Decreto				As	B	With(Nolock) 	
			On			B.TC_CodigoDecreto				=	A.TC_CodigoDecreto
			Inner Join	Catalogo.ClaseTipoOficina		As	C	With(Nolock) 	
			On			C.TN_CodClase					=	A.TN_CodClase	
			And			C.TN_CodTipoOficina				=	A.TN_CodTipoOficina	
			And			C.TC_CodMateria					=	A.TC_CodMateria
			Inner Join	Catalogo.TipoOficina			As	D	With(Nolock) 	
			On			D.TN_CodTipoOficina				= 	A.TN_CodTipoOficina	
			And			D.TN_CodTipoOficina				=	C.TN_CodTipoOficina
			Inner Join	Catalogo.Clase					As	E	With(Nolock) 	
			On			E.TN_CodClase					= 	A.TN_CodClase	
			And			E.TN_CodClase					=	C.TN_CodClase
			Inner Join	Catalogo.Materia				As	F	With(Nolock) 	
			On			F.TC_CodMateria					= 	A.TC_CodMateria		
			And			F.TC_CodMateria					=	C.TC_CodMateria
			Where		A.TC_CodigoDecreto				=	Coalesce(@Codigo, A.TC_CodigoDecreto) 
			And			A.TN_CodClase					=	Coalesce(@CodClase, A.TN_CodClase) 
			And			A.TC_CodMateria					=	Coalesce(@CodMateria, A.TC_CodMateria) 
			And			A.TN_CodTipoOficina				=	Coalesce(@CodTipoOficina, A.TN_CodTipoOficina) 
			Order By	A.TF_FechaAsociacion
 End
GO
