SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<08/09/2015>
-- Descripción :			<Permite Consultar Lugares de Atención a la victima.> 
-- Modificado por:			<Pablo Alvarez>
-- Fecha de creación:		<23/10/2015>
-- Descripción :			<Incluir la consulta por la fecha de activación.> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<03/11/2015>
-- Descripción :			<Se modifica para solucionar problema de consulta de inactivos y activos.> 
-- Modificacion:            <15/12/2015  Pablo Alvarez Generar llave por sequence> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<02/12/2016> <Pablo Alvarez> <Se corrige TN_CodLugarAtención por estandar.>     				 							
-- Modificación:            <3/10/2017> <Diego Chavarria> <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							 también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarLugarAtencion]
	@CodLugarAtencion smallint	    = Null,
	@Descripcion varchar(150)		= Null,	
	@CodProvincia smallint          = Null,	
	@FechaActivacion datetime2		= Null,	
	@FechaDesactivacion datetime2	= Null			
As
Begin
		
	   DECLARE @ExpresionLike varchar(200)
	   Set	   @ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
			Select		A.TN_CodLugarAtencion			As	Codigo,				A.TC_Descripcion	As	Descripcion,
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
						'Split'					As	Split,
						B.TN_CodProvincia		As	Codigo,				B.TC_Descripcion	As	Descripcion,		
						B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.LugarAtencion		A
			Join		Catalogo.Provincia	B	On A.TN_CodProvincia	=	B.TN_CodProvincia
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and A.TN_CodLugarAtencion = COALESCE(@CodLugarAtencion,A.TN_CodLugarAtencion)
			Order By	A.TC_Descripcion;
	End	
	--Activos 
	Else If @FechaActivacion Is not Null And @FechaDesactivacion Is Null
	Begin
			Select		A.TN_CodLugarAtencion			As	Codigo,				A.TC_Descripcion	As	Descripcion,
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
						'Split'					As	Split,
						B.TN_CodProvincia		As	Codigo,				B.TC_Descripcion	As	Descripcion,		
						B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.LugarAtencion		A
			Join		Catalogo.Provincia	B	On A.TN_CodProvincia	=	B.TN_CodProvincia	
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and A.TN_CodLugarAtencion = COALESCE(@CodLugarAtencion,A.TN_CodLugarAtencion)
			And			A.TF_Inicio_Vigencia  < GETDATE ()
			And			(A.TF_Fin_Vigencia Is Null OR A.TF_Fin_Vigencia  >= GETDATE ())
			Order By	A.TC_Descripcion;
	End	 
	--Inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is not Null
	Begin
			Select		A.TN_CodLugarAtencion			As	Codigo,				A.TC_Descripcion	As	Descripcion,
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
						'Split'					As	Split,
						B.TN_CodProvincia		As	Codigo,				B.TC_Descripcion	As	Descripcion,		
						B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.LugarAtencion		A
			Join		Catalogo.Provincia	B	On A.TN_CodProvincia	=	B.TN_CodProvincia
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and A.TN_CodLugarAtencion = COALESCE(@CodLugarAtencion,A.TN_CodLugarAtencion)
	        And			(A.TF_Inicio_Vigencia  > GETDATE () Or A.TF_Fin_Vigencia  < GETDATE ())
			Order By	A.TC_Descripcion;
	End	
	--Por Rango de Fechas
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is not Null
	Begin
			Select		A.TN_CodLugarAtencion			As	Codigo,				A.TC_Descripcion	As	Descripcion,
						A.TF_Inicio_Vigencia	As	FechaActivacion,	A.TF_Fin_Vigencia	As	FechaDesactivacion,
						'Split'					As	Split,
						B.TN_CodProvincia		As	Codigo,				B.TC_Descripcion	As	Descripcion,		
						B.TF_Inicio_Vigencia	As	FechaActivacion,	B.TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.LugarAtencion		A
			Join		Catalogo.Provincia	B	On A.TN_CodProvincia	=	B.TN_CodProvincia
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike) and A.TN_CodLugarAtencion = COALESCE(@CodLugarAtencion,A.TN_CodLugarAtencion)
		    And			(A.TF_Fin_Vigencia  <= @FechaDesactivacion and A.TF_Inicio_Vigencia >=@FechaActivacion)
			Order By	A.TC_Descripcion;
	End	
End
		



GO
