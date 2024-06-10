SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvare Espinoza>
-- Fecha de creación:		<4/09/2015>
-- Descripción :			<Permite Consultar las fases de una materia y las matarias ligadas a una fase.
-- =================================================================================================================================================
-- Modificación:			<02-12-2015> <Pablo Alvarez Espinoza> <Se agrega la columna por defecto>
-- Modificación:			<07/01/2016> <Alejandro Villalta> <Modificar el tipo de dato del codigo de fase.>
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<02/12/2016> <Pablo Alvarez> <Se modifica el campo TN_CodFase por estandar>
-- Modificación:			<04/01/2018> <Andrés Díaz> <Se simplifica el PA a una sola consulta. Se tabula el PA.>
-- Modificación:			<04/01/2021> <Karol Jiménez Sánchez> <Se agrega filtro por tipo de oficina, y se agregan variables para asignar parámetros>
-- Modificación:			<15/03/2021> <Fabian Sequeira> <Se agrega la fecha de activacion en la fase>
-- Modificación:			<06/04/2021><Jonathan Aguilar Navarro><Se realiza ajuste para que tome en cuenta la fecha de inicio y fin de viegencia de la fase>
--							<y la fecha de asocian de MateriaFase>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarMateriaFase]
    @CodMateria			Varchar(2)	= Null,
    @CodTipoOficina		smallint	= Null,
	@CodFase			smallint	= Null,
	@FechaAsociacion	Datetime2	= Null,
    @PorDefecto			bit			= Null
As
Begin

	--Variables.
	DECLARE	@L_TC_CodMateria		VARCHAR(5)	= @CodMateria,
			@L_TN_CodTipoOficina	SMALLINT	= @CodTipoOficina,
			@L_TN_CodFase			SMALLINT	= @CodFase,
			@L_TF_Inicio_Vigencia	DATETIME2	= @FechaAsociacion,
			@L_TB_PorDefecto		BIT			= @PorDefecto

	--Lógica.
	SELECT		A.TF_Inicio_Vigencia		AS FechaAsociacion,				 
				B.TN_CodFase				AS Codigo, 
				B.TC_Descripcion			AS Descripcion, 
				B.TF_Inicio_Vigencia		AS FechaActivacion, 
				B.TF_Fin_Vigencia			AS FechaDesactivacion,
				A.TB_PorDefecto             AS PorDefecto,
				'Split_Materia'				AS Split_Materia, 
       			C.TC_CodMateria				AS Codigo, 
				C.TC_Descripcion			AS Descripcion, 
				C.TF_Inicio_Vigencia		AS FechaActivacion, 
				C.TF_Fin_Vigencia			AS FechaDesactivacion, 	
				'Split_TipoOficina'			AS Split_TipoOficina, 
				A.TN_CodTipoOficina			AS Codigo,
				D.TC_Descripcion			AS Descripcion,
				D.TF_Inicio_Vigencia		AS FechaActivacion,
				D.TF_Fin_Vigencia			AS FechaDesactivacion
	FROM		Catalogo.MateriaFase		AS A WITH (Nolock) 
	INNER JOIN	Catalogo.Fase  				AS B WITH (Nolock)
	ON			B.TN_CodFase				= A.TN_CodFase 
	INNER JOIN	Catalogo.Materia			AS C WITH (Nolock)
	ON			C.TC_CodMateria				= A.TC_CodMateria
	INNER JOIN  Catalogo.TipoOficina		AS D WITH (Nolock) 
	ON			D.TN_CodTipoOficina			=A.TN_CodTipoOficina
	WHERE		A.TC_CodMateria				= COALESCE(@L_TC_CodMateria, A.TC_CodMateria)
	And			A.TN_CodFase				= COALESCE(@L_TN_CodFase, A.TN_CodFase)
	And			A.TN_CodTipoOficina			= COALESCE(@L_TN_CodTipoOficina, A.TN_CodTipoOficina)
	AND			A.TF_Inicio_Vigencia		<= COALESCE(@FechaAsociacion,A.TF_Inicio_Vigencia)
	AND			B.TF_Inicio_Vigencia		<= GETDATE()
	AND			(B.TF_Fin_Vigencia          Is Null    Or B.TF_Fin_Vigencia >= GETDATE ())  
	AND			A.TB_PorDefecto				= COALESCE(@L_TB_PorDefecto, A.TB_PorDefecto)
	ORDER BY	B.TC_Descripcion, C.TC_Descripcion;

End

GO
