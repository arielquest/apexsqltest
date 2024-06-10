SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================================================================================================
-- Versión:					<1.0>
-- Creado por:				<Aida E Siles>
-- Fecha de creación:		<10/04/2019>
-- Descripción :			<Permite agregar un registro a la tabla RepresentacionMovimientoCirculante> 
-- =================================================================================================================================================

CREATE PROCEDURE [DefensaPublica].[PA_AgregarRepresentacionMovimientoCirculante]
	@CodMovimiento				uniqueidentifier,
	@CodRepresentacion			uniqueidentifier,
	@CodContexto				varchar(4),
	@CodPuestoFuncionario		uniqueidentifier,
	@CodEstadoRepresentacion	smallint,
	@Movimiento					char
As
Begin
	Insert Into DefensaPublica.RepresentacionMovimientoCirculante
	(
		TU_CodMovimiento,
		TF_Movimiento,
		TU_CodRepresentacion,
		TC_CodContexto,
		TU_CodPuestoFuncionario,
		TN_CodEstadoRepresentacion,
		TC_Movimiento
	)
	Values
	(
		@CodMovimiento,
		GETDATE(),
		@CodRepresentacion,
		@CodContexto,
		@CodPuestoFuncionario,
		@CodEstadoRepresentacion,
		@Movimiento
	)
End
GO
