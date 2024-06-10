SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<08/09/2016>
-- Descripcion:		<Consultar tipo de evento>
--
-- Modificación:	<Andrés Díaz><28/11/2016><Se agrega el campo TB_EsRemate.>
-- =================================================================================================================================================
-- Modificado por:          <Diego Chavarria>
-- Fecha:					<3/10/2017>							
-- Modificación:            <Se eliminó la consulta por código, ya que se agrega como condición en todas las demás consultas,
--							también se elimina el IF Null de Código del select Todos>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoEvento]
			@Codigo smallint				=	Null,
			@Descripcion varchar(50)		=	Null,
			@FechaActivacion datetime2		=	Null,
			@FechaDesactivacion datetime2	=	Null
As
BEGIN
	DECLARE @ExpresionLike varchar(270)
	Set @ExpresionLike = iif(@Descripcion is not null,'%' + @Descripcion + '%','%')

		--Si todo es nulo se devuelven todos los registros
	If	@FechaActivacion Is Null And @FechaDesactivacion Is Null 
	begin
			Select		TN_CodTipoEvento as Codigo,				TC_Descripcion as Descripcion,
						TC_ColorEvento	 as ColorEvento,		TB_EsRemate		as EsRemate,
						TF_Inicio_Vigencia as FechaActivacion,	TF_Fin_Vigencia as FechaDesactivacion
			From		Catalogo.TipoEvento With(Nolock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			AND			TN_CodTipoEvento=COALESCE(@Codigo,TN_CodTipoEvento)
			Order By	TC_Descripcion;
	end
	
	--Por descripcion si hay. Si estan activos o desactivos dependiendo de valor de @FechaDesactivacion
	Else If @FechaDesactivacion Is Null And @FechaActivacion Is Not Null
	begin
			Select		TN_CodTipoEvento as Codigo,				TC_Descripcion as Descripcion,
						TC_ColorEvento	 as ColorEvento,		TB_EsRemate		as EsRemate,
						TF_Inicio_Vigencia as FechaActivacion,	TF_Fin_Vigencia as FechaDesactivacion
			From		Catalogo.TipoEvento With(Nolock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia  < GETDATE ()
			And			(TF_Fin_Vigencia is null or TF_Fin_Vigencia  >= GETDATE ())
			AND			TN_CodTipoEvento=COALESCE(@Codigo,TN_CodTipoEvento)
			Order By	TC_Descripcion;
	end
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Null
	begin
			Select		TN_CodTipoEvento as Codigo,				TC_Descripcion as Descripcion,
						TC_ColorEvento	 as ColorEvento,		TB_EsRemate		as EsRemate,
						TF_Inicio_Vigencia as FechaActivacion,	TF_Fin_Vigencia as FechaDesactivacion
			From		Catalogo.TipoEvento With(Nolock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		    And			(TF_Inicio_Vigencia  > GETDATE ()
			Or			TF_Fin_Vigencia  < GETDATE ())
			AND			TN_CodTipoEvento=COALESCE(@Codigo,TN_CodTipoEvento)
			Order By	TC_Descripcion;
	end
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	begin
			Select		TN_CodTipoEvento as Codigo,				TC_Descripcion as Descripcion,
						TC_ColorEvento	 as ColorEvento,		TB_EsRemate		as EsRemate,
						TF_Inicio_Vigencia as FechaActivacion,	TF_Fin_Vigencia as FechaDesactivacion
			From		Catalogo.TipoEvento With(Nolock)
			where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia	>= @FechaActivacion
			And			TF_Fin_Vigencia		<= @FechaDesactivacion
			AND			TN_CodTipoEvento=COALESCE(@Codigo,TN_CodTipoEvento) 
			Order By	TC_Descripcion;
	end
END

GO
