SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
--===========================================================================================
-- Versión:					<1.0>
-- Creado por:				<Olger Gamboa Castillo>
-- Fecha de creación:		<13/10/2017>
-- Descripción:				<Actualiza el estado de la comunición> 
-- ===========================================================================================
CREATE PROCEDURE [Biztalk].[PA_ActualizaEstadoComunicacion]
(
	@CodigoComunicacion uniqueidentifier,
	@Estado char(1)
)
AS
BEGIN
SET NOCOUNT ON;

	DECLARE @TempCodigoComunicacion UNIQUEIDENTIFIER
	DECLARE @TempEstado             CHAR(1)

	SELECT @TempCodigoComunicacion = @CodigoComunicacion
	SELECT @TempEstado             = @Estado 
	
	UPDATE	Comunicacion.Comunicacion
	SET		TC_Estado				=  @TempEstado	
	WHERE	TU_CodComunicacion      =  @TempCodigoComunicacion

END
GO
