SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Versión:					<1.1>
-- Creado por:				<Johan Manuel Acosta Ibañez>
-- Fecha de creación:		<18/01/2019>
-- Descripción :			<Permite agregar cálculo de horas extra> 
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarCalculoHorasExtra]
	@Codigo						uniqueidentifier,	
	@Descripcion				varchar(50),
	@NumeroExpediente			char(14),
	@CodMoneda					smallint,
	@CodContexto				varchar(4),
	@FechaCalculo				datetime2,
	@FechaInicio				datetime2,
	@FechaFinal					datetime2,
	@UsuarioRed					varchar(30),
	@CantidadDiasFeriados		smallint,
	@CantidadDiasIncapacidad	smallint,
	@CantidadDiasNoLaborado		smallint,
	@CantidadDiasVacaciones		smallint,
	@CantidadHorasExtra			smallint,
	@CantidadHorasLaboradas		smallint,
	@FormaPago					tinyint,
	@CodInterviniente			uniqueidentifier,
	@MontoSalarioMensual		decimal(18,2),
	@MontoTotalHorasExtra		decimal(18,2),	
	@MontoUnitarioHoraExtra		decimal(18,2),
	@CalculoHorasExtraEliminado	bit
As
Begin
	
		Insert Into Expediente.CalculoHorasExtra(	TU_CodigoCalculoHorasExtra,	TC_Descripcion,	TC_NumeroExpediente,	TN_CodMoneda,				TC_CodContexto,	
													TF_FechaCalculo,			TF_FechaInicio,	TF_FechaFinal,			TC_UsuarioRed,				TN_CantidadDiasFeriados,	
													TN_CantidadDiasIncapacidad,	TN_CantidadDiasNoLaborado,				TN_CantidadDiasVacaciones,	TN_CantidadHorasExtra,
													TN_CantidadHorasLaboradas,	TN_FormaPago,							TU_CodInterviniente,		TN_MontoSalarioMensual,
													TN_MontoTotalHorasExtra,	TN_MontoUnitarioHoraExtra,				TB_CalculoHorasExtraEliminado)
		Values									(	@Codigo,					@Descripcion,	@NumeroExpediente,		@CodMoneda,					@CodContexto,	
													@FechaCalculo,				@FechaInicio,	@FechaFinal,			@UsuarioRed,				@CantidadDiasFeriados,	
													@CantidadDiasIncapacidad,	@CantidadDiasNoLaborado,				@CantidadDiasVacaciones,	@CantidadHorasExtra,
													@CantidadHorasLaboradas,	@FormaPago,								@CodInterviniente,			@MontoSalarioMensual,
													@MontoTotalHorasExtra,		@MontoUnitarioHoraExtra,				@CalculoHorasExtraEliminado)

End
GO
