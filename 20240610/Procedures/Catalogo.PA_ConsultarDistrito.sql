SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
--
-- Modificación:			<Andrés Díaz><15/12/2016><Se agrega el campo TG_UbicacionPunto.>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarDistrito]
	@CodigoProvincia smallint=Null,
	@CodigoCanton smallint=Null,
	@CodigoDistrito smallint=Null,
	@Descripcion Varchar(150)=Null,
	@FechaActivacion Datetime2= Null,
	@FechaDesactivacion Datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		A.TN_CodDistrito			As Codigo,				
						A.TC_Descripcion			As Descripcion,		
						A.TF_Inicio_Vigencia		As FechaActivacion,
						A.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split_Canton,
						B.TN_CodCanton				As Codigo,
						B.TC_Descripcion			As Descripcion,		
						B.TF_Inicio_Vigencia		As FechaActivacion,
						B.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split_Provincia,
						C.TN_CodProvincia			As Codigo,
						C.TC_Descripcion			As Descripcion,		
						C.TF_Inicio_Vigencia		As FechaActivacion,
						C.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split,
						A.TG_UbicacionPunto.Lat		As Latitud,
						A.TG_UbicacionPunto.Long	As Longitud
			From		Catalogo.Distrito			As A With(Nolock) 	
			Inner Join	Catalogo.Canton				As B With(Nolock) 	
			On			B.TN_CodProvincia			= A.TN_CodProvincia
			And			B.TN_CodCanton				= A.TN_CodCanton  
			Inner Join	Catalogo.Provincia			As C With(Nolock) 	
			On			C.TN_CodProvincia			= B.TN_CodProvincia 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodProvincia			= IsNull(@CodigoProvincia, A.TN_CodProvincia)
			And			A.TN_CodCanton				= IsNull(@CodigoCanton, A.TN_CodCanton)
			And			A.TN_CodDistrito			= IsNull(@CodigoDistrito, A.TN_CodDistrito)
			Order By	A.TC_Descripcion;
	End	
		--Por activos
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		A.TN_CodDistrito			As Codigo,				
						A.TC_Descripcion			As Descripcion,		
						A.TF_Inicio_Vigencia		As FechaActivacion,
						A.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split_Canton,
						B.TN_CodCanton				As Codigo,
						B.TC_Descripcion			As Descripcion,		
						B.TF_Inicio_Vigencia		As FechaActivacion,
						B.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split_Provincia,
						C.TN_CodProvincia			As Codigo,
						C.TC_Descripcion			As Descripcion,		
						C.TF_Inicio_Vigencia		As FechaActivacion,
						C.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split,
						A.TG_UbicacionPunto.Lat		As Latitud,
						A.TG_UbicacionPunto.Long	As Longitud
			From		Catalogo.Distrito			As A With(Nolock) 	
			Inner Join	Catalogo.Canton				As B With(Nolock) 	
			On			B.TN_CodProvincia			= A.TN_CodProvincia
			And			B.TN_CodCanton				= A.TN_CodCanton  
			Inner Join	Catalogo.Provincia			As C With(Nolock) 	
			On			C.TN_CodProvincia			= B.TN_CodProvincia 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodProvincia			= IsNull(@CodigoProvincia, A.TN_CodProvincia)
			And			A.TN_CodCanton				= IsNull(@CodigoCanton, A.TN_CodCanton)
			And			A.TN_CodDistrito			= IsNull(@CodigoDistrito, A.TN_CodDistrito)
			And			A.TF_Inicio_Vigencia		< GETDATE ()
			And			(A.TF_Fin_Vigencia			Is Null OR A.TF_Fin_Vigencia  >= GETDATE ())
			Order By	A.TC_Descripcion;
	End
	--Por inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		A.TN_CodDistrito			As Codigo,				
						A.TC_Descripcion			As Descripcion,		
						A.TF_Inicio_Vigencia		As FechaActivacion,
						A.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split_Canton,
						B.TN_CodCanton				As Codigo,
						B.TC_Descripcion			As Descripcion,		
						B.TF_Inicio_Vigencia		As FechaActivacion,
						B.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split_Provincia,
						C.TN_CodProvincia			As Codigo,
						C.TC_Descripcion			As Descripcion,		
						C.TF_Inicio_Vigencia		As FechaActivacion,
						C.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split,
						A.TG_UbicacionPunto.Lat		As Latitud,
						A.TG_UbicacionPunto.Long	As Longitud
			From		Catalogo.Distrito			As A With(Nolock) 	
			Inner Join	Catalogo.Canton				As B With(Nolock) 	
			On			B.TN_CodProvincia			= A.TN_CodProvincia
			And			B.TN_CodCanton				= A.TN_CodCanton  
			Inner Join	Catalogo.Provincia			As C With(Nolock) 	
			On			C.TN_CodProvincia			= B.TN_CodProvincia 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodProvincia			= IsNull(@CodigoProvincia, A.TN_CodProvincia)
			And			A.TN_CodCanton				= IsNull(@CodigoCanton, A.TN_CodCanton)
			And			A.TN_CodDistrito			= IsNull(@CodigoDistrito, A.TN_CodDistrito)
			And			(A.TF_Inicio_Vigencia		> GETDATE () Or A.TF_Fin_Vigencia  < GETDATE ())
			Order By	A.TC_Descripcion;
	End

		--Inactivos por Fecha
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		A.TN_CodDistrito			As Codigo,				
						A.TC_Descripcion			As Descripcion,		
						A.TF_Inicio_Vigencia		As FechaActivacion,
						A.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split_Canton,
						B.TN_CodCanton				As Codigo,
						B.TC_Descripcion			As Descripcion,		
						B.TF_Inicio_Vigencia		As FechaActivacion,
						B.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split_Provincia,
						C.TN_CodProvincia			As Codigo,
						C.TC_Descripcion			As Descripcion,		
						C.TF_Inicio_Vigencia		As FechaActivacion,
						C.TF_Fin_Vigencia			As FechaDesactivacion,
						'Split'						As Split,
						A.TG_UbicacionPunto.Lat		As Latitud,
						A.TG_UbicacionPunto.Long	As Longitud
			From		Catalogo.Distrito			As A With(Nolock) 	
			Inner Join	Catalogo.Canton				As B With(Nolock) 	
			On			B.TN_CodProvincia			= A.TN_CodProvincia
			And			B.TN_CodCanton				= A.TN_CodCanton  
			Inner Join	Catalogo.Provincia			As C With(Nolock) 	
			On			C.TN_CodProvincia			= B.TN_CodProvincia 
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodProvincia			= IsNull(@CodigoProvincia, A.TN_CodProvincia)
			And			A.TN_CodCanton				= IsNull(@CodigoCanton, A.TN_CodCanton)
			And			A.TN_CodDistrito			= IsNull(@CodigoDistrito, A.TN_CodDistrito)
			And			(A.TF_Fin_Vigencia			> @FechaActivacion Or A.TF_Fin_Vigencia  < @FechaDesactivacion)
			Order By	A.TC_Descripcion;
	End
			
 End

GO
