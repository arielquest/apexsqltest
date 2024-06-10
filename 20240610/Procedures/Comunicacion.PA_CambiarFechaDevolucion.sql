SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Elias Gonzalez Porras>
-- Fecha de creación:		<22/06/2023>
-- Descripción :			<Permite hacer cambio de la fecha de devolucion de un comunicado>
-- =================================================================================================================================================
CREATE   PROCEDURE [Comunicacion].[PA_CambiarFechaDevolucion]
	@CodComunicacion				uniqueidentifier,
	@FechaDevolucion				datetime2(7)

As
Begin
	--Variables
	DECLARE	@L_TU_CodComunicacion		UNIQUEIDENTIFIER		= @CodComunicacion,
			@L_TF_FechaDevolucion		datetime2(7)			= @FechaDevolucion

	Update	[Comunicacion].Comunicacion 
	Set	    [TF_FechaDevolucion]		= @L_TF_FechaDevolucion
	Where TU_CodComunicacion			= @L_TU_CodComunicacion;

End
GO
