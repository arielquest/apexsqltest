SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<21/08/2015>
-- Descripción :			<Permite Consultar las clases de asuntos asociadas a un tipo de oficina 
-- =================================================================================================================================================
-- Modificación:			<10/11/2013> <Roger Lara> <se modifico para que devuelva un split>
-- Modificación:			<17/12/2015> <Alejandro Villalta> <Autogenerar el codigo de clase de asunto, de varchar a int>
-- Modificación:			<18/12/2015> <Alejandro Villalta> <Autogenerar el codigo del tipo de oficina>
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<12/07/2017> <Jeffry Hernández> <Se agregan los datos de la materia.>
--
-- Modificación:			<04/01/2018> <Andrés Díaz> <Se simplifica el PA a una sola consulta. Se tabula el PA.>
-- Modificación:			<09/10/2018> <Andrés Díaz> <Se resuelve error en la consulta.>
-- Modificado:				<Johan Acosta Ibañez><05/11/2018><Se agrega el campo CostasPersonales>
-- Modificación:			<Jonathan Aguilar Navarro> <30/01/2018> <Se cambia el nombre del SP, se cambia la relacion con la tabla ClaseAsunto por Clase>
-- Modificación:			<Jonathan Aguiar Navarro><06/04/2021><Se modifica la consulta para que tome en cuenta las fechas TF_Inicio_Vigencia y TF_Fin_Vigencia>
--							<de la clase y la TF_Inicio_Vigencia de la tabla ClaseTipoOficina>
-- Modificado:				<Oscar Sánchez><31/01/2023><Se modifica procedimiento para no tomar en cuenta fechas de activacion en el filtrado de clases de expedientes>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarTipoOficinaClase]
   @CodTipoOficina	   smallint	   = Null,
   @CodClase	       int		   = Null,
   @FechaAsociacion	   Datetime2   = Null,
   @CodMateria         Varchar(5)  = Null,
   @MostrarNoVigente   bit         =  0
As
Begin

 IF @MostrarNoVigente = 0
 BEGIN
	SELECT		A.TF_Inicio_Vigencia				AS	FechaAsociacion, 
				A.TB_CostasPersonales				As	CostasPersonales,				
				B.TN_CodClase						AS	Codigo, 
				B.TC_Descripcion					AS	Descripcion, 
				B.TF_Inicio_Vigencia				AS	FechaActivacion, 
				B.TF_Fin_Vigencia					AS	FechaDesactivacion,
				'Split_TipoOficina'					AS	Split_TipoOficina, 
				C.TN_CodTipoOficina					AS	Codigo, 
				C.TC_Descripcion					AS	Descripcion, 
				C.TF_Inicio_Vigencia				AS	FechaActivacion, 
				C.TF_Fin_Vigencia					AS	FechaDesactivacion,
				'SplitMateria'						AS	SplitMateria,
				D.TC_CodMateria						AS	Codigo,				
				D.TC_Descripcion					AS	Descripcion,
				D.TB_EjecutaRemate					AS	EjecutaRemate,
				D.TF_Inicio_Vigencia				AS	FechaActivacion,	
				D.TF_Fin_Vigencia					AS	FechaDesactivacion

	FROM		Catalogo.ClaseTipoOficina			AS	A WITH (Nolock) 
	INNER JOIN	Catalogo.Clase						AS	B WITH (Nolock)
	ON			B.TN_CodClase						=	A.TN_CodClase
	INNER JOIN	Catalogo.TipoOficina				AS	C WITH (Nolock)
	ON			C.TN_CodTipoOficina					=	A.TN_CodTipoOficina
	INNER JOIN  Catalogo.Materia					AS	D WITH (Nolock)
	ON			D.TC_CodMateria						=	A.TC_CodMateria	
			
	WHERE		A.TN_CodTipoOficina					=	COALESCE(@CodTipoOficina, A.TN_CodTipoOficina)
	AND			A.TN_CodClase						=	COALESCE(@CodClase, A.TN_CodClase)
	AND			A.TC_CodMateria						=	COALESCE(@CodMateria, A.TC_CodMateria)
	And		    B.TF_Inicio_Vigencia				<=   GETDATE ()
	And			(B.TF_Fin_Vigencia					is null or B.TF_Fin_Vigencia >= GETDATE())
	And			A.TF_Inicio_Vigencia				<= COALESCE(@FechaAsociacion,A.TF_Inicio_Vigencia)
	
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion;

	END 
	ELSE
	BEGIN
		SELECT	A.TF_Inicio_Vigencia				AS	FechaAsociacion, 
				A.TB_CostasPersonales				As	CostasPersonales,				
				B.TN_CodClase						AS	Codigo, 
				B.TC_Descripcion					AS	Descripcion, 
				B.TF_Inicio_Vigencia				AS	FechaActivacion, 
				B.TF_Fin_Vigencia					AS	FechaDesactivacion,
				'Split_TipoOficina'					AS	Split_TipoOficina, 
				C.TN_CodTipoOficina					AS	Codigo, 
				C.TC_Descripcion					AS	Descripcion, 
				C.TF_Inicio_Vigencia				AS	FechaActivacion, 
				C.TF_Fin_Vigencia					AS	FechaDesactivacion,
				'SplitMateria'						AS	SplitMateria,
				D.TC_CodMateria						AS	Codigo,				
				D.TC_Descripcion					AS	Descripcion,
				D.TB_EjecutaRemate					AS	EjecutaRemate,
				D.TF_Inicio_Vigencia				AS	FechaActivacion,	
				D.TF_Fin_Vigencia					AS	FechaDesactivacion

	FROM		Catalogo.ClaseTipoOficina			AS	A WITH (Nolock) 
	INNER JOIN	Catalogo.Clase						AS	B WITH (Nolock)
	ON			B.TN_CodClase						=	A.TN_CodClase
	INNER JOIN	Catalogo.TipoOficina				AS	C WITH (Nolock)
	ON			C.TN_CodTipoOficina					=	A.TN_CodTipoOficina
	INNER JOIN  Catalogo.Materia					AS	D WITH (Nolock)
	ON			D.TC_CodMateria						=	A.TC_CodMateria	
			
	WHERE		A.TN_CodTipoOficina					=	COALESCE(@CodTipoOficina, A.TN_CodTipoOficina)
	AND			A.TN_CodClase						=	COALESCE(@CodClase, A.TN_CodClase)
	AND			A.TC_CodMateria						=	COALESCE(@CodMateria, A.TC_CodMateria)
	
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion;
	END

END
GO
