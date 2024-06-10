SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvarez>
-- Fecha de creación:		<30/10/2015>
-- Descripción :			<Permite Consultar las tareas de un perfil de puesto
-- Modificado por:			<Olger Ariel Gamboa Castillo>
-- Fecha de creación:		<12/11/2015>
-- Descripción :			<Se actualiza para que solo devueva intermedias>
-- Modificado:				<Pablo Alvarez Espinoza>
-- Fecha Modifica:			<17/12/2015>
-- Descripcion:				<Se cambia la llave a smallint squence>
--
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificado : Johan Acosta
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- Modificado : Pablo Alvarez
-- Fecha: 02/12/2016
-- Descripcion: Se cambio nombre de TC a TN 
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarPerfilPuestoTarea]
    @CodPerfilPuesto  Smallint=null,
	@FechaAsociacion  Datetime2= Null,
	@CodTarea			smallint
 As
 Begin 		
	--Registros activos
   If @FechaAsociacion  Is Null 
	Begin
	  
		SELECT		B.TN_CodTarea AS Codigo, 
					B.TC_Descripcion AS Descripcion, 
					B.TF_Inicio_Vigencia AS FechaActivacion, 
					B.TF_Fin_Vigencia AS FechaDesactivacion,
					A.TF_Inicio_Vigencia AS FechaAsociacion,
					A.TN_PlazoHoras as PlazoHoras,
					'Split' AS Split,
					C.TN_CodPerfilPuesto AS Codigo, 
					C.TC_Descripcion AS Descripcion, 
					C.TF_Inicio_vigencia AS FechaActivacion, 
					C.TF_Fin_Vigencia AS FechaDesactivacion
		FROM		Catalogo.PerfilPuestoTarea AS A WITH (Nolock) INNER JOIN
					Catalogo.Tarea AS B WITH (Nolock) ON B.TN_CodTarea = A.TN_CodTarea INNER JOIN
					Catalogo.PerfilPuesto AS C WITH (Nolock) ON C.TN_CodPerfilPuesto = A.TN_CodPerfilPuesto
		WHERE		(A.TN_CodPerfilPuesto = @CodPerfilPuesto or A.TN_CodTarea=@CodTarea)
		and			A.TF_Inicio_Vigencia    < GETDATE ()
		Order By	B.TC_Descripcion, C.TC_Descripcion;
	End
	Else
	-- todos registros 	
		SELECT		B.TN_CodTarea AS Codigo, 
					B.TC_Descripcion AS Descripcion, 
					B.TF_Inicio_Vigencia AS FechaActivacion, 
					B.TF_Fin_Vigencia AS FechaDesactivacion,
					A.TF_Inicio_Vigencia AS FechaAsociacion,
					A.TN_PlazoHoras as PlazoHoras,
					'Split' AS Split,
					C.TN_CodPerfilPuesto AS Codigo, 
					C.TC_Descripcion AS Descripcion, 
					C.TF_Inicio_vigencia AS FechaActivacion, 
					C.TF_Fin_Vigencia AS FechaDesactivacion
		FROM		Catalogo.PerfilPuestoTarea AS A WITH (Nolock) INNER JOIN
					Catalogo.Tarea AS B WITH (Nolock) ON B.TN_CodTarea = A.TN_CodTarea INNER JOIN
					Catalogo.PerfilPuesto AS C WITH (Nolock) ON C.TN_CodPerfilPuesto = A.TN_CodPerfilPuesto
		WHERE		(A.TN_CodPerfilPuesto = @CodPerfilPuesto or A.TN_CodTarea=@CodTarea)
		Order By	B.TC_Descripcion, C.TC_Descripcion;

 End


GO
