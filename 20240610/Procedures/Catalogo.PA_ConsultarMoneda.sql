SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<12/08/2015>
-- Descripción :			<Permite Consultar un tipo moneda> 
-- Modificado por:			<23/10/2015> <Pablo Alvarez> 	<Se incluyen filtros por fecha de activación.>
-- Modificado por:			<08/12/2015> <GerardoLopez> 	<Se cambia tipo dato codmoneda a smallint>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:		    <02-12-2016> <Pablo Alvarez> <Se modifica TN_CodMedioComunicación por estandar.>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<14/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarMoneda]
			@Codigo smallint				= Null,
			@Descripcion varchar(255)		= Null,
			@FechaActivacion datetime2(3)	= Null,
			@FechaDesactivacion datetime2(3)= Null
 As
Begin
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(257)
	Set		@ExpresionLike = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')
	
	--Si todo es nulo se devuelven todos los registros
	If	@FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin	
			Select		TN_CodMoneda		As	Codigo,				TC_Descripcion	As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Moneda With(Nolock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND			TN_CodMoneda=COALESCE(@Codigo,TN_CodMoneda)
			Order By	TC_Descripcion;
	End
	
	Else If @FechaDesactivacion Is Null And @FechaActivacion Is Not Null
	Begin
			Select		TN_CodMoneda		As	Codigo,				TC_Descripcion	As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.Moneda
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia		< GETDATE ()
			And			(	TF_Fin_Vigencia		Is Null 
						OR	TF_Fin_Vigencia		>= GETDATE ())
			AND			  TN_CodMoneda=COALESCE(@Codigo,TN_CodMoneda)
			Order By	TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null
	Begin
		Select		TN_CodMoneda		As	Codigo,				TC_Descripcion	As	Descripcion,
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.Moneda
		where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			(	TF_Inicio_Vigencia  > GETDATE ()
					Or	TF_Fin_Vigencia  < GETDATE ())
		AND			  TN_CodMoneda=COALESCE(@Codigo,TN_CodMoneda)
		Order By	TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	Begin
		Select		TN_CodMoneda		As	Codigo,				TC_Descripcion	As	Descripcion,
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
		From		Catalogo.Moneda
		where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			TF_Inicio_Vigencia	>= @FechaActivacion
		And			TF_Fin_Vigencia		<= @FechaDesactivacion 
		AND			  TN_CodMoneda=COALESCE(@Codigo,TN_CodMoneda)
		Order By	TC_Descripcion;
	End

end



GO
