SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Xinia Soto Valerio>
-- Fecha de creación:		<30/04/2021>
-- Descripción :			<Registra el reparto en bitácora> 
-- =================================================================================================================================================

CREATE PROCEDURE [Catalogo].[PA_AgregarBitacoraReparto]
	@NumeroExpediente			varchar(14),      
	@CodLegajo					uniqueidentifier ,
	@CodContexto				varchar(4),    
	@CodOficina					varchar(4),
	@CodPuestoTrabajo			varchar(14),			
	@CodTipoPuestoTrabajo		smallint,
	@DatosCriterio				varchar(255),
	@Accion						varchar(150),
	@Motivo						varchar(255)
AS  
BEGIN  
	Declare 
			@L_NumeroExpediente			varchar(14)      = @NumeroExpediente,
			@L_CodLegajo				uniqueidentifier = @CodLegajo,
			@L_CodContexto				varchar(4)       = @CodContexto,
			@L_CodOficina				varchar(4)		 = @CodOficina,
			@L_CodPuestoTrabajo			varchar(14)      = @CodPuestoTrabajo,			
			@L_CodTipoPuestoTrabajo		smallint         = @CodTipoPuestoTrabajo,
			@L_DatosCriterio			varchar(255)     = @DatosCriterio,
			@L_Accion					varchar(150)     = @Accion,
			@L_Motivo					varchar(255)     = @Motivo
			

	Insert Into Catalogo.BitacoraReparto Values (
				NEWID(),	                 @L_CodOficina,			 @L_CodContexto,	@L_NumeroExpediente,	@L_CodLegajo,
				@L_CodTipoPuestoTrabajo,     @L_CodPuestoTrabajo,    GETDATE(),			@L_Accion,				@L_Motivo,
				@L_DatosCriterio,            GETDATE())
	
END
GO
