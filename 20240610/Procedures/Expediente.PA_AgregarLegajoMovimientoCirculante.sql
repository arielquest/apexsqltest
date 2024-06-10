SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- =================================================================================================================================================
-- Autor:				<Isaac Dobles Mata>
-- Fecha Creaci¢n:		<07/03/2019>
-- Descripcion:			<Agregar un movimiento de circulante para un legajo.>
-- =================================================================================================================================================
-- Modificaci¢n:	    <04/05/2021> <Karol Jim‚nez S.> <Se cambia par metro CodigoEstado para que sea int y no smallint, por cambio en tabla Catalogo.Estado>
-- Modificaci¢n:		<18/08/2021> <Roger Lara> <Se cambia par metro Movimiento para que permita nulo>
-- =================================================================================================================================================
CREATE PROCEDURE [Expediente].[PA_AgregarLegajoMovimientoCirculante] 
	@CodigoLegajo				uniqueidentifier,		
	@Fecha						datetime2(7),
	@Contexto					varchar(4),
	@CodigoEstado				int,
	@Movimiento					char(1)= null,
	@CodigoArchivo				uniqueidentifier,
	@Funcionario				uniqueidentifier,
	@Descripcion				varchar(255),
	@NumeroExpediente			char(14)	 
AS
BEGIN
	INSERT INTO Historico.LegajoMovimientoCirculante
	(
		TU_CodLegajo,
		TF_Fecha,
		TC_CodContexto,
		TN_CodEstado,
		TC_Movimiento,
		TU_CodArchivo,
		TU_CodPuestoFuncionario,
		TC_Descripcion,
		TC_NumeroExpediente
	)
	VALUES
	(
		@CodigoLegajo,  
		@Fecha, 
		@Contexto,
		@CodigoEstado,
		@Movimiento,
		@CodigoArchivo,
		@Funcionario,
		@Descripcion,
		@NumeroExpediente
	)
END
GO
