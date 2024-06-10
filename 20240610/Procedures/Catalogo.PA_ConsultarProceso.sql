SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Alejandro Villalta Ruiz>
-- Fecha de creación:		<13/08/2015>
-- Descripción :			<Permite Consultar un Proceso> 
-- =================================================================================================================================================
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<05/12/2016> <Pablo Alvarez> <Se corrige TN_CodProcedimiento por estandar.>
-- Modificación:			<04/10/2017> <Diego Navarrete> <Se elimina la consulta por codigo pero se agrega en los where de las demas consultas con un Coalesce>
-- Modificación:			<14/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- Modificación:			<05/02/2019> <Isaac Dobles Mata> <Se cambia nombre a PA_ConsultarProceso y direcciona a tabla Catalogo.Proceso>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarProceso]
	@Codigo smallint=Null,
	@Descripcion Varchar(255)=Null,
	@FechaActivacion Datetime2= Null,
	@FechaDesactivacion Datetime2= Null
 As
 Begin
  
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(257)
	Set		@ExpresionLike	=	iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')
	
	--Si todo es nulo se devuelven todos los registros
	If @FechaActivacion Is Null And	@FechaDesactivacion Is Null 
	Begin	
			Select		TN_CodProceso     As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Proceso
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodProceso= COALESCE(@Codigo, TN_CodProceso)
			Order By	TC_Descripcion;
	End
	
	--Activos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null 
	Begin
			Select		TN_CodProceso		As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Proceso
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			And			TN_CodProceso= COALESCE(@Codigo, TN_CodProceso)
			Order By	TC_Descripcion;
	End
	--Inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null 
			Select		TN_CodProceso	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Proceso
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			And			TN_CodProceso= COALESCE(@Codigo, TN_CodProceso)
			Order By	TC_Descripcion;
	--Inactivos por fecha
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null 
			Select		TN_CodProceso	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Proceso
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Fin_Vigencia  > @FechaActivacion Or	TF_Fin_Vigencia  < @FechaDesactivacion)
			And			TN_CodProceso= COALESCE(@Codigo, TN_CodProceso)
			Order By	TC_Descripcion;
 End

GO
