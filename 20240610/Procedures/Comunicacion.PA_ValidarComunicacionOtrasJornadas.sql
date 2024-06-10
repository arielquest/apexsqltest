SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Jonathan Gómez G>
-- Fecha de creación:		<15/03/2017>
-- Descripción :			<Valida que la comunicacion no exista en otras jornadas activas>
-- =================================================================================================================================================
CREATE PROCEDURE [Comunicacion].[PA_ValidarComunicacionOtrasJornadas]
 @CodComunicacion uniqueidentifier
As
BEGIN

	select count(1) from Comunicacion.JornadaComunicacionDetalle DET
	join Comunicacion.JornadaComunicacion JOR on DET.TU_CodJornadaComunicacion = JOR.TU_CodJornadaComunicacion
	where JOR.TF_Cierre is not null and TU_CodComunicacion = @CodComunicacion

END
GO
