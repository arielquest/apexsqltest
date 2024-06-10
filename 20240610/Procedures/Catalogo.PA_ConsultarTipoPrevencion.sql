SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Luis Alonso Leiva Tames>
-- Fecha de creación:		<08/03/2019>
-- Descripción :			<Permite consultar registros del catálogo de Tipo Prevencion> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoPrevencion]
	 @CodTipoPrevencion smallint=Null,
	 @Descripcion varchar(100)=Null,
	 @FechaActivacion Datetime2=Null,
	 @FechaDesactivacion Datetime2= Null
 As
 Begin
  
	DECLARE	@ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			SELECT		TN_CodTipoPrevencion	As	Codigo,				
						TC_Descripcion			As	Descripcion,
						TF_Inicio_Vigencia		As	FechaActivacion,	
						TF_Fin_Vigencia			As	FechaDesactivacion
			FROM		
						Catalogo.TipoPrevencion With(Nolock) 	
			WHERE		
						dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike) 
						AND	TN_CodTipoPrevencion = COALESCE(@CodTipoPrevencion,TN_CodTipoPrevencion)
			ORDER BY	
						TC_Descripcion;
	End	 
	--Activos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			SELECT		
						TN_CodTipoPrevencion	As	Codigo,				
						TC_Descripcion			As	Descripcion,
						TF_Inicio_Vigencia		As	FechaActivacion,	
						TF_Fin_Vigencia			As	FechaDesactivacion
			FROM		
						Catalogo.TipoPrevencion With(Nolock) 
			WHERE		
						dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike) 
						AND	TF_Inicio_Vigencia  < GETDATE ()
						AND	(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
						AND	TN_CodTipoPrevencion = COALESCE(@CodTipoPrevencion,TN_CodTipoPrevencion)
			ORDER BY	
						TC_Descripcion;
	End
	--Inactivos
	Else  If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null	
		Begin
			SELECT		
				TN_CodTipoPrevencion	As	Codigo,				
				TC_Descripcion			As	Descripcion,
				TF_Inicio_Vigencia		As	FechaActivacion,	
				TF_Fin_Vigencia			As	FechaDesactivacion
			FROM		
				Catalogo.TipoPrevencion With(Nolock) 
			WHERE		
				dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike) 
				And	(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
				AND	TN_CodTipoPrevencion = COALESCE(@CodTipoPrevencion,TN_CodTipoPrevencion)
			ORDER BY	
				TC_Descripcion;
	End
	--Inactivos por fecha
	Else  If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
	Begin
			SELECT		
					TN_CodTipoPrevencion	As	Codigo,				
					TC_Descripcion			As	Descripcion,
					TF_Inicio_Vigencia		As	FechaActivacion,	
					TF_Fin_Vigencia			As	FechaDesactivacion
			FROM		
					Catalogo.TipoPrevencion With(Nolock) 
			WHERE		
					dbo.FN_RemoverTildes(TC_Descripcion) like dbo.FN_RemoverTildes(@ExpresionLike) 
					AND	(TF_Inicio_Vigencia  > @FechaActivacion And TF_Fin_Vigencia  < @FechaDesactivacion)
					AND	TN_CodTipoPrevencion = COALESCE(@CodTipoPrevencion,TN_CodTipoPrevencion)
			ORDER BY	
					TC_Descripcion;
	End	
 End
GO
