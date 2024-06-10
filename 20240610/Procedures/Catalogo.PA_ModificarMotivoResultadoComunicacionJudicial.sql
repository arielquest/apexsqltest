SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:		<Pablo Alvarez Espinoza>
-- Fecha Creación: <08/12/2016>
-- Descripcion:	<Modificar MotivoResultadoComunicacionJudicial.>
-- =================================================================================================================================================
-- Modificación:	<06/11/2018> <Andrés Díaz> <Se renombra 'TF_FinalizaVigencia' a 'TF_Fin_Vigencia'.>
-- =================================================================================================================================================
CREATE PROCEDURE [Catalogo].[PA_ModificarMotivoResultadoComunicacionJudicial] 
	@CodMotivoResultadoComunicacionJudicial smallint, 
	@Resultado char(1),
	@Descripcion varchar(255),
	@FinVigencia datetime2=null	
AS
BEGIN
	UPDATE	Catalogo.MotivoResultadoComunicacionJudicial
	Set		TC_Descripcion			= @Descripcion,
			TC_Resultado			= @Resultado,
			TF_Fin_Vigencia			= @FinVigencia
	where	TN_CodMotivoResultado	= @CodMotivoResultadoComunicacionJudicial;
END

GO
