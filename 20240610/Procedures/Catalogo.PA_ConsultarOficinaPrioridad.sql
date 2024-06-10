SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<26/08/2015>
-- Descripción :			<Permite Consultar las prioridades que tiene una oficina. 
-- Modificado por           <Pablo Alvarez Espinoza>
-- Fecha de modificacion    <3-9-2015>
-- Descripción              <Se modifica entidad intermedia por herencia>
-- Modificado:              <Pablo Alvarez Espinoza>
-- Fecha Modifica:		    <07/01/2015>
-- Descripcion:			    <Se cambia la llave a smallint>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<21/12/2016> <Pablo Alvarez> <Se corrige TN_CodPrioridad por estandar.>
--
-- Modificación:			<04/01/2018> <Andrés Díaz> <Se simplifica el PA a una sola consulta. Se tabula el PA.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarOficinaPrioridad]
    @CodOficina			Varchar(4)	= Null,
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
				C.TC_CodOficina					AS Codigo, 
				C.TC_Nombre						AS Descripcion, 
				C.TF_Inicio_Vigencia			AS FechaActivacion, 
				C.TF_Fin_Vigencia				AS FechaDesactivacion
	FROM		Catalogo.OficinaPrioridad		AS A WITH (Nolock) 
	INNER JOIN	Catalogo.Prioridad				AS B WITH (Nolock)
	ON			B.TN_CodPrioridad				= A.TN_CodPrioridad 
	INNER JOIN	Catalogo.Oficina				AS C WITH (Nolock)
	ON			C.TC_CodOficina					= A.TC_CodOficina
	WHERE		(A.TC_CodOficina				= @CodOficina OR A.TN_CodPrioridad = @CodPrioridad) 
	AND			A.TF_Inicio_Vigencia			<= CASE WHEN @FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
	Order By	B.TC_Descripcion, C.TC_Nombre;

End
GO
