SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<10/09/2015>
-- Descripción :			<Permite Consultar los Ubicaciones de la tabla Catalogo.Ubicacion> 
-- Modificado por:			<Pablo Alvarez>
-- Fecha de creación:		<23/10/2015>
-- Descripción :			<Se incluyen filtros por fecha de activación.> 
--
-- Modificación:			<11/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<02/12/2016> <Donald Vargas> <Se corrige el nombre del campo TC_CodUbicacion a TN_CodUbicacion de acuerdo al tipo de dato.>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- Modificación:			<23/11/2020> <Fabian Sequeira> <Se agrega provincia, circuito y oficna >
-- Modificación:			<10/02/2023> <Josué Quirós Batista> <Actualización del tipo de dato del campo CodUbicacion.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarUbicacion]
	@Codigo					INT=Null,
	@Descripcion			Varchar(150)=Null,
	@FechaActivacion		datetime2=Null,
	@FechaDesactivacion		datetime2= Null,
	@CodigoProvincia		smallint=Null,
	@CodigoCircuito			smallint=Null,
	@CodigoOficina			Varchar(4)=Null
 As
 Begin
  
   DECLARE	@ExpresionLike		varchar(152)
	Set		@ExpresionLike =	iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

--Variables 
	DECLARE	@L_Codigo					INT					= @Codigo
    DECLARE	@L_Descripcion				Varchar(150)		= @Descripcion
	DECLARE	@L_FechaActivacion			datetime2			= @FechaActivacion
	DECLARE	@L_FechaDesactivacion		datetime2			= @FechaDesactivacion
	DECLARE	@L_CodigoProvincia			smallint			= @CodigoProvincia
	DECLARE	@L_CodigoCircuito			smallint			= @CodigoCircuito
	DECLARE	@L_CodigoOficina			Varchar(4)			= @CodigoOficina

	--Todos
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null  
	Begin
