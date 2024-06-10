SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<28/08/2015>
-- Descripción :			<Permite Consultar motivos absolutorias> 
-- Modificado :				<Alejandro Villalta><08/01/2016><Modificar el tipo de dato del codigo de motivo absolutoria> 
--
-- Modificación:			<08/07/2016><Andrés Díaz><Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:		    <02-12-2016><Pablo Alvarez><Se modifica TN_CodMotivoAbsolutoria por estandar.>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<14/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarMotivoAbsolutoria]
	@CodMotivoAbsolutoria smallint=Null,
	@Descripcion Varchar(255)=Null,
	@FechaActivacion Datetime2= Null,
	@FechaDesactivacion Datetime2= Null
 As
 Begin
  
  	
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(257)
	Set		@ExpresionLike	=	iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')
	
	--Si todo es nulo se devuelven todos los registros
	If	@FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin	
			Select		TN_CodMotivoAbsolutoria   As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MotivoAbsolutoria
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			and			 TN_CodMotivoAbsolutoria=COALESCE(@CodMotivoAbsolutoria,TN_CodMotivoAbsolutoria)
			Order By	TC_Descripcion;
	End
	
	--Activos
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null 
	Begin
			Select		TN_CodMotivoAbsolutoria		As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MotivoAbsolutoria
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null Or TF_Fin_Vigencia  >= GETDATE ())	
		     and			 TN_CodMotivoAbsolutoria=COALESCE(@CodMotivoAbsolutoria,TN_CodMotivoAbsolutoria)
			Order By	TC_Descripcion;
	End
	--Inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion Is Not Null 
			Select		TN_CodMotivoAbsolutoria	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MotivoAbsolutoria
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			and			 TN_CodMotivoAbsolutoria=COALESCE(@CodMotivoAbsolutoria,TN_CodMotivoAbsolutoria)
			Order By	TC_Descripcion;

	--Inactivos por Rango de Fechas						
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null 
			Select		TN_CodMotivoAbsolutoria	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.MotivoAbsolutoria
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Fin_Vigencia>=@FechaActivacion And TF_Fin_Vigencia  <= @FechaDesactivacion)
			and			 TN_CodMotivoAbsolutoria=COALESCE(@CodMotivoAbsolutoria,TN_CodMotivoAbsolutoria)
			Order By	TC_Descripcion;
					  
 End

GO
