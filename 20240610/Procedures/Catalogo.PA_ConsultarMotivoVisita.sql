SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<27/08/2015>
-- Descripción :			<Permite Consultar Motivos de Visita> 
-- Modificado  :			<Alejandro Villalta Ruiz> <04/01/2016> <Autogenerar codigo de motivo de visita>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<02/12/2016> <Pablo Alvarez> <Se modifican TN_CodMotivoVisita por estandar.>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarMotivoVisita]
	@Codigo smallint=Null,
	@Descripcion Varchar(255)=Null,
	@FechaActivacion Datetime2= Null,
	@FechaDesactivacion Datetime2= Null
 As
 Begin
  
   DECLARE @ExpresionLike varchar(257)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null 
		Select		TN_CodMotivoVisita	As	Codigo,				TC_Descripcion	As	Descripcion,		
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.MotivoVisita With(Nolock) 
		Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		AND			TN_CodMotivoVisita=COALESCE(@Codigo,TN_CodMotivoVisita)
		Order By	TC_Descripcion;

		--Por activos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodMotivoVisita	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MotivoVisita With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			AND			TN_CodMotivoVisita=COALESCE(@Codigo,TN_CodMotivoVisita)
			Order By	TC_Descripcion;
	End
	--Por inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TN_CodMotivoVisita	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MotivoVisita With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			AND			TN_CodMotivoVisita=COALESCE(@Codigo,TN_CodMotivoVisita)
			Order By	TC_Descripcion;
	End
	--Rango de Fechas para los inctivos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TN_CodMotivoVisita	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MotivoVisita With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia >=@FechaActivacion And TF_Fin_Vigencia  <= @FechaDesactivacion)
			AND			TN_CodMotivoVisita=COALESCE(@Codigo,TN_CodMotivoVisita)
			Order By	TC_Descripcion;
		end			
 End





GO
