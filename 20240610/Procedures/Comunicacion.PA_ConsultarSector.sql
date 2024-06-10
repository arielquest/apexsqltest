SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Andrés Díaz Buján>
-- Fecha de creación:		<20/01/2017>
-- Descripción :			<Permite consultar registros de Comunicacion.Sector.> 
-- =================================================================================================================================================
-- Modificado:				<Cristian Cerdas Camacho><20/07/2021><Se agrega en la consulta si el sector puede utiliza aplicación móvil.>
-- Modificado:				<Isaac Dobles Mata><05/10/2021><Se agrega filtro para consultar todos los sectores activos que usan AppMovil únicamente.>
-- Modificado:				<Fernando Mendez Diaz><09/05/2023><Se modifica el sp para ajustar el filtrado>
-- =================================================================================================================================================
CREATE   PROCEDURE [Comunicacion].[PA_ConsultarSector]
	@CodSector				smallint		= Null,
	@Descripcion			varchar(100)	= Null,
	@CodOficinaOCJ			varchar(4)		= Null,
	@FechaActivacion		datetime2		= Null,
	@FechaDesactivacion		datetime2		= Null,
	@UtilizaAppMovil		bit				= Null
 As
 Begin
	Declare @ExpresionLike varchar(500) = '%' + lower(@Descripcion) + '%'

	Select		
		A.TN_CodSector			As Codigo,
		A.TC_Descripcion		As Descripcion,
		A.TF_Inicio_Vigencia	As FechaActivacion,
		A.TF_Fin_Vigencia		As FechaDesactivacion,
		A.TB_UtilizaAppMovil    AS UtilizaAppMovil,
		'Split'					As Split,
		B.TC_CodOficina			As Codigo,
		B.TC_Nombre				As Descripcion
		From		Comunicacion.Sector		A With(NoLock)
		Inner Join	Catalogo.Oficina		B With(NoLock)
		On			B.TC_CodOficina			= A.TC_CodOficinaOCJ
		WHERE
		(A.TN_CodSector = COALESCE(@CodSector, A.TN_CodSector))
		AND (@Descripcion IS NULL OR dbo.FN_RemoverTildes(lower(A.TC_Descripcion)) like dbo.FN_RemoverTildes(@ExpresionLike))
		AND (A.TC_CodOficinaOCJ = COALESCE(@CodOficinaOCJ, A.TC_CodOficinaOCJ))
		AND (
			(@FechaActivacion IS NULL AND @FechaDesactivacion IS NULL)
			OR
			(@FechaActivacion IS NOT NULL AND @FechaDesactivacion IS NULL 
			AND A.TF_Inicio_Vigencia <= @FechaActivacion AND (A.TF_Fin_Vigencia IS NULL OR A.TF_Fin_Vigencia >= @FechaActivacion))
			OR
			(@FechaActivacion IS NULL AND @FechaDesactivacion IS NOT NULL 
			AND A.TF_Fin_Vigencia < @FechaDesactivacion OR A.TF_Inicio_Vigencia > @FechaDesactivacion)
			OR
			(@FechaActivacion IS NOT NULL AND @FechaDesactivacion IS NOT NULL 
			AND A.TF_Inicio_Vigencia >= @FechaActivacion AND (A.TF_Fin_Vigencia IS NULL OR A.TF_Fin_Vigencia <= @FechaDesactivacion))
			)
 End
GO
