SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- ==========================================================================================
-- Autor:			<Roger Lara>
-- Fecha Creación:	<25/09/2015>
-- Descripcion:		<Modificar una medida pena de un intervininte-imputado>
-- =================================================================================================================================================
-- Modificado por:	<23/11/2015> <Henry Mendez> <Se agrega campo TC_CodSituacionLibertad y TF_SituacionLibertad.> 
-- Modificado por:	<04/01/2016> <Pablo Alvarez Espinoza> <Se cambia la llave situacionLibertad a smallint>
-- Modificado por:	<05/01/2015> <Alejandro Villalta> <Modificar el tipo de dato del codigo de tipo medida para autogenerar el valor.>
-- Modificado por:	<07/01/2016> <Sigifredo Leitón Luna> <Modificar para autogenerar el código del tipo de pena - item 5734>
-- Modificado por:  <01/04/2016> <Gerardo Lopez> <Modificar porque se eliminaron campos numvoto y oficina>
-- Modificado por:  <05/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN>
-- Modificado por:  <02/11/2022> <Jose Gabriel Cordero Soto> <Se modifica nombre de TipoMedidaCautelar a TipoMedida>
-- =================================================================================================================================================  
CREATE   PROCEDURE [Expediente].[PA_ModificarIntervinienteMedidaPena] 
		@CodigoMedidaPena			uniqueidentifier, 
		@CodigoInterviniente		uniqueidentifier,
		@CodigoDelito				int,
		@CodigoTipoPena				smallint			= null,
		@CodigoMedida				smallint			= null,
		@CodigoMedidaPenaImputado	char(1),
		@FechaImposicion			datetime2,
		@CodigoResultadoResolucion           uniqueidentifier,	
		@FechaVencimiento			datetime2,
		@FechaRevocatoria			datetime2			= null,
		@FechaRevision				datetime2			= null,
		@ControlFirma				bit,
		@Observaciones				varchar(256)		= null,	
		@CodigoSituacionLibertad	smallint			= null, 
		@FechaSituacionLibertad		DateTime2			= null
      
AS
BEGIN
	Update  Expediente.MedidaPena
	Set		TN_CodDelito			=	@CodigoDelito,
			TN_CodTipoPena			=	@CodigoTipoPena,
			TN_CodTipoMedida		=	@CodigoMedida,
			TC_CodMedidaPena		=	@CodigoMedidaPenaImputado,
			TF_FechaImposicion		=	@FechaImposicion,
			TU_CodResultadoResolucionInterviniente    	=	@CodigoResultadoResolucion,
			TF_Vencimiento			=	@FechaVencimiento,
			TF_Revocatoria			=	@FechaRevocatoria,
			TF_Revision				=	@FechaRevision,
			TB_ControlFirma			=	@ControlFirma,
			TC_Observaciones		=	@Observaciones,		 
			TN_CodSituacionLibertad	=	@CodigoSituacionLibertad,
			TF_SituacionLibertad	=	@FechaSituacionLibertad,	
			TF_Actualizacion		=	GETDATE()
	Where	TU_CodMedidaPena		=	@CodigoMedidaPEna
END

GO
