SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================================================================
-- Autor:			<Jeffry Hernández>
-- Fecha Creación:	<9/08/2017>
-- Descripcion:		<Consulta los procedimientos que podrían ser asociados a un formato jurídico>
--==============================================================================================
-- Modificado:		<28/11/2017> <Ailyn López> <Se modifica el nombre del procedimiento> 
-- Modificado:		<13/04/2018> <Diego Navarrete> <Se agregan los Split nuevamente y el comando (NoLock)>
-- Modificado:		<07/02/2019> <Isaac Dobles> <Se cambia nombre a PA_ConsultarFormatoJuridicoProcesoAsociables y direcciona a tabla Catalogo.Proceso >    
-- =============================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarFormatoJuridicoProcesoAsociables] 

AS
BEGIN

	DECLARE @FechaDeHoy Datetime2 = Getdate();  
        
	SELECT	C.TN_CodProceso			AS	Codigo,				C.TC_Descripcion		AS	Descripcion, 
			C.TF_Inicio_Vigencia	AS	FechaActivacion,	C.TF_Fin_Vigencia		AS	FechaDesactivacion,
			'SplitClase'			AS	SplitClase,	
			D.TN_CodClase			AS	Codigo,				D.TC_Descripcion		AS	Descripcion,		
			D.TF_Inicio_Vigencia	AS	FechaActivacion,	D.TF_Fin_Vigencia		AS	FechaDesactivacion, 
			'SplitTipoOficina'		AS	SplitTipoOficina,
			E.TN_CodTipoOficina		AS	Codigo,				E.TC_Descripcion		AS	Descripcion, 
			E.TF_Inicio_Vigencia	AS	FechaActivacion,	E.TF_Fin_Vigencia		AS	FechaDesactivacion,
			'SplitMateria'			AS	SplitMateria,		F.TC_CodMateria			AS	Codigo,				
			F.TC_Descripcion		AS	Descripcion,		F.TB_EjecutaRemate		AS	EjecutaRemate,
			F.TF_Inicio_Vigencia	AS	FechaActivacion,	F.TF_Fin_Vigencia		AS	FechaDesactivacion			
			
	FROM		Catalogo.ClaseProceso				AS	A With(Nolock)
	Inner Join	Catalogo.ClaseTipoOficina			AS	B With(Nolock)
	On			A.TN_CodClase						=	B.TN_CodClase	
	Inner Join	Catalogo.Proceso					AS	C With(Nolock)
	On			A.TN_CodProceso						=	C.TN_CodProceso
	Inner Join	Catalogo.Clase						AS	D With(Nolock)
	On			A.TN_CodClase						=	D.TN_CodClase
	Inner Join	Catalogo.TipoOficina				AS	E With(Nolock)
	On			B.TN_CodTipoOficina					=	E.TN_CodTipoOficina
	Inner Join	Catalogo.Materia					AS	F With(Nolock)
	On			B.TC_CodMateria						=	F.TC_CodMateria

	Where		A.TF_Inicio_Vigencia <= @FechaDeHoy
	And			B.TF_Inicio_Vigencia <= @FechaDeHoy

END
GO
