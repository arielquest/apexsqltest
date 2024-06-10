SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Pablo Alvare Espinoza>
-- Fecha de creación:		<4/09/2015>
-- Descripción :			<Permite Consultar las TipoIntervencion de una Materia
-- =================================================================================================================================================
-- Modificación:			<12/11/2015> <Sigifredo Leitón Luna> <Se realiza modificación para reliazar el mantenimiento de tipo de asociaciones
-- Modificación:			<04/01/2016> <Sigifredo Leitón Luna.> <Generar automaticamente el código de tipo de intervencion - item 5858>
-- Modificación:			<08/07/2016> <Andrés Díaz> <Se modifican las consultas para que devuelvan los valores ordenados por descripción.>
-- Modificación:            <02-12-2016> <Pablo Alvarez> <Se modifica TN_CodTipoIntervencion por estandar>
-- Modificación:            <09-10-2017> <Ailyn López> <Se agrega columna PuedeSolicitarDefensor a la consulta>
-- Modificación:			<04/01/2018> <Andrés Díaz> <Se simplifica el PA a una sola consulta. Se tabula el PA.>
-- Modificación:            <09/07/2018> <Juan Ramirez> <Se agrega columna VinculoAgresor a la consulta>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ConsultarMateriaTipoIntervencion]
    @CodMateria				Varchar(5)	= Null,
	@CodTipoIntervencion	smallint	= Null,
	@FechaAsociacion		Datetime2	= Null
 As
 Begin 		

	     SELECT			A.TB_PuedeSolicitarDefensor			AS PuedeSolicitarDefensor,
						B.TN_CodTipoIntervencion			AS Codigo, 
						B.TC_Descripcion					AS Descripcion, 
						B.TF_Inicio_Vigencia				AS FechaActivacion, 
						B.TF_Fin_Vigencia					AS FechaDesactivacion,
						A.TF_Inicio_Vigencia				AS FechaAsociacion,
						A.TB_VinculoAgresor					AS VinculoAgresor,
						'Split'								AS Split,
						C.TC_CodMateria						AS Codigo, 
						C.TC_Descripcion					AS Descripcion, 
						C.TF_Inicio_Vigencia				AS FechaActivacion, 
						C.TF_Fin_Vigencia					AS FechaDesactivacion				
		  FROM			Catalogo.MateriaTipoIntervencion	AS A WITH (Nolock)
		  INNER JOIN	Catalogo.TipoIntervencion			AS B WITH (Nolock)
		  ON			B.TN_CodTipoIntervencion			= A.TN_CodTipoIntervencion
		  INNER JOIN	Catalogo.Materia					AS C WITH (Nolock)
		  ON			C.TC_CodMateria						= A.TC_CodMateria
		  WHERE			(A.TC_CodMateria					= @CodMateria
		  OR			A.TN_CodTipoIntervencion			= @CodTipoIntervencion)
		  AND			A.TF_Inicio_Vigencia				<= CASE WHEN @FechaAsociacion IS NULL THEN GETDATE() ELSE A.TF_Inicio_Vigencia END
		  ORDER BY		B.TC_Descripcion, C.TC_Descripcion;

 End
GO
