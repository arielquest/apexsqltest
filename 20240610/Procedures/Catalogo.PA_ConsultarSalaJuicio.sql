SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<03/11/2016>
-- Descripción :			<Permite consultar registros de Catalogo.SalaJuicio.> 
-- Modificación:			<04/10/2014><Diego Navarrete><Se elimo la consulta por codigo, pero se agrego a las demas consultas>
-- Modificación:			<15/12/2017> <Ailyn López> <Se ajusta para que al filtrar por descripción se ignoren los acentos>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarSalaJuicio]
	@CodSala				smallint		= Null,
	@CodCircuito			smallint		= Null,
	@Descripcion			varchar(255)	= Null,
	@Habilitada				bit				= Null,
	@FechaActivacion		datetime2		= Null,
	@FechaDesactivacion		datetime2		= Null
 As
 Begin
 
	Declare @ExpresionLike varchar(257) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%')

	--Todos
	If @FechaActivacion Is Null And @FechaActivacion Is Null And @FechaDesactivacion Is Null
	Begin
		Select		A.TN_CodSala			As Codigo,
					A.TC_Descripcion		As Descripcion,
					A.TC_Observaciones		As Observaciones,
					A.TN_Capacidad			As Capacidad,
					A.TB_Habilitada			As Habilitada,
					A.TF_Inicio_Vigencia	As FechaActivacion,
					A.TF_Fin_Vigencia		As FechaDesactivacion,
					'Split'					As Split,
					B.TN_CodCircuito		As Codigo,
					B.TC_Descripcion		As Descripcion
		From		Catalogo.SalaJuicio		A With(NoLock)
		Inner Join	Catalogo.Circuito		B With(NoLock)
		On			B.TN_CodCircuito		= A.TN_CodCircuito
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			A.TN_CodCircuito		= ISNULL(@CodCircuito, A.TN_CodCircuito)
		And			A.TB_Habilitada			= ISNULL(@Habilitada, A.TB_Habilitada)
		And			A.TN_CodSala			= Coalesce(@CodSala,A.TN_CodSala)
		Order By	A.TC_Descripcion;
	End
	--Por activos y filtro por descripcion
	Else If  @FechaActivacion Is Not Null And @FechaDesactivacion Is Null
	Begin
		Select		A.TN_CodSala			As Codigo,
					A.TC_Descripcion		As Descripcion,
					A.TC_Observaciones		As Observaciones,
					A.TN_Capacidad			As Capacidad,
					A.TB_Habilitada			As Habilitada,
					A.TF_Inicio_Vigencia	As FechaActivacion,
					A.TF_Fin_Vigencia		As FechaDesactivacion,
					'Split'					As Split,
					B.TN_CodCircuito		As Codigo,
					B.TC_Descripcion		As Descripcion
		From		Catalogo.SalaJuicio		A With(NoLock)
		Inner Join	Catalogo.Circuito		B With(NoLock)
		On			B.TN_CodCircuito		= A.TN_CodCircuito
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			A.TF_Inicio_Vigencia	< GETDATE ()
		And			(A.TF_Fin_Vigencia		Is Null Or A.TF_Fin_Vigencia >= GETDATE())
		And			A.TN_CodCircuito		= ISNULL(@CodCircuito, A.TN_CodCircuito)
		And			A.TB_Habilitada			= ISNULL(@Habilitada, A.TB_Habilitada)
		And			A.TN_CodSala			= Coalesce(@CodSala,A.TN_CodSala)
		Order By	A.TC_Descripcion;
	End
	
	--Por inactivos y filtro por descripcion
	Else IF @FechaActivacion Is Null And @FechaDesactivacion Is Not Null		
	Begin
		Select		A.TN_CodSala			As Codigo,
					A.TC_Descripcion		As Descripcion,
					A.TC_Observaciones		As Observaciones,
					A.TN_Capacidad			As Capacidad,
					A.TB_Habilitada			As Habilitada,
					A.TF_Inicio_Vigencia	As FechaActivacion,
					A.TF_Fin_Vigencia		As FechaDesactivacion,
					'Split'					As Split,
					B.TN_CodCircuito		As Codigo,
					B.TC_Descripcion		As Descripcion
		From		Catalogo.SalaJuicio		A With(NoLock)
		Inner Join	Catalogo.Circuito		B With(NoLock)
		On			B.TN_CodCircuito		= A.TN_CodCircuito
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
	    And			(A.TF_Inicio_Vigencia	> GETDATE() Or A.TF_Fin_Vigencia < GETDATE())
		And			A.TN_CodCircuito		= ISNULL(@CodCircuito, A.TN_CodCircuito)
		And			A.TB_Habilitada			= ISNULL(@Habilitada, A.TB_Habilitada)
		And			A.TN_CodSala			= Coalesce(@CodSala,A.TN_CodSala)
		Order By	A.TC_Descripcion;
	End

	 --Si las dos fechas no son nulas listar los datos por rango de fechas de los inactivos
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
	Begin
		Select		A.TN_CodSala			As Codigo,
					A.TC_Descripcion		As Descripcion,
					A.TC_Observaciones		As Observaciones,
					A.TN_Capacidad			As Capacidad,
					A.TB_Habilitada			As Habilitada,
					A.TF_Inicio_Vigencia	As FechaActivacion,
					A.TF_Fin_Vigencia		As FechaDesactivacion,
					'Split'					As Split,
					B.TN_CodCircuito		As Codigo,
					B.TC_Descripcion		As Descripcion
		From		Catalogo.SalaJuicio		A With(NoLock)
		Inner Join	Catalogo.Circuito		B With(NoLock)
		On			B.TN_CodCircuito		= A.TN_CodCircuito
		Where		dbo.FN_RemoverTildes(A.TC_Descripcion) Like dbo.FN_RemoverTildes(@ExpresionLike)
		And			(A.TF_Fin_Vigencia		<= @FechaDesactivacion And A.TF_Inicio_Vigencia >= @FechaActivacion)
		And			A.TN_CodCircuito		= ISNULL(@CodCircuito, A.TN_CodCircuito)
		And			A.TB_Habilitada			= ISNULL(@Habilitada, A.TB_Habilitada)
		And			A.TN_CodSala			= Coalesce(@CodSala,A.TN_CodSala)
		Order By	A.TC_Descripcion;
	End
			
 End



GO
