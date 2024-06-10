SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<24/08/2015>
-- Descripción :			<Permite Consultar la tabla Catalogo.SituacionLibertad> 
-- Modificacion:			<Gerardo Lopez> <22/10/2015> <Incluir fecha de activación para realizar la consulta de activos.>
-- Modificado:			    <Pablo Alvarez Espinoza>
-- Fecha Modifica:          <04/01/2016>
-- Descripcion:	            <Se cambia la llave a smallint squence>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificado:	            <05/12/2016> <Pablo Alvarez<Se corrige TN_CodSituacionLibertad por estandar >
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarSituacionLibertad]
	@Codigo smallint=Null,
	@Descripcion varchar(150)=Null,			
	@FechaActivacion datetime2= Null,
	@FechaDesactivacion datetime2= Null
As
Begin
	
	DECLARE @ExpresionLike varchar(200)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null And @Codigo Is Null  
	Begin
			Select		TN_CodSituacionLibertad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.SituacionLibertad	With(Nolock) 
			Where		TC_Descripcion like @ExpresionLike 
			Order By	TC_Descripcion;
	End
	 
	--Por Llave
	Else If  @Codigo Is Not Null
	Begin
			Select		TN_CodSituacionLibertad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.SituacionLibertad 	With(Nolock) 
			Where		TN_CodSituacionLibertad		=	@Codigo
			Order By	TC_Descripcion;
	End

	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodSituacionLibertad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.SituacionLibertad With(Nolock) 
			Where		TC_Descripcion like @ExpresionLike 
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia Is Null OR TF_Fin_Vigencia  >= GETDATE ())
			Order By	TC_Descripcion;
	End
	
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
			Select		TN_CodSituacionLibertad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.SituacionLibertad	With(Nolock) 
			Where		TC_Descripcion		like	@ExpresionLike 
	        And			(TF_Inicio_Vigencia  > GETDATE () Or TF_Fin_Vigencia  < GETDATE ())
			Order By	TC_Descripcion;
	End
	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else IF @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
		Begin
			Select		TN_CodSituacionLibertad	As	Codigo,				TC_Descripcion	As	Descripcion,		
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.SituacionLibertad	With(Nolock) 
			Where		TC_Descripcion		like	@ExpresionLike 
	    	And			(TF_Fin_Vigencia  <= @FechaDesactivacion and TF_Inicio_Vigencia >=@FechaActivacion)
			Order By	TC_Descripcion;
	End
End

GO
