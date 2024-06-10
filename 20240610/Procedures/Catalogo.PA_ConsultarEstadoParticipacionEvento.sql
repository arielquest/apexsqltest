SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<09/09/2016>
-- Descripción:				<Permite consultar los estados del participante del evento.>
--
-- Modificación:			<2017-11-23> <Andrés Díaz> <Se simplifica el PA a cuatro consultas.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoParticipacionEvento]
	@CodEstadoParticipacion		int				= Null,
	@Descripcion				varchar(150)	= Null,			
	@FechaActivacion			datetime2		= Null,
	@FechaDesactivacion			datetime2		= Null
AS
BEGIN
	DECLARE @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%');

	--Todos
	If  (@FechaActivacion Is Null) And (@FechaDesactivacion Is Null)
	Begin
			Select		TN_CodEstadoParticipacion			As	Codigo,
						TC_Descripcion						As	Descripcion,		
						TF_Inicio_Vigencia					As	FechaActivacion,
						TF_Fin_Vigencia						As	FechaDesactivacion
			From		Catalogo.EstadoParticipacionEvento	With(Nolock)
			Where		TN_CodEstadoParticipacion			= COALESCE(@CodEstadoParticipacion, TN_CodEstadoParticipacion)
			And			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			Order By	TC_Descripcion;
	End

	--Activos
	Else If (@FechaActivacion Is Not Null) And (@FechaDesactivacion Is Null)
	Begin
			Select		TN_CodEstadoParticipacion			As	Codigo,
						TC_Descripcion						As	Descripcion,		
						TF_Inicio_Vigencia					As	FechaActivacion,
						TF_Fin_Vigencia						As	FechaDesactivacion
			From		Catalogo.EstadoParticipacionEvento	With(Nolock)
			Where		TN_CodEstadoParticipacion			= COALESCE(@CodEstadoParticipacion, TN_CodEstadoParticipacion)
			And			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Inicio_Vigencia					< GETDATE()
			And			(TF_Fin_Vigencia					Is Null Or TF_Fin_Vigencia >= GETDATE())
			Order By	TC_Descripcion;
	End

	--Inactivos
	Else if (@FechaActivacion Is Null) And (@FechaDesactivacion Is Not Null)
	Begin
			Select		TN_CodEstadoParticipacion			As	Codigo,
						TC_Descripcion						As	Descripcion,		
						TF_Inicio_Vigencia					As	FechaActivacion,
						TF_Fin_Vigencia						As	FechaDesactivacion
			From		Catalogo.EstadoParticipacionEvento	With(Nolock)
			Where		TN_CodEstadoParticipacion			= COALESCE(@CodEstadoParticipacion, TN_CodEstadoParticipacion)
			And			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			(TF_Inicio_Vigencia					> GETDATE() Or TF_Fin_Vigencia < GETDATE())
			Order By	TC_Descripcion;
	End
	
	--Rango de fechas
	Else if (@FechaActivacion Is Not Null) And (@FechaDesactivacion Is Not Null)
	Begin
			Select		TN_CodEstadoParticipacion			As	Codigo,
						TC_Descripcion						As	Descripcion,		
						TF_Inicio_Vigencia					As	FechaActivacion,
						TF_Fin_Vigencia						As	FechaDesactivacion
			From		Catalogo.EstadoParticipacionEvento	With(Nolock)
			Where		TN_CodEstadoParticipacion			= COALESCE(@CodEstadoParticipacion, TN_CodEstadoParticipacion)
			And			dbo.FN_RemoverTildes(TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
			And			TF_Fin_Vigencia						>= @FechaActivacion
			And			TF_Fin_Vigencia						<= @FechaDesactivacion
			Order By	TC_Descripcion;
	End
END
GO
