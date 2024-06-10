SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Creado por:			<Andrés Díaz>
-- Fecha de creación:	<10/05/2018>
-- Descripción :		<Consulta los tipos de oficina y materia que no se encuentran asociados a un estado en la tabla Catalogo.TipoOficinaEstado> 
-- =================================================================================================================================================
-- Modificación:		<06/11/2018> <Andrés Díaz> <Se renombra 'TF_InicioVigencia' a 'TF_Inicio_Vigencia'.>
-- Modificación:		<04/05/2021> <Karol Jiménez S.> <Se cambia parámetro CodEstado para que sea int y no smallint, por cambio en tabla Catalogo.Estado,
--						se corrige también por tabla que no coincidía>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoOficinaSinAsociarEstado]
	@CodEstado					int,
	@DescripcionTipoOficina		varchar(255)	= Null,
	@IndicePagina				smallint		= Null,
	@CantidadPagina				smallint		= Null
As
Begin

	DECLARE @ExpresionLike varchar(300) = iIf(@DescripcionTipoOficina Is Not Null,'%' + @DescripcionTipoOficina + '%','%');

	If (@IndicePagina Is Null Or @CantidadPagina Is Null)
	Begin
		SET @IndicePagina = 0;
		SET @CantidadPagina = 32767;
	End

	DECLARE @TablaTemp AS TABLE
	(
		TN_CodTipoOficina		smallint		NOT NULL,
		TC_CodMateria			varchar(5)		NOT NULL
	);

	INSERT INTO	@TablaTemp
	SELECT		A1.TN_CodTipoOficina, A1.TC_CodMateria
	FROM		Catalogo.TipoOficinaMateria		A1 With(NoLock)
	WHERE		A1.TF_Inicio_Vigencia			<= GETDATE()
	EXCEPT
	SELECT		A2.TN_CodTipoOficina, A2.TC_CodMateria
	FROM		Catalogo.EstadoTipoOficina		A2 With(NoLock)
	Where		A2.TN_CodEstado					= @CodEstado;

	SELECT		B.TN_CodTipoOficina				AS	Codigo, 
				B.TC_Descripcion				AS	Descripcion, 
				B.TF_Inicio_Vigencia			AS	FechaActivacion, 
				B.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'Split'							AS	Split,
				C.TC_CodMateria					AS	Codigo,				
				C.TC_Descripcion				AS	Descripcion,
				C.TB_EjecutaRemate				AS	EjecutaRemate,
				C.TF_Inicio_Vigencia			AS	FechaActivacion,	
				C.TF_Fin_Vigencia				AS	FechaDesactivacion,
				'Split'							AS	Split,
				COUNT(*) OVER()					AS	Total

	FROM		@TablaTemp						AS	A
	INNER JOIN	Catalogo.TipoOficina			AS	B WITH (Nolock)
	ON			B.TN_CodTipoOficina				=	A.TN_CodTipoOficina
	INNER JOIN  Catalogo.Materia				AS	C WITH (Nolock)
	ON			C.TC_CodMateria					=	A.TC_CodMateria	
	WHERE		dbo.FN_RemoverTildes(B.TC_Descripcion)
												like dbo.FN_RemoverTildes(@ExpresionLike)
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion
	Offset		@IndicePagina * @CantidadPagina Rows
	Fetch Next	@CantidadPagina Rows Only;

End
GO
