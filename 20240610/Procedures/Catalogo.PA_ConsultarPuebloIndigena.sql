SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<31/08/2015>
-- Descripción :			<Permite Consultar Publos indigenas> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<05/12/2016> <Pablo Alvarez> <Se corrige TN_CodPuebloIndigena por estandar.>
--
-- Modificación:			<2017/05/26><Andrés Díaz><Se cambia el tamaño del parámetro descripción a 255.>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarPuebloIndigena]
	@CodPuebloIndigena		smallint=Null,
	@Descripcion			Varchar(255)=Null,
	@FechaActivacion		Datetime2= Null,
	@FechaDesactivacion		Datetime2= Null

 As
 Begin
    	
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(257)
	Set		@ExpresionLike	=	iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')
	
	--Si todo es nulo se devuelven todos los registros
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin	
			Select		TN_CodPuebloIndigena     As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.PuebloIndigena
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND         TN_CodPuebloIndigena=COALESCE(@CodPuebloIndigena,TN_CodPuebloIndigena)
			Order By	TC_Descripcion;
	End

	
	--Activos 
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodPuebloIndigena		As	Codigo,		TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.PuebloIndigena
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Fin_Vigencia Is Null Or TF_Fin_Vigencia  >= GETDATE ())
			AND         TN_CodPuebloIndigena=COALESCE(@CodPuebloIndigena,TN_CodPuebloIndigena)	
			Order By	TC_Descripcion;
	End
	--Inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null
			Select		TN_CodPuebloIndigena	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.PuebloIndigena
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())	
			AND         TN_CodPuebloIndigena=COALESCE(@CodPuebloIndigena,TN_CodPuebloIndigena)
			Order By	TC_Descripcion;		
	--Rango de Fechas para los inctivos

	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TN_CodPuebloIndigena	As	Codigo,				TC_Descripcion	As	Descripcion,	
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.PuebloIndigena
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia >=@FechaActivacion And TF_Fin_Vigencia  <= @FechaDesactivacion)
			AND         TN_CodPuebloIndigena=COALESCE(@CodPuebloIndigena,TN_CodPuebloIndigena)
			Order By	TC_Descripcion;
		end			  
 End
GO
