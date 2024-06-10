SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:		<Juan Ramirez>
-- Fecha Creación:	<17/08/2018>
-- Descripcion:		<Modificar una representación>
-- =============================================
CREATE PROCEDURE [Expediente].[PA_ModificarRepresentacion] 
		@CodigoInterviniente	uniqueidentifier,
		@CodigoRepresentante	uniqueidentifier,
		@Principal				bit=null,
		@NotificaRepresentante	bit=null, 
		@TipoRepresentacion		int=null,
		@FechaFinVigencia		DateTime2=null  
AS
BEGIN

	if (@NotificaRepresentante=1 or @Principal=1)
	begin
		Update	[Expediente].[Representacion]
		Set		TB_Principal					=	0,	
				TB_NotificaRepresentante		=	0				
		Where	TU_CodIntervinienteRepresentante=   @CodigoRepresentante
	end
			
	Update	[Expediente].[Representacion]
	Set		TB_Principal					=	ISNULL(@Principal,TB_Principal),	
			TB_NotificaRepresentante		=	ISNULL(@NotificaRepresentante,TB_NotificaRepresentante),
			TN_CodTipoRepresentacion		=	ISNULL(@TipoRepresentacion,TN_CodTipoRepresentacion),	
			TF_Fin_Vigencia					=	ISNULL(@FechaFinVigencia,TF_Fin_Vigencia)
	Where	TU_CodInterviniente				=	@CodigoInterviniente
	AND		TU_CodIntervinienteRepresentante=   @CodigoRepresentante
	
END


GO
