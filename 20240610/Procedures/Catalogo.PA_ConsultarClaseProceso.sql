SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Johan Acosta Ibañez>
-- Fecha de creación:		<26/08/2015>
-- Descripción :			<Permite Consultar los Procedimientos que tiene una Clase de Asunto. 
-- =================================================================================================================================================
-- Modificación:            <3-9-2015> <Pablo Alvarez Espinoza> <Se modifica entidad intermedia por herencia>
-- Modificación:            <16-11-2015> <Johan Acosta> <Se modifica para que reciba los códigos de Clase de asunto y de Procedimiento>
-- Modificación:            <17-12-2015> <Alejandro Villalta> <Se modifica el tipo de dato de la clase de asunto, autogenerar codigo>
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:			<05/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN>
-- Modificación:			<09/10/2018> <Andrés Díaz> <Se resuelve error en la consulta.>
-- Modificación:			<06/02/2019> <Isaac Dobles> <Se cambia nombre por ConsultarClaseProceso y se ajusta a la nueva estructura.>
-- Modificación:			<Jonathan Aguilar Navarri> <06/04/2021> <Se agrega a la consutla la fecha TF_Inicio_Vigencia y TF_Fin_Vigencia del proceso>
--							<y la TF_Inicio_Vigencia de la tabla ClaseProceso>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarClaseProceso]
    @CodClase				int,
	@CodProceso				smallint,
	@FechaAsociacion		Datetime2= Null 
As
Begin 		

		SELECT		A.TN_CodClase						AS	Codigo, 
					C.TC_Descripcion					AS	Descripcion, 
					C.TF_Inicio_Vigencia				AS	FechaActivacion, 
					C.TF_Fin_Vigencia					AS	FechaDesactivacion,
					A.TF_Inicio_Vigencia				AS  FechaAsociacion,
					'Split'								AS	Split,
					B.TN_CodProceso						AS	Codigo, 
					B.TC_Descripcion					AS	Descripcion, 
					B.TF_Inicio_Vigencia				AS	FechaActivacion, 
					B.TF_Fin_Vigencia					AS	FechaDesactivacion

		FROM		Catalogo.ClaseProceso				AS	A WITH (Nolock) 
		INNER JOIN	Catalogo.Proceso					AS	B WITH (Nolock) 
		ON			B.TN_CodProceso						=	A.TN_CodProceso 
		INNER JOIN	Catalogo.Clase						AS	C WITH (Nolock) 
		ON			C.TN_CodClase						=	A.TN_CodClase

		WHERE		A.TN_CodClase						=	COALESCE(@CodClase, A.TN_CodClase)
		AND			A.TN_CodProceso						=	COALESCE(@CodProceso, A.TN_CodProceso)
		AND		    B.TF_Inicio_Vigencia				<=   GETDATE ()
		AND			(B.TF_Fin_Vigencia					is null or B.TF_Fin_Vigencia >= GETDATE())
		AND			A.TF_Inicio_Vigencia				<= COALESCE(@FechaAsociacion,A.TF_Inicio_Vigencia)

		ORDER BY	B.TC_Descripcion, C.TC_Descripcion;

	End
GO
