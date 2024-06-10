SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Roger Lara>
-- Fecha de creación:		<03/09/2015>
-- Descripción :			<Permite eliminar un tipo intervencion  de una materia> 
-- Modificado por:			<Sigifredo Leitón Luna.>
-- Fecha de creación:		<04/01/2016>
-- Descripción :			<Generar automaticamente el código de tipo de intervencion - item 5858>
-- Moficado:                <02-12-2016><Pablo Alvarez><Se modifica TN_CodTipoIntervencion por estandar>
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_EliminarMateriaTipoIntervencion]
   @CodMateria			varchar(5),
   @CodTipoIntervencion	smallint
AS 
BEGIN
	DELETE	Catalogo.MateriaTipoIntervencion
	WHERE	TC_CodMateria			= @CodMateria
	AND		TN_CodTipoIntervencion	= @CodTipoIntervencion
END
 

GO
