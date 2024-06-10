SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Autor:		Ronny Ramírez
-- Fecha Creación: 03/06/2019
-- Descripcion:	Crear un nuevo registro en el hitorico para un Pago de Deuda
-- =================================================================================================================================================
CREATE PROCEDURE [Historico].[PA_AgregarPagoDeuda] 
	@CodigoPagoDeuda			uniqueidentifier, 
	@CodigoDeuda				uniqueidentifier, 
	@FechaDeposito				datetime2,
	@FechaPago					datetime2,
	@MontoAbonoCapital			decimal(18,2),
	@MontoDeposito				decimal(18,2),
	@MontoPagoCostasPersonales	decimal(18,2),
	@MontoPagoCostasProcesales	decimal(18,2),
	@MontoPagoInteres			decimal(18,2),
	@NumeroDeposito				varchar(50),
	@UsuarioRed					varchar(30),
	@FechaRegistroPago			datetime2,
	@CodMoneda					smallint
AS
BEGIN
	INSERT INTO Historico.PagoDeuda
    (
			TU_CodigoPagoDeuda,		TU_CodigoDeuda,		TF_FechaDeposito,				TF_FechaPago,
			TN_MontoAbonoCapital,	TN_MontoDeposito,	TN_MontoPagoCostasPersonales,	TN_MontoPagoCostasProcesales,
			TN_MontoPagoInteres,	TN_NumeroDeposito,	TC_UsuarioRed,	TF_FechaRegistroPago, TN_CodMoneda
	)
     VALUES
    (
			@CodigoPagoDeuda,	@CodigoDeuda,		@FechaDeposito,				@FechaPago,
			@MontoAbonoCapital,	@MontoDeposito,		@MontoPagoCostasPersonales,	@MontoPagoCostasProcesales,
			@MontoPagoInteres,	@NumeroDeposito,	@UsuarioRed,				@FechaRegistroPago,
			@CodMoneda
	)
END

GO
