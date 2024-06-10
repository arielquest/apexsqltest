SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Autor:			<Roger LAra>
-- Fecha Creación:	<25/09/2015>
-- Descripcion:		<Agregar una medida pena a un imputado>
-- =================================================================================================================================================
-- Modificado por:	<23/11/2015> <Henry Mendez> <Se agrega campo TC_CodSituacionLibertad y TF_SituacionLibertad.> 
-- Modificado por:	<04/01/2016> <Pablo Alvarez Espinoza> <Se cambia la llave situacionLibertad a smallint >
-- Modificado por:	<05/01/2015> <Alejandro Villalta> <Modificar el tipo de dato del codigo de tipo medida para autogenerar el valor.>
-- Modificado por:  <01/04/2016> <Gerardo Lopez> <Modificar porque se eliminaron campos numvoto y oficina>
-- Modificado por:  <05/12/2016> <Johan Acosta> <Se cambio nombre de TC a TN>
-- Modificado por:  <03/11/2022> <Jose Gabriel Cordero Soto> <Se modifica nombre de parametro de MedidaCautelar a Medida>
-- =================================================================================================================================================
CREATE   PROCEDURE [Expediente].[PA_AgregarIntervinienteMedidaPena] 
	@CodigoMedidaPEna uniqueidentifier, 
	@CodigoInterviniente uniqueidentifier,
	@CodigoResultadoResolucion uniqueidentifier,
	@CodigoDelito int,
	@CodigoTipoPena varchar(9)=null,
	@CodigoMedida smallint=null,
	@CodigoMedidaPenaImputado char(1),
	@FechaImposicion datetime2, 
	@FechaVencimiento datetime2,
	@FechaRevocatoria datetime2=null,
	@FechaRevision datetime2=null,
	@ControlFirma bit,
	@Observaciones varchar(256)=null,	 
	@CodigoSituacionLibertad smallint=null, 
	@FechaSituacionLibertad  DateTime2=null
      
AS
BEGIN
	INSERT INTO Expediente.MedidaPena
	(
	TU_CodMedidaPena,		TU_CodInterviniente,		TN_CodDelito,				TN_CodTipoPena,
	TN_CodTipoMedida,		TC_CodMedidaPena,			TF_FechaImposicion,			TU_CodResultadoResolucionInterviniente,		
	TF_Vencimiento,			TF_Revocatoria,				TF_Revision,				TB_ControlFirma,		
	TC_Observaciones,		TN_CodSituacionLibertad,	TF_SituacionLibertad
	)
	VALUES
	(
	@CodigoMedidaPEna,		@CodigoInterviniente,		@CodigoDelito,				@CodigoTipoPena,
	@CodigoMedida,			@CodigoMedidaPenaImputado,	@FechaImposicion,			@CodigoResultadoResolucion,	
	@FechaVencimiento,		@FechaRevocatoria,			@FechaRevision,				@ControlFirma,	
	@Observaciones,			@CodigoSituacionLibertad,	@FechaSituacionLibertad
	)
	
END

GO
