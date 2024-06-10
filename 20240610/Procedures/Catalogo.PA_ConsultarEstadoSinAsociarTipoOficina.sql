SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:			<Andrés Díaz>
-- Fecha de creación:	<10/05/2018>
-- Descripción :		<Consulta los estados que no se encuentran asociados a un tipo de oficina en la tabla Catalogo.TipoOficinaEstado> 
-- =================================================================================================================================================
-- Modificación:		
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarEstadoSinAsociarTipoOficina]
    @CodTipoOficina				smallint		,
	@DescripcionEstado			varchar(150)	= Null,
	@IndicePagina				smallint		= Null,
	@CantidadPagina				smallint		= Null
As
Begin

	DECLARE @ExpresionLike varchar(300) = iIf(@DescripcionEstado Is Not Null,'%' + dbo.FN_RemoverTildes(@DescripcionEstado) + '%','%');

	If (@IndicePagina Is Null Or @CantidadPagina Is Null)
	Begin
		SET @IndicePagina = 0;
		SET @CantidadPagina = 32767;
	End

	DECLARE @Contador AS INT = NULL;

	Select		@Contador = COUNT(*)
	From		Catalogo.TipoOficinaMateria		A With(NoLock)
	Where		TN_CodTipoOficina				= @CodTipoOficina
	Group By	A.TN_CodTipoOficina;

	SELECT		A.TN_CodEstado					AS	Codigo, 
				A.TC_Descripcion				AS	Descripcion, 
				A.TF_Inicio_Vigencia			AS	FechaActivacion, 
				A.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'Split'							AS	Split,
				COUNT(*) OVER()					AS	Total
	FROM		Catalogo.Estado					AS	A WITH (Nolock)
	WHERE		dbo.FN_RemoverTildes(A.TC_Descripcion)
												Like @ExpresionLike
	AND			TN_CodEstado					Not In (
														Select		A.TN_CodEstado
														From		Catalogo.TipoOficinaEstado			AS A WITH (Nolock) 
														Where		TN_CodTipoOficina					= @CodTipoOficina
														Group By	A.TN_CodEstado, A.TN_CodTipoOficina
														Having		COUNT(*) = @Contador
														)
	AND			A.TF_Inicio_Vigencia			<= GETDATE()
	AND			(A.TF_Fin_Vigencia				Is Null Or A.TF_Fin_Vigencia >= GETDATE())
	ORDER BY	A.TC_Descripcion
	Offset		@IndicePagina * @CantidadPagina Rows
	Fetch Next	@CantidadPagina Rows Only;
	
End
GO
