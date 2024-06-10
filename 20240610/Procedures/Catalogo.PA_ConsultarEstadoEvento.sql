SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:			<Johan Acosta Ibañez>
-- Fecha Creación:	<06/09/2016>
-- Descripcion:		<Consultar estado de evento>
--
-- Modificación:	<Andrés Díaz><07/12/2016><Se agrega el campo TB_FinalizaEvento.>
-- Modificación:	<Jeffry Hernández> <16/11/2017><Se estructura en tres escenarios, todos, activos e inactivos con posibilidad de filtrar por código, descripción o FinalizaEvento en cualquiera de los tres casos >
-- Modificación:	<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoEvento]
	@Codigo					smallint		= Null,
	@Descripcion			varchar(50)		= Null,
	@FinalizaEvento			bit				= Null,
	@FechaActivacion		datetime2		= Null,
	@FechaDesactivacion		datetime2		= Null	
As
BEGIN
	DECLARE @ExpresionLike varchar(270)
	Set @ExpresionLike = iif(@Descripcion is not null,'%' + @Descripcion + '%','%')

		--Todos los registros
	If	@FechaActivacion Is Null And @FechaDesactivacion Is Null 
	begin
			Select		TN_CodEstadoEvento		As Codigo,
						TC_Descripcion			As Descripcion,
						TB_FinalizaEvento		As FinalizaEvento,
						TF_Inicio_Vigencia		As FechaActivacion,
						TF_Fin_Vigencia			As FechaDesactivacion
			From		Catalogo.EstadoEvento	A With(Nolock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodEstadoEvento		= Coalesce(@Codigo,TN_CodEstadoEvento )
			And			TB_FinalizaEvento		= IsNull(@FinalizaEvento, A.TB_FinalizaEvento)
			Order By	TC_Descripcion;
	end
	--Solo Inactivos
	Else IF	@FechaActivacion Is Null And @FechaDesactivacion Is Not Null 
	begin
			Select		TN_CodEstadoEvento		As Codigo,
						TC_Descripcion			As Descripcion,
						TB_FinalizaEvento		As FinalizaEvento,
						TF_Inicio_Vigencia		As FechaActivacion,
						TF_Fin_Vigencia			As FechaDesactivacion
			From		Catalogo.EstadoEvento	A With(Nolock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodEstadoEvento		= Coalesce(@Codigo,TN_CodEstadoEvento )
			And			TB_FinalizaEvento		= IsNull(@FinalizaEvento, A.TB_FinalizaEvento)
			And			(TF_Inicio_Vigencia		> GETDATE ()
			Or  		TF_Fin_Vigencia			< GETDATE ())
			Order By	TC_Descripcion;
	end
	--Solo Activos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null 
	begin
			Select		TN_CodEstadoEvento		As Codigo,
						TC_Descripcion			As Descripcion,
						TB_FinalizaEvento		As FinalizaEvento,
						TF_Inicio_Vigencia		As FechaActivacion,
						TF_Fin_Vigencia			As FechaDesactivacion
			From		Catalogo.EstadoEvento	A With(Nolock)
			Where		dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TN_CodEstadoEvento		= Coalesce(@Codigo,TN_CodEstadoEvento )
			And			TB_FinalizaEvento		= IsNull(@FinalizaEvento, A.TB_FinalizaEvento)			
			And			TF_Inicio_Vigencia		< GETDATE ()
			And			(TF_Fin_Vigencia		is null or TF_Fin_Vigencia  >= GETDATE ())
			Order By	TC_Descripcion;
	end
	
END
GO
