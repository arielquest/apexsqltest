SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Olger Gamboa Castillo
-- Create date: 31/08/2020
-- Description:	Procedimiento para agregar una solicitud de carga de expediente de un usuario
-- =============================================
CREATE PROCEDURE [Expediente].[PA_AgregarCargaExpedienteInactivo]
	@ValidarSREM bit,
	@ValidarDocumento bit,
	@ValidarEscrito bit,
	@FechaCorte Datetime2(3),
	@CodContexto varchar(4),
	@UsuarioRed varchar(30),
	@Estado char(1)
AS
BEGIN
DECLARE @TB_ValidarSREM BIT			=	@ValidarSREM, 
		@TB_ValidarDocumento bit	=	@ValidarDocumento,
		@TB_ValidarEscrito bit		=	@ValidarEscrito,
		@TF_Corte Datetime2(3)		=	@FechaCorte,
		@TC_CodContexto  varchar(4)	=	@CodContexto,
		@TC_UsuarioRed varchar(30)	=	@UsuarioRed,
		@TC_Estado char(1)			=	@Estado
INSERT INTO Expediente.SolicitudCargaInactivo
(	TB_ValidarSREM,	
	TB_ValidarDocumento,	
	TB_ValidarEscrito,	
	TF_Corte,	
	TC_CodContexto,
	TC_UsuarioRed,
	TC_Estado
)
VALUES	
(	@TB_ValidarSREM,	
	@TB_ValidarDocumento,
	@TB_ValidarEscrito, 
	@TF_Corte, 
	@TC_CodContexto,
	@TC_UsuarioRed,
	@TC_Estado	
)
END	
GO
