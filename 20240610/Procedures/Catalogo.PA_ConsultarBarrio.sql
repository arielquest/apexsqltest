SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta>
-- Fecha de creación:		<11/11/2015>
-- Descripción:				<Permitir consultar registros en la tabla de Barrio.> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
--
-- Modificación:			<Andrés Díaz><15/12/2016><Se agrega el campo TG_UbicacionPunto.>
-- Modificación:			<Diego GB><03/05/2017><Se elimina la codicion de que evaluava las llaves de provincia, canton, distrito y codigo>
-- Modificación:			<29/11/2017><Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarBarrio]
	@CodigoProvincia		smallint		= Null,
	@CodigoCanton			smallint		= Null,
	@CodigoDistrito			smallint		= Null,
	@Codigo					smallint		= Null,
	@Descripcion			Varchar(150)	= Null,
	@FechaActivacion		Datetime2		= Null,
	@FechaDesactivacion		Datetime2		= Null
As
Begin
  
   DECLARE @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaDesactivacion Is Null
	Begin
			Select		A.TN_CodBarrio				As	Codigo,
						A.TC_Descripcion			As	Descripcion,
						A.TF_Inicio_Vigencia		As	FechaActivacion,
						A.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Distrito,
						B.TN_CodDistrito			As	Codigo,
						B.TC_Descripcion			As	Descripcion,
						B.TF_Inicio_Vigencia		As	FechaActivacion,
						B.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Canton,
						C.TN_CodCanton				As	Codigo,
						C.TC_Descripcion			As	Descripcion,
						C.TF_Inicio_Vigencia		As	FechaActivacion,
						C.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Provincia,
						D.TN_CodProvincia			As	Codigo,
						D.TC_Descripcion			As	Descripcion,
						D.TF_Inicio_Vigencia		As	FechaActivacion,
						D.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split,
						A.TG_UbicacionPunto.Lat		As	Latitud,
						A.TG_UbicacionPunto.Long	As	Longitud
			From		Catalogo.Barrio				As	A With(Nolock) 	
			Inner Join	Catalogo.Distrito			As	B With(Nolock) 	
			On			B.TN_CodProvincia			=	A.TN_CodProvincia 
			And			B.TN_CodCanton				=	A.TN_CodCanton
			And			B.TN_CodDistrito			=	A.TN_CodDistrito  
			Inner Join	Catalogo.Canton				As	C With(Nolock) 	
			On			C.TN_CodProvincia			=	B.TN_CodProvincia 
			And			C.TN_CodCanton				=	B.TN_CodCanton  
			Inner Join	Catalogo.Provincia			As	D With(Nolock)
			On			D.TN_CodProvincia			=	C.TN_CodProvincia
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)	
			And			A.TN_CodProvincia			= ISNULL(@CodigoProvincia, A.TN_CodProvincia) 
			And			A.TN_CodCanton				= ISNULL(@CodigoCanton, A.TN_CodCanton)  
			And			A.TN_CodDistrito			= ISNULL(@CodigoDistrito, A.TN_CodDistrito)
			And         A.TN_CodBarrio              = ISNULL(@Codigo, A.TN_CodBarrio)
			Order By	A.TC_Descripcion;
	End
	 
		--Por activos
	Else  If  @FechaActivacion Is Not Null And  @FechaDesactivacion Is Null 
	Begin
			Select		A.TN_CodBarrio				As	Codigo,
						A.TC_Descripcion			As	Descripcion,
						A.TF_Inicio_Vigencia		As	FechaActivacion,
						A.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Distrito,
						B.TN_CodDistrito			As	Codigo,
						B.TC_Descripcion			As	Descripcion,
						B.TF_Inicio_Vigencia		As	FechaActivacion,
						B.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Canton,
						C.TN_CodCanton				As	Codigo,
						C.TC_Descripcion			As	Descripcion,
						C.TF_Inicio_Vigencia		As	FechaActivacion,
						C.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Provincia,
						D.TN_CodProvincia			As	Codigo,
						D.TC_Descripcion			As	Descripcion,
						D.TF_Inicio_Vigencia		As	FechaActivacion,
						D.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split,
						A.TG_UbicacionPunto.Lat		As	Latitud,
						A.TG_UbicacionPunto.Long	As	Longitud
			From		Catalogo.Barrio				As	A With(Nolock) 	
			Inner Join	Catalogo.Distrito			As	B With(Nolock) 	
			On			B.TN_CodProvincia			=	A.TN_CodProvincia 
			And			B.TN_CodCanton				=	A.TN_CodCanton
			And			B.TN_CodDistrito			=	A.TN_CodDistrito  
			Inner Join	Catalogo.Canton				As	C With(Nolock) 	
			On			C.TN_CodProvincia			=	B.TN_CodProvincia 
			And			C.TN_CodCanton				=	B.TN_CodCanton  
			Inner Join	Catalogo.Provincia			As	D With(Nolock)
			On			D.TN_CodProvincia			=	C.TN_CodProvincia
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodProvincia			=	ISNULL(@CodigoProvincia, A.TN_CodProvincia) 
			And			A.TN_CodCanton				=	ISNULL(@CodigoCanton, A.TN_CodCanton)  
			And			A.TN_CodDistrito			=	ISNULL(@CodigoDistrito, A.TN_CodDistrito)
			And         A.TN_CodBarrio              =   ISNULL(@Codigo, A.TN_CodBarrio)	
			And			A.TF_Inicio_Vigencia	<=		GETDATE ()
			And			(A.TF_Fin_Vigencia		Is	Null OR A.TF_Fin_Vigencia  >= GETDATE ())
			Order By	A.TC_Descripcion;
	End
	--Por inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		A.TN_CodBarrio				As	Codigo,
						A.TC_Descripcion			As	Descripcion,
						A.TF_Inicio_Vigencia		As	FechaActivacion,
						A.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Distrito,
						B.TN_CodDistrito			As	Codigo,
						B.TC_Descripcion			As	Descripcion,
						B.TF_Inicio_Vigencia		As	FechaActivacion,
						B.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Canton,
						C.TN_CodCanton				As	Codigo,
						C.TC_Descripcion			As	Descripcion,
						C.TF_Inicio_Vigencia		As	FechaActivacion,
						C.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Provincia,
						D.TN_CodProvincia			As	Codigo,
						D.TC_Descripcion			As	Descripcion,
						D.TF_Inicio_Vigencia		As	FechaActivacion,
						D.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split,
						A.TG_UbicacionPunto.Lat		As	Latitud,
						A.TG_UbicacionPunto.Long	As	Longitud
			From		Catalogo.Barrio				As	A With(Nolock) 	
			Inner Join	Catalogo.Distrito			As	B With(Nolock) 	
			On			B.TN_CodProvincia			=	A.TN_CodProvincia 
			And			B.TN_CodCanton				=	A.TN_CodCanton
			And			B.TN_CodDistrito			=	A.TN_CodDistrito  
			Inner Join	Catalogo.Canton				As	C With(Nolock) 	
			On			C.TN_CodProvincia			=	B.TN_CodProvincia 
			And			C.TN_CodCanton				=	B.TN_CodCanton  
			Inner Join	Catalogo.Provincia			As	D With(Nolock)
			On			D.TN_CodProvincia			=	C.TN_CodProvincia
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)	
			And			A.TN_CodProvincia			=	ISNULL(@CodigoProvincia,	A.TN_CodProvincia) 
			And			A.TN_CodCanton				=	ISNULL(@CodigoCanton,		A.TN_CodCanton)  
			And			A.TN_CodDistrito			=	ISNULL(@CodigoDistrito,		A.TN_CodDistrito)
			And         A.TN_CodBarrio              =   ISNULL(@Codigo, A.TN_CodBarrio)	
			And			(A.TF_Inicio_Vigencia >		GETDATE () 
			Or			A.TF_Fin_Vigencia		<		GETDATE ())
			Order By	A.TC_Descripcion;
	End

		--Por rango de Fechas
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		A.TN_CodBarrio				As	Codigo,
						A.TC_Descripcion			As	Descripcion,
						A.TF_Inicio_Vigencia		As	FechaActivacion,
						A.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Distrito,
						B.TN_CodDistrito			As	Codigo,
						B.TC_Descripcion			As	Descripcion,
						B.TF_Inicio_Vigencia		As	FechaActivacion,
						B.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Canton,
						C.TN_CodCanton				As	Codigo,
						C.TC_Descripcion			As	Descripcion,
						C.TF_Inicio_Vigencia		As	FechaActivacion,
						C.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split_Provincia,
						D.TN_CodProvincia			As	Codigo,
						D.TC_Descripcion			As	Descripcion,
						D.TF_Inicio_Vigencia		As	FechaActivacion,
						D.TF_Fin_Vigencia			As	FechaDesactivacion,
						'Split'						As	Split,
						A.TG_UbicacionPunto.Lat		As	Latitud,
						A.TG_UbicacionPunto.Long	As	Longitud
			From		Catalogo.Barrio				As	A With(Nolock) 	
			Inner Join	Catalogo.Distrito			As	B With(Nolock) 	
			On			B.TN_CodProvincia			=	A.TN_CodProvincia 
			And			B.TN_CodCanton				=	A.TN_CodCanton
			And			B.TN_CodDistrito			=	A.TN_CodDistrito  
			Inner Join	Catalogo.Canton				As	C With(Nolock) 	
			On			C.TN_CodProvincia			=	B.TN_CodProvincia 
			And			C.TN_CodCanton				=	B.TN_CodCanton  
			Inner Join	Catalogo.Provincia			As	D With(Nolock)
			On			D.TN_CodProvincia			=	C.TN_CodProvincia
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodProvincia			=	ISNULL(@CodigoProvincia, A.TN_CodProvincia) 
			And			A.TN_CodCanton				=	ISNULL(@CodigoCanton, A.TN_CodCanton)  
			And			A.TN_CodDistrito			=	ISNULL(@CodigoDistrito, A.TN_CodDistrito)	
			And         A.TN_CodBarrio              =   ISNULL(@Codigo, A.TN_CodBarrio)
			And			(A.TF_Inicio_Vigencia	>= @FechaActivacion
			And			A.TF_Fin_Vigencia		<= @FechaDesactivacion)
			Order By	A.TC_Descripcion;
	End
			
End



GO
