SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- =======================================================================================================================================
-- Autor:					<Aida E Siles>
-- Fecha Creación:			<07/03/2019>
-- Descripcion:				<Crear una nueva carpeta en la defensa pública>
-- =======================================================================================================================================
-- Modificación:		<08/07/2021> <Josué Quirós Batista> <Se agrega la consulta de las observaciones de la carpeta a la consulta.>
-- ==================================================================================================================================================================================
CREATE   PROCEDURE [DefensaPublica].[PA_AgregarCarpeta] 
	@NRD				varchar(14), 
	@NumeroExpediente	char(14), 
	@FechaCreacion		datetime2,
	@CodTipoCaso		smallint,
	@CodContexto		varchar(4),
	@Observaciones		varchar(255)	
AS
BEGIN
	INSERT INTO DefensaPublica.Carpeta
	(
		TC_NRD,			TC_NumeroExpediente,	TF_Creacion,		TN_CodTipoCaso,
		TC_CodContexto,	TF_Actualizacion,	    TC_Observaciones
	)
	VALUES
	(
		@NRD,			@NumeroExpediente,		@FechaCreacion,		@CodTipoCaso,	
		@CodContexto,	GETDATE(),				@Observaciones
	)
END

GO
