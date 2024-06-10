SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:				<Andrés Díaz>
-- Fecha de creación:		<16/09/2016>
-- Descripción:				<Permite consultar los motivos de estado de evento.>
--
-- Modificación:			<2017/05/26><Andrés Díaz><Se cambia el tipo del parámetro código de int a smallint.>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- Modificación:			<22/01/2021> <Roger Lara> <Se elimina join para ligar el motivo con estado>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarMotivoEstadoEvento]
	@CodMotivoEstado			smallint		= Null,
	@Descripcion				varchar(150)	= Null,			
	@FechaActivacion			datetime2		= Null,
	@FechaDesactivacion			datetime2		= Null
AS
BEGIN
	DECLARE @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%');

	--Todos
	If  (@FechaActivacion Is Null) And (@FechaDesactivacion Is Null) And (@CodMotivoEstado Is Null)
	Begin
		Select		A.TN_CodMotivoEstado			As	Codigo,
					A.TC_Descripcion				As	Descripcion,		
					A.TF_Inicio_Vigencia			As	FechaActivacion,
					A.TF_Fin_Vigencia				As	FechaDesactivacion
		From		Catalogo.MotivoEstadoEvento		A With(NoLock)
		Where 		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		Order By	A.TC_Descripcion;
	End
	 
	--Por Llave
	Else If  (@CodMotivoEstado Is Not Null)
	Begin
		Select		A.TN_CodMotivoEstado			As	Codigo,
					A.TC_Descripcion				As	Descripcion,		
					A.TF_Inicio_Vigencia			As	FechaActivacion,
					A.TF_Fin_Vigencia				As	FechaDesactivacion
		From		Catalogo.MotivoEstadoEvento		A With(NoLock)
		Where		A.TN_CodMotivoEstado			= @CodMotivoEstado
		Order By	A.TC_Descripcion;
	End
	
	--Por activos
	Else If (@FechaActivacion Is Not Null) And (@FechaDesactivacion Is Null)
	Begin
		Select		A.TN_CodMotivoEstado			As	Codigo,
					A.TC_Descripcion				As	Descripcion,		
					A.TF_Inicio_Vigencia			As	FechaActivacion,
					A.TF_Fin_Vigencia				As	FechaDesactivacion
		From		Catalogo.MotivoEstadoEvento		A With(NoLock)
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			A.TF_Inicio_Vigencia			< GETDATE ()
		And			(A.TF_Fin_Vigencia Is Null OR A.TF_Fin_Vigencia >= GETDATE ())
		Order By	A.TC_Descripcion;
	End

	--Por inactivos
	Else if (@FechaActivacion Is Null) And (@FechaDesactivacion Is Not Null)
	Begin
		Select		A.TN_CodMotivoEstado			As	Codigo,
					A.TC_Descripcion				As	Descripcion,		
					A.TF_Inicio_Vigencia			As	FechaActivacion,
					A.TF_Fin_Vigencia				As	FechaDesactivacion
		From		Catalogo.MotivoEstadoEvento		A With(NoLock)
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			(A.TF_Inicio_Vigencia			> GETDATE ()
		Or			A.TF_Fin_Vigencia				< GETDATE ())
		Order By	A.TC_Descripcion;
	End
	
	--Por inactivos por fechas
	Else if (@FechaActivacion Is Not Null) And (@FechaDesactivacion Is Not Null)
	Begin
		Select		A.TN_CodMotivoEstado			As	Codigo,
					A.TC_Descripcion				As	Descripcion,		
					A.TF_Inicio_Vigencia			As	FechaActivacion,
					A.TF_Fin_Vigencia				As	FechaDesactivacion
		From		Catalogo.MotivoEstadoEvento		A With(NoLock)
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			(A.TF_Fin_Vigencia > @FechaActivacion And A.TF_Fin_Vigencia < @FechaDesactivacion)
		Order By	A.TC_Descripcion;
	End
END

GO
