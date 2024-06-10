SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:			<Roger Lara>
-- Fecha de creación:	<28/08/2015>
-- Descripción :		<Permite Consultar tipo penas> 
-- Modificacion:		<Gerardo Lopez> <22/10/2015> <Incluir fecha de activación para realizar la consulta de activos.>
-- Modificado por:		<Sigifredo Leitón Luna>
-- Fecha:				<07/01/2016>
-- Descripción :		<Modificar para autogenerar el código del tipo de pena - item 5734> 
--
-- Modificación:		<11/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificado por:      <Diego Chavarria>
-- Fecha:			    <4/10/2017>							
-- Modificación:        <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--					    también se elimina el IF Null de Código del select Todos>
-- Modificación:	    <15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoPena]
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
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null   
	Begin	
			Select		TN_CodTipoPena     As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoPena With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND			TN_CodTipoPena=coalesce(@Codigo,TN_CodTipoPena)
			Order By	TC_Descripcion;
	End	
	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTipoPena		As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoPena With(Nolock) 
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			AND			TN_CodTipoPena=coalesce(@Codigo,TN_CodTipoPena)
			Order By	TC_Descripcion;
	End
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
			Select		TN_CodTipoPena		As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoPena With(Nolock) 
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			AND			TN_CodTipoPena=coalesce(@Codigo,TN_CodTipoPena)
			Order By	TC_Descripcion;
	end
		 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else IF @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TN_CodTipoPena	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoPena With(Nolock) 
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Fin_Vigencia  <= @FechaDesactivacion and TF_Inicio_Vigencia >=@FechaActivacion)
			AND			TN_CodTipoPena=coalesce(@Codigo,TN_CodTipoPena)
			Order By	TC_Descripcion;
	  end	  
 End

GO
