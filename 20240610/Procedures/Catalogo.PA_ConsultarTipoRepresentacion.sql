SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.1>
-- Creado por:			<Roger Lara>
-- Fecha de creación:	<11/08/2015>
-- Descripción :		<Permite Consultar tipos de representacion> 
-- Modificacion:		<Pablo Alvarez> <02/11/2015> <Incluir fecha de activación para realizar la consulta de activos.>
-- Modificado por:		<Sigifredo Leitón Luna>
-- Fecha:				<07/01/2016>
-- Descripción :		<Modificación para autogenerar el código de tipo de representación - item 5758> 
--
--	Modificación:		<11/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
--	Modificación:		<04/10/2017> <Diego Navarrete >	<Se elimina la consulta por codigo pero se agrega a las demas consultas.>
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- Modificación:	    <15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoRepresentacion]
	@Codigo				smallint	= Null,
	@Descripcion		Varchar(150)= Null,
	@FechaActivacion	Datetime2	= Null,
	@FechaDesactivacion datetime2	= Null
  As
 Begin
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(200)
	Set		@ExpresionLike	=	iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')
	
	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin	
			Select		TN_CodTipoRepresentacion     As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoRepresentacion With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodTipoRepresentacion = COALESCE(@Codigo,TN_CodTipoRepresentacion)
			Order By	TC_Descripcion;
	End
	
	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTipoRepresentacion		As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoRepresentacion With(Nolock) 
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			And			TN_CodTipoRepresentacion = COALESCE(@Codigo,TN_CodTipoRepresentacion)
			Order By	TC_Descripcion;
	End
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
			Select		TN_CodTipoRepresentacion		As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoRepresentacion With(Nolock) 
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			And			TN_CodTipoRepresentacion = COALESCE(@Codigo,TN_CodTipoRepresentacion)
			Order By	TC_Descripcion;
	end
		 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else IF @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TN_CodTipoRepresentacion	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoRepresentacion With(Nolock) 
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Fin_Vigencia  <= @FechaDesactivacion and TF_Inicio_Vigencia >=@FechaActivacion)
			And			TN_CodTipoRepresentacion = COALESCE(@Codigo,TN_CodTipoRepresentacion)
			Order By	TC_Descripcion;
	  end	  
 End

GO
