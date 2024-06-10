SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versi¢n:					<1.0>
-- Creado por:				<Jonathan Aguilar Navarro>
-- Fecha de creaci¢n:		<08/03/2019>
-- Descripci¢n :			<Permite agregar un registro al historico de ExpedienteMovimientoCirculante> 
-- =================================================================================================================================================
-- Modificaci¢n				<08/02/2021> <Isaac Dobles Mata> <Se agrega insert en columna IDFEP en caso que el valor venga (Itineraciones desde Gesti¢n)>
-- Modificaci¢n:			<04/05/2021> <Karol Jim‚nez S.> <Se cambia par metro CodEstado para que sea int y no smallint, por cambio en tabla Catalogo.Estado>
-- Modificaci¢n:			<18/08/2021> <Roger Lara> <Se cambia par metro Movimiento para que permita nulo>
-- Modificaci¢n:			<04/01/2022> <Luis Alonso Leiva Tames> <Se cambia el tipo de dato al parametro IDFEP (int --> bigint) >
-- =================================================================================================================================================

CREATE PROCEDURE [Historico].[PA_AgregarExpedienteMovimientoCirculante]
	@NumeroExpediente			varchar(14),
	@Fecha						datetime2(7),
	@CodContexto				varchar(4),
	@CodEstado					int,
	@Movimiento					char= null,
	@CodArchivo					uniqueidentifier,
	@CodPuestoTabajoFuncionario	uniqueidentifier,
	@Descripcion				varchar(255),
	@IDFEP						bigint		= null
AS  
BEGIN  
	DECLARE	
		@L_TC_NumeroExpediente			varchar(14)			=	@NumeroExpediente,
		@L_TF_Fecha						datetime2(7)		=	@Fecha,
		@L_TC_CodContexto				varchar(4)			=	@CodContexto,
		@L_TN_CodEstado					int					=	@CodEstado,
		@L_TC_Movimiento				char				=	@Movimiento,
		@L_TU_CodArchivo				uniqueidentifier	=	@CodArchivo,
		@L_TU_CodPuestoFuncionario		uniqueidentifier	=	@CodPuestoTabajoFuncionario,
		@L_TC_Descripcion				varchar(255)		=	@Descripcion,
		@L_IDFEP						bigint					=	@IDFEP

	INSERT INTO	Historico.ExpedienteMovimientoCirculante
	(
		TC_NumeroExpediente,
		TF_Fecha,
		TC_CodContexto,
		TN_CodEstado,
		TC_Movimiento,
		TU_CodArchivo,
		TU_CodPuestoFuncionario,
		TC_Descripcion,
		IDFEP
	)
	VALUES
	(
		@L_TC_NumeroExpediente,
		@L_TF_Fecha,
		@L_TC_CodContexto,
		@L_TN_CodEstado,
		@L_TC_Movimiento,
		@L_TU_CodArchivo,
		@L_TU_CodPuestoFuncionario,
		@L_TC_Descripcion,
		@L_IDFEP
	)
END
GO
