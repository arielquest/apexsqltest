SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:			<Sigifredo Leitón Luna>
-- Fecha Creación:	<17/08/2015>
-- Descripcion:		<Crear un nuevo expediente.>
-- =================================================================================================================================================
-- Modificado:		<17/12/2015><Alejandro Villalta><Autogenerar el codigo de clase de asunto, de varchar a int>
-- Modificado:		<02/12/2016><Donald Vargas><Se corrige el nombre del campo TC_CodDelito y TC_CodClaseAsunto a TN_CodDelito y TN_CodClaseAsunto de acuerdo al tipo de dato>
-- Modificado:		<28/02/2019><Jonathan Aguilar Navarro><Sea agrgan los demas campos debido a la mejora de Creacion de Expedientes>
-- Modificación:	<08/02/2021> <Karol Jiménez S.> <Se agrega parámetro carpeta>
-- Modificación:	<03/06/2021> <Richard Zúñiga Segura> <Se agrega parámetro de @DescripcionHechos, @MontoAguinaldo y @MontoSalarioEscolar>
-- Modificación:	<12/10/2023> <Karol Jiménez Sánchez><Se agrega el campo TB_EmbargosFisicos. PBI 347798.>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarExpediente] 
	@NumeroExpediente		char(14), 
	@FechaInicio			datetime2,
	@CodDelito				int,
	@EsConfidencial			Bit,
	@CodContexto			varchar(4),
	@CodContextoCreacion	varchar(4),
	@Descripcion			varchar(255),
	@CasoRelevante			bit,
	@CodPrioridad			int,
	@CodTipoCuantia			int,
	@CodMoneda				int,
	@MontoCuantia			decimal,
	@CodTipoViavilidad		int,
	@FechaHechos			datetime2,
	@CodProvincia			int,
	@CodCanton				int,
	@CodDistrito			int,
	@CodBarrio				int,
	@OtrasSennas			varchar(500),
	@Carpeta				varchar(14),
	@DescripcionHechos		varchar(255)	= NULL,
	@MontoAguinaldo			decimal(18,2)	= NULL,
	@MontoSalarioEscolar	decimal(18,2)	= NULL,
	@EmbargosFisicos		BIT				= NULL
AS
BEGIN
	INSERT INTO Expediente.Expediente
	(
		TC_NumeroExpediente,	TF_Inicio,					TN_CodDelito,			TB_Confidencial,		
		TC_CodContexto,			TC_CodContextoCreacion,		TC_Descripcion,			TB_CasoRelevante,
		TN_CodPrioridad,		TN_CodTipoCuantia,			TN_CodMoneda,			TN_MontoCuantia,
		TN_CodTipoViabilidad,	TF_Hechos,					TF_Actualizacion,		TN_CodCanton,
		TN_CodDistrito,	 		TN_CodBarrio,				TN_CodProvincia,		TC_Señas,
		CARPETA,				TC_DescripcionHechos,		TN_MontoAguinaldo,		TN_MontoSalarioEscolar,
		TB_EmbargosFisicos
	)
	VALUES
	(
		@NumeroExpediente,		@FechaInicio,				@CodDelito,				@EsConfidencial,
		@CodContexto,			@CodContextoCreacion,		@Descripcion,			@CasoRelevante,
		@CodPrioridad,			@CodTipoCuantia,			@CodMoneda,				@MontoCuantia,
		@CodTipoViavilidad,		@FechaHechos,				GETDATE(),				@CodCanton,
		@CodDistrito,			@CodBarrio,					@CodProvincia,			@OtrasSennas,
		@Carpeta,				@DescripcionHechos,			@MontoAguinaldo,		@MontoSalarioEscolar,
		ISNULL(@EmbargosFisicos, 0)
	)
END
GO
