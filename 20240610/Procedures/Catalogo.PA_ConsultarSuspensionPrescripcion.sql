SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:				<1.0>
-- Creado por:			<Pablo Alvarez>
-- Fecha de creación:	<26/08/2015>
-- Descripción :		<Permite Consultar la tabla Catalogo.SuspensionPrescripcion> 
-- Modificado por:		<Sigifredo Leitón Luna>
-- Fecha:				<08/01/2016>
-- Descripción :		<Se modifica para la autogeneración del código de suspensión prescripción - item 5606>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificado:	            <05/12/2016> <Pablo Alvarez<Se corrige TN_CodSuspensionPrescripcion por estandar >
-- =================================================================================================================================================
-- Modificado por:			<Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:			<Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarSuspensionPrescripcion]
	@CodSuspensionPrescripcion	smallint	= Null,
	@Descripcion				varchar(100)= Null,		
	@FechaActivacion			datetime2	= Null,
	@FechaDesactivacion			datetime2	= Null
As
Begin	
	DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin
			Select		TN_CodSuspensionPrescripcion	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.SuspensionPrescripcion	
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND            TN_CodSuspensionPrescripcion=COALESCE(@CodSuspensionPrescripcion,TN_CodSuspensionPrescripcion)
			Order By	TC_Descripcion;
	End
	--Por activos
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodSuspensionPrescripcion	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.SuspensionPrescripcion
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			AND         TN_CodSuspensionPrescripcion=COALESCE(@CodSuspensionPrescripcion,TN_CodSuspensionPrescripcion)
			Order By	TC_Descripcion;
	End
	--Inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		TN_CodSuspensionPrescripcion	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.SuspensionPrescripcion
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			AND         TN_CodSuspensionPrescripcion=COALESCE(@CodSuspensionPrescripcion,TN_CodSuspensionPrescripcion)
			Order By	TC_Descripcion;
	End
	--Inactivos por rango de fechas
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null	
		Begin
			Select		TN_CodSuspensionPrescripcion	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.SuspensionPrescripcion
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Fin_Vigencia  > @FechaActivacion And	TF_Fin_Vigencia  < @FechaDesactivacion)
			AND         TN_CodSuspensionPrescripcion=COALESCE(@CodSuspensionPrescripcion,TN_CodSuspensionPrescripcion)
			Order By	TC_Descripcion;
	End
End


GO
