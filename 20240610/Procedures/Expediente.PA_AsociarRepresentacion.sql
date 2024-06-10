SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================================================================================================
-- Autor:		<Juan Ramirez>
-- Fecha Creación:	<26/07/2018>
-- Descripcion:		<Asociar un representante a una intervención tipo parte>
-- ======================================================================================================================================
-- Modificación:	<10/07/2020>	<Daniel Ruiz H.>		<Se eliminan los representantes principales si el nuevo agregado es seleccionado como principal>
-- ======================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AsociarRepresentacion] 
		@CodigoInterviniente	uniqueidentifier,
		@CodigoRepresentante	uniqueidentifier,
		@Principal				bit=null,
		@NotificaRepresentante	bit=null, 
		@TipoRepresentacion		smallint=null, 
		@FechaInicioVigencia	DateTime2,
		@FechaFinVigencia		DateTime2  
AS
BEGIN
	IF (@NotificaRepresentante=1 or @Principal=1)
		BEGIN
			UPDATE	[Expediente].[Representacion]
			SET		TB_Principal					=	0,	
					TB_NotificaRepresentante		=	0				
			WHERE	TU_CodIntervinienteRepresentante=   @CodigoRepresentante
		END
	INSERT INTO [Expediente].[Representacion]
			   ([TU_CodInterviniente]
			   ,[TU_CodIntervinienteRepresentante]
			   ,[TB_Principal]
			   ,[TB_NotificaRepresentante]
			   ,[TN_CodTipoRepresentacion]
			   ,[TF_Inicio_Vigencia]
			   ,[TF_Fin_Vigencia])
     VALUES
            (
			   @CodigoInterviniente,
			   @CodigoRepresentante,
			   @Principal,
			   @NotificaRepresentante,
			   @TipoRepresentacion,
			   @FechaInicioVigencia,
			   @FechaFinVigencia
			)
	
END


GO
