SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Gerardo Lopez R>
-- Fecha Creación:	<17/11/2015>
-- Descripcion:		<Asociar telefono   a un interviniente.>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_AgregarIntervinienteTelefono]   
    @Codigo         	uniqueidentifier,
	@CodInterviniente	uniqueidentifier,
    @CodTipoTelefono    smallint,
	@Numero            varchar(8),
	@CodArea		    varchar(3),
	@Extension          varchar(3)
AS
BEGIN
	INSERT INTO Expediente.IntervinienteTelefono
	(
	 TU_CodTelefono,	TU_CodInterviniente, TN_CodTipoTelefono,  TC_Numero, TC_CodArea, TC_Extension, TF_Actualizacion
	) 
	VALUES
	(
		@Codigo,	@CodInterviniente, @CodTipoTelefono, @Numero , @CodArea , @Extension , getdate()
	)
END
GO
