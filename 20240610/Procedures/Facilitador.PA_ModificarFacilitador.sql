SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:			<1.0>
-- Creado por:		<Andrés Espinoza Rojas>
-- Fecha creación:	<28/02/2023>
-- Descripción:		<SP que	permite modificar un facilitador>
-- Modificado:      <00/00/0000>
-- =================================================================================================================================================

CREATE   PROCEDURE  [Facilitador].[PA_ModificarFacilitador]
	@CodEscolaridad SMALLINT,	
	@CodProfesion   SMALLINT,	
	@Email          VARCHAR(255) = null,	
	@Observaciones  VARCHAR(255) = null,
	@Activo         BIT,
	@CodPersona     UNIQUEIDENTIFIER
AS
BEGIN
	--Variables
	DECLARE	@L_TN_CodEscolaridad SMALLINT         = @CodEscolaridad,
			@L_TN_CodProfesion   SMALLINT		  = @CodProfesion,
			@L_TC_Email          VARCHAR(255)     = @Email,
			@L_TC_Observaciones  VARCHAR(255)     = @Observaciones,
			@L_TB_Activo         BIT              = @Activo,
			@L_TU_CodPersona     UNIQUEIDENTIFIER = @CodPersona

			UPDATE Facilitador.Facilitador WITH (ROWLOCK)
			SET TN_CodEscolaridad          = @L_TN_CodEscolaridad,
				TN_CodProfesion            = @L_TN_CodProfesion,
				TC_Email		           = @L_TC_Email,
				TC_Observaciones           = @L_TC_Observaciones,
				TB_Activo                  = @L_TB_Activo,
				TF_Actualizacion           = GETDATE()
			WHERE				           
				TU_CodPersona              = @L_TU_CodPersona
END
GO
