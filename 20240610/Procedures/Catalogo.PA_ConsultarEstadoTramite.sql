SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<19/02/2016>
-- Descripción :			<Permite Consultar un tipo EstadoTramite> 
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
--
-- Modificación:			<2017-11-23> <Andrés Díaz> <Se simplifica el PA a cuatro consultas. Se tabula todo el PA.>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoTramite]
	@Codigo				smallint		= Null,
	@Descripcion		varchar(50)		= Null,
	@FechaActivacion	datetime2(3)	= Null,
	@FechaDesactivacion	datetime2(3)	= Null
 As
Begin
	--Variable para almacenar la descripcion 
	Declare @ExpresionLike Varchar(200) = iif(@Descripcion Is Not Null,'%' + @Descripcion + '%','%');
	
	--Todos
	If	@FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin	
			Select		TN_CodEstadoTramite		As	Codigo,
						TC_Descripcion			As	Descripcion,
						TF_Inicio_Vigencia		As	FechaActivacion,
						TF_Fin_Vigencia			As	FechaDesactivacion
			From		Catalogo.EstadoTramite	With(Nolock)
			Where		TN_CodEstadoTramite		= COALESCE(@Codigo, TN_CodEstadoTramite)
			And			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			Order By	TC_Descripcion;
	End

	--Activos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
			Select		TN_CodEstadoTramite		As	Codigo,
						TC_Descripcion			As	Descripcion,
						TF_Inicio_Vigencia		As	FechaActivacion,
						TF_Fin_Vigencia			As	FechaDesactivacion
			From		Catalogo.EstadoTramite	With(Nolock)
			Where		TN_CodEstadoTramite		= COALESCE(@Codigo, TN_CodEstadoTramite)
			And			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia		< GETDATE()
			And			(TF_Fin_Vigencia		Is Null Or TF_Fin_Vigencia >= GETDATE())
			Order By	TC_Descripcion;
	End

	--Inactivos
	Else If @FechaActivacion Is Null And @FechaDesactivacion Is Not Null
	Begin
			Select		TN_CodEstadoTramite		As	Codigo,
						TC_Descripcion			As	Descripcion,
						TF_Inicio_Vigencia		As	FechaActivacion,
						TF_Fin_Vigencia			As	FechaDesactivacion
			From		Catalogo.EstadoTramite	With(Nolock)
			Where		TN_CodEstadoTramite		= COALESCE(@Codigo, TN_CodEstadoTramite)
			And			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia		> GETDATE() Or TF_Fin_Vigencia < GETDATE())
			Order By	TC_Descripcion;
	End

	--Rango de fechas
	Else If @FechaDesactivacion Is Not Null And @FechaActivacion Is Not Null
	Begin
			Select		TN_CodEstadoTramite		As	Codigo,
						TC_Descripcion			As	Descripcion,
						TF_Inicio_Vigencia		As	FechaActivacion,
						TF_Fin_Vigencia			As	FechaDesactivacion
			From		Catalogo.EstadoTramite	With(Nolock)
			Where		TN_CodEstadoTramite		= COALESCE(@Codigo, TN_CodEstadoTramite)
			And			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia		>= @FechaActivacion
			And			TF_Fin_Vigencia			<= @FechaDesactivacion 
			Order By	TC_Descripcion;
	End

End
GO
