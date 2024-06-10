SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<08/12/2016>
-- Descripción :			<Permite Consultar un tipo MotivoResultadoComunicacionJudicial> 
-- =================================================================================================================================================
-- Modificación:            <3/10/2017> <Diego Chavarria> <Se elimino la consulta por codigo, ya que se agrega
--							como condicion en todas las demas consultas, tambien se elimina del IF Null de Codigo del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- Modificación:			<06/11/2018> <Andrés Díaz> <Se renombra 'TF_InicioVigencia' a 'TF_Inicio_Vigencia' y 'TF_FinalizaVigencia' a 'TF_Fin_Vigencia'.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarMotivoResultadoComunicacionJudicial]
	@Codigo smallint				= Null,
	@Descripcion varchar(255)		= Null,
	@Resultado  varchar(1)          = Null,
	@FechaActivacion datetime2		= Null,
	@FechaDesactivacion datetime2	= Null
As
Begin
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(200) = iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%');
	
	--Si todo es nulo se devuelven todos los registros
	If	@FechaActivacion Is Null And @FechaDesactivacion Is Null 
	Begin	
			Select		TN_CodMotivoResultado		As	Codigo,				TC_Descripcion	As	Descripcion, 
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion, 
						'Split'	  As Split,    TC_Resultado as Resultado
			From		Catalogo.MotivoResultadoComunicacionJudicial With(Nolock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND			  TN_CodMotivoResultado=COALESCE(@Codigo,TN_CodMotivoResultado)
			Order By	TC_Descripcion;
	End

	--Solo por resultado
	Else IF	@Resultado Is Not Null
	Begin
			Select		TN_CodMotivoResultado		As	Codigo,				TC_Descripcion	As	Descripcion,  
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion,
						'Split'	  As Split,    TC_Resultado as Resultado
			From		Catalogo.MotivoResultadoComunicacionJudicial
			Where		TC_Resultado	=	@Resultado 
			AND			  TN_CodMotivoResultado=COALESCE(@Codigo,TN_CodMotivoResultado)
			Order By	TC_Descripcion;
	End	

	
	--Por descripcion si hay. Si estan activos o desactivos dependiendo de valor de @FechaDesactivacion
	Else If @FechaDesactivacion Is Null And @FechaActivacion Is Not Null
	Begin
			Select		TN_CodMotivoResultado		As	Codigo,				TC_Descripcion	As	Descripcion, 
						TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion,
						'Split'	  As Split,    TC_Resultado as Resultado
			From		Catalogo.MotivoResultadoComunicacionJudicial
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia		< GETDATE ()
			And			(	TF_Fin_Vigencia		Is Null 
						OR	TF_Fin_Vigencia		>= GETDATE ())
			AND			  TN_CodMotivoResultado=COALESCE(@Codigo,TN_CodMotivoResultado)
			Order By	TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null
	Begin
		Select		TN_CodMotivoResultado		As	Codigo,				TC_Descripcion	As	Descripcion,  
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion,
					'Split'	  As Split,    TC_Resultado as Resultado
		From		Catalogo.MotivoResultadoComunicacionJudicial
		where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			(	TF_Inicio_Vigencia  > GETDATE ()
					Or	TF_Fin_Vigencia  < GETDATE ())
	     AND			  TN_CodMotivoResultado=COALESCE(@Codigo,TN_CodMotivoResultado)
		Order By	TC_Descripcion;
	End
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	Begin
		Select		TN_CodMotivoResultado		As	Codigo,				TC_Descripcion	As	Descripcion, 
					TF_Inicio_Vigencia	As	FechaActivacion,	TF_Fin_Vigencia	As	FechaDesactivacion,
					'Split'	  As Split,    TC_Resultado as Resultado
		From		Catalogo.MotivoResultadoComunicacionJudicial
		where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			TF_Inicio_Vigencia	>= @FechaActivacion
		And			TF_Fin_Vigencia		<= @FechaDesactivacion
		AND			  TN_CodMotivoResultado=COALESCE(@Codigo,TN_CodMotivoResultado) 
		Order By	TC_Descripcion;
	End

End
GO
