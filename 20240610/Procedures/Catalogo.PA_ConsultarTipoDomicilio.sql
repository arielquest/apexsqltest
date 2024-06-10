SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<07/09/2015>
-- Descripción :			<Permite Consultar tipos de domicilio> 
-- Modificado por:			<Sigifredo Leitón Luna>
-- Fecha de creación:		<22/10/2015>
-- Descripción :			<Incluir filtro por la fecha de activación.>
-- Modificado por:			<15/12/2015> <GerardoLopez> 	<Se cambia tipo dato  CodTipoDomicilio  a smallint>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- =================================================================================================================================================
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoDomicilio]
	@CodTipoDomicilio		smallint		= Null,
	@Descripcion			varchar(50)		= Null,
	@FechaActivacion		datetime2(3)	= Null,
	@FechaDesactivacion		datetime2(3)	= null
 As
Begin


--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(200)
	Set		@ExpresionLike	=	iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')
	
	--Si todo es nulo se devuelven todos los registros
	If  @FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin	
			Select		TN_CodTipoDomicilio		As	Codigo,				TC_Descripcion	As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDomicilio With(Nolock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			and         TN_CodTipoDomicilio=COALESCE(@CodTipoDomicilio,TN_CodTipoDomicilio)
			Order By	TC_Descripcion;
	End
	--Si estan activos o desactivos dependiendo de valor de @FechaDesactivacion
	Else If @FechaDesactivacion Is Null And @FechaActivacion Is Not Null
	Begin
			Select		TN_CodTipoDomicilio		As	Codigo,				TC_Descripcion	As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDomicilio
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia		< GETDATE ()
			And			(	TF_Fin_Vigencia		Is Null 
						OR	TF_Fin_Vigencia		>= GETDATE ())	
		  	and         TN_CodTipoDomicilio=COALESCE(@CodTipoDomicilio,TN_CodTipoDomicilio)
			Order By	TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null
	Begin
			Select		TN_CodTipoDomicilio		As	Codigo,				TC_Descripcion	As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDomicilio
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(	TF_Inicio_Vigencia  > GETDATE ()
						Or	TF_Fin_Vigencia  < GETDATE ())
			and         TN_CodTipoDomicilio=COALESCE(@CodTipoDomicilio,TN_CodTipoDomicilio)
			Order By	TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	Begin
			Select		TN_CodTipoDomicilio		As	Codigo,				TC_Descripcion	As	Descripcion,
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion
			From		Catalogo.TipoDomicilio
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia	>= @FechaActivacion
			And			TF_Fin_Vigencia		<= @FechaDesactivacion 
			and         TN_CodTipoDomicilio=COALESCE(@CodTipoDomicilio,TN_CodTipoDomicilio)
			Order By	TC_Descripcion;
	End

end



GO
