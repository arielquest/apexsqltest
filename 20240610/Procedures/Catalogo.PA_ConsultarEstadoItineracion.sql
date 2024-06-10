SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Henry Mendez Chavarria>
-- Fecha de creación:		<08/09/2015>
-- Descripción :			<Permite Consultar estados de itineracion de la tabla Catalogo.EstadoItineracion> 
-- Modificacion:			<Gerardo Lopez> <22/10/2015> <Incluir fecha de activación para realizar la consulta de activos.>
-- Modificado:			    <Pablo Alvarez Espinoza>
-- Fecha Modifica:          <18/12/2015>
-- Descripcion:	            <Se cambia la llave a smallint squence>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificado:              <22/08/2017> <Diego Navarrete ><Se optimiza la consulta>
-- Modificación:			<29/11/2017> <Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoItineracion]
	@Codigo smallint=Null,
	@Descripcion varchar(150)=Null,			
	@FechaActivacion datetime2=Null,
	@FechaDesactivacion datetime2= Null
As
Begin
	
	DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Activos e inactivos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
				
		Select			EI.TN_CodEstadoItineracion	As	Codigo,				EI.TC_Descripcion	As	Descripcion,		
						EI.TF_Inicio_Vigencia		As	FechaActivacion,	EI.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.EstadoItineracion	EI With(Nolock)
			Where		dbo.FN_RemoverTildes(EI.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
			And			EI.TN_CodEstadoItineracion	=	COALESCE(@Codigo,TN_CodEstadoItineracion)
			Order By	TC_Descripcion;
	End
		
	--Activos 
	Else If @FechaActivacion Is not Null And @FechaDesactivacion Is Null
	Begin					
		Select			EI.TN_CodEstadoItineracion	As	Codigo,				EI.TC_Descripcion	As	Descripcion,		
						EI.TF_Inicio_Vigencia		As	FechaActivacion,	EI.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.EstadoItineracion	EI With(Nolock)
			Where		dbo.FN_RemoverTildes(EI.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
			And			EI.TN_CodEstadoItineracion	=	COALESCE(@Codigo,TN_CodEstadoItineracion)
			And			EI.TF_Inicio_Vigencia		<	GETDATE ()
			And			(EI.TF_Fin_Vigencia			Is	Null 
			OR			EI.TF_Fin_Vigencia			>=	GETDATE ())
			Order By	EI.TC_Descripcion;
	End
	
	--Inactivos
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null
	Begin
		Select		EI.TN_CodEstadoItineracion	As	Codigo,				EI.TC_Descripcion	As	Descripcion,		
					EI.TF_Inicio_Vigencia		As	FechaActivacion,	EI.TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.EstadoItineracion	EI With(Nolock)
		Where		dbo.FN_RemoverTildes(EI.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
		And			EI.TN_CodEstadoItineracion	=	COALESCE(@Codigo,TN_CodEstadoItineracion)
	    And			(EI.TF_Inicio_Vigencia			>	GETDATE () 
		Or			EI.TF_Fin_Vigencia				<	GETDATE ())
		Order By	EI.TC_Descripcion;
	End
	 --Por rango
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	Begin
		Select		EI.TN_CodEstadoItineracion	As	Codigo,				EI.TC_Descripcion	As	Descripcion,		
					EI.TF_Inicio_Vigencia		As	FechaActivacion,	EI.TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.EstadoItineracion	EI With(Nolock)
		Where		dbo.FN_RemoverTildes(EI.TC_Descripcion) like dbo.FN_RemoverTildes(COALESCE(@ExpresionLike ,TC_Descripcion))
		And			EI.TN_CodEstadoItineracion	=	COALESCE(@Codigo,TN_CodEstadoItineracion)
		And			(EI.TF_Fin_Vigencia			<=	@FechaDesactivacion 
		and			EI.TF_Inicio_Vigencia		>=	@FechaActivacion) 
		Order By	EI.TC_Descripcion;
	End	
End


GO
