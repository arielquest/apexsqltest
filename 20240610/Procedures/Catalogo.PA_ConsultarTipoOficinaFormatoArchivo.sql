SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================
-- Autor:				<Pablo Alvarez>
-- Fecha Creación:		<19 de febrero de 2016.>
-- Descripcion:			<Permite Consultar un tipo FormatoArchivo>
-- Modificación:		<Andrés Díaz>
-- Fecha Modificación:	<01 de abril de 2016.>
-- Descripcion:			<Se agrega el campo TC_Extensiones>
-- Modificación:		<Esteban Cordero Benavides.>
-- Fecha Modificación:	<04 de abril de 2016.>
-- Descripcion:			<Se Modifica todo el procedimiento para que se refiera a FormatoArchivo y no a TipoArchivo.>
--
-- Modificación:		<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
--
-- Modificación:		<04/01/2018> <Andrés Díaz> <Se simplifica el PA a una sola consulta. Se tabula el PA.>
-- =================================================================================================================
CREATE Procedure [Catalogo].[PA_ConsultarTipoOficinaFormatoArchivo]
	@TN_CodFormatoArchivo	SmallInt	= Null,
	@TN_CodTipoOficina		Int			= Null,
	@TF_Inicio_Vigencia		DateTime2	= Null
As
Begin

		Select		A.TF_Inicio_Vigencia					AS	FechaAsociacion, 		
					B.TN_CodFormatoArchivo					AS	Codigo,
					B.TC_Descripcion						AS	Descripcion, 
					B.TF_Inicio_Vigencia					AS	FechaActivacion,
					B.TF_Fin_Vigencia						AS	FechaDesactivacion,
					A.TN_LimiteSubida						AS	LimiteSubida,
					A.TN_LimiteSubidaMasivo					AS	LimiteSubidaMasivo,
					A.TN_LimiteDescargaMasivo				AS	LimiteDescargaMasivo,
					'Split_TipoOficina'						AS	Split_TipoOficina, 
					C.TN_CodTipoOficina						AS	Codigo,
					C.TC_Descripcion						AS	Descripcion,
					C.TF_Inicio_Vigencia					AS	FechaActivacion,
					C.TF_Fin_Vigencia						AS	FechaDesactivacion

		From		Catalogo.TipoOficinaFormatoArchivo		AS	A With(NoLock) 
		Inner Join	Catalogo.FormatoArchivo					AS	B With(NoLock)
		On			B.TN_CodFormatoArchivo 					=	A.TN_CodFormatoArchivo 
		Inner Join	Catalogo.TipoOficina					AS	C With(NoLock)
		On			C.TN_CodTipoOficina						=	A.TN_CodTipoOficina

		Where		(A.TN_CodTipoOficina					=	@TN_CodFormatoArchivo
		Or			A.TN_CodFormatoArchivo					=	@TN_CodTipoOficina) 
		And			A.TF_Inicio_Vigencia					<=	CASE WHEN @TF_Inicio_Vigencia IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
		Order By	B.TC_Descripcion, C.TC_Descripcion;

End
GO
