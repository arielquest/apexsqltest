SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Johan Acosta Ibañez>
-- Fecha de creación:	<12/08/2015>
-- Descripción :		<Permite Consultar los tipos de Cuantia de la tabla Catalogo.TipoCuantia> 
-- Modificado por:		<Sigifredo Leitón Luna.>
-- Fecha:				<13/01/2016>
-- Descripción:			<Se realiza cambio para autogenerar el consecutivo de tipo de cuantía - item 5630.>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificado por:      <Diego Chavarria>
-- Fecha:			    <4/10/2017>							
-- Modificación:        <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--					    también se elimina el IF Null de Código del select Todos>
-- Modificación:		<14/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoCuantia]
	@CodTipoCuantia		tinyint		= Null,
	@Descripcion		Varchar(255)= Null,
	@FechaActivacion	Datetime2	= Null,
	@FechaDesactivacion Datetime2	= Null 
AS
BEGIN 	
	--Variable para almacenar la descripcion 
	DECLARE @ExpresionLike varchar(257)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTipoCuantia	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoCuantia With(Nolock) 	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			and			TN_CodTipoCuantia=COALESCE(@CodTipoCuantia,TN_CodTipoCuantia)
			Order By	TC_Descripcion;
	End
	 

	
	--Por activos
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodTipoCuantia	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoCuantia With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			and			TN_CodTipoCuantia=COALESCE(@CodTipoCuantia,TN_CodTipoCuantia)
			Order By	TC_Descripcion;
	End
	--Por inactivos
	Else If	@FechaActivacion Is Null And @FechaDesactivacion Is Not Null
		Begin
			Select		TN_CodTipoCuantia	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoCuantia With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE ()
			Or			TF_Fin_Vigencia  < GETDATE ())
			and			TN_CodTipoCuantia=COALESCE(@CodTipoCuantia,TN_CodTipoCuantia)
			Order By	TC_Descripcion;
	End
	--Rango de Fechas para los inctivos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TN_CodTipoCuantia	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoCuantia With(Nolock) 
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia >=@FechaActivacion And TF_Fin_Vigencia  <= @FechaDesactivacion)
			and			TN_CodTipoCuantia=COALESCE(@CodTipoCuantia,TN_CodTipoCuantia)
			Order By	TC_Descripcion;
		end			
END
GO
