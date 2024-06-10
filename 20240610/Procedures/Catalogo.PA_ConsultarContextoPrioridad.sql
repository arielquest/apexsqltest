SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creación:		<18/04/2018>
-- Descripción :			<Permite Consultar las prioridades que tiene un contexto. 
-- Modificación:			<Tatiana Flores> <22/08/2018> <Se cambia nombre de la tabla Catalogo.Contexto a singular>

CREATE PROCEDURE [Catalogo].[PA_ConsultarContextoPrioridad]
    @CodContexto			Varchar(4)	= Null,
	@CodPrioridad		smallint	= Null,
	@FechaAsociacion	Datetime2	= Null
As
Begin

	SELECT		A.TF_Inicio_Vigencia			AS FechaAsociacion, 				
	   			B.TN_CodPrioridad				AS Codigo, 
				B.TC_Descripcion				AS Descripcion, 
				B.TF_Inicio_Vigencia			AS FechaActivacion, 
				B.TF_Fin_Vigencia				AS FechaDesactivacion,
				'Split'							AS Split, 
				C.TC_CodContexto				AS Codigo, 
				C.TC_Descripcion				AS Descripcion, 
				C.TF_Inicio_Vigencia			AS FechaActivacion, 
				C.TF_Fin_Vigencia				AS FechaDesactivacion
	FROM		Catalogo.ContextoPrioridad		AS A WITH (Nolock) 
	INNER JOIN	Catalogo.Prioridad				AS B WITH (Nolock)
	ON			B.TN_CodPrioridad				= A.TN_CodPrioridad 
	INNER JOIN	Catalogo.Contexto				AS C WITH (Nolock)
	ON			C.TC_CodContexto				= A.TC_CodContexto
	WHERE		(A.TC_CodContexto					= @CodContexto OR A.TN_CodPrioridad = @CodPrioridad) 
	AND			A.TF_Inicio_Vigencia			<= CASE WHEN @FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
	Order By	B.TC_Descripcion, C.TC_Descripcion;

End
GO
