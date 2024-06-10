SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ==============================================================================================================================
-- Autor:			<Gerardo Lopez R>
-- Fecha Creación:	<17/11/2015>
-- Descripcion:		<Asociar telefono   a un interviniente.>
-- Modificación:	<21/09/2018> <Juan Ramírez V> <Se agrega el campo SMS y se modifica la estructura a Persona.Telefono>
-- Modificación:	<22/12/2020> <Aida Elena Siles R> <Se amplia el tamaño del parámetro @Numero a 15. PBI 158522>
-- ==============================================================================================================================
CREATE PROCEDURE [Persona].[PA_AgregarPersonaTelefono]   
    @Codigo         	UNIQUEIDENTIFIER,
	@CodPersona			UNIQUEIDENTIFIER,
    @CodTipoTelefono    SMALLINT,
	@Numero				VARCHAR(15),
	@CodArea		    VARCHAR(5),
	@Extension          VARCHAR(3),
	@SMS				BIT
AS
BEGIN
--VARIABLES
DECLARE @L_Codigo         	UNIQUEIDENTIFIER	=@Codigo,
		@L_CodPersona		UNIQUEIDENTIFIER	=@CodPersona,
		@L_CodTipoTelefono  SMALLINT			=@CodTipoTelefono,
		@L_Numero			VARCHAR(15)			=@Numero,
		@L_CodArea		    VARCHAR(5)			=@CodArea,
		@L_Extension        VARCHAR(3)			=@Extension,
		@L_SMS				BIT					=@SMS

--LÓGICA
	INSERT INTO Persona.Telefono WITH (ROWLOCK)
	(
		TU_CodTelefono,		TU_CodPersona,		TN_CodTipoTelefono,		TC_Numero, 
		TC_CodArea,			TC_Extension,		TF_Actualizacion,		TB_SMS
	) 
	VALUES
	(
		@L_Codigo,			@L_CodPersona,		@L_CodTipoTelefono,		@L_Numero, 
		@L_CodArea,			@L_Extension,		GETDATE(),				@L_SMS
	)
END

GO
