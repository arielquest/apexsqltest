SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Gerardo Lopez>
-- Fecha de creación:		<23/10/2015>
-- Descripción :			<Permite Agregar un expediente preasignado  > 
-- =================================================================================================================================================
-- Modificado por:			<Johan Manuel Acosta Ibañez> <Se actualizaron los campos de Oficinafuncionario y código preasignado.>
-- Modificado por:			<Johan Manuel Acosta Ibañez> <Se cambian los campos de Oficinafuncionario por código de puesto.>
-- Modificado por:			<Luis Alonso Leiva Tames><12/04/2022><Se agrega el codigo del contexto, contexto origen donde es creado>
-- Modificado por:			<Isaac Dobles Mata> <31/08/2022> <Se agrega código de contexto y si proviene de un sistema externo al ingresar pre asignado>
-- =================================================================================================================================================

CREATE   PROCEDURE [Expediente].[PA_AgregarExpedientePreasignado]
   @CodPreasignado			uniqueidentifier,
   @NumeroExpediente		varchar(14),
   @CodPuestoTrabajo		varchar(14),
   @Estado					varchar(1),
   @FechaTramite			datetime2(7),
   @CodContexto				varchar(4)				= Null,
   @SistemaExterno			bit						= 0
AS 
	DECLARE
	@L_CodPreasignado			uniqueidentifier	= @CodPreasignado,
	@L_NumeroExpediente			varchar(14)			= @NumeroExpediente,
	@L_CodPuestoTrabajo			varchar(14)			= @CodPuestoTrabajo,
	@L_Estado					varchar(1)			= @Estado,
	@L_FechaTramite				datetime2(7)		= @FechaTramite,
	@L_CodContexto				varchar(4)			= @CodContexto,
	@L_SistemaExterno			bit					= @SistemaExterno

    BEGIN
		INSERT INTO Expediente.ExpedientePreasignado
		(
			TU_CodPreasignado,	
			TC_NumeroExpediente, 
			TC_CodPuestoTrabajo,	
			TC_Estado,	
			TF_Tramite, 
			TC_CodContexto,
			TB_SistemaExterno
		)
		VALUES 
		(
			@L_CodPreasignado,	
			@L_NumeroExpediente, 	 
			@L_CodPuestoTrabajo,	
			@L_Estado,	
			@L_FechaTramite, 
			@L_CodContexto,
			@L_SistemaExterno
		)   
    END
GO
