SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Gerardo Lopez R>
-- Fecha Creación:	<17/11/2015>
-- Descripcion:		<Modfificar telefono   a un interviniente.>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_ModificarIntervinienteTelefono]   
    @Codigo         	uniqueidentifier,
	@CodInterviniente	uniqueidentifier,
    @CodTipoTelefono	smallint,
	@Numero            varchar(8),
	@CodArea		    varchar(3),
	@Extension          varchar(3)
AS
BEGIN
	 Update Expediente.IntervinienteTelefono
	  set    TN_CodTipoTelefono =@CodTipoTelefono, 
	         TC_Numero= @Numero, 
			 TC_CodArea =@CodArea, 
			 TC_Extension =@Extension, 
			 TF_Actualizacion =getdate()
	Where  TU_CodTelefono = @Codigo and TU_CodInterviniente =@CodInterviniente
	
 
END
GO