Select		A.TN_CodUbicacion      	As	Codigo,				
			A.TC_Descripcion		As	Descripcion,		
			A.TF_Inicio_Vigencia	As	FechaActivacion,	
			A.TF_Fin_Vigencia		As	FechaDesactivacion,
			'Split'					As	Split,
			B.TC_CodOficina       	As	CodigoOficina,				
			B.TC_Nombre				As	DescripcionOficina,		
			C.TN_CodCircuito		As	CodigoCircuito,				
			C.TC_Descripcion		As	DescripcionCircuito,		
			D.TN_CodProvincia		As	CodigoProvincia,				
			D.TC_Descripcion		As	DescripcionProvincia		
			From					Catalogo.Ubicacion		As	A With(Nolock)
			Inner Join				Catalogo.Oficina		As	B With(Nolock)
			ON						A.TC_CodOficina			=B.TC_CodOficina
			Inner Join				Catalogo.Circuito		As	C With(Nolock) 	
			On						B.TN_CodCircuito		= C.TN_CodCircuito
			Inner Join				Catalogo.Provincia		As	D With(Nolock) 	
			On						C.TN_CodProvincia		= D.TN_CodProvincia
			Where					dbo.FN_RemoverTildes	(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND						A.TN_CodUbicacion		=COALESCE(@L_Codigo,TN_CodUbicacion) 
			--AND						dbo.FN_RemoverTildes	(B.TC_Nombre) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND						B.TC_CodOficina			=COALESCE(@L_CodigoOficina,B.TC_CodOficina) 
			--AND						dbo.FN_RemoverTildes	(C.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND						C.TN_CodCircuito		=COALESCE(@L_CodigoCircuito,C.TN_CodCircuito) 
			--AND						dbo.FN_RemoverTildes	(D.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND						D.TN_CodProvincia		=COALESCE(@L_CodigoProvincia,D.TN_CodProvincia) 
			Order By				A.TC_Descripcion;
	End


	--Por activos y filtro por descripcion
	Else If  @L_FechaActivacion Is Not Null And @L_FechaDesactivacion Is Null   --and @L_CodigoProvincia Is Null And @L_CodigoCircuito Is Null and @L_CodigoOficina Is Null and @L_Codigo is null
	Begin
	Select	A.TN_CodUbicacion      	As	Codigo,				
			A.TC_Descripcion		As	Descripcion,		
			A.TF_Inicio_Vigencia	As	FechaActivacion,	
			A.TF_Fin_Vigencia		As	FechaDesactivacion,
			'Split'					As	Split,
			B.TC_CodOficina       	As	CodigoOficina,				
			B.TC_Nombre				As	DescripcionOficina,		
			C.TN_CodCircuito		As	CodigoCircuito,				
			C.TC_Descripcion		As	DescripcionCircuito,		
			D.TN_CodProvincia		As	CodigoProvincia,				
			D.TC_Descripcion		As	DescripcionProvincia		
			From					Catalogo.Ubicacion						As	A With(Nolock)
			Inner Join				Catalogo.Oficina						As	B With(Nolock)
			ON						A.TC_CodOficina							=	B.TC_CodOficina
			Inner Join				Catalogo.Circuito						As	C With(Nolock) 	
			On						B.TN_CodCircuito						= C.TN_CodCircuito
			Inner Join				Catalogo.Provincia						As	D With(Nolock) 	
			On						C.TN_CodProvincia						= D.TN_CodProvincia
			Where					dbo.FN_RemoverTildes					(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And						A.TF_Inicio_Vigencia				< GETDATE ()
			And						(A.TF_Fin_Vigencia Is Null OR			A.TF_Fin_Vigencia  >= GETDATE ())
			AND						A.TN_CodUbicacion		=COALESCE(@L_Codigo,TN_CodUbicacion) 
			AND						B.TC_CodOficina			=COALESCE(@L_CodigoOficina,B.TC_CodOficina) 
			AND						C.TN_CodCircuito		=COALESCE(@L_CodigoCircuito,C.TN_CodCircuito) 
			AND						D.TN_CodProvincia		=COALESCE(@L_CodigoProvincia,D.TN_CodProvincia) 
			Order By				A.TC_Descripcion;
	End
	
	--Por inactivos y filtro por descripcion
	Else IF @L_FechaActivacion Is Null And @L_FechaDesactivacion Is Not Null --And @L_Descripcion is not null and @L_CodigoProvincia Is Null And @L_CodigoCircuito Is Null and @L_CodigoOficina Is Null	and @L_Codigo is null
	Begin
	Select	A.TN_CodUbicacion      	As	Codigo,				
			A.TC_Descripcion		As	Descripcion,		
			A.TF_Inicio_Vigencia	As	FechaActivacion,	
			A.TF_Fin_Vigencia		As	FechaDesactivacion,
			'Split'					As	Split,
			B.TC_CodOficina       	As	CodigoOficina,				
			B.TC_Nombre				As	DescripcionOficina,		
			C.TN_CodCircuito		As	CodigoCircuito,				
			C.TC_Descripcion		As	DescripcionCircuito,		
			D.TN_CodProvincia		As	CodigoProvincia,				
			D.TC_Descripcion		As	DescripcionProvincia		
			From					Catalogo.Ubicacion		As	A With(Nolock)
			Inner Join				Catalogo.Oficina		As	B With(Nolock)
			ON						A.TC_CodOficina			=	B.TC_CodOficina
			Inner Join				Catalogo.Circuito		As	C With(Nolock) 	
			On						B.TN_CodCircuito		= C.TN_CodCircuito
			Inner Join				Catalogo.Provincia		As	D With(Nolock) 	
			On						C.TN_CodProvincia		= D.TN_CodProvincia
			Where					dbo.FN_RemoverTildes	(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
	        And					(A.TF_Inicio_Vigencia	> GETDATE () Or A.TF_Fin_Vigencia  < GETDATE ())
			AND						A.TN_CodUbicacion		=COALESCE(@L_Codigo,TN_CodUbicacion) 
			AND						B.TC_CodOficina			=COALESCE(@L_CodigoOficina,B.TC_CodOficina) 
			AND						C.TN_CodCircuito		=COALESCE(@L_CodigoCircuito,C.TN_CodCircuito) 
			AND						D.TN_CodProvincia		=COALESCE(@L_CodigoProvincia,D.TN_CodProvincia) 
			Order By				A.TC_Descripcion;
	End


	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	ELSE IF @L_FechaActivacion Is Not Null And @L_FechaDesactivacion Is Not Null and @L_Codigo is null		
		Begin
	Select	A.TN_CodUbicacion      	As	Codigo,				
			A.TC_Descripcion		As	Descripcion,		
			A.TF_Inicio_Vigencia	As	FechaActivacion,	
			A.TF_Fin_Vigencia		As	FechaDesactivacion,
			'Split'					As	Split,
			B.TC_CodOficina       	As	CodigoOficina,				
			B.TC_Nombre				As	DescripcionOficina,		
			C.TN_CodCircuito		As	CodigoCircuito,				
			C.TC_Descripcion		As	DescripcionCircuito,		
			D.TN_CodProvincia		As	CodigoProvincia,				
			D.TC_Descripcion		As	DescripcionProvincia		
			From					Catalogo.Ubicacion		As	A With(Nolock)
			Inner Join				Catalogo.Oficina		As	B With(Nolock)
			ON						A.TC_CodOficina =		B.TC_CodOficina
			Inner Join				Catalogo.Circuito		As	C With(Nolock) 	
			On						B.TN_CodCircuito		= C.TN_CodCircuito
			Inner Join				Catalogo.Provincia		As	D With(Nolock) 	
			On						C.TN_CodProvincia		= D.TN_CodProvincia
			Where					dbo.FN_RemoverTildes	(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		    AND						(A.TF_Fin_Vigencia		<= @L_FechaDesactivacion and A.TF_Inicio_Vigencia >=@L_FechaActivacion)
			AND						TN_CodUbicacion			=COALESCE(@L_Codigo,TN_CodUbicacion) 
			Order By				A.TC_Descripcion;
	End

	--Inactivos
	If  @FechaDesactivacion Is Not Null And @FechaActivacion Is Null and @L_Codigo is null
	Begin
Select		A.TN_CodUbicacion      	As	Codigo,				
			A.TC_Descripcion		As	Descripcion,		
			A.TF_Inicio_Vigencia	As	FechaActivacion,	
			A.TF_Fin_Vigencia		As	FechaDesactivacion,
			'Split'					As	Split,
			B.TC_CodOficina       	As	CodigoOficina,				
			B.TC_Nombre				As	DescripcionOficina,		
			C.TN_CodCircuito		As	CodigoCircuito,				
			C.TC_Descripcion		As	DescripcionCircuito,		
			D.TN_CodProvincia		As	CodigoProvincia,				
			D.TC_Descripcion		As	DescripcionProvincia		
			From					Catalogo.Ubicacion		As	A With(Nolock)
			Inner Join				Catalogo.Oficina		As	B With(Nolock)
			ON						A.TC_CodOficina			=B.TC_CodOficina
			Inner Join				Catalogo.Circuito		As	C With(Nolock) 	
			On						B.TN_CodCircuito		= C.TN_CodCircuito
			Inner Join				Catalogo.Provincia		As	D With(Nolock) 	
			On						C.TN_CodProvincia		= D.TN_CodProvincia
			Where					dbo.FN_RemoverTildes	(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND						A.TN_CodUbicacion		=COALESCE(@L_Codigo,TN_CodUbicacion) 
			AND						dbo.FN_RemoverTildes	(B.TC_Nombre) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND						B.TC_CodOficina			=COALESCE(@L_CodigoOficina,B.TC_CodOficina) 
			AND						dbo.FN_RemoverTildes	(C.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND						C.TN_CodCircuito		=COALESCE(@L_CodigoCircuito,C.TN_CodCircuito) 
			AND						dbo.FN_RemoverTildes	(D.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND						D.TN_CodProvincia		=COALESCE(@L_CodigoProvincia,D.TN_CodProvincia) 
			Order By				A.TC_Descripcion;
	End

			
 End

GO
