SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Olger Ariel Gamboa C>
-- Fecha de creación:		<12/08/2015>
-- Descripción :			<Permite Consultar un Estado> 
-- =================================================================================================================================================
-- ModIficado por:			<Henry MEndez Chavarria>
-- Modificado :				<Olger Gamboa Castillo, 17/12/2015, Se modifica el tipo de dato del codigo de estado a smallint.> 
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificado:				<29/11/2017> <Ailyn López><Se llama a la función dbo.FN_RemoverTildes>
-- Modificación:			<11/05/2018> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores paginados.>
-- Modificación:			<22/02/2019> <Jonathan Aguilar Navarro> <Se agrega a la consulta los valores para enumeradores ExpedienteLegajo,Circulante y Pasivo>
-- Modificación:			<04/05/2021> <Karol Jiménez S.> <Se cambia parámetro CodEstado para que sea int y no smallint, por cambio en tabla Catalogo.Estado>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstado]
	@CodEstado			int				= Null,
	@Descripcion		varchar(150)	= Null,			
	@FechaActivacion	datetime2		= Null,
	@FechaDesactivacion datetime2		= Null,
	@IndicePagina		smallint		= Null,
	@CantidadPagina		smallint		= Null,
	@ExpedienteLegajo	varchar(1)		= Null,
	@Circulante			varchar(1)		= Null,
	@Pasivo				varchar(1)		= Null
As
Begin
	
	DECLARE @ExpresionLike varchar(200) = iIf(@Descripcion Is Not Null,'%' + @Descripcion + '%','%');
	If (@IndicePagina Is Null Or @CantidadPagina Is Null)
	Begin
		SET @IndicePagina = 0;
		SET @CantidadPagina = 32767;
	End
	
	--Activos e inactivos
	If  @FechaActivacion Is Null And  @FechaDesactivacion Is Null 
	Begin
			Select		A.TN_CodEstado			As	Codigo,				
						A.TC_Descripcion		As	Descripcion,
						A.TF_Inicio_Vigencia	As	FechaActivacion,	
						A.TF_Fin_Vigencia		As	FechaDesactivacion,
						'Split'					As	Split,
						COUNT(*) OVER()			As	Total,
						A.TC_ExpedienteLegajo	As	ExpedienteLegajo,
						A.TC_Circulante			As	Circulante,
						A.TC_Pasivo				As  Pasivo
						
			From		Catalogo.Estado			A	With(NoLock)			
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion)
												like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodEstado			=	Coalesce(@CodEstado,A.TN_CodEstado) 
			And			A.TC_ExpedienteLegajo	=	Coalesce (@ExpedienteLegajo,A.TC_ExpedienteLegajo)
			And			A.TC_Circulante			=	Coalesce (@Circulante,A.TC_Circulante)
			And			Coalesce(A.TC_Pasivo,'')	=	Coalesce (@Pasivo,A.TC_Pasivo,'')
			
			Order By	A.TC_Descripcion
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
	End
	 
	--Activos
	Else If  @FechaActivacion Is Not Null And  @FechaDesactivacion Is Null 
	Begin
			Select		A.TN_CodEstado			As	Codigo,				
						A.TC_Descripcion		As	Descripcion,
						A.TF_Inicio_Vigencia	As	FechaActivacion,	
						A.TF_Fin_Vigencia		As	FechaDesactivacion,						
						'Split'					As	Split,
						COUNT(*) OVER()			As	Total,
						A.TC_ExpedienteLegajo	As	ExpedienteLegajo,
						A.TC_Circulante			As	Circulante,
						A.TC_Pasivo				As  Pasivo
						
			From		Catalogo.Estado			A	With(NoLock)
			
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion) 
												like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodEstado			=	Coalesce(@CodEstado,A.TN_CodEstado) 
			And			A.TF_Inicio_Vigencia	<=	GETDATE ()
			And			(A.TF_Fin_Vigencia		Is	Null OR A.TF_Fin_Vigencia  >= GETDATE ())
			And			A.TC_ExpedienteLegajo	=	Coalesce (@ExpedienteLegajo,A.TC_ExpedienteLegajo)
			And			A.TC_Circulante			=	Coalesce (@Circulante,A.TC_Circulante)
			And			Coalesce(A.TC_Pasivo,'')	=	Coalesce (@Pasivo,A.TC_Pasivo,'')
			
			Order By	A.TC_Descripcion
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
	End
	
	--Inactivos
	Else If  @FechaActivacion Is Null And @FechaDesactivacion Is Not Null
	Begin
			Select		A.TN_CodEstado			As	Codigo,				
						A.TC_Descripcion		As	Descripcion,
						A.TF_Inicio_Vigencia	As	FechaActivacion,	
						A.TF_Fin_Vigencia		As	FechaDesactivacion,
						'Split'					As	Split,
						COUNT(*) OVER()			As	Total,
						A.TC_ExpedienteLegajo	As	ExpedienteLegajo,
						A.TC_Circulante			As	Circulante,
						A.TC_Pasivo				As  Pasivo
						
			From		Catalogo.Estado			A	With(NoLock)			
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion)
												like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodEstado			= Coalesce(@CodEstado,A.TN_CodEstado) 
			And			(A.TF_Inicio_Vigencia 	>	GETDATE () 
			Or			A.TF_Fin_Vigencia		<	GETDATE ())
			And			A.TC_ExpedienteLegajo	=	Coalesce (@ExpedienteLegajo,A.TC_ExpedienteLegajo)
			And			A.TC_Circulante			=	Coalesce (@Circulante,A.TC_Circulante)
			And			Coalesce(A.TC_Pasivo,'')	=	Coalesce (@Pasivo,A.TC_Pasivo,'')
			
			Order By	A.TC_Descripcion
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
	End

	--Por rango de fechas
	Else If @FechaActivacion Is Not Null And @FechaDesactivacion Is Not Null		
	Begin
			Select		A.TN_CodEstado			As	Codigo,				
						A.TC_Descripcion		As	Descripcion,
						A.TF_Inicio_Vigencia	As	FechaActivacion,	
						A.TF_Fin_Vigencia		As	FechaDesactivacion,
						'Split'					As	Split,
						COUNT(*) OVER()			As	Total,
						A.TC_ExpedienteLegajo	As	ExpedienteLegajo,
						A.TC_Circulante			As	Circulante,
						A.TC_Pasivo				As  Pasivo
						
			From		Catalogo.Estado			A	With(NoLock)			
			Where		dbo.FN_RemoverTildes(A.TC_Descripcion)
												like dbo.FN_RemoverTildes(@ExpresionLike)
			And			A.TN_CodEstado			= Coalesce(@CodEstado,A.TN_CodEstado) 
			And			(A.TF_Inicio_Vigencia	>= @FechaActivacion
			And			A.TF_Fin_Vigencia		<= @FechaDesactivacion)
			And			A.TC_ExpedienteLegajo	=	Coalesce (@ExpedienteLegajo,A.TC_ExpedienteLegajo)
			And			A.TC_Circulante			=	Coalesce (@Circulante,A.TC_Circulante)
			And			Coalesce(A.TC_Pasivo,'')	=	Coalesce (@Pasivo,A.TC_Pasivo,'')
			
			Order By	A.TC_Descripcion
			Offset		@IndicePagina * @CantidadPagina Rows
			Fetch Next	@CantidadPagina Rows Only;
	End	
	
END	
GO
